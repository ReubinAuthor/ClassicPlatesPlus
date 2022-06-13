----------------------------------------
-- NAMESPACES
----------------------------------------
local myAddon, core = ...;
local func = core.func;
local frames = core.frames;

----------------------------------------
-- INITIAL SETTINGS 
----------------------------------------
function func:Initial_Settings()
    if not ReubinsNameplates_settings then
        ReubinsNameplates_settings = {}; -- Setting up a table
        ReubinsNameplates_settings.Tank = false; -- Tank mode
        ReubinsNameplates_settings.Threat_Visibility = "Always"; -- Show Threat
        ReubinsNameplates_settings.Show_Health = true; -- Show Health
        ReubinsNameplates_settings.FontSize = 16; -- Font Size
    end
end

----------------------------------------
-- ADDON SETTINGS
----------------------------------------
function func:Load_Settings()
    -- Create a frame to use as the panel
    local panel = CreateFrame("FRAME", myAddon.."Settings");
    panel.name = "Reubin's Nameplates";
    frames.panel = panel;
    
    -- Title
    local title = panel:CreateFontString(myAddon.."Settings_title", "OVERLAY", "GameFontNormalLarge");
    title:SetPoint("TOPLEFT", myAddon.."Settings", "TOPLEFT", 16, -16);
    title:SetText("Reubin's Nameplates");
    
    -- Threat icon, Sub-title
    local subTitle = panel:CreateFontString(myAddon.."Settings_subTitle_ThreatIcon", "OVERLAY", "GameFontNormal");
    subTitle:SetPoint("TOPLEFT", myAddon.."Settings_title", "BOTTOMLEFT", 0, -16);
    subTitle:SetText("Threat icon");
    
    -- Tank mode, Check button
    local TankCheck = CreateFrame("CheckButton", myAddon.."Settings_TankCheck", panel, "InterfaceOptionsCheckButtonTemplate");
    TankCheck:SetPoint("TOPLEFT", myAddon.."Settings_subTitle_ThreatIcon", "BOTTOMLEFT", 0, -16);
    TankCheck.Text:SetText("Tank mode");
    TankCheck:SetChecked(ReubinsNameplates_settings.Tank);
    
    -- Threat visibility, Sub-title
    local subTitle = panel:CreateFontString(myAddon.."Settings_Threat_Visibility_subTitle", "OVERLAY", "GameFontHighlightSmall");
    subTitle:SetPoint("TOPLEFT", myAddon.."Settings_TankCheck", "BOTTOMLEFT", 0, -16);
    subTitle:SetText("Show icon");

    -- Threat visibility, Dropdown menu
    local selection = ReubinsNameplates_settings.Threat_Visibility
    -- Create the dropdown, and configure its appearance
    local dropDown = CreateFrame("Frame", myAddon.."Settings_Threat_Visibility_Dropdown", panel, "UIDropDownMenuTemplate");
    dropDown:SetPoint("TOPLEFT", myAddon.."Settings_Threat_Visibility_subTitle", "BOTTOMLEFT", -16, -4);
    UIDropDownMenu_SetWidth(dropDown, 120);
    UIDropDownMenu_SetText(dropDown, selection);

    UIDropDownMenu_Initialize(dropDown, function(self, level, menuList)
        local info = UIDropDownMenu_CreateInfo()
        info.func = self.SetValue
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
        selection = newValue
        UIDropDownMenu_SetText(dropDown, selection)
        CloseDropDownMenus()
    end

    -- Threat icon, Sub-title
    local subTitle = panel:CreateFontString(myAddon.."Settings_subTitle_Health", "OVERLAY", "GameFontNormal");
    subTitle:SetPoint("TOPLEFT", myAddon.."Settings_Threat_Visibility_Dropdown", "BOTTOMLEFT", 16, -16);
    subTitle:SetText("Health");
    
    -- Show Health, Check button
    local ShowHealthCheck = CreateFrame("CheckButton", myAddon.."Settings_ShowHealthCheck", panel, "InterfaceOptionsCheckButtonTemplate");
    ShowHealthCheck:SetPoint("TOPLEFT", myAddon.."Settings_subTitle_Health", "BOTTOMLEFT", 0, -16);
    ShowHealthCheck.Text:SetText("Show health");
    ShowHealthCheck:SetChecked(ReubinsNameplates_settings.Show_Health);
    
    -- Font size, slider
    local FontSizeSlider = CreateFrame("Slider", myAddon.."Settings_FontSizeSlider", panel, "OptionsSliderTemplate");
    FontSizeSlider:SetPoint("TOPLEFT", myAddon.."Settings_ShowHealthCheck", "BOTTOMLEFT", 8, -24);
    FontSizeSlider:SetOrientation("HORIZONTAL");
    FontSizeSlider:SetWidth(300);
    FontSizeSlider:SetHeight(20);
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
    
    -- Notes, Sub-title
    local subTitle = panel:CreateFontString(myAddon.."Settings_subTitle_Notes", "OVERLAY", "GameFontNormal");
    subTitle:SetPoint("TOPLEFT", myAddon.."Settings_FontSizeSlider", "BOTTOMLEFT", 0, -32);
    subTitle:SetText('Notes:');
    
    local subTitle = panel:CreateFontString(myAddon.."Settings_Text_Notes", "OVERLAY", "GameFontNormal");
    subTitle:SetPoint("TOPLEFT", myAddon.."Settings_subTitle_Notes", "BOTTOMLEFT", 0, -16);
    subTitle:SetText('You can also toggle Tank mode by typing "/rplates tank" in the chat');

    ----------------------------------------
    -- APPLYTING SETTINGS (Ok button)
    ----------------------------------------
    panel.okay =
        function ()
            -- Tank mode
            ReubinsNameplates_settings.Tank = TankCheck:GetChecked();
            -- Threat visibility
            ReubinsNameplates_settings.Threat_Visibility = selection;
            -- Show Health
            ReubinsNameplates_settings.Show_Health = ShowHealthCheck:GetChecked();
            -- Font Size
            ReubinsNameplates_settings.FontSize = FontSizeSlider:GetValue();

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
                    v:SetShown(func:Threat_Toggle());
                    func:Update_Threat(k);
                end
            end
        end

    ----------------------------------------
    -- CANCELING SETTINGS (Cancel button)
    ----------------------------------------
    panel.cancel =
        function ()
            -- Tank mode
            TankCheck:SetChecked(ReubinsNameplates_settings.Tank);
            -- Threat visibility
            UIDropDownMenu_SetText(dropDown, ReubinsNameplates_settings.Threat_Visibility);
            -- Show Health
            ShowHealthCheck:SetChecked(ReubinsNameplates_settings.Show_Health);
            -- Font Size
            FontSizeSlider:SetValue(ReubinsNameplates_settings.FontSize);
        end
    
    ----------------------------------------
    -- REVERTING TO DEFAULTS (Defaults button)
    ----------------------------------------
    panel.default =
    function ()
        -- Tank mode
        ReubinsNameplates_settings.Tank = false;
        TankCheck:SetChecked(ReubinsNameplates_settings.Tank);
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
end
