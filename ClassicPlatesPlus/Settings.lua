----------------------------------------
-- CORE
----------------------------------------
local myAddon, core = ...;
local func = core.func;
local data = core.data;

-- Colors
local yellow = "|cff" .. "ffd100";
local white  = "|cff" .. "ffffff";
local green  = "|cff" .. "7CFC00";
local orange = "|cff" .. "FF5600";
local blue   = "|cff" .. "0072CA";
local purple = "|cff" .. "FF00FF";
local gray   = "|cff" .. "808080";

-- Panels table
data.settings = {
    panels = {}, -- Table that will store panels for initialization
    configs = {
        all = {}, -- Table that will contain complete list of configs
        panels = {} -- Table for panels settings
    }
};

----------------------------------------
-- Loading Settings
----------------------------------------
function func:Load_Settings()

    -- Creating config tables
    CFG_ClassicPlatesPlus = CFG_ClassicPlatesPlus or {};
    CFG_Account_ClassicPlatesPlus = CFG_Account_ClassicPlatesPlus or { Profiles = {} };

    -- Creating profiles
    local profileID = func:GenerateID();
    local playerName = UnitName("player");
    local playerRealm = GetRealmName("player");
    local profileName = playerName .. " - " .. playerRealm;

    CFG_ClassicPlatesPlus.Profile = CFG_ClassicPlatesPlus.Profile or profileID;
    CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile] = CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile] or { displayName = profileName };

    -- MAIN PANEL
    -- Fist panel has to be accessable to other panels, putting it outside of the code block.
    local panelMain = func:CreatePanel(nil, myAddon);

    -- CATEGORY: About
    do
        -- Sub-Category
        do
            local title = "Contact Me";
            local description = "Feel free to leave feedback, ask for help, or suggest your idea.";

            func:Create_SubCategory(panelMain, title, description);
        end

        -- Social Link
        do
            local name = "Discord";
            local image = "Interface\\addons\\ClassicPlatesPlus\\media\\logo\\discord";
            local link = "discord.gg/Hj49J2APGZ";
            local text = "";
            local flair = { classicEra = true, cata = true, retail = true };

            func:Create_SocialLink(panelMain, flair, name, image, text, link)
        end

        -- Spacer
        func:Create_Spacer(panelMain);

        -- Social Link
        do
            local name = "GitHub";
            local image = "Interface\\addons\\ClassicPlatesPlus\\media\\logo\\github";
            local link = "github.com/ReubinAuthor/ClassicPlatesPlus";
            local text = "";
            local flair = { classicEra = true, cata = true, retail = true };

            func:Create_SocialLink(panelMain, flair, name, image, text, link)
        end

        -- Spacer
        func:Create_Spacer(panelMain);

        -- Sub-Category
        do
            local title = "Consider Supporting This Project";
            local description = "Development of this project takes 99% of my WoW time.\nPlease consider supporting it if you like it.";

            func:Create_SubCategory(panelMain, title, description);
        end

        -- Social Link
        do
            local name = "Boosty";
            local image = "Interface\\addons\\ClassicPlatesPlus\\media\\logo\\boosty";
            local link = "boosty.to/reubin";
            local text = "";
            local flair = { classicEra = true, cata = true, retail = true };

            func:Create_SocialLink(panelMain, flair, name, image, text, link)
        end

        -- Anchoring settings
        func:AnchorFrames(panelMain);
    end

    -- CATEGORY: General
    do
        -- Panel
        local panel = func:CreatePanel(panelMain.name, "General");

        -- Sub-Category
        func:Create_SubCategory(panel, "General");

        -- CheckButton
        do
            local name = "Scale Nameplates With Distance";
            local tooltip = "Scale nameplates down the further away they are";
            local cfg = "ScaleWithDistance";
            local default = true;
            local flair = { classicEra = false, cata = true, retail = true };

            func:Create_CheckButton(panel, flair, name, tooltip, cfg, default);
        end

        -- CheckButton
        do
            local name = "Enlarge Selected Nameplates";
            local tooltip = "";
            local cfg = "EnlargeSelected";
            local default = true;
            local flair = { classicEra = true, cata = true, retail = true };

            func:Create_CheckButton(panel, flair, name, tooltip, cfg, default);
        end

        -- CheckButton
        do
            local name = "Fade Unselected Targets";
            local tooltip = "";
            local cfg = "FadeUnselected";
            local default = true;
            local flair = { classicEra = true, cata = true, retail = true };

            func:Create_CheckButton(panel, flair, name, tooltip, cfg, default);
        end

        -- Slider
        do
            local name = "Fade Intensity";
            local tooltip = "";
            local cfg = "FadeIntensity";
            local default = 0.5;
            local step = 0.01;
            local minValue = 0.0;
            local maxValue = 1.0;
            local decimals = 2;
            local flair = { classicEra = true, cata = true, retail = true };

            func:Create_Slider(panel, flair, name, tooltip, cfg, default, step, minValue, maxValue, decimals);
        end

        -- Slider
        do
            local name = "Nameplates Scale";
            local tooltip = "Must be out of combat for the effect to take place";
            local cfg = "NameplatesScale";
            local default = 1.00;
            local step = 0.01;
            local minValue = 0.75;
            local maxValue = 1.25;
            local decimals = 2;
            local flair = { classicEra = true, cata = true, retail = true };

            func:Create_Slider(panel, flair, name, tooltip, cfg, default, step, minValue, maxValue, decimals);
        end

        -- Slider
        do
            local name = "Max Nameplate Distance";
            local tooltip = "Must be out of combat for the effect to take place";
            local cfg = "MaxNameplateDistance";
            local default = 60;
            local step = 1;
            local minValue = 10;
            local maxValue = 60;
            local decimals = 0;
            local flair = { classicEra = false, cata = false, retail = true };

            func:Create_Slider(panel, flair, name, tooltip, cfg, default, step, minValue, maxValue, decimals);
        end

        -- Slider
        do
            local name = "Combo Points Scale";
            local tooltip = "";
            local cfg = "ComboPointsScaleClassless" --"ClassPowerScale";
            local default = 1;
            local step = 0.01;
            local minValue = 0.50;
            local maxValue = 1.50;
            local decimals = 2;
            local flair = { classicEra = true, cata = true, retail = false };

            func:Create_Slider(panel, flair, name, tooltip, cfg, default, step, minValue, maxValue, decimals);
        end

        -- Sub-Category
        func:Create_SubCategory(panel, "Structure");

        -- CheckButton
        do
            local name = "Power Bar";
            local tooltip = "";
            local cfg = "Powerbar";
            local default = true;
            local flair = { classicEra = true, cata = true, retail = true };

            func:Create_CheckButton(panel, flair, name, tooltip, cfg, default);
        end

        -- CheckButton
        do
            local name = "Portrait";
            local tooltip = "";
            local cfg = "Portrait";
            local default = true;
            local flair = { classicEra = true, cata = true, retail = true };

            func:Create_CheckButton(panel, flair, name, tooltip, cfg, default);
        end

        -- CheckButton
        do
            local name = "Level";
            local tooltip = "";
            local cfg = "ShowLevel";
            local default = true;
            local flair = { classicEra = true, cata = true, retail = true };

            func:Create_CheckButton(panel, flair, name, tooltip, cfg, default);
        end

        -- CheckButton
        do
            local name = "Guild Name";
            local tooltip = "";
            local cfg = "ShowGuildName";
            local default = true;
            local flair = { classicEra = true, cata = true, retail = true };

            func:Create_CheckButton(panel, flair, name, tooltip, cfg, default);
        end

        -- CheckButton
        do
            local name = "NPC Classification";
            local tooltip = "Creature class: " .. white .. "Elite, Rare, Rare Elite, World Boss";
            local cfg = "Classification";
            local default = true;
            local flair = { classicEra = true, cata = true, retail = true };

            func:Create_CheckButton(panel, flair, name, tooltip, cfg, default);
        end

        -- CheckButton
        do
            local name = "Faction Badge";
            local tooltip = "";
            local cfg = "ShowFaction";
            local default = true;
            local flair = { classicEra = true, cata = true, retail = true };

            func:Create_CheckButton(panel, flair, name, tooltip, cfg, default);
        end

        -- CheckButton
        do
            local name = "Fellowship Badge";
            local tooltip = "Badge colors: " .. purple .. "Friend, " .. green .. "Guildmate, " .. blue .. "Party member, " .. orange .. "Raid member";
            local cfg = "FellowshipBadge";
            local default = true;
            local flair = { classicEra = true, cata = true, retail = true };

            func:Create_CheckButton(panel, flair, name, tooltip, cfg, default);
        end

        -- CheckButton
        do
            local name = "Quest Mark";
            local tooltip = "Creature class: " .. white .. "Elite, Rare, Rare Elite, World Boss";
            local cfg = "QuestMark";
            local default = true;
            local flair = { classicEra = false, cata = false, retail = true };

            func:Create_CheckButton(panel, flair, name, tooltip, cfg, default);
        end

        -- Sub-Category
        func:Create_SubCategory(panel, "Values", nil, "small");

        -- CheckButton
        do
            local name = "Numeric Values";
            local tooltip = "Dispaly health and power numeric values";
            local cfg = "NumericValue";
            local default = true;
            local flair = { classicEra = true, cata = true, retail = true };

            func:Create_CheckButton(panel, flair, name, tooltip, cfg, default);
        end

        -- CheckButton
        do
            local name = "Percentage Values";
            local tooltip = "Dispaly Health and Power percentage values";
            local cfg = "Percentage";
            local default = true;
            local flair = { classicEra = true, cata = true, retail = true };

            func:Create_CheckButton(panel, flair, name, tooltip, cfg, default);
        end

        -- CheckButton
        do
            local name = "Switch Values Positions";
            local tooltip = "Swap positions of numeric and percentage values";
            local cfg = "PercentageAsMainValue";
            local default = false;
            local flair = { classicEra = true, cata = true, retail = true };

            func:Create_CheckButton(panel, flair, name, tooltip, cfg, default);
        end

        -- Spacer
        func:Create_Spacer(panel, "small");

        -- CheckButton
        do
            local name = "Total Health";
            local tooltip = "Display Total amount of your health\n(Displayed on personal nameplate only)";
            local cfg = "PersonalNameplateTotalHealth";
            local default = true;
            local flair = { classicEra = true, cata = true, retail = true };

            func:Create_CheckButton(panel, flair, name, tooltip, cfg, default);
        end

        -- CheckButton
        do
            local name = "Total Power";
            local tooltip = "Display Total amount of your power\n" .. white .. "Example: " .. yellow .. "Mana, Rage, Energy, etc...\n(Displayed on personal nameplate only)";
            local cfg = "PersonalNameplateTotalPower";
            local default = true;
            local flair = { classicEra = true, cata = true, retail = true };

            func:Create_CheckButton(panel, flair, name, tooltip, cfg, default);
        end

        -- Spacer
        func:Create_Spacer(panel);

        -- Anchoring settings
        func:AnchorFrames(panel);
    end

    -- CATEGORY: Personal Nameplate
    do
        -- Panel
        local panel = func:CreatePanel(panelMain.name, "Personal Nameplate");

        -- Sub-Category
        func:Create_SubCategory(panel, "General");

        -- CheckButton
        do
            local name = "Enable Personal Nameplate";
            local tooltip = not data.isRetail and "To move the personal nameplate, hold " .. green .. "CTRL" .. yellow .. " and drag it with " .. green .. "Left Mouse Button" or "";
            local cfg = "PersonalNameplate";
            local default = true;
            local flair = { classicEra = true, cata = true, retail = false };

            func:Create_CheckButton(panel, flair, name, tooltip, cfg, default);
        end

        -- CheckButton
        do
            local name = "Always Show";
            local tooltip = "Show personal nameplate even when out of combat";
            local cfg = "PersonalNameplateAlwaysShow";
            local default = false;
            local flair = { classicEra = true, cata = true, retail = true };
            local cvar = "NameplatePersonalShowAlways";

            func:Create_CheckButton(panel, flair, name, tooltip, cfg, default, cvar);
        end

        -- CheckButton
        do
            local name = "Fade Out";
            local tooltip = "Fade out personal nameplate when out of combat";
            local cfg = "PersonalNameplateFade";
            local default = true;
            local flair = { classicEra = true, cata = true, retail = false };

            func:Create_CheckButton(panel, flair, name, tooltip, cfg, default);
        end

        -- Slider
        do
            local name = "Personal Nameplate Scale";
            local tooltip = "";
            local cfg = "PersonalNameplatesScale";
            local default = 1.00;
            local step = 0.01;
            local minValue = 0.75;
            local maxValue = 1.25;
            local decimals = 2;
            local flair = { classicEra = true, cata = true, retail = true };

            func:Create_Slider(panel, flair, name, tooltip, cfg, default, step, minValue, maxValue, decimals);
        end

        -- Slider
        do
            local name = "Personal Nameplate Position";
            local tooltip = "";
            local cfg = "PersonalNameplatePointY";
            local default = 380;
            local step = 1;
            local minValue = 1;
            local maxValue = 2000;
            local decimals = 0;
            local flair = { classicEra = false, cata = false, retail = false };

            func:Create_Slider(panel, flair, name, tooltip, cfg, default, step, minValue, maxValue, decimals);
        end

        -- Sub-Category
        func:Create_SubCategory(panel, "Special Power");

        -- CheckButton
        do
            local name = "Special Power";
            local tooltip = "Custom made special power bar: " .. white .. "Totems" .. gray .. "\nMore will be added later";
            local cfg = "SpecialPower";
            local default = true;
            local flair = { classicEra = true, cata = true, retail = true };

            func:Create_CheckButton(panel, flair, name, tooltip, cfg, default);
        end

        -- Slider
        do
            local name = "Special Power Scale";
            local tooltip = "";
            local cfg = "SpecialPowerScale";
            local default = 1.00;
            local step = 0.01;
            local minValue = 0.75;
            local maxValue = 1.25;
            local decimals = 2;
            local flair = { classicEra = true, cata = true, retail = true };

            func:Create_Slider(panel, flair, name, tooltip, cfg, default, step, minValue, maxValue, decimals);
        end

        -- Sub-Category
        func:Create_SubCategory(panel, "Health Bar Animation");

        -- CheckButton
        do
            local name = "Health Bar Animation";
            local tooltip = "Show the health bar draining and refilling animation";
            local cfg = "PersonalHealthBarAnimation";
            local default = true;
            local flair = { classicEra = true, cata = true, retail = true };

            func:Create_CheckButton(panel, flair, name, tooltip, cfg, default);
        end

        -- Slider
        do
            local name = "Health Bar Animation Threshold";
            local tooltip = "Animation Threshold (in percentage)";
            local cfg = "PersonalHealthBarAnimationThreshold";
            local default = 1.00;
            local step = 1;
            local minValue = 1;
            local maxValue = 99;
            local decimals = 0;
            local flair = { classicEra = true, cata = true, retail = true };

            func:Create_Slider(panel, flair, name, tooltip, cfg, default, step, minValue, maxValue, decimals);
        end

        -- Sub-Category
        func:Create_SubCategory(panel, "Power Bar Animation");

        -- CheckButton
        do
            local name = "Power Bar Animation";
            local tooltip = "Show the power bar draining and refilling animation";
            local cfg = "PersonalPowerBarAnimation";
            local default = true;
            local flair = { classicEra = true, cata = true, retail = true };

            func:Create_CheckButton(panel, flair, name, tooltip, cfg, default);
        end

        -- Slider
        do
            local name = "Power Bar Animation Threshold";
            local tooltip = "Animation Threshold (in percentage)";
            local cfg = "PersonalPowerBarAnimationThreshold";
            local default = 10.00;
            local step = 1;
            local minValue = 1;
            local maxValue = 99;
            local decimals = 0;
            local flair = { classicEra = true, cata = true, retail = true };

            func:Create_Slider(panel, flair, name, tooltip, cfg, default, step, minValue, maxValue, decimals);
        end

        -- Spacer
        func:Create_Spacer(panel);

        -- Anchoring settings
        func:AnchorFrames(panel);
    end

    -- CATEGORY: Class Related
    do
        -- Panel
        local panel = func:CreatePanel(panelMain.name, "Class Related");

        -- Spacer
        --func:Create_Spacer(panel);

        -- Sub-Category
        func:Create_SubCategory(panel, "Name & Guild", nil, "large");

        -- CheckButton
        do
            local name = "Friendly Players Class Color";
            local tooltip = "Friendly Name & Guild Class Color";
            local cfg = "FriendlyClassColorNamesAndGuild";
            local default = true;
            local flair = { classicEra = true, cata = true, retail = true };

            func:Create_CheckButton(panel, flair, name, tooltip, cfg, default);
        end

        -- CheckButton
        do
            local name = "Enemy Players Class Color";
            local tooltip = "Enemy Name & Guild Class Color";
            local cfg = "EnemyClassColorNamesAndGuild";
            local default = true;
            local flair = { classicEra = true, cata = true, retail = true };

            func:Create_CheckButton(panel, flair, name, tooltip, cfg, default);
        end

        -- Sub-Category
        func:Create_SubCategory(panel, "Icons", nil, "large");

        -- CheckButton
        do
            local name = "Friendly Players Class Icon";
            local tooltip = "";
            local cfg = "ClassIconsFriendly";
            local default = false;
            local flair = { classicEra = true, cata = true, retail = true };

            func:Create_CheckButton(panel, flair, name, tooltip, cfg, default);
        end

        -- CheckButton
        do
            local name = "Enemy Players Class Icon";
            local tooltip = "";
            local cfg = "ClassIconsEnemy";
            local default = true;
            local flair = { classicEra = true, cata = true, retail = true };

            func:Create_CheckButton(panel, flair, name, tooltip, cfg, default);
        end

        -- Sub-Category
        func:Create_SubCategory(panel, "Health Bar", nil, "large");

        -- CheckButton
        do
            local name = "Frienly Players Healthbar Class Color";
            local tooltip = "";
            local cfg = "HealthBarClassColorsFriendly";
            local default = true;
            local flair = { classicEra = true, cata = true, retail = true };

            func:Create_CheckButton(panel, flair, name, tooltip, cfg, default);
        end

        -- CheckButton
        do
            local name = "Enemy Players Healthbar Class Color";
            local tooltip = "";
            local cfg = "HealthBarClassColorsEnemy";
            local default = true;
            local flair = { classicEra = true, cata = true, retail = true };

            func:Create_CheckButton(panel, flair, name, tooltip, cfg, default);
        end

        -- Spacer
        func:Create_Spacer(panel);

        -- Anchoring settings
        func:AnchorFrames(panel);
    end

    -- CATEGORY: Names Only
    do
        -- Panel
        local panel = func:CreatePanel(panelMain.name, "Names Only");

        -- Sub-Category
        func:Create_SubCategory(panel, "General");

        -- CheckButton
        do
            local name = "Always Show Target's Nameplate";
            local tooltip = "";
            local cfg = "NamesOnlyAlwaysShowTargetsNameplate";
            local default = true;
            local flair = { classicEra = true, cata = true, retail = true };

            func:Create_CheckButton(panel, flair, name, tooltip, cfg, default);
        end

        -- Sub-Category
        func:Create_SubCategory(panel, "Friendlies");

        -- CheckButton
        do
            local name = "Friendly Players";
            local tooltip = "";
            local cfg = "NamesOnlyFriendlyPlayers";
            local default = false;
            local flair = { classicEra = true, cata = true, retail = true };

            func:Create_CheckButton(panel, flair, name, tooltip, cfg, default);
        end

        -- CheckButton
        do
            local name = "Friendly Pets";
            local tooltip = "";
            local cfg = "NamesOnlyFriendlyPets";
            local default = false;
            local flair = { classicEra = true, cata = true, retail = true };

            func:Create_CheckButton(panel, flair, name, tooltip, cfg, default);
        end

        -- CheckButton
        do
            local name = "Friendly NPC";
            local tooltip = "";
            local cfg = "NamesOnlyFriendlyNPC";
            local default = false;
            local flair = { classicEra = true, cata = true, retail = true };

            func:Create_CheckButton(panel, flair, name, tooltip, cfg, default);
        end

        -- CheckButton
        do
            local name = "Friendly Totems";
            local tooltip = "";
            local cfg = "NamesOnlyFriendlyTotems";
            local default = false;
            local flair = { classicEra = true, cata = true, retail = true };

            func:Create_CheckButton(panel, flair, name, tooltip, cfg, default);
        end

        -- Sub-Category
        func:Create_SubCategory(panel, "Enemies");

        -- CheckButton
        do
            local name = "Enemy Players";
            local tooltip = "";
            local cfg = "NamesOnlyEnemyPlayers";
            local default = false;
            local flair = { classicEra = true, cata = true, retail = true };

            func:Create_CheckButton(panel, flair, name, tooltip, cfg, default);
        end

        -- CheckButton
        do
            local name = "Enemy Pets";
            local tooltip = "";
            local cfg = "NamesOnlyEnemyPets";
            local default = false;
            local flair = { classicEra = true, cata = true, retail = true };

            func:Create_CheckButton(panel, flair, name, tooltip, cfg, default);
        end

        -- CheckButton
        do
            local name = "Enemy NPC";
            local tooltip = "";
            local cfg = "NamesOnlyEnemyNPC";
            local default = false;
            local flair = { classicEra = true, cata = true, retail = true };

            func:Create_CheckButton(panel, flair, name, tooltip, cfg, default);
        end

        -- CheckButton
        do
            local name = "Enemy Totems";
            local tooltip = "";
            local cfg = "NamesOnlyEnemyTotems";
            local default = false;
            local flair = { classicEra = true, cata = true, retail = true };

            func:Create_CheckButton(panel, flair, name, tooltip, cfg, default);
        end

        -- Sub-Category
        func:Create_SubCategory(panel, "Exclusions");

        -- CheckButton
        do
            local name = "Exclude Friends";
            local tooltip = "";
            local cfg = "NamesOnlyExcludeFriends";
            local default = false;
            local flair = { classicEra = true, cata = true, retail = true };

            func:Create_CheckButton(panel, flair, name, tooltip, cfg, default);
        end

        -- CheckButton
        do
            local name = "Exclude Guild Members";
            local tooltip = "";
            local cfg = "NamesOnlyExcludeGuild";
            local default = false;
            local flair = { classicEra = true, cata = true, retail = true };

            func:Create_CheckButton(panel, flair, name, tooltip, cfg, default);
        end

        -- CheckButton
        do
            local name = "Exclude Party Members";
            local tooltip = "";
            local cfg = "NamesOnlyExcludeParty";
            local default = false;
            local flair = { classicEra = true, cata = true, retail = true };

            func:Create_CheckButton(panel, flair, name, tooltip, cfg, default);
        end

        -- CheckButton
        do
            local name = "Exclude Raid Members";
            local tooltip = "";
            local cfg = "NamesOnlyExcludeRaid";
            local default = false;
            local flair = { classicEra = true, cata = true, retail = true };

            func:Create_CheckButton(panel, flair, name, tooltip, cfg, default);
        end

        -- Spacer
        func:Create_Spacer(panel);

        -- Anchoring settings
        func:AnchorFrames(panel);
    end

    -- CATEGORY: Auras
    do
        -- Panel
        local panel = func:CreatePanel(panelMain.name, "Auras");

        -- Sub-Category
        func:Create_SubCategory(panel, "General");

        -- CheckButton
        do
            local name = "Countdown";
            local tooltip = "";
            local cfg = "AurasCountdown";
            local default = true;
            local flair = { classicEra = true, cata = true, retail = true };

            func:Create_CheckButton(panel, flair, name, tooltip, cfg, default);
        end

        -- DropDownMenu
        do
            local name = "Countdown position";
            local tooltip = "";
            local cfg = "AurasCountdownPosition";
            local default = 1;
            local options = {
                [1] = "Top Right",
                [2] = "Center"
            }
            local flair = { classicEra = true, cata = true, retail = true };

            func:Create_DropDownMenu(panel, flair, name, tooltip, cfg, default, options);
        end

        -- CheckButton
        do
            local name = "Reverse Cooldown Swipe Animation";
            local tooltip = "";
            local cfg = "AurasReverseAnimation";
            local default = true;
            local flair = { classicEra = true, cata = true, retail = true };

            func:Create_CheckButton(panel, flair, name, tooltip, cfg, default);
        end

        -- CheckButton
        do
            local name = "Mark Your Auras";
            local tooltip = "";
            local cfg = "AurasMarkYours";
            local default = true;
            local flair = { classicEra = true, cata = true, retail = true };

            func:Create_CheckButton(panel, flair, name, tooltip, cfg, default);
        end

        -- ColorPicker
        do
            local name = "Mark Color";
            local tooltip = "";
            local cfg = "AurasMarkColor";
            local default = {r = 1, g = 1, b = 0, a = 1};
            local flair = { classicEra = true, cata = true, retail = true };

            func:Create_ColorPicker(panel, flair, name, tooltip, cfg, default);
        end

        -- DropDownMenu
        do
            local name = "Mark Location";
            local tooltip = "Hide auras without expiration time";
            local cfg = "AurasMarkLocation";
            local default = 1;
            local options = {
                [1] = "Top left",
                [2] = "Bottom left",
            }
            local flair = { classicEra = true, cata = true, retail = true };

            func:Create_DropDownMenu(panel, flair, name, tooltip, cfg, default, options);
        end

        -- CheckButton
        do
            local name = "Important Auras Highlight";
            local tooltip = "";
            local cfg = "AurasImportantHighlight";
            local default = true;
            local flair = { classicEra = true, cata = true, retail = true };

            func:Create_CheckButton(panel, flair, name, tooltip, cfg, default);
        end

        -- Sub-Category
        func:Create_SubCategory(panel, "Filters");

        -- CheckButton
        do
            local name = "Show Only Important Auras";
            local tooltip = "";
            local cfg = "AurasShowOnlyImportant";
            local default = false;
            local flair = { classicEra = true, cata = true, retail = true };

            func:Create_CheckButton(panel, flair, name, tooltip, cfg, default);
        end

        -- CheckButton
        do
            local name = "Show Auras On Target Only";
            local tooltip = "";
            local cfg = "AurasOnTarget";
            local default = true;
            local flair = { classicEra = true, cata = true, retail = true };

            func:Create_CheckButton(panel, flair, name, tooltip, cfg, default);
        end

        -- Spacer
        func:Create_Spacer(panel, "small");

        -- CheckButton
        do
            local name = "Show Buffs On Friendlies";
            local tooltip = "";
            local cfg = "BuffsFriendly";
            local default = true;
            local flair = { classicEra = true, cata = true, retail = true };

            func:Create_CheckButton(panel, flair, name, tooltip, cfg, default);
        end

        -- CheckButton
        do
            local name = "Show Debuffs On Friendlies";
            local tooltip = "";
            local cfg = "DebuffsFriendly";
            local default = true;
            local flair = { classicEra = true, cata = true, retail = true };

            func:Create_CheckButton(panel, flair, name, tooltip, cfg, default);
        end

        -- CheckButton
        do
            local name = "Show Buffs On Enemies";
            local tooltip = "";
            local cfg = "BuffsEnemy";
            local default = true;
            local flair = { classicEra = true, cata = true, retail = true };

            func:Create_CheckButton(panel, flair, name, tooltip, cfg, default);
        end

        -- CheckButton
        do
            local name = "Show Debuffs On Enemies";
            local tooltip = "";
            local cfg = "DebuffsEnemy";
            local default = true;
            local flair = { classicEra = true, cata = true, retail = true };

            func:Create_CheckButton(panel, flair, name, tooltip, cfg, default);
        end

        -- Spacer
        func:Create_Spacer(panel, "small");

        -- CheckButton
        do
            local name = "Show Buffs On Personal Namplate";
            local tooltip = "";
            local cfg = "BuffsPersonal";
            local default = true;
            local flair = { classicEra = true, cata = true, retail = true };

            func:Create_CheckButton(panel, flair, name, tooltip, cfg, default);
        end

        -- CheckButton
        do
            local name = "Show Debuffs On Personal Namplate";
            local tooltip = "";
            local cfg = "DebuffsPersonal";
            local default = true;
            local flair = { classicEra = true, cata = true, retail = true };

            func:Create_CheckButton(panel, flair, name, tooltip, cfg, default);
        end

        -- Spacer
        func:Create_Spacer(panel, "small");

        -- DropDownMenu
        do
            local name = "Passive Auras";
            local tooltip = "Hide auras without expiration time";
            local cfg = "AurasHidePassive";
            local default = 1;
            local options = {
                [1] = "Show all",
                [2] = "Hide all",
                [3] = "Show only your own"
            }
            local flair = { classicEra = true, cata = true, retail = true };

            func:Create_DropDownMenu(panel, flair, name, tooltip, cfg, default, options);
        end

        -- DropDownMenu
        do
            local name = "Auras On Frindlies";
            local tooltip = "";
            local cfg = "AurasFilterFriendly";
            local default = 1;
            local options = {
                [1] = "Show all auras",
                [2] = "Show auras applied by you",
                [3] = "Show auras you can apply and dispell"
            }
            local flair = { classicEra = true, cata = true, retail = true };

            func:Create_DropDownMenu(panel, flair, name, tooltip, cfg, default, options);
        end

        -- DropDownMenu
        do
            local name = "Auras On Enemies";
            local tooltip = "";
            local cfg = "AurasFilterEnemy";
            local default = 1;
            local options = {
                [1] = "Show all auras",
                [2] = "Show auras applied by you"
            }
            local flair = { classicEra = true, cata = true, retail = true };

            func:Create_DropDownMenu(panel, flair, name, tooltip, cfg, default, options);
        end

        -- DropDownMenu
        do
            local name = "Personal Nameplate Buffs";
            local tooltip = "";
            local cfg = "BuffsFilterPersonal";
            local default = 1;
            local options = {
                [1] = "Show all buffs",
                [2] = "Show buffs applied by you",
                [3] = "Show buffs you can apply and applied"
            }
            local flair = { classicEra = true, cata = true, retail = true };

            func:Create_DropDownMenu(panel, flair, name, tooltip, cfg, default, options);
        end

        -- DropDownMenu
        do
            local name = "Personal Nameplate Debuffs";
            local tooltip = "";
            local cfg = "DebuffsFilterPersonal";
            local default = 1;
            local options = {
                [1] = "Show all debuffs",
                [2] = "Show debuffs you can dispell"
            }
            local flair = { classicEra = true, cata = true, retail = true };

            func:Create_DropDownMenu(panel, flair, name, tooltip, cfg, default, options);
        end

        -- Spacer
        func:Create_Spacer(panel, "small");

        -- DropDownMenu
        do
            local name = "Group Filter";
            local tooltip = "";
            local cfg = "AurasGroupFilter";
            local default = 1;
            local options = {
                [1] = "Show buffs for Everyone",
                [2] = "Show buffs for Party Members",
                [3] = "Show buffs for Raid Members",
                [4] = "Show buffs for Party & Raid members"
            }
            local flair = { classicEra = true, cata = true, retail = true };

            func:Create_DropDownMenu(panel, flair, name, tooltip, cfg, default, options);
        end

        -- CheckButton
        do
            local name = "Exclude Target";
            local tooltip = "Exclude target from group filtering";
            local cfg = "AurasGroupFilterExcludeTarget";
            local default = true;
            local flair = { classicEra = true, cata = true, retail = true };

            func:Create_CheckButton(panel, flair, name, tooltip, cfg, default);
        end

        -- Sub-Category
        func:Create_SubCategory(panel, "Tooltip");

        -- DropDownMenu
        do
            local name = "Tooltip";
            local tooltip = "";
            local cfg = "Tooltip";
            local default = 1;
            local options = {
                [1] = "Hold SHIFT",
                [2] = "Hold CTRL",
                [3] = "Hold ALT",
                [4] = "Disabled"
            }
            local flair = { classicEra = true, cata = true, retail = true };

            func:Create_DropDownMenu(panel, flair, name, tooltip, cfg, default, options);
        end

        -- CheckButton
        do
            local name = "Show Spell ID on Tooltip";
            local tooltip = "";
            local cfg = "TooltipSpellID";
            local default = true;
            local flair = { classicEra = true, cata = true, retail = true };

            func:Create_CheckButton(panel, flair, name, tooltip, cfg, default);
        end

        -- Sub-Category
        func:Create_SubCategory(panel, "Auras Limits");

        -- CheckButton
        do
            local name = "Auras Overflow Counter";
            local tooltip = "";
            local cfg = "AurasOverFlowCounter";
            local default = true;
            local flair = { classicEra = true, cata = true, retail = true };

            func:Create_CheckButton(panel, flair, name, tooltip, cfg, default);
        end

        -- Sub-Category
        func:Create_SubCategory(panel, "Friendlies", nil, "small");

        -- Slider
        do
            local name = "Max Buffs";
            local tooltip = "";
            local cfg = "AurasMaxBuffsFriendly";
            local default = 4;
            local step = 1;
            local minValue = 1;
            local maxValue = 16;
            local decimals = 0;
            local flair = { classicEra = true, cata = true, retail = true };

            func:Create_Slider(panel, flair, name, tooltip, cfg, default, step, minValue, maxValue, decimals);
        end

        -- Slider
        do
            local name = "Max Debuffs";
            local tooltip = "";
            local cfg = "AurasMaxDebuffsFriendly";
            local default = 2;
            local step = 1;
            local minValue = 1;
            local maxValue = 16;
            local decimals = 0;
            local flair = { classicEra = true, cata = true, retail = true };

            func:Create_Slider(panel, flair, name, tooltip, cfg, default, step, minValue, maxValue, decimals);
        end

        -- Sub-Category
        func:Create_SubCategory(panel, "Enemies", nil, "small");

        -- Slider
        do
            local name = "Max Buffs";
            local tooltip = "";
            local cfg = "AurasMaxBuffsEnemy";
            local default = 2;
            local step = 1;
            local minValue = 1;
            local maxValue = 16;
            local decimals = 0;
            local flair = { classicEra = true, cata = true, retail = true };

            func:Create_Slider(panel, flair, name, tooltip, cfg, default, step, minValue, maxValue, decimals);
        end

        -- Slider
        do
            local name = "Max Debuffs";
            local tooltip = "";
            local cfg = "AurasMaxDebuffsEnemy";
            local default = 4;
            local step = 1;
            local minValue = 1;
            local maxValue = 16;
            local decimals = 0;
            local flair = { classicEra = true, cata = true, retail = true };

            func:Create_Slider(panel, flair, name, tooltip, cfg, default, step, minValue, maxValue, decimals);
        end

        -- Sub-Category
        func:Create_SubCategory(panel, "Personal Nameplate Auras", nil, "small");

        -- Slider
        do
            local name = "Max Buffs";
            local tooltip = "";
            local cfg = "AurasPersonalMaxBuffs";
            local default = 6;
            local step = 1;
            local minValue = 1;
            local maxValue = 16;
            local decimals = 0;
            local flair = { classicEra = true, cata = true, retail = true };

            func:Create_Slider(panel, flair, name, tooltip, cfg, default, step, minValue, maxValue, decimals);
        end

        -- Slider
        do
            local name = "Max Debuffs";
            local tooltip = "";
            local cfg = "AurasPersonalMaxDebuffs";
            local default = 6;
            local step = 1;
            local minValue = 1;
            local maxValue = 16;
            local decimals = 0;
            local flair = { classicEra = true, cata = true, retail = true };

            func:Create_Slider(panel, flair, name, tooltip, cfg, default, step, minValue, maxValue, decimals);
        end

        -- Sub-Category
        func:Create_SubCategory(panel, "Scale");

        -- Slider
        do
            local name = "Regular Auras Scale";
            local tooltip = "";
            local cfg = "AurasScale";
            local default = 1.00;
            local step = 0.01;
            local minValue = 0.75;
            local maxValue = 1.25;
            local decimals = 2;
            local flair = { classicEra = true, cata = true, retail = true };

            func:Create_Slider(panel, flair, name, tooltip, cfg, default, step, minValue, maxValue, decimals);
        end

        -- Slider
        do
            local name = "Important Auras Scale";
            local tooltip = "";
            local cfg = "AurasImportantScale";
            local default = 1.25;
            local step = 0.01;
            local minValue = 0.75;
            local maxValue = 1.5;
            local decimals = 2;
            local flair = { classicEra = true, cata = true, retail = true };

            func:Create_Slider(panel, flair, name, tooltip, cfg, default, step, minValue, maxValue, decimals);
        end

        -- Spacer
        func:Create_Spacer(panel);

        -- Anchoring settings
        func:AnchorFrames(panel);
    end

    -- CATEGORY: Important Auras
    do
        -- Panel
        local panel = func:CreatePanel(panelMain.name, "Important Auras List");

        -- Spacer
        func:Create_Spacer(panel);

        -- Auras List
        do
            local name = "Important Auras";
            local cfg = "AurasImportantList";

            func:Create_AurasList(panel, name, cfg);
        end

        -- Anchoring settings
        func:AnchorFrames(panel);
    end

    -- CATEGORY: Blacklisted Auras
    do
        -- Panel
        local panel = func:CreatePanel(panelMain.name, "Blacklisted Auras List");

        -- Spacer
        func:Create_Spacer(panel);

        -- Auras List
        do
            local name = "Blacklisted Auras";
            local cfg = "AurasBlacklist";

            func:Create_AurasList(panel, name, cfg);
        end

        -- Anchoring settings
        func:AnchorFrames(panel);
    end

    -- CATEGORY: Threat
    do
        -- Panel
        local panel = func:CreatePanel(panelMain.name, "Threat");

        -- Sub-Category
        func:Create_SubCategory(panel, "General");

        -- CheckButton
        do
            local name = "Threat Percentage";
            local tooltip = "Display the amount of threat generated";
            local cfg = "ThreatPercentage";
            local default = true;
            local flair = { classicEra = true, cata = true, retail = true };

            func:Create_CheckButton(panel, flair, name, tooltip, cfg, default);
        end

        -- CheckButton
        do
            local name = "Change Color Based On Threat Percentage";
            local tooltip = "The less threat you have the lighter the color gets";
            local cfg = "ThreatColorBasedOnPercentage";
            local default = true;
            local flair = { classicEra = true, cata = true, retail = true };

            func:Create_CheckButton(panel, flair, name, tooltip, cfg, default);
        end

        -- CheckButton
        do
            local name = "Highlight";
            local tooltip = "Highlight nameplates depending on threat situation";
            local cfg = "ThreatHighlight";
            local default = true;
            local flair = { classicEra = true, cata = true, retail = true };

            func:Create_CheckButton(panel, flair, name, tooltip, cfg, default);
        end

        -- ColorPicker
        do
            local name = "Aggro Color";
            local tooltip = "";
            local cfg = "ThreatAggroColor";
            local default = {r = 1, g = 0, b = 1, a = 1};
            local flair = { classicEra = true, cata = true, retail = true };

            func:Create_ColorPicker(panel, flair, name, tooltip, cfg, default);
        end

        -- ColorPicker
        do
            local name = "Other Tank Color";
            local tooltip = "Color for when another tank is tanking";
            local cfg = "ThreatOtherTankColor";
            local default = {r = 0, g = 0.58, b = 1, a = 1};
            local flair = { classicEra = true, cata = true, retail = true };

            func:Create_ColorPicker(panel, flair, name, tooltip, cfg, default);
        end

        -- Sub-Category
        func:Create_SubCategory(panel, "Threat Warning");

        -- CheckButton
        do
            local name = "Enable";
            local tooltip = "";
            local cfg = "ThreatWarning";
            local default = true;
            local flair = { classicEra = true, cata = true, retail = true };

            func:Create_CheckButton(panel, flair, name, tooltip, cfg, default);
        end

        -- Slider
        do
            local name = "Threshold";
            local tooltip = "";
            local cfg = "ThreatWarningThreshold";
            local default = 75;
            local step = 1;
            local minValue = 1;
            local maxValue = 100;
            local decimals = 0;
            local flair = { classicEra = true, cata = true, retail = true };

            func:Create_Slider(panel, flair, name, tooltip, cfg, default, step, minValue, maxValue, decimals);
        end

        -- ColorPicker
        do
            local name = "Warning Color";
            local tooltip = "";
            local cfg = "ThreatWarningColor";
            local default = {r = 1, g = 0.6, b = 0, a = 1};
            local flair = { classicEra = true, cata = true, retail = true };

            func:Create_ColorPicker(panel, flair, name, tooltip, cfg, default);
        end

        -- Spacer
        func:Create_Spacer(panel);

        -- Anchoring settings
        func:AnchorFrames(panel);
    end

    -- CATEGORY: Cast Bar
    do
        -- Panel
        local panel = func:CreatePanel(panelMain.name, "Cast Bar");

        -- Spacer
        func:Create_Spacer(panel);

        -- CheckButton
        do
            local name = "Show Cast bar";
            local tooltip = "";
            local cfg = "CastbarShow";
            local default = true;
            local flair = { classicEra = true, cata = false, retail = false };

            func:Create_CheckButton(panel, flair, name, tooltip, cfg, default);
        end

        -- CheckButton
        do
            local name = "Show Cast Bar Icon";
            local tooltip = "";
            local cfg = "CastbarIconShow";
            local default = true;
            local flair = { classicEra = true, cata = true, retail = true };

            func:Create_CheckButton(panel, flair, name, tooltip, cfg, default);
        end

        -- Slider
        do
            local name = "Castbar Scale";
            local tooltip = "";
            local cfg = "CastbarScale";
            local default = 1;
            local step = 0.01;
            local minValue = 0.75;
            local maxValue = 1.25;
            local decimals = 2;
            local flair = { classicEra = true, cata = true, retail = true };

            func:Create_Slider(panel, flair, name, tooltip, cfg, default, step, minValue, maxValue, decimals);
        end

        -- Slider
        do
            local name = "Castbar Position (vertical)";
            local tooltip = "";
            local cfg = "CastbarPositionY";
            local default = 2;
            local step = 1;
            local minValue = 0;
            local maxValue = 50;
            local decimals = 0;
            local flair = { classicEra = true, cata = true, retail = true };

            func:Create_Slider(panel, flair, name, tooltip, cfg, default, step, minValue, maxValue, decimals);
        end

        -- Spacer
        func:Create_Spacer(panel);

        -- Anchoring settings
        func:AnchorFrames(panel);
    end

    -- CATEGORY: Fonts
    do
        -- Panel
        local panel = func:CreatePanel(panelMain.name, "Fonts");

        -- Sub-Category
        func:Create_SubCategory(panel, "General");

        -- CheckButton
        do
            local name = "Name & Guild Outline";
            local tooltip = "";
            local cfg = "NameAndGuildOutline";
            local default = true;
            local flair = { classicEra = true, cata = true, retail = true };

            func:Create_CheckButton(panel, flair, name, tooltip, cfg, default);
        end

        -- CheckButton
        do
            local name = "Large Name";
            local tooltip = "";
            local cfg = "LargeName";
            local default = true;
            local flair = { classicEra = true, cata = true, retail = true };

            func:Create_CheckButton(panel, flair, name, tooltip, cfg, default);
        end

        -- CheckButton
        do
            local name = "Large Guild Name";
            local tooltip = "";
            local cfg = "LargeGuildName";
            local default = false;
            local flair = { classicEra = true, cata = true, retail = true };

            func:Create_CheckButton(panel, flair, name, tooltip, cfg, default);
        end

        -- Sub-Category
        func:Create_SubCategory(panel, "Health & Power");

        -- CheckButton
        do
            local name = "Large Main Health Value";
            local tooltip = "";
            local cfg = "LargeMainValue";
            local default = true;
            local flair = { classicEra = true, cata = true, retail = true };

            func:Create_CheckButton(panel, flair, name, tooltip, cfg, default);
        end

        -- ColorPicker
        do
            local name = "Font Color";
            local tooltip = "";
            local cfg = "HealthFontColor";
            local default = {r = 1, g = 0.82, b = 0, a = 1};
            local flair = { classicEra = true, cata = true, retail = true };

            func:Create_ColorPicker(panel, flair, name, tooltip, cfg, default);
        end

        -- Spacer
        func:Create_Spacer(panel);

        -- Anchoring settings
        func:AnchorFrames(panel);
    end

    -- CATEGORY: Border
    do
        -- Panel
        local panel = func:CreatePanel(panelMain.name, "Borders");

        -- Sub-Category
        func:Create_SubCategory(panel, "Nameplates Border Color");

        -- ColorPicker
        do
            local name = "Color";
            local tooltip = "";
            local cfg = "BorderColor";
            local default = {r = 0.75, g = 0.60, b = 0, a = 1};
            local flair = { classicEra = true, cata = true, retail = true };

            func:Create_ColorPicker(panel, flair, name, tooltip, cfg, default);
        end

        -- Sub-Category
        func:Create_SubCategory(panel, "Auras Border Color");

        -- Sub-Category
        func:Create_SubCategory(panel, "Buffs", nil, "small");

        -- ColorPicker
        do
            local name = "Regular";
            local tooltip = "";
            local cfg = "AurasHelpfulBorderColor";
            local default = {r = 0.85, g = 0.7, b = 0, a = 1};
            local flair = { classicEra = true, cata = true, retail = true };

            func:Create_ColorPicker(panel, flair, name, tooltip, cfg, default);
        end

        -- ColorPicker
        do
            local name = "Stealable Auras";
            local tooltip = "";
            local cfg = "AurasStealableBorderColor";
            local default = {r = 0.6, g = 0.79, b = 1, a = 1};
            local flair = { classicEra = true, cata = true, retail = true };

            func:Create_ColorPicker(panel, flair, name, tooltip, cfg, default);
        end

        -- Sub-Category
        func:Create_SubCategory(panel, "Debuffs", nil, "small");

        -- ColorPicker
        do
            local name = "Regular";
            local tooltip = "";
            local cfg = "Auras_HarmfulBorderColor_Regular";
            local default = {r = 0.8, g = 0, b = 0, a = 1};
            local flair = { classicEra = true, cata = true, retail = true };

            func:Create_ColorPicker(panel, flair, name, tooltip, cfg, default);
        end

        -- ColorPicker
        do
            local name = "Magic";
            local tooltip = "";
            local cfg = "Auras_HarmfulBorderColor_Magic";
            local default = {r = 0.8, g = 0, b = 0, a = 1};
            local flair = { classicEra = true, cata = true, retail = true };

            func:Create_ColorPicker(panel, flair, name, tooltip, cfg, default);
        end

        -- ColorPicker
        do
            local name = "Curse";
            local tooltip = "";
            local cfg = "Auras_HarmfulBorderColor_Curse";
            local default = {r = 0.8, g = 0, b = 0, a = 1};
            local flair = { classicEra = true, cata = true, retail = true };

            func:Create_ColorPicker(panel, flair, name, tooltip, cfg, default);
        end

        -- ColorPicker
        do
            local name = "Disease";
            local tooltip = "";
            local cfg = "Auras_HarmfulBorderColor_Disease";
            local default = {r = 0.8, g = 0, b = 0, a = 1};
            local flair = { classicEra = true, cata = true, retail = true };

            func:Create_ColorPicker(panel, flair, name, tooltip, cfg, default);
        end

        -- ColorPicker
        do
            local name = "Poison";
            local tooltip = "";
            local cfg = "Auras_HarmfulBorderColor_Poison";
            local default = {r = 0.8, g = 0, b = 0, a = 1};
            local flair = { classicEra = true, cata = true, retail = true };

            func:Create_ColorPicker(panel, flair, name, tooltip, cfg, default);
        end

        -- Sub-Category
        func:Create_SubCategory(panel, "Personal Nameplate Debuffs", nil, "small");

        -- ColorPicker
        do
            local name = "Regular";
            local tooltip = "";
            local cfg = "Auras_Personal_HarmfulBorderColor_Regular";
            local default = {r = 0.8, g = 0, b = 0, a = 1};
            local flair = { classicEra = true, cata = true, retail = true };

            func:Create_ColorPicker(panel, flair, name, tooltip, cfg, default);
        end

        -- ColorPicker
        do
            local name = "Magic";
            local tooltip = "";
            local cfg = "Auras_Personal_HarmfulBorderColor_Magic";
            local default = {r = 0.2, g = 0.6, b = 1, a = 1};
            local flair = { classicEra = true, cata = true, retail = true };

            func:Create_ColorPicker(panel, flair, name, tooltip, cfg, default);
        end

        -- ColorPicker
        do
            local name = "Curse";
            local tooltip = "";
            local cfg = "Auras_Personal_HarmfulBorderColor_Curse";
            local default = {r = 0.6, g = 0, b = 1, a = 1};
            local flair = { classicEra = true, cata = true, retail = true };

            func:Create_ColorPicker(panel, flair, name, tooltip, cfg, default);
        end

        -- ColorPicker
        do
            local name = "Disease";
            local tooltip = "";
            local cfg = "Auras_Personal_HarmfulBorderColor_Disease";
            local default = {r = 0.6, g = 0.4, b = 0, a = 1};
            local flair = { classicEra = true, cata = true, retail = true };

            func:Create_ColorPicker(panel, flair, name, tooltip, cfg, default);
        end

        -- ColorPicker
        do
            local name = "Poison";
            local tooltip = "";
            local cfg = "Auras_Personal_HarmfulBorderColor_Poison";
            local default = {r = 0, g = 0.6, b = 0, a = 1};
            local flair = { classicEra = true, cata = true, retail = true };

            func:Create_ColorPicker(panel, flair, name, tooltip, cfg, default);
        end

        -- Spacer
        func:Create_Spacer(panel);

        -- Anchoring settings
        func:AnchorFrames(panel);
    end

    -- CATEGORY: Profiles
    do
        -- Panel
        local panel = func:CreatePanel(panelMain.name, "Profiles");

        -- Spacer
        func:Create_Spacer(panel);

        -- Auras List
        do
            local name = "Profiles";
            local cfg = "Profiles";
            local default = "Default";

            func:Create_Profiles(panel, name, cfg, default);
        end

        -- Anchoring settings
        func:AnchorFrames(panel);
    end

    ---------------------------------------
    -- Adding panels
    ---------------------------------------
    local mainCategory = Settings.RegisterCanvasLayoutCategory(panelMain, panelMain.name)

    for k, v in ipairs(data.settings.panels) do
        if k and v.name ~= panelMain.name then
            Settings.RegisterCanvasLayoutSubcategory(mainCategory, v, v.name)
        end
    end

    Settings.RegisterAddOnCategory(mainCategory)
end