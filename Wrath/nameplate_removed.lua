----------------------------------------
-- Core
----------------------------------------
local _, core = ...;
local func = core.func;

----------------------------------------
-- Removing nameplate
----------------------------------------
function func:Nameplate_Removed(unit)
    if unit then
        local nameplate = C_NamePlate.GetNamePlateForUnit(unit);

        if nameplate then
            local unitFrame = nameplate.unitFrame;

            -- Hidding auras
            for k,v in pairs(unitFrame.buffs) do
                if k then
                    v:Hide();
                end
            end
            for k,v in pairs(unitFrame.debuffs) do
                if k then
                    v:Hide();
                end
            end

            -- Threat percentage
            unitFrame.threatPercentage:Hide();

            -- Combo points
            unitFrame.comboPoints:Hide();

            -- Removing nameplate
            unitFrame.unit = nil;
            unitFrame.inVehicle = nil;
            unitFrame:Hide();
        end
    end
end