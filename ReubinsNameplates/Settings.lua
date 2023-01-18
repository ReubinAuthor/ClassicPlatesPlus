----------------------------------------
-- CORE
----------------------------------------
local myAddon, core = ...;
local func = core.func;
local data = core.data;

----------------------------------------
-- Loading settings
----------------------------------------
function func:Load_Settings()
    ----------------------------------------
    -- First time launch settings
    ----------------------------------------

    -- Prepping settings table
    ReubinsNameplates_settings = ReubinsNameplates_settings or {};

    -----> General <-----

    -- powerbar
    if ReubinsNameplates_settings.Powerbar == nil then ReubinsNameplates_settings.Powerbar = true;
    else ReubinsNameplates_settings.Powerbar = ReubinsNameplates_settings.Powerbar; end

    -- portrait
    if ReubinsNameplates_settings.Portrait == nil then ReubinsNameplates_settings.Portrait = true;
    else ReubinsNameplates_settings.Portrait = ReubinsNameplates_settings.Portrait; end

    -- Enemy class icon
    if ReubinsNameplates_settings.EnemyClassIcons == nil then ReubinsNameplates_settings.EnemyClassIcons = true;
    else ReubinsNameplates_settings.EnemyClassIcons = ReubinsNameplates_settings.EnemyClassIcons; end

    -- Friendly class icon
    if ReubinsNameplates_settings.FriendlyClassIcons == nil then ReubinsNameplates_settings.FriendlyClassIcons = false;
    else ReubinsNameplates_settings.FriendlyClassIcons = ReubinsNameplates_settings.FriendlyClassIcons; end

    -- Classification
    if ReubinsNameplates_settings.Classification == nil then ReubinsNameplates_settings.Classification = true;
    else ReubinsNameplates_settings.Classification = ReubinsNameplates_settings.Classification; end

    -- Enemy players' healthbar class color
    if ReubinsNameplates_settings.EnemyHealthBarClassColors == nil then ReubinsNameplates_settings.EnemyHealthBarClassColors = true;
    else ReubinsNameplates_settings.EnemyHealthBarClassColors = ReubinsNameplates_settings.EnemyHealthBarClassColors; end

    -- Friendly players' healthbar class color
    if ReubinsNameplates_settings.FriendlyHealthBarClassColors == nil then ReubinsNameplates_settings.FriendlyHealthBarClassColors = false;
    else ReubinsNameplates_settings.FriendlyHealthBarClassColors = ReubinsNameplates_settings.FriendlyHealthBarClassColors; end

    -- Health numbers
    if ReubinsNameplates_settings.HealthNumber == nil then ReubinsNameplates_settings.HealthNumber = true;
    else ReubinsNameplates_settings.HealthNumber = ReubinsNameplates_settings.HealthNumber; end

    -- Health percentage
    if ReubinsNameplates_settings.HealthPercentage == nil then ReubinsNameplates_settings.HealthPercentage = true;
    else ReubinsNameplates_settings.HealthPercentage = ReubinsNameplates_settings.HealthPercentage; end

    -- Switch places with health numbers
    if ReubinsNameplates_settings.HealthPercentageSwitchPlaces == nil then ReubinsNameplates_settings.HealthPercentageSwitchPlaces = false;
    else ReubinsNameplates_settings.HealthPercentageSwitchPlaces = ReubinsNameplates_settings.HealthPercentageSwitchPlaces; end

    -- Health font color
    ReubinsNameplates_settings.HealthFontColor = ReubinsNameplates_settings.HealthFontColor or { r = 1, g = 0.82, b = 0, a = 1 };

    -- Center health font size
    if ReubinsNameplates_settings.CenterHealthFontSize == nil then ReubinsNameplates_settings.CenterHealthFontSize = 16;
    else ReubinsNameplates_settings.CenterHealthFontSize = ReubinsNameplates_settings.CenterHealthFontSize; end

    -- Nameplates scale
    if ReubinsNameplates_settings.NameplatesScale == nil then ReubinsNameplates_settings.NameplatesScale = 1;
    else ReubinsNameplates_settings.NameplatesScale = ReubinsNameplates_settings.NameplatesScale; end

    -----> Threat <-----

    -- Tank Mode
    if ReubinsNameplates_settings.TankMode == nil then ReubinsNameplates_settings.TankMode = false;
    else ReubinsNameplates_settings.TankMode = ReubinsNameplates_settings.TankMode; end

    -- Threat percentage
    if ReubinsNameplates_settings.ThreatPercentage == nil then ReubinsNameplates_settings.ThreatPercentage = true;
    else ReubinsNameplates_settings.ThreatPercentage = ReubinsNameplates_settings.ThreatPercentage; end

    -- Show icon
    ReubinsNameplates_settings.ThreatIcon = ReubinsNameplates_settings.ThreatIcon or "Always";

    -----> Auras <-----

    -- Buffs
    if ReubinsNameplates_settings.AurasBuffs == nil then ReubinsNameplates_settings.AurasBuffs = true;
    else ReubinsNameplates_settings.AurasBuffs = ReubinsNameplates_settings.AurasBuffs; end

    -- Debuffs
    if ReubinsNameplates_settings.AurasDebuffs == nil then ReubinsNameplates_settings.AurasDebuffs = true;
    else ReubinsNameplates_settings.AurasDebuffs = ReubinsNameplates_settings.AurasDebuffs; end

    -- Countdown
    if ReubinsNameplates_settings.AurasCountdown == nil then ReubinsNameplates_settings.AurasCountdown = false;
    else ReubinsNameplates_settings.AurasCountdown = ReubinsNameplates_settings.AurasCountdown; end

    -- Reverse cooldown animation
    if ReubinsNameplates_settings.AurasReverseAnimation == nil then ReubinsNameplates_settings.AurasReverseAnimation = false;
    else ReubinsNameplates_settings.AurasReverseAnimation = ReubinsNameplates_settings.AurasReverseAnimation; end

    -- Auras scale
    if ReubinsNameplates_settings.AurasScale == nil then ReubinsNameplates_settings.AurasScale = 1;
    else ReubinsNameplates_settings.AurasScale = ReubinsNameplates_settings.AurasScale; end

    -- Blacklisted auras
    ReubinsNameplates_settings.AurasBlacklist = ReubinsNameplates_settings.AurasBlacklist or {};

    ----------------------------------------
    -- Settings interface
    ----------------------------------------
    -- Create a frame to use as the panel
    local panel = CreateFrame("frame", myAddon .. "Settings");
    
    panel.icon = panel:CreateTexture();
    panel.icon:SetTexture("Interface\\addons\\ReubinsNameplates\\media\\icons\\ReubinsNameplates_icon");
    panel.icon:SetSize(16, 16);

    panel.name = myAddon;
    
    -- Icon
    icon = panel:CreateTexture();
    icon:SetPoint("topLeft", 16, -16);
    icon:SetTexture("Interface\\addons\\ReubinsNameplates\\media\\icons\\ReubinsNameplates_icon");
    icon:SetSize(20, 20);

    -- Title
    local title = panel:CreateFontString(myAddon .. "Settings_title", "overlay", "GameFontNormalLarge");
    title:SetPoint("left", icon, "right", 6, 0);
    title:SetText("Reubin's Nameplates");

    -----> General <-----

    -- SubTitle: General
    local SubTitle_General = panel:CreateFontString(myAddon .. "SubTitle_General", "overlay", "GameFontNormal");
    SubTitle_General:SetPoint("topLeft", icon, "bottomLeft", 0, -16);
    SubTitle_General:SetText("General");

    -- CheckButton: Powerbar
    local CheckButton_Powerbar = CreateFrame("CheckButton", myAddon .. "CheckButton_Powerbar", panel, "InterfaceOptionsCheckButtonTemplate");
    CheckButton_Powerbar:SetPoint("topLeft", myAddon .. "SubTitle_General", "bottomLeft", 0, -4);
    CheckButton_Powerbar.Text:SetText("Power bar");
    CheckButton_Powerbar:SetChecked(ReubinsNameplates_settings.Powerbar);

    -- CheckButton: Portrait
    local CheckButton_Portrait = CreateFrame("CheckButton", myAddon .. "CheckButton_Portrait", panel, "InterfaceOptionsCheckButtonTemplate");
    CheckButton_Portrait:SetPoint("topLeft", myAddon .. "CheckButton_Powerbar", "bottomLeft");
    CheckButton_Portrait.Text:SetText("Portrait");
    CheckButton_Portrait:SetChecked(ReubinsNameplates_settings.Portrait);

    -- CheckButton: Enemy players' class icon
    local CheckButton_EnemyClassIcons = CreateFrame("CheckButton", myAddon .. "CheckButton_EnemyClassIcons", panel, "InterfaceOptionsCheckButtonTemplate");
    CheckButton_EnemyClassIcons:SetPoint("topLeft", myAddon .. "CheckButton_Portrait", "bottomLeft", 18, 0);
    CheckButton_EnemyClassIcons:SetScale(0.85);
    CheckButton_EnemyClassIcons.Text:SetText("Enemy players' class icons");
    CheckButton_EnemyClassIcons:SetChecked(ReubinsNameplates_settings.EnemyClassIcons);
    CheckButton_EnemyClassIcons:SetEnabled(ReubinsNameplates_settings.Portrait);
    if CheckButton_EnemyClassIcons:IsEnabled() then
        CheckButton_EnemyClassIcons.Text:SetTextColor(1,1,1);
    else
        CheckButton_EnemyClassIcons.Text:SetTextColor(0.5, 0.5, 0.5);
    end

    -- CheckButton: Friendly players' class icon
    local CheckButton_FriendlyClassIcons = CreateFrame("CheckButton", myAddon .. "CheckButton_FriendlyClassIcons", panel, "InterfaceOptionsCheckButtonTemplate");
    CheckButton_FriendlyClassIcons:SetPoint("topLeft", myAddon .. "CheckButton_EnemyClassIcons", "bottomLeft");
    CheckButton_FriendlyClassIcons:SetScale(0.85);
    CheckButton_FriendlyClassIcons.Text:SetText("Friendly players' class icons");
    CheckButton_FriendlyClassIcons:SetChecked(ReubinsNameplates_settings.FriendlyClassIcons);
    CheckButton_FriendlyClassIcons:SetEnabled(ReubinsNameplates_settings.Portrait);
    if CheckButton_FriendlyClassIcons:IsEnabled() then
        CheckButton_FriendlyClassIcons.Text:SetTextColor(1,1,1);
    else
        CheckButton_FriendlyClassIcons.Text:SetTextColor(0.5, 0.5, 0.5);
    end

    -- Portrait check button OnClick script
    CheckButton_Portrait:SetScript("OnClick", function()
        CheckButton_EnemyClassIcons:SetEnabled(CheckButton_Portrait:GetChecked());
        CheckButton_FriendlyClassIcons:SetEnabled(CheckButton_Portrait:GetChecked());
        if CheckButton_EnemyClassIcons:IsEnabled() then
            CheckButton_EnemyClassIcons.Text:SetTextColor(1,1,1);
        else
            CheckButton_EnemyClassIcons.Text:SetTextColor(0.5, 0.5, 0.5);
        end
        if CheckButton_FriendlyClassIcons:IsEnabled() then
            CheckButton_FriendlyClassIcons.Text:SetTextColor(1,1,1);
        else
            CheckButton_FriendlyClassIcons.Text:SetTextColor(0.5, 0.5, 0.5);
        end
    end);

    -- CheckButton: Classification
    local CheckButton_Classification = CreateFrame("CheckButton", myAddon .. "CheckButton_Classification", panel, "InterfaceOptionsCheckButtonTemplate");
    CheckButton_Classification:SetPoint("topLeft", myAddon .. "CheckButton_Portrait", "bottomLeft", 0, -46);
    CheckButton_Classification.Text:SetText("NPC's Classification");
    CheckButton_Classification:SetChecked(ReubinsNameplates_settings.Classification);

    -- CheckButton: Enemy players' healthbar class color
    local CheckButton_EnemyHealthBarClassColors = CreateFrame("CheckButton", myAddon .. "CheckButton_EnemyHealthBarClassColors", panel, "InterfaceOptionsCheckButtonTemplate");
    CheckButton_EnemyHealthBarClassColors:SetPoint("topLeft", myAddon .. "CheckButton_Classification", "bottomLeft");
    CheckButton_EnemyHealthBarClassColors.Text:SetText("Enemy players' health bar class colors");
    CheckButton_EnemyHealthBarClassColors:SetChecked(ReubinsNameplates_settings.EnemyHealthBarClassColors);

    -- CheckButton: Friendly players' healthbar class color
    local CheckButton_FriendlyHealthBarClassColors = CreateFrame("CheckButton", myAddon .. "CheckButton_FriendlyHealthBarClassColors", panel, "InterfaceOptionsCheckButtonTemplate");
    CheckButton_FriendlyHealthBarClassColors:SetPoint("topLeft", myAddon .. "CheckButton_EnemyHealthBarClassColors", "bottomLeft");
    CheckButton_FriendlyHealthBarClassColors.Text:SetText("Friendly players' health bar class colors");
    CheckButton_FriendlyHealthBarClassColors:SetChecked(ReubinsNameplates_settings.FriendlyHealthBarClassColors);

    -- CheckButton: Health number
    local CheckButton_HealthNumber = CreateFrame("CheckButton", myAddon .. "CheckButton_HealthNumber", panel, "InterfaceOptionsCheckButtonTemplate");
    CheckButton_HealthNumber:SetPoint("topLeft", myAddon .. "CheckButton_FriendlyHealthBarClassColors", "bottomLeft");
    CheckButton_HealthNumber.Text:SetText("Health number");
    CheckButton_HealthNumber:SetChecked(ReubinsNameplates_settings.HealthNumber);

    -- CheckButton: Health percentage
    local CheckButton_HealthPercentage = CreateFrame("CheckButton", myAddon .. "CheckButton_HealthPercentage", panel, "InterfaceOptionsCheckButtonTemplate");
    CheckButton_HealthPercentage:SetPoint("topLeft", myAddon .. "CheckButton_HealthNumber", "bottomLeft");
    CheckButton_HealthPercentage.Text:SetText("Health percentage");
    CheckButton_HealthPercentage:SetChecked(ReubinsNameplates_settings.HealthPercentage);

    -- CheckButton: Swtich places with health numbers
    local CheckButton_HealthPercentageSwitchPlaces = CreateFrame("CheckButton", myAddon .. "CheckButton_HealthPercentageSwitchPlaces", panel, "InterfaceOptionsCheckButtonTemplate");
    CheckButton_HealthPercentageSwitchPlaces:SetPoint("topLeft", myAddon .. "CheckButton_HealthPercentage", "bottomLeft", 18, 0);
    CheckButton_HealthPercentageSwitchPlaces:SetScale(0.85);
    CheckButton_HealthPercentageSwitchPlaces.Text:SetText("Swap health number and percentage locations");
    CheckButton_HealthPercentageSwitchPlaces:SetChecked(ReubinsNameplates_settings.HealthPercentageSwitchPlaces);
    CheckButton_HealthPercentageSwitchPlaces:SetEnabled(ReubinsNameplates_settings.HealthPercentage and ReubinsNameplates_settings.HealthNumber);
    if CheckButton_HealthPercentageSwitchPlaces:IsEnabled() then
        CheckButton_HealthPercentageSwitchPlaces.Text:SetTextColor(1,1,1);
    else
        CheckButton_HealthPercentageSwitchPlaces.Text:SetTextColor(0.5, 0.5, 0.5);
    end

    -- CheckButton: Switch health number and health percentage locations check button OnClick script
    CheckButton_HealthPercentage:SetScript("OnClick", function()
        CheckButton_HealthPercentageSwitchPlaces:SetEnabled(CheckButton_HealthPercentage:GetChecked() and CheckButton_HealthNumber:GetChecked());
        if CheckButton_HealthPercentageSwitchPlaces:IsEnabled() then
            CheckButton_HealthPercentageSwitchPlaces.Text:SetTextColor(1,1,1);
        else
            CheckButton_HealthPercentageSwitchPlaces.Text:SetTextColor(0.5, 0.5, 0.5);
        end
    end);

    CheckButton_HealthNumber:SetScript("OnClick", function()
        CheckButton_HealthPercentageSwitchPlaces:SetEnabled(CheckButton_HealthPercentage:GetChecked() and CheckButton_HealthNumber:GetChecked());
        if CheckButton_HealthPercentageSwitchPlaces:IsEnabled() then
            CheckButton_HealthPercentageSwitchPlaces.Text:SetTextColor(1,1,1);
        else
            CheckButton_HealthPercentageSwitchPlaces.Text:SetTextColor(0.5, 0.5, 0.5);
        end
    end);

    -- SubTitle: Font color
    local ColorPicker_FontColor = panel:CreateFontString(myAddon .. "ColorPicker_FontColor", "overlay", "GameFontHighlight");
    ColorPicker_FontColor:SetPoint("topLeft", myAddon.."CheckButton_HealthPercentageSwitchPlaces", "bottomLeft", -14, -12);
    ColorPicker_FontColor:SetText("Health font color:");

    local backdropInfo = {
        bgFile = "Interface\\Buttons\\WHITE8x8",
        edgeFile = "Interface\\Buttons\\WHITE8x8",
        tile = true,
        tileEdge = true,
        tileSize =1,
        edgeSize = 1,
        insets = { left = 1, right = 1, top = 1, bottom = 1 }
    }

    local ColorPicker_FontColorButton = CreateFrame("button", myAddon .. "ColorPicker_FontColorButton", panel, "BackdropTemplate");
    ColorPicker_FontColorButton:SetPoint("left", myAddon.."ColorPicker_FontColor", "right", 8, 0);
    ColorPicker_FontColorButton:SetSize(16, 16);
    ColorPicker_FontColorButton:SetBackdrop(backdropInfo);
    ColorPicker_FontColorButton:SetBackdropBorderColor(1,1,1);

    ColorPicker_FontColorButton:SetScript("OnEnter", function()
        ColorPicker_FontColorButton:SetBackdropBorderColor(1, 0.82, 0);
    end);

    ColorPicker_FontColorButton:SetScript("OnLeave", function()
        ColorPicker_FontColorButton:SetBackdropBorderColor(1, 1, 1);
    end);

    ColorPicker_FontColorButtonTexture = panel:CreateTexture();
    ColorPicker_FontColorButtonTexture:SetParent(ColorPicker_FontColorButton);
    ColorPicker_FontColorButtonTexture:SetPoint("center", ColorPicker_FontColorButton, "center");
    ColorPicker_FontColorButtonTexture:SetSize(14, 14);
    ColorPicker_FontColorButtonTexture:SetColorTexture(1,1,1);
    ColorPicker_FontColorButtonTexture:SetVertexColor(
        ReubinsNameplates_settings.HealthFontColor.r,
        ReubinsNameplates_settings.HealthFontColor.g,
        ReubinsNameplates_settings.HealthFontColor.b,
        ReubinsNameplates_settings.HealthFontColor.a
    );

    local function showColorPicker(r,g,b,a,callback)
        --ColorPickerFrame:SetColorRGB(r,g,b);
        ColorPickerFrame.hasOpacity, ColorPickerFrame.opacity = (a ~= nil), a;
        ColorPickerFrame.previousValues = {r,g,b,a};
        ColorPickerFrame.func, ColorPickerFrame.opacityFunc, ColorPickerFrame.cancelFunc = callback, callback, callback;
        ColorPickerFrame:Hide();
        ColorPickerFrame:Show();
    end

    ColorPicker_FontColorButton.recolorTexture = function(color)
        local r,g,b,a;

        if color then
            r,g,b,a = unpack(color);
        else
            r,g,b = ColorPickerFrame:GetColorRGB();
            a = OpacitySliderFrame:GetValue();
        end
        ColorPicker_FontColorButtonTexture:SetVertexColor( r,g,b,a );
    end

    ColorPicker_FontColorButton:EnableMouse(true);
    ColorPicker_FontColorButton:SetScript("OnMouseDown", function(self, button, ...)
        if button == "LeftButton" then
            local r,g,b,a = ColorPicker_FontColorButtonTexture:GetVertexColor();
            showColorPicker(r,g,b,a,self.recolorTexture);
        end
    end);

    -- Slider: Center health font size
    local Slider_CenterHealthFontSize = CreateFrame("Slider", myAddon .. "Slider_CenterHealthFontSize", panel, "OptionsSliderTemplate");
    Slider_CenterHealthFontSize:SetPoint("topLeft", myAddon .. "ColorPicker_FontColor", "bottomLeft", 2, -36);
    Slider_CenterHealthFontSize:SetOrientation("HORIZONTAL");
    Slider_CenterHealthFontSize:SetWidth(130);
    Slider_CenterHealthFontSize:SetHeight(18);
    Slider_CenterHealthFontSize:SetMinMaxValues(10, 16);
    Slider_CenterHealthFontSize:SetValueStep(1);
    Slider_CenterHealthFontSize:SetObeyStepOnDrag(true);
    Slider_CenterHealthFontSize:SetValue(ReubinsNameplates_settings.CenterHealthFontSize);
    _G[Slider_CenterHealthFontSize:GetName() .. "Low"]:SetText("");
    _G[Slider_CenterHealthFontSize:GetName() .. "High"]:SetText("");
    Slider_CenterHealthFontSize.Text:SetText("|cffffe800Center health font size");
    Slider_CenterHealthFontSize.TextValue = panel:CreateFontString(nil, "overlay", "GameFontHighlightSmall");
    Slider_CenterHealthFontSize.TextValue:SetPoint("top", myAddon .. "Slider_CenterHealthFontSize", "bottom");
    Slider_CenterHealthFontSize.TextValue:SetText(Slider_CenterHealthFontSize:GetValue());
    Slider_CenterHealthFontSize:SetScript("OnValueChanged", function()
        Slider_CenterHealthFontSize.TextValue:SetText(Slider_CenterHealthFontSize:GetValue());
    end);

    -- Slider: Nameplate scale
    local Slider_NameplatesScale = CreateFrame("Slider", myAddon .. "Slider_NameplatesScale", panel, "OptionsSliderTemplate");
    Slider_NameplatesScale:SetPoint("left", myAddon .. "Slider_CenterHealthFontSize", "right", 20, -0);
    Slider_NameplatesScale:SetOrientation("HORIZONTAL");
    Slider_NameplatesScale:SetWidth(130);
    Slider_NameplatesScale:SetHeight(18);
    Slider_NameplatesScale:SetMinMaxValues(0.75, 1.25);
    Slider_NameplatesScale:SetValueStep(0.01);
    Slider_NameplatesScale:SetObeyStepOnDrag(true);
    Slider_NameplatesScale:SetValue(ReubinsNameplates_settings.NameplatesScale);
    _G[Slider_NameplatesScale:GetName() .. "Low"]:SetText("");
    _G[Slider_NameplatesScale:GetName() .. "High"]:SetText("");
    Slider_NameplatesScale.Text:SetText("|cffffe800Nameplates scale");
    Slider_NameplatesScale.TextValue = panel:CreateFontString(nil, "overlay", "GameFontHighlightSmall");
    Slider_NameplatesScale.TextValue:SetPoint("top", myAddon .. "Slider_NameplatesScale", "bottom");
    Slider_NameplatesScale.TextValue:SetText(string.format("%.2f", Slider_NameplatesScale:GetValue()));
    Slider_NameplatesScale:SetScript("OnValueChanged", function()
        Slider_NameplatesScale.TextValue:SetText(string.format("%.2f", Slider_NameplatesScale:GetValue()));
    end);

    -----> Threat <-----

    -- SubTitle: Threat
    local SubTitle_Threat = panel:CreateFontString(myAddon .. "SubTitle_Threat", "overlay", "GameFontNormal");
    SubTitle_Threat:SetPoint("topLeft", myAddon .. "Slider_CenterHealthFontSize", "bottomLeft", -4, -28);
    SubTitle_Threat:SetText("Threat");

    -- Tank mode
    local CheckButton_TankMode = CreateFrame("CheckButton", myAddon .. "CheckButton_TankMode", panel, "InterfaceOptionsCheckButtonTemplate");
    CheckButton_TankMode:SetPoint("topLeft", myAddon .. "SubTitle_Threat", "bottomLeft", 0, -4);
    CheckButton_TankMode.Text:SetText("Tank mode");
    CheckButton_TankMode:SetChecked(ReubinsNameplates_settings.TankMode);
    data.TankModeCheckButton = CheckButton_TankMode;

    -- CheckButton: Tank mode note
    local Note_TankMode = panel:CreateFontString(myAddon .. "Note_TankMode", "overlay", "GameFontHighlightSmall");
    Note_TankMode:SetPoint("topLeft", myAddon .. "CheckButton_TankMode", "bottomLeft", 28, 4);
    Note_TankMode:SetText("Command: /rplates tank");
    Note_TankMode:SetAlpha(0.66);

    -- CheckButton: Threat percentage
    local CheckButton_ThreatPercentage = CreateFrame("CheckButton", myAddon .. "CheckButton_ThreatPercentage", panel, "InterfaceOptionsCheckButtonTemplate");
    CheckButton_ThreatPercentage:SetPoint("topLeft", myAddon .. "CheckButton_TankMode", "bottomLeft", 0, -12);
    CheckButton_ThreatPercentage.Text:SetText("Percentage");
    CheckButton_ThreatPercentage:SetChecked(ReubinsNameplates_settings.ThreatPercentage);

    -- DropdownMenu: Threat percentage
    local SubTitle_ThreatIcon = panel:CreateFontString(myAddon .. "SubTitle_ThreatIcon", "overlay", "GameFontNormalSmall");
    SubTitle_ThreatIcon:SetPoint("topLeft", myAddon .. "CheckButton_ThreatPercentage", "bottomLeft", 0, -12);
    SubTitle_ThreatIcon:SetText("Show icon:");

    local Selection_ThreatIcon = ReubinsNameplates_settings.ThreatIcon;
    local DropdownMenu_ThreatIcon = CreateFrame("Frame", myAddon .. "DropdownMenu_ThreatIcon", panel, "UIDropDownMenuTemplate");
    DropdownMenu_ThreatIcon:SetPoint("topLeft", myAddon .. "SubTitle_ThreatIcon", "bottomLeft", -16, -4);
    UIDropDownMenu_SetWidth(DropdownMenu_ThreatIcon, 140);
    UIDropDownMenu_SetText(DropdownMenu_ThreatIcon, Selection_ThreatIcon);
    UIDropDownMenu_Initialize(DropdownMenu_ThreatIcon, function(self)
        local info = UIDropDownMenu_CreateInfo();
        info.func = self.SetValue;
        info.text, info.arg1, info.checked = "Always", "Always", "Always" == Selection_ThreatIcon;
        UIDropDownMenu_AddButton(info);
        info.text, info.arg1, info.checked = "Party & raid", "Party & raid", "Party & raid" == Selection_ThreatIcon;
        UIDropDownMenu_AddButton(info);
        info.text, info.arg1, info.checked = "Never", "Never", "Never" == Selection_ThreatIcon;
        UIDropDownMenu_AddButton(info);
    end);
    function DropdownMenu_ThreatIcon:SetValue(newValue)
        Selection_ThreatIcon = newValue;
        UIDropDownMenu_SetText(DropdownMenu_ThreatIcon, Selection_ThreatIcon);
        CloseDropDownMenus();
    end

    -----> Auras <-----

    -- SubTitle: Auras
    local SubTitle_Auras = panel:CreateFontString(myAddon.."SubTitle_Auras", "overlay", "GameFontNormal");
    SubTitle_Auras:SetPoint("left", myAddon .. "SubTitle_General", "right", 260, 0);
    SubTitle_Auras:SetText("Buffs & Debuffs");

    -- CheckButton: Buffs
    local CheckButton_AurasBuffs = CreateFrame("CheckButton", myAddon .. "CheckButton_Buffs", panel, "InterfaceOptionsCheckButtonTemplate");
    CheckButton_AurasBuffs:SetPoint("topLeft", myAddon.."SubTitle_Auras", "bottomLeft", 0, -4);
    CheckButton_AurasBuffs.Text:SetText("Buffs");
    CheckButton_AurasBuffs:SetChecked(ReubinsNameplates_settings.AurasBuffs);

    -- CheckButton: Debuffs
    local CheckButton_AurasDebuffs = CreateFrame("CheckButton", myAddon .. "CheckButton_Debuffs", panel, "InterfaceOptionsCheckButtonTemplate");
    CheckButton_AurasDebuffs:SetPoint("topLeft", myAddon .. "CheckButton_Buffs", "bottomLeft");
    CheckButton_AurasDebuffs.Text:SetText("Debuffs");
    CheckButton_AurasDebuffs:SetChecked(ReubinsNameplates_settings.AurasDebuffs);

    -- CheckButton: Countdown
    local CheckButton_AurasCountdown = CreateFrame("CheckButton", myAddon .. "CheckButton_AurasCountdown", panel, "InterfaceOptionsCheckButtonTemplate");
    CheckButton_AurasCountdown:SetPoint("topLeft", myAddon .. "CheckButton_Debuffs", "bottomLeft");
    CheckButton_AurasCountdown.Text:SetText("Countdown");
    CheckButton_AurasCountdown:SetChecked(ReubinsNameplates_settings.AurasCountdown);

    -- CheckButton: Reverse auras cooldown animation
    local CheckButton_AurasReverseAnimation = CreateFrame("CheckButton", myAddon .. "CheckButton_AurasReverseAnimation", panel, "InterfaceOptionsCheckButtonTemplate");
    CheckButton_AurasReverseAnimation:SetPoint("topLeft", myAddon .. "CheckButton_AurasCountdown", "bottomLeft");
    CheckButton_AurasReverseAnimation.Text:SetText("Reverse cooldown animation");
    CheckButton_AurasReverseAnimation:SetChecked(ReubinsNameplates_settings.AurasReverseAnimation);

    -- Color picker
    local ColorPickerFrame = CreateFrame("ColorSelect", myAddon .. "ColorPickerFrame", panel, "BackdropTemplate")
    ColorPickerFrame:SetPoint("topLeft", myAddon .. "CheckButton_AurasReverseAnimation", "bottomLeft");

    -- Auras scale, slider
    local Slider_AurasScale = CreateFrame("Slider", myAddon .. "Slider_AurasScale", panel, "OptionsSliderTemplate");
    Slider_AurasScale:SetPoint("topLeft", myAddon .. "CheckButton_AurasReverseAnimation", "bottomLeft", 8, -28);
    Slider_AurasScale:SetOrientation("HORIZONTAL");
    Slider_AurasScale:SetWidth(130);
    Slider_AurasScale:SetHeight(18);
    Slider_AurasScale:SetMinMaxValues(0.75, 1.25);
    Slider_AurasScale:SetValueStep(0.01);
    Slider_AurasScale:SetObeyStepOnDrag(true);
    Slider_AurasScale:SetValue(ReubinsNameplates_settings.AurasScale);
    _G[Slider_AurasScale:GetName() .. "Low"]:SetText("");
    _G[Slider_AurasScale:GetName() .. "High"]:SetText("");
    Slider_AurasScale.Text:SetText("|cffffe800Auras scale");
    Slider_AurasScale.TextValue = panel:CreateFontString(nil, "overlay", "GameFontHighlightSmall");
    Slider_AurasScale.TextValue:SetPoint("top", myAddon .. "Slider_AurasScale", "bottom");
    Slider_AurasScale.TextValue:SetText(string.format("%.2f", Slider_AurasScale:GetValue()));
    Slider_AurasScale:SetScript("OnValueChanged", function()
        Slider_AurasScale.TextValue:SetText(string.format("%.2f", Slider_AurasScale:GetValue()));
    end);

    -- Blacklisted auras
    BLAurasTitle = panel:CreateFontString(nil, "overlay", "GameFontNormal");
    BLAurasTitle:SetPoint("topLeft", myAddon .. "Slider_AurasScale", "bottomLeft", -8, -36);
    BLAurasTitle:SetText("Blacklisted auras");

    local BLAuras = CreateFrame("Frame", nil, panel, "OptionsBoxTemplate");
    BLAuras:SetPoint("topLeft", BLAurasTitle, "bottomLeft", 0, -8)
    BLAuras:SetSize(280, 280);

    BLAurasTextureBackground = BLAuras:CreateTexture();
    BLAurasTextureBackground:SetParent(BLAuras);
    BLAurasTextureBackground:SetPoint("topLeft", 4, -4);
    BLAurasTextureBackground:SetPoint("bottomRight", -4, 4);
    BLAurasTextureBackground:SetDrawLayer("background");
    BLAurasTextureBackground:SetColorTexture(0.07, 0.07, 0.07, 0.7);

    local BLAurasScrollFrame = CreateFrame("ScrollFrame", nil, BLAuras, "UIPanelScrollFrameTemplate2");
    BLAurasScrollFrame:SetPoint("topLeft", 4, -6);
    BLAurasScrollFrame:SetPoint("bottomRight", -30, 6);

    BLAurasScrollFrameBG = BLAuras:CreateTexture();
    BLAurasScrollFrameBG:SetParent(BLAurasScrollFrame);
    BLAurasScrollFrameBG:SetPoint("right", BLAurasScrollFrame, "right", 24, 0);
    BLAurasScrollFrameBG:SetSize(20, 260);
    BLAurasScrollFrameBG:SetDrawLayer("background");
    BLAurasScrollFrameBG:SetColorTexture(0,0,0,0.66);

    local BLAurasScrollChild = CreateFrame("Frame");
    BLAurasScrollFrame:SetScrollChild(BLAurasScrollChild);
    BLAurasScrollChild:SetWidth(BLAuras:GetWidth()-18);
    BLAurasScrollChild:SetHeight(1);

    BLAurasScrollChild.auras = {};

    -- List of auras to delete from our blacklist on OK button click.
    data.removeFromBlacklist = {};

    -- Blacklisted auras' list
    data.BLAurasScrollChild = BLAurasScrollChild;
    data.BLAurasScrollFrame = BLAurasScrollFrame;

    func:BlacklistedAuras();

    ----------------------------------------
    -- Pressing "Ok" button
    ----------------------------------------
    panel.okay = function()

        -----> General <-----

        -- Powerbar
        ReubinsNameplates_settings.Powerbar = CheckButton_Powerbar:GetChecked();

        -- Portrait 
        ReubinsNameplates_settings.Portrait = CheckButton_Portrait:GetChecked();

        -- Classification 
        ReubinsNameplates_settings.Classification = CheckButton_Classification:GetChecked();

        -- Enemy class icon 
        ReubinsNameplates_settings.EnemyClassIcons = CheckButton_EnemyClassIcons:GetChecked();

        -- Friendly class icon 
        ReubinsNameplates_settings.FriendlyClassIcons = CheckButton_FriendlyClassIcons:GetChecked();

        -- Enemy players' healthbar class color
        ReubinsNameplates_settings.EnemyHealthBarClassColors = CheckButton_EnemyHealthBarClassColors:GetChecked();

        -- Friendly players' healthbar class color
        ReubinsNameplates_settings.FriendlyHealthBarClassColors = CheckButton_FriendlyHealthBarClassColors:GetChecked();

        -- Health numbers
        ReubinsNameplates_settings.HealthNumber = CheckButton_HealthNumber:GetChecked();

        -- Health percentage
        ReubinsNameplates_settings.HealthPercentage = CheckButton_HealthPercentage:GetChecked();

        -- Swtich places with health numbers
        ReubinsNameplates_settings.HealthPercentageSwitchPlaces = CheckButton_HealthPercentageSwitchPlaces:GetChecked();

        -- Health font color
        local hpf_r, hpf_g, hpf_b, hpf_a = ColorPicker_FontColorButtonTexture:GetVertexColor();
        ReubinsNameplates_settings.HealthFontColor = { r = hpf_r, g = hpf_g, b = hpf_b, a = hpf_a };

        -- Center health font size
        ReubinsNameplates_settings.CenterHealthFontSize = Slider_CenterHealthFontSize:GetValue();

        -- Nameplates scale
        ReubinsNameplates_settings.NameplatesScale = Slider_NameplatesScale:GetValue();

        -----> Threat <-----

        -- Tank mode
        ReubinsNameplates_settings.TankMode = CheckButton_TankMode:GetChecked();

        -- Threat percentage
        ReubinsNameplates_settings.ThreatPercentage = CheckButton_ThreatPercentage:GetChecked();

        -- Threat icon
        ReubinsNameplates_settings.ThreatIcon = UIDropDownMenu_GetText(DropdownMenu_ThreatIcon);

        -----> Auras <-----

        -- Buffs
        ReubinsNameplates_settings.AurasBuffs = CheckButton_AurasBuffs:GetChecked();

        -- Debuffs
        ReubinsNameplates_settings.AurasDebuffs = CheckButton_AurasDebuffs:GetChecked();

        -- Countdown
        ReubinsNameplates_settings.AurasCountdown = CheckButton_AurasCountdown:GetChecked();

        -- Reverse cooldown animation
        ReubinsNameplates_settings.AurasReverseAnimation = CheckButton_AurasReverseAnimation:GetChecked();

        -- Auras scale
        ReubinsNameplates_settings.AurasScale = Slider_AurasScale:GetValue();

        -- Blacklisted auras
        if data.removeFromBlacklist then
            for k in pairs(data.removeFromBlacklist) do
                ReubinsNameplates_settings.AurasBlacklist[k] = nil;
            end
        end
        for k,v in pairs(BLAurasScrollChild.auras) do
            if k then
                v:Hide();
            end
        end
        data.removeFromBlacklist = {};
        func:BlacklistedAuras();

        -----> Updating nameplates <-----
        local nameplates = C_NamePlate.GetNamePlates();
        if nameplates then
            for k,v in pairs(nameplates) do
                if k then
                    local unit = v.unitFrame.unit;

                    func:Update_Auras(unit);
                    func:Nameplate_Added(unit);
                end
            end
        end
        func:ResizeNameplates();
    end

    ----------------------------------------
    -- Pressing "Cancel" button
    ----------------------------------------
    panel.cancel = function()

        -----> General <-----

        -- Powerbar
        CheckButton_Powerbar:SetChecked(ReubinsNameplates_settings.Powerbar);

        -- Portrait
        CheckButton_Portrait:SetChecked(ReubinsNameplates_settings.Portrait);

        -- Classification 
        CheckButton_Classification:SetChecked(ReubinsNameplates_settings.Classification);

        -- Enemy class icon 
        CheckButton_EnemyClassIcons:SetChecked(ReubinsNameplates_settings.EnemyClassIcons);

        -- Friendly class icon 
        CheckButton_FriendlyClassIcons:SetChecked(ReubinsNameplates_settings.FriendlyClassIcons);

        -- Enemy players' healthbar class color
        CheckButton_EnemyHealthBarClassColors:SetChecked(ReubinsNameplates_settings.EnemyHealthBarClassColors);

        -- Friendly players' healthbar class color
        CheckButton_FriendlyHealthBarClassColors:SetChecked(ReubinsNameplates_settings.FriendlyHealthBarClassColors);

        -- Health numbers
        CheckButton_HealthNumber:SetChecked(ReubinsNameplates_settings.HealthNumber);

        -- Health percentage
        CheckButton_HealthPercentage:SetChecked(ReubinsNameplates_settings.HealthPercentage);

        -- Swtich places with health numbers
        CheckButton_HealthPercentageSwitchPlaces:SetChecked(ReubinsNameplates_settings.HealthPercentageSwitchPlaces);

        -- Health font color
        ColorPicker_FontColorButtonTexture:SetVertexColor(
            ReubinsNameplates_settings.HealthFontColor.r,
            ReubinsNameplates_settings.HealthFontColor.g,
            ReubinsNameplates_settings.HealthFontColor.b,
            ReubinsNameplates_settings.HealthFontColor.a
        );

        -- Center health font size
        Slider_CenterHealthFontSize:SetValue(ReubinsNameplates_settings.CenterHealthFontSize);

        -- Nameplates scale
        Slider_NameplatesScale:SetValue(ReubinsNameplates_settings.NameplatesScale);

        -----> Threat <-----

        -- Tank mode
        CheckButton_TankMode:SetChecked(ReubinsNameplates_settings.TankMode);

        -- Threat percentage
        CheckButton_ThreatPercentage:SetChecked(ReubinsNameplates_settings.ThreatPercentage);

        -- Threat icon
        UIDropDownMenu_SetText(DropdownMenu_ThreatIcon, ReubinsNameplates_settings.ThreatIcon);
        Selection_ThreatIcon = ReubinsNameplates_settings.ThreatIcon;

        -----> Auras <-----

        -- Buffs
        CheckButton_AurasDebuffs:SetChecked(ReubinsNameplates_settings.AurasBuffs);

        -- Debuffs
        CheckButton_AurasDebuffs:SetChecked(ReubinsNameplates_settings.AurasDebuffs);

        -- Countdown
        CheckButton_AurasCountdown:SetChecked(ReubinsNameplates_settings.AurasCountdown);

        -- Reverse cooldown animation
        CheckButton_AurasReverseAnimation:SetChecked(ReubinsNameplates_settings.AurasReverseAnimation);

        -- Auras scale
        Slider_AurasScale:SetValue(ReubinsNameplates_settings.AurasScale);

        -- Blacklisted auras
        data.removeFromBlacklist = {};
        for k,v in pairs(BLAurasScrollChild.auras) do
            if k then
                v.background:SetColorTexture(1, 0.82, 0, 0.1);
                v.background:Hide();
                v.name:SetTextColor(1, 0.82, 0);
                v.AddRemove:SetNormalTexture("Interface\\Buttons\\UI-MinusButton-Up");
                v.AddRemove:SetPushedTexture("Interface\\Buttons\\UI-MinusButton-Down");
                v.selected = false;
                v.removed = false;
            end
        end
    end

    ----------------------------------------
    -- Pressing "Defaults" button
    ----------------------------------------
    panel.default = function()

        -----> General <-----

        -- Powerbar
        CheckButton_Powerbar:SetChecked(true);

        -- Portrait
        CheckButton_Portrait:SetChecked(true);

        -- Classification
        CheckButton_Classification:SetChecked(true);

        -- Enemy class icon
        CheckButton_EnemyClassIcons:SetChecked(true);

        -- Frienndly class icon
        CheckButton_FriendlyClassIcons:SetChecked(false);

        -- Enemy players' healthbar class color
        CheckButton_EnemyHealthBarClassColors:SetChecked(true);

        -- Friendly players' healthbar class color
        CheckButton_FriendlyHealthBarClassColors:SetChecked(false);

        -- Health numbers
        CheckButton_HealthNumber:SetChecked(true);

        -- Health percentage
        CheckButton_HealthPercentage:SetChecked(true);

        -- Swtich places with health numbers
        CheckButton_HealthPercentageSwitchPlaces:SetChecked(false);

        -- Health font color
        ColorPicker_FontColorButtonTexture:SetVertexColor(1, 0.82, 0, 1)

        -- Center health font size
        Slider_CenterHealthFontSize:SetValue(16);

        -- Nameplates scale
        Slider_NameplatesScale:SetValue(1);

        -----> Threat <-----

        -- Tank mode
        CheckButton_TankMode:SetChecked(false);

        -- Threat percentage
        CheckButton_ThreatPercentage:SetChecked(true);

        -- Threat icon
        UIDropDownMenu_SetText(DropdownMenu_ThreatIcon, "Always");
        Selection_ThreatIcon = UIDropDownMenu_GetText(DropdownMenu_ThreatIcon);

        -----> Auras <-----

        -- Buffs
        CheckButton_AurasDebuffs:SetChecked(true);

        -- Debuffs
        CheckButton_AurasDebuffs:SetChecked(true);

        -- Countdown
        CheckButton_AurasCountdown:SetChecked(false);

        -- Reverse cooldown animation
        CheckButton_AurasReverseAnimation:SetChecked(true);

        -- Auras scale
        Slider_AurasScale:SetValue(1);
    end

    -- Add the panel to the Interface Options
    InterfaceOptions_AddCategory(panel);
end

----------------------------------------
-- Saving settings
----------------------------------------
function func:Save_Settings()
    -- General
    ReubinsNameplates_settings.Powerbar = ReubinsNameplates_settings.Powerbar;
    ReubinsNameplates_settings.Portrait = ReubinsNameplates_settings.Portrait;
    ReubinsNameplates_settings.Classification = ReubinsNameplates_settings.Classification;
    ReubinsNameplates_settings.EnemyClassIcons = ReubinsNameplates_settings.EnemyClassIcons;
    ReubinsNameplates_settings.FriendlyClassIcons = ReubinsNameplates_settings.FriendlyClassIcons;
    ReubinsNameplates_settings.EnemyHealthBarClassColors = ReubinsNameplates_settings.EnemyHealthBarClassColors;
    ReubinsNameplates_settings.FriendlyHealthBarClassColors = ReubinsNameplates_settings.FriendlyHealthBarClassColors;
    ReubinsNameplates_settings.HealthNumber = ReubinsNameplates_settings.HealthNumber;
    ReubinsNameplates_settings.HealthPercentage = ReubinsNameplates_settings.HealthPercentage;
    ReubinsNameplates_settings.HealthPercentageSwitchPlaces = ReubinsNameplates_settings.HealthPercentageSwitchPlaces;
    ReubinsNameplates_settings.HealthFontColor = ReubinsNameplates_settings.HealthFontColor;
    ReubinsNameplates_settings.CenterHealthFontSize = ReubinsNameplates_settings.CenterHealthFontSize;
    ReubinsNameplates_settings.NameplatesScale = ReubinsNameplates_settings.NameplatesScale;

    -- Threat
    ReubinsNameplates_settings.TankMode = ReubinsNameplates_settings.TankMode;
    ReubinsNameplates_settings.ThreatPercentage = ReubinsNameplates_settings.ThreatPercentage;
    ReubinsNameplates_settings.ThreatIcon = ReubinsNameplates_settings.ThreatIcon;

    -- Auras
    ReubinsNameplates_settings.AurasBlacklist = ReubinsNameplates_settings.AurasBlacklist;
    ReubinsNameplates_settings.AurasBuffs = ReubinsNameplates_settings.AurasBuffs;
    ReubinsNameplates_settings.AurasDebuffs = ReubinsNameplates_settings.AurasDebuffs;
    ReubinsNameplates_settings.AurasCountdown = ReubinsNameplates_settings.AurasCountdown;
    ReubinsNameplates_settings.AurasReverseAnimation = ReubinsNameplates_settings.AurasReverseAnimation;
    ReubinsNameplates_settings.AurasScale = ReubinsNameplates_settings.AurasScale;
end