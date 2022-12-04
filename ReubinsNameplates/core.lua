----------------------------------------
-- Core
----------------------------------------
local myAddon, core = ...

core.func = {};
core.data = {
    colors = {
        -- General
        blue = { r = 0.0, g = 0.75, b = 1 },
        green = { r = 0, g = 1, b = 0 },
        yellow = { r = 1, g = 0.90, b = 0 },
        orange = { r = 1, g = 0.5, b = 0 },
        red = { r = 1, g = 0, b = 0 },
        purple = { r = 1, g = 0.3, b = 1 },
        -- Name
        nameSelected = { r = 0.95, g = 0.95, b = 0 },
        nameMouseover = { r = 0.95, g = 0.95, b = 0},
        nameDefault = { r = 1, g = 1, b = 1},
        -- Border
        nameplateBorder = { r = 0.75, g = 0.60, b = 0.0 }
    },
    tanks = {},
    members = {},
    tickers = {},
    nameplates = {},
    isClassic = WOW_PROJECT_ID == WOW_PROJECT_CLASSIC;
};

local func = core.func;
local data = core.data;

----------------------------------------
-- Resize nameplates clickable base
----------------------------------------
function func:ResizeNameplates()
    local function resize()
        local inInstance, instanceType = IsInInstance();
        local scale = ReubinsNameplates_settings.NameplatesScale;

        if ReubinsNameplates_settings.Portrait then
            if inInstance and (instanceType == "party" or instanceType == "raid") then
                C_NamePlate.SetNamePlateFriendlySize(128, 30);
                C_NamePlate.SetNamePlateEnemySize(168 * scale, 54 * scale);
            else
                C_NamePlate.SetNamePlateFriendlySize(168 * scale, 54 * scale);
                C_NamePlate.SetNamePlateEnemySize(168 * scale, 54 * scale);
            end
        else
            if inInstance and (instanceType == "party" or instanceType == "raid") then
                C_NamePlate.SetNamePlateFriendlySize(128, 30);
                C_NamePlate.SetNamePlateEnemySize(136 * scale, 30 * scale);
            else
                C_NamePlate.SetNamePlateFriendlySize(136 * scale, 30 * scale);
                C_NamePlate.SetNamePlateEnemySize(136 * scale, 30 * scale);
            end
        end
    end

    if not InCombatLockdown() then
        resize();
    else
        if not data.tickers.frameOptions then
            data.tickers.frameOptions = C_Timer.NewTicker(1, function()
                if not InCombatLockdown() then
                    resize();
                    data.tickers.frameOptions:Cancel();
                end
            end)
        end
    end
end

----------------------------------------
-- Hooking NamePlateDriverFrame
----------------------------------------
-- Hiding default nameplates
hooksecurefunc(NamePlateDriverFrame,"OnNamePlateAdded", function(functions, unit)
    local nameplate = C_NamePlate.GetNamePlateForUnit(unit);

    if nameplate then
        local inInstance, instanceType = IsInInstance();

        if inInstance and (instanceType == "party" or instanceType == "raid") then
            if not UnitPlayerOrPetInParty(unit) then
                nameplate.UnitFrame:Hide();
            end
        else
            nameplate.UnitFrame:Hide();
        end
    end
end);

-- Resizing clickable base
hooksecurefunc(NamePlateDriverFrame,"ApplyFrameOptions", function(functions, nameplateFrame)
    func:ResizeNameplates()
end);

----------------------------------------
-- Tweaking CVars
----------------------------------------
function func:CVars(event)
    if event == "VARIABLES_LOADED" then
        SetCVar("nameplateSelectedScale", 1.15);
        SetCVar("nameplateTargetRadialPosition", 1);
        SetCVar("clampTargetNameplateToScreen", 1);
        SetCVar("nameplateNotSelectedAlpha", 0.5);
        SetCVar("NamePlateHorizontalScale", 1);
        SetCVar("nameplateOtherTopInset", 0.105);
    elseif event == "PLAYER_LOGOUT" then
        SetCVar("nameplateSelectedScale", 1);
        SetCVar("nameplateTargetRadialPosition", 0);
        SetCVar("clampTargetNameplateToScreen", 0);
        SetCVar("nameplateNotSelectedAlpha", 0.5);
        SetCVar("NamePlateHorizontalScale", 1);
        SetCVar("nameplateOtherTopInset", 0.08)
    end
end

----------------------------------------
-- Coloring names
----------------------------------------
function func:ColorName(unit)

    local function PaintNames(unit, unitFrame)
        if unit and unitFrame then
            if UnitIsPlayer(unit) then
                if IsGuildMember(unit) and UnitInParty(unit) then
                    unitFrame.name:SetTextColor(1, 0.75, 1);
                elseif UnitInParty(unit) then
                    unitFrame.name:SetTextColor(0, 0.9, 1);
                elseif IsGuildMember(unit) then
                    unitFrame.name:SetTextColor(0, 1, 0);
                else
                    unitFrame.name:SetTextColor(1, 1, 1);
                end
            elseif UnitIsFriend("player", unit) then
                unitFrame.name:SetTextColor(1, 1, 1);
            elseif UnitIsTapDenied(unit) then
                unitFrame.name:SetTextColor(0.5, 0.5, 0.5);
            else
                unitFrame.name:SetTextColor(1, 1, 1);
            end
        end
    end

    if unit then
        local nameplate = C_NamePlate.GetNamePlateForUnit(unit);
        if nameplate then
            PaintNames(unit, nameplate.unitFrame);
        end
    else
        local nameplates = C_NamePlate.GetNamePlates();
        if nameplates then
            for k,v in pairs(nameplates) do
                if k then
                    PaintNames(v.unitFrame.unit, v.unitframe);
                end
            end
        end
    end
end

----------------------------------------
-- Mouseover check
----------------------------------------
function func:MouseoverCheck(unitFrame)
    local border = data.colors.nameplateBorder;
    local nameDefault = data.colors.nameDefault;
    local nameMouseover = data.colors.nameMouseover;

    if not unitFrame.selected then
        local unit = unitFrame.unit;

        if unit then
            if UnitExists("mouseover") and UnitIsUnit("mouseover", unit) then
                unitFrame.name:SetTextColor(nameMouseover.r, nameMouseover.g, nameMouseover.b);
                unitFrame.border:SetVertexColor(border.r + 0.18, border.g + 0.18, border.b + 0.18);
                unitFrame.portrait.border:SetVertexColor(border.r + 0.18, border.g + 0.18, border.b + 0.18);
                unitFrame.powerbar.border:SetVertexColor(border.r + 0.18, border.g + 0.18, border.b + 0.18);
                unitFrame.threat.percentage.border:SetVertexColor(border.r + 0.18, border.g + 0.18, border.b + 0.18);
                unitFrame.healthbar_highlight:Show();
                unitFrame.mouseover = 1;
            else
                -- color name
                func:ColorName(unit);

                unitFrame.border:SetVertexColor(border.r, border.g, border.b);
                unitFrame.portrait.border:SetVertexColor(border.r, border.g, border.b);
                unitFrame.powerbar.border:SetVertexColor(border.r, border.g, border.b);
                unitFrame.threat.percentage.border:SetVertexColor(border.r, border.g, border.b);
                unitFrame.healthbar_highlight:Hide();
                unitFrame.mouseover = nil;
            end
        end
    end
end

----------------------------------------
-- Mouseover
----------------------------------------
function func:Mouseover()
    local border = data.colors.nameplateBorder;
    local nameDefault = data.colors.nameDefault;
    local nameMouseover = data.colors.nameMouseover;

    if UnitExists("mouseover") then
        local nameplate = C_NamePlate.GetNamePlateForUnit("mouseover");

        if nameplate then
            local unitFrame = nameplate.unitFrame;

            if not unitFrame.selected then
                if not unitFrame.mouseover then
                    unitFrame.name:SetTextColor(nameMouseover.r, nameMouseover.g, nameMouseover.b);
                    unitFrame.border:SetVertexColor(border.r + 0.18, border.g + 0.18, border.b + 0.18);
                    unitFrame.portrait.border:SetVertexColor(border.r + 0.18, border.g + 0.18, border.b + 0.18);
                    unitFrame.powerbar.border:SetVertexColor(border.r + 0.18, border.g + 0.18, border.b + 0.18);
                    unitFrame.threat.percentage.border:SetVertexColor(border.r + 0.18, border.g + 0.18, border.b + 0.18);
                    unitFrame.healthbar_highlight:Show(); 
                    unitFrame.mouseover = 1;
                else
                    local unit = unitFrame.unit;

                    -- color name
                    func:ColorName(unit);

                    unitFrame.border:SetVertexColor(border.r, border.g, border.b);
                    unitFrame.portrait.border:SetVertexColor(border.r, border.g, border.b);
                    unitFrame.powerbar.border:SetVertexColor(border.r, border.g, border.b);
                    unitFrame.threat.percentage.border:SetVertexColor(border.r, border.g, border.b);
                    unitFrame.healthbar_highlight:Hide();
                    unitFrame.mouseover = nil;
                end
            end
        end
    else
        local nameplates = C_NamePlate.GetNamePlates();

        if nameplates then
            for k,v in pairs(nameplates) do
                if k then
                    local unitFrame = v.unitFrame;

                    if unitFrame.mouseover and not unitFrame.selected then
                        -- color name
                        func:ColorName(unitFrame.unit);

                        unitFrame.border:SetVertexColor(border.r, border.g, border.b);
                        unitFrame.portrait.border:SetVertexColor(border.r, border.g, border.b);
                        unitFrame.powerbar.border:SetVertexColor(border.r, border.g, border.b);
                        unitFrame.threat.percentage.background:SetVertexColor(border.r, border.g, border.b);
                        unitFrame.healthbar_highlight:Hide();
                        unitFrame.mouseover = nil;
                    end
                end
            end
        end
    end
end

----------------------------------------
-- Unit selected
----------------------------------------
function func:Selected()
    local border = data.colors.nameplateBorder;
    local nameDefault = data.colors.nameDefault;
    local nameSelected = data.colors.nameSelected;
    local nameMouseover = data.colors.nameMouseover;

    local function setDefault(unitFrame)
        if not UnitExists("mouseover") then
            local unit = unitFrame.unit;

            -- color name
            func:ColorName(unit);

            unitFrame.border:SetVertexColor(border.r, border.g, border.b);
            unitFrame.portrait.border:SetVertexColor(border.r, border.g, border.b);
            unitFrame.powerbar.border:SetVertexColor(border.r, border.g, border.b);
            unitFrame.threat.percentage.border:SetVertexColor(border.r, border.g, border.b);
            unitFrame.healthbar_highlight:Hide();
            unitFrame.selected = nil;
            unitFrame.mouseover = nil;
        else
            unitFrame.name:SetTextColor(nameMouseover.r, nameMouseover.g, nameMouseover.b);
            unitFrame.border:SetVertexColor(border.r + 0.18, border.g + 0.18, border.b + 0.18);
            unitFrame.portrait.border:SetVertexColor(border.r + 0.18, border.g + 0.18, border.b + 0.18);
            unitFrame.powerbar.border:SetVertexColor(border.r + 0.18, border.g + 0.18, border.b + 0.18);
            unitFrame.threat.percentage.border:SetVertexColor(border.r + 0.18, border.g + 0.18, border.b + 0.18);
            unitFrame.healthbar_highlight:Show();
            unitFrame.selected = nil;
            unitFrame.mouseover = 1;
        end
    end

    local function setActive(unitFrame)
        unitFrame.name:SetTextColor(nameSelected.r, nameSelected.g, nameSelected.b);
        unitFrame.border:SetVertexColor(border.r + 0.18, border.g + 0.18, border.b + 0.18);
        unitFrame.portrait.border:SetVertexColor(border.r + 0.18, border.g + 0.18, border.b + 0.18);
        unitFrame.powerbar.border:SetVertexColor(border.r + 0.18, border.g + 0.18, border.b + 0.18);
        unitFrame.threat.percentage.border:SetVertexColor(border.r + 0.18, border.g + 0.18, border.b + 0.18);
        unitFrame.healthbar_highlight:Show();
        unitFrame.selected = 1;
    end

    local function reset()
        local nameplates = C_NamePlate.GetNamePlates();

        if nameplates then
            for k,v in pairs(nameplates) do
                if k then
                    local unitFrame = v.unitFrame;

                    if unitFrame.selected then
                        setDefault(unitFrame);
                    end
                end
            end
        end
    end

    if UnitExists("playertarget") then
        local nameplate = C_NamePlate.GetNamePlateForUnit("playertarget");

        if nameplate then
            local unitFrame = nameplate.unitFrame;

            if not data.selected then
                data.selected = unitFrame;

                setActive(unitFrame);
            else
                data.selectedPrev = data.selected;
                data.selected = unitFrame;

                if data.selected.unit == data.selectedPrev.unit then
                    setActive(data.selected);
                    data.selectedPrev = nil;
                else
                    setActive(data.selected);
                    setDefault(data.selectedPrev);
                end
            end
        else
            reset();
        end
    else
        reset();
    end
end

----------------------------------------
-- Format health
----------------------------------------
function func:Abbreviate_Health(unit, health)
    if unit and health then
        if isClassic then
            local member = UnitPlayerOrPetInParty(unit);
            local player = UnitIsPlayer(unit);
            local otherPlayersPet = UnitIsOtherPlayersPet(unit);

            if member or (not player and not otherPlayersPet) then
                return AbbreviateNumbers(health);
            else
                return AbbreviateNumbers(health) .. "%";
            end
        else
            return AbbreviateNumbers(health);
        end
    end
end

----------------------------------------
-- Update health
----------------------------------------
function func:Update_Health(unit)
    if unit then
        local nameplate = C_NamePlate.GetNamePlateForUnit(unit);

        if nameplate then
            local unitFrame = nameplate.unitFrame;
            local healthMax = UnitHealthMax(unit);
            local health = UnitHealth(unit);
            local healthNumber = func:Abbreviate_Health(unit, health);
            local healthPercent = string.format("%.0f", (health/healthMax)*100) .. "%";

            -- Putting stuff in it's places
            if ReubinsNameplates_settings.HealthPercentage and ReubinsNameplates_settings.HealthNumber then
                if ReubinsNameplates_settings.HealthPercentageSwitchPlaces then
                    unitFrame.health_left:SetText(healthNumber);
                    unitFrame.health_center:SetText(healthPercent);
                else
                    unitFrame.health_left:SetText(healthPercent);
                    unitFrame.health_center:SetText(healthNumber);
                end
            elseif ReubinsNameplates_settings.HealthNumber then
                unitFrame.health_left:SetText("");
                unitFrame.health_center:SetText(healthNumber);
            elseif ReubinsNameplates_settings.HealthPercentage then
                unitFrame.health_left:SetText("");
                unitFrame.health_center:SetText(healthPercent);
            else
                unitFrame.health_left:SetText("");
                unitFrame.health_center:SetText("");
            end

            -- Updating Health bar
            unitFrame.healthbar:SetMinMaxValues(0, healthMax);
            unitFrame.healthbar:SetValue(health);

            -- Hiding spark if health bar is full or empty
            if health <= 0 or health == healthMax then
                unitFrame.healthbar_spark:Hide();
            else
                unitFrame.healthbar_spark:Show();
            end
        end
    end
end

----------------------------------------
-- Update healthbar color
----------------------------------------
function func:Update_healthbar(unit)
    if unit then
        local nameplate = C_NamePlate.GetNamePlateForUnit(unit);

        if nameplate then
            local unitFrame = nameplate.unitFrame;
            local _, englishClass = UnitClass(unit);
            local color = RAID_CLASS_COLORS[englishClass];
            local player = UnitIsPlayer(unit);
            local isEnemy = UnitIsEnemy(unit, "player");
            local isFriend = UnitIsFriend(unit, "player");
            --local playersPet = UnitIsOtherPlayersPet(unit);

            if UnitIsTapDenied(unit) then
                if UnitIsFriend("player", unit) then
                    unitFrame.healthbar:SetStatusBarColor(UnitSelectionColor(unit));
                else
                    unitFrame.healthbar:SetStatusBarColor(0.9, 0.9, 0.9);
                end
            else
                if player then
                    if isEnemy then
                        if ReubinsNameplates_settings.EnemyHealthBarClassColors then
                            unitFrame.healthbar:SetStatusBarColor(color.r, color.g, color.b);
                        else
                            unitFrame.healthbar:SetStatusBarColor(UnitSelectionColor(unit));
                        end
                    end

                    if isFriend then
                        if ReubinsNameplates_settings.FriendlyHealthBarClassColors then
                            unitFrame.healthbar:SetStatusBarColor(color.r, color.g, color.b);
                        else
                            unitFrame.healthbar:SetStatusBarColor(UnitSelectionColor(unit));
                        end
                    end
                else
                    unitFrame.healthbar:SetStatusBarColor(UnitSelectionColor(unit));
                end
            end
        end
    end
end

----------------------------------------
-- Update powerbar
----------------------------------------
function func:Update_Powerbar(unit)
    if unit then
        local nameplate = C_NamePlate.GetNamePlateForUnit(unit);
        local borderColor = data.colors.nameplateBorder;

        if nameplate then
            local unitFrame = nameplate.unitFrame;
            local powerMax = UnitPowerMax(unit);
            local power = UnitPower(unit);
            local powerType, powerToken, altR, altG, altB = UnitPowerType(unit);
            local color = PowerBarColor[powerToken];

            -- Show or hide highlight
            -- If powerbar is shown
            if power and powerMax > 0 then
                if color then
                    unitFrame.powerbar.statusbar:SetStatusBarColor(color.r, color.g, color.b);
                end
                unitFrame.powerbar.statusbar:SetMinMaxValues(0, powerMax);
                unitFrame.powerbar.statusbar:SetValue(power);
                unitFrame.powerbar:SetShown(ReubinsNameplates_settings.Powerbar);
                unitFrame.powerbar.border:Show();
                -- Portrait is shown
                if ReubinsNameplates_settings.Portrait then
                    if ReubinsNameplates_settings.Powerbar then
                        unitFrame.highlight:SetTexture("Interface\\addons\\ReubinsNameplates\\media\\highlights\\widePower");
                    else
                        unitFrame.highlight:SetTexture("Interface\\addons\\ReubinsNameplates\\media\\highlights\\wide");
                    end
                -- Portrait is hidden
                else
                    if ReubinsNameplates_settings.Powerbar then
                        unitFrame.highlight:SetTexture("Interface\\addons\\ReubinsNameplates\\media\\highlights\\compactPower");
                    else
                        unitFrame.highlight:SetTexture("Interface\\addons\\ReubinsNameplates\\media\\highlights\\compact");
                    end
                end
            -- If powerbar is hidden
            else
                unitFrame.powerbar:Hide();
                unitFrame.powerbar.spark:Hide();
                unitFrame.powerbar.border:Hide();
                -- Portrait is shown
                if ReubinsNameplates_settings.Portrait then
                    unitFrame.highlight:SetTexture("Interface\\addons\\ReubinsNameplates\\media\\highlights\\wide");
                -- portrait is hidden
                else
                    unitFrame.highlight:SetTexture("Interface\\addons\\ReubinsNameplates\\media\\highlights\\compact");
                end
            end

            -- Hiding spark if bar is full or empty
            if power == powerMax or power <= 0 then
                unitFrame.powerbar.spark:Hide();
            else
                unitFrame.powerbar.spark:Show();
            end
        end
    end
end

----------------------------------------
-- Update portrait
----------------------------------------
function func:Update_Portrait(unit)
    if ReubinsNameplates_settings.Portrait then
        if unit then
            local nameplate = C_NamePlate.GetNamePlateForUnit(unit);

            if nameplate then
                local unitFrame = nameplate.unitFrame;
                local player = UnitIsPlayer(unit);
                local isEnemy = UnitIsEnemy(unit, "player");
                local isFriend = UnitIsFriend(unit, "player");

                local function setClassIcon()
                    local _, class = UnitClass(unit);

                    if class then
                        unitFrame.portrait.texture:SetTexture("Interface\\addons\\ReubinsNameplates\\media\\classes\\" .. class);
                    end
                end

                if player then
                    if ReubinsNameplates_settings.EnemyClassIcons then
                        if isEnemy then
                            setClassIcon();
                        end
                    else
                        if isEnemy then
                            SetPortraitTexture(unitFrame.portrait.texture, unit);
                        end
                    end

                    if ReubinsNameplates_settings.FriendlyClassIcons then
                        if isFriend then
                            setClassIcon();
                        end
                    else
                        if isFriend then
                            SetPortraitTexture(unitFrame.portrait.texture, unit);
                        end
                    end
                else
                    SetPortraitTexture(unitFrame.portrait.texture, unit);
                end
            end
        end
    end
end

----------------------------------------
-- Update name
----------------------------------------
function func:Update_Name(unit)
    if unit then
        local nameplate = C_NamePlate.GetNamePlateForUnit(unit);

        if nameplate then
            local unitFrame = nameplate.unitFrame;

            unitFrame.name:SetText(GetUnitName(unit, false));
        end
    end
end

----------------------------------------
-- Update level
----------------------------------------
function func:Update_Level(unit)
    if unit then
        local nameplate = C_NamePlate.GetNamePlateForUnit(unit);

        if nameplate then
            local unitFrame = nameplate.unitFrame;
            local effectiveLevel = UnitLevel(unit);
            local color = GetCreatureDifficultyColor(effectiveLevel);

            if effectiveLevel > 0 then
                unitFrame.level:SetTextColor(color.r, color.g, color.b);
                unitFrame.level:SetText(effectiveLevel);
                unitFrame.level:Show();
                unitFrame.high_level_texture:Hide();
            else
                unitFrame.level:Hide();
                unitFrame.high_level_texture:Show();
            end
        end
    end
end

----------------------------------------
-- Update classification
----------------------------------------
function func:Update_Classification(unit)
    if unit then
        local nameplate = C_NamePlate.GetNamePlateForUnit(unit);

        if nameplate then
            local unitFrame = nameplate.unitFrame;
            local classification = UnitClassification(unit);

            local function SetClassification()
                if classification == "rareelite"
                or classification == "elite"
                or classification == "worldboss"
                or classification == "rare"
                then
                    if ReubinsNameplates_settings.Portrait then
                        unitFrame.classification:SetTexture("Interface\\addons\\ReubinsNameplates\\media\\classifications\\" .. classification);
                    else
                        unitFrame.classification:SetTexture("Interface\\addons\\ReubinsNameplates\\media\\classifications\\compact" .. classification);
                    end
                    unitFrame.classification:SetShown(ReubinsNameplates_settings.Classification);
                else
                    unitFrame.classification:Hide();
                end
            end

            if classification then
                SetClassification();
            else
                if not unitFrame.classification.ticker then
                    unitFrame.classification.ticker = C_Timer.NewTicker(0.2, function()
                        if classification then
                            SetClassification();
                            unitFrame.classification.ticker:Cancel();
                        end
                    end);
                end
            end
        end
    end
end

----------------------------------------
-- PVP flags
----------------------------------------
function func:Update_PVP_Flag(unit)
    if unit then
        local nameplate = C_NamePlate.GetNamePlateForUnit(unit);

        if nameplate then
            local unitFrame = nameplate.unitFrame;
            local isFreeForAll = UnitIsPVPFreeForAll(unit);
            local flaggedPVP = UnitIsPVP(unit);

            if isFreeForAll then
                unitFrame.pvp_flag:SetTexture("Interface\\addons\\ReubinsNameplates\\media\\icons\\ffa");
                unitFrame.pvp_flag:Show();
            elseif flaggedPVP then
                local faction = UnitFactionGroup(unit);

                if faction then
                    unitFrame.pvp_flag:SetTexture("Interface\\addons\\ReubinsNameplates\\media\\icons\\" .. faction);
                    unitFrame.pvp_flag:Show();
                else
                    unitFrame.pvp_flag:Hide();
                end
            else
                unitFrame.pvp_flag:Hide();
            end
        end
    end
end

----------------------------------------
-- highlight (updates 10/sec)
----------------------------------------
function func:Highlight(unitFrame)
    local unit = unitFrame.unit;

    if unit then
        if UnitIsUnit(unit .. "target", "player") then
            if UnitIsEnemy(unit, "player") or not UnitIsPlayer(unit) then
                if not ReubinsNameplates_settings.TankMode then
                    unitFrame.highlight:SetVertexColor(1, 0, 0);
                else
                    unitFrame.highlight:SetVertexColor(0, 1, 0);
                end
                unitFrame.highlight:Show();
            else
                unitFrame.highlight:Hide();
            end
        else
            unitFrame.highlight:Hide();
        end
    end
end

----------------------------------------
-- Assign tanks & members
----------------------------------------
function func:Update_Roster()
    local unit;

    -- Reseting tables
    data.tanks = {};
    data.members = {};

    for i = 1, GetNumGroupMembers() do

        -- Getting unit's IDs
        if IsInRaid() then
            unit = "raid" .. i;
        elseif IsInGroup() then
            unit = "party" .. i;
        end

        if UnitExists(unit) then
            if not UnitIsUnit(unit, "player") then -- Excluding ourselves
                -- if unit is a tank
                if GetPartyAssignment("MainTank", unit, true) then
                    data.tanks[UnitName(unit)] = UnitName(unit);
                -- If unit is a member
                else
                    data.members[UnitName(unit)] = UnitName(unit);
                end
            end
        end
    end
end

----------------------------------------
-- Settings - Blacklisted auras
----------------------------------------
function func:Hotkeys_Pressed(key, down)
    if (key == "LSHIFT" or key == "RSHIFT") and IsControlKeyDown()
    or (key == "LCTRL" or key == "RCTRL") and IsShiftKeyDown() then
        local nameplates = C_NamePlate.GetNamePlates();

        if nameplates then
            for k,v in pairs(nameplates) do
                if k then
                    for i = 1, 40 do
                        if v.unitFrame.auras[i] then
                            if down == 1 then
                                v.unitFrame.auras[i].main:EnableMouse(true);
                            else
                                v.unitFrame.auras[i].main:EnableMouse(false);
                            end
                        end
                    end
                end
            end
        end
    end
end

----------------------------------------
-- Settings - Blacklisted auras
----------------------------------------
function func:BlacklistedAuras()
    local BLAurasScrollFrame = data.BLAurasScrollFrame;
    local BLAurasScrollChild = data.BLAurasScrollChild;

    data.blacklistedAuras = {};
    for k,v in pairs(ReubinsNameplates_settings.AurasBlacklist) do
        if k then
            table.insert(data.blacklistedAuras, v);
        end
    end

    local function anchor(k)
        if k == 1 then
            return "topLeft";
        else
            return "topLeft", BLAurasScrollChild.auras[k - 1], "BottomLeft";
        end
    end

    for k,v in ipairs(data.blacklistedAuras) do
        if k then
            -- Frames
            if not BLAurasScrollChild.auras[k] then
                BLAurasScrollChild.auras[k] = CreateFrame("frame", nil, BLAurasScrollChild);
                BLAurasScrollChild.auras[k]:SetPoint(anchor(k));
                BLAurasScrollChild.auras[k]:SetSize(BLAurasScrollChild:GetWidth() - 16, 30);

                BLAurasScrollChild.auras[k].icon = BLAurasScrollChild:CreateTexture();
                BLAurasScrollChild.auras[k].icon:SetParent(BLAurasScrollChild.auras[k]);
                BLAurasScrollChild.auras[k].icon:SetPoint("left", 6, 0);
                BLAurasScrollChild.auras[k].icon:SetTexture(v.icon);
                BLAurasScrollChild.auras[k].icon:SetSize(24, 24);

                BLAurasScrollChild.auras[k].name = BLAurasScrollChild:CreateFontString(nil, "overlay", "GameFontNormal");
                BLAurasScrollChild.auras[k].name:SetParent(BLAurasScrollChild.auras[k]);
                BLAurasScrollChild.auras[k].name:SetPoint("left", 40, 0);
                BLAurasScrollChild.auras[k].name:SetWidth(172);
                BLAurasScrollChild.auras[k].name:SetJustifyH("left");
                BLAurasScrollChild.auras[k].name:SetText(v.name);

                BLAurasScrollChild.auras[k].AddRemove = CreateFrame("button", nil, BLAurasScrollChild.auras[k]);
                BLAurasScrollChild.auras[k].AddRemove:SetSize(20, 20);
                BLAurasScrollChild.auras[k].AddRemove:SetPoint("right", -6, 0);
                BLAurasScrollChild.auras[k].AddRemove:SetNormalTexture("Interface\\Buttons\\UI-MinusButton-Up");
                BLAurasScrollChild.auras[k].AddRemove:SetPushedTexture("Interface\\Buttons\\UI-MinusButton-Down");
                BLAurasScrollChild.auras[k].AddRemove:SetHighlightTexture("Interface\\Buttons\\UI-PlusButton-Hilight");

                BLAurasScrollChild.auras[k].background = BLAurasScrollChild:CreateTexture();
                BLAurasScrollChild.auras[k].background:SetParent(BLAurasScrollChild.auras[k]);
                BLAurasScrollChild.auras[k].background:SetAllPoints();
                BLAurasScrollChild.auras[k].background:SetColorTexture(1, 0.82, 0, 0.1);
                BLAurasScrollChild.auras[k].background:SetDrawLayer("background", 1);
                BLAurasScrollChild.auras[k].background:Hide();

                BLAurasScrollChild.auras[k].highlight = BLAurasScrollChild:CreateTexture();
                BLAurasScrollChild.auras[k].highlight:SetParent(BLAurasScrollChild.auras[k]);
                BLAurasScrollChild.auras[k].highlight:SetAllPoints();
                BLAurasScrollChild.auras[k].highlight:SetColorTexture(1, 0, 0, 0.1);
                BLAurasScrollChild.auras[k].highlight:SetBlendMode("add");
                BLAurasScrollChild.auras[k].highlight:SetDrawLayer("background", 2);
                BLAurasScrollChild.auras[k].highlight:Hide();
            else
                BLAurasScrollChild.auras[k]:SetParent(BLAurasScrollChild);
                BLAurasScrollChild.auras[k]:SetPoint(anchor(k));
                BLAurasScrollChild.auras[k]:SetSize(BLAurasScrollChild:GetWidth() - 16, 30);

                BLAurasScrollChild.auras[k].icon:SetParent(BLAurasScrollChild.auras[k]);
                BLAurasScrollChild.auras[k].icon:SetPoint("left", 6, 0);
                BLAurasScrollChild.auras[k].icon:SetTexture(v.icon);
                BLAurasScrollChild.auras[k].icon:SetSize(24, 24);

                BLAurasScrollChild.auras[k].name:SetParent(BLAurasScrollChild.auras[k]);
                BLAurasScrollChild.auras[k].name:SetPoint("left", 40, 0);
                BLAurasScrollChild.auras[k].name:SetTextColor(1, 0.82, 0);
                BLAurasScrollChild.auras[k].name:SetText(v.name);

                BLAurasScrollChild.auras[k].AddRemove:SetParent(BLAurasScrollChild.auras[k]);
                BLAurasScrollChild.auras[k].AddRemove:SetPoint("right", -6, 0);
                BLAurasScrollChild.auras[k].AddRemove:SetHighlightTexture("Interface\\Buttons\\UI-PlusButton-Hilight");
                BLAurasScrollChild.auras[k].AddRemove:SetNormalTexture("Interface\\Buttons\\UI-MinusButton-Up");
                BLAurasScrollChild.auras[k].AddRemove:SetPushedTexture("Interface\\Buttons\\UI-MinusButton-Down");

                BLAurasScrollChild.auras[k].background:SetParent(BLAurasScrollChild.auras[k]);
                BLAurasScrollChild.auras[k].background:SetAllPoints();
                BLAurasScrollChild.auras[k].background:SetColorTexture(1, 0.82, 0, 0.1);
                BLAurasScrollChild.auras[k].background:Hide();

                BLAurasScrollChild.auras[k].highlight:SetParent(BLAurasScrollChild.auras[k]);
                BLAurasScrollChild.auras[k].highlight:SetAllPoints();
                BLAurasScrollChild.auras[k].highlight:Hide();
            end
            BLAurasScrollChild.auras[k]:Show();

            -- Scripts
            BLAurasScrollChild.auras[k]:SetScript("OnEnter", function()
                BLAurasScrollChild.auras[k].mouseOver = true;
                BLAurasScrollChild.auras[k].background:Show();
                if BLAurasScrollChild.auras[k].selected then
                    BLAurasScrollChild.auras[k].highlight:Show();
                else
                    BLAurasScrollChild.auras[k].highlight:Hide();
                end
            end);

            BLAurasScrollChild.auras[k]:SetScript("OnLeave", function()
                BLAurasScrollChild.auras[k].mouseOver = false;
                BLAurasScrollChild.auras[k].background:Hide();
                BLAurasScrollChild.auras[k].highlight:Hide();
                if BLAurasScrollChild.auras[k].selected then
                    BLAurasScrollChild.auras[k].background:Show();
                else
                    BLAurasScrollChild.auras[k].background:Hide();
                end
            end);

            BLAurasScrollChild.auras[k].AddRemove:SetScript("OnEnter", function()
                BLAurasScrollChild.auras[k].mouseOver = true;
                BLAurasScrollChild.auras[k].background:Show();
                if BLAurasScrollChild.auras[k].selected then
                    BLAurasScrollChild.auras[k].highlight:Show();
                else
                    BLAurasScrollChild.auras[k].highlight:Hide();
                end
            end);

            BLAurasScrollChild.auras[k].AddRemove:SetScript("OnLeave", function()
                BLAurasScrollChild.auras[k].mouseOver = false;
                BLAurasScrollChild.auras[k].highlight:Hide();
                if BLAurasScrollChild.auras[k].selected then
                    BLAurasScrollChild.auras[k].background:Show();
                else
                    BLAurasScrollChild.auras[k].background:Hide();
                end
            end);

            BLAurasScrollChild.auras[k].selected = false;
            BLAurasScrollChild.auras[k].AddRemove:SetScript("OnClick", function()
                if not data.removeFromBlacklist[v.spellID] then
                    data.removeFromBlacklist[v.spellID] = v.spellID;
                    BLAurasScrollChild.auras[k].background:SetColorTexture(1, 0, 0, 0.1);
                    BLAurasScrollChild.auras[k].background:Show();
                    BLAurasScrollChild.auras[k].name:SetTextColor(1,0,0);
                    BLAurasScrollChild.auras[k].AddRemove:SetNormalTexture("Interface\\Buttons\\UI-PlusButton-Up");
                    BLAurasScrollChild.auras[k].AddRemove:SetPushedTexture("Interface\\Buttons\\UI-PlusButton-Down");
                    BLAurasScrollChild.auras[k].selected = true;
                    BLAurasScrollChild.auras[k].removed = true;
                else
                    data.removeFromBlacklist[v.spellID] = nil;
                    BLAurasScrollChild.auras[k].background:SetColorTexture(1, 0.82, 0, 0.1);
                    BLAurasScrollChild.auras[k].background:Show();
                    BLAurasScrollChild.auras[k].name:SetTextColor(1, 0.82, 0);
                    BLAurasScrollChild.auras[k].AddRemove:SetNormalTexture("Interface\\Buttons\\UI-MinusButton-Up");
                    BLAurasScrollChild.auras[k].AddRemove:SetPushedTexture("Interface\\Buttons\\UI-MinusButton-Down");
                    BLAurasScrollChild.auras[k].selected = false;
                    BLAurasScrollChild.auras[k].removed = false;
                end
                if BLAurasScrollChild.auras[k].mouseOver and BLAurasScrollChild.auras[k].selected then
                    BLAurasScrollChild.auras[k].highlight:Show();
                else
                    BLAurasScrollChild.auras[k].highlight:Hide();
                end
            end);
        end
    end

    -- Note
    if #data.blacklistedAuras == 0 then
        if not BLAurasScrollFrame.note1 then
            BLAurasScrollFrame.note1 = BLAurasScrollFrame:CreateFontString(nil, "overlay", "GameFontHighlightLarge");
            BLAurasScrollFrame.note1:SetParent(BLAurasScrollFrame);
            BLAurasScrollFrame.note1:SetPoint("center", 0, 60);
            BLAurasScrollFrame.note1:SetWidth(172);
            BLAurasScrollFrame.note1:SetJustifyH("center");
            BLAurasScrollFrame.note1:SetSpacing(2);
            BLAurasScrollFrame.note1:SetAlpha(0.33);
            BLAurasScrollFrame.note1:SetText("Blacklisted auras will appear here.");
            BLAurasScrollFrame.note1:Show();

            BLAurasScrollFrame.note2 = BLAurasScrollFrame:CreateFontString(nil, "overlay", "GameFontNormal");
            BLAurasScrollFrame.note2:SetParent(BLAurasScrollFrame);
            BLAurasScrollFrame.note2:SetPoint("center");
            BLAurasScrollFrame.note2:SetWidth(200);
            BLAurasScrollFrame.note2:SetJustifyH("center");
            BLAurasScrollFrame.note2:SetSpacing(2);
            BLAurasScrollFrame.note2:SetAlpha(0.66);
            BLAurasScrollFrame.note2:SetText("Hold SHIFT + CTRL and left-click on the aura above nameplate to blacklist it.");
            BLAurasScrollFrame.note2:Show();
        else
            BLAurasScrollFrame.note1:SetParent(BLAurasScrollFrame);
            BLAurasScrollFrame.note1:SetPoint("center", 0, 60);
            BLAurasScrollFrame.note1:Show();

            BLAurasScrollFrame.note2:SetParent(BLAurasScrollFrame);
            BLAurasScrollFrame.note2:SetPoint("center");
            BLAurasScrollFrame.note2:Show();
        end
    else
        if BLAurasScrollFrame.note1 then
            BLAurasScrollFrame.note1:Hide();
            BLAurasScrollFrame.note2:Hide();
        end
    end
end

----------------------------------------
-- Castbar start
----------------------------------------
function func:Castbar_Start(event, unit)
    if unit then
        local nameplate = C_NamePlate.GetNamePlateForUnit(unit);

        if nameplate then
            local castbar = nameplate.unitFrame.castbar;
            local name, text, icon, startTimeMS, endTimeMS, isTradeSkill, notInterruptible, minValue, maxValue, reverser;

            if event then
                if event == "UNIT_SPELLCAST_START" then
                    name, text, icon, startTimeMS, endTimeMS, isTradeSkill, _, notInterruptible = UnitCastingInfo(unit);
                    minValue = -(endTimeMS - startTimeMS) / 1000;
                    maxValue = 0;
                    reverser = -1;
                    castbar.statusbar:SetStatusBarColor(data.colors.orange.r, data.colors.orange.g, data.colors.orange.b);
                elseif event == "UNIT_SPELLCAST_CHANNEL_START" then
                    name, text, icon, startTimeMS, endTimeMS, isTradeSkill, notInterruptible = UnitChannelInfo(unit);
                    minValue = 0;
                    maxValue = (endTimeMS - startTimeMS) / 1000;
                    reverser = 1;
                    castbar.statusbar:SetStatusBarColor(data.colors.purple.r, data.colors.purple.g, data.colors.purple.b);
                end
            else
                local name1, text1, icon1, startTimeMS1, endTimeMS1, isTradeSkill1, _, notInterruptible1 = UnitCastingInfo(unit);
                local name2, text2, icon2, startTimeMS2, endTimeMS2, isTradeSkill2, notInterruptible2 = UnitChannelInfo(unit);

                if name1 then
                    name, text, icon, startTimeMS, endTimeMS, isTradeSkill, _, notInterruptible = name1, text1, icon1, startTimeMS1, endTimeMS1, isTradeSkill1, notInterruptible1;
                    minValue = -(endTimeMS - startTimeMS) / 1000;
                    maxValue = 0;
                    reverser = -1;
                    castbar.statusbar:SetStatusBarColor(data.colors.orange.r, data.colors.orange.g, data.colors.orange.b);
                elseif name2 then
                    name, text, icon, startTimeMS, endTimeMS, isTradeSkill, notInterruptible = name2, text2, icon2, startTimeMS2, endTimeMS2, isTradeSkill2, notInterruptible2;
                    minValue = 0;
                    maxValue = (endTimeMS - startTimeMS) / 1000;
                    reverser = 1;
                    castbar.statusbar:SetStatusBarColor(data.colors.purple.r, data.colors.purple.g, data.colors.purple.b);
                end
            end

            if text then
                if isTradeSkill then
                    castbar.border:SetTexture("Interface\\addons\\ReubinsNameplates\\media\\castbar\\castbar");
                elseif notInterruptible then
                    castbar.border:SetTexture("Interface\\addons\\ReubinsNameplates\\media\\castbar\\castbarUI2");
                else
                    castbar.border:SetTexture("Interface\\addons\\ReubinsNameplates\\media\\castbar\\castbar");
                end

                if text:len() >= 18 then
                    castbar.name:SetText(text:sub(1,18) .. "...");
                else
                    castbar.name:SetText(text);
                end

                castbar.countdown:Show();
                castbar.name:SetTextColor(1,1,1);
                castbar.icon:SetTexture(icon);
                castbar.border:SetVertexColor(0.75, 0.75, 0.75);
                castbar.statusbar:SetMinMaxValues(minValue, maxValue);

                local timeElapsed = 0;
                castbar:SetScript("OnUpdate", function(self, elapsed)
                    timeElapsed = timeElapsed + elapsed;
                    if not castbar.animation:IsPlaying() then
                        castbar.statusbar:SetValue(reverser * ((endTimeMS / 1000) - GetTime()));
                    end

                    if timeElapsed > 0.1 then
                        local value = (endTimeMS / 1000) - GetTime();
                        timeElapsed = 0;
                        if value >= 10 then
                            castbar.countdown:SetText(string.format("%.0f", value));
                        elseif value < 10 and value > 0 then
                            castbar.countdown:SetText(string.format("%.1f", value));
                        else
                            castbar.countdown:SetText("");
                        end
                    end
                end);

                if castbar.animation:IsPlaying() then
                    castbar.animation:Stop();
                end

                castbar:Show();
            end
        end
    end
end

----------------------------------------
-- Castbar end
----------------------------------------
function func:Castbar_End(event, unit)
    if unit then
        local nameplate = C_NamePlate.GetNamePlateForUnit(unit);

        if nameplate then
            local castbar = nameplate.unitFrame.castbar;
            local channelName = UnitChannelInfo(unit);

            if event == "UNIT_SPELLCAST_FAILED"
            or event == "UNIT_SPELLCAST_FAILED_QUIET"
            or event == "UNIT_SPELLCAST_INTERRUPTED" then
                castbar.statusbar:SetStatusBarColor(data.colors.red.r, data.colors.red.g, data.colors.red.b);
                castbar.border:SetVertexColor(data.colors.red.r, data.colors.red.g, data.colors.red.b);
                castbar.name:SetTextColor(data.colors.orange.r, data.colors.orange.g, data.colors.orange.b);
                castbar.statusbar:SetValue(0);
            end

            if event == "UNIT_SPELLCAST_SUCCEEDED" and not channelName then
                castbar.statusbar:SetStatusBarColor(data.colors.green.r, data.colors.green.g, data.colors.green.b);
                castbar.border:SetVertexColor(data.colors.green.r, data.colors.green.g, data.colors.green.b);
                castbar.name:SetTextColor(data.colors.yellow.r, data.colors.yellow.g, data.colors.yellow.b);
                castbar.statusbar:SetValue(0);
            end

            if event == "UNIT_SPELLCAST_STOP"
            or event == "UNIT_SPELLCAST_CHANNEL_STOP" then
                if castbar.animation:IsPlaying() then
                    castbar.animation:Restart();
                else
                    castbar.animation:Play();
                end
                castbar.countdown:Hide();
            end
        end
    end
end

----------------------------------------
-- Raid target index
----------------------------------------
function func:RaidTargetIndex()
    local nameplates = C_NamePlate.GetNamePlates();

    if nameplates then
        for k,v in pairs(nameplates) do
            if k then
                local raidTarget = v.unitFrame.raidTarget;
                local unit = v.unitFrame.unit;
                local mark = GetRaidTargetIndex(unit);

                if mark then
                    local texture;

                    if     mark == 1 then texture = "UI-RaidTargetingIcon_1";
                    elseif mark == 2 then texture = "UI-RaidTargetingIcon_2";
                    elseif mark == 3 then texture = "UI-RAIDTARGETINGICON_3";
                    elseif mark == 4 then texture = "UI-RaidTargetingIcon_4";
                    elseif mark == 5 then texture = "UI-RaidTargetingIcon_5";
                    elseif mark == 6 then texture = "UI-RaidTargetingIcon_6";
                    elseif mark == 7 then texture = "UI-RaidTargetingIcon_7";
                    elseif mark == 8 then texture = "UI-RaidTargetingIcon_8";
                    end

                    raidTarget.markPrev = raidTarget.mark;
                    raidTarget.mark = mark;
                    raidTarget.icon:SetTexture("interface\\TARGETINGFRAME\\" .. texture);
                    raidTarget:Show();

                    local function play()
                        if raidTarget.animation:IsPlaying() then
                            raidTarget.animation:Restart();
                        else
                            raidTarget.animation:Play();
                        end
                    end

                    if raidTarget.markPrev ~= raidTarget.mark then
                        play();
                    end
                else
                    raidTarget.mark = nil;
                    raidTarget:Hide();
                end
            end
        end
    end
end