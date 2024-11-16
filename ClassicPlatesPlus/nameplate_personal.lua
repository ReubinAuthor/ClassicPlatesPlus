----------------------------------------
-- Core
----------------------------------------
local myAddon, core = ...;
local func = core.func;
local data = core.data;

--------------------------------------
-- Create personal nameplate
--------------------------------------
local scaleOffset = 0.40;

function func:PersonalNameplateCreate()
    if not data.nameplate then
        -- Anchor
        data.nameplate = CreateFrame("frame", myAddon .. "nameplateSelf", UIParent);

        local nameplate = data.nameplate;

        nameplate:SetSize(256,64);
        nameplate:SetFrameLevel(2);
        nameplate:SetScript("OnShow", function(self)
            func:DefaultPowerBars();
        end);

        CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile].PersonalNameplatePointY = CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile].PersonalNameplatePointY or 380;

        -- Dragging part
        if not data.isRetail then
            local startY = 0;
            local originalY = 0;

            nameplate:SetMovable(true);
            nameplate:EnableMouse(false);
            nameplate:RegisterForDrag("LeftButton");
            nameplate:SetClampedToScreen(true);

            nameplate.isMoving = false;
            nameplate:SetScript("OnDragStart", function(self)
                if IsControlKeyDown() then
                    self.isMoving = true;
                    startY = select(2, GetCursorPosition());
                    originalY = self:GetTop();
                end
            end)

            nameplate:SetScript("OnDragStop", function(self)
                self.isMoving = false;
            end)

            nameplate:SetScript("OnUpdate", function(self)
                if self.isMoving then
                    local y = select(2, GetCursorPosition());
                    local deltaY = y - startY;

                    -- Calculate the new Y-coordinate
                    local newY = originalY + deltaY;

                    -- Set the frame's position along the Y-axis
                    self:SetPoint("top", UIParent, "bottom", 0, newY);
                    CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile].PersonalNameplatePointY = newY;
                end
            end);

            nameplate:SetScript("OnHide", function(self)
                self.isMoving = false;
            end)
        end

        -- Unit
        nameplate.unit = "player";

        -- Main / Scale
        nameplate.main = CreateFrame("frame", nil, nameplate);
        nameplate.main:SetAllPoints();
        nameplate.main:SetScale(CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile].PersonalNameplatesScale - 0.2);

        -- Border
        nameplate.border = nameplate.main:CreateTexture();
        nameplate.border:SetPoint("center");
        nameplate.border:SetSize(256,128);
        nameplate.border:SetTexture("Interface\\addons\\ClassicPlatesPlus\\media\\borders\\borderOwn");
        nameplate.border:SetVertexColor(data.colors.border.r, data.colors.border.g, data.colors.border.b);
        nameplate.border:SetDrawLayer("border", 1);

        -- Healthbar
        nameplate.healthbar = CreateFrame("StatusBar", nil, nameplate.main);
        nameplate.healthbar:SetPoint("top", nameplate.border, "center", 0, 36);
        nameplate.healthbar:SetSize(222, 28);
        nameplate.healthbar:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar");
        nameplate.healthbar:SetStatusBarColor(0,1,0);
        nameplate.healthbar:SetFrameLevel(1);

        nameplate.healthbarSpark = nameplate.main:CreateTexture();
        nameplate.healthbarSpark:SetPoint("center", nameplate.healthbar:GetStatusBarTexture(), "right");
        nameplate.healthbarSpark:SetSize(10, 32);
        nameplate.healthbarSpark:SetTexture("Interface\\addons\\ClassicPlatesPlus\\media\\highlights\\spark");
        nameplate.healthbarSpark:SetVertexColor(1, 0.82, 0);
        nameplate.healthbarSpark:SetBlendMode("ADD");
        nameplate.healthbarSpark:SetDrawLayer("artwork");
        nameplate.healthbarSpark:Hide();

        nameplate.healthbarBackground = nameplate.main:CreateTexture();
        nameplate.healthbarBackground:SetColorTexture(0.18, 0.18, 0.18, 0.85);
        nameplate.healthbarBackground:SetParent(nameplate.healthbar);
        nameplate.healthbarBackground:SetAllPoints();
        nameplate.healthbarBackground:SetDrawLayer("background");

        nameplate.healPrediction = nameplate.main:CreateTexture(nil, "background");
        nameplate.healPrediction:SetPoint("left", nameplate.healthbar:GetStatusBarTexture(), "right");
        nameplate.healPrediction:SetHeight(nameplate.healthbar:GetHeight());
        nameplate.healPrediction:SetTexture("Interface\\TARGETINGFRAME\\UI-StatusBar");
        nameplate.healPrediction:SetBlendMode("add");
        nameplate.healPrediction:SetVertexColor(0, 0.5, 0.0, 0.5);
        nameplate.healPrediction:Hide();

        nameplate.healPredictionSpark = nameplate.main:CreateTexture();
        nameplate.healPredictionSpark:SetParent(nameplate.main);
        nameplate.healPredictionSpark:SetPoint("center", nameplate.healPrediction, "right");
        nameplate.healPredictionSpark:SetSize(10, 32);
        nameplate.healPredictionSpark:SetTexture("Interface\\addons\\ClassicPlatesPlus\\media\\highlights\\spark");
        nameplate.healPredictionSpark:SetVertexColor(0, 1, 0, 0.33);
        nameplate.healPredictionSpark:SetBlendMode("add");
        nameplate.healPredictionSpark:SetDrawLayer("artwork");
        nameplate.healPredictionSpark:Hide();

        -- Health main
        nameplate.healthMain = nameplate.main:CreateFontString(nil, "overlay");
        nameplate.healthMain:SetParent(nameplate.main);
        nameplate.healthMain:SetPoint("center", nameplate.healthbar, "center", 0, -0.5);
        nameplate.healthMain:SetJustifyH("center");
        nameplate.healthMain:SetTextColor(
            CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile].HealthFontColor.r,
            CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile].HealthFontColor.g,
            CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile].HealthFontColor.b,
            CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile].HealthFontColor.a
        );
        if CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile].LargeMainValue then
            nameplate.healthMain:SetFontObject("GameFontNormalLargeOutline");
            nameplate.healthMain:SetScale(1.4 + scaleOffset);
        else
            nameplate.healthMain:SetFontObject("GameFontNormalOutline");
            nameplate.healthMain:SetScale(0.9 + scaleOffset);
        end

        -- Health left
        nameplate.healthSecondary = nameplate.main:CreateFontString(nil, "overlay", "GameFontNormalOutline");
        nameplate.healthSecondary:SetParent(nameplate.main);
        nameplate.healthSecondary:SetPoint("left", nameplate.healthbar, "left", 4, 0);
        nameplate.healthSecondary:SetJustifyH("left");
        nameplate.healthSecondary:SetTextColor(
            CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile].HealthFontColor.r,
            CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile].HealthFontColor.g,
            CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile].HealthFontColor.b,
            CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile].HealthFontColor.a
        );
        nameplate.healthSecondary:SetScale(0.9 + scaleOffset);

        -- Health total
        nameplate.healthTotal = nameplate.main:CreateFontString(nil, "overlay", "GameFontNormalOutline");
        nameplate.healthTotal:SetParent(nameplate.main);
        nameplate.healthTotal:SetPoint("right", nameplate.healthbar, "right", -4, 0);
        nameplate.healthTotal:SetJustifyH("right");
        nameplate.healthTotal:SetTextColor(
            CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile].HealthFontColor.r,
            CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile].HealthFontColor.g,
            CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile].HealthFontColor.b,
            CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile].HealthFontColor.a
        );
        nameplate.healthTotal:SetScale(0.9 + scaleOffset);

        -- Powebar
        nameplate.powerbar = CreateFrame("StatusBar", nil, nameplate.main);
        nameplate.powerbar:SetPoint("top", nameplate.border, "center", 0, 5);
        nameplate.powerbar:SetSize(222, 18);
        nameplate.powerbar:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar");
        nameplate.powerbar:SetFrameLevel(1);

        nameplate.powerbarSpark = nameplate.main:CreateTexture();
        nameplate.powerbarSpark:SetPoint("center", nameplate.powerbar:GetStatusBarTexture(), "right");
        nameplate.powerbarSpark:SetSize(10, 22);
        nameplate.powerbarSpark:SetTexture("Interface\\addons\\ClassicPlatesPlus\\media\\highlights\\spark");
        nameplate.powerbarSpark:SetVertexColor(1, 0.82, 0, 0.7);
        nameplate.powerbarSpark:SetBlendMode("add");
        nameplate.powerbarSpark:SetDrawLayer("artwork");
        nameplate.powerbarSpark:Hide();

        nameplate.powerbarBackground = nameplate.main:CreateTexture();
        nameplate.powerbarBackground:SetColorTexture(0.18, 0.18, 0.18, 0.85);
        nameplate.powerbarBackground:SetParent(nameplate.powerbar);
        nameplate.powerbarBackground:SetAllPoints();
        nameplate.powerbarBackground:SetDrawLayer("background");

        nameplate.powerMain = nameplate.main:CreateFontString(nil, "overlay", "GameFontNormalOutline");
        nameplate.powerMain:SetParent(nameplate.main);
        nameplate.powerMain:SetPoint("center", nameplate.powerbar, "center", 0, -0.2);
        nameplate.powerMain:SetJustifyH("center");
        nameplate.powerMain:SetTextColor(
            CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile].HealthFontColor.r,
            CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile].HealthFontColor.g,
            CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile].HealthFontColor.b,
            CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile].HealthFontColor.a
        );
        nameplate.powerMain:SetScale(0.9 + scaleOffset);

        nameplate.power = nameplate.main:CreateFontString(nil, "overlay", "GameFontNormalOutline");
        nameplate.power:SetParent(nameplate.main);
        nameplate.power:SetPoint("left", nameplate.powerbar, "left", 4, -0.2);
        nameplate.power:SetJustifyH("left");
        nameplate.power:SetTextColor(
            CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile].HealthFontColor.r,
            CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile].HealthFontColor.g,
            CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile].HealthFontColor.b,
            CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile].HealthFontColor.a
        );
        nameplate.power:SetScale(0.9 + scaleOffset);

        nameplate.powerTotal = nameplate.main:CreateFontString(nil, "overlay", "GameFontNormalOutline");
        nameplate.powerTotal:SetParent(nameplate.main);
        nameplate.powerTotal:SetPoint("right", nameplate.powerbar, "right", -4, -0.2);
        nameplate.powerTotal:SetJustifyH("right");
        nameplate.powerTotal:SetTextColor(
            CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile].HealthFontColor.r,
            CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile].HealthFontColor.g,
            CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile].HealthFontColor.b,
            CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile].HealthFontColor.a
        );
        nameplate.powerTotal:SetScale(0.9 + scaleOffset);

        nameplate.powerbarCost = nameplate.main:CreateTexture(nil, "background");
        nameplate.powerbarCost:SetPoint("right", nameplate.powerbar:GetStatusBarTexture(), "right");
        nameplate.powerbarCost:SetHeight(18);
        nameplate.powerbarCost:SetTexture("Interface\\TARGETINGFRAME\\UI-StatusBar");
        nameplate.powerbarCost:SetBlendMode("add");
        nameplate.powerbarCost:SetVertexColor(1, 1, 1, 0.6);
        nameplate.powerbarCost:Hide();

        nameplate.powerbarCostSpark = nameplate.main:CreateTexture();
        nameplate.powerbarCostSpark:SetPoint("center", nameplate.powerbarCost, "left");
        nameplate.powerbarCostSpark:SetSize(10, 22);
        nameplate.powerbarCostSpark:SetTexture("Interface\\addons\\ClassicPlatesPlus\\media\\highlights\\spark");
        nameplate.powerbarCostSpark:SetVertexColor(0.5, 0.5, 1, 1);
        nameplate.powerbarCostSpark:SetBlendMode("add");
        nameplate.powerbarCostSpark:SetDrawLayer("artwork");
        nameplate.powerbarCostSpark:Hide();

        -- Extra bar
        nameplate.extraBar = CreateFrame("StatusBar", nil, nameplate.main);
        nameplate.extraBar:SetPoint("top", nameplate.border, "center", 0, -17);
        nameplate.extraBar:SetSize(208, 18);
        nameplate.extraBar:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar");
        nameplate.extraBar:SetFrameLevel(1);
        nameplate.extraBar:Hide();

        nameplate.extraBar.spark = nameplate.main:CreateTexture();
        nameplate.extraBar.spark:SetParent(nameplate.extraBar);
        nameplate.extraBar.spark:SetPoint("center", nameplate.extraBar:GetStatusBarTexture(), "right");
        nameplate.extraBar.spark:SetSize(10, 22);
        nameplate.extraBar.spark:SetTexture("Interface\\addons\\ClassicPlatesPlus\\media\\highlights\\spark");
        nameplate.extraBar.spark:SetVertexColor(1, 0.82, 0, 0.7);
        nameplate.extraBar.spark:SetBlendMode("add");
        nameplate.extraBar.spark:SetDrawLayer("artwork");
        nameplate.extraBar.spark:Hide();

        nameplate.extraBar.background = nameplate.main:CreateTexture();
        nameplate.extraBar.background:SetParent(nameplate.extraBar);
        nameplate.extraBar.background:SetAllPoints();
        nameplate.extraBar.background:SetColorTexture(0.18, 0.18, 0.18, 0.85);
        nameplate.extraBar.background:SetDrawLayer("background");

        nameplate.extraBar.value = nameplate.main:CreateFontString(nil, "overlay", "GameFontNormalOutline");
        nameplate.extraBar.value:SetParent(nameplate.extraBar);
        nameplate.extraBar.value:SetPoint("center", nameplate.extraBar, "center");
        nameplate.extraBar.value:SetJustifyH("center");
        nameplate.extraBar.value:SetTextColor(
            CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile].HealthFontColor.r,
            CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile].HealthFontColor.g,
            CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile].HealthFontColor.b,
            CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile].HealthFontColor.a
        );
        nameplate.extraBar.value:SetScale(0.9 + scaleOffset);

        --------------------------------
        -- Class Power
        --------------------------------
        nameplate.classPower = CreateFrame("frame", nil, nameplate.main);
        nameplate.classPower:SetSize(data.classBarHeight, data.classBarHeight);
        nameplate.classPower:SetIgnoreParentScale(true);
        nameplate.classPower:Hide();

        -- Animation
        local function combatCheck()
            if InCombatLockdown() then
                return 1;
            else
                return 0.5;
            end
        end

        nameplate.animationShow = nameplate:CreateAnimationGroup();
        nameplate.animationShow.alpha = nameplate.animationShow:CreateAnimation("Alpha");
        nameplate.animationShow.alpha:SetDuration(0.18);
        nameplate.animationShow.alpha:SetFromAlpha(0);
        nameplate.animationShow.alpha:SetToAlpha(combatCheck());

        nameplate.animationHide = nameplate:CreateAnimationGroup();
        nameplate.animationHide.alpha = nameplate.animationHide:CreateAnimation("Alpha");
        nameplate.animationHide.alpha:SetDuration(0.18);
        nameplate.animationHide.alpha:SetFromAlpha(combatCheck());
        nameplate.animationHide.alpha:SetToAlpha(0);

        nameplate.animationHide:SetScript("OnFinished", function()
            nameplate:Hide();
        end);

        -- Aurasa counter
        nameplate.buffsCounter = nameplate:CreateFontString(nil, nil, "GameFontNormalOutline")
        nameplate.buffsCounter:SetTextColor(0,1,0);
        nameplate.debuffsCounter = nameplate:CreateFontString(nil, nil, "GameFontNormalOutline")
        nameplate.debuffsCounter:SetTextColor(1, 0.2, 0);

        -- Auras
        nameplate.buffs = {};
        nameplate.debuffs = {};

        nameplate:Hide();
    end
end

-----------------------------------------
-- Add personal nameplate
-----------------------------------------
function func:PersonalNameplateAdd()
    local nameplate = data.nameplate;

    if nameplate then
        local dummyAnchor = NamePlateDriverFrame.classNamePlateAlternatePowerBar or NamePlateDriverFrame.classNamePlatePowerBar or nameplate.powerbar;

        nameplate:ClearAllPoints();

        if data.isRetail then
            local myNameplate = C_NamePlate.GetNamePlateForUnit("player");

            nameplate:SetScale(0.7);

            if myNameplate then
                nameplate:SetParent(myNameplate);
                nameplate.main:SetPoint("center", nameplate, "center", 0, 0);
            end
        else
            nameplate:SetPoint("top", UIParent, "bottom", 0, CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile].PersonalNameplatePointY);
        end

        nameplate.main:SetScale(CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile].PersonalNameplatesScale - 0.2);
        nameplate.border:SetVertexColor(data.colors.border.r, data.colors.border.g, data.colors.border.b);

        if CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile].LargeMainValue then
            nameplate.healthMain:SetFontObject("GameFontNormalLargeOutline");
            nameplate.healthMain:SetScale(1.4 + scaleOffset);
        else
            nameplate.healthMain:SetFontObject("GameFontNormalOutline");
            nameplate.healthMain:SetScale(0.9 + scaleOffset);
        end

        nameplate.buffsCounter:SetScale(CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile].PersonalNameplatesScale + 0.5);
        nameplate.debuffsCounter:SetScale(CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile].PersonalNameplatesScale + 0.5);

        nameplate.classPower:SetPoint("top", dummyAnchor, "bottom", 0, -4);
        nameplate.classPower:SetHeight(data.classBarHeight);

        nameplate.healthSecondary:SetTextColor(
            CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile].HealthFontColor.r,
            CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile].HealthFontColor.g,
            CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile].HealthFontColor.b,
            CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile].HealthFontColor.a
        );
        nameplate.healthTotal:SetTextColor(
            CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile].HealthFontColor.r,
            CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile].HealthFontColor.g,
            CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile].HealthFontColor.b,
            CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile].HealthFontColor.a
        );
        nameplate.healthMain:SetTextColor(
            CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile].HealthFontColor.r,
            CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile].HealthFontColor.g,
            CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile].HealthFontColor.b,
            CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile].HealthFontColor.a
        );
        nameplate.powerMain:SetTextColor(
            CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile].HealthFontColor.r,
            CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile].HealthFontColor.g,
            CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile].HealthFontColor.b,
            CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile].HealthFontColor.a
        );
        nameplate.power:SetTextColor(
            CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile].HealthFontColor.r,
            CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile].HealthFontColor.g,
            CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile].HealthFontColor.b,
            CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile].HealthFontColor.a
        );
        nameplate.powerTotal:SetTextColor(
            CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile].HealthFontColor.r,
            CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile].HealthFontColor.g,
            CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile].HealthFontColor.b,
            CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile].HealthFontColor.a
        );

        func:Update_Health("player");

        nameplate.healthTotal:SetShown(CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile].PersonalNameplateTotalHealth);
        nameplate.powerTotal:SetShown(CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile].PersonalNameplateTotalPower);

        func:Toggle_ExtraBar();
        func:ToggleNameplatePersonal();
        func:Update_ClassPower();
    end
end

--------------------------------------------
-- Toggle extra bar
--------------------------------------------
function func:Toggle_ExtraBar()
    local nameplate = data.nameplate;
    local myNameplate = C_NamePlate.GetNamePlateForUnit("player");
    local alternatePower = NamePlateDriverFrame.classNamePlateAlternatePowerBar;
	local powerType = UnitPowerType("player", 1);
    local _, _, classID = UnitClass("player");
    local druidInCatOrBearFrom = classID == 11 and powerType ~= 0;
    local toggle = alternatePower or druidInCatOrBearFrom;
    local posY = 0;
    local scale = math.max(0.75, math.min(1.25, CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile].PersonalNameplatesScale)) -- Clamp Scale to the range [0.75, 1.25]

    if nameplate then
        -- Swapping border texture, calculating Y axis of the anchor and updating the extra powerbar values
        if toggle then
            nameplate.border:SetTexture("Interface\\addons\\ClassicPlatesPlus\\media\\borders\\personalExtra");
            posY = -30 + (scale - 0.75) * (22 / 0.5);
            func:Update_ExtraBar();
        else
            posY = -24 + (scale - 0.75) * (12 / 0.5);
            nameplate.border:SetTexture("Interface\\addons\\ClassicPlatesPlus\\media\\borders\\personal");
        end

        -- Adjusting nameplate position
        if data.isRetail then
            nameplate:ClearAllPoints();
            nameplate:SetPoint("bottom", myNameplate, "bottom", 0, posY);
        end

        -- Toggling extra bar
        nameplate.extraBar:SetShown(toggle);
        func:DefaultPowerBars();
        func:PositionAuras(nameplate);
    end
end

----------------------------------------
-- Toggle personal nameplate
----------------------------------------
function func:ToggleNameplatePersonal(event)
    local nameplate = data.nameplate;
    local toggle = false;

    if data.isRetail then
        local myNameplate = C_NamePlate.GetNamePlateForUnit("player");

        toggle = data.cvars.nameplateHideHealthAndPower == "0"
             and data.cvars.nameplateShowSelf == "1"
             and myNameplate
             and myNameplate:IsVisible()

    elseif CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile].PersonalNameplate then
        if not UnitIsDeadOrGhost("player") then
            local classID = select(3, UnitClass("player"));
            local powerType = UnitPowerType("player");

            if InCombatLockdown() or event == "PLAYER_REGEN_DISABLED" then
                nameplate:SetAlpha(1);
                toggle = true;
            else
                local fullHealth = UnitHealth("player") >= UnitHealthMax("player");

                nameplate:SetAlpha(0.5);

                if CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile].PersonalNameplateAlwaysShow then
                    toggle = true;
                elseif classID == 11 then -- If player is a druid
                    local noRage = UnitPower("player", 1) <= 0;
                    local fullEnergy = UnitPower("player", 3) == UnitPowerMax("player", 3);
                    local fullMana = UnitPower("player", 0) == UnitPowerMax("player", 0);

                    toggle = not (fullHealth and (powerType == 1 and noRage or powerType == 3 and fullEnergy or powerType == 0 and fullMana))
                elseif classID == 1 then -- If player is a warrior
                    local noRage = UnitPower("player", 1) <= 0;

                    toggle = not (fullHealth and (powerType == 1 and noRage));
                elseif classID == 6 then -- If player is a death knight
                    local noRunicPower = UnitPower("player", 6) <= 0;

                    toggle = not (fullHealth and noRunicPower);
                else
                    toggle = not (UnitPower("player") == UnitPowerMax("player") and fullHealth);
                end
            end
        end
    end

    if toggle then
        func:Update_Auras("player");
        nameplate.animationHide:Stop();
        nameplate:Show();
    else
        nameplate.animationHide:Play();
    end
end