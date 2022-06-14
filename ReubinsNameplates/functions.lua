----------------------------------------
-- NAMESPACES
----------------------------------------
local myAddon, core = ...
core.func = {};
core.frames = { strata = {}, threat = {}, health = {}, tanks = {}, members = {}, combat = UnitAffectingCombat("player") };
local func = core.func;
local frames = core.frames;

----------------------------------------
-- FORMATING NUMBER
----------------------------------------
local function format_number(number)
    if number >= 10^6 then
        return string.format("%.2fm", number / 10^6)
    elseif number >= 10^4 then
        return string.format("%.0fk", number / 10^3)
    elseif number >= 10^3 then
        return string.format("%.1fk", number / 10^3)
    else
        return tostring(number)
    end
end

----------------------------------------
-- THREAT VISIBILITY TOGGLE
----------------------------------------
function func:Threat_Toggle()
    if frames.combat then
        if ReubinsNameplates_settings.Threat_Visibility == "Always" then
            return true;
        end
        if ReubinsNameplates_settings.Threat_Visibility == "Solo" and not IsInGroup() then
            return true;
        else
            return false;
        end
        if ReubinsNameplates_settings.Threat_Visibility == "Party & Raid" and IsInGroup() then
            return true;
        else
            return false;
        end
        if ReubinsNameplates_settings.Threat_Visibility == "Never" then
            return false;
        end
    else
        return false;
    end
end

----------------------------------------
-- THREAT ICON TOGGLE
----------------------------------------
function func:threat_icon_toggle()
    if not ReubinsNameplates_settings.Tank then
        return "Interface\\addons\\ReubinsNameplates\\media\\aggro";
    else
        return "Interface\\addons\\ReubinsNameplates\\media\\tanking";
    end
end

----------------------------------------
-- ADDING NAMEPLATE
----------------------------------------
function func:Add_Nameplate(unit)
    if not UnitIsPlayer(unit) and not UnitIsOtherPlayersPet(unit) then
        local f = CreateFrame("Frame", nil, UIParent);
        local nameplate = C_NamePlate.GetNamePlateForUnit(unit);

        -- Strata
        if not frames.strata[unit] then
            f.Strata = CreateFrame("Frame", nil, nameplate);
            f.Strata:SetFrameStrata("DIALOG");
            frames.strata[unit] = f.Strata;
        else
            frames.strata[unit]:SetParent(nameplate);
        end
        
        -- Threat
        if not frames.threat[unit] then
            f.Threat = f:CreateTexture(nil, "ARTWORK");
            f.Threat:SetParent(nameplate);
            f.Threat:SetPoint("LEFT", nameplate, "RIGHT", -1, -7);
            f.Threat:SetTexture(func:threat_icon_toggle());
            f.Threat:SetSize(22, 22);
            f.Threat:SetShown(func:Threat_Toggle());
            frames.threat[unit] = f.Threat;
            func:Update_Threat(unit); -- Checking threat
        else
            frames.threat[unit]:SetParent(nameplate);
            frames.threat[unit]:SetPoint("LEFT", nameplate, "RIGHT", -1, -7);
            frames.threat[unit]:SetTexture(func:threat_icon_toggle());
            frames.threat[unit]:SetShown(func:Threat_Toggle());
            func:Update_Threat(unit); -- Checking threat
        end
        
        -- Health
        if not frames.health[unit] then
            f.Health = f:CreateFontString(nil, "OVERLAY");
            f.Health:SetPoint("CENTER", nameplate, "CENTER", 0, -7);
            f.Health:SetParent(frames.strata[unit]);
            f.Health:SetIgnoreParentScale(true);
            f.Health:SetFont("Fonts\\FRIZQT__.TTF", ReubinsNameplates_settings.FontSize, "OUTLINE");
            f.Health:SetTextColor(1, 0.99, 0.32);
            f.Health:SetShadowColor(0, 0, 0, 1);
            f.Health:SetShadowOffset(1, -1);
            f.Health:SetText(format_number(UnitHealth(unit)));
            f.Health:SetShown(ReubinsNameplates_settings.Show_Health);
            frames.health[unit] = f.Health;
        else
            frames.health[unit]:SetPoint("CENTER", nameplate, "CENTER", 0, -7);
            frames.health[unit]:SetParent(frames.strata[unit]);
            frames.health[unit]:SetText(format_number(UnitHealth(unit)));
            frames.health[unit]:SetShown(ReubinsNameplates_settings.Show_Health);
        end

    end
end

----------------------------------------
-- REMOVING NAMEPLATE
----------------------------------------
function func:Remove_Nameplate(unit)
    
    -- Strata
    if frames.strata[unit] then
        frames.strata[unit]:ClearAllPoints();
    end

    -- Threat
    if frames.threat[unit] then
        frames.threat[unit]:Hide();
        frames.threat[unit]:ClearAllPoints();
        frames.threat[unit]:SetVertexColor(0, 0, 0, 0);
    end

    -- Health
    if frames.health[unit] then
        frames.health[unit]:Hide();
        frames.health[unit]:ClearAllPoints();
    end
end

----------------------------------------
-- ASSIGNING TANKS
----------------------------------------
function func:Roster_Update()
    if IsInGroup() then
        frames.tanks = {}; -- Reseting table
        for i = 1, GetNumGroupMembers() do
            frames.members["raid"..i] = UnitName("raid"..i);

            if GetPartyAssignment("MainTank" ,"raid"..i, true) then
                if not UnitIsUnit("raid"..i, "player") then
                    local unit = UnitName("raid"..i);
                    frames.tanks[unit] = UnitName(unit);
                end
            end
        end
    end
end

----------------------------------------
-- UPDATING DATA
----------------------------------------

-- Health
function func:Update_Health(unit)
    if frames.health[unit] then
        frames.health[unit]:SetText(format_number(UnitHealth(unit)))
        frames.health[unit]:Show()
    end
end

-- Threat
function func:Update_Threat(unit)
    if frames.threat[unit] then
        local tank, status, threat = UnitDetailedThreatSituation("player", unit)

        if not ReubinsNameplates_settings.Tank then
            if not tank then
                if threat then
                    if threat < 50 then
                        frames.threat[unit]:SetVertexColor(0, 0, 0, 0); -- Transparent
                    end
                    if threat >= 50 then
                        frames.threat[unit]:SetVertexColor(1.0, 0.94, 0.0, 1); -- Yellow
                    end
                    if threat >= 75 then
                        frames.threat[unit]:SetVertexColor(0.96, 0.58, 0.11, 1); -- Orange
                    end
                else
                    frames.threat[unit]:SetVertexColor(0, 0, 0, 0); -- Transparent
                end 
            else
                frames.threat[unit]:SetVertexColor(1, 0, 0, 1); -- Red
            end
        else
            if not UnitExists(unit.."target") then
                frames.threat[unit]:SetVertexColor(0, 0, 0, 0); -- Transparent
            else
                if not tank then
                    if IsInGroup() then
                        if frames.tanks[UnitName(unit.."target")] then
                            frames.threat[unit]:SetVertexColor(0.08, 0.66, 0.98, 1); -- Blue    
                        else
                            if UnitPlayerOrPetInParty(unit.."target") or UnitInParty(unit.."target") then
                                frames.threat[unit]:SetVertexColor(1, 0, 0, 1); -- Red
                            else
                                frames.threat[unit]:SetVertexColor(0, 0, 0, 0); -- Transparent
                            end
                        end
                    else
                        frames.threat[unit]:SetVertexColor(1, 0, 0, 1); -- Red
                    end
                else
                    if status == 2 then -- Tanking but not highest
                        frames.threat[unit]:SetVertexColor(0.96, 0.58, 0.11, 1); -- Orange
                    elseif status == 3 then -- Tanking securly
                        frames.threat[unit]:SetVertexColor(0, 1, 0, 1); -- Green
                    else
                        frames.threat[unit]:SetVertexColor(0, 0, 0, 0); -- Transparent
                    end
                end
            end
        end
    end
end
