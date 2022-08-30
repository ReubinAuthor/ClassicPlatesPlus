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

    -- Initial settings --

    -- Setting up a table
    if ReubinsNameplates_settings == nil then ReubinsNameplates_settings = {};
    else ReubinsNameplates_settings = ReubinsNameplates_settings; end

    -- Tank mode
    if ReubinsNameplates_settings.Tank == nil then ReubinsNameplates_settings.Tank = false;
    else ReubinsNameplates_settings.Tank = ReubinsNameplates_settings.Tank; end

    -- Show threat icon
    if ReubinsNameplates_settings.Threat_Visibility == nil then ReubinsNameplates_settings.Threat_Visibility = "Always";
    else ReubinsNameplates_settings.Threat_Visibility = ReubinsNameplates_settings.Threat_Visibility; end

    -- Show threat value
    if ReubinsNameplates_settings.ThreatValue == nil then ReubinsNameplates_settings.ThreatValue = true;
    else ReubinsNameplates_settings.ThreatValue = ReubinsNameplates_settings.ThreatValue; end

    -- Threat value font size
    if ReubinsNameplates_settings.ThreatValueFontSize == nil then ReubinsNameplates_settings.ThreatValueFontSize = 10;
    else ReubinsNameplates_settings.ThreatValueFontSize = ReubinsNameplates_settings.ThreatValueFontSize; end

    -- Show health
    if ReubinsNameplates_settings.Show_Health == nil then ReubinsNameplates_settings.Show_Health = true;
    else ReubinsNameplates_settings.Show_Health =  ReubinsNameplates_settings.Show_Health; end

    -- Health font size
    if ReubinsNameplates_settings.FontSize == nil then ReubinsNameplates_settings.FontSize = 16;
    else ReubinsNameplates_settings.FontSize = ReubinsNameplates_settings.FontSize; end

    -- Buffs visibility
    if ReubinsNameplates_settings.Buffs == nil then ReubinsNameplates_settings.Buffs = true;
    else ReubinsNameplates_settings.Buffs = ReubinsNameplates_settings.Buffs; end

    -- Debuffs visibility
    if ReubinsNameplates_settings.Debuffs == nil then ReubinsNameplates_settings.Debuffs = true;
    else ReubinsNameplates_settings.Debuffs = ReubinsNameplates_settings.Debuffs; end

    -- Aura's countdown
    if ReubinsNameplates_settings.Auras_Countdown == nil then ReubinsNameplates_settings.Auras_Countdown = false;
    else ReubinsNameplates_settings.Auras_Countdown = ReubinsNameplates_settings.Auras_Countdown; end

    -- Aura's scale
    if ReubinsNameplates_settings.Auras_Scale == nil then ReubinsNameplates_settings.Auras_Scale = 1;
    else ReubinsNameplates_settings.Auras_Scale = ReubinsNameplates_settings.Auras_Scale; end

    -- Aura's animation reverse
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
    local subTitleHealth = panel:CreateFontString(myAddon.."Settings_subTitle_Health", "OVERLAY", "GameFontNormal");
    subTitleHealth:SetPoint("TOPLEFT", myAddon.."Settings_title", "BOTTOMLEFT", 0, -16);
    subTitleHealth:SetText("Health");

    -- Show Health, Check button
    local ShowHealthCheck = CreateFrame("CheckButton", myAddon.."Settings_ShowHealth", panel, "InterfaceOptionsCheckButtonTemplate");
    ShowHealthCheck:SetPoint("TOPLEFT", myAddon.."Settings_subTitle_Health", "BOTTOMLEFT", 0, -16);
    ShowHealthCheck.Text:SetText("Enable");
    ShowHealthCheck:SetChecked(ReubinsNameplates_settings.Show_Health);

    -- Health text size, slider
    local HealthTextSizeSlider = CreateFrame("Slider", myAddon.."Settings_HealthTextSizeSlider", panel, "OptionsSliderTemplate");
    HealthTextSizeSlider:SetPoint("TOPLEFT", myAddon.."Settings_ShowHealth", "BOTTOMLEFT", 8, -32);
    HealthTextSizeSlider:SetOrientation("HORIZONTAL");
    HealthTextSizeSlider:SetWidth(140);
    HealthTextSizeSlider:SetHeight(18);
    HealthTextSizeSlider:SetMinMaxValues(10, 22);
    HealthTextSizeSlider:SetValueStep(1);
    HealthTextSizeSlider:SetObeyStepOnDrag(true);
    HealthTextSizeSlider:SetValue(ReubinsNameplates_settings.FontSize);
    _G[HealthTextSizeSlider:GetName() .. "Low"]:SetText("10");
    _G[HealthTextSizeSlider:GetName() .. "High"]:SetText("22");
    HealthTextSizeSlider.Text:SetText("|cfff9d247Font size: " .. HealthTextSizeSlider:GetValue());
    HealthTextSizeSlider:SetScript("OnValueChanged", function(self)
        self.Text:SetText("|cfff9d247Font size: " .. HealthTextSizeSlider:GetValue());
    end);

    -- Auras, Sub-title
    local subTitle = panel:CreateFontString(myAddon.."Settings_subTitle_Auras", "OVERLAY", "GameFontNormal");
    subTitle:SetPoint("topleft", myAddon.."Settings_HealthTextSizeSlider", "bottomleft", -8, -64);
    subTitle:SetText("Buffs & Debuffs");

    -- Buffs visibility, Check button
    local Buffs_Vis = CreateFrame("CheckButton", myAddon.."Settings_Buffs_Visibility", panel, "InterfaceOptionsCheckButtonTemplate");
    Buffs_Vis:SetPoint("TOPLEFT", myAddon.."Settings_subTitle_Auras", "BOTTOMLEFT", 0, -16);
    Buffs_Vis.Text:SetText("Show buffs");
    Buffs_Vis:SetChecked(ReubinsNameplates_settings.Buffs);

    -- Debuffs visibility, Check button
    local Debuffs_Vis = CreateFrame("CheckButton", myAddon.."Settings_Debuffs_Visibility", panel, "InterfaceOptionsCheckButtonTemplate");
    Debuffs_Vis:SetPoint("TOPLEFT", myAddon.."Settings_Buffs_Visibility", "BOTTOMLEFT", 0, -8);
    Debuffs_Vis.Text:SetText("Show debuffs");
    Debuffs_Vis:SetChecked(ReubinsNameplates_settings.Debuffs);

    -- Auras countdown visibility, Check button
    local Auras_Countdown = CreateFrame("CheckButton", myAddon.."Settings_Auras_Countdown_Visibility", panel, "InterfaceOptionsCheckButtonTemplate");
    Auras_Countdown:SetPoint("TOPLEFT", myAddon.."Settings_Debuffs_Visibility", "BOTTOMLEFT", 0, -8);
    Auras_Countdown.Text:SetText("Show countdown");
    Auras_Countdown:SetChecked(ReubinsNameplates_settings.Auras_Countdown);

    -- Auras cooldown reverse animation, Check button
    local Auras_Cooldown_reverse = CreateFrame("CheckButton", myAddon.."Settings_Auras_Cooldown_Reverse_Animation", panel, "InterfaceOptionsCheckButtonTemplate");
    Auras_Cooldown_reverse:SetPoint("TOPLEFT", myAddon.."Settings_Auras_Countdown_Visibility", "BOTTOMLEFT", 0, -8);
    Auras_Cooldown_reverse.Text:SetText("Reverse animation");
    Auras_Cooldown_reverse:SetChecked(ReubinsNameplates_settings.Auras_Cooldown_Reverse);

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
    AurasScaleSlider.Text:SetText("|cfff9d247Scale: " .. string.format("%.2f", AurasScaleSlider:GetValue()));
    AurasScaleSlider:SetScript("OnValueChanged", function(self)
        self.Text:SetText("|cfff9d247Scale: " .. string.format("%.2f", AurasScaleSlider:GetValue()));
    end);

    -- Threat value, Sub-title
    local subTitleThreatValue = panel:CreateFontString(myAddon.."Settings_subTitle_ThreatValue", "OVERLAY", "GameFontNormal");
    subTitleThreatValue:SetPoint("left", myAddon.."Settings_subTitle_Health", "right", 280, 0);
    subTitleThreatValue:SetText("Threat differential");

    -- Threat value, Check button
    local ShowThreatValue = CreateFrame("CheckButton", myAddon.."Settings_ThreatValue", panel, "InterfaceOptionsCheckButtonTemplate");
    ShowThreatValue:SetPoint("TOPLEFT", myAddon.."Settings_subTitle_ThreatValue", "BOTTOMLEFT", 0, -16);
    ShowThreatValue.Text:SetText("Enable");
    ShowThreatValue:SetChecked(ReubinsNameplates_settings.ThreatValue);

    -- Threat value size, slider
    local ThreatValueSizeSlider = CreateFrame("Slider", myAddon.."Settings_ThreatValueSizeSlider", panel, "OptionsSliderTemplate");
    ThreatValueSizeSlider:SetPoint("TOPLEFT", myAddon.."Settings_ThreatValue", "BOTTOMLEFT", 8, -32);
    ThreatValueSizeSlider:SetOrientation("HORIZONTAL");
    ThreatValueSizeSlider:SetWidth(140);
    ThreatValueSizeSlider:SetHeight(18);
    ThreatValueSizeSlider:SetMinMaxValues(6, 14);
    ThreatValueSizeSlider:SetValueStep(1);
    ThreatValueSizeSlider:SetObeyStepOnDrag(true);
    ThreatValueSizeSlider:SetValue(ReubinsNameplates_settings.ThreatValueFontSize);
    _G[ThreatValueSizeSlider:GetName() .. "Low"]:SetText("6");
    _G[ThreatValueSizeSlider:GetName() .. "High"]:SetText("14");
    ThreatValueSizeSlider.Text:SetText("|cfff9d247Font size: " .. ThreatValueSizeSlider:GetValue());
    ThreatValueSizeSlider:SetScript("OnValueChanged", function(self)
        self.Text:SetText("|cfff9d247Font size: " .. ThreatValueSizeSlider:GetValue());
    end);

    -- Threat icon, Sub-title
    local subTitleThreatIcon = panel:CreateFontString(myAddon.."Settings_subTitle_ThreatIcon", "OVERLAY", "GameFontNormal");
    subTitleThreatIcon:SetPoint("topleft", myAddon.."Settings_ThreatValueSizeSlider", "bottomleft", -8, -64);
    subTitleThreatIcon:SetText("Threat icon");

    -- Tank mode, Check button
    local Tank_Mode = CreateFrame("CheckButton", myAddon.."Settings_Tank_Mode", panel, "InterfaceOptionsCheckButtonTemplate");
    Tank_Mode:SetPoint("TOPLEFT", myAddon.."Settings_subTitle_ThreatIcon", "BOTTOMLEFT", 0, -16);
    Tank_Mode.Text:SetText("Tank mode");
    Tank_Mode:SetChecked(ReubinsNameplates_settings.Tank);

    -- Threat visibility, Sub-title
    local subTitleThreatVis = panel:CreateFontString(myAddon.."Settings_Threat_Visibility_subTitle", "OVERLAY", "GameFontHighlightSmall");
    subTitleThreatVis:SetPoint("TOPLEFT", myAddon.."Settings_Tank_Mode", "BOTTOMLEFT", 0, -16);
    subTitleThreatVis:SetText("Show threat icon:");

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
    local subTitleNotes = panel:CreateFontString(myAddon.."Settings_subTitle_Notes", "OVERLAY", "GameFontNormal");
    subTitleNotes:SetPoint("TOPLEFT", myAddon.."Settings_Auras_Scale", "BOTTOMLEFT", -8, -64);
    subTitleNotes:SetText('NOTES:');

    local subTitleNote = panel:CreateFontString(myAddon.."Settings_Text_Notes", "OVERLAY", "GameFontNormal");
    subTitleNote:SetPoint("TOPLEFT", myAddon.."Settings_subTitle_Notes", "BOTTOMLEFT", 0, -16);
    subTitleNote:SetText('You can toggle Tank mode by typing "/rplates tank" in the chat');

    ----------------------------------------
    -- APPLYTING SETTINGS (Ok button)
    ----------------------------------------
    panel.okay =
        function ()
            -- Tank mode
            ReubinsNameplates_settings.Tank = Tank_Mode:GetChecked();
            -- Threat icon visibility
            ReubinsNameplates_settings.Threat_Visibility = selection;
            -- Threat value visibility
            ReubinsNameplates_settings.ThreatValue = ShowThreatValue:GetChecked();
            -- Threat value font size
            ReubinsNameplates_settings.ThreatValueFontSize = ThreatValueSizeSlider:GetValue();
            -- Show Health
            ReubinsNameplates_settings.Show_Health = ShowHealthCheck:GetChecked();
            -- Health text size
            ReubinsNameplates_settings.FontSize = HealthTextSizeSlider:GetValue();
            -- Buffs visibility
            ReubinsNameplates_settings.Buffs = Buffs_Vis:GetChecked();
            -- Debuffs visibility
            ReubinsNameplates_settings.Debuffs = Debuffs_Vis:GetChecked();
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
                if k and UnitExists(k) then
                    func:Add_Nameplate(k);
                    func:Update_Threat(k);
                end
            end

            -- Applying Aura settings
            for k, v in pairs(frames.auras) do
                if k and UnitExists(k) then
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
            -- Threat value visibility
            ShowThreatValue:SetChecked(ReubinsNameplates_settings.ThreatValue);
            -- Threat icon visibility
            UIDropDownMenu_SetText(dropDown, ReubinsNameplates_settings.Threat_Visibility);
            -- Threat value font size
            ThreatValueSizeSlider:SetValue(ReubinsNameplates_settings.ThreatValueFontSize);
            -- Show Health
            ShowHealthCheck:SetChecked(ReubinsNameplates_settings.Show_Health);
            -- Health text size
            HealthTextSizeSlider:SetValue(ReubinsNameplates_settings.FontSize);
            -- Buffs visibility
            Buffs_Vis:SetChecked(ReubinsNameplates_settings.Buffs);
            -- Debuffs visibility
            Debuffs_Vis:SetChecked(ReubinsNameplates_settings.Debuffs);
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
            -- Threat value visibility
            ReubinsNameplates_settings.ThreatValue = true;
            ShowThreatValue:SetChecked(ReubinsNameplates_settings.ThreatValue);
            -- Threat icon visibility
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
            -- Threat value font size
            ReubinsNameplates_settings.ThreatValueFontSize = 10;
            ThreatValueSizeSlider:SetValue(ReubinsNameplates_settings.ThreatValueFontSize);
            -- Show Health
            ReubinsNameplates_settings.Show_Health = true;
            ShowHealthCheck:SetChecked(ReubinsNameplates_settings.Show_Health);
            -- Health text size
            ReubinsNameplates_settings.FontSize = 16;
            HealthTextSizeSlider:SetValue(ReubinsNameplates_settings.FontSize);
            -- Buffs visibility
            ReubinsNameplates_settings.Buffs = true;
            Buffs_Vis:SetChecked(ReubinsNameplates_settings.Buffs);
            -- Debuffs visibility
            ReubinsNameplates_settings.Debuffs = true;
            Debuffs_Vis:SetChecked(ReubinsNameplates_settings.Debuffs);
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
    ReubinsNameplates_settings.FontSize = ReubinsNameplates_settings.FontSize; -- Health text size
    ReubinsNameplates_settings.Auras_Countdown = ReubinsNameplates_settings.Auras_Countdown; -- Aura's countdown
    ReubinsNameplates_settings.Auras_Scale = ReubinsNameplates_settings.Auras_Scale; -- Aura's scale
    ReubinsNameplates_settings.Buffs = ReubinsNameplates_settings.Buffs; -- Buffs visibility
    ReubinsNameplates_settings.Debuffs = ReubinsNameplates_settings.Debuffs; -- Debuffs visibility
end
