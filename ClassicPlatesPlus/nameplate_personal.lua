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
        local CFG = CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile];

        -- Anchor
        data.nameplate = CreateFrame("frame", myAddon .. "nameplateSelf", UIParent);

        local nameplate = data.nameplate;

        nameplate:SetSize(256,64);
        nameplate:SetFrameLevel(2);
        nameplate:SetScript("OnShow", function(self)
            func:DefaultPowerBars();
        end);

        -- Dragging Personal Nameplate
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
                    CFG.PersonalNameplatePointY = newY;

                    -- Updating Personal Nameplate Configs
                    local SettingFrame = _G[data.settings.configs.all.PersonalNameplatePointY.frame];

                    if SettingFrame then
                        SettingFrame:SetValue(CFG.PersonalNameplatePointY);
                    end
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
        nameplate.main:SetScale(CFG.PersonalNameplatesScale - 0.2);

        -- Border
        nameplate.border = nameplate.main:CreateTexture();
        nameplate.border:SetPoint("center");
        nameplate.border:SetSize(256,128);
        nameplate.border:SetTexture("Interface\\addons\\ClassicPlatesPlus\\media\\borders\\borderOwn");
        nameplate.border:SetVertexColor(CFG.BorderColor.r, CFG.BorderColor.g, CFG.BorderColor.b);
        nameplate.border:SetDrawLayer("border", 1);

        -- Healthbar
        nameplate.healthbar = CreateFrame("StatusBar", nil, nameplate.main);
        nameplate.healthbar:SetPoint("top", nameplate.border, "center", 0, 36);
        nameplate.healthbar:SetSize(222, 28);
        nameplate.healthbar:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar");
        nameplate.healthbar:SetStatusBarColor(0,1,0);
        nameplate.healthbar:SetFrameLevel(1);

        nameplate.healthbarChange = nameplate.main:CreateTexture();
        nameplate.healthbarChange:SetParent(nameplate.healthbar);
        nameplate.healthbarChange:SetHeight(28);
        nameplate.healthbarChange:SetTexture("Interface\\TargetingFrame\\UI-StatusBar");
        nameplate.healthbarChange:SetVertexColor(0.7, 0, 0, 1);
        nameplate.healthbarChange:SetDrawLayer("background", 3);
        nameplate.healthbarChange:Hide();

        nameplate.healthbarChange.animation_group = nameplate.healthbarChange:CreateAnimationGroup();
        nameplate.healthbarChange.animation_group.scale = nameplate.healthbarChange.animation_group:CreateAnimation("Scale");
        nameplate.healthbarChange.animation_group.scale:SetDuration(1);
        nameplate.healthbarChange.animation_group.scale:SetScaleFrom(1, 1);
        nameplate.healthbarChange.animation_group.scale:SetScale(0, 1);
        nameplate.healthbarChange.animation_group.scale:SetSmoothing("IN");
        nameplate.healthbarChange.animation_group.scale:SetOrigin("left", 0, 0);
        nameplate.healthbarChange.animation_group:SetScript("OnFinished", function(self)
            nameplate.healthbarChange:Hide();
        end);
        nameplate.healthbar:SetScript("OnValueChanged", function(self, newValue)
            if CFG.PersonalHealthBarAnimation then
                local prevValue = data.nameplate.prevHealthValue;

                if prevValue then
                    local healthMax = UnitHealthMax("player");

                    local function GetWidth(difference)
                        return difference / healthMax * self:GetWidth();
                    end

                    if newValue < prevValue then
                        local difference = prevValue - newValue;

                        if difference > 1 and prevValue <= healthMax then
                            local diffWidth = GetWidth(difference);
                            local valWidth = GetWidth(newValue)
                            local percentage = (difference / healthMax) * 100;

                            if percentage > CFG.PersonalHealthBarAnimationThreshold then
                                nameplate.healthbarChange:ClearAllPoints();
                                nameplate.healthbarChange:SetPoint("left", nameplate.healthbar, "right", -(nameplate.healthbar:GetWidth() - valWidth), 0);
                                nameplate.healthbarChange:SetWidth(diffWidth);
                                nameplate.healthbarChange:Show();
                                nameplate.healthbarChange.animation_group:Restart();
                            end
                        end
                    end
                end
            end
        end);

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
        nameplate.healthbarBackground:SetDrawLayer("background", 2);

        nameplate.healPrediction = nameplate.main:CreateTexture(nil, "background");
        nameplate.healPrediction:SetPoint("left", nameplate.healthbar:GetStatusBarTexture(), "right");
        nameplate.healPrediction:SetHeight(nameplate.healthbar:GetHeight());
        nameplate.healPrediction:SetTexture("Interface\\addons\\ClassicPlatesPlus\\media\\highlights\\healPredict");
        nameplate.healPrediction:SetBlendMode("add");
        nameplate.healPrediction:SetVertexColor(0, 0.5, 0.0, 0.5);
        nameplate.healPrediction:Hide();

        -- Animation: Group Alpha
        nameplate.healPrediction.animationGroupAlpha = nameplate.healPrediction:CreateAnimationGroup();
        nameplate.healPrediction.animation_Alpha_From = nameplate.healPrediction.animationGroupAlpha:CreateAnimation("Alpha");
        nameplate.healPrediction.animation_Alpha_From:SetDuration(0.36);
        nameplate.healPrediction.animation_Alpha_From:SetFromAlpha(0.6);
        nameplate.healPrediction.animation_Alpha_From:SetToAlpha(0.2);
        nameplate.healPrediction.animationGroupAlpha:SetLooping("BOUNCE");
        nameplate.healPrediction.animationGroupAlpha:Stop();

        -- Animation: Group Scale
        nameplate.healPrediction.animationGroupScale = nameplate.healPrediction:CreateAnimationGroup();
        nameplate.healPrediction.animation_Scale_From = nameplate.healPrediction.animationGroupScale:CreateAnimation("Scale");
        nameplate.healPrediction.animation_Scale_From:SetDuration(0.36);
        nameplate.healPrediction.animation_Scale_From:SetScaleFrom(1, 1);
        nameplate.healPrediction.animation_Scale_From:SetScaleTo(0.25, 1);
        nameplate.healPrediction.animation_Scale_From:SetOrigin("left", 0, 0);
        nameplate.healPrediction.animationGroupScale:SetLooping("BOUNCE");
        nameplate.healPrediction.animationGroupScale:Stop();

        -- Health main
        nameplate.healthMain = nameplate.main:CreateFontString(nil, "overlay");
        nameplate.healthMain:SetParent(nameplate.main);
        nameplate.healthMain:SetPoint("center", nameplate.healthbar, "center", 0, -0.5);
        nameplate.healthMain:SetJustifyH("center");
        nameplate.healthMain:SetTextColor(
            CFG.HealthFontColor.r,
            CFG.HealthFontColor.g,
            CFG.HealthFontColor.b,
            CFG.HealthFontColor.a
        );
        if CFG.LargeMainValue then
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
            CFG.HealthFontColor.r,
            CFG.HealthFontColor.g,
            CFG.HealthFontColor.b,
            CFG.HealthFontColor.a
        );
        nameplate.healthSecondary:SetScale(0.9 + scaleOffset);

        -- Health total
        nameplate.healthTotal = nameplate.main:CreateFontString(nil, "overlay", "GameFontNormalOutline");
        nameplate.healthTotal:SetParent(nameplate.main);
        nameplate.healthTotal:SetPoint("right", nameplate.healthbar, "right", -4, 0);
        nameplate.healthTotal:SetJustifyH("right");
        nameplate.healthTotal:SetTextColor(
            CFG.HealthFontColor.r,
            CFG.HealthFontColor.g,
            CFG.HealthFontColor.b,
            CFG.HealthFontColor.a
        );
        nameplate.healthTotal:SetScale(0.9 + scaleOffset);

        -- Powebar
        nameplate.powerbar = CreateFrame("StatusBar", nil, nameplate.main);
        nameplate.powerbar:SetPoint("top", nameplate.border, "center", 0, 5);
        nameplate.powerbar:SetSize(222, 18);
        nameplate.powerbar:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar");
        nameplate.powerbar:SetFrameLevel(1);

        nameplate.powerbarChange = nameplate.main:CreateTexture(nil, "background");
        nameplate.powerbarChange:SetHeight(18);
        nameplate.powerbarChange:SetTexture("Interface\\Buttons\\WHITE8x8");
        nameplate.powerbarChange:SetVertexColor(0.75, 0.75, 1, 1);
        nameplate.powerbarChange:SetBlendMode("ADD");
        nameplate.powerbarChange:Hide();

        nameplate.powerbarChange.animation_group_1 = nameplate.powerbarChange:CreateAnimationGroup();
        nameplate.powerbarChange.animation_group_1.scale = nameplate.powerbarChange.animation_group_1:CreateAnimation("Scale");
        nameplate.powerbarChange.animation_group_1.scale:SetDuration(0.5);
        nameplate.powerbarChange.animation_group_1.scale:SetScaleFrom(1, 1);
        nameplate.powerbarChange.animation_group_1.scale:SetScale(0, 1);
        nameplate.powerbarChange.animation_group_1.scale:SetSmoothing("IN");
        nameplate.powerbarChange.animation_group_1.scale:SetOrigin("right", 0, 0);

        nameplate.powerbarChange.animation_group_2 = nameplate.powerbarChange:CreateAnimationGroup();
        nameplate.powerbarChange.animation_group_2.alpha = nameplate.powerbarChange.animation_group_2:CreateAnimation("Alpha");
        nameplate.powerbarChange.animation_group_2.alpha:SetDuration(0.5);
        nameplate.powerbarChange.animation_group_2.alpha:SetFromAlpha(1);
        nameplate.powerbarChange.animation_group_2.alpha:SetToAlpha(0);
        nameplate.powerbarChange.animation_group_2.alpha:SetSmoothing("IN_OUT");

        nameplate.powerbarChange.animation_group_1:SetScript("OnFinished", function(self)
            nameplate.powerbarChange:Hide();
        end);

        nameplate.powerbarChange.animation_group_2:SetScript("OnFinished", function(self)
            nameplate.powerbarChange:Hide();
        end);

        nameplate.powerbar:SetScript("OnValueChanged", function(self, newValue)
            if CFG.PersonalPowerBarAnimation then
                local prevValue = data.nameplate.prevPowerValue;
                local prewPower = data.nameplate.prevPowerType;

                if prevValue then
                    local powerMax = UnitPowerMax("player");
                    local powerType = UnitPowerType("player");

                    local function GetWidth(difference)
                        return difference / powerMax * self:GetWidth();
                    end

                    if powerType == prewPower then
                        if newValue < prevValue then
                            local difference = prevValue - newValue;

                            if difference > 1 then
                                local diffWidth = GetWidth(difference);
                                local valWidth = GetWidth(newValue)
                                local percentage = (difference / powerMax) * 100;

                                if percentage > CFG.PersonalPowerBarAnimationThreshold then
                                    nameplate.powerbarChange:ClearAllPoints();
                                    nameplate.powerbarChange:SetPoint("left", nameplate.powerbar, "right", -(nameplate.powerbar:GetWidth() - valWidth), 0);
                                    nameplate.powerbarChange:SetWidth(diffWidth);
                                    nameplate.powerbarChange:Show();
                                    nameplate.powerbarChange.animation_group_2:Restart();
                                    nameplate.powerbarChange.animation_group_1:Stop();
                                end
                            end
                        elseif newValue > prevValue then
                            local difference = newValue - prevValue;

                            if difference > 1 then
                                local diffWidth = GetWidth(difference);
                                local percentage = (difference / powerMax) * 100;

                                if diffWidth > nameplate.powerbar:GetWidth() then
                                    diffWidth = nameplate.powerbar:GetWidth();
                                end

                                if percentage > CFG.PersonalPowerBarAnimationThreshold then
                                    nameplate.powerbarChange:ClearAllPoints();
                                    nameplate.powerbarChange:SetPoint("right", self:GetStatusBarTexture(), "right");
                                    nameplate.powerbarChange:SetWidth(diffWidth);
                                    nameplate.powerbarChange:SetShown(diffWidth > 0);
                                    nameplate.powerbarChange.animation_group_1:Restart();
                                    nameplate.powerbarChange.animation_group_2:Stop();
                                end
                            end
                        end
                    end
                end
            end
        end);

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
            CFG.HealthFontColor.r,
            CFG.HealthFontColor.g,
            CFG.HealthFontColor.b,
            CFG.HealthFontColor.a
        );
        nameplate.powerMain:SetScale(0.9 + scaleOffset);

        nameplate.power = nameplate.main:CreateFontString(nil, "overlay", "GameFontNormalOutline");
        nameplate.power:SetParent(nameplate.main);
        nameplate.power:SetPoint("left", nameplate.powerbar, "left", 4, -0.2);
        nameplate.power:SetJustifyH("left");
        nameplate.power:SetTextColor(
            CFG.HealthFontColor.r,
            CFG.HealthFontColor.g,
            CFG.HealthFontColor.b,
            CFG.HealthFontColor.a
        );
        nameplate.power:SetScale(0.9 + scaleOffset);

        nameplate.powerTotal = nameplate.main:CreateFontString(nil, "overlay", "GameFontNormalOutline");
        nameplate.powerTotal:SetParent(nameplate.main);
        nameplate.powerTotal:SetPoint("right", nameplate.powerbar, "right", -4, -0.2);
        nameplate.powerTotal:SetJustifyH("right");
        nameplate.powerTotal:SetTextColor(
            CFG.HealthFontColor.r,
            CFG.HealthFontColor.g,
            CFG.HealthFontColor.b,
            CFG.HealthFontColor.a
        );
        nameplate.powerTotal:SetScale(0.9 + scaleOffset);

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
            CFG.HealthFontColor.r,
            CFG.HealthFontColor.g,
            CFG.HealthFontColor.b,
            CFG.HealthFontColor.a
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
    local CFG = CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile];
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
            nameplate:SetPoint("top", UIParent, "bottom", 0, CFG.PersonalNameplatePointY);
        end

        nameplate.main:SetScale(CFG.PersonalNameplatesScale - 0.2);
        nameplate.border:SetVertexColor(CFG.BorderColor.r, CFG.BorderColor.g, CFG.BorderColor.b);

        if CFG.LargeMainValue then
            nameplate.healthMain:SetFontObject("GameFontNormalLargeOutline");
            nameplate.healthMain:SetScale(1.4 + scaleOffset);
        else
            nameplate.healthMain:SetFontObject("GameFontNormalOutline");
            nameplate.healthMain:SetScale(0.9 + scaleOffset);
        end

        nameplate.buffsCounter:SetScale(CFG.AurasScale + 0.2);
        nameplate.debuffsCounter:SetScale(CFG.AurasScale + 0.2);

        nameplate.classPower:SetPoint("top", dummyAnchor, "bottom", 0, -4);
        nameplate.classPower:SetHeight(data.classBarHeight);

        nameplate.healthSecondary:SetTextColor(
            CFG.HealthFontColor.r,
            CFG.HealthFontColor.g,
            CFG.HealthFontColor.b,
            CFG.HealthFontColor.a
        );
        nameplate.healthTotal:SetTextColor(
            CFG.HealthFontColor.r,
            CFG.HealthFontColor.g,
            CFG.HealthFontColor.b,
            CFG.HealthFontColor.a
        );
        nameplate.healthMain:SetTextColor(
            CFG.HealthFontColor.r,
            CFG.HealthFontColor.g,
            CFG.HealthFontColor.b,
            CFG.HealthFontColor.a
        );
        nameplate.powerMain:SetTextColor(
            CFG.HealthFontColor.r,
            CFG.HealthFontColor.g,
            CFG.HealthFontColor.b,
            CFG.HealthFontColor.a
        );
        nameplate.power:SetTextColor(
            CFG.HealthFontColor.r,
            CFG.HealthFontColor.g,
            CFG.HealthFontColor.b,
            CFG.HealthFontColor.a
        );
        nameplate.powerTotal:SetTextColor(
            CFG.HealthFontColor.r,
            CFG.HealthFontColor.g,
            CFG.HealthFontColor.b,
            CFG.HealthFontColor.a
        );

        func:Update_Health("player");
        func:Update_Power("player");

        nameplate.healthTotal:SetShown(CFG.PersonalNameplateTotalHealth);
        nameplate.powerTotal:SetShown(CFG.PersonalNameplateTotalPower);

        func:Toggle_ExtraBar();
        func:ToggleNameplatePersonal();
        func:Update_ClassPower();
    end
end

--------------------------------------------
-- Toggle extra bar
--------------------------------------------
function func:Toggle_ExtraBar()
    local CFG = CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile];
    local nameplate = data.nameplate;
    local myNameplate = C_NamePlate.GetNamePlateForUnit("player");
    local alternatePower = NamePlateDriverFrame.classNamePlateAlternatePowerBar;
	local powerType = UnitPowerType("player");
    local _, _, classID = UnitClass("player");
    local druidInCatOrBearFrom = classID == 11 and powerType ~= 0;
    local toggle = alternatePower or druidInCatOrBearFrom;
    local posY = 0;
    local scale = math.max(0.75, math.min(1.25, CFG.PersonalNameplatesScale)) -- Clamp Scale to the range [0.75, 1.25]

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
    local CFG = CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile];
    local nameplate = data.nameplate;
    local toggle = false;

    if data.isRetail then
        local myNameplate = C_NamePlate.GetNamePlateForUnit("player");

        toggle = data.cvars.nameplateHideHealthAndPower == "0"
             and data.cvars.nameplateShowSelf == "1"
             and myNameplate
             and myNameplate:IsVisible()

    elseif CFG.PersonalNameplate then
        if not UnitIsDeadOrGhost("player") then
            local classID = select(3, UnitClass("player"));
            local powerType = UnitPowerType("player");

            if InCombatLockdown() or event == "PLAYER_REGEN_DISABLED" then
                nameplate:SetAlpha(1);
                toggle = true;
            else
                local fullHealth = UnitHealth("player") >= UnitHealthMax("player");

                if CFG.PersonalNameplateFade then
                    nameplate:SetAlpha(CFG.PersonalNameplateFadeIntensity);
                else
                    nameplate:SetAlpha(1);
                end

                if CFG.PersonalNameplateAlwaysShow then
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