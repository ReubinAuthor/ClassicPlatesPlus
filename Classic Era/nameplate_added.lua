----------------------------------------
-- Core
----------------------------------------
local _, core = ...;
local func = core.func;
local data = core.data;

----------------------------------------
-- Adding nameplate
----------------------------------------
function func:Nameplate_Added(unit)
    if unit then
        local nameplate = C_NamePlate.GetNamePlateForUnit(unit, false);

        if nameplate then
            local unitFrame = nameplate.unitFrame;

            -- Healthbar
            unitFrame.healthbar.border:ClearAllPoints();

            -- Powerbar
            unitFrame.powerbar.statusbar:ClearAllPoints();

            -- Level
            unitFrame.level.background:SetColorTexture(
                data.colors.border.r - 0.35,
                data.colors.border.g - 0.35,
                data.colors.border.b - 0.35
            );

            -- Name and Guild
            unitFrame.name:SetScale(Config.NameplatesScale - func:GetPercent(Config.NameplatesScale, 10));
            unitFrame.guild:SetScale(Config.NameplatesScale - func:GetPercent(Config.NameplatesScale, 20));

            -- Threat percentage
            unitFrame.threatPercentage.border:ClearAllPoints();

            -- Classification
            unitFrame.classification:ClearAllPoints();

            -- Faction
            unitFrame.pvp_flag:ClearAllPoints();

            -- Health values: Main
            unitFrame.healthMain:SetTextColor(
                Config.HealthFontColor.r,
                Config.HealthFontColor.g,
                Config.HealthFontColor.b,
                Config.HealthFontColor.a
            );
            if Config.LargeMainValue then
                unitFrame.healthMain:SetFontObject("GameFontNormalLargeOutline");
                unitFrame.healthMain:SetScale(0.85);
            else
                unitFrame.healthMain:SetFontObject("GameFontNormalOutline");
                unitFrame.healthMain:SetScale(0.8);
            end
            unitFrame.healthMain:ClearAllPoints();

            -- Health values: Left side
            unitFrame.healthLeftSide:SetTextColor(
                Config.HealthFontColor.r,
                Config.HealthFontColor.g,
                Config.HealthFontColor.b,
                Config.HealthFontColor.a
            );

            -- Raid target
            unitFrame.raidTarget.icon:ClearAllPoints();

            unitFrame.buffsCounter:SetScale(Config.AurasScale);
            unitFrame.debuffsCounter:SetScale(Config.AurasScale);

            -- Portrait check
            if Config.Portrait then
                unitFrame.healthbar.border:SetPoint("bottom", nameplate, "bottom", 0, 4);
                unitFrame.powerbar.statusbar:SetPoint("top", unitFrame.healthbar, "bottom", 0, -1);
                unitFrame.threatPercentage.border:SetPoint("bottom", unitFrame.healthbar, "top", 0, -1.5);
                unitFrame.classification:SetParent(unitFrame.portrait);
                unitFrame.classification:SetPoint("center", unitFrame.portrait.texture, "center", -5, -2);
                unitFrame.classification:SetSize(48,48);
                unitFrame.pvp_flag:SetSize(27,27);
                unitFrame.pvp_flag:SetParent(unitFrame.portrait);
                unitFrame.pvp_flag:SetPoint("center", unitFrame.portrait.texture, "center", -7, -1.4);
                unitFrame.pvp_flag:SetScale(1);
                unitFrame.healthMain:SetPoint("center", unitFrame.healthbar, "center");
                unitFrame.raidTarget.icon:SetPoint("right", unitFrame.portrait.texture, "left", -6, 0);
                unitFrame.raidTarget.icon:SetPoint("right", unitFrame.portrait.texture, "left", -6, 0);
            else
                unitFrame.healthbar.border:SetPoint("top", nameplate, "center", -9, 0);
                unitFrame.powerbar.statusbar:SetPoint("top", unitFrame.healthbar, "bottom", 7, -1);
                unitFrame.threatPercentage.border:SetPoint("bottom", unitFrame.healthbar, "top", 7, -1.5);
                unitFrame.classification:SetParent(unitFrame);
                unitFrame.classification:SetPoint("center", unitFrame.level.border, "center", 7, 0);
                unitFrame.classification:SetSize(32,32);
                unitFrame.pvp_flag:SetSize(30,30);
                unitFrame.pvp_flag:SetParent(unitFrame);
                unitFrame.pvp_flag:SetPoint("right", unitFrame.name, "left", 10, -5);
                unitFrame.pvp_flag:SetScale(0.7);
                unitFrame.healthMain:SetPoint("center", unitFrame.healthbar, "center", 8, 0);
                unitFrame.raidTarget.icon:SetPoint("right", unitFrame.healthbar, "left", -6, 0);
                unitFrame.raidTarget.icon:SetPoint("right", unitFrame.healthbar, "left", -6, 0);
            end

            -- Toggling frames
            unitFrame.portrait:SetShown(Config.Portrait);
            unitFrame.powerbar:SetShown(Config.Powerbar);

            -- Assigning unit
            unitFrame.unit = unit;

            -- Updating everything
            func:Update_Classification(unit);
            func:Update_Portrait(unit);
            func:Update_PVP_Flag(unit);
            func:Update_Guild(unit);
            func:Update_Name(unit);
            func:Update_Level(unit);
            func:Update_Health(unit);
            func:Update_healthbar(unit);
            func:Update_Power(unit);
            func:Update_ComboPoints(unit);
            func:Update_Threat(unit);
            func:Update_Auras(unit);
            func:Update_Colors(unit);
            func:RaidTargetIndex();
            func:PredictHeal(unit);

            -- Scripts
            local timeElapsed = 0;
            unitFrame:SetScript("OnUpdate", function(self, elapsed)
                timeElapsed = timeElapsed + elapsed;
                if timeElapsed > 0.1 then
                    timeElapsed = 0;
                    func:Update_Threat(unit); -- Updating threat
                end
            end);

            -- Hiding default ("U"nitFrame) nameplates
            nameplate.UnitFrame:SetScript("OnShow", function()
                nameplate.UnitFrame:Hide();
            end);

            -- Showing nameplate
            nameplate.unitFrame:Show();
        end
    end
end