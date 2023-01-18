----------------------------------------
-- Core
----------------------------------------
local myAddon, core = ...;
local func = core.func;
local data = core.data;
local isClassic = WOW_PROJECT_ID == WOW_PROJECT_CLASSIC;

--[[ TO DO LIST
    Add important auras warnings

    ...Down the line check Retail compatability.
]]

----------------------------------------
-- Creating nameplate
----------------------------------------
function func:Nameplate_Created(nameplate)
    if nameplate then
        local unitFrame = CreateFrame("frame", nil, nameplate);

        nameplate.unitFrame = unitFrame;

        -- Parent
        unitFrame:SetFrameStrata("low");
        unitFrame:SetFrameLevel(2);

        -- Highlight
        unitFrame.highlight = unitFrame:CreateTexture(nil, "background");

        -- Border
        unitFrame.border = unitFrame:CreateTexture();
        unitFrame.border:SetTexture("Interface\\addons\\ReubinsNameplates\\media\\nameplate\\border");
        unitFrame.border:SetSize(256, 32);
        unitFrame.border:SetVertexColor(data.colors.nameplateBorder.r, data.colors.nameplateBorder.g, data.colors.nameplateBorder.b);

        -- Portrait frame
        unitFrame.portrait = CreateFrame("Frame");

        -- Portrait texture
        unitFrame.portrait.texture = unitFrame:CreateTexture();
        unitFrame.portrait.texture:SetSize(24, 24);

        -- Portrait border
        unitFrame.portrait.border = unitFrame:CreateTexture();
        unitFrame.portrait.border:SetTexture("Interface\\addons\\ReubinsNameplates\\media\\nameplate\\borderPortrait");
        unitFrame.portrait.border:SetSize(32, 32);
        unitFrame.portrait.border:SetVertexColor(data.colors.nameplateBorder.r, data.colors.nameplateBorder.g, data.colors.nameplateBorder.b);

        -- Classification
        unitFrame.classification = unitFrame:CreateTexture();

        -- PVP flag
        unitFrame.pvp_flag = unitFrame:CreateTexture();
        unitFrame.pvp_flag:SetSize(40, 40);

        -- Name
        unitFrame.name = unitFrame:CreateFontString(nil, nil, "GameFontNormal");
        unitFrame.name:SetTextColor(data.colors.nameDefault.r, data.colors.nameDefault.g, data.colors.nameDefault.b);

        -- Level
        unitFrame.level = unitFrame:CreateFontString(nil, nil, "GameFontNormalSmall");

        -- High level icon
        unitFrame.high_level_texture = unitFrame:CreateTexture();
        unitFrame.high_level_texture:SetTexture("Interface\\addons\\ReubinsNameplates\\media\\icons\\skull");
        unitFrame.high_level_texture:SetSize(18, 18);

        -- Health numerical
        unitFrame.health_center = unitFrame:CreateFontString(nil, "overlay");
        unitFrame.health_center:SetShadowColor(0, 0, 0);
        unitFrame.health_center:SetShadowOffset(1, -1);

        -- Health percentage
        unitFrame.health_left = unitFrame:CreateFontString(nil, "overlay");
        unitFrame.health_left:SetFont("Fonts\\FRIZQT__.TTF", 10, "Outline");
        unitFrame.health_left:SetShadowColor(0, 0, 0);
        unitFrame.health_left:SetShadowOffset(1, -1);

        -- Healthbar
        unitFrame.healthbar = CreateFrame("StatusBar");
        unitFrame.healthbar:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar");
        unitFrame.healthbar:SetSize(112, 10);

        -- Healthbar highlight
        unitFrame.healthbar_highlight = unitFrame:CreateTexture();
        unitFrame.healthbar_highlight:SetColorTexture(1, 1, 1, 0.1);
        unitFrame.healthbar_highlight:SetBlendMode("add");
        unitFrame.healthbar_highlight:Hide();

        -- Healthbar spark
        unitFrame.healthbar_spark = unitFrame:CreateTexture();
        unitFrame.healthbar_spark:SetTexture("Interface\\addons\\ReubinsNameplates\\media\\highlights\\spark");
        unitFrame.healthbar_spark:SetVertexColor(1, 0.82, 0, 0.7);
        unitFrame.healthbar_spark:SetBlendMode("ADD");
        unitFrame.healthbar_spark:SetSize(4, 12);

        -- Healthbar background
        unitFrame.healthbar_background = unitFrame:CreateTexture();
        unitFrame.healthbar_background:SetColorTexture(0.18, 0.18, 0.18, 0.85);

        -- Powerbar parent
        unitFrame.powerbar = CreateFrame("Frame");

        -- Powerbar statusbar
        unitFrame.powerbar.statusbar = CreateFrame("StatusBar");
        unitFrame.powerbar.statusbar:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar");

        -- Powerbar spark
        unitFrame.powerbar.spark = unitFrame:CreateTexture();
        unitFrame.powerbar.spark:SetTexture("Interface\\addons\\ReubinsNameplates\\media\\highlights\\spark");
        unitFrame.powerbar.spark:SetVertexColor(1, 0.82, 0, 0.7);
        unitFrame.powerbar.spark:SetBlendMode("ADD");
        unitFrame.powerbar.spark:SetSize(4, 4);

        -- Powerbar border
        unitFrame.powerbar.border = unitFrame:CreateTexture();
        unitFrame.powerbar.border:SetSize(128, 16);
        unitFrame.powerbar.border:SetVertexColor(data.colors.nameplateBorder.r, data.colors.nameplateBorder.g, data.colors.nameplateBorder.b);

        -- Powerbar background
        unitFrame.powerbar.border_background = unitFrame:CreateTexture();
        unitFrame.powerbar.border_background:SetColorTexture(0.22, 0.22, 0.22, 0.85);

        -- Threat frame
        unitFrame.threat = {};

        -- Threat icon parent
        unitFrame.threat.icon = CreateFrame("Frame");

        -- Threat icon
        unitFrame.threat.icon.texture = unitFrame:CreateTexture();
        unitFrame.threat.icon.texture:SetSize(36, 36);

        -- Threat animation group
        unitFrame.threat.animation = unitFrame.threat.icon:CreateAnimationGroup();

        -- Threat animation alpha
        local alphaAnimation = unitFrame.threat.animation:CreateAnimation("Alpha");
        alphaAnimation:SetDuration(0.2);
        alphaAnimation:SetFromAlpha(0);
        alphaAnimation:SetToAlpha(1);

        -- Threat animation scale
        local scaleAnimation = unitFrame.threat.animation:CreateAnimation("Scale");
        scaleAnimation:SetDuration(0.25);
        if isClassic then
            scaleAnimation:SetFromScale(2, 2);
            scaleAnimation:SetToScale(1, 1);
        else
            scaleAnimation:SetScaleFrom(2, 2);
            scaleAnimation:SetScaleTo(1, 1);
        end
        unitFrame.threat.animation:Stop();

        -- Threat percentage
        unitFrame.threat.percentage = CreateFrame("Frame");

        -- Threat text
        unitFrame.threat.percentage.text = unitFrame:CreateFontString();
        unitFrame.threat.percentage.text:SetFont("Fonts\\FRIZQT__.TTF", 10, "Outline");
        unitFrame.threat.percentage.text:SetShadowColor(0, 0, 0);
        unitFrame.threat.percentage.text:SetShadowOffset(1, -1);
        unitFrame.threat.percentage.text:SetTextColor(1, 1, 1);

        -- Threat border
        unitFrame.threat.percentage.border = unitFrame:CreateTexture();
        unitFrame.threat.percentage.border:SetTexture("Interface\\addons\\ReubinsNameplates\\media\\nameplate\\borderThreat");
        unitFrame.threat.percentage.border:SetSize(64, 32);
        unitFrame.threat.percentage.border:SetVertexColor(data.colors.nameplateBorder.r, data.colors.nameplateBorder.g, data.colors.nameplateBorder.b);

        -- Threat background
        unitFrame.threat.percentage.background = unitFrame:CreateTexture();
        unitFrame.threat.percentage.background:SetTexture("Interface\\addons\\ReubinsNameplates\\media\\nameplate\\backgroundThreat");
        unitFrame.threat.percentage.background:SetSize(64, 16);

        -- Auras table
        unitFrame.auras = {};

        -- Castbar frame
        unitFrame.castbar = CreateFrame("frame");
        unitFrame.castbar:SetSize(256, 64);

        -- Castbar border
        unitFrame.castbar.border = unitFrame:CreateTexture();
        unitFrame.castbar.border:SetTexture("Interface\\addons\\ReubinsNameplates\\media\\castbar\\castbarUI");
        unitFrame.castbar.border:SetVertexColor(0.75, 0.75, 0.75);

        -- Castbar icon mask
        unitFrame.castbar.mask = unitFrame:CreateMaskTexture();
        unitFrame.castbar.mask:SetSize(32, 32);
        unitFrame.castbar.mask:SetTexture("Interface\\addons\\ReubinsNameplates\\media\\castbar\\castbarMask");

        -- Castbar icon
        unitFrame.castbar.icon = unitFrame:CreateTexture();
        unitFrame.castbar.icon:SetSize(18, 18);
        unitFrame.castbar.icon:AddMaskTexture(unitFrame.castbar.mask);

        -- Castbar name
        unitFrame.castbar.name = unitFrame:CreateFontString(nil, nil, "GameFontHighlightSmall");
        unitFrame.castbar.name:SetScale(0.8);

        -- Castbar countdown
        unitFrame.castbar.countdown = unitFrame:CreateFontString(nil, nil, "GameFontNormalSmall");
        unitFrame.castbar.countdown:SetScale(0.9);

        -- Castbar progress bar
        unitFrame.castbar.statusbar = CreateFrame("StatusBar");
        unitFrame.castbar.statusbar:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar");
        unitFrame.castbar.statusbar:SetSize(112, 10);
        unitFrame.castbar.statusbar:SetStatusBarColor(data.colors.orange.r, data.colors.orange.g, data.colors.orange.b);

        -- Castbar spark
        unitFrame.castbar.spark = unitFrame:CreateTexture();
        unitFrame.castbar.spark:SetTexture("Interface\\CastingBar\\UI-CastingBar-Spark");
        unitFrame.castbar.spark:SetBlendMode("ADD");
        unitFrame.castbar.spark:SetSize(32, 32);

        -- Castbar background
        unitFrame.castbar.background = unitFrame:CreateTexture();
        unitFrame.castbar.background:SetColorTexture(0.18, 0.18, 0.18, 0.85);

        -- Castbar animation group
        unitFrame.castbar.animation = unitFrame.castbar:CreateAnimationGroup();

        -- Castbar animation alpha
        local castbar_animation_alpha = unitFrame.castbar.animation:CreateAnimation("Alpha");
        castbar_animation_alpha:SetStartDelay(0.36);
        castbar_animation_alpha:SetDuration(0.36);
        castbar_animation_alpha:SetFromAlpha(1);
        castbar_animation_alpha:SetToAlpha(0);

        -- Raid target parent
        unitFrame.raidTarget = CreateFrame("Frame");

        -- Raid target icon
        unitFrame.raidTarget.icon = unitFrame:CreateTexture();
        unitFrame.raidTarget.icon:SetSize(20, 20);

        -- Hiding what has to be hidden
        unitFrame.threat.percentage:Hide();
        unitFrame.raidTarget:Hide();
        unitFrame.castbar:Hide();
        unitFrame:Hide();
    end
end

----------------------------------------
-- Adding nameplate
----------------------------------------
function func:Nameplate_Added(unit)
    if unit then
        local nameplate = C_NamePlate.GetNamePlateForUnit(unit, false);

        if nameplate then
            local unitFrame = nameplate.unitFrame;

            -- Adding nameplate to a list of currently available nameplates
            data.nameplates[unit] = nameplate;

            -- Parent
            unitFrame:SetScale(ReubinsNameplates_settings.NameplatesScale);

            -- Highlight (texture)
            unitFrame.highlight:Hide();
            unitFrame.highlight:SetParent(unitFrame);
            unitFrame.highlight:SetDrawLayer("background", 1);
            unitFrame.highlight:ClearAllPoints();
            if ReubinsNameplates_settings.Portrait then
                unitFrame.highlight:SetSize(256, 64);
                unitFrame.highlight:SetPoint("center", unitFrame.border, "center");
            else
                unitFrame.highlight:SetSize(256, 64);
                unitFrame.highlight:SetPoint("center", unitFrame.border, "center", 0, 0);
            end

            -- Border (texture)
            unitFrame.border:SetParent(unitFrame);
            if ReubinsNameplates_settings.Portrait then
                unitFrame.border:SetPoint("center", nameplate, "center", 0, -2);
            else
                unitFrame.border:SetPoint("center", nameplate, "center", -14, -6);
            end
            unitFrame.border:SetDrawLayer("border", 1);

            -- Portrait frame (frame)
            unitFrame.portrait:SetParent(unitFrame);

            -- Portrait (texture)
            unitFrame.portrait.texture:SetParent(unitFrame.portrait);
            unitFrame.portrait.texture:SetPoint("center", unitFrame.border, "center", -66, 0);
            unitFrame.portrait.texture:SetDrawLayer("background");

            -- Portrait border (texture)
            unitFrame.portrait.border:SetParent(unitFrame.portrait);
            unitFrame.portrait.border:SetPoint("right", unitFrame.border, "left", 79, 0);
            unitFrame.portrait.border:SetDrawLayer("border", 2);

            -- Classification (texture)
            unitFrame.classification:SetDrawLayer("artwork", 1);
            unitFrame.classification:ClearAllPoints();
            if ReubinsNameplates_settings.Portrait then
                unitFrame.classification:SetParent(unitFrame.portrait);
                unitFrame.classification:SetPoint("center", unitFrame.portrait.texture, "center", -6, -2);
                unitFrame.classification:SetSize(64, 64);
            else
                unitFrame.classification:SetParent(unitFrame);
                unitFrame.classification:SetPoint("right", unitFrame.border, "right", -35, 0);
                unitFrame.classification:SetSize(32, 32);
            end

            -- PVP flag (texture)
            unitFrame.pvp_flag:ClearAllPoints();
            unitFrame.pvp_flag:SetDrawLayer("artwork", 2);
            if ReubinsNameplates_settings.Portrait then
                unitFrame.pvp_flag:SetParent(unitFrame.portrait);
                unitFrame.pvp_flag:SetPoint("topLeft", unitFrame.portrait.texture, "topLeft", -16, 5);
                unitFrame.pvp_flag:SetScale(1);
            else
                unitFrame.pvp_flag:SetParent(unitFrame);
                unitFrame.pvp_flag:SetPoint("right", unitFrame.name, "left", 14, -8);
                unitFrame.pvp_flag:SetScale(0.7);
            end

            -- Name (fontstring)
            unitFrame.name:SetParent(unitFrame);
            unitFrame.name:ClearAllPoints();
            if unitFrame.threat.percentage:IsShown() and ReubinsNameplates_settings.ThreatPercentage then
                if ReubinsNameplates_settings.Portrait then
                    unitFrame.name:SetPoint("bottom", nameplate.unitFrame.healthbar, "top", -1, 18);
                else
                    unitFrame.name:SetPoint("bottom", nameplate.unitFrame.healthbar, "top", 8, 18);
                end
            else
                if ReubinsNameplates_settings.Portrait then
                    unitFrame.name:SetPoint("bottom", nameplate.unitFrame.healthbar, "top", -1, 12);
                else
                    unitFrame.name:SetPoint("bottom", nameplate.unitFrame.healthbar, "top", 8, 8);
                end
            end

            -- Level (fontstring)
            unitFrame.level:SetParent(unitFrame);
            unitFrame.level:SetPoint("center", unitFrame.border, "right", -58, 0);

            -- High level icon (texture)
            unitFrame.high_level_texture:SetParent(unitFrame);
            unitFrame.high_level_texture:SetPoint("center", unitFrame.level, "center");
            unitFrame.high_level_texture:SetDrawLayer("artwork", 2);

            -- Healthbar (frame)
            unitFrame.healthbar:SetParent(unitFrame);
            unitFrame.healthbar:SetPoint("center", unitFrame.border, "center", 4, 0);
            unitFrame.healthbar:SetFrameLevel(1);

            -- Healthbar highlight (texture)
            unitFrame.healthbar_highlight:SetParent(unitFrame.healthbar);
            unitFrame.healthbar_highlight:SetAllPoints();
            unitFrame.healthbar_highlight:SetDrawLayer("overlay");

            -- Healthbar spark (texture)
            unitFrame.healthbar_spark:SetParent(unitFrame);
            unitFrame.healthbar_spark:SetPoint("center", unitFrame.healthbar:GetStatusBarTexture(), "right");
            unitFrame.healthbar_spark:SetDrawLayer("artwork");

            -- Healthbar background (texture)
            unitFrame.healthbar_background:SetParent(unitFrame.healthbar);
            unitFrame.healthbar_background:SetAllPoints();
            unitFrame.healthbar_background:SetDrawLayer("background");

            -- Powerbar parent (frame)
            unitFrame.powerbar:SetParent(unitFrame);
            unitFrame.powerbar:SetFrameLevel(2);

            -- Powerbar border (texture)
            unitFrame.powerbar.border:SetDrawLayer("border", 2);
            unitFrame.powerbar.border:SetParent(unitFrame.powerbar);
            unitFrame.powerbar.border:SetPoint("top", unitFrame.border, "bottom", 6, 16);
            if ReubinsNameplates_settings.Portrait then
                unitFrame.powerbar.border:SetTexture("Interface\\addons\\ReubinsNameplates\\media\\nameplate\\borderPowerbarWide");
            else
                unitFrame.powerbar.border:SetTexture("Interface\\addons\\ReubinsNameplates\\media\\nameplate\\borderPowerbarCompact");
            end

            -- Powerbar (statusbar)
            unitFrame.powerbar.statusbar:SetParent(unitFrame.powerbar);
            unitFrame.powerbar.statusbar:SetFrameLevel(1);
            unitFrame.powerbar.statusbar:ClearAllPoints();
            if ReubinsNameplates_settings.Portrait then
                unitFrame.powerbar.statusbar:SetSize(92, 4);
            else
                unitFrame.powerbar.statusbar:SetSize(82, 4);
            end
            unitFrame.powerbar.statusbar:SetPoint("right", unitFrame.powerbar.border, "right", -18, 0);

            -- Powerbar spark (texture)
            unitFrame.powerbar.spark:SetParent(unitFrame.powerbar);
            unitFrame.powerbar.spark:SetPoint("center", unitFrame.powerbar.statusbar:GetStatusBarTexture(), "right");
            unitFrame.powerbar.spark:SetDrawLayer("artwork");

            -- Powerbar background (texture)
            unitFrame.powerbar.border_background:SetParent(unitFrame.powerbar.statusbar);
            unitFrame.powerbar.border_background:SetAllPoints();
            unitFrame.powerbar.border_background:SetDrawLayer("background");

            -- Health numerical (fontstring)
            unitFrame.health_center:SetParent(unitFrame);
            unitFrame.health_center:SetFont("Fonts\\FRIZQT__.TTF", ReubinsNameplates_settings.CenterHealthFontSize, "Outline");
            unitFrame.health_center:SetTextColor(
                ReubinsNameplates_settings.HealthFontColor.r,
                ReubinsNameplates_settings.HealthFontColor.g,
                ReubinsNameplates_settings.HealthFontColor.b,
                ReubinsNameplates_settings.HealthFontColor.a
            );
            unitFrame.health_center:ClearAllPoints();
            if ReubinsNameplates_settings.Portrait then
                unitFrame.health_center:SetPoint("center", unitFrame.healthbar, "center");
            else
                unitFrame.health_center:SetPoint("center", unitFrame.healthbar, "center", 8, 0);
            end

            -- Health percentage (fontstring)
            unitFrame.health_left:SetParent(unitFrame);
            unitFrame.health_left:SetPoint("left", unitFrame.healthbar, "left", 2, 0);
            unitFrame.health_left:SetTextColor(
                ReubinsNameplates_settings.HealthFontColor.r,
                ReubinsNameplates_settings.HealthFontColor.g,
                ReubinsNameplates_settings.HealthFontColor.b,
                ReubinsNameplates_settings.HealthFontColor.a
            );

            -- Threat icon parent (frame)
            unitFrame.threat.icon:SetParent(unitFrame);

            -- Threat icon (texture)
            unitFrame.threat.icon.texture:SetParent(unitFrame.threat.icon);
            unitFrame.threat.icon.texture:SetPoint("center", unitFrame.border, "right", -32, 0);
            unitFrame.threat.icon.texture:SetDrawLayer("artwork", 1);

            -- Threat percentage parent (frame)
            unitFrame.threat.percentage:SetParent(unitFrame);

            -- Threat border (texture)
            unitFrame.threat.percentage.border:SetParent(unitFrame.threat.percentage);
            unitFrame.threat.percentage.border:SetDrawLayer("border", 2);
            unitFrame.threat.percentage.border:ClearAllPoints();
            if ReubinsNameplates_settings.Portrait then
                unitFrame.threat.percentage.border:SetPoint("bottom", unitFrame.healthbar, "top", 0, -8);
            else
                unitFrame.threat.percentage.border:SetPoint("bottom", unitFrame.healthbar, "top", 8, -8);
            end

            -- Threat background (texture)
            unitFrame.threat.percentage.background:SetParent(unitFrame.threat.percentage);
            unitFrame.threat.percentage.background:SetPoint("center", unitFrame.threat.percentage.border, "center");
            unitFrame.threat.percentage.background:SetDrawLayer("background", 2);

            -- Threat percentage text (fontstring)
            unitFrame.threat.percentage.text:SetParent(unitFrame.threat.percentage);
            unitFrame.threat.percentage.text:SetPoint("center", unitFrame.threat.percentage.background, "center");

            -- Castbar frame
            unitFrame.castbar:SetParent(unitFrame);
            unitFrame.castbar:ClearAllPoints();
            if ReubinsNameplates_settings.Portrait then
                unitFrame.castbar:SetPoint("top", unitFrame.border, "bottom", 4, 21);
            else
                unitFrame.castbar:SetPoint("top", unitFrame.healthbar, "bottom", 8, 12);
            end

            -- Castbar border
            unitFrame.castbar.border:SetParent(unitFrame.castbar);
            unitFrame.castbar.border:SetAllPoints();
            unitFrame.castbar.border:SetDrawLayer("artwork", 2);

            -- Castbar icon mask
            unitFrame.castbar.mask:SetParent(unitFrame.castbar);
            unitFrame.castbar.mask:SetPoint("center", unitFrame.castbar.border, "center", -56, 0);

            -- Castbar icon
            unitFrame.castbar.icon:SetParent(unitFrame.castbar);
            unitFrame.castbar.icon:SetPoint("center", unitFrame.castbar.border, "center", -56, 0);

            -- Castbar name
            unitFrame.castbar.name:SetParent(unitFrame.castbar);
            unitFrame.castbar.name:SetPoint("left", unitFrame.castbar.statusbar, "left", 5, 0);

            -- Castbar countdown
            unitFrame.castbar.countdown:SetParent(unitFrame.castbar);
            unitFrame.castbar.countdown:SetPoint("right", unitFrame.castbar.statusbar, "right", -2, 0);

            -- Castbar status bar
            unitFrame.castbar.statusbar:SetParent(unitFrame.castbar);
            unitFrame.castbar.statusbar:SetPoint("center", unitFrame.castbar.border, "center", 9, 0);
            unitFrame.castbar.statusbar:SetFrameLevel(1);

            -- Castar spark
            unitFrame.castbar.spark:SetParent(unitFrame.castbar);
            unitFrame.castbar.spark:SetPoint("center", unitFrame.castbar.statusbar:GetStatusBarTexture(), "right");
            unitFrame.castbar.spark:SetDrawLayer("artwork", 3);

            -- Castbar background
            unitFrame.castbar.background:SetParent(unitFrame.castbar.statusbar);
            unitFrame.castbar.background:SetAllPoints();
            unitFrame.castbar.background:SetDrawLayer("background");

            unitFrame.portrait:SetShown(ReubinsNameplates_settings.Portrait);
            unitFrame.powerbar:SetShown(ReubinsNameplates_settings.Powerbar);
            unitFrame.castbar:Hide();

            -- Raid target parent
            unitFrame.raidTarget:SetParent(unitFrame);

            -- Raid target icon
            unitFrame.raidTarget.icon:SetParent(unitFrame.raidTarget);
            unitFrame.raidTarget.icon:SetDrawLayer("artwork", 2);
            unitFrame.raidTarget.icon:ClearAllPoints();
            if ReubinsNameplates_settings.Portrait then
                unitFrame.raidTarget.icon:SetPoint("right", unitFrame.portrait.texture, "left", -6, 0);
            else
                unitFrame.raidTarget.icon:SetPoint("right", unitFrame.healthbar, "left", -6, 0);
            end

            -- Raid target animation group
            unitFrame.raidTarget.animation = unitFrame.raidTarget:CreateAnimationGroup();

            -- Raid target animation alpha
            unitFrame.raidTarget.animation.alpha = unitFrame.raidTarget.animation:CreateAnimation("Alpha");
            unitFrame.raidTarget.animation.alpha:SetDuration(0.26);
            unitFrame.raidTarget.animation.alpha:SetFromAlpha(0);
            unitFrame.raidTarget.animation.alpha:SetToAlpha(1);

            -- Raid target animation scale
            unitFrame.raidTarget.animation.scale1 = unitFrame.raidTarget.animation:CreateAnimation("Scale");
            unitFrame.raidTarget.animation.scale1:SetDuration(0.13);
            if isClassic then
                unitFrame.raidTarget.animation.scale1:SetFromScale(0,0);
                unitFrame.raidTarget.animation.scale1:SetToScale(1.15, 1.15);
            else
                unitFrame.raidTarget.animation.scale1:SetScaleFrom(0,0);
                unitFrame.raidTarget.animation.scale1:SetScaleTo(1.15, 1.15);
            end
            unitFrame.raidTarget.animation.scale1:SetSmoothing("out")

            unitFrame.raidTarget.animation.scale2 = unitFrame.raidTarget.animation:CreateAnimation("Scale");
            unitFrame.raidTarget.animation.scale2:SetStartDelay(0.13);
            unitFrame.raidTarget.animation.scale2:SetDuration(0.13);
            if isClassic then
                unitFrame.raidTarget.animation.scale2:SetFromScale(1.15, 1.15);
                unitFrame.raidTarget.animation.scale2:SetToScale(1, 1);
            else
                unitFrame.raidTarget.animation.scale2:SetScaleFrom(1.15, 1.15);
                unitFrame.raidTarget.animation.scale2:SetScaleTo(1, 1);
            end
            unitFrame.raidTarget.animation.scale2:SetSmoothing("in")

            -- Adding nameplate
            nameplate.unitFrame.unit = unit;
            if not isClassic then
                nameplate.unitFrame.inVehicle = UnitInVehicle(unit);
            end
            nameplate.unitFrame:Show();

            -- Updating everything
            func:Update_Classification(unit);
            func:Update_Portrait(unit);
            func:Update_PVP_Flag(unit);
            func:Update_Name(unit);
            func:Update_Level(unit);
            func:Update_Health(unit);
            func:Update_healthbar(unit);
            func:Update_Powerbar(unit);
            func:Update_ThreatIcon(unit);
            func:Update_ThreatPercentage(unit);
            func:Update_Auras(unit);
            func:Selected(unitFrame);
            func:MouseoverCheck(unitFrame);
            func:Castbar_Start(event, unit);
            func:RaidTargetIndex();

            -----> Scripts <-----
            local timeElapsed1, timeElapsed2 = 0, 0;
            unitFrame:SetScript("OnUpdate", function(self, elapsed)

                -- Highlight
                timeElapsed1 = timeElapsed1 + elapsed;
                if timeElapsed1 > 0.15 then
                    timeElapsed1 = 0;
                    func:Highlight(unitFrame);
                end

                --[[ Threat icon
                timeElapsed2 = timeElapsed2 + elapsed;
                if timeElapsed2 > 1 then
                    timeElapsed2 = 0;
                    if unitFrame.threat.icon:IsShown() then
                        if unit then
                            func:Update_ThreatIcon(unit);
                        end
                    end
                end]]
            end);

            -- Hiding default nameplates
            nameplate.UnitFrame:SetScript("OnShow", function()
                nameplate.UnitFrame:Hide();
            end);

            -- Threat icon animation on show
            unitFrame.threat.icon:SetScript("OnShow", function()
                unitFrame.threat.animation:Play();
            end);

            -- Hiding castbar when animation finishes
            unitFrame.castbar.animation:SetScript("OnFinished", function()
                unitFrame.castbar:Hide();
            end);

            -- Raid target animation on show
            unitFrame.raidTarget:SetScript("OnShow", function()
                if unitFrame.raidTarget.animation:IsPlaying() then
                    unitFrame.raidTarget.animation:Restart();
                else
                    unitFrame.raidTarget.animation:Play();
                end
            end);
        end
    end
end

----------------------------------------
-- Removing nameplate
----------------------------------------
function func:Nameplate_Removed(unit)
    if unit then
        local nameplate = C_NamePlate.GetNamePlateForUnit(unit);

        if nameplate then
            local unitFrame = nameplate.unitFrame;

            -- Removing nameplate from a list of currently available nameplates
            data.nameplates[unit] = nil;

            func:MouseoverCheck(unitFrame);

            for i = 1, 40 do
                if unitFrame.auras[i] then
                    unitFrame.auras[i]:Hide();
                end
            end

            -- Removing nameplate
            unitFrame.unit = nil;
            unitFrame.inVehicle = nil;
            unitFrame:Hide();
        end
    end
end