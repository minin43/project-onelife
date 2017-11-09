function GM:ApplyLoadout(ply)
    if not self.GameInProgress or self.RoundInProgress then return end

    --//Reset the loadout
    self.ammoTypesToRemove = {"Incendiary", "C4", "Frag Grenades", "IED", "Smoke Grenades", "Flash Grenades", "PG-7VM Grenade", "AT4 Launcher", "40MM"}
    for k, v in pairs(self.ammoTypesToRemove) do
        ply:SetAmmo(0, v)
    end
    ply:StripWeapons()

	ply:SetNWString("role", ply.role)
	ply:Give(ply.primWeapon, false)
    ply:Give(ply.secondWeapon, false)
    ply:Give(ply.equipWeapon, false)
    self.meleeWeaponsPerTeam = {"cw_kk_ins2_mel_gurkha", "cw_kk_ins2_mel_bayonet"}
    ply:Give(self.meleeWeaponsPerTeam[ply:Team()])

    local equipmentAmmo = {
		--//This is how many the player gets
		[ "cw_kk_ins2_nade_m18" ] = 2,
		[ "cw_kk_ins2_nade_m67" ] = 2,
		[ "cw_kk_ins2_nade_f1" ] = 2,
		[ "cw_kk_ins2_nade_m84" ] = 2,
		[ "cw_kk_ins2_nade_c4" ] = 1,
		[ "cw_kk_ins2_nade_ied" ] = 1,
		[ "cw_kk_ins2_nade_anm14" ] = 2,
		[ "cw_kk_ins2_nade_molotov" ] = 2,
		--//This is how many EXTRA the player gets (so 1 + whatever's down below)
		[ "cw_kk_ins2_rpg" ] = 1,
		[ "cw_kk_ins2_gp25" ] = 3,
		[ "cw_kk_ins2_p2a1" ] = 2,
		[ "cw_kk_ins2_at4" ] = 1
	}
    for k, v in pairs(ply:GetWeapons()) do
        local ammoType = v:GetPrimaryAmmoType()
		local magazineSize = v:Clip1()
        local weaponClass = v:GetClass()

        if equipmentAmmo[weaponClass] then
            ply:GiveAmmo(equipmentAmmo[weaponClass], weapons.GetStored(weaponClass).Primary.Ammo, true)
        else
            ply:GiveAmmo(magazineSize  * 5, ammoType, true)
        end
    end

    timer.Simple(0.3, function()
        for k, v in pairs(ply.primWeaponAttachments) do
            ply:GetWeapon(ply.primWeapon):attachSpecificAttachment(v)
            if CustomizableWeaponry.registeredAttachmentsSKey[v].isGrenadeLauncher then
                ply:GiveAmmo( 2, "40MM", true )
            end
        end

        for k, v in pairs(ply.secondWeaponAttachments) do
            ply:GetWeapon(ply.secondWeapon):attachSpecificAttachment(v)
        end

        for k, v in pairs(ply.equipWeaponAttachments) do
            ply:GetWeapon(ply.equipWeapon):attachSpecificAttachment(v)
        end
    end)

    self:SetRole(ply, ply.role)
end