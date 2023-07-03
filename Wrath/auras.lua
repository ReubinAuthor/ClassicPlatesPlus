----------------------------------------
-- CORE
----------------------------------------
local myAddon, core = ...;
local func = core.func;
local data = core.data;

----------------------------------------
-- Auras
----------------------------------------
function func:Update_Auras(unit)
    if unit and string.match(unit, "nameplate") then
        local nameplate = C_NamePlate.GetNamePlateForUnit(unit);
        local scaleOffset = 0.15; -- Aura size offset

        local function formatTime(seconds)
            local timeString = "";
            local timeValues = {
                {86400, "d"},
                {3600, "h"},
                {60, "m"},
                {1, "s"}
            };

            if seconds > 0 then
                seconds = math.floor(seconds + 0.9999);

                for i = 1, #timeValues do
                    local value = math.floor(seconds / timeValues[i][1]);
                    seconds = seconds % timeValues[i][1];

                    if value > 0 then
                        timeString = value .. timeValues[i][2];
                        break; -- Break the loop after the first non-zero value
                    end
                end
            else
                timeString = "";
            end

            return timeString;
        end

        if nameplate then
            local unitFrame = nameplate.unitFrame;
            local canAssist = UnitCanAssist("player", unit);
            local hidePassiveAuras = Config.HidePassiveAuras;
            local AurasShow = Config.AurasShow;
            local buffOnFriendly = Config.BuffsFriendly and canAssist;
            local debuffOnFriendly = Config.DebuffsFriendly and canAssist;
            local buffOnEnemy = Config.BuffsEnemy and not canAssist;
            local debuffOnEnemy = Config.DebuffsEnemy and not canAssist;

            unitFrame.toSort = {
                important_buffs = {},
                buffs = {},
                important_debuffs = {},
                debuffs = {}
            };

            unitFrame.sorted = {
                buffs = {},
                debuffs = {}
            };

            unitFrame.raid = {};

            local function createFrames(filter, auraType, showType, r,g,b)
                if showType then
                    for i = 1, 40 do
                        local name, icon, stacks, _, duration, expirationTime, source, _,_, spellId, canApplyAura, _,_,_, timeMod = UnitAura(unit, i, filter);

                        if name then
                            local hidePassive = not (hidePassiveAuras and duration == 0);
                            local show = (AurasShow == 1 and (source == "player" or source == "vehicle")) or AurasShow == 2;

                            if (hidePassive and show or data.AurasImportantList[name]) and not data.AurasBlacklist[name] then
                                if not unitFrame[auraType][i] then
                                    ------------------------------------
                                    -- Main
                                    ------------------------------------
                                    unitFrame[auraType][i] = CreateFrame("frame", nil, unitFrame);
                                    unitFrame[auraType][i]:SetSize(28, 24);
                                    unitFrame[auraType][i]:SetFrameLevel(1);
                                    unitFrame[auraType][i]:SetScale(Config.AurasScale - scaleOffset);

                                    ------------------------------------
                                    -- Firse level
                                    ------------------------------------
                                    unitFrame[auraType][i].first = CreateFrame("frame", nil, unitFrame[auraType][i]);
                                    unitFrame[auraType][i].first:SetPoint("center", unitFrame[auraType][i], "center");
                                    unitFrame[auraType][i].first:SetAllPoints();
                                    unitFrame[auraType][i].first:SetFrameLevel(1);

                                    -- Highlight 
                                    unitFrame[auraType][i].highlight = unitFrame[auraType][i].first:CreateTexture();
                                    unitFrame[auraType][i].highlight:SetPoint("Center", unitFrame[auraType][i].first);
                                    unitFrame[auraType][i].highlight:SetSize(64,64);
                                    unitFrame[auraType][i].highlight:SetTexture("Interface\\addons\\ClassicPlatesPlus\\media\\auras\\importantHighlight");
                                    unitFrame[auraType][i].highlight:SetVertexColor(1,0,0,1);

                                    -- Highlight animation group
                                    unitFrame[auraType][i].highlight.animationGrp = unitFrame[auraType][i].highlight:CreateAnimationGroup();
                                    unitFrame[auraType][i].highlight.animationGrp:SetLooping("repeat");

                                    -- Highlight animation alpha
                                    local animation_alphaFrom = unitFrame[auraType][i].highlight.animationGrp:CreateAnimation("Alpha");
                                    animation_alphaFrom:SetDuration(0.33);
                                    animation_alphaFrom:SetFromAlpha(0);
                                    animation_alphaFrom:SetToAlpha(1);
                                    animation_alphaFrom:SetOrder(1);
                                    local animation_alphaTo = unitFrame[auraType][i].highlight.animationGrp:CreateAnimation("Alpha");
                                    animation_alphaTo:SetDuration(0.33);
                                    animation_alphaTo:SetFromAlpha(1);
                                    animation_alphaTo:SetToAlpha(0);
                                    animation_alphaTo:SetOrder(2);

                                    -- Mask
                                    unitFrame[auraType][i].mask = unitFrame[auraType][i].first:CreateMaskTexture();
                                    unitFrame[auraType][i].mask:SetPoint("center", unitFrame[auraType][i].first, "center");
                                    unitFrame[auraType][i].mask:SetSize(64, 32);
                                    unitFrame[auraType][i].mask:SetTexture("Interface\\addons\\ClassicPlatesPlus\\media\\auras\\mask", "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE");

                                    -- Icon
                                    unitFrame[auraType][i].icon = unitFrame[auraType][i].first:CreateTexture();
                                    unitFrame[auraType][i].icon:SetPoint("center", unitFrame[auraType][i].first, "center");
                                    unitFrame[auraType][i].icon:SetSize(28, 28);
                                    unitFrame[auraType][i].icon:SetTexture(icon);
                                    unitFrame[auraType][i].icon:AddMaskTexture(unitFrame[auraType][i].mask);
                                    unitFrame[auraType][i].icon:SetDrawLayer("background", 1);

                                    -- Cooldown
                                    unitFrame[auraType][i].cooldown = CreateFrame("Cooldown", nil, unitFrame[auraType][i].first, "CooldownFrameTemplate");
                                    unitFrame[auraType][i].cooldown:SetAllPoints();
                                    unitFrame[auraType][i].cooldown:SetCooldown(GetTime() - (duration - (expirationTime - GetTime())), duration, timeMod);
                                    unitFrame[auraType][i].cooldown:SetDrawEdge(true);
                                    unitFrame[auraType][i].cooldown:SetDrawBling(false);
                                    unitFrame[auraType][i].cooldown:SetSwipeColor(0, 0, 0, 0.6);
                                    unitFrame[auraType][i].cooldown:SetHideCountdownNumbers(true);
                                    unitFrame[auraType][i].cooldown:SetReverse(Config.AurasReverseAnimation);
                                    unitFrame[auraType][i].cooldown:SetFrameLevel(1);

                                    ------------------------------------
                                    -- Second level
                                    ------------------------------------
                                    unitFrame[auraType][i].second = CreateFrame("frame", nil, unitFrame[auraType][i]);
                                    unitFrame[auraType][i].second:SetAllPoints();
                                    unitFrame[auraType][i].second:SetFrameLevel(2);

                                    -- Border
                                    unitFrame[auraType][i].border = unitFrame[auraType][i].second:CreateTexture();
                                    unitFrame[auraType][i].border:SetPoint("center", unitFrame[auraType][i].second, "center");
                                    unitFrame[auraType][i].border:SetDrawLayer("border", 1);

                                    -- Countdown
                                    unitFrame[auraType][i].countdown = unitFrame[auraType][i].second:CreateFontString(nil, nil, "GameFontNormalOutline");
                                    unitFrame[auraType][i].countdown:SetPoint("center", unitFrame[auraType][i].second, "center");
                                    unitFrame[auraType][i].countdown:SetScale(0.8);
                                    unitFrame[auraType][i].countdown:SetShadowColor(0, 0, 0);
                                    unitFrame[auraType][i].countdown:SetShadowOffset(1, -1);
                                    unitFrame[auraType][i].countdown:SetTextColor(1, 0.82, 0);
                                    unitFrame[auraType][i].countdown:SetText(formatTime(expirationTime - GetTime()));
                                    unitFrame[auraType][i].countdown:SetShown(Config.AurasCountdown);

                                    -- Stacks
                                    unitFrame[auraType][i].stacks = unitFrame[auraType][i].second:CreateFontString(nil, nil, "GameFontNormalSmall");
                                    unitFrame[auraType][i].stacks:SetPoint("right", unitFrame[auraType][i].second, "bottomRight", 5, 2.5);
                                    unitFrame[auraType][i].stacks:SetScale(0.9);
                                    unitFrame[auraType][i].stacks:SetText("x" .. stacks);
                                    unitFrame[auraType][i].stacks:SetDrawLayer("overlay", 3);
                                    unitFrame[auraType][i].stacks:SetShown(stacks > 0);
                                else
                                    -- Main
                                    unitFrame[auraType][i]:SetScale(Config.AurasScale - scaleOffset);

                                    -- Icon
                                    unitFrame[auraType][i].icon:SetTexture(icon);

                                    -- Cooldown
                                    unitFrame[auraType][i].cooldown:SetCooldown(GetTime() - (duration - (expirationTime - GetTime())), duration, timeMod);
                                    unitFrame[auraType][i].cooldown:SetReverse(Config.AurasReverseAnimation);

                                    -- Countdown
                                    unitFrame[auraType][i].countdown:SetText(formatTime(expirationTime - GetTime()));
                                    unitFrame[auraType][i].countdown:SetShown(Config.AurasCountdown);

                                    -- Stacks
                                    unitFrame[auraType][i].stacks:SetText("x" .. stacks);
                                    unitFrame[auraType][i].stacks:SetShown(stacks > 0);
                                end

                                -- Addigng name for future cross-check
                                unitFrame[auraType][i].name = name;
                                unitFrame[auraType][i].type = auraType;

                                -- Dividing important and normal aurs
                                if data.AurasImportantList[name] then
                                    table.insert(unitFrame.toSort["important_" .. auraType], unitFrame[auraType][i]);
                                else
                                    table.insert(unitFrame.toSort[auraType], unitFrame[auraType][i]);
                                end

                                ------------------------------------
                                -- Adjustments
                                ------------------------------------

                                -- Border texture
                                if data.AurasImportantList[name] then
                                    unitFrame[auraType][i].border:SetSize(64,64);
                                    if stacks > 0 then
                                        unitFrame[auraType][i].border:SetTexture("Interface\\addons\\ClassicPlatesPlus\\media\\auras\\importantBorderStacks");
                                        unitFrame[auraType][i].highlight:SetTexture("Interface\\addons\\ClassicPlatesPlus\\media\\auras\\importantHighlightStacks");
                                    else
                                        unitFrame[auraType][i].border:SetTexture("Interface\\addons\\ClassicPlatesPlus\\media\\auras\\importantBorder");
                                        unitFrame[auraType][i].highlight:SetTexture("Interface\\addons\\ClassicPlatesPlus\\media\\auras\\importantHighlight");
                                    end
                                else
                                    unitFrame[auraType][i].border:SetSize(64,32);
                                    if stacks > 0 then
                                        unitFrame[auraType][i].border:SetTexture("Interface\\addons\\ClassicPlatesPlus\\media\\auras\\borderStacks");
                                    else
                                        unitFrame[auraType][i].border:SetTexture("Interface\\addons\\ClassicPlatesPlus\\media\\auras\\border");
                                    end
                                end
                                unitFrame[auraType][i].highlight:SetShown(data.AurasImportantList[name]);

                                if unitFrame.raid[name] and canAssist and auraType == "debuffs" then
                                    unitFrame[auraType][i].border:SetVertexColor(0.85, 0.43, 0.83);
                                    unitFrame[auraType][i].highlight:SetVertexColor(0.85, 0.43, 0.83);
                                else
                                    unitFrame[auraType][i].border:SetVertexColor(r,g,b);
                                    unitFrame[auraType][i].highlight:SetVertexColor(r,g,b);
                                end

                                -- Scripts
                                local timeElapsed = 0;

                                unitFrame[auraType][i]:SetScript("OnUpdate", function(self, elapsed)
                                    timeElapsed = timeElapsed + elapsed;

                                    if timeElapsed > 0.1 then
                                        timeElapsed = 0;
                                        self.countdown:SetText(formatTime(expirationTime - GetTime()));
                                    end
                                end);

                                unitFrame[auraType][i]:Show();
                                unitFrame[auraType][i].highlight.animationGrp:Play();
                            elseif unitFrame[auraType][i] then
                                unitFrame[auraType][i]:Hide();
                                unitFrame[auraType][i].highlight.animationGrp:Stop();
                            end
                        elseif unitFrame[auraType][i] then
                            unitFrame[auraType][i]:Hide();
                            unitFrame[auraType][i].highlight.animationGrp:Stop();
                        else
                            break;
                        end
                    end
                else
                    for k,v in pairs(unitFrame[auraType]) do
                        if k then
                            v:Hide();
                        end
                    end
                end
            end

            createFrames("HELPFUL", "buffs", (buffOnFriendly or buffOnEnemy), 0,1,0);
            createFrames("HARMFUL", "debuffs", (debuffOnFriendly or debuffOnEnemy), 1,0,0);

            ----------------------------------------
            -- Sorting auras
            ----------------------------------------
            local function sortAuras(toSortTable, sortedTable, maxAuras)
                for k,v in ipairs(toSortTable) do
                    if k then
                        if #sortedTable < maxAuras then
                            table.insert(sortedTable, v);
                        else
                            v:Hide();
                        end
                    end
                end
            end

            -- Sorting important auras first then normal ones
            if canAssist then
                sortAuras(unitFrame.toSort.important_buffs,   unitFrame.sorted.buffs,   Config.AurasMaxBuffsFriendly);
                sortAuras(unitFrame.toSort.buffs,             unitFrame.sorted.buffs,   Config.AurasMaxBuffsFriendly);
                sortAuras(unitFrame.toSort.important_debuffs, unitFrame.sorted.debuffs, Config.AurasMaxDebuffsFriendly);
                sortAuras(unitFrame.toSort.debuffs,           unitFrame.sorted.debuffs, Config.AurasMaxDebuffsFriendly);
            else
                sortAuras(unitFrame.toSort.important_buffs,   unitFrame.sorted.buffs,   Config.AurasMaxBuffsEnemy);
                sortAuras(unitFrame.toSort.buffs,             unitFrame.sorted.buffs,   Config.AurasMaxBuffsEnemy);
                sortAuras(unitFrame.toSort.important_debuffs, unitFrame.sorted.debuffs, Config.AurasMaxDebuffsEnemy);
                sortAuras(unitFrame.toSort.debuffs,           unitFrame.sorted.debuffs, Config.AurasMaxDebuffsEnemy);
            end

            ----------------------------------------
            -- Positioning auras
            ----------------------------------------
            -- Buffs
            for k,v in ipairs(unitFrame.sorted.buffs) do
                local auraWidth, gap, bigGap, calc = 28, 6, 12, 0;

                if #unitFrame.sorted.buffs > 0 then
                    local prev = k - 1;

                    v:ClearAllPoints();

                    if #unitFrame.sorted.debuffs > 0 then
                        local totalAuras = #unitFrame.sorted.debuffs + #unitFrame.sorted.buffs;
                        local totalGaps = #unitFrame.sorted.debuffs + #unitFrame.sorted.buffs - 2;

                        calc = (auraWidth * totalAuras + gap * totalGaps + bigGap) / 2 - 14;
                    else
                        local totalAuras = #unitFrame.sorted.buffs;
                        local totalGaps = #unitFrame.sorted.buffs - 1;

                        calc = (auraWidth * totalAuras + gap * totalGaps) / 2 - 14;
                    end

                    if unitFrame.sorted.buffs[prev] then
                        v:SetPoint("left", unitFrame.sorted.buffs[prev], "right", gap, 0);
                    else
                        v:SetPoint("bottom", unitFrame.name, "top", -(calc), 6);
                    end
                end
            end

            -- Debuffs
            for k,v in ipairs(unitFrame.sorted.debuffs) do
                local auraWidth, gap, bigGap, calc = 28, 6, 12, 0;

                if #unitFrame.sorted.debuffs > 0 then
                    local prev = k - 1;

                    v:ClearAllPoints();

                    if #unitFrame.sorted.buffs > 0 then
                        local totalAuras = #unitFrame.sorted.debuffs;
                        local totalGaps = #unitFrame.sorted.debuffs - 1;

                        calc = auraWidth * totalAuras + gap * totalGaps + bigGap;
                    else
                        local totalAuras = #unitFrame.sorted.debuffs;
                        local totalGaps = #unitFrame.sorted.debuffs - 1;

                        calc = (auraWidth * totalAuras + gap * totalGaps) / 2 - 14;
                    end

                    if unitFrame.sorted.debuffs[prev] then
                        if #unitFrame.sorted.buffs > 0 then
                            v:SetPoint("right", unitFrame.sorted.debuffs[prev], "left", -(gap), 0);
                        else
                            v:SetPoint("right", unitFrame.sorted.debuffs[prev], "left", -(gap), 0);
                        end
                    else
                        if #unitFrame.sorted.buffs > 0 then
                            v:SetPoint("right", unitFrame.sorted.buffs[#unitFrame.sorted.buffs], "right", calc, 0);
                        else
                            v:SetPoint("bottom", unitFrame.name, "top", calc, 6);
                        end
                    end
                end
            end

            ----------------------------------------
            -- Auras counter
            ----------------------------------------
            local function processAuras(counter, auraType, maxAuras, pos1, pos2, x)
                local totalAuras = #unitFrame.toSort["important_" .. auraType] + #unitFrame.toSort[auraType];

                if totalAuras > maxAuras then
                    local sortedAuras = unitFrame.sorted[auraType];

                    counter:ClearAllPoints();
                    counter:SetPoint(pos1, sortedAuras[1], pos2, x, 0);
                    counter:SetText("+" .. totalAuras - maxAuras);
                end

                counter:SetShown(totalAuras > maxAuras);
            end

            if canAssist then
                processAuras(unitFrame.buffsCounter, "buffs", Config.AurasMaxBuffsFriendly, "right", "left", -5);
                processAuras(unitFrame.debuffsCounter, "debuffs", Config.AurasMaxDebuffsFriendly, "left", "right", 5);
            else
                processAuras(unitFrame.buffsCounter, "buffs", Config.AurasMaxBuffsEnemy, "right", "left", -5);
                processAuras(unitFrame.debuffsCounter, "debuffs", Config.AurasMaxDebuffsEnemy, "left", "right", 5);
            end
        end
    end
end