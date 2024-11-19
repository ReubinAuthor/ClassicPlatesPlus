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
    if unit and (string.match(unit, "nameplate") or unit == "player") then
        local scaleOffset = unit == "player" and 0.15 or 0.15;
        local nameplate = unit == "player" and data.nameplate or C_NamePlate.GetNamePlateForUnit(unit);

        local scale = CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile].AurasScale - scaleOffset;
        if scale <= 0 then scale = 0.1 end

        if nameplate then
            local unitFrame = unit == "player" and nameplate or nameplate.unitFrame;
            local canAttack = UnitCanAttack("player", unit);
            local AurasHidePassive = CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile].AurasHidePassive;

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

            if not unitFrame.buffs.auras then unitFrame.buffs.auras = {} end
            if not unitFrame.debuffs.auras then unitFrame.debuffs.auras = {} end

            local function createFrames(filter, auraType, r,g,b)
                for i = 1, 40 do
                    local aura = C_UnitAuras.GetAuraDataByIndex(unit, i, filter);

                    if aura then
                        local name = aura.name;
                        local icon = aura.icon;
                        local stacks = aura.applications;
                        local duration = aura.duration;
                        local expirationTime = aura.expirationTime;
                        local source = aura.sourceUnit;
                        local spellId = aura.spellId;
                        local timeMod = aura.timeMod;

                        local UnitIsPlayer = unit == "player" or source == "vehicle";

                        local function showType()
                            if unit == "player" then
                                if CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile].BuffsPersonal and auraType == "buffs" then
                                    return true;
                                end
                                if CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile].DebuffsPersonal and auraType == "debuffs" then
                                    return true;
                                end
                            else
                                if canAttack then
                                    if CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile].BuffsEnemy and auraType == "buffs" then
                                        return true;
                                    end
                                    if CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile].DebuffsEnemy and auraType == "debuffs" then
                                        return true;
                                    end
                                else
                                    if CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile].BuffsFriendly and auraType == "buffs" then
                                        return true;
                                    end
                                    if CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile].DebuffsFriendly and auraType == "debuffs" then
                                        return true;
                                    end
                                end
                            end
                        end

                        -- Test Auras
                        local test = false;
                        if test then
                            if i <= 8 then --and auraType == "debuffs" then
                                name = "Test Aura " .. i;
                                icon = 1120721;
                                stacks = i;
                                duration = 0;
                                expirationTime = duration + GetTime();
                                source = "target";
                            end
                            if i > 8 and i < 17 then
                                name = "Test Aura " .. i;
                                icon = 136243;
                                stacks = i;
                                duration = 0;
                                expirationTime = duration + GetTime();
                                source = "player";
                            end
                        end

                        local SourceIsPlayer = source == "player" or source == "vehicle";
                        local hidePassiveCheck = not ( duration == 0 and (AurasHidePassive == 2 or ( AurasHidePassive == 3 and not SourceIsPlayer ) ) );

                        -------- Checking aurs source --------
                        local AurasSource = CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile].AurasShow;
                        local show = true;

                        if canAttack then
                            if auraType == "debuffs" then
                                show = (AurasSource == 1 and SourceIsPlayer) or AurasSource == 2;
                            end
                        else
                            if auraType == "buffs" then
                                show = (AurasSource == 1 and SourceIsPlayer) or AurasSource == 2;
                            end
                        end

                        local isPlayersAura = UnitIsPlayer and (auraType == "debuffs" or auraType == "buffs" and ( CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile].AurasSourcePersonal == 1 and SourceIsPlayer or CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile].AurasSourcePersonal == 2 ) );
                        local toggle = data.settings and (data.settings.AurasImportantList[name] or (showType() and hidePassiveCheck and ( show or isPlayersAura )) and not data.settings.AurasBlacklist[name]);

                        if toggle then
                            if not unitFrame[auraType]["auras"][i] then
                                ------------------------------------
                                -- Main
                                ------------------------------------
                                unitFrame[auraType]["auras"][i] = CreateFrame("frame", nil, unitFrame);
                                unitFrame[auraType]["auras"][i]:SetSize(28, 24);
                                unitFrame[auraType]["auras"][i]:SetFrameLevel(1);
                                unitFrame[auraType]["auras"][i]:SetIgnoreParentScale(true);
                                unitFrame[auraType]["auras"][i]:SetScale(scale);

                                ------------------------------------
                                -- Firse level
                                ------------------------------------
                                unitFrame[auraType]["auras"][i].first = CreateFrame("frame", nil, unitFrame[auraType]["auras"][i]);
                                unitFrame[auraType]["auras"][i].first:SetPoint("center", unitFrame[auraType]["auras"][i], "center");
                                unitFrame[auraType]["auras"][i].first:SetAllPoints();
                                unitFrame[auraType]["auras"][i].first:SetFrameLevel(1);

                                -- Highlight
                                unitFrame[auraType]["auras"][i].highlight = unitFrame[auraType]["auras"][i].first:CreateTexture();
                                unitFrame[auraType]["auras"][i].highlight:SetPoint("Center", unitFrame[auraType]["auras"][i].first);
                                unitFrame[auraType]["auras"][i].highlight:SetSize(64,64);
                                unitFrame[auraType]["auras"][i].highlight:SetTexture("Interface\\addons\\ClassicPlatesPlus\\media\\auras\\importantHighlight");
                                unitFrame[auraType]["auras"][i].highlight:SetVertexColor(1,0,0,1);

                                -- Highlight animation group
                                unitFrame[auraType]["auras"][i].highlight.animationGrp = unitFrame[auraType]["auras"][i].highlight:CreateAnimationGroup();
                                unitFrame[auraType]["auras"][i].highlight.animationGrp:SetLooping("repeat");

                                -- Highlight animation alpha
                                local animation_alphaFrom = unitFrame[auraType]["auras"][i].highlight.animationGrp:CreateAnimation("Alpha");
                                animation_alphaFrom:SetDuration(0.33);
                                animation_alphaFrom:SetFromAlpha(0);
                                animation_alphaFrom:SetToAlpha(1);
                                animation_alphaFrom:SetOrder(1);
                                local animation_alphaTo = unitFrame[auraType]["auras"][i].highlight.animationGrp:CreateAnimation("Alpha");
                                animation_alphaTo:SetDuration(0.33);
                                animation_alphaTo:SetFromAlpha(1);
                                animation_alphaTo:SetToAlpha(0);
                                animation_alphaTo:SetOrder(2);

                                -- Mask
                                unitFrame[auraType]["auras"][i].mask = unitFrame[auraType]["auras"][i].first:CreateMaskTexture();
                                unitFrame[auraType]["auras"][i].mask:SetPoint("center", unitFrame[auraType]["auras"][i].first, "center");
                                unitFrame[auraType]["auras"][i].mask:SetSize(64, 32);
                                unitFrame[auraType]["auras"][i].mask:SetTexture("Interface\\addons\\ClassicPlatesPlus\\media\\auras\\mask", "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE");

                                -- Icon
                                unitFrame[auraType]["auras"][i].icon = unitFrame[auraType]["auras"][i].first:CreateTexture();
                                unitFrame[auraType]["auras"][i].icon:SetPoint("center", unitFrame[auraType]["auras"][i].first, "center");
                                unitFrame[auraType]["auras"][i].icon:SetSize(28, 28);
                                unitFrame[auraType]["auras"][i].icon:SetTexture(icon);
                                unitFrame[auraType]["auras"][i].icon:AddMaskTexture(unitFrame[auraType]["auras"][i].mask);
                                unitFrame[auraType]["auras"][i].icon:SetDrawLayer("background", 1);

                                -- Cooldown
                                unitFrame[auraType]["auras"][i].cooldown = CreateFrame("Cooldown", nil, unitFrame[auraType]["auras"][i].first, "CooldownFrameTemplate");
                                unitFrame[auraType]["auras"][i].cooldown:SetAllPoints();
                                unitFrame[auraType]["auras"][i].cooldown:SetCooldown(GetTime() - (duration - (expirationTime - GetTime())), duration, timeMod);
                                unitFrame[auraType]["auras"][i].cooldown:SetDrawEdge(true);
                                unitFrame[auraType]["auras"][i].cooldown:SetDrawBling(false);
                                unitFrame[auraType]["auras"][i].cooldown:SetSwipeColor(0, 0, 0, 0.6);
                                unitFrame[auraType]["auras"][i].cooldown:SetHideCountdownNumbers(true);
                                unitFrame[auraType]["auras"][i].cooldown:SetReverse(CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile].AurasReverseAnimation);
                                unitFrame[auraType]["auras"][i].cooldown:SetFrameLevel(1);

                                ------------------------------------
                                -- Second level
                                ------------------------------------
                                unitFrame[auraType]["auras"][i].second = CreateFrame("frame", nil, unitFrame[auraType]["auras"][i]);
                                unitFrame[auraType]["auras"][i].second:SetAllPoints();
                                unitFrame[auraType]["auras"][i].second:SetFrameLevel(2);

                                -- Border
                                unitFrame[auraType]["auras"][i].border = unitFrame[auraType]["auras"][i].second:CreateTexture();
                                unitFrame[auraType]["auras"][i].border:SetPoint("center", unitFrame[auraType]["auras"][i].second, "center");
                                unitFrame[auraType]["auras"][i].border:SetDrawLayer("border", 1);

                                -- Countdown
                                unitFrame[auraType]["auras"][i].countdown = unitFrame[auraType]["auras"][i].second:CreateFontString(nil, nil, "GameFontNormalOutline");
                                if CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile].AurasCountdownPosition == 1 then
                                    unitFrame[auraType]["auras"][i].countdown:SetPoint("right", unitFrame[auraType]["auras"][i].second, "topRight", 5, -2.5);
                                    unitFrame[auraType]["auras"][i].countdown:SetJustifyH("right");
                                elseif CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile].AurasCountdownPosition == 2 then
                                    unitFrame[auraType]["auras"][i].countdown:SetPoint("center", unitFrame[auraType]["auras"][i].second, "center");
                                    unitFrame[auraType]["auras"][i].countdown:SetJustifyH("center");
                                end
                                unitFrame[auraType]["auras"][i].countdown:SetScale(0.9);
                                unitFrame[auraType]["auras"][i].countdown:SetText(func:formatTime(expirationTime - GetTime()));
                                unitFrame[auraType]["auras"][i].countdown:SetShown(CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile].AurasCountdown);

                                -- Stacks
                                unitFrame[auraType]["auras"][i].stacks = unitFrame[auraType]["auras"][i].second:CreateFontString(nil, nil, "GameFontNormalOutline");
                                unitFrame[auraType]["auras"][i].stacks:SetPoint("right", unitFrame[auraType]["auras"][i].second, "bottomRight", 5, 2.5);
                                unitFrame[auraType]["auras"][i].stacks:SetScale(0.9);
                                unitFrame[auraType]["auras"][i].stacks:SetText("x" .. stacks);
                                unitFrame[auraType]["auras"][i].stacks:SetJustifyH("right");
                                unitFrame[auraType]["auras"][i].stacks:SetShown(stacks > 0);
                            else
                                -- Main
                                unitFrame[auraType]["auras"][i]:SetScale(scale);

                                -- Icon
                                unitFrame[auraType]["auras"][i].icon:SetTexture(icon);

                                -- Cooldown
                                unitFrame[auraType]["auras"][i].cooldown:SetCooldown(GetTime() - (duration - (expirationTime - GetTime())), duration, timeMod);
                                unitFrame[auraType]["auras"][i].cooldown:SetReverse(CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile].AurasReverseAnimation);

                                -- Countdown
                                unitFrame[auraType]["auras"][i].countdown:SetText(func:formatTime(expirationTime - GetTime()));
                                unitFrame[auraType]["auras"][i].countdown:SetShown(CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile].AurasCountdown);

                                -- Stacks
                                unitFrame[auraType]["auras"][i].stacks:SetText("x" .. stacks);
                                unitFrame[auraType]["auras"][i].stacks:SetShown(stacks > 0);
                            end

                            -- Tooltip
                            if CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile].Tooltip then
                                local frame = unitFrame[auraType]["auras"][i];
                                local hover;

                                local function keyCheck()
                                    if CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile].Tooltip == 1 and IsShiftKeyDown()
                                    or CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile].Tooltip == 2 and IsControlKeyDown()
                                    or CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile].Tooltip == 3 and IsAltKeyDown()
                                    then
                                        return true;
                                    end
                                end

                                local function work(frame)
                                    if hover and keyCheck() then
                                        GameTooltip:Hide();
                                        GameTooltip:SetOwner(frame, "ANCHOR_BOTTOMLEFT", 0, -2);
                                        GameTooltip:SetUnitAura(unit, i, filter);

                                        if spellId then
                                            GameTooltip:AddDoubleLine("Spell ID", spellId, nil, nil, nil, 1, 1, 1);
                                        end

                                        GameTooltip:Show();
                                    end
                                end

                                frame:SetScript("OnEnter", function(self)
                                    self:EnableMouse(keyCheck());
                                    hover = true;
                                    work(self);
                                end);

                                frame:SetScript("OnLeave", function(self)
                                    self:EnableMouse(keyCheck());
                                    hover = false;
                                    local owner = GameTooltip:GetOwner();

                                    if owner == self or not owner then
                                        GameTooltip:Hide();
                                    end
                                end);

                                frame:RegisterEvent("MODIFIER_STATE_CHANGED");
                                frame:SetScript("OnEvent", function(self)
                                    local owner = GameTooltip:GetOwner();

                                    self:EnableMouse(keyCheck());
                                    work(self);

                                    if not keyCheck() and owner == self or not owner then
                                        GameTooltip:Hide();
                                    end
                                end);

                                frame:EnableMouse(keyCheck());
                            end

                            -- Flags
                            unitFrame[auraType]["auras"][i].name = name;
                            unitFrame[auraType]["auras"][i].type = auraType;

                            -- Sorting important and normal aurs
                            if data.settings.AurasImportantList[name] then
                                table.insert(unitFrame.toSort["important_" .. auraType], unitFrame[auraType]["auras"][i]);
                            else
                                table.insert(unitFrame.toSort[auraType], unitFrame[auraType]["auras"][i]);
                            end

                            -- Adjusting border and highlight
                            if data.settings.AurasImportantList[name] then
                                unitFrame[auraType]["auras"][i].border:SetSize(64,64);
                                if stacks > 0 then
                                    unitFrame[auraType]["auras"][i].border:SetTexture("Interface\\addons\\ClassicPlatesPlus\\media\\auras\\importantBorderStacks");
                                    unitFrame[auraType]["auras"][i].highlight:SetTexture("Interface\\addons\\ClassicPlatesPlus\\media\\auras\\importantHighlightStacks");
                                else
                                    unitFrame[auraType]["auras"][i].border:SetTexture("Interface\\addons\\ClassicPlatesPlus\\media\\auras\\importantBorder");
                                    unitFrame[auraType]["auras"][i].highlight:SetTexture("Interface\\addons\\ClassicPlatesPlus\\media\\auras\\importantHighlight");
                                end
                            else
                                unitFrame[auraType]["auras"][i].border:SetSize(64,32);
                                if stacks > 0 then
                                    unitFrame[auraType]["auras"][i].border:SetTexture("Interface\\addons\\ClassicPlatesPlus\\media\\auras\\borderStacks");
                                else
                                    unitFrame[auraType]["auras"][i].border:SetTexture("Interface\\addons\\ClassicPlatesPlus\\media\\auras\\border");
                                end
                            end

                            -- Toggling highlight
                            unitFrame[auraType]["auras"][i].highlight:SetShown(data.settings.AurasImportantList[name]);

                            if unitFrame.raid[name] and canAttack and auraType == "debuffs" then
                                unitFrame[auraType]["auras"][i].border:SetVertexColor(0.85, 0.43, 0.83);
                                unitFrame[auraType]["auras"][i].highlight:SetVertexColor(0.85, 0.43, 0.83);
                            else
                                unitFrame[auraType]["auras"][i].border:SetVertexColor(r,g,b);
                                unitFrame[auraType]["auras"][i].highlight:SetVertexColor(r,g,b);
                            end

                            -- Scripts
                            local timeElapsed = 0;
                            unitFrame[auraType]["auras"][i]:SetScript("OnUpdate", function(self, elapsed)
                                timeElapsed = timeElapsed + elapsed;

                                if timeElapsed > 0.1 then
                                    local countdown = expirationTime - GetTime();

                                    if countdown < 10 then
                                        self.countdown:SetVertexColor(1, 0.5, 0);
                                    else
                                        self.countdown:SetVertexColor(1, 0.82, 0);
                                    end

                                    self.countdown:SetText(func:formatTime(countdown));
                                end
                            end);

                            -- Showing aura
                            unitFrame[auraType]["auras"][i]:Show();
                            unitFrame[auraType]["auras"][i].highlight.animationGrp:Play();
                        elseif unitFrame[auraType]["auras"][i] then
                            unitFrame[auraType]["auras"][i]:Hide();
                            unitFrame[auraType]["auras"][i].highlight.animationGrp:Stop();
                        end
                    elseif unitFrame[auraType]["auras"][i] then
                        unitFrame[auraType]["auras"][i]:Hide();
                        unitFrame[auraType]["auras"][i].highlight.animationGrp:Stop();
                    else
                        break;
                    end
                end
            end

            local helpful_Filter = CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile].ShowOnlyApplicableAuras and "helpful";
            local harmful_Filter = CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile].ShowOnlyDispellableAuras and "harmful";

            createFrames("helpful", "buffs", 0,1,0);
            createFrames("harmful", "debuffs", 1,0,0);

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
            if unit == "player" then
                sortAuras(unitFrame.toSort.important_buffs,   unitFrame.sorted.buffs,   CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile].AurasPersonalMaxBuffs);
                sortAuras(unitFrame.toSort.buffs,             unitFrame.sorted.buffs,   CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile].AurasPersonalMaxBuffs);
                sortAuras(unitFrame.toSort.important_debuffs, unitFrame.sorted.debuffs, CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile].AurasPersonalMaxDebuffs);
                sortAuras(unitFrame.toSort.debuffs,           unitFrame.sorted.debuffs, CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile].AurasPersonalMaxDebuffs);
            elseif canAttack then
                sortAuras(unitFrame.toSort.important_buffs,   unitFrame.sorted.buffs,   CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile].AurasMaxBuffsEnemy);
                sortAuras(unitFrame.toSort.buffs,             unitFrame.sorted.buffs,   CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile].AurasMaxBuffsEnemy);
                sortAuras(unitFrame.toSort.important_debuffs, unitFrame.sorted.debuffs, CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile].AurasMaxDebuffsEnemy);
                sortAuras(unitFrame.toSort.debuffs,           unitFrame.sorted.debuffs, CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile].AurasMaxDebuffsEnemy);
            else
                sortAuras(unitFrame.toSort.important_buffs,   unitFrame.sorted.buffs,   CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile].AurasMaxBuffsFriendly);
                sortAuras(unitFrame.toSort.buffs,             unitFrame.sorted.buffs,   CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile].AurasMaxBuffsFriendly);
                sortAuras(unitFrame.toSort.important_debuffs, unitFrame.sorted.debuffs, CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile].AurasMaxDebuffsFriendly);
                sortAuras(unitFrame.toSort.debuffs,           unitFrame.sorted.debuffs, CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile].AurasMaxDebuffsFriendly);
            end

            ----------------------------------------
            -- Call to positioning auras
            ----------------------------------------
            func:PositionAuras(unitFrame, unit);

            ----------------------------------------
            -- Auras counter
            ----------------------------------------
            local function processAuras(counter, auraType, maxAuras, pos1, pos2, x)
                local totalAuras = #unitFrame.toSort["important_" .. auraType] + #unitFrame.toSort[auraType];

                if totalAuras > maxAuras then
                    local sortedAuras = unitFrame.sorted[auraType];
                    local anchor = auraType == "debuffs" and sortedAuras[#sortedAuras] or auraType == "buffs" and sortedAuras[1];

                    if unit == "player" and auraType == "buffs" then
                        anchor = sortedAuras[#sortedAuras];
                    end

                    counter:ClearAllPoints();
                    counter:SetPoint(pos1, anchor, pos2, x, 0);
                    counter:SetText("+" .. totalAuras - maxAuras);
                end

                counter:SetShown(CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile].AurasOverFlowCounter and totalAuras > maxAuras);
            end

            if unit == "player" then
                processAuras(unitFrame.buffsCounter, "buffs", CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile].AurasPersonalMaxBuffs, "left", "right", 5);
                processAuras(unitFrame.debuffsCounter, "debuffs", CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile].AurasPersonalMaxDebuffs, "left", "right", 5);
            elseif canAttack then
                processAuras(unitFrame.buffsCounter, "buffs", CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile].AurasMaxBuffsEnemy, "right", "left", -5);
                processAuras(unitFrame.debuffsCounter, "debuffs", CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile].AurasMaxDebuffsEnemy, "left", "right", 5);
            else
                processAuras(unitFrame.buffsCounter, "buffs", CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile].AurasMaxBuffsFriendly, "right", "left", -5);
                processAuras(unitFrame.debuffsCounter, "debuffs", CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile].AurasMaxDebuffsFriendly, "left", "right", 5);
            end

            -- Interact Icon
            func:InteractIcon(nameplate);
        end
    end
end

----------------------------------------
-- Position auras
----------------------------------------
function func:PositionAuras(unitFrame, unit)
    if unitFrame then
        local resourceOnTarget = data.cvars.nameplateResourceOnTarget;
        local classFile = select(2, UnitClass("player"));
        local powerType = UnitPowerType("player");

        local class =
                classFile == "PALADIN"
            or  classFile == "ROGUE"
            or  classFile == "DEATHKNIGHT"
            or  classFile == "WARLOCK"
            or (classFile == "DRUID" and powerType == 3)
            or  classFile == "EVOKER";

        local auraWidth = 28;
        local bigGap = 12;
        local gap = 6;
        local calc = 0;
        local anchor, y, pos1, pos2, totalAuras, totalGaps;

        unit = unit or unitFrame.unit;

        -- Get Anchor
        if data.isRetail and resourceOnTarget == "1" and unit and UnitIsUnit(unit, "target") and class then
            anchor = unitFrame.classPower;
        elseif not data.isRetail and unitFrame.classPower:IsVisible() then
            anchor = unitFrame.classPower;
        else
            anchor = unitFrame.name;
        end

        -- Position auras
        if unitFrame.sorted then
            -- Buffs
            for k,v in ipairs(unitFrame.sorted.buffs) do
                if k == 1 then
                    if unit == "player" then
                        totalAuras = #unitFrame.sorted.buffs;
                        totalGaps = #unitFrame.sorted.buffs - 1;
                        anchor = unitFrame.healthbar;
                        y = 10 * CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile].PersonalNameplatesScale;
                        calc = -((auraWidth * totalAuras + gap * totalGaps) / 2 - 13.5);
                    else
                        y = 6;

                        if #unitFrame.sorted.debuffs > 0 then
                            totalAuras = #unitFrame.sorted.buffs + #unitFrame.sorted.debuffs;
                            totalGaps = #unitFrame.sorted.buffs + #unitFrame.sorted.debuffs - 2;
                            calc = -((auraWidth * totalAuras + gap * totalGaps) / 2 - 7);
                        else
                            totalAuras = #unitFrame.sorted.buffs;
                            totalGaps = #unitFrame.sorted.buffs - 1;
                            calc = -((auraWidth * totalAuras + gap * totalGaps) / 2 - 13.5);
                        end
                    end

                    pos1, pos2 = "bottom", "top";
                else
                    anchor = unitFrame.sorted.buffs[k - 1];
                    pos1, pos2, y = "left", "right", 0;
                    calc = gap;
                end

                v:ClearAllPoints();
                v:SetPoint(pos1, anchor, pos2, calc, y);
            end

            -- Debuffs
            local totalBuffs = #unitFrame.sorted.buffs;

            for k,v in ipairs(unitFrame.sorted.debuffs) do
                if k == 1 then
                    totalAuras = #unitFrame.sorted.debuffs;
                    totalGaps = #unitFrame.sorted.debuffs - 1;
                    calc = -((auraWidth * totalAuras + gap * totalGaps ) / 2 - 13.5);

                    if unit == "player" then
                        pos1, pos2 = "top", "bottom";

                        if resourceOnTarget == "0" and class then
                            anchor = unitFrame.classPower;

                            if classFile == "PALADIN" then
                                y = 0;
                            else
                                y = -8;
                            end
                        else
                            if unitFrame.classPower:IsVisible() then
                                anchor = unitFrame.classPower;
                            elseif unitFrame.extraBar:IsShown() then
                                anchor = unitFrame.extraBar;
                            else
                                anchor = unitFrame.powerbar;
                            end

                            y = -10;
                        end
                    else
                        if totalBuffs > 0 then
                            anchor = unitFrame.sorted.buffs[totalBuffs];
                            pos1, pos2, y = "left", "right", 0;
                            calc = bigGap;
                        else
                            pos1, pos2, y = "bottom", "top", 6;
                        end
                    end
                elseif #unitFrame.sorted.debuffs > 0 then
                    anchor = unitFrame.sorted.debuffs[k - 1];
                    pos1, pos2, y = "left", "right", 0;
                    calc = gap;
                end

                v:ClearAllPoints();
                v:SetPoint(pos1, anchor, pos2, calc, y);
            end
        end
    end
end