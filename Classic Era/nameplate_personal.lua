----------------------------------------
-- Core
----------------------------------------
local myAddon, core = ...;
local func = core.func;
local data = core.data;

--------------------------------------
-- Create own nameplate
--------------------------------------
function func:PersonalNameplate()
    local scaleOffset = 0.40;

    if not data.nameplate then
        -- Anchor
        data.nameplate = CreateFrame("frame", myAddon .. "nameplateSelf", UIParent);
        data.nameplate:SetPoint("top", UIParent, "bottom", 0, Config.PersonalNameplatePointY);
        data.nameplate:SetSize(256,128);
        data.nameplate:SetFrameLevel(2);
        data.nameplate:SetMovable(true);
        data.nameplate:EnableMouse(false);
        data.nameplate:RegisterForDrag("LeftButton");
        data.nameplate:SetClampedToScreen(true);

        data.nameplate.isMoving = false;
        local startY = 0;
        local originalY = 0;

        data.nameplate:SetScript("OnDragStart", function(self)
            if IsControlKeyDown() then
                self.isMoving = true;
                startY = select(2, GetCursorPosition());
                originalY = self:GetTop();
            end
        end)

        data.nameplate:SetScript("OnDragStop", function(self)
            self.isMoving = false;
        end)

        data.nameplate:SetScript("OnUpdate", function(self)
            if self.isMoving then
                local y = select(2, GetCursorPosition());
                local deltaY = y - startY;

                -- Calculate the new Y-coordinate
                local newY = originalY + deltaY;

                -- Set the frame's position along the Y-axis
                self:SetPoint("top", UIParent, "bottom", 0, newY);
                Config.PersonalNameplatePointY = newY;
            end
        end)

        data.nameplate:SetScript("OnHide", function(self)
            self.isMoving = false;
        end)

        -- Main / Scale
        data.nameplate.main = CreateFrame("frame", nil, data.nameplate);
        data.nameplate.main:SetAllPoints();
        data.nameplate.main:SetScale(Config.PersonalNameplatesScale - 0.2); -- -1.2 matches other nameplates

        -- Border
        data.nameplate.border = data.nameplate.main:CreateTexture();
        data.nameplate.border:SetPoint("center");
        data.nameplate.border:SetSize(data.nameplate:GetSize());
        data.nameplate.border:SetTexture("Interface\\addons\\ClassicPlatesPlus\\media\\borders\\borderOwn");
        data.nameplate.border:SetVertexColor(data.colors.border.r, data.colors.border.g, data.colors.border.b);
        data.nameplate.border:SetDrawLayer("border", 1);

        -- Healthbar
        data.nameplate.healthbar = CreateFrame("StatusBar", nil, data.nameplate.main);
        data.nameplate.healthbar:SetPoint("top", data.nameplate.border, "center", 0, 36);
        data.nameplate.healthbar:SetSize(222, 28);
        data.nameplate.healthbar:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar");
        data.nameplate.healthbar:SetFrameLevel(1);
        data.nameplate.healthbar:SetStatusBarColor(0,1,0);

        data.nameplate.healthbarSpark = data.nameplate.main:CreateTexture();
        data.nameplate.healthbarSpark:SetParent(data.nameplate.main);
        data.nameplate.healthbarSpark:SetPoint("center", data.nameplate.healthbar:GetStatusBarTexture(), "right");
        data.nameplate.healthbarSpark:SetSize(16, 32);
        data.nameplate.healthbarSpark:SetTexture("Interface\\addons\\ClassicPlatesPlus\\media\\highlights\\spark");
        data.nameplate.healthbarSpark:SetVertexColor(1, 0.82, 0, 0.7);
        data.nameplate.healthbarSpark:SetBlendMode("ADD");
        data.nameplate.healthbarSpark:SetDrawLayer("artwork");
        data.nameplate.healthbarSpark:Hide();

        data.nameplate.healthbarBackground = data.nameplate.main:CreateTexture();
        data.nameplate.healthbarBackground:SetColorTexture(0.18, 0.18, 0.18, 0.85);
        data.nameplate.healthbarBackground:SetParent(data.nameplate.healthbar);
        data.nameplate.healthbarBackground:SetAllPoints();
        data.nameplate.healthbarBackground:SetDrawLayer("background");

        data.nameplate.healPrediction = data.nameplate.main:CreateTexture(nil, "background");
        data.nameplate.healPrediction:SetPoint("left", data.nameplate.healthbar:GetStatusBarTexture(), "right");
        data.nameplate.healPrediction:SetHeight(data.nameplate.healthbar:GetHeight());
        data.nameplate.healPrediction:SetTexture("Interface\\TARGETINGFRAME\\UI-StatusBar");
        data.nameplate.healPrediction:SetBlendMode("add");
        data.nameplate.healPrediction:SetVertexColor(0, 0.5, 0.0, 0.5);
        data.nameplate.healPrediction:Hide();

        data.nameplate.healPredictionSpark = data.nameplate.main:CreateTexture();
        data.nameplate.healPredictionSpark:SetParent(data.nameplate.main);
        data.nameplate.healPredictionSpark:SetPoint("center", data.nameplate.healPrediction, "right");
        data.nameplate.healPredictionSpark:SetSize(16, 32);
        data.nameplate.healPredictionSpark:SetTexture("Interface\\addons\\ClassicPlatesPlus\\media\\highlights\\spark");
        data.nameplate.healPredictionSpark:SetVertexColor(0, 1, 0, 0.33);
        data.nameplate.healPredictionSpark:SetBlendMode("add");
        data.nameplate.healPredictionSpark:SetDrawLayer("artwork");
        data.nameplate.healPredictionSpark:Hide();

        -- Health main
        data.nameplate.healthMain = data.nameplate.main:CreateFontString(nil, "overlay");
        data.nameplate.healthMain:SetParent(data.nameplate.main);
        data.nameplate.healthMain:SetPoint("center", data.nameplate.healthbar, "center", 0, -0.5);
        data.nameplate.healthMain:SetTextColor(
            Config.HealthFontColor.r,
            Config.HealthFontColor.g,
            Config.HealthFontColor.b,
            Config.HealthFontColor.a
        );
        if Config.LargeMainValue then
            data.nameplate.healthMain:SetFontObject("GameFontNormalLargeOutline");
            data.nameplate.healthMain:SetScale(1.4 + scaleOffset);
        else
            data.nameplate.healthMain:SetFontObject("GameFontNormalOutline");
            data.nameplate.healthMain:SetScale(0.9 + scaleOffset);
        end

        -- Health left
        data.nameplate.healthLeftSide = data.nameplate.main:CreateFontString(nil, "overlay", "GameFontNormalOutline");
        data.nameplate.healthLeftSide:SetParent(data.nameplate.main);
        data.nameplate.healthLeftSide:SetPoint("left", data.nameplate.healthbar, "left", 4, 0);
        data.nameplate.healthLeftSide:SetTextColor(
            Config.HealthFontColor.r,
            Config.HealthFontColor.g,
            Config.HealthFontColor.b,
            Config.HealthFontColor.a
        );
        data.nameplate.healthLeftSide:SetScale(0.9 + scaleOffset);

        -- Health total
        data.nameplate.healthTotal = data.nameplate.main:CreateFontString(nil, "overlay", "GameFontNormalOutline");
        data.nameplate.healthTotal:SetParent(data.nameplate.main);
        data.nameplate.healthTotal:SetPoint("right", data.nameplate.healthbar, "right", -4, 0);
        data.nameplate.healthTotal:SetTextColor(
            Config.HealthFontColor.r,
            Config.HealthFontColor.g,
            Config.HealthFontColor.b,
            Config.HealthFontColor.a
        );
        data.nameplate.healthTotal:SetScale(0.9 + scaleOffset);

        -- Powebar
        data.nameplate.powerbar = CreateFrame("StatusBar", nil, data.nameplate.main);
        data.nameplate.powerbar:SetPoint("top", data.nameplate.border, "center", 0, 5);
        data.nameplate.powerbar:SetSize(222, 18);
        data.nameplate.powerbar:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar");
        data.nameplate.powerbar:SetFrameLevel(1);

        data.nameplate.powerbarSpark = data.nameplate.main:CreateTexture();
        data.nameplate.powerbarSpark:SetParent(data.nameplate.main);
        data.nameplate.powerbarSpark:SetPoint("center", data.nameplate.powerbar:GetStatusBarTexture(), "right");
        data.nameplate.powerbarSpark:SetSize(12, 22);
        data.nameplate.powerbarSpark:SetTexture("Interface\\addons\\ClassicPlatesPlus\\media\\highlights\\spark");
        data.nameplate.powerbarSpark:SetVertexColor(1, 0.82, 0, 0.7);
        data.nameplate.powerbarSpark:SetBlendMode("add");
        data.nameplate.powerbarSpark:SetDrawLayer("artwork");
        data.nameplate.powerbarSpark:Hide();

        data.nameplate.powerbarBackground = data.nameplate.main:CreateTexture();
        data.nameplate.powerbarBackground:SetColorTexture(0.18, 0.18, 0.18, 0.85);
        data.nameplate.powerbarBackground:SetParent(data.nameplate.powerbar);
        data.nameplate.powerbarBackground:SetAllPoints();
        data.nameplate.powerbarBackground:SetDrawLayer("background");

        data.nameplate.powerMain = data.nameplate.main:CreateFontString(nil, "overlay", "GameFontNormalOutline");
        data.nameplate.powerMain:SetParent(data.nameplate.main);
        data.nameplate.powerMain:SetPoint("center", data.nameplate.powerbar, "center", 0, -0.2);
        data.nameplate.powerMain:SetTextColor(
            Config.HealthFontColor.r,
            Config.HealthFontColor.g,
            Config.HealthFontColor.b,
            Config.HealthFontColor.a
        );
        data.nameplate.powerMain:SetScale(0.9 + scaleOffset);

        data.nameplate.power = data.nameplate.main:CreateFontString(nil, "overlay", "GameFontNormalOutline");
        data.nameplate.power:SetParent(data.nameplate.main);
        data.nameplate.power:SetPoint("left", data.nameplate.powerbar, "left", 4, -0.2);
        data.nameplate.power:SetTextColor(
            Config.HealthFontColor.r,
            Config.HealthFontColor.g,
            Config.HealthFontColor.b,
            Config.HealthFontColor.a
        );
        data.nameplate.power:SetScale(0.9 + scaleOffset);

        data.nameplate.powerTotal = data.nameplate.main:CreateFontString(nil, "overlay", "GameFontNormalOutline");
        data.nameplate.powerTotal:SetParent(data.nameplate.main);
        data.nameplate.powerTotal:SetPoint("right", data.nameplate.powerbar, "right", -4, -0.2);
        data.nameplate.powerTotal:SetTextColor(
            Config.HealthFontColor.r,
            Config.HealthFontColor.g,
            Config.HealthFontColor.b,
            Config.HealthFontColor.a
        );
        data.nameplate.powerTotal:SetScale(0.9 + scaleOffset);

        data.nameplate.powerbarCost = data.nameplate.main:CreateTexture(nil, "background");
        data.nameplate.powerbarCost:SetPoint("right", data.nameplate.powerbar:GetStatusBarTexture(), "right");
        data.nameplate.powerbarCost:SetHeight(18);
        data.nameplate.powerbarCost:SetTexture("Interface\\TARGETINGFRAME\\UI-StatusBar");
        data.nameplate.powerbarCost:SetBlendMode("add");
        data.nameplate.powerbarCost:SetVertexColor(1, 1, 1, 0.6);
        data.nameplate.powerbarCost:Hide();

        data.nameplate.powerbarCostSpark = data.nameplate.main:CreateTexture();
        data.nameplate.powerbarCostSpark:SetPoint("center", data.nameplate.powerbarCost, "left");
        data.nameplate.powerbarCostSpark:SetSize(12, 22);
        data.nameplate.powerbarCostSpark:SetTexture("Interface\\addons\\ClassicPlatesPlus\\media\\highlights\\spark");
        data.nameplate.powerbarCostSpark:SetVertexColor(0.5, 0.5, 1, 1);
        data.nameplate.powerbarCostSpark:SetBlendMode("add");
        data.nameplate.powerbarCostSpark:SetDrawLayer("artwork");
        data.nameplate.powerbarCostSpark:Hide();

        -- Druid's bar
        data.nameplate.druidsBar = CreateFrame("StatusBar", nil, data.nameplate.main);
        data.nameplate.druidsBar:SetPoint("top", data.nameplate.border, "center", 0, -17);
        data.nameplate.druidsBar:SetSize(208, 18);
        data.nameplate.druidsBar:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar");
        data.nameplate.druidsBar:SetStatusBarColor(0,0,1);
        data.nameplate.druidsBar:SetFrameLevel(1);

        data.nameplate.druidsBarSpark = data.nameplate.main:CreateTexture();
        data.nameplate.druidsBarSpark:SetParent(data.nameplate.druidsBar);
        data.nameplate.druidsBarSpark:SetPoint("center", data.nameplate.druidsBar:GetStatusBarTexture(), "right");
        data.nameplate.druidsBarSpark:SetSize(12, 22);
        data.nameplate.druidsBarSpark:SetTexture("Interface\\addons\\ClassicPlatesPlus\\media\\highlights\\spark");
        data.nameplate.druidsBarSpark:SetVertexColor(1, 0.82, 0, 0.7);
        data.nameplate.druidsBarSpark:SetBlendMode("add");
        data.nameplate.druidsBarSpark:SetDrawLayer("artwork");
        data.nameplate.druidsBarSpark:Hide();

        data.nameplate.druidsBarBackground = data.nameplate.main:CreateTexture();
        data.nameplate.druidsBarBackground:SetParent(data.nameplate.druidsBar);
        data.nameplate.druidsBarBackground:SetAllPoints();
        data.nameplate.druidsBarBackground:SetColorTexture(0.18, 0.18, 0.18, 0.85);
        data.nameplate.druidsBarBackground:SetDrawLayer("background");

        data.nameplate.druidsBarValue = data.nameplate.main:CreateFontString(nil, "overlay", "GameFontNormalOutline");
        data.nameplate.druidsBarValue:SetParent(data.nameplate.druidsBar);
        data.nameplate.druidsBarValue:SetPoint("center", data.nameplate.druidsBar, "center");
        data.nameplate.druidsBarValue:SetTextColor(
            Config.HealthFontColor.r,
            Config.HealthFontColor.g,
            Config.HealthFontColor.b,
            Config.HealthFontColor.a
        );
        data.nameplate.druidsBarValue:SetScale(0.9 + scaleOffset);

        -- Animation
        local function combatCheck()
            if InCombatLockdown() then
                return 1;
            else
                return 0.4;
            end
        end

        data.nameplate.animationShow = data.nameplate:CreateAnimationGroup();
        data.nameplate.animationShow.alpha = data.nameplate.animationShow:CreateAnimation("Alpha");
        data.nameplate.animationShow.alpha:SetDuration(0.18);
        data.nameplate.animationShow.alpha:SetFromAlpha(0);
        data.nameplate.animationShow.alpha:SetToAlpha(combatCheck());

        data.nameplate.animationHide = data.nameplate:CreateAnimationGroup();
        data.nameplate.animationHide.alpha = data.nameplate.animationHide:CreateAnimation("Alpha");
        data.nameplate.animationHide.alpha:SetDuration(0.18);
        data.nameplate.animationHide.alpha:SetFromAlpha(combatCheck());
        data.nameplate.animationHide.alpha:SetToAlpha(0);

        data.nameplate:SetScript("OnShow", function(self)
            self.animationShow:Play();
        end);

        data.nameplate.animationHide:SetScript("OnFinished", function()
            data.nameplate:Hide();
        end)

        func:Update_Health("player");
        func:Update_Power("player");
        func:Update_DruidsBar();
    else
        data.nameplate.main:SetScale(Config.PersonalNameplatesScale - 0.2);
        data.nameplate.border:SetVertexColor(data.colors.border.r, data.colors.border.g, data.colors.border.b);

        if Config.LargeMainValue then
            data.nameplate.healthMain:SetFontObject("GameFontNormalLargeOutline");
            data.nameplate.healthMain:SetScale(1.4 + scaleOffset);
        else
            data.nameplate.healthMain:SetFontObject("GameFontNormalOutline");
            data.nameplate.healthMain:SetScale(0.9 + scaleOffset);
        end

        data.nameplate.healthLeftSide:SetTextColor(
            Config.HealthFontColor.r,
            Config.HealthFontColor.g,
            Config.HealthFontColor.b,
            Config.HealthFontColor.a
        );
        data.nameplate.healthTotal:SetTextColor(
            Config.HealthFontColor.r,
            Config.HealthFontColor.g,
            Config.HealthFontColor.b,
            Config.HealthFontColor.a
        );
        data.nameplate.healthMain:SetTextColor(
            Config.HealthFontColor.r,
            Config.HealthFontColor.g,
            Config.HealthFontColor.b,
            Config.HealthFontColor.a
        );
        data.nameplate.powerMain:SetTextColor(
            Config.HealthFontColor.r,
            Config.HealthFontColor.g,
            Config.HealthFontColor.b,
            Config.HealthFontColor.a
        );
        data.nameplate.power:SetTextColor(
            Config.HealthFontColor.r,
            Config.HealthFontColor.g,
            Config.HealthFontColor.b,
            Config.HealthFontColor.a
        );
        data.nameplate.powerTotal:SetTextColor(
            Config.HealthFontColor.r,
            Config.HealthFontColor.g,
            Config.HealthFontColor.b,
            Config.HealthFontColor.a
        );

        func:Update_Health("player");
    end

    data.nameplate.healthTotal:SetShown(Config.PersonalNameplateTotalHealth);
    data.nameplate.powerTotal:SetShown(Config.PersonalNameplateTotalPower);

    func:ToggleNameplatePersonal();
end

--------------------------------------------
-- Druid's bar
--------------------------------------------
function func:Update_DruidsBar()
	local powerType = UnitPowerType("player", 1);
    local _, _, classID = UnitClass("player");
    local nameplate = data.nameplate;

    if nameplate then
        if powerType ~= 0 and classID == 11 then
            data.nameplate.border:SetTexture("Interface\\addons\\ClassicPlatesPlus\\media\\borders\\borderOwnDruid");
            data.nameplate.druidsBar:Show();
        else
            data.nameplate.druidsBar:Hide();
            data.nameplate.border:SetTexture("Interface\\addons\\ClassicPlatesPlus\\media\\borders\\borderOwn");
        end
    end
end

----------------------------------------
-- togle own nameplate
----------------------------------------
function func:ToggleNameplatePersonal(event)
    if Config.PersonalNameplate then
        local _, _, classID = UnitClass("player");
        local powerType = UnitPowerType("player");

        if InCombatLockdown() or event == "PLAYER_REGEN_DISABLED" then
            data.nameplate:SetAlpha(1);
            data.nameplate:Show();
        else
            data.nameplate:SetAlpha(0.4);

            if UnitIsDeadOrGhost("player") then
                data.nameplate.animationHide:Play();
            elseif classID == 11 then
                if powerType == 1 then
                    if UnitPower("player") == 0
                    and UnitHealth("player") == UnitHealthMax("player")
                    and UnitPower("player", 0) == UnitPowerMax("player", 0)
                    then
                        data.nameplate.animationHide:Play();
                    else
                        data.nameplate:Show();
                    end
                elseif powerType == 3 then
                    if UnitPower("player") == UnitPowerMax("player")
                    and UnitHealth("player") == UnitHealthMax("player")
                    and UnitPower("player", 0) == UnitPowerMax("player", 0)
                    then
                        data.nameplate.animationHide:Play();
                    else
                        data.nameplate:Show();
                    end
                else
                    if UnitPower("player") == UnitPowerMax("player")
                    and UnitHealth("player") == UnitHealthMax("player")
                    then
                        data.nameplate.animationHide:Play();
                    else
                        data.nameplate:Show();
                    end
                end
            elseif classID == 1 then
                if UnitPower("player") <= 0
                and UnitHealth("player") == UnitHealthMax("player") then
                    data.nameplate.animationHide:Play();
                else
                    data.nameplate:Show();
                end
            else
                if UnitPower("player") == UnitPowerMax("player")
                and UnitHealth("player") == UnitHealthMax("player")
                then
                    data.nameplate.animationHide:Play();
                else
                    data.nameplate:Show();
                end
            end
        end
    else
        data.nameplate:Hide();
    end
end