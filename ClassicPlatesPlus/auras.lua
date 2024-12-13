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
    local CFG = CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile];

    if unit then
        local isNameplate = string.match(unit, "nameplate");
        local UnitIsPlayer = UnitIsUnit("player", unit);
        local nameplate, unitFrame;

        if UnitIsPlayer then
            nameplate = data.nameplate;
            unitFrame = nameplate;
        elseif isNameplate then
            nameplate = C_NamePlate.GetNamePlateForUnit(unit);
            unitFrame = nameplate.unitFrame;
        end

        if nameplate and unitFrame then
            local canAttack = UnitCanAttack("player", unit);
            local scaleOffset = UnitIsPlayer and 0.15 or 0.15;
            local scale = (CFG.AurasScale - scaleOffset) > 0 and (CFG.AurasScale - scaleOffset) or 0.1

            unitFrame.auras = unitFrame.auras or CreateFrame("Frame", nil, unitFrame.parent);
            unitFrame.auras.helpful = unitFrame.auras.helpful or {};
            unitFrame.auras.harmful = unitFrame.auras.harmful or {};
            unitFrame.auras.toSort = { helpful = {}, harmful = {}, important_helpful = {}, important_harmful = {}, stealable_helpful = {} };
            unitFrame.auras.sorted = { helpful = {}, harmful = {} };

            if unitFrame.auras then
                local function getAuras(filter)
                    for i = 1, 40 do
                        local aura = C_UnitAuras.GetAuraDataByIndex(unit, i, filter);

                        local test = false;
                        if test then
                            aura = {
                                name = "Test aura " .. i,
                                icon = 1120721,
                                applications = i,
                                duration = i < 2 and 0 or 30,
                                isHarmful = filter == "harmful",
                                isHelpful = filter == "helpful",
                                expirationTime = (i < 2 and 0 or 30) + GetTime();
                            }
                        end

                        if aura then
                            local name = aura.name;
                            local icon = aura.icon;
                            local stacks = aura.applications;
                            local duration = aura.duration;
                            local expirationTime = aura.expirationTime;
                            local source = aura.sourceUnit;
                            local spellId = aura.spellId;
                            local timeMod = aura.timeMod;
                            local isHarmful = aura.isHarmful;
                            local isHelpful = aura.isHelpful;
                            local canApplyAura = aura.canApplyAura;
                            local isRaid = aura.isRaid;
                            local isStealable = aura.isStealable;
                            local r,g,b = (isHarmful and 1 or 0), (isHelpful and 1 or 0), 0;
                            local sourceIsPlayer = false;
                            local markStealable = CFG.MarkStealableAuras and isStealable;

                            if source then
                                sourceIsPlayer = UnitIsUnit("player", source);
                            end

                            if markStealable then
                                r,g,b = 0.0,0.66,1;
                            end

                            local function toggle()
                                -- Checking if aura is Blacklisted or Important
                                if data.settings.AurasBlacklist[name] then
                                    return false;
                                elseif data.settings.AurasImportantList[name] then
                                    return true;
                                end

                                -- Checking aura's filter
                                if UnitIsUnit("player", unit) then
                                    if filter == "helpful" then
                                        if CFG.BuffsFilterPersonal == 2 and not sourceIsPlayer then
                                            return false;
                                        elseif CFG.BuffsFilterPersonal == 3 and not sourceIsPlayer and not isRaid then
                                            return false;
                                        end
                                    elseif filter == "harmful" then
                                        if CFG.DebuffsFilterPersonal == 2 and not isRaid then
                                            return false;
                                        end
                                    end
                                else
                                    if not canAttack then
                                        if CFG.AurasFilterFriendly == 2 and not sourceIsPlayer then
                                            return false;
                                        elseif CFG.AurasFilterFriendly == 3 and not isRaid then
                                            return false;
                                        end
                                    else
                                        if CFG.AurasFilterEnemy == 2 and not sourceIsPlayer then
                                            return false;
                                        end
                                    end
                                end

                                -- Checking if aura is Passive and if it should be shown
                                if duration == 0 or not duration then
                                    if CFG.AurasHidePassive == 2 then
                                        return false;
                                    elseif CFG.AurasHidePassive == 3 and not sourceIsPlayer then
                                        return false;
                                    end
                                end

                                -- Checking if aura of this Type should be shown on personal namplate and others
                                if UnitIsPlayer then
                                    if isHelpful then
                                        if not CFG.BuffsPersonal then
                                            return false;
                                        end

                                        if CFG.BuffsFilterPersonal == 3 then
                                            if not canApplyAura and not sourceIsPlayer then
                                                return false;
                                            end
                                        end
                                    elseif isHarmful and not CFG.DebuffsPersonal then
                                        return false;
                                    end
                                else
                                    if canAttack then
                                        if isHelpful and not CFG.BuffsEnemy then
                                            return false;
                                        elseif isHarmful and not CFG.DebuffsEnemy then
                                            return false;
                                        end
                                    else
                                        if isHelpful and not CFG.BuffsFriendly then
                                            return false;
                                        elseif isHarmful and not CFG.DebuffsFriendly then
                                            return false;
                                        end
                                    end
                                end

                                return true;
                            end

                            if toggle() then
                                if not unitFrame.auras[filter][i] then
                                    ------------------------------------
                                    -- Main
                                    ------------------------------------
                                    unitFrame.auras[filter][i] = CreateFrame("frame", myAddon .. "_aurasList_" .. i, unitFrame);
                                    unitFrame.auras[filter][i]:SetSize(28, 24);
                                    unitFrame.auras[filter][i]:SetFrameLevel(1);
                                    unitFrame.auras[filter][i]:SetIgnoreParentScale(true);
                                    unitFrame.auras[filter][i]:SetScale(scale);

                                    ------------------------------------
                                    -- Firse level
                                    ------------------------------------
                                    unitFrame.auras[filter][i].first = CreateFrame("frame", nil, unitFrame.auras[filter][i]);
                                    unitFrame.auras[filter][i].first:SetPoint("center", unitFrame.auras[filter][i], "center");
                                    unitFrame.auras[filter][i].first:SetAllPoints();
                                    unitFrame.auras[filter][i].first:SetFrameLevel(1);

                                    -- Highlight
                                    unitFrame.auras[filter][i].highlight = unitFrame.auras[filter][i].first:CreateTexture();
                                    unitFrame.auras[filter][i].highlight:SetPoint("Center", unitFrame.auras[filter][i].first);
                                    unitFrame.auras[filter][i].highlight:SetSize(64,64);
                                    unitFrame.auras[filter][i].highlight:SetTexture("Interface\\addons\\ClassicPlatesPlus\\media\\auras\\importantHighlight");
                                    unitFrame.auras[filter][i].highlight:SetVertexColor(1,0,0,1);

                                    -- Highlight animation group
                                    unitFrame.auras[filter][i].highlight.animationGrp = unitFrame.auras[filter][i].highlight:CreateAnimationGroup();
                                    unitFrame.auras[filter][i].highlight.animationGrp:SetLooping("repeat");

                                    -- Highlight animation alpha
                                    local animation_alphaFrom = unitFrame.auras[filter][i].highlight.animationGrp:CreateAnimation("Alpha");
                                    animation_alphaFrom:SetDuration(0.33);
                                    animation_alphaFrom:SetFromAlpha(0);
                                    animation_alphaFrom:SetToAlpha(1);
                                    animation_alphaFrom:SetOrder(1);

                                    local animation_alphaTo = unitFrame.auras[filter][i].highlight.animationGrp:CreateAnimation("Alpha");
                                    animation_alphaTo:SetDuration(0.33);
                                    animation_alphaTo:SetFromAlpha(1);
                                    animation_alphaTo:SetToAlpha(0);
                                    animation_alphaTo:SetOrder(2);

                                    -- Mask
                                    unitFrame.auras[filter][i].mask = unitFrame.auras[filter][i].first:CreateMaskTexture();
                                    unitFrame.auras[filter][i].mask:SetPoint("center", unitFrame.auras[filter][i].first, "center");
                                    unitFrame.auras[filter][i].mask:SetSize(64, 32);
                                    unitFrame.auras[filter][i].mask:SetTexture("Interface\\addons\\ClassicPlatesPlus\\media\\auras\\mask", "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE");

                                    -- Icon
                                    unitFrame.auras[filter][i].icon = unitFrame.auras[filter][i].first:CreateTexture();
                                    unitFrame.auras[filter][i].icon:SetPoint("center", unitFrame.auras[filter][i].first, "center");
                                    unitFrame.auras[filter][i].icon:SetSize(28, 28);
                                    unitFrame.auras[filter][i].icon:SetTexture(icon);
                                    unitFrame.auras[filter][i].icon:AddMaskTexture(unitFrame.auras[filter][i].mask);
                                    unitFrame.auras[filter][i].icon:SetDrawLayer("background", 1);

                                    -- Cooldown
                                    unitFrame.auras[filter][i].cooldown = CreateFrame("Cooldown", nil, unitFrame.auras[filter][i].first, "CooldownFrameTemplate");
                                    unitFrame.auras[filter][i].cooldown:SetAllPoints();
                                    unitFrame.auras[filter][i].cooldown:SetCooldown(GetTime() - (duration - (expirationTime - GetTime())), duration, timeMod);
                                    unitFrame.auras[filter][i].cooldown:SetDrawEdge(true);
                                    unitFrame.auras[filter][i].cooldown:SetDrawBling(false);
                                    unitFrame.auras[filter][i].cooldown:SetSwipeColor(0, 0, 0, 0.6);
                                    unitFrame.auras[filter][i].cooldown:SetHideCountdownNumbers(true);
                                    unitFrame.auras[filter][i].cooldown:SetReverse(CFG.AurasReverseAnimation);
                                    unitFrame.auras[filter][i].cooldown:SetFrameLevel(1);

                                    ------------------------------------
                                    -- Second level
                                    ------------------------------------
                                    unitFrame.auras[filter][i].second = CreateFrame("frame", nil, unitFrame.auras[filter][i]);
                                    unitFrame.auras[filter][i].second:SetAllPoints();
                                    unitFrame.auras[filter][i].second:SetFrameLevel(2);

                                    -- Border
                                    unitFrame.auras[filter][i].border = unitFrame.auras[filter][i].second:CreateTexture();
                                    unitFrame.auras[filter][i].border:SetPoint("center", unitFrame.auras[filter][i].second, "center");
                                    unitFrame.auras[filter][i].border:SetDrawLayer("border", 1);

                                    -- Countdown
                                    unitFrame.auras[filter][i].countdown = unitFrame.auras[filter][i].second:CreateFontString(nil, nil, "GameFontNormalOutline");
                                    if CFG.AurasCountdownPosition == 1 then
                                        unitFrame.auras[filter][i].countdown:SetPoint("right", unitFrame.auras[filter][i].second, "topRight", 5, -2.5);
                                        unitFrame.auras[filter][i].countdown:SetJustifyH("right");
                                    elseif CFG.AurasCountdownPosition == 2 then
                                        unitFrame.auras[filter][i].countdown:SetPoint("center", unitFrame.auras[filter][i].second, "center");
                                        unitFrame.auras[filter][i].countdown:SetJustifyH("center");
                                    end
                                    unitFrame.auras[filter][i].countdown:SetScale(0.9);
                                    unitFrame.auras[filter][i].countdown:SetText(func:formatTime(expirationTime - GetTime()));
                                    unitFrame.auras[filter][i].countdown:SetShown(CFG.AurasCountdown);

                                    -- Stacks
                                    unitFrame.auras[filter][i].stacks = unitFrame.auras[filter][i].second:CreateFontString(nil, nil, "GameFontNormalOutline");
                                    unitFrame.auras[filter][i].stacks:SetPoint("right", unitFrame.auras[filter][i].second, "bottomRight", 5, 2.5);
                                    unitFrame.auras[filter][i].stacks:SetScale(0.9);
                                    unitFrame.auras[filter][i].stacks:SetText("x" .. stacks);
                                    unitFrame.auras[filter][i].stacks:SetJustifyH("right");
                                    unitFrame.auras[filter][i].stacks:SetShown(stacks > 0);
                                else
                                    -- Main
                                    unitFrame.auras[filter][i]:SetScale(scale);

                                    -- Icon
                                    unitFrame.auras[filter][i].icon:SetTexture(icon);

                                    -- Cooldown
                                    unitFrame.auras[filter][i].cooldown:SetCooldown(GetTime() - (duration - (expirationTime - GetTime())), duration, timeMod);
                                    unitFrame.auras[filter][i].cooldown:SetReverse(CFG.AurasReverseAnimation);

                                    -- Countdown
                                    unitFrame.auras[filter][i].countdown:SetText(func:formatTime(expirationTime - GetTime()));
                                    unitFrame.auras[filter][i].countdown:SetShown(CFG.AurasCountdown);

                                    -- Stacks
                                    unitFrame.auras[filter][i].stacks:SetText("x" .. stacks);
                                    unitFrame.auras[filter][i].stacks:SetShown(stacks > 0);
                                end

                                -- Tooltip
                                if CFG.Tooltip then
                                    local hover = false;

                                    local function ModifierState()
                                        if CFG.Tooltip == 1 and IsShiftKeyDown()
                                        or CFG.Tooltip == 2 and IsControlKeyDown()
                                        or CFG.Tooltip == 3 and IsAltKeyDown() then
                                            return true;
                                        else
                                            return false;
                                        end
                                    end

                                    local function work()
                                        if hover then
                                            GameTooltip:SetOwner(unitFrame.auras[filter][i], "ANCHOR_BOTTOMLEFT", 0, -2);
                                            GameTooltip:SetUnitAura(unit, i, filter);

                                            C_Timer.After(0.025, function()
                                                if CFG.TooltipSpellID then
                                                    GameTooltip:AddDoubleLine("Spell ID", spellId, nil, nil, nil, 1, 1, 1);
                                                end
                                                GameTooltip:Show();
                                            end);
                                        end
                                    end

                                    unitFrame.auras[filter][i]:SetScript("OnEnter", function(self)
                                        hover = true;
                                        self:EnableMouse(ModifierState());
                                        work();
                                    end);

                                    unitFrame.auras[filter][i]:SetScript("OnLeave", function(self)
                                        hover = false;
                                        self:EnableMouse(ModifierState());
                                        GameTooltip:Hide();
                                    end);

                                    unitFrame.auras[filter][i]:RegisterEvent("MODIFIER_STATE_CHANGED");
                                    unitFrame.auras[filter][i]:SetScript("OnEvent", function(self)
                                        self:EnableMouse(ModifierState());
                                    end);
                                end

                                -- Flags
                                unitFrame.auras[filter][i].name = name;
                                unitFrame.auras[filter][i].type = filter;

                                -- Toggling highlight
                                unitFrame.auras[filter][i].highlight:SetShown(data.settings.AurasImportantList[name]);

                                -- Setting border color
                                unitFrame.auras[filter][i].border:SetVertexColor(r,g,b);

                                -- Setting highlight color
                                unitFrame.auras[filter][i].highlight:SetVertexColor(r,g,b);

                                -- Adjusting border and highlight
                                if data.settings.AurasImportantList[name] then
                                    unitFrame.auras[filter][i].border:SetSize(64,64);

                                    if stacks > 0 then
                                        unitFrame.auras[filter][i].border:SetTexture("Interface\\addons\\ClassicPlatesPlus\\media\\auras\\importantBorderStacks");
                                        unitFrame.auras[filter][i].highlight:SetTexture("Interface\\addons\\ClassicPlatesPlus\\media\\auras\\importantHighlightStacks");
                                    else
                                        unitFrame.auras[filter][i].border:SetTexture("Interface\\addons\\ClassicPlatesPlus\\media\\auras\\importantBorder");
                                        unitFrame.auras[filter][i].highlight:SetTexture("Interface\\addons\\ClassicPlatesPlus\\media\\auras\\importantHighlight");
                                    end

                                    -- Inserting frames for further sorting
                                    table.insert(unitFrame.auras.toSort["important_" .. filter], unitFrame.auras[filter][i]);
                                else
                                    unitFrame.auras[filter][i].border:SetSize(64,32);

                                    if stacks > 0 then
                                        unitFrame.auras[filter][i].border:SetTexture("Interface\\addons\\ClassicPlatesPlus\\media\\auras\\borderStacks");
                                    else
                                        unitFrame.auras[filter][i].border:SetTexture("Interface\\addons\\ClassicPlatesPlus\\media\\auras\\border");
                                    end

                                    -- Inserting frames for further sorting
                                    if markStealable then
                                        table.insert(unitFrame.auras.toSort["stealable_" .. filter], unitFrame.auras[filter][i]);
                                    else
                                        table.insert(unitFrame.auras.toSort[filter], unitFrame.auras[filter][i]);
                                    end
                                end

                                -- Scripts
                                local timeElapsed = 0;
                                unitFrame.auras[filter][i]:SetScript("OnUpdate", function(self, elapsed)
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
                                unitFrame.auras[filter][i]:Show();
                                unitFrame.auras[filter][i].highlight.animationGrp:Play();
                            elseif unitFrame.auras[filter][i] then
                                unitFrame.auras[filter][i]:Hide();
                                unitFrame.auras[filter][i].highlight.animationGrp:Stop();
                            end
                        elseif unitFrame.auras[filter][i] then
                            unitFrame.auras[filter][i]:Hide();
                            unitFrame.auras[filter][i].highlight.animationGrp:Stop();
                        else
                            break;
                        end
                    end
                end

                getAuras("helpful");
                getAuras("harmful");

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
                if UnitIsPlayer then
                    sortAuras(unitFrame.auras.toSort.important_helpful,   unitFrame.auras.sorted.helpful,   CFG.AurasPersonalMaxBuffs);
                    sortAuras(unitFrame.auras.toSort.helpful,             unitFrame.auras.sorted.helpful,   CFG.AurasPersonalMaxBuffs);
                    sortAuras(unitFrame.auras.toSort.important_harmful,   unitFrame.auras.sorted.harmful,   CFG.AurasPersonalMaxDebuffs);
                    sortAuras(unitFrame.auras.toSort.harmful,             unitFrame.auras.sorted.harmful,   CFG.AurasPersonalMaxDebuffs);
                elseif canAttack then
                    sortAuras(unitFrame.auras.toSort.important_helpful,   unitFrame.auras.sorted.helpful,   CFG.AurasMaxBuffsEnemy);
                    sortAuras(unitFrame.auras.toSort.stealable_helpful,   unitFrame.auras.sorted.helpful,   CFG.AurasMaxBuffsEnemy);
                    sortAuras(unitFrame.auras.toSort.helpful,             unitFrame.auras.sorted.helpful,   CFG.AurasMaxBuffsEnemy);
                    sortAuras(unitFrame.auras.toSort.important_harmful,   unitFrame.auras.sorted.harmful,   CFG.AurasMaxDebuffsEnemy);
                    sortAuras(unitFrame.auras.toSort.harmful,             unitFrame.auras.sorted.harmful,   CFG.AurasMaxDebuffsEnemy);
                else
                    sortAuras(unitFrame.auras.toSort.important_helpful,   unitFrame.auras.sorted.helpful,   CFG.AurasMaxBuffsFriendly);
                    sortAuras(unitFrame.auras.toSort.helpful,             unitFrame.auras.sorted.helpful,   CFG.AurasMaxBuffsFriendly);
                    sortAuras(unitFrame.auras.toSort.important_harmful,   unitFrame.auras.sorted.harmful,   CFG.AurasMaxDebuffsFriendly);
                    sortAuras(unitFrame.auras.toSort.harmful,             unitFrame.auras.sorted.harmful,   CFG.AurasMaxDebuffsFriendly);
                end

                ----------------------------------------
                -- Call to position auras
                ----------------------------------------
                func:PositionAuras(unitFrame, unit);

                ----------------------------------------
                -- Auras counter
                ----------------------------------------
                local function processAuras(counter, filter, maxAuras, pos1, pos2, x)
                    local totalAuras = #unitFrame.auras.toSort["important_" .. filter] + #unitFrame.auras.toSort[filter];

                    if totalAuras > maxAuras then
                        local sortedAuras = unitFrame.auras.sorted[filter];
                        local anchor = filter == "harmful" and sortedAuras[#sortedAuras] or filter == "helpful" and sortedAuras[1];

                        if UnitIsPlayer and filter == "helpful" then
                            anchor = sortedAuras[#sortedAuras];
                        end

                        counter:ClearAllPoints();
                        counter:SetPoint(pos1, anchor, pos2, x, 0);
                        counter:SetText("+" .. totalAuras - maxAuras);
                    end

                    counter:SetShown(CFG.AurasOverFlowCounter and totalAuras > maxAuras);
                end

                if UnitIsPlayer then
                    processAuras(unitFrame.buffsCounter, "helpful", CFG.AurasPersonalMaxBuffs, "left", "right", 5);
                    processAuras(unitFrame.debuffsCounter, "harmful", CFG.AurasPersonalMaxDebuffs, "left", "right", 5);
                elseif canAttack then
                    processAuras(unitFrame.buffsCounter, "helpful", CFG.AurasMaxBuffsEnemy, "right", "left", -5);
                    processAuras(unitFrame.debuffsCounter, "harmful", CFG.AurasMaxDebuffsEnemy, "left", "right", 5);
                else
                    processAuras(unitFrame.buffsCounter, "helpful", CFG.AurasMaxBuffsFriendly, "right", "left", -5);
                    processAuras(unitFrame.debuffsCounter, "harmful", CFG.AurasMaxDebuffsFriendly, "left", "right", 5);
                end

                -- Interact Icon
                func:InteractIcon(nameplate);
            end
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

        if unit then
            -- Get Anchor
            if data.isRetail and resourceOnTarget == "1" and unit and UnitIsUnit(unit, "target") and class then
                anchor = unitFrame.classPower;
            elseif not data.isRetail and unitFrame.classPower:IsVisible() then
                anchor = unitFrame.classPower;
            else
                anchor = unitFrame.name;
            end

            -- Position auras
            if unitFrame.auras and unitFrame.auras.sorted then
                -- helpful
                for k,v in ipairs(unitFrame.auras.sorted.helpful) do
                    if k == 1 then
                        if UnitIsUnit("player", unit) then
                            totalAuras = #unitFrame.auras.sorted.helpful;
                            totalGaps = #unitFrame.auras.sorted.helpful - 1;
                            anchor = unitFrame.healthbar;
                            y = 10 * CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile].PersonalNameplatesScale;
                            calc = -((auraWidth * totalAuras + gap * totalGaps) / 2 - 13.5);
                        else
                            y = 6;

                            if #unitFrame.auras.sorted.harmful > 0 then
                                totalAuras = #unitFrame.auras.sorted.helpful + #unitFrame.auras.sorted.harmful;
                                totalGaps = #unitFrame.auras.sorted.helpful + #unitFrame.auras.sorted.harmful - 2;
                                calc = -((auraWidth * totalAuras + gap * totalGaps) / 2 - 7);
                            else
                                totalAuras = #unitFrame.auras.sorted.helpful;
                                totalGaps = #unitFrame.auras.sorted.helpful - 1;
                                calc = -((auraWidth * totalAuras + gap * totalGaps) / 2 - 13.5);
                            end
                        end

                        pos1, pos2 = "bottom", "top";
                    else
                        anchor = unitFrame.auras.sorted.helpful[k - 1];
                        pos1, pos2, y = "left", "right", 0;
                        calc = gap;
                    end

                    v:ClearAllPoints();
                    v:SetPoint(pos1, anchor, pos2, calc, y);
                end

                -- harmful
                local totalHelpful = #unitFrame.auras.sorted.helpful;

                for k,v in ipairs(unitFrame.auras.sorted.harmful) do
                    if k == 1 then
                        totalAuras = #unitFrame.auras.sorted.harmful;
                        totalGaps = #unitFrame.auras.sorted.harmful - 1;
                        calc = -((auraWidth * totalAuras + gap * totalGaps ) / 2 - 13.5);

                        if UnitIsUnit("player", unit) then
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
                            if totalHelpful > 0 then
                                anchor = unitFrame.auras.sorted.helpful[totalHelpful];
                                pos1, pos2, y = "left", "right", 0;
                                calc = bigGap;
                            else
                                pos1, pos2, y = "bottom", "top", 6;
                            end
                        end
                    elseif #unitFrame.auras.sorted.harmful > 0 then
                        anchor = unitFrame.auras.sorted.harmful[k - 1];
                        pos1, pos2, y = "left", "right", 0;
                        calc = gap;
                    end

                    v:ClearAllPoints();
                    v:SetPoint(pos1, anchor, pos2, calc, y);
                end
            end
        end
    end
end