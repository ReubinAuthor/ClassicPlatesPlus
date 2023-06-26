----------------------------------------
-- Core
----------------------------------------
local _, core = ...;

core.func = {};
core.data = {
    colors = {
        border = {r = 0.75, g = 0.60, b = 0, a = 1},
        blue = {r = 0.0, g = 0.75, b = 1},
        green = {r = 0, g = 1, b = 0},
        yellow = {r = 1, g = 0.90, b = 0},
        orange = {r = 1, g = 0.5, b = 0},
        red = {r = 1, g = 0, b = 0},
        purple = {r = 1, g = 0.3, b = 1},
    },
    tanks = {},
    members = {},
    tickers = {},
    nameplates = {},
};

local func = core.func;
local data = core.data;

----------------------------------------
-- Tweaking CVars
----------------------------------------
function func:CVars(event)
    if event == "VARIABLES_LOADED" then
        -- Distance
        SetCVar("nameplateMinScale", 1.0);
        SetCVar("nameplateMaxScale", 1.0);
        SetCVar("nameplateMinScaleDistance", 10);
        SetCVar("nameplateMaxScaleDistance", 10);

        -- Selected
        SetCVar("nameplateNotSelectedAlpha", 0.5);
        SetCVar("nameplateSelectedAlpha", 1.0);
        SetCVar("nameplateSelectedScale", 1.2);

        -- Inset
        SetCVar("nameplateOtherTopInset", .08);

        -- Nameplates size
        SetCVar("nameplateGlobalScale", Config.NameplatesScale);

        -- Rest
        SetCVar("nameplateTargetRadialPosition", 2);
        SetCVar("clampTargetNameplateToScreen", 1);
    elseif event == "PLAYER_LOGOUT" then
        -- Distance
        SetCVar("nameplateMinScale", 1.0);
        SetCVar("nameplateMaxScale", 1.0);
        SetCVar("nameplateMinScaleDistance", 10);
        SetCVar("nameplateMaxScaleDistance", 10);

        -- Selected
        SetCVar("nameplateNotSelectedAlpha", 0.5);
        SetCVar("nameplateSelectedAlpha", 1.0);
        SetCVar("nameplateSelectedScale", 1.0);

        -- Inset
        SetCVar("nameplateOtherTopInset", .08);

        -- Nameplates size
        SetCVar("nameplateGlobalScale", 1.0);

        -- Rest
        SetCVar("nameplateTargetRadialPosition", 0);
        SetCVar("clampTargetNameplateToScreen", 0);
    end
end

----------------------------------------
-- Resize nameplates clickable base
----------------------------------------
function func:ResizeNameplates()
    local function resize()
        local inInstance, instanceType = IsInInstance();
        local width, height;

        if Config.Portrait then
            width = 160;
        else
            width = 155;
        end

        if Config.ShowGuildName then
            height = 46;
        else
            height = 36;
        end

        if inInstance and (instanceType == "party" or instanceType == "raid") then
            C_NamePlate.SetNamePlateFriendlySize(128, 30);
        else
            C_NamePlate.SetNamePlateFriendlySize(width, height);
        end
        C_NamePlate.SetNamePlateEnemySize(width, height);
    end

    if not InCombatLockdown() then
        resize();
    else
        if not data.tickers.frameOptions then
            data.tickers.frameOptions = C_Timer.NewTicker(1, function()
                if not InCombatLockdown() then
                    resize();

                    data.tickers.frameOptions:Cancel();
                    data.tickers.frameOptions = nil;
                end
            end)
        end
    end
end

----------------------------------------
-- Hooking NamePlateDriverFrame
----------------------------------------
-- hiding default nameplates
hooksecurefunc(NamePlateDriverFrame,"OnNamePlateAdded", function(_, nameplateUnitToken)
    local nameplate = C_NamePlate.GetNamePlateForUnit(nameplateUnitToken, false);

    if nameplate then
        nameplate.UnitFrame:Hide();
    end
end);

-- Resizing clickable base
hooksecurefunc(NamePlateDriverFrame,"ApplyFrameOptions", function(_, nameplateFrame)
    func:ResizeNameplates();
end);

----------------------------------------
-- Updating nameplates
----------------------------------------
function func:Update()
    local nameplates = C_NamePlate.GetNamePlates();

    if nameplates then
        for k,v in pairs(nameplates) do
            if k then
                func:Nameplate_Added(v.unitFrame.unit);
            end
        end
    end

    func:ResizeNameplates();
end

function func:GetPercent(maxValue, percent)
    if tonumber(percent) and tonumber(maxValue) then
        return (maxValue * percent) / 100;
    else
        return false;
    end
end

----------------------------------------
-- UTF8 Aware sting sub
----------------------------------------
-- This function can return a substring of a UTF-8 string, properly
-- handling UTF-8 codepoints. Rather than taking a start index and
-- optionally an end index, it takes the string, the start index, and
-- the number of characters to select from the string.
--
-- UTF-8 Reference:
-- 0xxxxxx - ASCII character
-- 110yyyxx - 2 byte UTF codepoint
-- 1110yyyy - 3 byte UTF codepoint
-- 11110zzz - 4 byte UTF codepoint

function func:utf8sub(str, start, numChars)
    local currentIndex = start;

    while numChars > 0 and currentIndex <= #str do
        local char = string.byte(str, currentIndex);

        if char >= 240 then
            currentIndex = currentIndex + 4;
        elseif char >= 225 then
            currentIndex = currentIndex + 3;
        elseif char >= 192 then
            currentIndex = currentIndex + 2;
        else
            currentIndex = currentIndex + 1;
        end

        numChars = numChars - 1;
    end

    return str:sub(start, currentIndex - 1);
end

----------------------------------------
-- Get unit color
----------------------------------------
function func:GetHighlightAndUnitColor(unit)
    local isFriend = UnitIsFriend(unit, "player");
    local threat = UnitThreatPercentageOfLead("player", unit);
    local r,g,b = UnitSelectionColor(unit, true);
    local _, englishClass = UnitClass(unit);
    local classColor = RAID_CLASS_COLORS[englishClass];

    local function getLighterPurpleColor(value)
        if value > 200 then
            return 1, 0, 1;
        elseif value < 100 then
            return 1, 0.5, 1;
        else
            return 1, 0.5 - (value - 100) / 200 * 0.5, 1;
        end
    end

    -- Default healthbar colors
    local function default()
        if UnitIsPlayer(unit) or UnitIsOtherPlayersPet(unit) then
            if not isFriend then
                if Config.HealthBarClassColorsEnemy then
                    return false, threat, classColor.r, classColor.g, classColor.b;
                else
                    return false, threat, r, g, b;
                end
            else
                if Config.HealthBarClassColorsFriendly then
                    return false, threat, classColor.r, classColor.g, classColor.b;
                else
                    return false, threat, r, g, b;
                end
            end
        elseif UnitIsTapDenied(unit) then
            if isFriend then
                return false, threat, r, g, b;
            else
                return false, threat, 0.9, 0.9, 0.9;
            end
        else
            return false, threat, r, g, b;
        end
    end

    if not isFriend then
        local status = UnitThreatSituation("player", unit);
        local iAmTarget = UnitIsUnit(unit .. "target", "player");

        if not UnitIsPlayer(unit) and not UnitIsOtherPlayersPet(unit) then
            local function otherTank()
                for k in pairs(data.tanks) do
                    if k then
                        local isTanking = UnitDetailedThreatSituation(k, unit);
                        if isTanking then
                            return true;
                        end
                    end
                end
            end

            if status == 3 or status == 2 then
                return true, threat, getLighterPurpleColor(threat);
            elseif otherTank() then
                return true, threat, 0, 0.75, 0;
            elseif status == 1 or (threat and threat > Config.ThreatWarningThreshold) then
                return true, threat, 1, 0.6, 0;
            else
                return default();
            end
        else
            if iAmTarget then
                if Config.HealthBarClassColorsEnemy then
                    return true, threat, classColor.r, classColor.g, classColor.b;
                else
                    return true, threat, r, g, b;
                end
            else
                return default();
            end
        end
    else
        return default();
    end
end

----------------------------------------
-- Update colors
----------------------------------------
function func:Update_Colors(unit)
    local color = data.colors.border;

    local function work(unitFrame, unit)
        local r,g,b = select(3, func:GetHighlightAndUnitColor(unit));
        local Rs,Gs,Bs = UnitSelectionColor(unit, true);

        if UnitIsEnemy(unit, "player") and (UnitIsPlayer(unit) or UnitIsOtherPlayersPet(unit)) then
            if UnitIsPVP(unit) or UnitIsPVPFreeForAll(unit) then
                r,g,b = Rs, Gs, Bs;
            else
                r,g,b = color.r, color.g, color.b;
            end
        elseif UnitIsFriend(unit, "player") and (UnitIsPlayer(unit) or UnitIsOtherPlayersPet(unit)) then
            if UnitIsPVP(unit) or UnitIsPVPFreeForAll(unit) then
                r,g,b = Rs, Gs, Bs;
            else
                r,g,b = color.r, color.g, color.b;
            end
        else
            r,g,b = color.r, color.g, color.b;
        end

        -- Coloring borders
        if UnitIsEnemy(unit, "player") and (UnitIsPlayer(unit) or UnitIsOtherPlayersPet(unit)) and (UnitIsPVP(unit) or UnitIsPVPFreeForAll(unit)) then
            unitFrame.portrait.border:SetVertexColor(Rs, Gs, Bs);
            unitFrame.healthbar.border:SetVertexColor(Rs, Gs, Bs);
            unitFrame.level.border:SetVertexColor(Rs, Gs, Bs);
            unitFrame.powerbar.border:SetVertexColor(Rs, Gs, Bs);
            unitFrame.threatPercentage.border:SetVertexColor(Rs, Gs, Bs);
        else
            unitFrame.portrait.border:SetVertexColor(r,g,b);
            unitFrame.healthbar.border:SetVertexColor(r,g,b);
            unitFrame.level.border:SetVertexColor(r,g,b);
            unitFrame.powerbar.border:SetVertexColor(r,g,b);
            unitFrame.threatPercentage.border:SetVertexColor(r,g,b);
        end

        if UnitIsEnemy(unit, "player") and UnitIsTapDenied(unit) then
            unitFrame.name:SetTextColor(0.5, 0.5, 0.5);
            unitFrame.guild:SetTextColor(0.5, 0.5, 0.5);
        else
            unitFrame.name:SetTextColor(Rs, Gs, Bs);
            unitFrame.guild:SetTextColor(Rs, Gs, Bs);
        end

        -- Coloring healthbar background
        unitFrame.healthbar.background:SetColorTexture(0.1 + (r / 7), 0.1 + (g / 7), 0.1 + (b / 7), 0.85);

        -- Updating name and guild positions to accomodate scale change
        func:Update_NameAndGuildPositions(unitFrame);
    end

    if unit then
        local nameplate = C_NamePlate.GetNamePlateForUnit(unit);

        if nameplate then
            work(nameplate.unitFrame, unit);
        end
    else
        local nameplates = C_NamePlate.GetNamePlates();

        if nameplates then
            for k,v in pairs(nameplates) do
                if k then
                    work(v.unitFrame, v.unitFrame.unit);
                end
            end
        end
    end
end

----------------------------------------
-- Update health
----------------------------------------
function func:Update_Health(unit)
    if unit then
        local healthMax = UnitHealthMax(unit);
        local health = UnitHealth(unit);
        local healthPercent = string.format("%.0f", (health/healthMax)*100) .. "%";

        if unit == "player" then
            local nameplate = data.nameplate;

            if nameplate then
                local hp = AbbreviateNumbers(health);
                local percentageAsMainValue = Config.PercentageAsMainValue and Config.NumericValue and Config.Percentage;

                nameplate.healthMain:SetText(
                    percentageAsMainValue and healthPercent
                    or Config.NumericValue and hp
                    or Config.Percentage and healthPercent
                    or ""
                );
                nameplate.healthLeftSide:SetText(percentageAsMainValue and hp or healthPercent);

                nameplate.healthMain:SetShown(Config.NumericValue or Config.Percentage);
                nameplate.healthLeftSide:SetShown(Config.NumericValue and Config.Percentage);

                -- Total health
                data.nameplate.healthTotal:SetText(AbbreviateNumbers(healthMax));

                -- Updating Health bar
                nameplate.healthbar:SetMinMaxValues(0, healthMax);
                nameplate.healthbar:SetValue(health);

                -- Toggling spark
                func:ToggleSpark(health, healthMax, nameplate.healthbarSpark);
            end
        else
            local nameplate = C_NamePlate.GetNamePlateForUnit(unit);

            if nameplate then
                local unitFrame = nameplate.unitFrame;
                local hp = AbbreviateNumbers(health);
                local notMember = (UnitIsPlayer(unit) or UnitIsOtherPlayersPet(unit)) and not UnitPlayerOrPetInParty(unit);
                local percentageAsMainValue = Config.PercentageAsMainValue and Config.NumericValue and Config.Percentage;

                unitFrame.healthMain:SetText(
                    (percentageAsMainValue or notMember) and healthPercent
                    or Config.NumericValue and hp
                    or Config.Percentage and healthPercent
                    or ""
                );
                unitFrame.healthLeftSide:SetText(percentageAsMainValue and hp or healthPercent);

                unitFrame.healthMain:SetShown(Config.NumericValue or Config.Percentage);
                unitFrame.healthLeftSide:SetShown((Config.NumericValue and Config.Percentage) and not notMember);

                -- Updating Health bar
                unitFrame.healthbar:SetMinMaxValues(0, healthMax);
                unitFrame.healthbar:SetValue(health);

                -- Toggling spark
                func:ToggleSpark(health, healthMax, unitFrame.healthbar.spark);
            end
        end

        func:PredictHeal(unit);
    end

    func:ToggleNameplatePersonal();
end

----------------------------------------
-- Update healthbar color
----------------------------------------
function func:Update_healthbar(unit)
    if unit then
        local nameplate = C_NamePlate.GetNamePlateForUnit(unit);

        if nameplate then
            local unitFrame = nameplate.unitFrame;
            local r,g,b = select(3, func:GetHighlightAndUnitColor(unit));

            unitFrame.healthbar:SetStatusBarColor(r,g,b);
        end
    end
end

----------------------------------------
-- Heal prediction
----------------------------------------
function func:PredictHeal(unit)
    local healthbar, prediction, missing, heal, predictionSpark;

    if unit then
        if unit == "player" then
            healthbar = data.nameplate.healthbar;
            prediction = data.nameplate.healPrediction;
            predictionSpark = data.nameplate.healPredictionSpark;
            missing = data.nameplate.missing;
            heal = data.nameplate.heal;
        else
            local nameplate = C_NamePlate.GetNamePlateForUnit(unit);

            if nameplate then
                healthbar = nameplate.unitFrame.healthbar;
                prediction = nameplate.unitFrame.healthbar.healPrediction;
                predictionSpark = nameplate.unitFrame.healthbar.healPredictionSpark;
                missing = nameplate.unitFrame.healthbar.healPrediction.missing;
                heal = nameplate.unitFrame.healthbar.healPrediction.heal;
            end
        end

        local healValue = UnitGetIncomingHeals(unit);

        if not healValue then
            healValue = heal;
        end

        if healValue and healValue > 0  and healthbar then
            missing = UnitHealthMax(unit) - UnitHealth(unit);
            heal = healValue;

            local missingValue = missing / UnitHealthMax(unit) * healthbar:GetWidth();
            local newValue = heal / UnitHealthMax(unit) * healthbar:GetWidth();

            if newValue > missingValue then
                newValue = missingValue;
            end

            prediction:SetWidth(newValue);
            prediction:SetShown(newValue > 0);
            predictionSpark:SetShown(newValue > 0);
        else
            if prediction then
                prediction:Hide();
            end
            if predictionSpark then
                predictionSpark:Hide();
            end
        end

        missing = UnitHealthMax(unit) - UnitHealth(unit);
        heal = healValue;
    end
end

----------------------------------------
-- Update power
----------------------------------------
function func:Update_Power(unit)
    if unit then
        if unit == "player" then
            local nameplate = data.nameplate;
            local powerMax = UnitPowerMax(unit);
            local power = UnitPower(unit);
            local powerType, powerToken = UnitPowerType(unit);
            local color = PowerBarColor[powerToken];
            local classID = select(3, UnitClass("player"));

            if nameplate then
                if color then
                    nameplate.powerbar:SetStatusBarColor(color.r, color.g, color.b);
                end

                local powerPercent = string.format("%.0f", (power/powerMax)*100) .. "%";

                nameplate.powerbar:SetMinMaxValues(0, powerMax);
                nameplate.powerbar:SetValue(power);

                if powerType == 0 then
                    if Config.PercentageAsMainValue and Config.NumericValue and Config.Percentage then
                        nameplate.powerMain:SetText(powerPercent);
                        nameplate.power:SetText(AbbreviateNumbers(power));
                        nameplate.power:Show();
                        nameplate.powerMain:Show();
                    elseif Config.NumericValue and Config.Percentage then
                        nameplate.powerMain:SetText(AbbreviateNumbers(power));
                        nameplate.power:SetText(powerPercent);
                        nameplate.power:Show();
                        nameplate.powerMain:Show();
                    elseif Config.NumericValue then
                        nameplate.powerMain:SetText(AbbreviateNumbers(power));
                        nameplate.powerMain:SetShown(powerType == 0);
                        nameplate.power:Hide();
                    elseif Config.Percentage then
                        nameplate.powerMain:SetText(powerPercent);
                        nameplate.powerMain:Show();
                        nameplate.power:Hide();
                    else
                        nameplate.powerMain:Hide();
                        nameplate.power:Hide();
                    end
                else
                    nameplate.powerMain:SetText(power);
                    nameplate.power:Hide();
                end

                data.nameplate.powerTotal:SetText(AbbreviateNumbers(powerMax));

                -- Toggling spark
                func:ToggleSpark(power, powerMax, nameplate.powerbarSpark);

                -- Druid's bar
                if powerType ~= 0 and classID == 11 then
                    local manaMax = UnitPowerMax("player", 0);
                    local mana = UnitPower("player", 0);

                    nameplate.druidsBar:SetMinMaxValues(0, manaMax);
                    nameplate.druidsBar:SetValue(mana);
                    nameplate.druidsBarValue:SetText(mana);

                    -- Toggling spark
                    func:ToggleSpark(mana, manaMax, nameplate.druidsBarSpark);
                end
            end
        else
            local nameplate = C_NamePlate.GetNamePlateForUnit(unit);

            if nameplate then
                local unitFrame = nameplate.unitFrame;
                local powerMax = UnitPowerMax(unit);
                local power = UnitPower(unit);
                local powerType, powerToken, altR, altG, altB = UnitPowerType(unit);
                local color = PowerBarColor[powerToken];

                -- Show or hide highlight
                if power and powerMax > 0 then -- Powerbar is shown
                    if color then
                        unitFrame.powerbar.statusbar:SetStatusBarColor(color.r, color.g, color.b);
                    end

                    unitFrame.powerbar.statusbar:SetMinMaxValues(0, powerMax);
                    unitFrame.powerbar.statusbar:SetValue(power);
                    unitFrame.powerbar:SetShown(Config.Powerbar);
                    unitFrame.powerbar.border:Show();
                else -- Powerbar is hidden
                    unitFrame.powerbar:Hide();
                    unitFrame.powerbar.spark:Hide();
                    unitFrame.powerbar.border:Hide();
                end

                -- Toggling spark
                func:ToggleSpark(power, powerMax, unitFrame.powerbar.spark);
            end
        end
    end

    func:ToggleNameplatePersonal();
end

----------------------------------------
-- Update combo points
----------------------------------------
function func:Update_ComboPoints(unit)
    if unit == "player" then
        local nameplates = C_NamePlate.GetNamePlates();

        if nameplates then
            for k,v in pairs(nameplates) do
                if k then
                    local unitFrame = v.unitFrame;
                    local comboPoints = GetComboPoints("player", v.unitFrame.unit);

                    if comboPoints > 0 then
                        for i = 1, 10 do
                            if i > comboPoints and unitFrame.comboPoints[i] then
                                unitFrame.comboPoints[i]:Hide();
                            else
                                if not unitFrame.comboPoints[i] then
                                    unitFrame.comboPoints[i] = CreateFrame("frame", nil, unitFrame.comboPoints);
                                    unitFrame.comboPoints[i]:SetSize(14, 14);
                                    unitFrame.comboPoints[i].center = unitFrame.comboPoints[i]:CreateTexture();
                                    unitFrame.comboPoints[i].center:SetAllPoints();
                                    unitFrame.comboPoints[i].center:SetTexture("Interface\\addons\\ClassicPlatesPlus\\media\\powers\\comboPoints");
                                    unitFrame.comboPoints[i].border = unitFrame.comboPoints[i]:CreateTexture();
                                    unitFrame.comboPoints[i].border:SetAllPoints();
                                    unitFrame.comboPoints[i].border:SetTexture("Interface\\addons\\ClassicPlatesPlus\\media\\powers\\comboPointsBorder");
                                else
                                    unitFrame.comboPoints[i].border:SetVertexColor(
                                        data.colors.border.r,
                                        data.colors.border.g,
                                        data.colors.border.b
                                    );

                                    if i > 1 then
                                        unitFrame.comboPoints[i]:SetPoint("left", unitFrame.comboPoints[i - 1], "right");
                                    end
                                end

                                unitFrame.comboPoints[i]:Show();
                            end
                        end

                        unitFrame.comboPoints[1]:ClearAllPoints();

                        if Config.Portrait then
                            if unitFrame.powerbar:IsShown() then
                                unitFrame.comboPoints[1]:SetPoint("top", unitFrame.healthbar, "bottom", (-(comboPoints -1) * 7), -7);
                            else
                                unitFrame.comboPoints[1]:SetPoint("top", unitFrame.healthbar, "bottom", (-(comboPoints -1) * 7), -2);
                            end
                        else
                            if unitFrame.powerbar:IsShown() then
                                unitFrame.comboPoints[1]:SetPoint("top", unitFrame.healthbar, "bottom", ((-(comboPoints -1) * 7)) + 9, -7);
                            else
                                unitFrame.comboPoints[1]:SetPoint("top", unitFrame.healthbar, "bottom", ((-(comboPoints -1) * 7)) + 9, -2);
                            end
                        end

                        unitFrame.comboPoints:Show();
                    else
                        unitFrame.comboPoints:Hide();
                    end
                end
            end
        end
    end
end

------------------------------------------
-- Toggle spark for healthbars and powerbars
------------------------------------------
function func:ToggleSpark(value, valueMax, spark)
    if value == valueMax or value <= 0 then
        spark:Hide();
    else
        spark:Show();
    end
end

----------------------------------------
-- Spell cost
----------------------------------------
function func:SpellCost(unit, spellID)
    if UnitIsUnit(unit, "player") then
        local costTable = GetSpellPowerCost(spellID);

        local function cost(Cost, costType)
            local powerMax = UnitPowerMax("player", costType);

            if Cost > 0 then
                data.nameplate.powerbarCost:SetWidth(Cost / powerMax * data.nameplate.powerbar:GetWidth());
                data.nameplate.powerbarCost:Show();
                data.nameplate.powerbarCostSpark:Show();
            end
        end

        if next(costTable) ~= nil then
            if type(costTable[1]["cost"]) == "table" then
                local costType = costTable[1].cost[1].type;
                local cost2Type = costTable[1].cost[2].type;

                if costType == 0 or costType == 1 or costType == 3 then
                    cost(costTable[1].cost[1].cost, costType);
                elseif cost2Type == 0 or cost2Type == 1 or cost2Type == 3 then
                    cost(costTable[1].cost[2].cost, cost2Type);
                end
            else
                cost(costTable[1].cost, costTable[1].type);
            end
        end
    end
end

----------------------------------------
-- Update portrait
----------------------------------------
function func:Update_Portrait(unit)
    if Config.Portrait then
        if unit then
            local nameplate = C_NamePlate.GetNamePlateForUnit(unit);

            if nameplate then
                local unitFrame = nameplate.unitFrame;
                local isEnemy = UnitIsEnemy(unit, "player");
                local isFriend = UnitIsFriend(unit, "player");

                local function setClassIcon()
                    local _, class = UnitClass(unit);

                    if class then
                        unitFrame.portrait.texture:SetTexture("Interface\\addons\\ClassicPlatesPlus\\media\\classes\\" .. class);
                    end
                end

                if UnitIsPlayer(unit) then
                    if Config.ClassIconsEnemy then
                        if isEnemy then
                            setClassIcon();
                        end
                    else
                        if isEnemy then
                            SetPortraitTexture(unitFrame.portrait.texture, unit);
                        end
                    end

                    if Config.ClassIconsFriendly then
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
            local name = GetUnitName(unit, false);

            unitFrame.name:SetText(name);
            func:Update_NameAndGuildPositions(unitFrame);
        end
    end
end

----------------------------------------
-- Update guild
----------------------------------------
function func:Update_Guild(unit)
    if unit then
        local nameplate = C_NamePlate.GetNamePlateForUnit(unit);

        if nameplate then
            local unitFrame = nameplate.unitFrame;
            local guildName = GetGuildInfo(unit);

            if guildName then
                unitFrame.guild:SetText("<"..guildName..">");
            end

            unitFrame.guild:SetShown(Config.ShowGuildName and guildName ~= nil);
            func:Update_NameAndGuildPositions(unitFrame);
        end
    end
end

----------------------------------------
-- Update name and guild positions
----------------------------------------
function func:Update_NameAndGuildPositions(unitFrame)
    if unitFrame then
        local x,y;

        if UnitIsUnit(unitFrame.unit, "target") then
            if unitFrame.threatPercentage:IsShown() then
                if Config.Portrait then
                    x,y = 0, 22;
                else
                    x,y = 8, 22;
                end
            else
                if Config.Portrait then
                    x,y = 0, 10;
                else
                    x,y = 8, 8;
                end
            end
        else
            if unitFrame.threatPercentage:IsShown() then
                if Config.Portrait then
                    x,y = 0, 18 ;
                else
                    x,y = 8, 18;
                end
            else
                if Config.Portrait then
                    x,y = 0, 8;
                else
                    x,y = 8, 6;
                end
            end
        end

        unitFrame.guild:ClearAllPoints();
        unitFrame.name:ClearAllPoints();

        unitFrame.guild:SetPoint("bottom", unitFrame.healthbar, "top", x, y);
        if unitFrame.guild:IsShown() then
            unitFrame.name:SetPoint("bottom", unitFrame.guild, "top", 0, 1);
        else
            unitFrame.name:SetPoint("bottom", unitFrame.healthbar, "top", x, y);
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
                unitFrame.level.highLevel:Hide();
            else
                unitFrame.level:Hide();
                unitFrame.level.highLevel:Show();
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

            if Config.Classification and classification and (
                   classification == "rareelite"
                or classification == "elite"
                or classification == "worldboss"
                or classification == "rare"
            ) then
                if Config.Portrait then
                    unitFrame.classification:SetTexture("Interface\\addons\\ClassicPlatesPlus\\media\\classifications\\" .. classification);
                else
                    unitFrame.classification:SetTexture("Interface\\addons\\ClassicPlatesPlus\\media\\classifications\\compact" .. classification);
                end

                unitFrame.classification:Show();
            else
                unitFrame.classification:Hide();
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
                unitFrame.pvp_flag:SetTexture("Interface\\addons\\ClassicPlatesPlus\\media\\icons\\ffa");
                unitFrame.pvp_flag:Show();
            elseif flaggedPVP then
                local faction = UnitFactionGroup(unit);

                if faction then
                    unitFrame.pvp_flag:SetTexture("Interface\\addons\\ClassicPlatesPlus\\media\\icons\\" .. faction);
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
                if GetPartyAssignment("MainTank", unit, true) then -- if unit is a tank
                    data.tanks[UnitName(unit)] = UnitName(unit);
                else                                               -- If unit is a member
                    data.members[UnitName(unit)] = UnitName(unit);
                end
            end
        end
    end
end

----------------------------------------
-- Update list of auras
----------------------------------------
function func:UpdateAurasList(ScrollFrame, ScrollChild, AurasList)
    local sorted = {};
    local sorter = {};

    local function pairsByKeys (t)
        local a = {};

        for n in pairs(t) do
            table.insert(a, n);
        end

        table.sort(a);

        local i = 0;
        local function iter()
            i = i + 1;

            if a[i] == nil then
                return nil;
            else
                return a[i], t[a[i]];
            end
        end

        return iter;
    end

    data[AurasList] = {};
    for k in pairs(Config[AurasList]) do
        if k then
            local name, _, icon = GetSpellInfo(k);

            if name then
                sorter[name] = { icon = icon, id = k };
                data[AurasList][name] = 1;
            end
        end
    end

    for k,v in pairsByKeys(sorter) do
        if pairsByKeys then
            local aura = { name = k, icon = v.icon, id = v.id };
            table.insert(sorted, aura);
        end
    end

    local function anchor(index)
        if index == 1 then
            return "topLeft";
        else
            return "topLeft", ScrollChild.auras[index - 1], "bottomLeft";
        end
    end

    for k,v in ipairs(sorted) do
        if k then
            if not ScrollChild.auras[k] then
                ScrollChild.auras[k] = CreateFrame("frame", nil, ScrollChild);
                ScrollChild.auras[k]:SetPoint(anchor(k));
                ScrollChild.auras[k]:SetSize(ScrollChild:GetWidth() - 16, 30);

                ScrollChild.auras[k].icon = ScrollChild:CreateTexture();
                ScrollChild.auras[k].icon:SetParent(ScrollChild.auras[k]);
                ScrollChild.auras[k].icon:SetPoint("left", 6, 0);
                ScrollChild.auras[k].icon:SetTexture(v.icon);
                ScrollChild.auras[k].icon:SetSize(24, 24);

                ScrollChild.auras[k].name = ScrollChild:CreateFontString(nil, "overlay", "GameFontNormal");
                ScrollChild.auras[k].name:SetParent(ScrollChild.auras[k]);
                ScrollChild.auras[k].name:SetPoint("left", 40, 0);
                ScrollChild.auras[k].name:SetWidth(172);
                ScrollChild.auras[k].name:SetJustifyH("left");
                ScrollChild.auras[k].name:SetText(v.name);

                ScrollChild.auras[k].remove = CreateFrame("button", nil, ScrollChild.auras[k]);
                ScrollChild.auras[k].remove:SetSize(18, 18);
                ScrollChild.auras[k].remove:SetPoint("right");
                ScrollChild.auras[k].remove:SetNormalTexture("Interface\\Buttons\\UI-MinusButton-Up");
                ScrollChild.auras[k].remove:SetPushedTexture("Interface\\Buttons\\UI-MinusButton-Down");
                ScrollChild.auras[k].remove:SetHighlightTexture("Interface\\Buttons\\UI-PlusButton-Hilight");

                ScrollChild.auras[k].background = ScrollChild:CreateTexture();
                ScrollChild.auras[k].background:SetParent(ScrollChild.auras[k]);
                ScrollChild.auras[k].background:SetAllPoints();
                ScrollChild.auras[k].background:SetTexture("Interface\\addons\\ClassicPlatesPlus\\media\\highlights\\aurasList");
                ScrollChild.auras[k].background:SetVertexColor(1, 0.82, 0, 0.15);
                ScrollChild.auras[k].background:SetDrawLayer("background", 1);
            else
                ScrollChild.auras[k].icon:SetTexture(v.icon);
                ScrollChild.auras[k].name:SetText(v.name);
            end

            ScrollChild.auras[k].background:Hide();
            ScrollChild.auras[k]:Show();

            ----------------------------------------
            -- Scripts
            ----------------------------------------

            -- Highlight
            ScrollChild.auras[k]:SetScript("OnEnter", function()
                ScrollChild.auras[k].background:Show();
            end);
            ScrollChild.auras[k]:SetScript("OnLeave", function()
                ScrollChild.auras[k].background:Hide();
            end);
            ScrollChild.auras[k].remove:SetScript("OnEnter", function()
                ScrollChild.auras[k].background:Show();
            end);
            ScrollChild.auras[k].remove:SetScript("OnLeave", function()
                ScrollChild.auras[k].background:Hide();
            end);

            -- Remove button
            ScrollChild.auras[k].remove:SetScript("OnClick", function()
                Config[AurasList][v.id] = nil;

                if not Config[AurasList][k] then
                    for k,v in pairs(ScrollChild.auras) do
                        if k then
                            v:Hide();
                        end
                    end
                end

                func:UpdateAurasList(ScrollFrame, ScrollChild, AurasList);
                func:Update();
            end);
        end
    end

    if #sorted == 0 then
        if not ScrollFrame.note then
            ScrollFrame.note = ScrollFrame:CreateFontString(nil, "overlay", "GameFontHighlight");
            ScrollFrame.note:SetParent(ScrollFrame);
            ScrollFrame.note:SetPoint("center", 0, 10);
            ScrollFrame.note:SetWidth(200);
            ScrollFrame.note:SetJustifyH("center");
            ScrollFrame.note:SetSpacing(2);
            ScrollFrame.note:SetAlpha(0.33);
            ScrollFrame.note:SetText("Nothing here yet...");
        else
            ScrollFrame.note:SetParent(ScrollFrame);
            ScrollFrame.note:SetPoint("center", 0, 10);
        end

        if AurasList == "AurasImportantList" then
            ScrollFrame.note:SetText("Important auras will appear here.\n\nThese auras are always displayed, and stand out from the rest of the auras");
        elseif AurasList == "AurasBlacklist" then
            ScrollFrame.note:SetText("Blacklisted auras will appear here.\n\nThese auras will never be displayed.");
        end

        ScrollFrame.note:Show();
    else
        if ScrollFrame.note then
            ScrollFrame.note:Hide();
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

                    if mark == 1 then texture = "UI-RaidTargetingIcon_1";
                    elseif mark == 2 then texture = "UI-RaidTargetingIcon_2";
                    elseif mark == 3 then texture = "UI-RAIDTARGETINGICON_3";
                    elseif mark == 4 then texture = "UI-RaidTargetingIcon_4";
                    elseif mark == 5 then texture = "UI-RaidTargetingIcon_5";
                    elseif mark == 6 then texture = "UI-RaidTargetingIcon_6";
                    elseif mark == 7 then texture = "UI-RaidTargetingIcon_7";
                    elseif mark == 8 then texture = "UI-RaidTargetingIcon_8";
                    end

                    if texture then
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
                    end
                else
                    raidTarget.mark = nil;
                    raidTarget:Hide();
                end
            end
        end
    end
end