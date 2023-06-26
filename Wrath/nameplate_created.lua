----------------------------------------
-- Core
----------------------------------------
local _, core = ...;
local func = core.func;
local data = core.data;

----------------------------------------
-- Creating nameplate
----------------------------------------
function func:Nameplate_Created(nameplate)
    if nameplate then
        local unitFrame = CreateFrame("frame", nil, nameplate);
        unitFrame:SetFrameStrata("low");
        nameplate.unitFrame = unitFrame;

        -- unitFrame animation show group
        unitFrame.animationShow = unitFrame:CreateAnimationGroup();

        -- unitFrame animation show alpha
        unitFrame.animationShow.alpha = unitFrame.animationShow:CreateAnimation("Alpha");
        unitFrame.animationShow.alpha:SetDuration(0.15);
        unitFrame.animationShow.alpha:SetFromAlpha(0);
        unitFrame.animationShow.alpha:SetToAlpha(1);

        -- Scripts: Playing animation
        unitFrame:SetScript("OnShow", function(self)
            unitFrame.animationShow:Play();
        end);

        -- Main strata
        unitFrame:SetFrameStrata("low");

        --------------------------------
        -- Highlights strata
        --------------------------------
        unitFrame.highlightsStrata = CreateFrame("frame", nil, unitFrame);
        unitFrame.highlightsStrata:SetFrameStrata("background");

        --------------------------------
        -- Healthbar
        --------------------------------

        -- Statusbar
        unitFrame.healthbar = CreateFrame("StatusBar", nil, unitFrame);
        unitFrame.healthbar:SetSize(112, 10);
        unitFrame.healthbar:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar");
        unitFrame.healthbar:SetFrameLevel(1);

        -- Border
        unitFrame.healthbar.border = unitFrame:CreateTexture();
        unitFrame.healthbar.border:SetTexture("Interface\\addons\\ClassicPlatesPlus\\media\\borders\\healthbar");
        unitFrame.healthbar.border:SetSize(128, 16);
        unitFrame.healthbar.border:SetDrawLayer("border", 1);

        -- Statusbar point
        unitFrame.healthbar:SetPoint("center", unitFrame.healthbar.border, "center");

        -- Heal prediction
        unitFrame.healthbar.healPrediction = unitFrame:CreateTexture(nil, "background");
        unitFrame.healthbar.healPrediction:SetPoint("left", unitFrame.healthbar:GetStatusBarTexture(), "right");
        unitFrame.healthbar.healPrediction:SetHeight(unitFrame.healthbar:GetHeight());
        unitFrame.healthbar.healPrediction:SetTexture("Interface\\TARGETINGFRAME\\UI-StatusBar");
        unitFrame.healthbar.healPrediction:SetVertexColor(0, 0.5, 0.0, 0.5);
        unitFrame.healthbar.healPrediction:SetBlendMode("add");
        unitFrame.healthbar.healPrediction:Hide();

        -- Heal prediction spark
        unitFrame.healthbar.healPredictionSpark = unitFrame:CreateTexture(nil, "background");
        unitFrame.healthbar.healPredictionSpark:SetPoint("center", unitFrame.healthbar.healPrediction, "right");
        unitFrame.healthbar.healPredictionSpark:SetSize(6, 12);
        unitFrame.healthbar.healPredictionSpark:SetTexture("Interface\\addons\\ClassicPlatesPlus\\media\\highlights\\spark");
        unitFrame.healthbar.healPredictionSpark:SetVertexColor(0, 1, 0, 0.33);
        unitFrame.healthbar.healPredictionSpark:SetBlendMode("add");
        unitFrame.healthbar.healPredictionSpark:SetDrawLayer("artwork");
        unitFrame.healthbar.healPredictionSpark:Hide();

        -- background
        unitFrame.healthbar.background = unitFrame.healthbar:CreateTexture();
        unitFrame.healthbar.background:SetAllPoints();
        unitFrame.healthbar.background:SetDrawLayer("background");

        -- Spark
        unitFrame.healthbar.spark = unitFrame:CreateTexture();
        unitFrame.healthbar.spark:SetPoint("center", unitFrame.healthbar:GetStatusBarTexture(), "right");
        unitFrame.healthbar.spark:SetSize(6, 12);
        unitFrame.healthbar.spark:SetTexture("Interface\\addons\\ClassicPlatesPlus\\media\\highlights\\spark");
        unitFrame.healthbar.spark:SetVertexColor(1, 0.82, 0, 0.7);
        unitFrame.healthbar.spark:SetBlendMode("add");
        unitFrame.healthbar.spark:SetDrawLayer("artwork");

        -- Highlight
        unitFrame.healthbar.highlight = unitFrame.highlightsStrata:CreateTexture();
        unitFrame.healthbar.highlight:SetPoint("center", unitFrame.healthbar.border, "center");
        unitFrame.healthbar.highlight:SetSize(128, 32);
        unitFrame.healthbar.highlight:SetDrawLayer("background", -1);

        --------------------------------
        -- Powerbar
        --------------------------------

        -- Parent
        unitFrame.powerbar = CreateFrame("Frame", nil, unitFrame);
        unitFrame.powerbar:SetFrameLevel(3);

        -- Statusbar
        unitFrame.powerbar.statusbar = CreateFrame("StatusBar", nil, unitFrame.powerbar);
        unitFrame.powerbar.statusbar:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar");
        unitFrame.powerbar.statusbar:SetSize(72, 5);
        unitFrame.powerbar.statusbar:SetFrameLevel(1);

        -- Border
        unitFrame.powerbar.border = unitFrame.powerbar:CreateTexture();
        unitFrame.powerbar.border:SetPoint("top", unitFrame.powerbar.statusbar, "top", 0, 5);
        unitFrame.powerbar.border:SetSize(128, 16);
        unitFrame.powerbar.border:SetTexture("Interface\\addons\\ClassicPlatesPlus\\media\\borders\\powerbar");
        unitFrame.powerbar.border:SetDrawLayer("border", 2);

        -- Background
        unitFrame.powerbar.background = unitFrame.powerbar.statusbar:CreateTexture();
        unitFrame.powerbar.background:SetAllPoints();
        unitFrame.powerbar.background:SetColorTexture(0.22, 0.22, 0.22, 0.85);
        unitFrame.powerbar.background:SetDrawLayer("background");

        -- Spark
        unitFrame.powerbar.spark = unitFrame.powerbar:CreateTexture();
        unitFrame.powerbar.spark:SetPoint("center", unitFrame.powerbar.statusbar:GetStatusBarTexture(), "right");
        unitFrame.powerbar.spark:SetSize(8, 6);
        unitFrame.powerbar.spark:SetTexture("Interface\\addons\\ClassicPlatesPlus\\media\\highlights\\spark");
        unitFrame.powerbar.spark:SetVertexColor(1, 0.82, 0, 0.7);
        unitFrame.powerbar.spark:SetBlendMode("add");
        unitFrame.powerbar.spark:SetDrawLayer("background");

        -- Highlight
        unitFrame.powerbar.highlight = unitFrame.highlightsStrata:CreateTexture();
        unitFrame.powerbar.highlight:SetPoint("center", unitFrame.powerbar.border, "center");
        unitFrame.powerbar.highlight:SetSize(128, 16);
        unitFrame.powerbar.highlight:SetTexture("Interface\\addons\\ClassicPlatesPlus\\media\\highlights\\powerbar");
        unitFrame.powerbar.highlight:SetDrawLayer("background", -8);

        --------------------------------
        -- Combo points
        --------------------------------
        unitFrame.comboPoints = CreateFrame("frame", nil, unitFrame);

        --------------------------------
        -- Portrait
        --------------------------------

        -- Parent
        unitFrame.portrait = CreateFrame("Frame", nil, unitFrame);

        -- Portrait
        unitFrame.portrait.texture = unitFrame.portrait:CreateTexture();
        unitFrame.portrait.texture:SetPoint("right", unitFrame.healthbar, "left");
        unitFrame.portrait.texture:SetSize(18, 18);
        unitFrame.portrait.texture:SetDrawLayer("background");

        -- Border
        unitFrame.portrait.border = unitFrame.portrait:CreateTexture();
        unitFrame.portrait.border:SetPoint("center", unitFrame.portrait.texture, "center");
        unitFrame.portrait.border:SetTexture("Interface\\addons\\ClassicPlatesPlus\\media\\borders\\portrait");
        unitFrame.portrait.border:SetSize(32, 32);
        unitFrame.portrait.border:SetDrawLayer("border", 2);

        -- Highlight
        unitFrame.portrait.highlight = unitFrame.highlightsStrata:CreateTexture();
        unitFrame.portrait.highlight:SetPoint("center", unitFrame.portrait.border, "center");
        unitFrame.portrait.highlight:SetSize(32, 32);
        unitFrame.portrait.highlight:SetTexture("Interface\\addons\\ClassicPlatesPlus\\media\\highlights\\portrait");
        unitFrame.portrait.highlight:SetDrawLayer("background", -8);

        --------------------------------
        -- Level
        --------------------------------

        -- Value
        unitFrame.level = unitFrame:CreateFontString(nil, nil, "GameFontNormalSmall");
        unitFrame.level:SetScale(0.9);

        -- Border
        unitFrame.level.border = unitFrame:CreateTexture();
        unitFrame.level.border:SetPoint("left", unitFrame.healthbar, "right", -6, 0);
        unitFrame.level.border:SetSize(32, 32);
        unitFrame.level.border:SetTexture("Interface\\addons\\ClassicPlatesPlus\\media\\borders\\level");

        -- level point
        unitFrame.level:SetPoint("center", unitFrame.level.border, "center");

        -- High level skull icon
        unitFrame.level.highLevel = unitFrame:CreateTexture();
        unitFrame.level.highLevel:SetPoint("center", unitFrame.level, "center");
        unitFrame.level.highLevel:SetTexture("Interface\\addons\\ClassicPlatesPlus\\media\\icons\\skull");
        unitFrame.level.highLevel:SetSize(18, 18);
        unitFrame.level.highLevel:SetDrawLayer("artwork", 2);

        -- Background
        unitFrame.level.background = unitFrame:CreateTexture();
        unitFrame.level.background:SetPoint("center", unitFrame.level.border, "center");
        unitFrame.level.background:SetSize(18, 10);
        unitFrame.level.background:SetDrawLayer("background", 0);

        -- Highlight
        unitFrame.level.highlight = unitFrame.highlightsStrata:CreateTexture();
        unitFrame.level.highlight:SetPoint("center", unitFrame.level.border, "center");
        unitFrame.level.highlight:SetSize(32, 32);
        unitFrame.level.highlight:SetTexture("Interface\\addons\\ClassicPlatesPlus\\media\\highlights\\level");
        unitFrame.level.highlight:SetDrawLayer("background", -1);

        --------------------------------
        -- Threat percentage
        --------------------------------

        -- Parent
        unitFrame.threatPercentage = CreateFrame("Frame", nil, unitFrame);
        unitFrame.threatPercentage:SetSize(64,16);
        unitFrame.threatPercentage:SetFrameLevel(2);

        -- Value
        unitFrame.threatPercentage.value = unitFrame.threatPercentage:CreateFontString(nil, nil, "GameFontNormalOutline");
        unitFrame.threatPercentage.value:SetScale(0.7);

        -- Border
        unitFrame.threatPercentage.border = unitFrame.threatPercentage:CreateTexture();
        unitFrame.threatPercentage.border:SetTexture("Interface\\addons\\ClassicPlatesPlus\\media\\borders\\threat_new");
        unitFrame.threatPercentage.border:SetSize(64, 16);
        unitFrame.threatPercentage.border:SetVertexColor(data.colors.border.r, data.colors.border.g, data.colors.border.b);
        unitFrame.threatPercentage.border:SetDrawLayer("border", 2);

        -- Background
        unitFrame.threatPercentage.background = unitFrame.threatPercentage:CreateTexture();
        unitFrame.threatPercentage.background:SetPoint("center", unitFrame.threatPercentage.border, "center");
        unitFrame.threatPercentage.background:SetTexture("Interface\\addons\\ClassicPlatesPlus\\media\\borders\\threatBG_new");
        unitFrame.threatPercentage.background:SetSize(64, 16);
        unitFrame.threatPercentage.background:SetDrawLayer("background", 1);

        -- Value point
        unitFrame.threatPercentage.value:SetPoint("center", unitFrame.threatPercentage.background, "center", 0, -0.5);

        -- Highlight
        unitFrame.threatPercentage.highlight = unitFrame.highlightsStrata:CreateTexture();
        unitFrame.threatPercentage.highlight:SetPoint("center", unitFrame.threatPercentage.border, "center");
        unitFrame.threatPercentage.highlight:SetSize(64, 32);
        unitFrame.threatPercentage.highlight:SetTexture("Interface\\addons\\ClassicPlatesPlus\\media\\highlights\\threat_new");
        unitFrame.threatPercentage.highlight:SetDrawLayer("background", -1);

        --------------------------------
        -- Classification
        --------------------------------
        unitFrame.classification = unitFrame:CreateTexture();
        unitFrame.classification:SetDrawLayer("artwork", 1);

        --------------------------------
        -- Name & Guild
        --------------------------------
        unitFrame.name = unitFrame:CreateFontString(nil, nil, "GameFontNormalSmall");
        unitFrame.name:SetIgnoreParentScale(true);
        unitFrame.guild = unitFrame:CreateFontString(nil, nil, "GameFontNormalSmall");
        unitFrame.guild:SetIgnoreParentScale(true);

        --------------------------------
        -- Faction
        --------------------------------
        unitFrame.pvp_flag = unitFrame:CreateTexture();
        unitFrame.pvp_flag:SetIgnoreParentScale(not Config.Portrait);
        unitFrame.pvp_flag:SetDrawLayer("artwork", 2);

        --------------------------------
        -- Health values
        --------------------------------

        -- Main
        unitFrame.healthMain = unitFrame:CreateFontString(nil, "overlay");

        -- Left side
        unitFrame.healthLeftSide = unitFrame:CreateFontString(nil, "overlay", "GameFontNormalOutline");
        unitFrame.healthLeftSide:SetPoint("left", unitFrame.healthbar, "left", 4, 0);
        unitFrame.healthLeftSide:SetScale(0.8);

        --------------------------------
        -- Auras counter
        --------------------------------
        unitFrame.buffsCounter = unitFrame:CreateFontString(nil, nil, "GameFontNormalOutline")
        unitFrame.buffsCounter:SetTextColor(0,1,0);
        unitFrame.debuffsCounter = unitFrame:CreateFontString(nil, nil, "GameFontNormalOutline")
        unitFrame.debuffsCounter:SetTextColor(1, 0.2, 0);

        --------------------------------
        -- Auras
        --------------------------------
        unitFrame.buffs = {};
        unitFrame.debuffs = {};

        --------------------------------
        -- Castbar
        --------------------------------

        -- Parent
        unitFrame.castbar = CreateFrame("frame", nil, unitFrame);
        unitFrame.castbar:SetSize(256, 64);

        -- Border
        unitFrame.castbar.border = unitFrame.castbar:CreateTexture();
        unitFrame.castbar.border:SetAllPoints();
        unitFrame.castbar.border:SetTexture("Interface\\addons\\ClassicPlatesPlus\\media\\castbar\\castbarUI");
        unitFrame.castbar.border:SetVertexColor(0.75, 0.75, 0.75);
        unitFrame.castbar.border:SetDrawLayer("artwork", 2);

        -- Icon mask
        unitFrame.castbar.mask = unitFrame.castbar:CreateMaskTexture();
        unitFrame.castbar.mask:SetPoint("center", unitFrame.castbar.border, "center", -56, 0);
        unitFrame.castbar.mask:SetSize(32, 32);
        unitFrame.castbar.mask:SetTexture("Interface\\addons\\ClassicPlatesPlus\\media\\castbar\\castbarMask");

        -- Icon
        unitFrame.castbar.icon = unitFrame.castbar:CreateTexture();
        unitFrame.castbar.icon:SetPoint("center", unitFrame.castbar.border, "center", -56, 0);
        unitFrame.castbar.icon:SetSize(18, 18);
        unitFrame.castbar.icon:AddMaskTexture(unitFrame.castbar.mask);
        unitFrame.castbar.icon:SetDrawLayer("artwork", 1);

        -- Status bar
        unitFrame.castbar.statusbar = CreateFrame("StatusBar", nil, unitFrame.castbar);
        unitFrame.castbar.statusbar:SetPoint("center", unitFrame.castbar.border, "center", 9, 0);
        unitFrame.castbar.statusbar:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar");
        unitFrame.castbar.statusbar:SetSize(112, 10);
        unitFrame.castbar.statusbar:SetStatusBarColor(data.colors.orange.r, data.colors.orange.g, data.colors.orange.b);
        unitFrame.castbar.statusbar:SetFrameLevel(1);

        -- Countdown
        unitFrame.castbar.countdown = unitFrame.castbar:CreateFontString(nil, nil, "GameFontNormalSmall");
        unitFrame.castbar.countdown:SetPoint("right", unitFrame.castbar.statusbar, "right", -2, 0);
        unitFrame.castbar.countdown:SetTextColor(1,1,1);
        unitFrame.castbar.countdown:SetScale(0.8);

        -- Name
        unitFrame.castbar.name = unitFrame.castbar:CreateFontString(nil, nil, "GameFontNormalSmall");
        unitFrame.castbar.name:SetPoint("left", unitFrame.castbar.statusbar, "left", 5, 0);
        unitFrame.castbar.name:SetScale(0.8);

        -- Spark
        unitFrame.castbar.spark = unitFrame.castbar:CreateTexture();
        unitFrame.castbar.spark:SetPoint("center", unitFrame.castbar.statusbar:GetStatusBarTexture(), "right");
        unitFrame.castbar.spark:SetTexture("Interface\\CastingBar\\UI-CastingBar-Spark");
        unitFrame.castbar.spark:SetBlendMode("ADD");
        unitFrame.castbar.spark:SetSize(32, 32);
        unitFrame.castbar.spark:SetDrawLayer("artwork", 3);

        -- Background
        unitFrame.castbar.background = unitFrame.castbar.statusbar:CreateTexture();
        unitFrame.castbar.background:SetAllPoints();
        unitFrame.castbar.background:SetColorTexture(0.18, 0.18, 0.18, 0.85);
        unitFrame.castbar.background:SetDrawLayer("background");

        -- Animation group
        unitFrame.castbar.animation = unitFrame.castbar:CreateAnimationGroup();

        -- Animation alpha
        local castbar_animation_alpha = unitFrame.castbar.animation:CreateAnimation("Alpha");
        castbar_animation_alpha:SetStartDelay(0.36);
        castbar_animation_alpha:SetDuration(0.36);
        castbar_animation_alpha:SetFromAlpha(1);
        castbar_animation_alpha:SetToAlpha(0);

        -- Scripts: Hiding castbar after its animation finishes
        unitFrame.castbar.animation:SetScript("OnFinished", function()
            unitFrame.castbar:Hide();
        end);

        --------------------------------
        -- Raid target
        --------------------------------

        -- Parent
        unitFrame.raidTarget = CreateFrame("frame", nil, unitFrame);

        -- Icon
        unitFrame.raidTarget.icon = unitFrame.raidTarget:CreateTexture();
        unitFrame.raidTarget.icon:SetSize(20, 20);
        unitFrame.raidTarget.icon:SetDrawLayer("artwork", 2);

        -- Animation group
        unitFrame.raidTarget.animation = unitFrame.raidTarget:CreateAnimationGroup();

        -- Animation alpha
        unitFrame.raidTarget.animation.alpha = unitFrame.raidTarget.animation:CreateAnimation("Alpha");
        unitFrame.raidTarget.animation.alpha:SetDuration(0.26);
        unitFrame.raidTarget.animation.alpha:SetFromAlpha(0);
        unitFrame.raidTarget.animation.alpha:SetToAlpha(1);

        -- Animation scale
        unitFrame.raidTarget.animation.scale1 = unitFrame.raidTarget.animation:CreateAnimation("Scale");
        unitFrame.raidTarget.animation.scale1:SetDuration(0.13);
        unitFrame.raidTarget.animation.scale1:SetScaleFrom(0,0);
        unitFrame.raidTarget.animation.scale1:SetScaleTo(1.15, 1.15);
        unitFrame.raidTarget.animation.scale1:SetSmoothing("out")

        unitFrame.raidTarget.animation.scale2 = unitFrame.raidTarget.animation:CreateAnimation("Scale");
        unitFrame.raidTarget.animation.scale2:SetStartDelay(0.13);
        unitFrame.raidTarget.animation.scale2:SetDuration(0.13);
        unitFrame.raidTarget.animation.scale2:SetScaleFrom(1.15, 1.15);
        unitFrame.raidTarget.animation.scale2:SetScaleTo(1, 1);
        unitFrame.raidTarget.animation.scale2:SetSmoothing("in")

        -- Scrits: Animating raid target icon on show
        unitFrame.raidTarget:SetScript("OnShow", function()
            if unitFrame.raidTarget.animation:IsPlaying() then
                unitFrame.raidTarget.animation:Restart();
            else
                unitFrame.raidTarget.animation:Play();
            end
        end);
        --------------------------------
        -- Hiding what has to be hidden
        --------------------------------
        unitFrame.threatPercentage:Hide();
        unitFrame.raidTarget:Hide();
        unitFrame.castbar:Hide();
        unitFrame:Hide();
    end
end