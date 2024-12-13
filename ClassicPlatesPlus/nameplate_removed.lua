----------------------------------------
-- Core
----------------------------------------
local _, core = ...;
local func = core.func;
local data = core.data;

----------------------------------------
-- Removing nameplate
----------------------------------------
function func:Nameplate_Removed(unit)
    if unit then
        local nameplate = C_NamePlate.GetNamePlateForUnit(unit);

        if nameplate then
            local unitFrame = nameplate.unitFrame;

            unitFrame.portrait.countdown:Hide();

            -- Hidding auras
            if unitFrame.auras then
                if unitFrame.auras.helpful then
                    for k,v in pairs(unitFrame.auras.helpful) do
                        if k then
                            v:Hide();
                        end
                    end
                end
                if unitFrame.auras.harmful then
                    for k,v in pairs(unitFrame.auras.harmful) do
                        if k then
                            v:Hide();
                        end
                    end
                end
            end

            -- Threat percentage
            unitFrame.threatPercentage:Hide();

            -- Combo points
            unitFrame.classPower:Hide();

            -- Removing nameplate
            unitFrame.unit = nil;
            unitFrame.inVehicle = nil;
            unitFrame:Hide();

            if data.isRetail then
                if UnitIsUnit(unit, "player") then
                    data.nameplate:Hide();
                end
            end
        end
    end
end