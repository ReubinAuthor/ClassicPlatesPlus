----------------------------------------
-- CORE
----------------------------------------
local myAddon, core = ...;
local func = core.func;
local data = core.data;

----------------------------------------
-- Check if other tank is tanking
----------------------------------------
function func:OtherTank(unit)
    if unit and not UnitIsPlayer(unit) or UnitIsOtherPlayersPet(unit) then
        for k in pairs(data.tanks) do
            if k then
                local status = UnitThreatSituation(k, unit);

                if status == 2 or status == 3 then
                    return true;
                end
            end
        end
    end
end

----------------------------------------
-- Threat
----------------------------------------
function func:Update_Threat(unit)
    if unit and string.match(unit, "nameplate") then
        local CFG = CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile];
        local nameplate = C_NamePlate.GetNamePlateForUnit(unit);

        if nameplate then
            local unitFrame = nameplate.unitFrame;
            local ThreatPercentageOfLead = UnitThreatPercentageOfLead("player", unit) or 0;
            local status = UnitThreatSituation("player", unit);
            local r,g,b = func:GetUnitColor(unit, ThreatPercentageOfLead, status);

            -- Coloring highlights
            unitFrame.portrait.highlight:SetVertexColor(r,g,b);
            unitFrame.healthbar.highlight:SetVertexColor(r,g,b);
            unitFrame.level.highlight:SetVertexColor(r,g,b);
            unitFrame.powerbar.highlight:SetVertexColor(r,g,b);
            unitFrame.threatPercentage.highlight:SetVertexColor(r,g,b);

            -- Coloring rest
            unitFrame.healthbar:SetStatusBarColor(r,g,b);
            unitFrame.threatPercentage.background:SetVertexColor(r,g,b);

            --Swapping healthbar's highlight so that it won't show underneath the powerbar's background.
            if unitFrame.powerbar:IsShown() then
                if CFG.Portrait then
                    unitFrame.healthbar.highlight:SetTexture("Interface\\addons\\ClassicPlatesPlus\\media\\highlights\\healthbar_2");
                else
                    unitFrame.healthbar.highlight:SetTexture("Interface\\addons\\ClassicPlatesPlus\\media\\highlights\\healthbar_3");
                end
            else
                unitFrame.healthbar.highlight:SetTexture("Interface\\addons\\ClassicPlatesPlus\\media\\highlights\\healthbar");
            end

            -- Updating threat percentage
            if CFG.ThreatPercentage and ThreatPercentageOfLead > 0 then
                if ThreatPercentageOfLead > 999 then
                    ThreatPercentageOfLead = 999;
                end

                unitFrame.threatPercentage.value:SetText(math.floor(ThreatPercentageOfLead) .. "%");
            end

            unitFrame.threatPercentage:SetShown(CFG.ThreatPercentage and ThreatPercentageOfLead and ThreatPercentageOfLead > 0);

            -- Toggle for highlights
            local ShowHighlight = CFG.ThreatHighlight
                and (ThreatPercentageOfLead > CFG.ThreatWarningThreshold -- Above threat threshold
                or (UnitIsUnit(unit.."target", "player") and UnitIsEnemy(unit, "player") and (UnitIsPlayer(unit) or UnitIsOtherPlayersPet)) -- Enemy player or pet targeting you
                or (status == 3 or status == 2) -- Tanking
                or GetPartyAssignment("MainTank", "player", true) and func:OtherTank(unit) -- Other tank tanking
            );

            -- Toggling frames:
            unitFrame.portrait.highlight:SetShown(ShowHighlight and unitFrame.portrait:IsShown());
            unitFrame.healthbar.highlight:SetShown(ShowHighlight);
            unitFrame.level.highlight:SetShown(ShowHighlight and unitFrame.level:IsShown());
            unitFrame.powerbar.highlight:SetShown(ShowHighlight and unitFrame.powerbar:IsShown());
            unitFrame.threatPercentage.highlight:SetShown(false);
        end
    end
end