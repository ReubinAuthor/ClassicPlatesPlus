----------------------------------------
-- CORE
----------------------------------------
local myAddon, core = ...;
local func = core.func;
local data = core.data;

-- Default settings
local default = {
    -- Personal nameplate
    PersonalNameplate = true,
    PersonalNameplateTotalHealth = true,
    PersonalNameplateTotalPower = true,
    PersonalNameplatePointY = 400,
    PersonalNameplatesScale = 1,

    -- General
    Powerbar = true,
    Portrait = true,
    ShowGuildName = true,
    Classification = true,
    ClassIconsEnemy = true,
    ClassIconsFriendly = false,
    HealthBarClassColorsEnemy = true,
    HealthBarClassColorsFriendly = true,
    NumericValue = true,
    Percentage = true,
    PercentageAsMainValue = false,
    LargeMainValue = true,
    HealthFontColor = { r = 1, g = 0.82, b = 0, a = 1 },
    HealthCenterFontScale = 1,
    NameplatesScale = 1,

    -- Threat
    ThreatPercentage = true,
    ThreatWarningThreshold = 75,

    -- Auras
    AurasShow = 1,
    BuffsFriendly = true,
    DebuffsFriendly = true,
    BuffsEnemy = true,
    DebuffsEnemy = true,
    AurasMaxBuffsFriendly = 4,
    AurasMaxDebuffsFriendly = 2,
    AurasMaxBuffsEnemy = 2,
    AurasMaxDebuffsEnemy = 4,
    AurasCountdown = true,
    AurasReverseAnimation = true,
    AurasScale = 1,
    AurasImportantList = {},
    AurasBlacklist = {}
};

local backdropInfo = {
    bgFile = "Interface\\Buttons\\WHITE8x8",
    edgeFile = "Interface\\Buttons\\WHITE8x8",
    tile = true,
    tileEdge = true,
    tileSize =1,
    edgeSize = 1,
    insets = { left = 1, right = 1, top = 1, bottom = 1 }
}

local backdropGeneral = {
    bgFile = "Interface\\Buttons\\WHITE8x8",
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    tile = true,
    tileEdge = true,
    tileSize = 16,
    edgeSize = 16,
    insets = { left = 4, right = 4, top = 4, bottom = 4 },
}

local function updateNameplateScale()
    local function work()
        local nameplates = C_NamePlate.GetNamePlates();

        SetCVar("nameplateGlobalScale", Config.NameplatesScale);
        for k,v in pairs(nameplates) do
            if k then
                v.unitFrame.name:SetIgnoreParentScale(false);
                v.unitFrame.guild:SetIgnoreParentScale(false);

                v.unitFrame.name:SetScale(Config.NameplatesScale - func:GetPercent(Config.NameplatesScale, 10));
                v.unitFrame.guild:SetScale(Config.NameplatesScale - func:GetPercent(Config.NameplatesScale, 20));

                v.unitFrame.name:SetIgnoreParentScale(true);
                v.unitFrame.guild:SetIgnoreParentScale(true);
            end
        end
    end

    if not InCombatLockdown() then
        work();
    else
        if not data.tickers.nameplatesUpdate then
            data.tickers.nameplatesUpdate = C_Timer.NewTicker(1, function()
                if not InCombatLockdown() then
                    work();

                    data.tickers.nameplatesUpdate:Cancel();
                    data.tickers.nameplatesUpdate = nil;
                end
            end)
        end
    end
end

----------------------------------------
-- Loading settings
----------------------------------------
function func:Load_Settings()
    -- First launch settings
    Config = Config or {};
    for k,v in pairs(default) do
        if Config[k] == nil then
            Config[k] = v;
        end
    end

    ----------------------------------------
    -- MAIN PANEL
    ----------------------------------------

    -- Create a frame to use as the panel
    local panel_main = CreateFrame("frame");
    panel_main.name = myAddon;

    -- Add-on Icon
    local general_icon = panel_main:CreateTexture();
    general_icon:SetPoint("topLeft", 16, -16);
    general_icon:SetTexture("Interface\\addons\\ClassicPlatesPlus\\media\\icons\\ClassicPlatesPlus_icon");
    general_icon:SetSize(20, 20);

    -- Add-on Title
    local general_title = panel_main:CreateFontString(nil, "overlay", "GameFontNormalLarge");
    general_title:SetPoint("left", general_icon, "right", 6, 0);
    general_title:SetText("ClassicPlates Plus");

    -- Button: Reset all settings
    local general_button_resetSettings = CreateFrame("Button", nil, panel_main, "GameMenuButtonTemplate");
    general_button_resetSettings:SetPoint("BottomLeft", 16, 24);
    general_button_resetSettings:SetSize(120, 22);
    general_button_resetSettings:SetText("Reset all settings");
    general_button_resetSettings:SetNormalFontObject("GameFontNormal");
    general_button_resetSettings:SetHighlightFontObject("GameFontHighlight");

    -- SubTitle: General
    local general_SubTitle = panel_main:CreateFontString(myAddon .. "SubTitle_General", "overlay", "GameFontNormal");
    general_SubTitle:SetPoint("topLeft", general_icon, "bottomLeft", 0, -16);
    general_SubTitle:SetText("General");

    -- CheckButton: Personal nameplate
    local general_CheckButton_PersonalNameplate = CreateFrame("CheckButton", nil, panel_main, "InterfaceOptionsCheckButtonTemplate");
    general_CheckButton_PersonalNameplate:SetPoint("topLeft", general_SubTitle, "bottomLeft", 0, -8);
    general_CheckButton_PersonalNameplate.Text:SetText("Personal nameplate");
    general_CheckButton_PersonalNameplate:SetChecked(Config.PersonalNameplate);
    general_CheckButton_PersonalNameplate:SetScript("OnClick", function(self)
        Config.PersonalNameplate = self:GetChecked();
        func:ToggleNameplatePersonal();
    end);

    -- CheckButton: Powerbar
    local general_CheckButton_Powerbar = CreateFrame("CheckButton", nil, panel_main, "InterfaceOptionsCheckButtonTemplate");
    general_CheckButton_Powerbar:SetPoint("topLeft", general_CheckButton_PersonalNameplate, "bottomLeft", 0, -8);
    general_CheckButton_Powerbar.Text:SetText("Power bar");
    general_CheckButton_Powerbar:SetChecked(Config.Powerbar);
    general_CheckButton_Powerbar:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "anchor_topLeft", 135);
        GameTooltip:SetText("Displays power resource\n(mana, rage, energy, etc...)");
    end)
    general_CheckButton_Powerbar:SetScript("OnClick", function(self)
        Config.Powerbar = self:GetChecked();
        func:Update();
    end);

    -- CheckButton: Portrait
    local general_CheckButton_Portrait = CreateFrame("CheckButton", nil, panel_main, "InterfaceOptionsCheckButtonTemplate");
    general_CheckButton_Portrait:SetPoint("topLeft", general_CheckButton_Powerbar, "bottomLeft", 0, -8);
    general_CheckButton_Portrait.Text:SetText("Portrait");
    general_CheckButton_Portrait:SetChecked(Config.Portrait);

    -- CheckButton: Enemy players' class icon
    local general_CheckButton_ClassIconsEnemy = CreateFrame("CheckButton", nil, panel_main, "InterfaceOptionsCheckButtonTemplate");
    general_CheckButton_ClassIconsEnemy:SetPoint("topLeft", general_CheckButton_Portrait, "bottomLeft", 18, 0);
    general_CheckButton_ClassIconsEnemy.Text:SetText("Enemy class icons");
    general_CheckButton_ClassIconsEnemy:SetChecked(Config.ClassIconsEnemy);
    general_CheckButton_ClassIconsEnemy:SetEnabled(Config.Portrait);
    if general_CheckButton_ClassIconsEnemy:IsEnabled() then
        general_CheckButton_ClassIconsEnemy.Text:SetFontObject("GameFontHighlight");
    else
        general_CheckButton_ClassIconsEnemy.Text:SetFontObject("GameFontDisable");
    end
    general_CheckButton_ClassIconsEnemy:SetScript("OnClick", function(self)
        Config.ClassIconsEnemy = self:GetChecked();
        func:Update();
    end);

    -- CheckButton: Friendly players' class icon
    local general_CheckButton_ClassIconsFriendly = CreateFrame("CheckButton", nil, panel_main, "InterfaceOptionsCheckButtonTemplate");
    general_CheckButton_ClassIconsFriendly:SetPoint("topLeft", general_CheckButton_ClassIconsEnemy, "bottomLeft");
    general_CheckButton_ClassIconsFriendly.Text:SetText("Friendly class icons");
    general_CheckButton_ClassIconsFriendly:SetChecked(Config.ClassIconsFriendly);
    general_CheckButton_ClassIconsFriendly:SetEnabled(Config.Portrait);
    if general_CheckButton_ClassIconsFriendly:IsEnabled() then
        general_CheckButton_ClassIconsFriendly.Text:SetFontObject("GameFontHighlight");
    else
        general_CheckButton_ClassIconsFriendly.Text:SetFontObject("GameFontDisable");
    end
    general_CheckButton_ClassIconsFriendly:SetScript("OnClick", function(self)
        Config.ClassIconsFriendly = self:GetChecked();
        func:Update();
    end);

    -- Portraits check button OnClick script
    general_CheckButton_Portrait:SetScript("OnClick", function(self)
        Config.Portrait = self:GetChecked();

        if self:GetChecked() then
            general_CheckButton_ClassIconsEnemy.Text:SetFontObject("GameFontHighlight");
            general_CheckButton_ClassIconsFriendly.Text:SetFontObject("GameFontHighlight");
        else
            general_CheckButton_ClassIconsEnemy.Text:SetFontObject("GameFontDisable");
            general_CheckButton_ClassIconsFriendly.Text:SetFontObject("GameFontDisable");
        end
        general_CheckButton_ClassIconsEnemy:SetEnabled(general_CheckButton_Portrait:GetChecked());
        general_CheckButton_ClassIconsFriendly:SetEnabled(general_CheckButton_Portrait:GetChecked());

        func:Update();
    end);

    general_CheckButton_Portrait:SetScript("OnShow", function(self)
        if self:GetChecked() then
            general_CheckButton_ClassIconsEnemy.Text:SetFontObject("GameFontHighlight");
            general_CheckButton_ClassIconsFriendly.Text:SetFontObject("GameFontHighlight");
        else
            general_CheckButton_ClassIconsEnemy.Text:SetFontObject("GameFontDisable");
            general_CheckButton_ClassIconsFriendly.Text:SetFontObject("GameFontDisable");
        end
        general_CheckButton_ClassIconsEnemy:SetEnabled(general_CheckButton_Portrait:GetChecked());
        general_CheckButton_ClassIconsFriendly:SetEnabled(general_CheckButton_Portrait:GetChecked());
    end);

    -- CheckButton: Show guild name
    local general_CheckButton_GuildName = CreateFrame("CheckButton", nil, panel_main, "InterfaceOptionsCheckButtonTemplate");
    general_CheckButton_GuildName:SetPoint("topLeft", general_CheckButton_ClassIconsFriendly, "bottomLeft", -18, -8);
    general_CheckButton_GuildName.Text:SetText("Guild name");
    general_CheckButton_GuildName:SetChecked(Config.ShowGuildName);
    general_CheckButton_GuildName:SetScript("OnClick", function(self)
        Config.ShowGuildName = self:GetChecked();
        func:Update();
    end);

    -- CheckButton: Classification
    local general_CheckButton_Classification = CreateFrame("CheckButton", nil, panel_main, "InterfaceOptionsCheckButtonTemplate");
    general_CheckButton_Classification:SetPoint("topLeft", general_CheckButton_GuildName, "bottomLeft", 0, -8);
    general_CheckButton_Classification.Text:SetText("NPC Classification");
    general_CheckButton_Classification:SetChecked(Config.Classification);
    general_CheckButton_Classification:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "anchor_topLeft", 135);
        GameTooltip:SetText("Displays NPC type (Rare, Elite, Rare Elite, World boss)");
    end);
    general_CheckButton_Classification:SetScript("OnClick", function(self)
        Config.Classification = self:GetChecked();
        func:Update();
    end);

    -- CheckButton: Enemy players' healthbar class color
    local general_CheckButton_HealthBarClassColorsEnemy = CreateFrame("CheckButton", nil, panel_main, "InterfaceOptionsCheckButtonTemplate");
    general_CheckButton_HealthBarClassColorsEnemy:SetPoint("topLeft", general_CheckButton_Classification, "bottomLeft", 0, -8);
    general_CheckButton_HealthBarClassColorsEnemy.Text:SetText("Class colors for enemies");
    general_CheckButton_HealthBarClassColorsEnemy:SetChecked(Config.HealthBarClassColorsEnemy);
    general_CheckButton_HealthBarClassColorsEnemy:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "anchor_topLeft", 135);
        GameTooltip:SetText("Colors health bar with class colors");
    end);
    general_CheckButton_HealthBarClassColorsEnemy:SetScript("OnClick", function(self)
        Config.HealthBarClassColorsEnemy = self:GetChecked();
        func:Update();
    end);

    -- CheckButton: Friendly players' healthbar class color
    local general_CheckButton_HealthBarClassColorsFriendly = CreateFrame("CheckButton", nil, panel_main, "InterfaceOptionsCheckButtonTemplate");
    general_CheckButton_HealthBarClassColorsFriendly:SetPoint("topLeft", general_CheckButton_HealthBarClassColorsEnemy, "bottomLeft", 0, -8);
    general_CheckButton_HealthBarClassColorsFriendly.Text:SetText("Class colors for friendlies");
    general_CheckButton_HealthBarClassColorsFriendly:SetChecked(Config.HealthBarClassColorsFriendly);
    general_CheckButton_HealthBarClassColorsFriendly:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "anchor_topLeft", 135);
        GameTooltip:SetText("Colors health bar with class colors");
    end);
    general_CheckButton_HealthBarClassColorsFriendly:SetScript("OnClick", function(self)
        Config.HealthBarClassColorsFriendly = self:GetChecked();
        func:Update();
    end);

    -- Slider: Nameplate scale
    local general_Slider_NameplatesScale = CreateFrame("Slider", myAddon .. "Slider_NameplatesScale", panel_main, "OptionsSliderTemplate");
    general_Slider_NameplatesScale:SetPoint("topLeft", general_CheckButton_HealthBarClassColorsFriendly, "bottomLeft", 0, -32);
    general_Slider_NameplatesScale:SetOrientation("horizontal");
    general_Slider_NameplatesScale:SetWidth(180);
    general_Slider_NameplatesScale:SetHeight(18);
    general_Slider_NameplatesScale:SetMinMaxValues(0.75, 1.25);
    general_Slider_NameplatesScale:SetValueStep(0.01);
    general_Slider_NameplatesScale:SetObeyStepOnDrag(true);
    general_Slider_NameplatesScale:SetValue(Config.NameplatesScale);
    _G[general_Slider_NameplatesScale:GetName() .. "Low"]:SetText("");
    _G[general_Slider_NameplatesScale:GetName() .. "High"]:SetText("");
    general_Slider_NameplatesScale.Text:SetFontObject("GameFontNormal");
    general_Slider_NameplatesScale.Text:SetText("Nameplate scale");
    general_Slider_NameplatesScale.TextValue = panel_main:CreateFontString(nil, "overlay", "GameFontHighlightSmall");
    general_Slider_NameplatesScale.TextValue:SetPoint("top", general_Slider_NameplatesScale, "bottom");
    general_Slider_NameplatesScale.TextValue:SetText(string.format("%.2f", general_Slider_NameplatesScale:GetValue()));
    general_Slider_NameplatesScale:SetScript("OnValueChanged", function(self)
        self.TextValue:SetText(string.format("%.2f", self:GetValue()));
        Config.NameplatesScale = self:GetValue();

        updateNameplateScale();
    end);
    general_Slider_NameplatesScale:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "anchor_topLeft", 135, 16);
        GameTooltip:SetText("You must be out of combat for the change to take place");
    end)

    -- Slider: Personal nameplate scale
    local general_Slider_PersonalNameplatesScale = CreateFrame("Slider", myAddon .. "Slider_PersonalNameplatesScale", panel_main, "OptionsSliderTemplate");
    general_Slider_PersonalNameplatesScale:SetPoint("topLeft", general_Slider_NameplatesScale, "bottomLeft", 0, -36);
    general_Slider_PersonalNameplatesScale:SetOrientation("horizontal");
    general_Slider_PersonalNameplatesScale:SetWidth(180);
    general_Slider_PersonalNameplatesScale:SetHeight(18);
    general_Slider_PersonalNameplatesScale:SetMinMaxValues(0.75, 1.25);
    general_Slider_PersonalNameplatesScale:SetValueStep(0.01);
    general_Slider_PersonalNameplatesScale:SetObeyStepOnDrag(true);
    general_Slider_PersonalNameplatesScale:SetValue(Config.PersonalNameplatesScale);
    _G[general_Slider_PersonalNameplatesScale:GetName() .. "Low"]:SetText("");
    _G[general_Slider_PersonalNameplatesScale:GetName() .. "High"]:SetText("");
    general_Slider_PersonalNameplatesScale.Text:SetFontObject("GameFontNormal");
    general_Slider_PersonalNameplatesScale.Text:SetText("Personal nameplate scale");
    general_Slider_PersonalNameplatesScale.TextValue = panel_main:CreateFontString(nil, "overlay", "GameFontHighlightSmall");
    general_Slider_PersonalNameplatesScale.TextValue:SetPoint("top", general_Slider_PersonalNameplatesScale, "bottom");
    general_Slider_PersonalNameplatesScale.TextValue:SetText(string.format("%.2f", general_Slider_PersonalNameplatesScale:GetValue()));
    general_Slider_PersonalNameplatesScale:SetScript("OnValueChanged", function(self)
        self.TextValue:SetText(string.format("%.2f", self:GetValue()));
        Config.PersonalNameplatesScale = self:GetValue();
        func:PersonalNameplate();
    end);

    -- SubTitle: Health & Power Values
    local HealthPower_SubTitle = panel_main:CreateFontString(nil, "overlay", "GameFontNormal");
    HealthPower_SubTitle:SetPoint("left", general_SubTitle, "left", 310, 0);
    HealthPower_SubTitle:SetText("Health & Power Values");

    -- CheckButton: Numeric value
    local HealthPower_CheckButton_NumericValue = CreateFrame("CheckButton", nil, panel_main, "InterfaceOptionsCheckButtonTemplate");
    HealthPower_CheckButton_NumericValue:SetPoint("topLeft", HealthPower_SubTitle, "bottomLeft", 0, -8);
    HealthPower_CheckButton_NumericValue.Text:SetText("Numeric value");
    HealthPower_CheckButton_NumericValue:SetChecked(Config.NumericValue);

    -- CheckButton: Percentage
    local HealthPower_CheckButton_Percentage = CreateFrame("CheckButton", nil, panel_main, "InterfaceOptionsCheckButtonTemplate");
    HealthPower_CheckButton_Percentage:SetPoint("topLeft", HealthPower_CheckButton_NumericValue, "bottomLeft", 0, -8);
    HealthPower_CheckButton_Percentage.Text:SetText("Percentage");
    HealthPower_CheckButton_Percentage:SetChecked(Config.Percentage);

    -- CheckButton: Display percentage as the main value
    local HealthPower_CheckButton_PercentageAsMainValue = CreateFrame("CheckButton", nil, panel_main, "InterfaceOptionsCheckButtonTemplate");
    HealthPower_CheckButton_PercentageAsMainValue:SetPoint("topLeft", HealthPower_CheckButton_Percentage, "bottomLeft", 16, -8);
    HealthPower_CheckButton_PercentageAsMainValue.Text:SetText("Switch positions");
    HealthPower_CheckButton_PercentageAsMainValue:SetChecked(Config.PercentageAsMainValue);
    HealthPower_CheckButton_PercentageAsMainValue:SetEnabled(Config.Percentage and Config.NumericValue);
    if HealthPower_CheckButton_PercentageAsMainValue:IsEnabled() then
        HealthPower_CheckButton_PercentageAsMainValue.Text:SetFontObject("GameFontHighlight");
    else
        HealthPower_CheckButton_PercentageAsMainValue.Text:SetFontObject("GameFontDisable");
    end

    HealthPower_CheckButton_Percentage:SetScript("OnClick", function(self)
        Config.Percentage = self:GetChecked();

        HealthPower_CheckButton_PercentageAsMainValue:SetEnabled(self:GetChecked() and HealthPower_CheckButton_NumericValue:GetChecked());
        if HealthPower_CheckButton_PercentageAsMainValue:IsEnabled() then
            HealthPower_CheckButton_PercentageAsMainValue.Text:SetFontObject("GameFontHighlight");
        else
            HealthPower_CheckButton_PercentageAsMainValue.Text:SetFontObject("GameFontDisable");
        end

        func:Update();
        func:PersonalNameplate();
    end);

    HealthPower_CheckButton_NumericValue:SetScript("OnClick", function(self)
        Config.NumericValue = self:GetChecked();

        HealthPower_CheckButton_PercentageAsMainValue:SetEnabled(self:GetChecked() and HealthPower_CheckButton_Percentage:GetChecked());
        if HealthPower_CheckButton_PercentageAsMainValue:IsEnabled() then
            HealthPower_CheckButton_PercentageAsMainValue.Text:SetFontObject("GameFontHighlight");
        else
            HealthPower_CheckButton_PercentageAsMainValue.Text:SetFontObject("GameFontDisable");
        end

        func:Update();
        func:PersonalNameplate();
    end);

    HealthPower_CheckButton_PercentageAsMainValue:SetScript("OnClick", function(self)
        Config.PercentageAsMainValue = self:GetChecked();

        local nameplates = C_NamePlate.GetNamePlates();
        if nameplates then
            for k,v in pairs(nameplates) do
                if k then
                    func:Update_Health(v.unitFrame.unit);
                end
            end
        end

        func:PersonalNameplate();
    end)

    HealthPower_CheckButton_PercentageAsMainValue:SetScript("OnShow", function(self)
        self:SetEnabled(HealthPower_CheckButton_Percentage:GetChecked() and HealthPower_CheckButton_NumericValue:GetChecked());
        if self:IsEnabled() then
            self.Text:SetFontObject("GameFontHighlight");
        else
            self.Text:SetFontObject("GameFontDisable");
        end
    end);

    HealthPower_CheckButton_PercentageAsMainValue:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "anchor_top", 0, 16);
        GameTooltip:SetText("Switches positions of main value and percentage");
    end)

    -- CheckButton: Total health
    local HealthPower_CheckButton_TotalHealth = CreateFrame("CheckButton", nil, panel_main, "InterfaceOptionsCheckButtonTemplate");
    HealthPower_CheckButton_TotalHealth:SetPoint("topLeft", HealthPower_CheckButton_PercentageAsMainValue, "bottomLeft", -16, -8);
    HealthPower_CheckButton_TotalHealth.Text:SetText("Total health");
    HealthPower_CheckButton_TotalHealth:SetChecked(Config.PersonalNameplateTotalHealth);
    HealthPower_CheckButton_TotalHealth:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "anchor_top", 0, 16);
        GameTooltip:SetText("Displayed on personal nameplate only");
    end);
    HealthPower_CheckButton_TotalHealth:SetScript("OnClick", function(self)
        Config.PersonalNameplateTotalHealth = self:GetChecked();
        func:PersonalNameplate();
    end);

    -- CheckButton: Total power
    local HealthPower_CheckButton_TotalPower = CreateFrame("CheckButton", nil, panel_main, "InterfaceOptionsCheckButtonTemplate");
    HealthPower_CheckButton_TotalPower:SetPoint("topLeft", HealthPower_CheckButton_TotalHealth, "bottomLeft", 0, -8);
    HealthPower_CheckButton_TotalPower.Text:SetText("Total power");
    HealthPower_CheckButton_TotalPower:SetChecked(Config.PersonalNameplateTotalPower);
    HealthPower_CheckButton_TotalPower:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "anchor_top", 0, 16);
        GameTooltip:SetText("Displayed on personal nameplate only");
    end);
    HealthPower_CheckButton_TotalPower:SetScript("OnClick", function(self)
        Config.PersonalNameplateTotalPower = self:GetChecked();
        func:PersonalNameplate();
    end);

    -- CheckButton: Large main value
    local HealthPower_CheckButton_LargeMainValue = CreateFrame("CheckButton", nil, panel_main, "InterfaceOptionsCheckButtonTemplate");
    HealthPower_CheckButton_LargeMainValue:SetPoint("topLeft", HealthPower_CheckButton_TotalPower, "bottomLeft", 0, -8);
    HealthPower_CheckButton_LargeMainValue.Text:SetText("Large main health value");
    HealthPower_CheckButton_LargeMainValue:SetChecked(Config.LargeMainValue);
    HealthPower_CheckButton_LargeMainValue:SetScript("OnClick", function(self)
        Config.LargeMainValue = self:GetChecked();
        func:Update();
        func:PersonalNameplate();
    end);

    -- SubTitle: Font color
    local HealthPower_ColorPicker_FontColor = panel_main:CreateFontString(nil, "overlay", "GameFontNormal");
    HealthPower_ColorPicker_FontColor:SetPoint("topLeft", HealthPower_CheckButton_LargeMainValue, "bottomLeft", 0, -16);
    HealthPower_ColorPicker_FontColor:SetText("Color:");

    local HealthPower_ColorPicker_FontColorButton = CreateFrame("button", nil, panel_main, "BackdropTemplate");
    HealthPower_ColorPicker_FontColorButton:SetPoint("left", HealthPower_ColorPicker_FontColor, "right", 8, 0);
    HealthPower_ColorPicker_FontColorButton:SetSize(16, 16);
    HealthPower_ColorPicker_FontColorButton:SetBackdrop(backdropInfo);
    HealthPower_ColorPicker_FontColorButton:SetBackdropBorderColor(1,1,1);
    HealthPower_ColorPicker_FontColorButton:SetScript("OnEnter", function()
        HealthPower_ColorPicker_FontColorButton:SetBackdropBorderColor(1, 0.82, 0);
    end);
    HealthPower_ColorPicker_FontColorButton:SetScript("OnLeave", function()
        HealthPower_ColorPicker_FontColorButton:SetBackdropBorderColor(1, 1, 1);
    end);
    local health_ColorPicker_FontColorButtonTexture = panel_main:CreateTexture();
    health_ColorPicker_FontColorButtonTexture:SetParent(HealthPower_ColorPicker_FontColorButton);
    health_ColorPicker_FontColorButtonTexture:SetPoint("center", HealthPower_ColorPicker_FontColorButton, "center");
    health_ColorPicker_FontColorButtonTexture:SetSize(14, 14);
    health_ColorPicker_FontColorButtonTexture:SetColorTexture(1,1,1);
    health_ColorPicker_FontColorButtonTexture:SetVertexColor(
        Config.HealthFontColor.r,
        Config.HealthFontColor.g,
        Config.HealthFontColor.b,
        Config.HealthFontColor.a
    );

    local function reColorFrames(r,g,b,a)
        data.nameplate.healthMain:SetTextColor(r,g,b,a);
        data.nameplate.healthLeftSide:SetTextColor(r,g,b,a);

        local nameplates = C_NamePlate.GetNamePlates();
        if nameplates then
            for k,v in pairs(nameplates) do
                if k then
                    v.unitFrame.healthMain:SetTextColor(r,g,b,a);
                    v.unitFrame.healthLeftSide:SetTextColor(r,g,b,a);
                end
            end
        end
    end

    local function showColorPicker(r,g,b,a,callback)
        ColorPickerFrame.hasOpacity, ColorPickerFrame.opacity = (a ~= nil), a;
        ColorPickerFrame.previousValues = {r,g,b,a};
        ColorPickerFrame.func, ColorPickerFrame.opacityFunc, ColorPickerFrame.cancelFunc = callback, callback, callback;
        ColorPickerFrame:SetColorRGB(r,g,b);
        ColorPickerFrame:Hide();
        ColorPickerFrame:Show();
    end

    HealthPower_ColorPicker_FontColorButton.recolorTexture = function(color)
        local r,g,b,a;

        if color then
            r,g,b,a = color[1], color[2], color[3], color[4];
        else
            r,g,b = ColorPickerFrame:GetColorRGB();
            a = OpacitySliderFrame:GetValue();
        end

        health_ColorPicker_FontColorButtonTexture:SetVertexColor( r,g,b,a );

        reColorFrames(r,g,b,a);
    end

    HealthPower_ColorPicker_FontColorButton:EnableMouse(true);
    HealthPower_ColorPicker_FontColorButton:SetScript("OnClick", function(self, ...)
        local r,g,b,a = health_ColorPicker_FontColorButtonTexture:GetVertexColor();
        showColorPicker(r,g,b,a,self.recolorTexture);
    end);

    local ResetFontColor  = CreateFrame("button", nil, panel_main, "UIPanelButtonTemplate");
    ResetFontColor:SetPoint("left", health_ColorPicker_FontColorButtonTexture, "right", 10, 0);
    ResetFontColor:SetWidth(50)
    ResetFontColor:SetText("Reset");
    ResetFontColor:SetScript("Onclick", function()
        Config.HealthFontColor.r = default.HealthFontColor.r;
        Config.HealthFontColor.g = default.HealthFontColor.g;
        Config.HealthFontColor.b = default.HealthFontColor.b;
        Config.HealthFontColor.a = default.HealthFontColor.a;

        health_ColorPicker_FontColorButtonTexture:SetVertexColor(
            Config.HealthFontColor.r,
            Config.HealthFontColor.g,
            Config.HealthFontColor.b,
            Config.HealthFontColor.a
        );
        reColorFrames(
            Config.HealthFontColor.r,
            Config.HealthFontColor.g,
            Config.HealthFontColor.b,
            Config.HealthFontColor.a
        );
    end);

    -- SubTitle: Threat
    local threat_SubTitle = panel_main:CreateFontString(nil, "overlay", "GameFontNormal");
    threat_SubTitle:SetPoint("topLeft", HealthPower_ColorPicker_FontColor, "bottomLeft", 0, -32);
    threat_SubTitle:SetText("Threat");

    -- CheckButton: Threat percentage
    local threat_CheckButton_ThreatPercentage = CreateFrame("CheckButton", nil, panel_main, "InterfaceOptionsCheckButtonTemplate");
    threat_CheckButton_ThreatPercentage:SetPoint("topLeft", threat_SubTitle, "bottomLeft", 0, -8);
    threat_CheckButton_ThreatPercentage.Text:SetText("Show threat percentage");
    threat_CheckButton_ThreatPercentage:SetChecked(Config.ThreatPercentage);
    threat_CheckButton_ThreatPercentage:SetScript("OnClick", function(self)
        Config.ThreatPercentage = self:GetChecked();
        func:Update();
    end);

    -- Slider: Threat threshold
    local threat_Slider_ThreatWarningThreshold = CreateFrame("Slider", myAddon .. "Slider_ThreatWarningThreshold", panel_main, "OptionsSliderTemplate");
    threat_Slider_ThreatWarningThreshold:SetPoint("topLeft", threat_CheckButton_ThreatPercentage, "bottomLeft", 0, -32);
    threat_Slider_ThreatWarningThreshold:SetOrientation("horizontal");
    threat_Slider_ThreatWarningThreshold:SetWidth(180);
    threat_Slider_ThreatWarningThreshold:SetHeight(18);
    threat_Slider_ThreatWarningThreshold:SetMinMaxValues(1, 100);
    threat_Slider_ThreatWarningThreshold:SetValueStep(1);
    threat_Slider_ThreatWarningThreshold:SetObeyStepOnDrag(true);
    threat_Slider_ThreatWarningThreshold:SetValue(Config.ThreatWarningThreshold);
    _G[threat_Slider_ThreatWarningThreshold:GetName() .. "Low"]:SetText("");
    _G[threat_Slider_ThreatWarningThreshold:GetName() .. "High"]:SetText("");
    threat_Slider_ThreatWarningThreshold.Text:SetFontObject("GameFontNormal");
    threat_Slider_ThreatWarningThreshold.Text:SetText("Threat warning threshold");
    threat_Slider_ThreatWarningThreshold.TextValue = panel_main:CreateFontString(nil, "overlay", "GameFontHighlightSmall");
    threat_Slider_ThreatWarningThreshold.TextValue:SetPoint("top", threat_Slider_ThreatWarningThreshold, "bottom");
    threat_Slider_ThreatWarningThreshold.TextValue:SetText(string.format("%.0f", threat_Slider_ThreatWarningThreshold:GetValue()) .. "%");
    threat_Slider_ThreatWarningThreshold:SetScript("OnValueChanged", function(self)
        self.TextValue:SetText(string.format("%.0f", self:GetValue()) .. "%");
        Config.ThreatWarningThreshold = self:GetValue();
        func:Update();
    end);
    threat_Slider_ThreatWarningThreshold:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "anchor_top", 0, 16);
        GameTooltip:SetText("Sets threshold for high threat warning (orange glow)");
    end)

    ----------------------------------------
    -- SUB-CATEGORY: AURAS
    ----------------------------------------

    local panel_auras = CreateFrame("frame");
    panel_auras.parent = panel_main.name;
    panel_auras.name = "Buffs & debuffs";

    -- Icon
    local auras_icon = panel_auras:CreateTexture();
    auras_icon:SetPoint("topLeft", 16, -16);
    auras_icon:SetTexture("Interface\\addons\\ClassicPlatesPlus\\media\\icons\\ClassicPlatesPlus_icon");
    auras_icon:SetSize(20, 20);

    -- Title
    local auras_title = panel_auras:CreateFontString(nil, "overlay", "GameFontNormalLarge");
    auras_title:SetPoint("left", auras_icon, "right", 6, 0);
    auras_title:SetText("ClassicPlates Plus");

    -- DropdownMenu: Auras visibility
    local auras_subTitle_AurasVisibility = panel_auras:CreateFontString(nil, "overlay", "GameFontNormal");
    auras_subTitle_AurasVisibility:SetPoint("topLeft", auras_icon, "bottomLeft", 0, -16);
    auras_subTitle_AurasVisibility:SetText("Show auras:");

    local auras_selection_AurasVisibility = Config.AurasShow;
    local auras_DropdownMenu_AurasVisibility = CreateFrame("Frame", nil, panel_auras, "UIDropDownMenuTemplate");
    local function getVarName_AurasVisibility(var)
        if var == 1 then
            return "Applied by you";
        elseif var == 2 then
            return "All";
        end
    end
    auras_DropdownMenu_AurasVisibility:SetPoint("topLeft", auras_subTitle_AurasVisibility, "bottomLeft", -16, -4);
    UIDropDownMenu_SetWidth(auras_DropdownMenu_AurasVisibility, 140);
    UIDropDownMenu_SetText(auras_DropdownMenu_AurasVisibility, getVarName_AurasVisibility(auras_selection_AurasVisibility));
    UIDropDownMenu_Initialize(auras_DropdownMenu_AurasVisibility, function(self)
        local info = UIDropDownMenu_CreateInfo();
        info.func = self.SetValue;
        info.text, info.arg1, info.checked = getVarName_AurasVisibility(1), 1, 1 == auras_selection_AurasVisibility;
        UIDropDownMenu_AddButton(info);
        info.text, info.arg1, info.checked = getVarName_AurasVisibility(2), 2, 2 == auras_selection_AurasVisibility;
        UIDropDownMenu_AddButton(info);
    end);
    function auras_DropdownMenu_AurasVisibility:SetValue(newValue)
        auras_selection_AurasVisibility = newValue;
        UIDropDownMenu_SetText(auras_DropdownMenu_AurasVisibility, getVarName_AurasVisibility(auras_selection_AurasVisibility));
        CloseDropDownMenus();
        Config.AurasShow = auras_selection_AurasVisibility;
        func:Update();
    end

    -- CheckButton: Countdown
    local auras_CheckButton_AurasCountdown = CreateFrame("CheckButton", nil, panel_auras, "InterfaceOptionsCheckButtonTemplate");
    auras_CheckButton_AurasCountdown:SetPoint("topLeft", auras_DropdownMenu_AurasVisibility, "bottomLeft", 16, -4);
    auras_CheckButton_AurasCountdown.Text:SetText("Show countdown");
    auras_CheckButton_AurasCountdown:SetChecked(Config.AurasCountdown);
    auras_CheckButton_AurasCountdown:SetScript("OnClick", function(self)
        Config.AurasCountdown = self:GetChecked();
        func:Update();
    end);

    -- CheckButton: Reverse auras cooldown animation
    local auras_CheckButton_AurasReverseAnimation = CreateFrame("CheckButton", nil, panel_auras, "InterfaceOptionsCheckButtonTemplate");
    auras_CheckButton_AurasReverseAnimation:SetPoint("topLeft", auras_CheckButton_AurasCountdown, "bottomLeft", 0, -4);
    auras_CheckButton_AurasReverseAnimation.Text:SetText("Reverse cooldown animation");
    auras_CheckButton_AurasReverseAnimation:SetChecked(Config.AurasReverseAnimation);
    auras_CheckButton_AurasReverseAnimation:SetScript("OnClick", function(self)
        Config.AurasReverseAnimation = self:GetChecked();
        func:Update();
    end);

    -- Auras slider, scale
    local auras_Slider_AurasScale = CreateFrame("Slider", myAddon .. "Slider_AurasScale", panel_auras, "OptionsSliderTemplate");
    auras_Slider_AurasScale:SetPoint("topLeft", auras_CheckButton_AurasReverseAnimation, "bottomLeft", 3, -24);
    auras_Slider_AurasScale:SetOrientation("HORIZONTAL");
    auras_Slider_AurasScale:SetWidth(180);
    auras_Slider_AurasScale:SetHeight(18);
    auras_Slider_AurasScale:SetMinMaxValues(0.75, 1.25);
    auras_Slider_AurasScale:SetValueStep(0.01);
    auras_Slider_AurasScale:SetObeyStepOnDrag(true);
    auras_Slider_AurasScale:SetValue(Config.AurasScale);
    _G[auras_Slider_AurasScale:GetName() .. "Low"]:SetText("");
    _G[auras_Slider_AurasScale:GetName() .. "High"]:SetText("");
    auras_Slider_AurasScale.Text:SetFontObject("GameFontNormal");
    auras_Slider_AurasScale.Text:SetText("Aura scale");
    auras_Slider_AurasScale.TextValue = panel_auras:CreateFontString(nil, "overlay", "GameFontHighlightSmall");
    auras_Slider_AurasScale.TextValue:SetPoint("top", auras_Slider_AurasScale, "bottom");
    auras_Slider_AurasScale.TextValue:SetText(string.format("%.2f", auras_Slider_AurasScale:GetValue()));
    auras_Slider_AurasScale:SetScript("OnValueChanged", function(self)
        auras_Slider_AurasScale.TextValue:SetText(string.format("%.2f", self:GetValue()));
        Config.AurasScale = self:GetValue();
        --func:Update();

        local nameplates = C_NamePlate.GetNamePlates();

        if nameplates then
            for k,v in pairs(nameplates) do
                if k then
                    for i = 1, 40 do
                        if v.unitFrame.buffs[i] then
                            v.unitFrame.buffs[i]:SetScale(Config.AurasScale - 0.15);
                        end
                    end
                    for i = 1, 40 do
                        if v.unitFrame.debuffs[i] then
                            v.unitFrame.debuffs[i]:SetScale(Config.AurasScale - 0.15);
                        end
                    end
                end
            end
        end
    end);

    -- Auras CheckButton, buffs on friendlies
    local auras_CheckButton_BuffsFriendly = CreateFrame("CheckButton", nil, panel_auras, "InterfaceOptionsCheckButtonTemplate");
    auras_CheckButton_BuffsFriendly:SetPoint("topLeft", auras_icon, "bottomLeft", 310, -24);
    auras_CheckButton_BuffsFriendly:SetChecked(Config.BuffsFriendly);

    -- Auras slider, Max buffs on friendlies
    local auras_Slider_MaxBuffsFriendly = CreateFrame("Slider", myAddon .. "Slider_MaxBuffsFriendly", panel_auras, "OptionsSliderTemplate");
    auras_Slider_MaxBuffsFriendly:SetPoint("left", auras_CheckButton_BuffsFriendly, "right", 2, 0);
    auras_Slider_MaxBuffsFriendly:SetSize(180, 18);
    auras_Slider_MaxBuffsFriendly:SetFrameLevel(auras_CheckButton_BuffsFriendly:GetFrameLevel() + 1);
    auras_Slider_MaxBuffsFriendly:SetOrientation("horizontal");
    auras_Slider_MaxBuffsFriendly:SetMinMaxValues(1, 16);
    auras_Slider_MaxBuffsFriendly:SetValueStep(1);
    auras_Slider_MaxBuffsFriendly:SetObeyStepOnDrag(true);
    auras_Slider_MaxBuffsFriendly:SetValue(Config.AurasMaxBuffsFriendly);
    _G[auras_Slider_MaxBuffsFriendly:GetName() .. "Low"]:SetText("");
    _G[auras_Slider_MaxBuffsFriendly:GetName() .. "High"]:SetText("");
    auras_Slider_MaxBuffsFriendly.Text:SetFontObject("GameFontNormal");
    auras_Slider_MaxBuffsFriendly.Text:SetText("Buffs on friendlies");
    auras_Slider_MaxBuffsFriendly.TextValue = panel_auras:CreateFontString(nil, "overlay", "GameFontHighlightSmall");
    auras_Slider_MaxBuffsFriendly.TextValue:SetPoint("top", auras_Slider_MaxBuffsFriendly, "bottom");
    auras_Slider_MaxBuffsFriendly.TextValue:SetText(string.format("%.0f", auras_Slider_MaxBuffsFriendly:GetValue()));
    auras_Slider_MaxBuffsFriendly:SetScript("OnValueChanged", function(self)
        self.TextValue:SetText(string.format("%.0f", self:GetValue()));
        Config.AurasMaxBuffsFriendly = self:GetValue();
        func:Update();
    end);

    auras_CheckButton_BuffsFriendly:SetScript("OnClick", function(self)
        if self:GetChecked() then
            auras_Slider_MaxBuffsFriendly.Text:SetFontObject("GameFontNormal");
            auras_Slider_MaxBuffsFriendly.TextValue:SetFontObject("GameFontHighlightSmall");
        else
            auras_Slider_MaxBuffsFriendly.Text:SetFontObject("GameFontDisable");
            auras_Slider_MaxBuffsFriendly.TextValue:SetFontObject("GameFontDisableSmall");
        end
        auras_Slider_MaxBuffsFriendly:SetEnabled(self:GetChecked());

        Config.BuffsFriendly = self:GetChecked();

        local nameplates = C_NamePlate.GetNamePlates();
        if nameplates then
            for k,v in pairs(nameplates) do
                if k then
                    func:Update_Auras(v.unitFrame.unit);
                end
            end
        end
    end);

    auras_Slider_MaxBuffsFriendly:SetScript("OnShow", function(self)
        if auras_CheckButton_BuffsFriendly:GetChecked() then
            self.Text:SetFontObject("GameFontNormal");
            self.TextValue:SetFontObject("GameFontHighlightSmall");
        else
            self.Text:SetFontObject("GameFontDisable");
            self.TextValue:SetFontObject("GameFontDisableSmall");
        end
        self:SetEnabled(auras_CheckButton_BuffsFriendly:GetChecked());
    end);

    -- Auras CheckButton, debuffs on friendlies
    local auras_CheckButton_DebuffsFriendly = CreateFrame("CheckButton", nil, panel_auras, "InterfaceOptionsCheckButtonTemplate");
    auras_CheckButton_DebuffsFriendly:SetPoint("topLeft", auras_CheckButton_BuffsFriendly, "topLeft", 0, -48);
    auras_CheckButton_DebuffsFriendly:SetChecked(Config.DebuffsFriendly);

    -- Auras slider, Max debuffs on friendlies
    local auras_Slider_MaxDebuffsFriendly = CreateFrame("Slider", myAddon .. "Slider_MaxDebuffsFriendly", panel_auras, "OptionsSliderTemplate");
    auras_Slider_MaxDebuffsFriendly:SetPoint("left", auras_CheckButton_DebuffsFriendly, "right", 2, 0);
    auras_Slider_MaxDebuffsFriendly:SetOrientation("HORIZONTAL");
    auras_Slider_MaxDebuffsFriendly:SetSize(180, 18);
    auras_Slider_MaxDebuffsFriendly:SetFrameLevel(auras_CheckButton_DebuffsFriendly:GetFrameLevel() + 1);
    auras_Slider_MaxDebuffsFriendly:SetMinMaxValues(1, 16);
    auras_Slider_MaxDebuffsFriendly:SetValueStep(1);
    auras_Slider_MaxDebuffsFriendly:SetObeyStepOnDrag(true);
    auras_Slider_MaxDebuffsFriendly:SetValue(Config.AurasMaxDebuffsFriendly);
    _G[auras_Slider_MaxDebuffsFriendly:GetName() .. "Low"]:SetText("");
    _G[auras_Slider_MaxDebuffsFriendly:GetName() .. "High"]:SetText("");
    auras_Slider_MaxDebuffsFriendly.Text:SetFontObject("GameFontNormal");
    auras_Slider_MaxDebuffsFriendly.Text:SetText("Debuffs on friendlies");
    auras_Slider_MaxDebuffsFriendly.TextValue = panel_auras:CreateFontString(nil, "overlay", "GameFontHighlightSmall");
    auras_Slider_MaxDebuffsFriendly.TextValue:SetPoint("top", auras_Slider_MaxDebuffsFriendly, "bottom");
    auras_Slider_MaxDebuffsFriendly.TextValue:SetText(string.format("%.0f", auras_Slider_MaxDebuffsFriendly:GetValue()));
    auras_Slider_MaxDebuffsFriendly:SetEnabled(auras_CheckButton_DebuffsFriendly:GetChecked());
    auras_Slider_MaxDebuffsFriendly:SetScript("OnValueChanged", function(self)
        self.TextValue:SetText(string.format("%.0f", self:GetValue()));
        Config.AurasMaxDebuffsFriendly = self:GetValue();
        func:Update();
    end);

    auras_CheckButton_DebuffsFriendly:SetScript("OnClick", function(self)
        if self:GetChecked() then
            auras_Slider_MaxDebuffsFriendly.Text:SetFontObject("GameFontNormal");
            auras_Slider_MaxDebuffsFriendly.TextValue:SetFontObject("GameFontHighlightSmall");
        else
            auras_Slider_MaxDebuffsFriendly.Text:SetFontObject("GameFontDisable");
            auras_Slider_MaxDebuffsFriendly.TextValue:SetFontObject("GameFontDisableSmall");
        end
        auras_Slider_MaxDebuffsFriendly:SetEnabled(self:GetChecked());

        Config.DebuffsFriendly = self:GetChecked();

        local nameplates = C_NamePlate.GetNamePlates();
        if nameplates then
            for k,v in pairs(nameplates) do
                if k then
                    func:Update_Auras(v.unitFrame.unit);
                end
            end
        end
    end);

    auras_Slider_MaxDebuffsFriendly:SetScript("OnShow", function(self)
        if auras_CheckButton_DebuffsFriendly:GetChecked() then
            self.Text:SetFontObject("GameFontNormal");
            self.TextValue:SetFontObject("GameFontHighlightSmall");
        else
            self.Text:SetFontObject("GameFontDisable");
            self.TextValue:SetFontObject("GameFontDisableSmall");
        end
        self:SetEnabled(auras_CheckButton_DebuffsFriendly:GetChecked());
    end);

    -- Auras CheckButton, buffs on enemies
    local auras_CheckButton_BuffsEnemy = CreateFrame("CheckButton", nil, panel_auras, "InterfaceOptionsCheckButtonTemplate");
    auras_CheckButton_BuffsEnemy:SetPoint("topLeft", auras_CheckButton_DebuffsFriendly, "topLeft", 0, -64);
    auras_CheckButton_BuffsEnemy:SetChecked(Config.BuffsEnemy);

    -- Auras slider, Max buffs on enemies
    local auras_Slider_MaxBuffsEnemy = CreateFrame("Slider", myAddon .. "Slider_MaxBuffsEnemy", panel_auras, "OptionsSliderTemplate");
    auras_Slider_MaxBuffsEnemy:SetPoint("left", auras_CheckButton_BuffsEnemy, "right", 2, 0);
    auras_Slider_MaxBuffsEnemy:SetOrientation("HORIZONTAL");
    auras_Slider_MaxBuffsEnemy:SetSize(180, 18);
    auras_Slider_MaxBuffsEnemy:SetFrameLevel(auras_CheckButton_BuffsEnemy:GetFrameLevel() + 1);
    auras_Slider_MaxBuffsEnemy:SetMinMaxValues(1, 16);
    auras_Slider_MaxBuffsEnemy:SetValueStep(1);
    auras_Slider_MaxBuffsEnemy:SetObeyStepOnDrag(true);
    auras_Slider_MaxBuffsEnemy:SetValue(Config.AurasMaxBuffsEnemy);
    _G[auras_Slider_MaxBuffsEnemy:GetName() .. "Low"]:SetText("");
    _G[auras_Slider_MaxBuffsEnemy:GetName() .. "High"]:SetText("");
    auras_Slider_MaxBuffsEnemy.Text:SetFontObject("GameFontNormal");
    auras_Slider_MaxBuffsEnemy.Text:SetText("Buffs on enemies");
    auras_Slider_MaxBuffsEnemy.TextValue = panel_auras:CreateFontString(nil, "overlay", "GameFontHighlightSmall");
    auras_Slider_MaxBuffsEnemy.TextValue:SetPoint("top", auras_Slider_MaxBuffsEnemy, "bottom");
    auras_Slider_MaxBuffsEnemy.TextValue:SetText(string.format("%.0f", auras_Slider_MaxBuffsEnemy:GetValue()));
    auras_Slider_MaxBuffsEnemy:SetEnabled(auras_CheckButton_BuffsEnemy:GetChecked());
    auras_Slider_MaxBuffsEnemy:SetScript("OnValueChanged", function(self)
        self.TextValue:SetText(string.format("%.0f", self:GetValue()));
        Config.AurasMaxBuffsEnemy = self:GetValue();
        func:Update();
    end);

    auras_CheckButton_BuffsEnemy:SetScript("OnClick", function(self)
        if self:GetChecked() then
            auras_Slider_MaxBuffsEnemy.Text:SetFontObject("GameFontNormal");
            auras_Slider_MaxBuffsEnemy.TextValue:SetFontObject("GameFontHighlightSmall");
        else
            auras_Slider_MaxBuffsEnemy.Text:SetFontObject("GameFontDisable");
            auras_Slider_MaxBuffsEnemy.TextValue:SetFontObject("GameFontDisableSmall");
        end
        auras_Slider_MaxBuffsEnemy:SetEnabled(self:GetChecked());

        Config.BuffsEnemy = self:GetChecked();

        local nameplates = C_NamePlate.GetNamePlates();
        if nameplates then
            for k,v in pairs(nameplates) do
                if k then
                    func:Update_Auras(v.unitFrame.unit);
                end
            end
        end
    end);

    auras_Slider_MaxBuffsEnemy:SetScript("OnShow", function(self)
        if auras_CheckButton_BuffsEnemy:GetChecked() then
            self.Text:SetFontObject("GameFontNormal");
            self.TextValue:SetFontObject("GameFontHighlightSmall");
        else
            self.Text:SetFontObject("GameFontDisable");
            self.TextValue:SetFontObject("GameFontDisableSmall");
        end
        self:SetEnabled(auras_CheckButton_BuffsEnemy:GetChecked());
    end);

    -- Auras CheckButton, debuffs on enemies
    local auras_CheckButton_DebuffsEnemy = CreateFrame("CheckButton", nil, panel_auras, "InterfaceOptionsCheckButtonTemplate");
    auras_CheckButton_DebuffsEnemy:SetPoint("left", auras_CheckButton_BuffsEnemy, "left", 0, -48);
    auras_CheckButton_DebuffsEnemy:SetChecked(Config.DebuffsEnemy);

    -- Auras slider, Max debuffs on enemies
    local auras_Slider_MaxDebuffsEnemy = CreateFrame("Slider", myAddon .. "Slider_MaxDebuffsEnemy", panel_auras, "OptionsSliderTemplate");
    auras_Slider_MaxDebuffsEnemy:SetPoint("left", auras_CheckButton_DebuffsEnemy, "right", 2, 0);
    auras_Slider_MaxDebuffsEnemy:SetOrientation("HORIZONTAL");
    auras_Slider_MaxDebuffsEnemy:SetSize(180,18);
    auras_Slider_MaxDebuffsEnemy:SetFrameLevel(auras_CheckButton_DebuffsEnemy:GetFrameLevel() + 1);
    auras_Slider_MaxDebuffsEnemy:SetMinMaxValues(1, 16);
    auras_Slider_MaxDebuffsEnemy:SetValueStep(1);
    auras_Slider_MaxDebuffsEnemy:SetObeyStepOnDrag(true);
    auras_Slider_MaxDebuffsEnemy:SetValue(Config.AurasMaxDebuffsEnemy);
    _G[auras_Slider_MaxDebuffsEnemy:GetName() .. "Low"]:SetText("");
    _G[auras_Slider_MaxDebuffsEnemy:GetName() .. "High"]:SetText("");
    auras_Slider_MaxDebuffsEnemy.Text:SetFontObject("GameFontNormal");
    auras_Slider_MaxDebuffsEnemy.Text:SetText("Debuffs on enemies");
    auras_Slider_MaxDebuffsEnemy.TextValue = panel_auras:CreateFontString(nil, "overlay", "GameFontHighlightSmall");
    auras_Slider_MaxDebuffsEnemy.TextValue:SetPoint("top", auras_Slider_MaxDebuffsEnemy, "bottom");
    auras_Slider_MaxDebuffsEnemy.TextValue:SetText(string.format("%.0f", auras_Slider_MaxDebuffsEnemy:GetValue()));
    auras_Slider_MaxDebuffsEnemy:SetEnabled(auras_CheckButton_DebuffsEnemy:GetChecked());
    auras_Slider_MaxDebuffsEnemy:SetScript("OnValueChanged", function(self)
        self.TextValue:SetText(string.format("%.0f", self:GetValue()));
        Config.AurasMaxDebuffsEnemy = self:GetValue();
        func:Update();
    end);

    auras_CheckButton_DebuffsEnemy:SetScript("OnClick", function(self)
        if self:GetChecked() then
            auras_Slider_MaxDebuffsEnemy.Text:SetFontObject("GameFontNormal");
            auras_Slider_MaxDebuffsEnemy.TextValue:SetFontObject("GameFontHighlightSmall");
        else
            auras_Slider_MaxDebuffsEnemy.Text:SetFontObject("GameFontDisable");
            auras_Slider_MaxDebuffsEnemy.TextValue:SetFontObject("GameFontDisableSmall");
        end
        auras_Slider_MaxDebuffsEnemy:SetEnabled(self:GetChecked());

        Config.DebuffsEnemy = self:GetChecked();

        local nameplates = C_NamePlate.GetNamePlates();
        if nameplates then
            for k,v in pairs(nameplates) do
                if k then
                    func:Update_Auras(v.unitFrame.unit);
                end
            end
        end
    end);

    auras_Slider_MaxDebuffsEnemy:SetScript("OnShow", function(self)
        if auras_CheckButton_DebuffsEnemy:GetChecked() then
            self.Text:SetFontObject("GameFontNormal");
            self.TextValue:SetFontObject("GameFontHighlightSmall");
        else
            self.Text:SetFontObject("GameFontDisable");
            self.TextValue:SetFontObject("GameFontDisableSmall");
        end
        self:SetEnabled(auras_CheckButton_DebuffsEnemy:GetChecked());
    end);

    ----------------------------------------
    -- PopUp box
    ----------------------------------------
    local auras_PopUp = CreateFrame("Frame", myAddon .. "PopUp", panel_auras, "BackdropTemplate");
    auras_PopUp:SetPoint("topLeft");
    auras_PopUp:SetPoint("bottomRight");
    auras_PopUp:SetFrameLevel(panel_auras:GetFrameLevel() + 5);
    auras_PopUp:EnableMouse(true);
    auras_PopUp:SetBackdrop(backdropGeneral);
    auras_PopUp:SetBackdropColor(0.1, 0.1, 0.1, 1);
    auras_PopUp:SetBackdropBorderColor(0.62, 0.62, 0.62);
    auras_PopUp:Hide();

    -- Title
    local auras_PopUpTitle = auras_PopUp:CreateFontString(nil, "overlay", "GameFontNormalLarge");
    auras_PopUpTitle:SetPoint("topLeft", auras_PopUp, "topLeft", 16, -16);
    auras_PopUpTitle:SetText("Title goes here");

    -- Note
    local auras_PopUpNote = auras_PopUp:CreateFontString(nil, "overlay", "GameFontHighlightSmall");
    auras_PopUpNote:SetPoint("topLeft", auras_PopUpTitle, "bottomLeft", 0, -4);
    auras_PopUpNote:SetText("lorem ipsum dolor sit amet...");
    auras_PopUpNote:SetAlpha(0.66);

    local auras_PopUp_inputBox = CreateFrame("Frame", nil, auras_PopUp, "BackdropTemplate");
    auras_PopUp_inputBox:SetPoint("topLeft", 16, -50);
    auras_PopUp_inputBox:SetPoint("bottomRight", -16, 46);
    auras_PopUp_inputBox:SetBackdrop(backdropGeneral);
    auras_PopUp_inputBox:SetBackdropColor(0, 0, 0, 0.5);
    auras_PopUp_inputBox:SetBackdropBorderColor(0.62, 0.62, 0.62);

    local auras_PopUpScrollFrame = CreateFrame("ScrollFrame", myAddon .. "auras_PopUpScroll", auras_PopUp_inputBox, "UIPanelScrollFrameTemplate");
    auras_PopUpScrollFrame:SetPoint("topLeft", 8, -8);
    auras_PopUpScrollFrame:SetPoint("bottomRight", -28, 6);

    local auras_PopUp_inputButton = CreateFrame("Button", nil, auras_PopUpScrollFrame)
    auras_PopUp_inputButton:SetPoint("topLeft");
    auras_PopUp_inputButton:SetPoint("bottomRight");

    local auras_PopUp_input = CreateFrame("EditBox", nil, auras_PopUpScrollFrame);
    auras_PopUpScrollFrame:SetScrollChild(auras_PopUp_input);
    auras_PopUp_input:SetWidth(554);
    auras_PopUp_input:SetFontObject(GameFontHighlight);
    auras_PopUp_input:SetMultiLine(true);
    auras_PopUp_input:SetMovable(false);
    auras_PopUp_input:SetAutoFocus(false);
    auras_PopUp_input:SetMaxLetters(0);

    auras_PopUp_inputButton:SetFrameLevel(auras_PopUp_input:GetFrameLevel() - 1)

    -- Error message
    local auras_PopUpErrorMsg = auras_PopUp:CreateFontString(nil, "overlay", "GameFontHighlight");
    auras_PopUpErrorMsg:SetPoint("bottomLeft", auras_PopUp, "bottomLeft", 20, 21);
    auras_PopUpErrorMsg:SetTextColor(1, 0, 0);
    auras_PopUpErrorMsg:Hide();

    -- Button Close
    auras_PopUp.ButtonClose = CreateFrame("Button", nil, auras_PopUp, "GameMenuButtonTemplate");
    auras_PopUp.ButtonClose:SetPoint("topRight", auras_PopUp_inputBox, "bottomright", 0, -8);
    auras_PopUp.ButtonClose:SetSize(100, 22);
    auras_PopUp.ButtonClose:SetText("Close");
    auras_PopUp.ButtonClose:SetNormalFontObject("GameFontNormal");
    auras_PopUp.ButtonClose:SetHighlightFontObject("GameFontHighlight");

    -- Button
    auras_PopUp.Button = CreateFrame("Button", nil, auras_PopUp, "GameMenuButtonTemplate");
    auras_PopUp.Button:SetPoint("right", auras_PopUp.ButtonClose, "left");
    auras_PopUp.Button:SetSize(100, 22);
    auras_PopUp.Button:SetText("Button");
    auras_PopUp.Button:SetNormalFontObject("GameFontNormal");
    auras_PopUp.Button:SetHighlightFontObject("GameFontHighlight");
    auras_PopUp.Button:Hide();

    -- Scripts:
    -- Input area
    auras_PopUp_inputButton:SetScript("OnClick", function()
        auras_PopUp_input:SetFocus();
    end);

    -- Cancel
    auras_PopUp.ButtonClose:SetScript("OnClick", function()
        auras_PopUp:Hide();
        auras_PopUp_input:SetText("");
    end);

    -- Escape
    auras_PopUp_input:SetScript("OnEscapePressed", function(self)
        self:ClearFocus();
    end);

    -- On hide
    auras_PopUp_input:SetScript("OnHide", function()
        auras_PopUp:Hide();
    end);

    ----------------------------------------
    -- Find aura
    ----------------------------------------
    local function addSpell(list, input)
        local name = GetSpellInfo(input);

        if input ~= "" then
            if name then
                if not list[input] then
                    list[input] = 1;
                    return true,  '|cfff563ff[ClassicPlates Plus]: |cff00eb00'..'added: '..name;
                elseif list[input] then
                    return false, '|cfff563ff[ClassicPlates Plus]: |cffe3eb00"'..name..' is already listed';
                end
            else
                return false, '|cfff563ff[ClassicPlates Plus]: |cffff0000"'..input..'" not found';
            end
        end
    end

    ----------------------------------------
    -- Important auras
    ----------------------------------------

    -- Sub-title 
    local auras_ImportantTitle = panel_auras:CreateFontString(nil, "overlay", "GameFontNormal");
    auras_ImportantTitle:SetPoint("bottomLeft", panel_auras, "bottomLeft", 16, 275);
    auras_ImportantTitle:SetText("Important auras");

    -- EditBox
    local Important_input = CreateFrame("EditBox", nil, panel_auras, "InputBoxTemplate");
    Important_input:SetPoint("topLeft", auras_ImportantTitle, "bottomLeft", 6, -8);
    Important_input:SetWidth(220);
    Important_input:SetHeight(20);
    Important_input:SetMultiLine(false);
    Important_input:SetMovable(false);
    Important_input:SetAutoFocus(false);
    Important_input:SetFontObject("GameFontHighlight");
    Important_input:SetMaxLetters(9);
    Important_input:SetNumeric(true);

    Important_input.placeholder = panel_auras:CreateFontString(nil, "overlay", "GameFontDisableLeft");
    Important_input.placeholder:SetPoint("left", Important_input, "left", 2, 0);
    Important_input.placeholder:SetText("Enter spell ID");

    -- EditBox Button
    Important_input.AddBtn = CreateFrame("Button", nil, panel_auras, "GameMenuButtonTemplate");
    Important_input.AddBtn:SetPoint("left", Important_input, "right", 4, 0);
    Important_input.AddBtn:SetSize(50, 22);
    Important_input.AddBtn:SetText("Add");
    Important_input.AddBtn:SetNormalFontObject("GameFontNormal");
    Important_input.AddBtn:SetHighlightFontObject("GameFontHighlight");

    -- Border and background
    local auras_Important = CreateFrame("Frame", nil, panel_auras, "BackdropTemplate");
    auras_Important:SetPoint("topLeft", Important_input, "bottomLeft", -6, -8)
    auras_Important:SetSize(280, 190);
    auras_Important:SetBackdrop(backdropGeneral);
    auras_Important:SetBackdropColor(0.07, 0.07, 0.07, 0.7);
    auras_Important:SetBackdropBorderColor(0.62, 0.62, 0.62);

    -- Scroll frame
    local auras_ImportantScrollFrame = CreateFrame("ScrollFrame", myAddon .. "auras_ImportantScrollFrame", auras_Important, "UIPanelScrollFrameTemplate");
    auras_ImportantScrollFrame:SetPoint("topLeft", 4, -5);
    auras_ImportantScrollFrame:SetPoint("bottomRight", -26, 4);

    -- Scroll background
    local auras_ImportantScrollFrameBG = auras_Important:CreateTexture();
    auras_ImportantScrollFrameBG:SetParent(auras_ImportantScrollFrame);
    auras_ImportantScrollFrameBG:SetPoint("topLeft", 255, -10);
    auras_ImportantScrollFrameBG:SetPoint("bottomRight", 22, 10);
    auras_ImportantScrollFrameBG:SetDrawLayer("background");
    auras_ImportantScrollFrameBG:SetColorTexture(0, 0, 0, 0.3);

    -- Scroll child
    local auras_ImportantScrollChild = CreateFrame("Frame");
    auras_ImportantScrollFrame:SetScrollChild(auras_ImportantScrollChild);
    auras_ImportantScrollChild:SetWidth(auras_Important:GetWidth()-18);
    auras_ImportantScrollChild:SetHeight(1);
    auras_ImportantScrollChild.auras = {};

    -- Import button
    local auras_ImportantButton_Import = CreateFrame("Button", nil, panel_auras, "GameMenuButtonTemplate");
    auras_ImportantButton_Import:SetPoint("topLeft", auras_Important, "bottomLeft", 0, -6);
    auras_ImportantButton_Import:SetSize(70, 22);
    auras_ImportantButton_Import:SetText("Import");
    auras_ImportantButton_Import:SetNormalFontObject("GameFontNormal");
    auras_ImportantButton_Import:SetHighlightFontObject("GameFontHighlight");

    -- Export button
    local auras_ImportantButton_Export = CreateFrame("Button", nil, panel_auras, "GameMenuButtonTemplate");
    auras_ImportantButton_Export:SetPoint("left", auras_ImportantButton_Import, "right");
    auras_ImportantButton_Export:SetSize(70, 22);
    auras_ImportantButton_Export:SetText("Export");
    auras_ImportantButton_Export:SetNormalFontObject("GameFontNormal");
    auras_ImportantButton_Export:SetHighlightFontObject("GameFontHighlight");

    -- Remove all Button
    local auras_ImportantButton_RemoveAll = CreateFrame("Button", nil, panel_auras, "GameMenuButtonTemplate");
    auras_ImportantButton_RemoveAll:SetPoint("topright", auras_Important, "bottomright", 0, -6);
    auras_ImportantButton_RemoveAll:SetSize(100, 22);
    auras_ImportantButton_RemoveAll:SetText("Remove all");
    auras_ImportantButton_RemoveAll:SetNormalFontObject("GameFontNormal");
    auras_ImportantButton_RemoveAll:SetHighlightFontObject("GameFontHighlight");

    -- Remove all confirmation popup
    StaticPopupDialogs["ConfirmImportant"] = {
        text = "Remove all important auras?",
        button1 = "Remove",
        button2 = "Cancel",
        OnAccept = function()
            Config.AurasImportantList = {};
            for k,v in pairs(auras_ImportantScrollChild.auras) do
                if k then
                    v:Hide();
                end
            end

            -- Refreshing
            func:UpdateAurasList(auras_ImportantScrollFrame, auras_ImportantScrollChild, "AurasImportantList");
            func:Update();
        end,
        timeout = 0,
        whileDead = true,
        hideOnEscape = true,
    }

    ---------- Scripts ----------

    Important_input:SetScript("OnEditFocusLost", function(self)
        if #self:GetText() == 0 then
            Important_input.placeholder:Show();
        end
    end);

    Important_input:SetScript("OnEditFocusGained", function(self)
        Important_input.placeholder:Hide();
    end);

    Important_input:SetScript("OnHide", function(self)
        self:SetText("");
        Important_input.placeholder:Show();
    end);

    -- EditBox, enter pressed
    Important_input:SetScript("OnEnterPressed", function(self)
        local added, status = addSpell(Config.AurasImportantList, self:GetText());

        if added then
            self:SetText("");
            self:ClearFocus();
            func:UpdateAurasList(auras_ImportantScrollFrame, auras_ImportantScrollChild, "AurasImportantList");
            func:Update();

            if status then
                print(status);
            end
        else
            if status then
                print(status);
            end
        end
    end);

    -- EditBox, button pressed
    Important_input.AddBtn:SetScript("OnClick", function()
        local added, status = addSpell(Config.AurasImportantList, Important_input:GetText());

        if added then
            Important_input:SetText("");
            Important_input:ClearFocus();
            func:UpdateAurasList(auras_ImportantScrollFrame, auras_ImportantScrollChild, "AurasImportantList");
            func:Update();

            if status then
                print(status);
            end
        else
            if status then
                print(status);
            end
        end
    end);

    -- Import button
    auras_ImportantButton_Import:SetScript("OnClick", function()
        auras_PopUpTitle:SetText("Import important auras");
        auras_PopUpNote:SetText("Enter spell IDs separated by commas");
        auras_PopUp_input:SetText("");
        auras_PopUp.Button:SetText("Import");
        auras_PopUp.Button:Show();
        auras_PopUp.Button:SetScript("OnClick", function()
            local import = auras_PopUp_input:GetText();
            local t = {};
            local hash = {};
            local result = {};
            local resultPrint = {
                success = {},
                error = {}
            };
            local confirm;

            for aura in string.gmatch(import, "([^,]*)") do
                local trimmedAura = aura:match("^%s*(.-)%s*$");

                if aura ~= "" then
                    table.insert(t, trimmedAura)
                end

                for _, v in ipairs(t) do
                    if (not hash[v]) then
                        result[#result+1] = v;
                        hash[v] = true;
                    end
                end
            end

            for k,v in ipairs(result) do
                if k then
                    local added, status = addSpell(Config.AurasImportantList, v);

                    if not confirm and added then
                        confirm = added;
                    end

                    if added then
                        if not confirm then
                            confirm = added;
                        end

                        table.insert(resultPrint.success, status);
                    else
                        table.insert(resultPrint.error, status);
                    end
                end
            end

            if #resultPrint.success > 0 then
                print("|cfff563ff" .. "[ClassicPlates Plus]: |cff00eb00" .. "Successfully added " .. #resultPrint.success .. " auras");
            end
            if #resultPrint.error > 0 then
                for k,v in ipairs(resultPrint.error) do
                    print(v);
                end
            end

            func:UpdateAurasList(auras_ImportantScrollFrame, auras_ImportantScrollChild, "AurasImportantList");
            func:Update();

            if confirm then
                auras_PopUp:Hide();
            end
        end);

        auras_PopUp:Show();
        auras_PopUp_input:SetFocus();
    end);

    -- Export button
    auras_ImportantButton_Export:SetScript("OnClick", function()
        auras_PopUpTitle:SetText("Export important auras");
        auras_PopUpNote:SetText("Enter spell IDs separated by commas");
        auras_PopUp_input:SetText("");
        auras_PopUp.Button:SetText("Select all");
        auras_PopUp.Button:Show();

        local export;

        for k,v in pairs(Config.AurasImportantList) do
            if k then
                if not export then
                    export = tostring(k);
                else
                    export = export .. ", " .. k;
                end
            end
        end

        if export then
            auras_PopUp_input:SetText(export);

            auras_PopUp.Button:SetScript("OnClick", function()
                if export then
                    auras_PopUp_input:HighlightText();
                    auras_PopUp_input:SetFocus();
                end
            end);

            auras_PopUp:Show();
            auras_PopUp_input:HighlightText();
            auras_PopUp_input:SetFocus();
        end
    end);

    -- Remove all button
    auras_ImportantButton_RemoveAll:SetScript("OnClick", function()
        StaticPopup_Show("ConfirmImportant");
    end);

    -- Update list
    func:UpdateAurasList(auras_ImportantScrollFrame, auras_ImportantScrollChild, "AurasImportantList");

    ----------------------------------------
    -- Blacklisted auras
    ----------------------------------------

    -- Sub-title 
    local auras_BLAurasTitle = panel_auras:CreateFontString(nil, "overlay", "GameFontNormal");
    auras_BLAurasTitle:SetPoint("bottomLeft", panel_auras, "bottomLeft", 326, 275);
    auras_BLAurasTitle:SetText("Blacklisted auras");

    -- EditBox
    local BLAuras_input = CreateFrame("EditBox", nil, panel_auras, "InputBoxTemplate");
    BLAuras_input:SetPoint("topLeft", auras_BLAurasTitle, "bottomLeft"  , 6, -8);
    BLAuras_input:SetWidth(220);
    BLAuras_input:SetHeight(20);
    BLAuras_input:SetMultiLine(false);
    BLAuras_input:SetMovable(false);
    BLAuras_input:SetAutoFocus(false);
    BLAuras_input:SetFontObject("GameFontHighlight");
    BLAuras_input:SetMaxLetters(9);
    BLAuras_input:SetNumeric(true);

    BLAuras_input.placeholder = panel_auras:CreateFontString(nil, "overlay", "GameFontDisableLeft");
    BLAuras_input.placeholder:SetPoint("left", BLAuras_input, "left", 2, 0);
    BLAuras_input.placeholder:SetText("Enter spell ID");

    -- EditBox button
    BLAuras_input.AddBtn = CreateFrame("Button", nil, panel_auras, "GameMenuButtonTemplate");
    BLAuras_input.AddBtn:SetPoint("left", BLAuras_input, "right", 4, 0);
    BLAuras_input.AddBtn:SetSize(50, 22);
    BLAuras_input.AddBtn:SetText("Add");
    BLAuras_input.AddBtn:SetNormalFontObject("GameFontNormal");
    BLAuras_input.AddBtn:SetHighlightFontObject("GameFontHighlight");

    -- Border and background
    local auras_BLAuras = CreateFrame("Frame", nil, panel_auras, "BackdropTemplate");
    auras_BLAuras:SetPoint("topLeft", BLAuras_input, "bottomLeft", -6, -8)
    auras_BLAuras:SetSize(280, 190);
    auras_BLAuras:SetBackdrop(backdropGeneral);
    auras_BLAuras:SetBackdropColor(0.07, 0.07, 0.07, 0.7);
    auras_BLAuras:SetBackdropBorderColor(0.62, 0.62, 0.62);

    -- Scroll frame
    local auras_BLAurasScrollFrame = CreateFrame("ScrollFrame", myAddon .. "auras_BLAurasScrollFrame", auras_BLAuras, "UIPanelScrollFrameTemplate");
    auras_BLAurasScrollFrame:SetPoint("topLeft", 4, -5);
    auras_BLAurasScrollFrame:SetPoint("bottomRight", -26, 4);

    -- Scroll background
    local auras_BLAurasScrollFrameBG = auras_BLAuras:CreateTexture();
    auras_BLAurasScrollFrameBG:SetParent(auras_BLAurasScrollFrame);
    auras_BLAurasScrollFrameBG:SetPoint("topLeft", 255, -10);
    auras_BLAurasScrollFrameBG:SetPoint("bottomRight", 22, 10);
    auras_BLAurasScrollFrameBG:SetDrawLayer("background");
    auras_BLAurasScrollFrameBG:SetColorTexture(0, 0, 0, 0.3);

    -- Scroll child
    local auras_BLAurasScrollChild = CreateFrame("Frame");
    auras_BLAurasScrollFrame:SetScrollChild(auras_BLAurasScrollChild);
    auras_BLAurasScrollChild:SetWidth(auras_BLAuras:GetWidth()-18);
    auras_BLAurasScrollChild:SetHeight(1);
    auras_BLAurasScrollChild.auras = {};

    -- Import button
    local BLAuras_button_Import = CreateFrame("Button", nil, panel_auras, "GameMenuButtonTemplate");
    BLAuras_button_Import:SetPoint("topLeft", auras_BLAuras, "bottomLeft", 0, -6);
    BLAuras_button_Import:SetSize(70, 22);
    BLAuras_button_Import:SetText("Import");
    BLAuras_button_Import:SetNormalFontObject("GameFontNormal");
    BLAuras_button_Import:SetHighlightFontObject("GameFontHighlight");

    -- Export button
    local BLAuras_button_Export = CreateFrame("Button", nil, panel_auras, "GameMenuButtonTemplate");
    BLAuras_button_Export:SetPoint("left", BLAuras_button_Import, "right");
    BLAuras_button_Export:SetSize(70, 22);
    BLAuras_button_Export:SetText("Export");
    BLAuras_button_Export:SetNormalFontObject("GameFontNormal");
    BLAuras_button_Export:SetHighlightFontObject("GameFontHighlight");

    -- Remove all Button
    local BLAuras_button_RemoveAll = CreateFrame("Button", nil, panel_auras, "GameMenuButtonTemplate");
    BLAuras_button_RemoveAll:SetPoint("topright", auras_BLAuras, "bottomright", 0, -6);
    BLAuras_button_RemoveAll:SetSize(100, 22);
    BLAuras_button_RemoveAll:SetText("Remove all");
    BLAuras_button_RemoveAll:SetNormalFontObject("GameFontNormal");
    BLAuras_button_RemoveAll:SetHighlightFontObject("GameFontHighlight");

    -- Remove all confirmation
    StaticPopupDialogs["ConfirmBlacklisted"] = {
        text = "Remove all blacklisted auras?",
        button1 = "Remove",
        button2 = "Cancel",
        OnAccept = function()
            Config.AurasBlacklist = {};
            for k,v in pairs(auras_BLAurasScrollChild.auras) do
                if k then
                    v:Hide();
                end
            end

            -- Refreshing
            func:UpdateAurasList(auras_BLAurasScrollFrame, auras_BLAurasScrollChild, "AurasBlacklist");
            func:Update();
        end,
        timeout = 0,
        whileDead = true,
        hideOnEscape = true,
    }

    ---------- Scripts ----------

    BLAuras_input:SetScript("OnEditFocusLost", function(self)
        if #self:GetText() == 0 then
            BLAuras_input.placeholder:Show();
        end
    end);

    BLAuras_input:SetScript("OnEditFocusGained", function(self)
        BLAuras_input.placeholder:Hide();
    end);

    BLAuras_input:SetScript("OnHide", function(self)
        self:SetText("");
        BLAuras_input.placeholder:Show();
    end);

    -- EditBox, enter pressed
    BLAuras_input:SetScript("OnEnterPressed", function(self)
        local added, status = addSpell(Config.AurasBlacklist, self:GetText());

        if added then
            self:SetText("");
            self:ClearFocus();
            func:UpdateAurasList(auras_BLAurasScrollFrame, auras_BLAurasScrollChild, "AurasBlacklist");
            func:Update();

            if status then
                print(status);
            end
        else
            if status then
                print(status);
            end
        end
    end);

    -- EditBox, button pressed
    BLAuras_input.AddBtn:SetScript("OnClick", function(self)
        local added, status = addSpell(Config.AurasBlacklist, BLAuras_input:GetText());

        if added then
            BLAuras_input:SetText("");
            BLAuras_input:ClearFocus();
            func:UpdateAurasList(auras_BLAurasScrollFrame, auras_BLAurasScrollChild, "AurasBlacklist");
            func:Update();

            if status then
                print(status);
            end
        else
            if status then
                print(status);
            end
        end
    end);

    -- Import button
    BLAuras_button_Import:SetScript("OnClick", function()
        auras_PopUpTitle:SetText("Import blacklisted auras");
        auras_PopUpNote:SetText("Enter spell IDs separated by commas");
        auras_PopUp_input:SetText("");
        auras_PopUp.Button:SetText("Import");
        auras_PopUp.Button:Show();
        auras_PopUp.Button:SetScript("OnClick", function()
            local import = auras_PopUp_input:GetText();
            local t = {};
            local hash = {};
            local result = {};
            local resultPrint = {
                success = {},
                error = {}
            };
            local confirm;

            for aura in string.gmatch(import, "([^,]*)") do
                local trimmedAura = aura:match("^%s*(.-)%s*$");

                if aura ~= "" then
                    table.insert(t, trimmedAura)
                end

                for _, v in ipairs(t) do
                    if (not hash[v]) then
                        result[#result+1] = v;
                        hash[v] = true;
                    end
                end
            end

            for k,v in ipairs(result) do
                if k then
                    local added, status = addSpell(Config.AurasBlacklist, v);

                    if not confirm and added then
                        confirm = added;
                    end

                    if added then
                        if not confirm then
                            confirm = added;
                        end

                        table.insert(resultPrint.success, status);
                    else
                        table.insert(resultPrint.error, status);
                    end
                end
            end

            if #resultPrint.success > 0 then
                print("|cfff563ff[ClassicPlates Plus]: |cff00eb00" .. "Successfully added " .. #resultPrint.success .. " auras");
            end
            if #resultPrint.error > 0 then
                for k,v in ipairs(resultPrint.error) do
                    print(v);
                end
            end

            func:UpdateAurasList(auras_BLAurasScrollFrame, auras_BLAurasScrollChild, "AurasBlacklist");
            func:Update();

            if confirm then
                auras_PopUp:Hide();
            end
        end);

        auras_PopUp:Show();
        auras_PopUp_input:SetFocus();
    end);

    -- Export button
    BLAuras_button_Export:SetScript("OnClick", function()
        auras_PopUpTitle:SetText("Export blacklisted auras");
        auras_PopUpNote:SetText("Enter spell IDs separated by commas");
        auras_PopUp_input:SetText("");
        auras_PopUp.Button:SetText("Select all");
        auras_PopUp.Button:Show();

        local export;

        for k,v in pairs(Config.AurasBlacklist) do
            if k then
                if not export then
                    export = tostring(k);
                else
                    export = export .. ", " .. k;
                end
            end
        end

        if export then
            auras_PopUp_input:SetText(export);

            auras_PopUp.Button:SetScript("OnClick", function()
                if export then
                    auras_PopUp_input:HighlightText();
                    auras_PopUp_input:SetFocus();
                end
            end);

            auras_PopUp:Show();
            auras_PopUp_input:HighlightText();
            auras_PopUp_input:SetFocus();
        end
    end);

    -- Remove all button
    BLAuras_button_RemoveAll:SetScript("OnClick", function()
        StaticPopup_Show("ConfirmBlacklisted");
    end);

    -- Update
    func:UpdateAurasList(auras_BLAurasScrollFrame, auras_BLAurasScrollChild, "AurasBlacklist");

    -- Reset all settings
    StaticPopupDialogs["ResetAllSettings"] = {
        text = "Reset all settings?",
        button1 = "Reset",
        button2 = "Cancel",
        OnAccept = function()
            for k,v in pairs(default) do
                Config[k] = v;
            end

            general_CheckButton_PersonalNameplate:SetChecked(Config.PersonalNameplate);
            general_CheckButton_Powerbar:SetChecked(Config.Powerbar);
            general_CheckButton_Portrait:SetChecked(Config.Portrait);
            general_CheckButton_ClassIconsEnemy:SetChecked(Config.ClassIconsEnemy);
            general_CheckButton_ClassIconsFriendly:SetChecked(Config.ClassIconsFriendly);
            general_CheckButton_GuildName:SetChecked(Config.ShowGuildName);
            general_CheckButton_Classification:SetChecked(Config.Classification);
            general_CheckButton_HealthBarClassColorsEnemy:SetChecked(Config.HealthBarClassColorsEnemy);
            general_CheckButton_HealthBarClassColorsFriendly:SetChecked(Config.HealthBarClassColorsFriendly);
            general_Slider_NameplatesScale:SetValue(Config.NameplatesScale);
            general_Slider_PersonalNameplatesScale:SetValue(Config.PersonalNameplatesScale);
            HealthPower_CheckButton_NumericValue:SetChecked(Config.NumericValue);
            HealthPower_CheckButton_Percentage:SetChecked(Config.Percentage);
            HealthPower_CheckButton_PercentageAsMainValue:SetChecked(Config.PercentageAsMainValue);
            HealthPower_CheckButton_TotalHealth:SetChecked(Config.PersonalNameplateTotalHealth);
            HealthPower_CheckButton_TotalPower:SetChecked(Config.PersonalNameplateTotalPower);
            HealthPower_CheckButton_LargeMainValue:SetChecked(Config.LargeMainValue);
            health_ColorPicker_FontColorButtonTexture:SetVertexColor(Config.HealthFontColor.r, Config.HealthFontColor.g, Config.HealthFontColor.b, Config.HealthFontColor.a);
            reColorFrames(Config.HealthFontColor.r, Config.HealthFontColor.g, Config.HealthFontColor.b, Config.HealthFontColor.a);
            threat_CheckButton_ThreatPercentage:SetChecked(Config.ThreatPercentage);
            threat_Slider_ThreatWarningThreshold:SetValue(Config.ThreatWarningThreshold);
            auras_DropdownMenu_AurasVisibility:SetValue(Config.AurasShow);
            auras_CheckButton_AurasCountdown:SetChecked(Config.AurasCountdown);
            auras_CheckButton_AurasReverseAnimation:SetChecked(Config.AurasReverseAnimation);
            auras_Slider_AurasScale:SetValue(Config.AurasScale);
            auras_CheckButton_BuffsFriendly:SetChecked(Config.BuffsFriendly);
            auras_Slider_MaxBuffsFriendly:SetValue(Config.AurasMaxBuffsFriendly);
            auras_CheckButton_DebuffsFriendly:SetChecked(Config.DebuffsFriendly);
            auras_Slider_MaxDebuffsFriendly:SetValue(Config.AurasMaxDebuffsFriendly);
            auras_CheckButton_BuffsEnemy:SetChecked(Config.BuffsEnemy);
            auras_Slider_MaxBuffsEnemy:SetValue(Config.AurasMaxBuffsEnemy);
            auras_CheckButton_DebuffsEnemy:SetChecked(Config.DebuffsEnemy);
            auras_Slider_MaxDebuffsEnemy:SetValue(Config.AurasMaxDebuffsEnemy);

            updateNameplateScale();
            func:Update();
            func:PersonalNameplate();
        end,
        timeout = 0,
        whileDead = true,
        hideOnEscape = true,
    };

    general_button_resetSettings:SetScript("OnClick", function()
        StaticPopup_Show("ResetAllSettings");
    end);

    -- Add the panel to the Interface Options
    InterfaceOptions_AddCategory(panel_main);
    InterfaceOptions_AddCategory(panel_auras);
end