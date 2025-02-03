----------------------------------------
-- CORE
----------------------------------------
local myAddon, core = ...;
local func = core.func;
local data = core.data;

----------------------------------------
-- Auras
----------------------------------------
local AuraSize = { x = 32, y = 28 };

function func:HideAllAuras(unitframe)
    local function hideAuras(unitFrame, filter)
        if unitFrame.auras then

            unitFrame.buffsCounter:Hide();
            unitFrame.buffsCounter:Hide();

            for i = 1, 40 do
                if unitFrame.auras[filter][i] then
                    unitFrame.auras[filter][i]:Hide();
                    unitFrame.auras[filter][i].highlight.animationGrp:Stop();
                else
                    break;
                end
            end
        end
    end

    if unitframe then
        unitframe.buffsCounter:Hide();
        unitframe.buffsCounter:Hide();

        if unitframe.unit and not UnitIsUnit("player", unitframe.unit) then
            hideAuras(unitframe, "helpful");
            hideAuras(unitframe, "harmful");
        end
    else
        for _, nameplate in ipairs(C_NamePlate.GetNamePlates(false)) do
            local unitFrame = nameplate.unitFrame;
            local unit = nameplate.unitFrame.unit;

            if unit and not UnitIsUnit("player", unit) then
                hideAuras(unitFrame, "helpful");
                hideAuras(unitFrame, "harmful");
            end
        end
    end
end

function func:Update_Auras(unit)
    local CFG = CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile];

    if unit then
        local isNameplate = string.match(unit, "nameplate");
        local UnitIsPlayer = UnitIsUnit("player", unit);
        local UnitIsTarget = UnitIsUnit("target", unit);
        local UnitIsMyPet = UnitIsUnit("pet", unit);
        local canAttack = UnitCanAttack("player", unit);
        local nameplate, unitFrame;

        if UnitIsPlayer then
            nameplate = data.nameplate;
            unitFrame = nameplate;
        elseif isNameplate then
            nameplate = C_NamePlate.GetNamePlateForUnit(unit);
            unitFrame = nameplate and nameplate.unitFrame;
        end

        if nameplate and unitFrame then
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
                        if test and i < 10 then
                            local durationN =
                                   i <= 2 and 0
                                or i > 2 and i < 4 and 9
                                or 30;

                            aura = {
                                name = "Test aura " .. i,
                                icon = 1120721,
                                applications = durationN,
                                duration = durationN,
                                isHarmful = filter == "harmful",
                                isHelpful = filter == "helpful",
                                expirationTime = durationN + GetTime(),
                                sourceUnit = "player",
                                dispelName = "Curse",
                            }

                            if i == 1 or i == 2 then
                                aura.name = "Arcane Brilliance"
                            end
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
                            local dispelName = aura.dispelName;
                            local sourceIsPlayer = false;
                            local markStealable = CFG.MarkStealableAuras and isStealable;

                            if source then
                                sourceIsPlayer = UnitIsUnit("player", source);
                            end

                            -- Border Color
                            local r,g,b = 1,1,1;
                            if isHarmful then
                                if UnitIsPlayer then
                                    if dispelName then
                                        if dispelName == "Magic" then
                                            r = CFG.Auras_Personal_HarmfulBorderColor_Magic.r;
                                            g = CFG.Auras_Personal_HarmfulBorderColor_Magic.g;
                                            b = CFG.Auras_Personal_HarmfulBorderColor_Magic.b;
                                        elseif dispelName == "Curse" then
                                            r = CFG.Auras_Personal_HarmfulBorderColor_Curse.r;
                                            g = CFG.Auras_Personal_HarmfulBorderColor_Curse.g;
                                            b = CFG.Auras_Personal_HarmfulBorderColor_Curse.b;
                                        elseif dispelName == "Disease" then
                                            r = CFG.Auras_Personal_HarmfulBorderColor_Disease.r;
                                            g = CFG.Auras_Personal_HarmfulBorderColor_Disease.g;
                                            b = CFG.Auras_Personal_HarmfulBorderColor_Disease.b;
                                        elseif dispelName == "Poison" then
                                            r = CFG.Auras_Personal_HarmfulBorderColor_Poison.r;
                                            g = CFG.Auras_Personal_HarmfulBorderColor_Poison.g;
                                            b = CFG.Auras_Personal_HarmfulBorderColor_Poison.b;
                                        end
                                    else
                                        r = CFG.Auras_Personal_HarmfulBorderColor_Regular.r;
                                        g = CFG.Auras_Personal_HarmfulBorderColor_Regular.g;
                                        b = CFG.Auras_Personal_HarmfulBorderColor_Regular.b;
                                    end
                                else
                                    if dispelName then
                                        if dispelName == "Magic" then
                                            r = CFG.Auras_HarmfulBorderColor_Magic.r;
                                            g = CFG.Auras_HarmfulBorderColor_Magic.g;
                                            b = CFG.Auras_HarmfulBorderColor_Magic.b;
                                        elseif dispelName == "Curse" then
                                            r = CFG.Auras_HarmfulBorderColor_Curse.r;
                                            g = CFG.Auras_HarmfulBorderColor_Curse.g;
                                            b = CFG.Auras_HarmfulBorderColor_Curse.b;
                                        elseif dispelName == "Disease" then
                                            r = CFG.Auras_HarmfulBorderColor_Disease.r;
                                            g = CFG.Auras_HarmfulBorderColor_Disease.g;
                                            b = CFG.Auras_HarmfulBorderColor_Disease.b;
                                        elseif dispelName == "Poison" then
                                            r = CFG.Auras_HarmfulBorderColor_Poison.r;
                                            g = CFG.Auras_HarmfulBorderColor_Poison.g;
                                            b = CFG.Auras_HarmfulBorderColor_Poison.b;
                                        end
                                    else
                                        r = CFG.Auras_HarmfulBorderColor_Regular.r;
                                        g = CFG.Auras_HarmfulBorderColor_Regular.g;
                                        b = CFG.Auras_HarmfulBorderColor_Regular.b;
                                    end
                                end
                            end

                            if isHelpful then
                                if markStealable then
                                    r = CFG.AurasStealableBorderColor.r;
                                    g = CFG.AurasStealableBorderColor.g;
                                    b = CFG.AurasStealableBorderColor.b;
                                else
                                    r = CFG.AurasHelpfulBorderColor.r;
                                    g = CFG.AurasHelpfulBorderColor.g;
                                    b = CFG.AurasHelpfulBorderColor.b;
                                end
                            end

                            -- Filter
                            local function Settings_filter()
                                -- Check if aura is Blacklisted or Important
                                if data.settings.AurasBlacklist[name] then
                                    return false;
                                elseif data.settings.AurasImportantList[name] then
                                    return true;
                                end

                                -- Option: Show Only Important Auras
                                -- Since we already checked if aura is important, we can hide rest if this option is toggled.
                                if CFG.AurasShowOnlyImportant then
                                    return false;
                                end

                                -- Option: Buffs / Debuffs toggles
                                if UnitIsPlayer then
                                    if isHelpful and not CFG.BuffsPersonal then
                                        return false;
                                    end
                                    if isHarmful and not CFG.DebuffsPersonal then
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

                                -- Option: Passive Auras
                                if duration == 0 or not duration then
                                    if CFG.AurasHidePassive == 2 then
                                        return false;
                                    elseif CFG.AurasHidePassive == 3 and not sourceIsPlayer then
                                        return false;
                                    end
                                end

                                -- Option: Auras Source and ability to Dispel/Apply
                                if UnitIsPlayer then
                                    if isHelpful then
                                        if CFG.BuffsFilterPersonal == 2 and not sourceIsPlayer then
                                            return false;
                                        elseif CFG.BuffsFilterPersonal == 3 and not sourceIsPlayer and not isRaid then
                                            return false;
                                        end
                                    end
                                    if isHarmful then
                                        if CFG.DebuffsFilterPersonal == 2 and not isRaid then
                                            return false;
                                        end
                                    end
                                else
                                    if canAttack then
                                        if CFG.AurasFilterEnemy == 2 and not sourceIsPlayer then
                                            return false;
                                        end
                                    else
                                        if CFG.AurasFilterFriendly == 2 and not sourceIsPlayer then
                                            return false;
                                        elseif CFG.AurasFilterFriendly == 3 and not isRaid then
                                            return false;
                                        end
                                    end
                                end

                                -- Option: Group Filter
                                if not UnitIsPlayer and not UnitIsMyPet and not canAttack then
                                    local exclude = CFG.AurasGroupFilterExcludeTarget and UnitIsTarget;

                                    if CFG.AurasGroupFilter == 2 then
                                        if not UnitPlayerOrPetInParty(unit) and not exclude then
                                            return false;
                                        end
                                    elseif CFG.AurasGroupFilter == 3 then
                                        if not UnitPlayerOrPetInRaid(unit) and not exclude then
                                            return false;
                                        end
                                    elseif CFG.AurasGroupFilter == 4 then
                                        if not UnitPlayerOrPetInParty(unit) and not UnitPlayerOrPetInRaid(unit) and not exclude then
                                            return false;
                                        end
                                    end
                                end

                                -- Option: Show Auras Only On Target
                                if CFG.AurasOnTarget and not UnitIsTarget and not UnitIsPlayer then
                                    return false;
                                end

                                return true;
                            end

                            if Settings_filter() then
                                if not unitFrame.auras[filter][i] then
                                    ------------------------------------
                                    -- Main
                                    ------------------------------------
                                    unitFrame.auras[filter][i] = CreateFrame("frame", myAddon .. "_aurasList_" .. i, unitFrame);
                                    unitFrame.auras[filter][i]:SetFrameLevel(1);
                                    unitFrame.auras[filter][i]:SetIgnoreParentScale(true);

                                    ------------------------------------
                                    -- Firse level
                                    ------------------------------------
                                    unitFrame.auras[filter][i].first = CreateFrame("frame", nil, unitFrame.auras[filter][i]);
                                    unitFrame.auras[filter][i].first:SetPoint("center");
                                    unitFrame.auras[filter][i].first:SetFrameLevel(1);

                                    -- Highlight important
                                    unitFrame.auras[filter][i].highlight = unitFrame.auras[filter][i].first:CreateTexture();
                                    unitFrame.auras[filter][i].highlight:SetAllPoints();
                                    unitFrame.auras[filter][i].highlight:SetTexture("Interface\\addons\\ClassicPlatesPlus\\media\\auras\\importantHighlight2");

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
                                    unitFrame.auras[filter][i].mask:SetAllPoints();
                                    unitFrame.auras[filter][i].mask:SetTexture("Interface\\addons\\ClassicPlatesPlus\\media\\auras\\mask", "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE");

                                    -- Icon
                                    unitFrame.auras[filter][i].icon = unitFrame.auras[filter][i].first:CreateTexture();
                                    unitFrame.auras[filter][i].icon:SetPoint("center");
                                    unitFrame.auras[filter][i].icon:AddMaskTexture(unitFrame.auras[filter][i].mask);
                                    unitFrame.auras[filter][i].icon:SetDrawLayer("background", 1);

                                    -- Cooldown
                                    unitFrame.auras[filter][i].cooldown_wrap = CreateFrame("frame", nil, unitFrame.auras[filter][i].first);
                                    unitFrame.auras[filter][i].cooldown_wrap:SetPoint("center");
                                    unitFrame.auras[filter][i].cooldown_wrap:SetFrameLevel(1);
                                    unitFrame.auras[filter][i].cooldown = CreateFrame("Cooldown", nil, unitFrame.auras[filter][i].cooldown_wrap, "CooldownFrameTemplate");
                                    unitFrame.auras[filter][i].cooldown:SetAllPoints();
                                    unitFrame.auras[filter][i].cooldown:SetDrawEdge(true);
                                    unitFrame.auras[filter][i].cooldown:SetDrawBling(false);
                                    unitFrame.auras[filter][i].cooldown:SetSwipeColor(0, 0, 0, 0.6);
                                    unitFrame.auras[filter][i].cooldown:SetHideCountdownNumbers(true);
                                    unitFrame.auras[filter][i].cooldown:SetFrameLevel(1);

                                    ------------------------------------
                                    -- Second level
                                    ------------------------------------
                                    unitFrame.auras[filter][i].second = CreateFrame("frame", nil, unitFrame.auras[filter][i]);
                                    unitFrame.auras[filter][i].second:SetPoint("center");
                                    unitFrame.auras[filter][i].second:SetFrameLevel(2);

                                    -- Border
                                    unitFrame.auras[filter][i].border = unitFrame.auras[filter][i].second:CreateTexture();
                                    unitFrame.auras[filter][i].border:SetAllPoints();
                                    unitFrame.auras[filter][i].border:SetDrawLayer("border", 1);

                                    -- Countdown
                                    unitFrame.auras[filter][i].countdown = unitFrame.auras[filter][i].second:CreateFontString(nil, nil, "GameFontNormalOutline");

                                    -- Countdown shadow
                                    unitFrame.auras[filter][i].countdown_shadow = unitFrame.auras[filter][i].second:CreateTexture();
                                    unitFrame.auras[filter][i].countdown_shadow:SetPoint("center", unitFrame.auras[filter][i].countdown, -4, -4);
                                    unitFrame.auras[filter][i].countdown_shadow:SetTexture("Interface\\addons\\ClassicPlatesPlus\\media\\auras\\aurasShadow");
                                    unitFrame.auras[filter][i].countdown_shadow:SetAlpha(0.5);
                                    unitFrame.auras[filter][i].countdown_shadow:SetTexCoord(0, 1, 1, 0);
                                    unitFrame.auras[filter][i].countdown_shadow:SetDrawLayer("border", 2);

                                    -- Stacks
                                    unitFrame.auras[filter][i].stacks = unitFrame.auras[filter][i].second:CreateFontString(nil, nil, "GameFontNormalOutline");
                                    unitFrame.auras[filter][i].stacks:SetPoint("bottomRight", unitFrame.auras[filter][i], "bottomRight", 3, -2);
                                    unitFrame.auras[filter][i].stacks:SetJustifyH("right");

                                    -- Stacks shadow
                                    unitFrame.auras[filter][i].stacks_shadow = unitFrame.auras[filter][i].second:CreateTexture();
                                    unitFrame.auras[filter][i].stacks_shadow:SetPoint("center", unitFrame.auras[filter][i].stacks, -4, 4);
                                    unitFrame.auras[filter][i].stacks_shadow:SetTexture("Interface\\addons\\ClassicPlatesPlus\\media\\auras\\aurasShadow");
                                    unitFrame.auras[filter][i].stacks_shadow:SetAlpha(0.5);
                                    unitFrame.auras[filter][i].stacks_shadow:SetDrawLayer("border", 2);

                                    -- Mark
                                    unitFrame.auras[filter][i].mark = unitFrame.auras[filter][i].second:CreateTexture();
                                    unitFrame.auras[filter][i].mark:SetTexture("Interface\\addons\\ClassicPlatesPlus\\media\\icons\\mark3");
                                    unitFrame.auras[filter][i].mark:SetDrawLayer("artwork");
                                    unitFrame.auras[filter][i].mark:Hide();
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

                                -- Border
                                unitFrame.auras[filter][i].border:SetVertexColor(r,g,b);

                                -- Stacks
                                local showStacks = stacks > 0;
                                unitFrame.auras[filter][i].stacks:SetText("x" .. stacks);
                                unitFrame.auras[filter][i].stacks:SetShown(showStacks)
                                unitFrame.auras[filter][i].stacks_shadow:SetShown(showStacks)

                                -- Mark your own auras
                                unitFrame.auras[filter][i].mark:SetVertexColor(CFG.AurasMarkColor.r, CFG.AurasMarkColor.g, CFG.AurasMarkColor.b);
                                unitFrame.auras[filter][i].mark:SetShown(CFG.AurasMarkYours and sourceIsPlayer);
                                unitFrame.auras[filter][i].mark:ClearAllPoints();

                                -- Cooldown
                                unitFrame.auras[filter][i].cooldown:SetCooldown(GetTime() - (duration - (expirationTime - GetTime())), duration, timeMod);
                                unitFrame.auras[filter][i].cooldown:SetReverse(CFG.AurasReverseAnimation);

                                -- Icon
                                unitFrame.auras[filter][i].icon:SetTexture(icon);

                                -- Countdown
                                unitFrame.auras[filter][i].countdown:SetText(func:formatTime(expirationTime - GetTime()));
                                unitFrame.auras[filter][i].countdown:ClearAllPoints();
                                unitFrame.auras[filter][i].countdown:SetShown(CFG.AurasCountdown);
                                if CFG.AurasCountdownPosition == 1 then
                                    unitFrame.auras[filter][i].countdown:SetPoint("topRight", unitFrame.auras[filter][i], "topRight", 3, 2);
                                    unitFrame.auras[filter][i].countdown:SetJustifyH("right");
                                elseif CFG.AurasCountdownPosition == 2 then
                                    unitFrame.auras[filter][i].countdown:SetPoint("center", unitFrame.auras[filter][i]);
                                    unitFrame.auras[filter][i].countdown:SetJustifyH("center");
                                end
                                unitFrame.auras[filter][i].countdown_shadow:SetShown(CFG.AurasCountdown and duration > 0 and (expirationTime - GetTime()) > 0);

                                -- Highlight
                                unitFrame.auras[filter][i].highlight:SetVertexColor(r,g,b);
                                unitFrame.auras[filter][i].highlight:SetShown(CFG.AurasImportantHighlight and data.settings.AurasImportantList[name]);

                                -- Important auras adjustments
                                local first_x, first_y = 64, 32;
                                local second_x, second_y = 64, 32;
                                local icon_x, icon_y = 28, 28;
                                local cooldown_x, cooldown_y = 28, 24;
                                local mark_x, mark_y = 18, 13;
                                local shadow_x, shadow_y = 32, 28;

                                if data.settings.AurasImportantList[name] then
                                    -- Adjusting scale
                                    unitFrame.auras[filter][i]:SetSize(AuraSize.x * CFG.AurasImportantScale, AuraSize.y * CFG.AurasImportantScale);
                                    unitFrame.auras[filter][i].first:SetSize(first_x * CFG.AurasImportantScale, first_y * CFG.AurasImportantScale);
                                    unitFrame.auras[filter][i].second:SetSize(second_x * CFG.AurasImportantScale, second_y * CFG.AurasImportantScale);
                                    unitFrame.auras[filter][i].icon:SetSize(icon_x * CFG.AurasImportantScale, icon_y * CFG.AurasImportantScale);
                                    unitFrame.auras[filter][i].cooldown_wrap:SetSize(cooldown_x * CFG.AurasImportantScale, cooldown_y * CFG.AurasImportantScale);
                                    unitFrame.auras[filter][i].mark:SetSize(mark_x * CFG.AurasImportantScale, mark_y * CFG.AurasImportantScale);
                                    unitFrame.auras[filter][i].countdown_shadow:SetSize(shadow_x * CFG.AurasImportantScale, shadow_y * CFG.AurasImportantScale);
                                    unitFrame.auras[filter][i].stacks_shadow:SetSize(shadow_x * CFG.AurasImportantScale, shadow_y * CFG.AurasImportantScale);

                                    if CFG.AurasMarkLocation == 1 then
                                        unitFrame.auras[filter][i].mark:SetPoint("top", unitFrame.auras[filter][i], "topLeft", 3 * CFG.AurasImportantScale, 2.5 * CFG.AurasImportantScale);
                                    elseif CFG.AurasMarkLocation == 2 then
                                        unitFrame.auras[filter][i].mark:SetPoint("top", unitFrame.auras[filter][i], "bottomLeft", 6 * CFG.AurasImportantScale, 7 * CFG.AurasImportantScale);
                                    end

                                    unitFrame.auras[filter][i].stacks:SetScale(CFG.AurasImportantScale - 0.2);
                                    unitFrame.auras[filter][i].countdown:SetScale(CFG.AurasImportantScale - 0.2);

                                    unitFrame.auras[filter][i].border:SetTexture("Interface\\addons\\ClassicPlatesPlus\\media\\auras\\importantBorder2");

                                    -- Flags
                                    unitFrame.auras[filter][i].isImportant = true;

                                    -- Inserting frames for further sorting
                                    table.insert(unitFrame.auras.toSort["important_" .. filter], unitFrame.auras[filter][i]);
                                else
                                    -- Adjusting scale
                                    unitFrame.auras[filter][i]:SetSize(AuraSize.x * CFG.AurasScale, AuraSize.y * CFG.AurasScale);
                                    unitFrame.auras[filter][i].first:SetSize(first_x * CFG.AurasScale, first_y *- CFG.AurasScale);
                                    unitFrame.auras[filter][i].second:SetSize(second_x * CFG.AurasScale, second_y * CFG.AurasScale);
                                    unitFrame.auras[filter][i].icon:SetSize(icon_x * CFG.AurasScale, icon_y * CFG.AurasScale);
                                    unitFrame.auras[filter][i].cooldown_wrap:SetSize(cooldown_x * CFG.AurasScale, cooldown_y * CFG.AurasScale);
                                    unitFrame.auras[filter][i].mark:SetSize(mark_x * CFG.AurasScale, mark_y * CFG.AurasScale);
                                    unitFrame.auras[filter][i].countdown_shadow:SetSize(shadow_x * CFG.AurasScale, shadow_y * CFG.AurasScale);
                                    unitFrame.auras[filter][i].stacks_shadow:SetSize(shadow_x * CFG.AurasScale, shadow_y * CFG.AurasScale);

                                    if CFG.AurasMarkLocation == 1 then
                                        unitFrame.auras[filter][i].mark:SetPoint("top", unitFrame.auras[filter][i], "topLeft", 3 * CFG.AurasScale, 2.5 * CFG.AurasScale);
                                    elseif CFG.AurasMarkLocation == 2 then
                                        unitFrame.auras[filter][i].mark:SetPoint("top", unitFrame.auras[filter][i], "bottomLeft", 6 * CFG.AurasScale, 7 * CFG.AurasScale);
                                    end


                                    unitFrame.auras[filter][i].stacks:SetScale(CFG.AurasScale - 0.2);
                                    unitFrame.auras[filter][i].countdown:SetScale(CFG.AurasScale - 0.2);

                                    unitFrame.auras[filter][i].border:SetTexture("Interface\\addons\\ClassicPlatesPlus\\media\\auras\\border");

                                    -- Flags
                                    unitFrame.auras[filter][i].isImportant = false;

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

                                -- Flags
                                unitFrame.auras[filter][i].name = name;
                                unitFrame.auras[filter][i].type = filter;

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
                        local totalSorted = #sortedAuras;
                        local anchor = filter == "harmful" and sortedAuras[totalSorted] or filter == "helpful" and sortedAuras[1];

                        if UnitIsPlayer and filter == "helpful" then
                            anchor = sortedAuras[totalSorted];
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
        unit = unit or unitFrame.unit;

        if unit then
            local CFG = CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile];
            local resourceOnTarget = data.cvars.nameplateResourceOnTarget;
            local classFile = select(2, UnitClass("player"));
            local powerType = UnitPowerType("player");
            local isPlayer = UnitIsUnit("player", unit);
            local isTarget = UnitIsUnit(unit, "target");
            local class =
            classFile == "PALADIN"
            or classFile == "ROGUE"
            or classFile == "DEATHKNIGHT"
            or classFile == "WARLOCK"
            or classFile == "DRUID" and powerType == 3
            or classFile == "EVOKER"

            local function CountAuras(auras)
                local total = #auras;

                if total > 0 then
                    local count_important = 0;
                    local count_normal = 0;
                    local count_gaps = 0;

                    for i, aura in pairs(auras) do
                        if i then
                            if aura.isImportant then
                                count_important = count_important + 1;
                            else
                                count_normal = count_normal + 1;
                            end

                            count_gaps = count_gaps + 1
                        end
                    end

                    return count_normal, count_important, count_gaps - 1;
                else
                    return 0, 0, 0;
                end
            end

            if unit and unitFrame.auras and unitFrame.auras.sorted then
                local total_helpful = #unitFrame.auras.sorted.helpful;
                local helpful_normal, helpful_important, helpful_gaps = CountAuras(unitFrame.auras.sorted.helpful);

                local total_harmful = #unitFrame.auras.sorted.harmful;
                local harmful_normal, harmful_important, harmful_gaps = CountAuras(unitFrame.auras.sorted.harmful);

                local halfSize = AuraSize.x / -2;
                local gap_width = 3;
                local x_helpful, x_harmful;
                local anchor, pos1, pos2, y;

                if data.isRetail and resourceOnTarget == "1" and unit and isTarget and class then
                    anchor = unitFrame.classPower;
                elseif not data.isRetail and unitFrame.classPower:IsVisible() then
                    anchor = unitFrame.classPower;
                else
                    anchor = unitFrame.name;
                end

                if total_helpful > 0 then
                    for i, aura in ipairs(unitFrame.auras.sorted.helpful) do
                        if i == 1 then
                            if isPlayer then
                                anchor = unitFrame.healthbar;
                                local x = halfSize * (helpful_normal * CFG.AurasScale + helpful_important * CFG.AurasImportantScale);
                                local gaps = gap_width / -2 * helpful_gaps;

                                x_helpful = x + gaps;
                                y = 10 * CFG.PersonalNameplatesScale;
                            else
                                if total_harmful > 0 then
                                    local x1 = halfSize * (helpful_normal * CFG.AurasScale + helpful_important * CFG.AurasImportantScale);
                                    local x2 = halfSize * (harmful_normal * CFG.AurasScale + harmful_important * CFG.AurasImportantScale);
                                    local gaps = gap_width / -2 * (helpful_gaps + harmful_gaps) + gap_width * -1.5;

                                    x_helpful = x1 + x2 + gaps;
                                else
                                    local x = halfSize * (helpful_normal * CFG.AurasScale + helpful_important * CFG.AurasImportantScale);
                                    local gaps = gap_width / -2 * helpful_gaps;

                                    x_helpful = x + gaps;
                                end

                                y = 6;
                            end

                            pos1, pos2 = "bottomLeft", "top";
                        else
                            anchor = unitFrame.auras.sorted.helpful[i - 1];
                            x_helpful = gap_width;
                            y = 0;
                            pos1, pos2 = "BottomLeft", "BottomRight";
                        end

                        aura:ClearAllPoints();
                        aura:SetPoint(pos1, anchor, pos2, x_helpful, y);
                    end
                end

                if total_harmful > 0 then
                    for i, aura in ipairs(unitFrame.auras.sorted.harmful) do
                        if isPlayer then
                            if i == 1 then
                                pos1, pos2 = "topLeft", "bottom";
                                local x = halfSize * (harmful_normal * CFG.AurasScale + harmful_important * CFG.AurasImportantScale);
                                local gaps = gap_width / -2 * harmful_gaps;

                                x_harmful = x + gaps;

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
                                anchor = unitFrame.auras.sorted.harmful[i - 1];

                                x_harmful = gap_width;
                                y = 0;
                                pos1, pos2 = "topLeft", "topRight";
                            end
                        else
                            if i == 1 then
                                if total_helpful > 0 then
                                    anchor = unitFrame.auras.sorted.helpful[total_helpful];
                                    x_harmful = gap_width * 3;
                                    y = 0;

                                    pos1, pos2 = "bottomLeft", "bottomRight";
                                else
                                    local x = halfSize * (harmful_normal * CFG.AurasScale + harmful_important * CFG.AurasImportantScale);
                                    local gaps = gap_width / -2 * harmful_gaps;

                                    x_harmful = x + gaps;
                                    y = 6;
                                    pos1, pos2 = "bottomLeft", "top";
                                end
                            else
                                anchor = unitFrame.auras.sorted.harmful[i - 1];
                                x_harmful = gap_width;
                                y = 0;
                                pos1, pos2 = "bottomLeft", "bottomRight";
                            end
                        end

                        aura:ClearAllPoints();
                        aura:SetPoint(pos1, anchor, pos2, x_harmful, y);
                    end
                end
            end
        end
    end
end