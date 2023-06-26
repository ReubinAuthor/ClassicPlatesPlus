----------------------------------------
-- CORE
----------------------------------------
local myAddon, core = ...;
local func = core.func;
local data = core.data;

----------------------------------------
-- Threat
----------------------------------------
function func:Update_Threat(unit)
    if unit and string.match(unit, "nameplate") then
        local nameplate = C_NamePlate.GetNamePlateForUnit(unit);

        if nameplate then
            local unitFrame = nameplate.unitFrame;
            local showHighlight, threat, r,g,b = func:GetHighlightAndUnitColor(unit);

            -- Coloring frames:
            unitFrame.portrait.highlight:SetVertexColor(r,g,b);
            unitFrame.healthbar.highlight:SetVertexColor(r,g,b);
            unitFrame.level.highlight:SetVertexColor(r,g,b);
            unitFrame.powerbar.highlight:SetVertexColor(r,g,b);
            unitFrame.threatPercentage.highlight:SetVertexColor(r,g,b);
            unitFrame.healthbar:SetStatusBarColor(r,g,b);
            unitFrame.threatPercentage.background:SetVertexColor(r,g,b);

            --Swapping healthbar's highlight so that it won't show underneath the powerbar's background.
            if unitFrame.powerbar:IsShown() then
                if Config.Portrait then
                    unitFrame.healthbar.highlight:SetTexture("Interface\\addons\\ClassicPlatesPlus\\media\\highlights\\healthbar_2");
                else
                    unitFrame.healthbar.highlight:SetTexture("Interface\\addons\\ClassicPlatesPlus\\media\\highlights\\healthbar_3");
                end
            else
                unitFrame.healthbar.highlight:SetTexture("Interface\\addons\\ClassicPlatesPlus\\media\\highlights\\healthbar");
            end

            -- Updating threat percentage
            if Config.ThreatPercentage and threat and threat > 0 then
                if threat >= 999 then
                    unitFrame.threatPercentage.value:SetText("999%");
                else
                    unitFrame.threatPercentage.value:SetText(math.floor(threat) .. "%");
                end
            end
            unitFrame.threatPercentage:SetShown(Config.ThreatPercentage and threat and threat > 0);

            func:Update_NameAndGuildPositions(unitFrame);

            -- Toggling frames:
            unitFrame.portrait.highlight:SetShown(showHighlight and unitFrame.portrait:IsShown());
            unitFrame.healthbar.highlight:SetShown(showHighlight);
            unitFrame.level.highlight:SetShown(showHighlight and unitFrame.level:IsShown());
            unitFrame.powerbar.highlight:SetShown(showHighlight and unitFrame.powerbar:IsShown());
            unitFrame.threatPercentage.highlight:SetShown(showHighlight and unitFrame.threatPercentage:IsShown());
        end
    end
end