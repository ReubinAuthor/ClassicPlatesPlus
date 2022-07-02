----------------------------------------
-- NAMESPACES
----------------------------------------
local myAddon, core = ...;
local func = core.func;
local frames = core.frames;

----------------------------------------
-- ADDON SETTINGS
----------------------------------------
function func:Load_Settings()

    -- Initial settings
    -- Setting up a table
    if ReubinsNameplates_settings == nil then ReubinsNameplates_settings = {};
    else ReubinsNameplates_settings = ReubinsNameplates_settings; end

    -- Tank mode
    if ReubinsNameplates_settings.Tank == nil then ReubinsNameplates_settings.Tank = false;
    else ReubinsNameplates_settings.Tank = ReubinsNameplates_settings.Tank; end

    -- Show Threat
    if ReubinsNameplates_settings.Threat_Visibility == nil then ReubinsNameplates_settings.Threat_Visibility = "Always";
    else ReubinsNameplates_settings.Threat_Visibility = ReubinsNameplates_settings.Threat_Visibility; end

    -- Show Health
    if ReubinsNameplates_settings.Show_Health == nil then ReubinsNameplates_settings.Show_Health = true;
    else ReubinsNameplates_settings.Show_Health =  ReubinsNameplates_settings.Show_Health; end

    -- Font Size
    if ReubinsNameplates_settings.FontSize == nil then ReubinsNameplates_settings.FontSize = 16;
    else ReubinsNameplates_settings.FontSize = ReubinsNameplates_settings.FontSize; end

    -- Auras visibility
    if ReubinsNameplates_settings.Auras_Visibility == nil then ReubinsNameplates_settings.Auras_Visibility = true;
    else ReubinsNameplates_settings.Auras_Visibility = ReubinsNameplates_settings.Auras_Visibility; end

    -- Aura's countdown
    if ReubinsNameplates_settings.Auras_Countdown == nil then ReubinsNameplates_settings.Auras_Countdown = false;
    else ReubinsNameplates_settings.Auras_Countdown = ReubinsNameplates_settings.Auras_Countdown; end

    -- Aura's scale
    if ReubinsNameplates_settings.Auras_Scale == nil then ReubinsNameplates_settings.Auras_Scale = 1;
    else ReubinsNameplates_settings.Auras_Scale = ReubinsNameplates_settings.Auras_Scale; end

    if ReubinsNameplates_settings.Auras_Cooldown_Reverse == nil then ReubinsNameplates_settings.Auras_Cooldown_Reverse = false;
    else ReubinsNameplates_settings.Auras_Cooldown_Reverse = ReubinsNameplates_settings.Auras_Cooldown_Reverse; end

    -- Create a frame to use as the panel
    local panel = CreateFrame("FRAME", myAddon.."Settings");
    panel.name = "Reubin's Nameplates";
    frames.panel = panel;

    -- Title
    local title = panel:CreateFontString(myAddon.."Settings_title", "OVERLAY", "GameFontNormalLarge");
    title:SetPoint("TOPLEFT", myAddon.."Settings", "TOPLEFT", 16, -16);
    title:SetText("Reubin's Nameplates");

    -- Health, Sub-title
    local subTitle = panel:CreateFontString(myAddon.."Settings_subTitle_Health", "OVERLAY", "GameFontNormal");
    subTitle:SetPoint("TOPLEFT", myAddon.."Settings_title", "BOTTOMLEFT", 0, -16);
    subTitle:SetText("Health");

    -- Show Health, Check button
    local ShowHealthCheck = CreateFrame("CheckButton", myAddon.."Settings_ShowHealth", panel, "InterfaceOptionsCheckButtonTemplate");
    ShowHealthCheck:SetPoint("TOPLEFT", myAddon.."Settings_subTitle_Health", "BOTTOMLEFT", 0, -16);
    ShowHealthCheck.Text:SetText("Show health");
    ShowHealthCheck:SetChecked(ReubinsNameplates_settings.Show_Health);

    -- Font size, slider
    local FontSizeSlider = CreateFrame("Slider", myAddon.."Settings_FontSizeSlider", panel, "OptionsSliderTemplate");
    FontSizeSlider:SetPoint("TOPLEFT", myAddon.."Settings_ShowHealth", "BOTTOMLEFT", 8, -32);
    FontSizeSlider:SetOrientation("HORIZONTAL");
    FontSizeSlider:SetWidth(140);
    FontSizeSlider:SetHeight(18);
    FontSizeSlider:SetMinMaxValues(10, 22);
    FontSizeSlider:SetValueStep(1);
    FontSizeSlider:SetObeyStepOnDrag(true);
    FontSizeSlider:SetValue(ReubinsNameplates_settings.FontSize);
    _G[FontSizeSlider:GetName() .. "Low"]:SetText("10");
    _G[FontSizeSlider:GetName() .. "High"]:SetText("22");
    FontSizeSlider.Text:SetText("|cfff9d247Font size: " .. FontSizeSlider:GetValue());
    FontSizeSlider:SetScript("OnValueChanged", function(self)
        self.Text:SetText("|cfff9d247Font size: " .. FontSizeSlider:GetValue());
    end);

    -- Auras, Sub-title
    local subTitle = panel:CreateFontString(myAddon.."Settings_subTitle_Auras", "OVERLAY", "GameFontNormal");
    subTitle:SetPoint("topleft", myAddon.."Settings_FontSizeSlider", "bottomleft", -8, -64);
    subTitle:SetText("Debuffs");

    -- Auras visibility, Check button
    local Auras_Vis = CreateFrame("CheckButton", myAddon.."Settings_Auras_Visibility", panel, "InterfaceOptionsCheckButtonTemplate");
    Auras_Vis:SetPoint("TOPLEFT", myAddon.."Settings_subTitle_Auras", "BOTTOMLEFT", 0, -16);
    Auras_Vis.Text:SetText("Show debuffs");
    Auras_Vis:SetChecked(ReubinsNameplates_settings.Auras_Visibility);

    -- Auras countdown visibility, Check button
    local Auras_Countdown = CreateFrame("CheckButton", myAddon.."Settings_Auras_Countdown_Visibility", panel, "InterfaceOptionsCheckButtonTemplate");
    Auras_Countdown:SetPoint("TOPLEFT", myAddon.."Settings_Auras_Visibility", "BOTTOMLEFT", 0, -8);
    Auras_Countdown.Text:SetText("Show countdown");
    Auras_Countdown:SetChecked(ReubinsNameplates_settings.Auras_Countdown);
    Auras_Countdown:SetEnabled(ReubinsNameplates_settings.Auras_Visibility);

    -- Auras cooldown reverse animation, Check button
    local Auras_Cooldown_reverse = CreateFrame("CheckButton", myAddon.."Settings_Auras_Cooldown_Reverse_Animation", panel, "InterfaceOptionsCheckButtonTemplate");
    Auras_Cooldown_reverse:SetPoint("TOPLEFT", myAddon.."Settings_Auras_Countdown_Visibility", "BOTTOMLEFT", 0, -8);
    Auras_Cooldown_reverse.Text:SetText("Reverse animation");
    Auras_Cooldown_reverse:SetChecked(ReubinsNameplates_settings.Auras_Cooldown_Reverse);
    Auras_Cooldown_reverse:SetEnabled(ReubinsNameplates_settings.Auras_Visibility);

    -- Auras scale, slider
    local AurasScaleSlider = CreateFrame("Slider", myAddon.."Settings_Auras_Scale", panel, "OptionsSliderTemplate");
    AurasScaleSlider:SetPoint("TOPLEFT", myAddon.."Settings_Auras_Cooldown_Reverse_Animation", "BOTTOMLEFT", 8, -32);
    AurasScaleSlider:SetOrientation("HORIZONTAL");
    AurasScaleSlider:SetWidth(140);
    AurasScaleSlider:SetHeight(18);
    AurasScaleSlider:SetMinMaxValues(0.75, 1.25);
    AurasScaleSlider:SetValueStep(0.01);
    AurasScaleSlider:SetObeyStepOnDrag(true);
    AurasScaleSlider:SetValue(ReubinsNameplates_settings.Auras_Scale);
    _G[AurasScaleSlider:GetName() .. "Low"]:SetText("0.75");
    _G[AurasScaleSlider:GetName() .. "High"]:SetText("1.25");
    AurasScaleSlider.Text:SetText("|cfff9d247Debuffs scale: " .. string.format("%.2f", AurasScaleSlider:GetValue()));
    AurasScaleSlider:SetScript("OnValueChanged", function(self)
        self.Text:SetText("|cfff9d247Debuffs scale: " .. string.format("%.2f", AurasScaleSlider:GetValue()));
    end);

    -- Threat, Sub-title
    local subTitle = panel:CreateFontString(myAddon.."Settings_subTitle_ThreatIcon", "OVERLAY", "GameFontNormal");
    subTitle:SetPoint("left", myAddon.."Settings_subTitle_Health", "right", 280, 0);
    subTitle:SetText("Threat");

    -- Tank mode, Check button
    local Tank_Mode = CreateFrame("CheckButton", myAddon.."Settings_Tank_Mode", panel, "InterfaceOptionsCheckButtonTemplate");
    Tank_Mode:SetPoint("TOPLEFT", myAddon.."Settings_subTitle_ThreatIcon", "BOTTOMLEFT", 0, -16);
    Tank_Mode.Text:SetText("Tank mode");
    Tank_Mode:SetChecked(ReubinsNameplates_settings.Tank);

    -- Threat visibility, Sub-title
    local subTitle = panel:CreateFontString(myAddon.."Settings_Threat_Visibility_subTitle", "OVERLAY", "GameFontHighlightSmall");
    subTitle:SetPoint("TOPLEFT", myAddon.."Settings_Tank_Mode", "BOTTOMLEFT", 0, -16);
    subTitle:SetText("Show:");

    -- Threat visibility, Dropdown menu
    local selection = ReubinsNameplates_settings.Threat_Visibility;
    -- Create the dropdown, and configure its appearance
    local dropDown = CreateFrame("Frame", myAddon.."Settings_Threat_Visibility_Dropdown", panel, "UIDropDownMenuTemplate");
    dropDown:SetPoint("TOPLEFT", myAddon.."Settings_Threat_Visibility_subTitle", "BOTTOMLEFT", -16, -4);
    UIDropDownMenu_SetWidth(dropDown, 140);
    UIDropDownMenu_SetText(dropDown, selection);

    UIDropDownMenu_Initialize(dropDown, function(self, level, menuList)
        local info = UIDropDownMenu_CreateInfo();
        info.func = self.SetValue;
        info.text, info.arg1, info.checked = "Always", "Always", "Always" == selection;
        UIDropDownMenu_AddButton(info);
        info.text, info.arg1, info.checked = "Solo", "Solo", "Solo" == selection;
        UIDropDownMenu_AddButton(info);
        info.text, info.arg1, info.checked = "Party & Raid", "Party & Raid", "Party & Raid" == selection;
        UIDropDownMenu_AddButton(info);
        info.text, info.arg1, info.checked = "Never", "Never", "Never" == selection;
        UIDropDownMenu_AddButton(info);
    end);

    function dropDown:SetValue(newValue)
        selection = newValue;
        UIDropDownMenu_SetText(dropDown, selection);
        CloseDropDownMenus();
    end

    -- Notes, Sub-title
    local subTitle = panel:CreateFontString(myAddon.."Settings_subTitle_Notes", "OVERLAY", "GameFontNormal");
    subTitle:SetPoint("TOPLEFT", myAddon.."Settings_Auras_Scale", "BOTTOMLEFT", -8, -64);
    subTitle:SetText('NOTES:');

    local subTitle = panel:CreateFontString(myAddon.."Settings_Text_Notes", "OVERLAY", "GameFontNormal");
    subTitle:SetPoint("TOPLEFT", myAddon.."Settings_subTitle_Notes", "BOTTOMLEFT", 0, -16);
    subTitle:SetText('You can also toggle Tank mode by typing "/rplates tank" in the chat');

    -- Script
    Auras_Vis:SetScript("OnClick", function()
        Auras_Countdown:SetEnabled(Auras_Vis:GetChecked());
    end)

    ----------------------------------------
    -- APPLYTING SETTINGS (Ok button)
    ----------------------------------------
    panel.okay =
        function ()
            -- Tank mode
            ReubinsNameplates_settings.Tank = Tank_Mode:GetChecked();
            -- Threat visibility
            ReubinsNameplates_settings.Threat_Visibility = selection;
            -- Show Health
            ReubinsNameplates_settings.Show_Health = ShowHealthCheck:GetChecked();
            -- Font Size
            ReubinsNameplates_settings.FontSize = FontSizeSlider:GetValue();
            -- Auras visibility
            ReubinsNameplates_settings.Auras_Visibility = Auras_Vis:GetChecked();
            -- Auras countdown visibility
            ReubinsNameplates_settings.Auras_Countdown = Auras_Countdown:GetChecked();
            -- Auras cooldown animation reverse
            ReubinsNameplates_settings.Auras_Cooldown_Reverse = Auras_Cooldown_reverse:GetChecked();
            -- Auras Scale
            ReubinsNameplates_settings.Auras_Scale = AurasScaleSlider:GetValue();

            -- Applying Health settings
            for k, v in pairs(frames.health) do
                if k then
                    v:SetShown(ReubinsNameplates_settings.Show_Health);
                    v:SetFont("Fonts\\FRIZQT__.TTF", ReubinsNameplates_settings.FontSize, "OUTLINE");
                end
            end

            -- Applying Threat visibility & Tank mode settings
            for k, v in pairs(frames.threat) do
                if k then
                    if not ReubinsNameplates_settings.Tank then
                        v:SetTexture("Interface\\addons\\ReubinsNameplates\\media\\aggro");
                    else
                        v:SetTexture("Interface\\addons\\ReubinsNameplates\\media\\tanking");
                    end
                    func:Add_Nameplate(k);
                    func:Update_Threat(k);
                end
            end

            if ReubinsNameplates_settings.Tank == true then
                print("|cff00ccffReubin's Nameplates: |cffFFFC54Tank mode activated");
            else
                print("|cff00ccffReubin's Nameplates: |cffFFFC54Tank mode deactivated");
            end

            -- Applying Aura settings
            for k, v in pairs(frames.auras) do
                if k then
                    if UnitExists((k):match('^(.-)_')) then
                        func:Update_Auras((k):match('^(.-)_'));
                    end
                end
            end
        end

    ----------------------------------------
    -- CANCELING SETTINGS (Cancel button)
    ----------------------------------------
    panel.cancel =
        function ()
            -- Tank mode
            Tank_Mode:SetChecked(ReubinsNameplates_settings.Tank);
            -- Threat visibility
            UIDropDownMenu_SetText(dropDown, ReubinsNameplates_settings.Threat_Visibility);
            -- Show Health
            ShowHealthCheck:SetChecked(ReubinsNameplates_settings.Show_Health);
            -- Font Size
            FontSizeSlider:SetValue(ReubinsNameplates_settings.FontSize);
            -- Auras visibility
            Auras_Vis:SetChecked(ReubinsNameplates_settings.Auras_Visibility);
            -- Auras scale
            AurasScaleSlider:SetValue(ReubinsNameplates_settings.Auras_Scale);
            -- Auras countown
            Auras_Countdown:SetChecked(ReubinsNameplates_settings.Auras_Countdown);
            -- Auras cooldown animation reverse
            Auras_Cooldown_reverse:SetChecked(ReubinsNameplates_settings.Auras_Cooldown_Reverse);
        end

    ----------------------------------------
    -- REVERTING TO DEFAULTS (Defaults button)
    ----------------------------------------
    panel.default =
        function ()
            -- Tank mode
            ReubinsNameplates_settings.Tank = false;
            Tank_Mode:SetChecked(ReubinsNameplates_settings.Tank);
            -- Threat visibility
            UIDropDownMenu_Initialize(dropDown, function(self, level, menuList)
                local info = UIDropDownMenu_CreateInfo()
                info.func = self.SetValue
                info.text, info.arg1, info.checked = "Always", "Always", "Always" == ReubinsNameplates_settings.Threat_Visibility;
                UIDropDownMenu_AddButton(info);
                info.text, info.arg1, info.checked = "Solo", "Solo", "Solo" == ReubinsNameplates_settings.Threat_Visibility;
                UIDropDownMenu_AddButton(info);
                info.text, info.arg1, info.checked = "Party & Raid", "Party & Raid", "Party & Raid" == ReubinsNameplates_settings.Threat_Visibility;
                UIDropDownMenu_AddButton(info);
                info.text, info.arg1, info.checked = "Never", "Never", "Never" == ReubinsNameplates_settings.Threat_Visibility;
                UIDropDownMenu_AddButton(info);
            end);
            ReubinsNameplates_settings.Threat_Visibility = "Always";
            UIDropDownMenu_SetText(dropDown, ReubinsNameplates_settings.Threat_Visibility);
            -- Show Health
            ReubinsNameplates_settings.Show_Health = true;
            ShowHealthCheck:SetChecked(ReubinsNameplates_settings.Show_Health);
            -- Font Size
            ReubinsNameplates_settings.FontSize = 16;
            FontSizeSlider:SetValue(ReubinsNameplates_settings.FontSize);
            -- Auras visibility
            ReubinsNameplates_settings.Auras_Visibility = true;
            Auras_Vis:SetChecked(ReubinsNameplates_settings.Auras_Visibility);
            -- Auras scale
            ReubinsNameplates_settings.Auras_Scale = 1.00;
            AurasScaleSlider:SetValue(ReubinsNameplates_settings.Auras_Scale);
            -- Auras countown
            ReubinsNameplates_settings.Auras_Countdown = false;
            Auras_Countdown:SetChecked(ReubinsNameplates_settings.Auras_Countdown);
            -- Auras cooldown animation reverse
            ReubinsNameplates_settings.Auras_Cooldown_Reverse = false;
            Auras_Cooldown_reverse:SetChecked(ReubinsNameplates_settings.Auras_Cooldown_Reverse);
        end

    -- Add the panel to the Interface Options
    InterfaceOptions_AddCategory(panel);
end

----------------------------------------
-- SAVING SETTINGS
----------------------------------------
function func:Save_Settings()
    ReubinsNameplates_settings.Tank = ReubinsNameplates_settings.Tank; -- Tank mode
    ReubinsNameplates_settings.Threat_Visibility = ReubinsNameplates_settings.Threat_Visibility; -- Show / Hide Threat
    ReubinsNameplates_settings.Show_Health = ReubinsNameplates_settings.Show_Health; -- Show / Hide Health
    ReubinsNameplates_settings.FontSize = ReubinsNameplates_settings.FontSize; -- Font size
    ReubinsNameplates_settings.Auras_Countdown = ReubinsNameplates_settings.Auras_Countdown; -- Aura's countdown
    ReubinsNameplates_settings.Auras_Scale = ReubinsNameplates_settings.Auras_Scale; -- Aura's scale
    ReubinsNameplates_settings.Auras_Visibility = ReubinsNameplates_settings.Auras_Visibility; -- Auras visibility
end
