----------------------------------------
-- NAMESPACES
----------------------------------------
local myAddon, core = ...
local func = core.func
local frames = core.frames
----------------------------------------
-- DEFAULT SETTINGS (for the first launch)
----------------------------------------
local defaults = {
    Tank = false,
    Solo = true,
    Party = true,
    ShowText = true,
    TextSize = 16,
}
ReubinsNameplates_settings = ReubinsNameplates_settings or {}
for k, v in pairs(defaults) do
    if ReubinsNameplates_settings[k] == nil then
        ReubinsNameplates_settings[k] = v
    end
end
----------------------------------------
-- ADDON SETTINGS
----------------------------------------
function func:Settings()
    -- Applying settings
    ReubinsNameplates_settings.Tank = ReubinsNameplates_settings.Tank -- Tank mode
    ReubinsNameplates_settings.Solo = ReubinsNameplates_settings.Solo -- Solo
    ReubinsNameplates_settings.Party = ReubinsNameplates_settings.Party -- Party
    ReubinsNameplates_settings.ShowText = ReubinsNameplates_settings.ShowText -- Show Text
    ReubinsNameplates_settings.TextSize = ReubinsNameplates_settings.TextSize -- Text Size
    func:Mark_Options_Check() -- Updating Marks
    func:UpdateOptionsHealth() -- Updating Text

    -- Create a frame to use as the panel
    local panel = CreateFrame("FRAME", "ReubinsNameplates_Addon_Settings")
    panel.name = "Reubin's Nameplates"
    frames.panel = panel

    -- Title
    local title = panel:CreateFontString("ReubinsNameplates_Addon_Settings_title", "OVERLAY", "GameFontNormalLarge")
    title:SetPoint("TOPLEFT", "ReubinsNameplates_Addon_Settings", "TOPLEFT", 16, -16)
    title:SetText("Reubin's Nameplates")

    -- Threat icon, Sub-title
    local subTitle = panel:CreateFontString("ReubinsNameplates_Addon_Settings_subTitle_ThreatIcon", "OVERLAY", "GameFontNormal")
    subTitle:SetPoint("TOPLEFT", "ReubinsNameplates_Addon_Settings_title", "BOTTOMLEFT", 0, -16)
    subTitle:SetText("Threat icon")

    -- Solo, Check button
    local SoloCheck = CreateFrame("CheckButton", "ReubinsNameplates_Addon_Settings_SoloCheck", panel, "InterfaceOptionsCheckButtonTemplate")
    SoloCheck:SetPoint("TOPLEFT", "ReubinsNameplates_Addon_Settings_subTitle_ThreatIcon", "BOTTOMLEFT", 0, -16)
    SoloCheck.Text:SetText("Show in solo")
    SoloCheck:SetChecked(ReubinsNameplates_settings.Solo or defaults.Solo)
    frames.SoloCheck = SoloCheck

    -- Party and Raid, Check button
    local PartyCheck = CreateFrame("CheckButton", "ReubinsNameplates_Addon_Settings_PartyCheck", panel, "InterfaceOptionsCheckButtonTemplate")
    PartyCheck:SetPoint("TOPLEFT", "ReubinsNameplates_Addon_Settings_SoloCheck", "BOTTOMLEFT", 0, -8)
    PartyCheck.Text:SetText("Show in party/raid")
    PartyCheck:SetChecked(ReubinsNameplates_settings.Party or defaults.Party)
    frames.PartyCheck = PartyCheck

    -- Tank mode, Check button
    local TankCheck = CreateFrame("CheckButton", "ReubinsNameplates_Addon_Settings_TankCheck", panel, "InterfaceOptionsCheckButtonTemplate")
    TankCheck:SetPoint("TOPLEFT", "ReubinsNameplates_Addon_Settings_PartyCheck", "BOTTOMLEFT", 0, -8)
    TankCheck.Text:SetText("Tank mode")
    TankCheck:SetChecked(ReubinsNameplates_settings.Tank or defaults.Tank)
    frames.TankCheck = TankCheck

    -- Notes, Sub-title
    local subTitle = panel:CreateFontString("ReubinsNameplates_Addon_Settings_subTitle_Notes_Text", "OVERLAY", "GameFontHighlightSmall")
    subTitle:SetPoint("TOPLEFT", "ReubinsNameplates_Addon_Settings_TankCheck", "BOTTOMLEFT", 0, -8)
    subTitle:SetJustifyH("LEFT")
    subTitle:SetText('You can also toggle Tank mode by typing "/rplates tank" in the chat')

    -- Threat icon, Sub-title
    local subTitle = panel:CreateFontString("ReubinsNameplates_Addon_Settings_subTitle_Health", "OVERLAY", "GameFontNormal")
    subTitle:SetPoint("TOPLEFT", "ReubinsNameplates_Addon_Settings_subTitle_Notes_Text", "BOTTOMLEFT", 0, -32)
    subTitle:SetText("Health")

    -- Show text, Check button
    local ShowTextCheck = CreateFrame("CheckButton", "ReubinsNameplates_Addon_Settings_ShowTextCheck", panel, "InterfaceOptionsCheckButtonTemplate")
    ShowTextCheck:SetPoint("TOPLEFT", "ReubinsNameplates_Addon_Settings_subTitle_Health", "BOTTOMLEFT", 0, -16)
    ShowTextCheck.Text:SetText("Show health")
    ShowTextCheck:SetChecked(ReubinsNameplates_settings.ShowText or defaults.ShowText)
    frames.ShowTextCheck = ShowTextCheck

    -- Text size, slider
    local TextSizeSlider = CreateFrame("Slider", "ReubinsNameplates_Addon_Settings_TextSizeSlider", panel, "OptionsSliderTemplate")
    TextSizeSlider:SetPoint("TOPLEFT", "ReubinsNameplates_Addon_Settings_ShowTextCheck", "BOTTOMLEFT", 8, -24)
    TextSizeSlider:SetOrientation("HORIZONTAL")
    TextSizeSlider:SetWidth(300)
    TextSizeSlider:SetHeight(20)
    TextSizeSlider:SetMinMaxValues(10, 22)
    TextSizeSlider:SetValueStep(1)
    TextSizeSlider:SetObeyStepOnDrag(true)
    TextSizeSlider:SetValue(ReubinsNameplates_settings.TextSize or defaults.TextSize)
    _G[TextSizeSlider:GetName() .. "Low"]:SetText("10")
    _G[TextSizeSlider:GetName() .. "High"]:SetText("22")
    TextSizeSlider.Text:SetText("|cfff9d247Font size: " .. TextSizeSlider:GetValue())
    TextSizeSlider:SetScript("OnValueChanged", function(self)
        self.Text:SetText("|cfff9d247Font size: " .. TextSizeSlider:GetValue())
    end)

    -- Default settings
    panel.default =
        function ()
            -- Tank mode
            ReubinsNameplates_settings.Tank = false
            TankCheck:SetChecked(ReubinsNameplates_settings.Tank)
            -- Solo
            ReubinsNameplates_settings.Solo = true
            SoloCheck:SetChecked(ReubinsNameplates_settings.Solo)
            -- Party
            ReubinsNameplates_settings.Party = true
            PartyCheck:SetChecked(ReubinsNameplates_settings.Party)
            -- Show Text
            ReubinsNameplates_settings.ShowText = true
            ShowTextCheck:SetChecked(ReubinsNameplates_settings.ShowText)
            -- Text Size
            ReubinsNameplates_settings.TextSize = 16
            TextSizeSlider:SetValue(ReubinsNameplates_settings.TextSize)
        end

    -- When the player clicks okay, set the original value to the current setting
    panel.okay =
        function ()
            -- Tank mode
            ReubinsNameplates_settings.Tank = TankCheck:GetChecked()
            func:Mark_Options_Check()
            -- Solo
            ReubinsNameplates_settings.Solo = SoloCheck:GetChecked()
            func:Mark_Options_Check()
            -- Party
            ReubinsNameplates_settings.Party = PartyCheck:GetChecked()
            func:Mark_Options_Check()
            -- Show Text
            ReubinsNameplates_settings.ShowText = ShowTextCheck:GetChecked()
            func:UpdateOptionsHealth()
            -- Text Size
            ReubinsNameplates_settings.TextSize = TextSizeSlider:GetValue()
            func:UpdateOptionsHealth()
        end

    -- When the player clicks cancel, set the current setting to the original value
    panel.cancel =
        function ()
            -- Tank mode
            TankCheck:SetChecked(ReubinsNameplates_settings.Tank)
            -- Solo
            SoloCheck:SetChecked(ReubinsNameplates_settings.Solo)
            -- Party
            PartyCheck:SetChecked(ReubinsNameplates_settings.Party)
            -- Show Text
            ShowTextCheck:SetChecked(ReubinsNameplates_settings.ShowText)
            -- Text Size
            TextSizeSlider:SetValue(ReubinsNameplates_settings.TextSize)
        end

    -- Add the panel to the Interface Options
    InterfaceOptions_AddCategory(panel)
end

----------------------------------------
-- SAVING VARIABLES
----------------------------------------
function func:Save_Settings()
    ReubinsNameplates_settings.Tank = ReubinsNameplates_settings.Tank -- Tank mode
    ReubinsNameplates_settings.Solo = ReubinsNameplates_settings.Solo -- Solo
    ReubinsNameplates_settings.Party = ReubinsNameplates_settings.Party -- Party or raid
    ReubinsNameplates_settings.ShowText = ReubinsNameplates_settings.ShowText -- Show HP
    ReubinsNameplates_settings.TextSize = ReubinsNameplates_settings.TextSize -- Text size
end
