print( "sh_loadoutmenu initialization..." )
--Red team: 3 ARs, 3 SMGs, 3 DMRs, 1 SR, 1 HMG, 1 SG	Blue team: 6 ARs, 2 SMGs, 2 DMRs, 1 SR, 1 HMG, 1 SG
--//Table format: GM.weaponsPerRole[Chosen role (assigned and sorted numerically)][Weapon Type][Chosen team (sorted numerically)][Weapon's classname] = {price in shop, extra magazines}
GM.weaponsPerRole = {
	{ --Militant/Rifleman
		primary = {
			{"cw_kk_ins2_akm" = {0, 0}, "cw_kk_ins2_m1a1" = {0, 0}, "cw_kk_ins2_mp40" = {0, 0}},
			{"cw_kk_ins2_m16a4" = {0, 0}, "cw_kk_ins2_galil" = {0, 0}, "cw_kk_ins2_ump45" = {0, 0}, "cw_kk_ins2_l1a1" = {0, 0}}
		},
		secondary = {
			{"cw_kk_ins2_makarov" = {0, 0}, "weapon_class" = {0, 0}, "weapon_class" = {0, 0}},
			{"weapon_class" = {0, 0}, "weapon_class" = {0, 0}, "weapon_class" = {0, 0}}
		},
		equipment = {
			{"weapon_class" = {0, 0}, "weapon_class" = {0, 0}, "weapon_class" = {0, 0}},
			{"weapon_class" = {0, 0}, "weapon_class" = {0, 0}, "weapon_class" = {0, 0}}
		},
	},
	{ --Scout/Recon
		primary = {
			{"weapon_class" = {0, 0}, "weapon_class" = {0, 0}, "weapon_class" = {0, 0}},
			{"weapon_class" = {0, 0}, "weapon_class" = {0, 0}, "weapon_class" = {0, 0}}
		},
		secondary = {
			{"cw_kk_ins2_makarov" = {0, 0}, "weapon_class" = {0, 0}, "weapon_class" = {0, 0}},
			{"weapon_class" = {0, 0}, "weapon_class" = {0, 0}, "weapon_class" = {0, 0}}
		},
		equipment = {
			{"weapon_class" = {0, 0}, "weapon_class" = {0, 0}, "weapon_class" = {0, 0}},
			{"weapon_class" = {0, 0}, "weapon_class" = {0, 0}, "weapon_class" = {0, 0}}
		},
	},
	{ --Gunner/Support
		primary = {
			{"weapon_class" = {0, 0}, "weapon_class" = {0, 0}, "weapon_class" = {0, 0}},
			{"weapon_class" = {0, 0}, "weapon_class" = {0, 0}, "weapon_class" = {0, 0}}
		},
		secondary = {
			{"cw_kk_ins2_makarov" = {0, 0}, "weapon_class" = {0, 0}, "weapon_class" = {0, 0}},
			{"weapon_class" = {0, 0}, "weapon_class" = {0, 0}, "weapon_class" = {0, 0}}
		},
		equipment = {
			{"weapon_class" = {0, 0}, "weapon_class" = {0, 0}, "weapon_class" = {0, 0}},
			{"weapon_class" = {0, 0}, "weapon_class" = {0, 0}, "weapon_class" = {0, 0}}
		},
	},
	{ --Sharpshooter/Marksman
		primary = {
			{"weapon_class" = {0, 0}, "weapon_class" = {0, 0}, "weapon_class" = {0, 0}},
			{"weapon_class" = {0, 0}, "weapon_class" = {0, 0}, "weapon_class" = {0, 0}}
		},
		secondary = {
			{"cw_kk_ins2_makarov" = {0, 0}, "weapon_class" = {0, 0}, "weapon_class" = {0, 0}},
			{"weapon_class" = {0, 0}, "weapon_class" = {0, 0}, "weapon_class" = {0, 0}}
		},
		equipment = {
			{"weapon_class" = {0, 0}, "weapon_class" = {0, 0}, "weapon_class" = {0, 0}},
			{"weapon_class" = {0, 0}, "weapon_class" = {0, 0}, "weapon_class" = {0, 0}}
		},
	},
	{ --Striker/Demolitions
		primary = {
			{"weapon_class" = {0, 0}, "weapon_class" = {0, 0}, "weapon_class" = {0, 0}},
			{"weapon_class" = {0, 0}, "weapon_class" = {0, 0}, "weapon_class" = {0, 0}}
		},
		secondary = {
			{"cw_kk_ins2_makarov" = {0, 0}, "weapon_class" = {0, 0}, "weapon_class" = {0, 0}},
			{"weapon_class" = {0, 0}, "weapon_class" = {0, 0}, "weapon_class" = {0, 0}}
		},
		equipment = {
			{"weapon_class" = {0, 0}, "weapon_class" = {0, 0}, "weapon_class" = {0, 0}},
			{"weapon_class" = {0, 0}, "weapon_class" = {0, 0}, "weapon_class" = {0, 0}}
		},
	},
	{ --Sniper
		primary = {
			{"weapon_class" = {0, 0}, "weapon_class" = {0, 0}, "weapon_class" = {0, 0}},
			{"weapon_class" = {0, 0}, "weapon_class" = {0, 0}, "weapon_class" = {0, 0}}
		},
		secondary = {
			{"cw_kk_ins2_makarov" = {0, 0}, "weapon_class" = {0, 0}, "weapon_class" = {0, 0}},
			{"weapon_class" = {0, 0}, "weapon_class" = {0, 0}, "weapon_class" = {0, 0}}
		},
		equipment = {
			{"weapon_class" = {0, 0}, "weapon_class" = {0, 0}, "weapon_class" = {0, 0}},
			{"weapon_class" = {0, 0}, "weapon_class" = {0, 0}, "weapon_class" = {0, 0}}
		},
	},
	{ --Sapper/Breacher
		primary = {
			{"weapon_class" = {0, 0}, "weapon_class" = {0, 0}, "weapon_class" = {0, 0}},
			{"weapon_class" = {0, 0}, "weapon_class" = {0, 0}, "weapon_class" = {0, 0}}
		},
		secondary = {
			{"cw_kk_ins2_makarov" = {0, 0}, "weapon_class" = {0, 0}, "weapon_class" = {0, 0}},
			{"weapon_class" = {0, 0}, "weapon_class" = {0, 0}, "weapon_class" = {0, 0}}
		},
		equipment = {
			{"weapon_class" = {0, 0}, "weapon_class" = {0, 0}, "weapon_class" = {0, 0}},
			{"weapon_class" = {0, 0}, "weapon_class" = {0, 0}, "weapon_class" = {0, 0}}
		},
	},
	{ --Expert/Specialist
		primary = {
			{"weapon_class" = {0, 0}, "weapon_class" = {0, 0}, "weapon_class" = {0, 0}},
			{"weapon_class" = {0, 0}, "weapon_class" = {0, 0}, "weapon_class" = {0, 0}}
		},
		secondary = {
			{"cw_kk_ins2_makarov" = {0, 0}, "weapon_class" = {0, 0}, "weapon_class" = {0, 0}},
			{"weapon_class" = {0, 0}, "weapon_class" = {0, 0}, "weapon_class" = {0, 0}}
		},
		equipment = {
			{"weapon_class" = {0, 0}, "weapon_class" = {0, 0}, "weapon_class" = {0, 0}},
			{"weapon_class" = {0, 0}, "weapon_class" = {0, 0}, "weapon_class" = {0, 0}}
		},
	}
}

--//This is for clients, primarily, for when I list out the weapons. I could use weapons.Get for all of them, but that utilizes precious system resources.
GM.menuDisplayName = {
		--Red Primaries
		"cw_kk_ins2_ak74" = 		"AK74",
		"cw_kk_ins2_akm" = 			"AKM",
		"cw_kk_ins2_aks74u" = 		"AKs-74u",
		"cw_kk_ins2_fnfal" = 		"FN FAL",
		"cw_kk_ins2_m1a1" = 		"M1A1",
		"cw_kk_ins2_m1a1_para" = 	"M1A1 Elite",
		"cw_kk_ins2_mosin" = 		"Mosin Nagant",
		"cw_kk_ins2_mp40" = 		"MP-40",
		"cw_kk_ins2_rpk" = 			"RPK",
		"cw_kk_ins2_sks" = 			"SKS",
		"cw_kk_ins2_sterling" = 	"Sterling",
		"cw_kk_ins2_toz" = 			"TOZ",
		--Blue Primaires
		"cw_kk_ins2_mini14" = 		"AC-556", --AR
		"cw_kk_ins2_galil" = 		"Galil", --AR
		"cw_kk_ins2_cstm_galil_ace" = "Galil ACE", --AR
		"cw_kk_ins2_mp5k" = 		"HK MP5K", --SMG
		"cw_kk_ins2_ump45" = 		"HK UMP .45", --SMG
		"cw_kk_ins2_l1a1" = 		"L1A1", --DMR
		"cw_kk_ins2_m14" = 			"M14 EBR", --DMR
		"cw_kk_ins2_m16a4" = 		"M16A4", --AR
		"cw_kk_ins2_m249" = 		"M249", --HMG
		"cw_kk_ins2_m40a1" = 		"M40A1", --SR
		"cw_kk_ins2_m4a1" = 		"M4A1", --AR
		"cw_kk_ins2_m590" = 		"M590", --SG
		"cw_kk_ins2_mk18" = 		"MK18", --AR
		--Extra Primaries
		"cw_kk_ins2_cstm_aug" = 	"AUG",
		"cw_kk_ins2_cstm_colt" = 	"Colt",
		"cw_kk_ins2_cstm_famas" = 	"Famas",
		"cw_kk_ins2_cstm_g36c" = 	"G36C",
		"cw_kk_ins2_cstm_kriss" = 	"Kriss Vector",
		"cw_kk_ins2_cstm_ksg" = 	"KSG-12",
		"cw_kk_ins2_cstm_l85" = 	"L85A2",
		"cw_kk_ins2_cstm_m14" = 	"M14 Classic",
		"cw_kk_ins2_cstm_m500" = 	"M500",
		"cw_kk_ins2_cstm_mp5a4" = 	"MP5A4",
		"cw_kk_ins2_cstm_mp7" = 	"MP7",
		"cw_kk_ins2_cstm_scar" = 	"Scar-H",
		"cw_kk_ins2_cstm_spas12" = 	"Spas-12",
		"cw_kk_ins2_cstm_uzi" = 	"Uzi",
		--Secondaries
		"cw_kk_ins2_m1911" = 		"M1911",
		"cw_kk_ins2_makarov" = 		"Makarov",
		"cw_kk_ins2_revolver" = 	"Model 10",
		"cw_kk_ins2_m9" = 			"Beretta M9",
		"cw_kk_ins2_m45" = 			"M45",
		--Extra Secondaries
		"cw_kk_ins2_cstm_cobra" = 	"S&W Cobra",
		"cw_kk_ins2_cstm_g19" = 	"Glock 19",
		--Equipment
		"cw_kk_ins2_nade_f1" = 		"F1 Frag",
		"cw_kk_ins2_nade_m67" = 	"M67 Frag",
		"cw_kk_ins2_nade_m18" = 	"M18 Smoke",
		"cw_kk_ins2_nade_m84" = 	"M84 Flash",
		"cw_kk_ins2_nade_anm14" = 	"ANM-14",
		"cw_kk_ins2_nade_molotov" = "Molotov",
		"cw_kk_ins2_nade_c4" = 		"C4",
		"cw_kk_ins2_nade_ied" = 	"IED",
		"cw_kk_ins2_rpg" = 			"RPG-7",
		"cw_kk_ins2_at4" = 			"AT-4",
		--"cw_kk_ins2_gp25" = 		"GP-25 Grenade Launcher",
		"cw_kk_ins2_p2a1" = 		"P2A1 Flare Gun" --This is the flare gun, for night maps, I guess
}

if CLIENT then

local models = { }
function GetModels()
	for k, v in pairs( primaries ) do
		for k2, v2 in pairs( v ) do
			local model = weapons.Get( v2weaponClass )
			table.insert( models, model["WorldModel"] )
		end
	end
	for k, v in pairs( secondaries ) do
		for k2, v2 in pairs( v ) do
			local model = weapons.Get( v2weaponClass )
			table.insert( models, model["WorldModel"] )
		end
	end
	for k, v in pairs( equipment ) do
		for k2, v2 in pairs( v ) do
			local model = weapons.Get( v2weaponClass )
			table.insert( models, model["WorldModel"] )
		end
	end
	return models
end

end

function TeamThree()
	table.Empty( primaries[3] )
	table.Empty( secondaries[3] )
	table.Empty( equipment[3] )
	for k, v in pairs( primaries ) do
		for k2, v2 in pairs( v ) do
			table.insert( primaries[3], v2 )
		end
	end
	for k, v in pairs( secondaries ) do
		for k2, v2 in pairs( v ) do
			table.insert( secondaries[3], v2 )
		end
	end
	for k, v in pairs( equipment ) do
		for k2, v2 in pairs( v ) do
			if !table.HasValue( equipment[3], v2 ) then
				table.insert( equipment[3], v2 )
			end
		end
	end
end

function isPrimary( class )
	for k, v in pairs( primaries ) do
		for k2, v2 in pairs( v ) do
			if class == v2[ "class" ] or class == v2[ "name" ] then
				return true
			end
		end
	end
	return false
end

function isSecondary( class )
	for k, v in pairs( secondaries ) do
		for k2, v2 in pairs( v ) do
			if class == v2[ "class" ] or class == v2[ "name" ] then
				return true
			end
		end
	end
	return false
end

function isEquipment( class )
	for k, v in pairs( equipment ) do
		for k2, v2 in pairs( v ) do
			if class == v2[ "class" ] or class == v2[ "name" ] then
				return true
			end
		end
	end
	return false
end

--hook.Add( "to-do hook", "TeamThree", TeamThree() )

--//Should I edit CW2.0's pickup function as as to disallow multiple weapon pickups, or rewrite it here?
if SERVER then  	
	--//This saves the player's' loadout (weapons/attachments) when they hit the "Save Loadout" button in the menu
	util.AddNetworkString( "SetLoadout" )
	net.Receive( "SetLoadout", function( len, ply )
		local loadout = net.ReadTable()

		if loadout then
			--TO-DO: check for client consistency between what the server's given and ply's ACTUAL unlocked attachments
			if loadout[ "primary" ] then
				ply.oldprim = loadout[ "primary" ]
			end
			if loadout[ "secondary" ] then
				ply.oldsec = loadout[ "secondary" ]
			end
			if loadout[ "equipment" ] then
				ply.oldeq = loadout[ "equipment" ]
			end
			if loadout[ "role" ] then
				ply.oldrole = loadout[ "role" ]
			end
			if loadout[ "pattachments" ] and loadout[ "primary" ] then
				ply.oldpatt = loadout[ "pattachments" ]
			end
			if loadout[ "sattachments" ] and loadout[ "secondary" ] then
				ply.oldsatt = loadout[ "sattachments" ]
			end
		end
		GiveLoadout( ply )
	end )

	function GiveLoadout( ply )
		if GetGlobalBool( "RoundInProgress" ) or !GetGlobalBool( "GameInProgress" ) then return end

		--[[This COULD be a table and a for statement... but meh...
		print( "Removing ", ply:GetAmmoCount( "cw_kk_ins2_nade_m18" ), " ammo from cw_kk_ins2_nade_m18." )
		print( "Removing ", ply:GetAmmoCount( "cw_kk_ins2_nade_m67" ), " ammo from cw_kk_ins2_nade_m67." )
		print( "Removing ", ply:GetAmmoCount( "cw_kk_ins2_nade_m84" ), " ammo from cw_kk_ins2_nade_m84." )
		print( "Removing ", ply:GetAmmoCount( "cw_kk_ins2_nade_c4" ), " ammo from cw_kk_ins2_nade_c4." )
		print( "Removing ", ply:GetAmmoCount( "cw_kk_ins2_nade_ied" ), " ammo from cw_kk_ins2_nade_ied." )

		ply:RemoveAmmo( ply:GetAmmoCount( "cw_kk_ins2_nade_m18" ), "cw_kk_ins2_nade_m18" )
		ply:RemoveAmmo( ply:GetAmmoCount( "cw_kk_ins2_nade_m67" ), "cw_kk_ins2_nade_m67" )
		ply:RemoveAmmo( ply:GetAmmoCount( "cw_kk_ins2_nade_m84" ), "cw_kk_ins2_nade_m84" )
		ply:RemoveAmmo( ply:GetAmmoCount( "cw_kk_ins2_nade_c4" ),  "cw_kk_ins2_nade_c4" )
		ply:RemoveAmmo( ply:GetAmmoCount( "cw_kk_ins2_nade_ied" ), "cw_kk_ins2_nade_ied" )]]

		local attachmentequipdelay = 0.3
		local give40mm = false
		ply:StripWeapons()
		if ply.oldprim then
			ply:Give( ply.oldprim )
		end
		if ply.oldsec then
			ply:Give( ply.oldsec )
		end
		if ply.oldeq then
			ply:Give( ply.oldeq )
		end
		if ply.oldrole then
			ply:SetNWString( "role", ply.oldrole )
		end
		if ply.oldpatt and ply.oldprim then
			timer.Simple( attachmentequipdelay, function()
				for k, v in pairs( ply.oldpatt ) do
					ply:GetWeapon( ply.oldprim ):attachSpecificAttachment( v )
					if v == "kk_ins2_gl_gp25" or v == "kk_ins2_gl_m203" then 
						give40mm = true
						print( ply:Nick(), " has a nade launcher, give them some nades..." )
					end
				end
			end )
		end
		if ply.oldsatt and ply.oldsec then
			timer.Simple( attachmentequipdelay, function()
				for k, v in pairs( ply.oldsatt ) do
					ply:GetWeapon( ply.oldsec ):attachSpecificAttachment( v )
				end
			end )
		end

		if ply:Team() == 1 then
			ply:Give( "cw_kk_ins2_mel_gurkha" )
		elseif ply:Team() == 2 then
			ply:Give( "cw_kk_ins2_mel_bayonet" )
		else
			ply:Give( table.Random( { "cw_kk_ins2_mel_gurkha", "cw_kk_ins2_mel_bayonet" } ) )
		end

		--//Give ammo here
		local ammoneeded = {
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
		local previouslyremoved = { }
		timer.Simple( attachmentequipdelay - 0.05, function()
			if ply:IsPlayer() then
				for k, v in pairs( ply:GetWeapons() ) do
					local x = v:GetPrimaryAmmoType()
					local y = v:Clip1()
					if !table.HasValue( previouslyremoved, x ) then
						ply:RemoveAmmo( ply:GetAmmoCount( x ), x )
						table.insert( previouslyremoved, x )
					end
					if ammoneeded[ v:GetClass() ] then
						ply:GiveAmmo( ammoneeded[ v:GetClass() ], x, true )
					else
						ply:GiveAmmo( ( y * 5 ), x, true )
					end
				end	
				ply:RemoveAmmo( ply:GetAmmoCount( "40MM" ), "40MM" )
				if give40mm then
					ply:GiveAmmo( 2, "40MM", true )
				end
			end
		end )
		print( "SetRole called via sh_loadoutmenu" )
		SetRole( ply )
	end

	function GM:CheckRole( ply )
		local role = ply:GetNWString( "role" )
		for k, v in pairs( roles ) do
			if v[ ply:Team() ] == role then
				return k
			end
		end
		return 0
	end

--[[function CheckWeapons( ply )
	if v and v ~= NULL and IsValid( v ) and v:Alive() then
		local tab = v:GetWeapons()
		if tab then
			local foundp = false
			local founds = false
			local founde = false
			for k2, v2 in next, tab do
				if isPrimary( v2:GetClass() ) then
					v.curprimary = v2:GetClass()
					foundp = true
				elseif isSecondary( v2:GetClass() ) then
					v.cursecondary = v2:GetClass() 
					founds = true
				elseif isEquipment( v2:GetClass() ) then
					v.curequipment = v2:GetClass()
					founde = true
				end
			end
			if foundp == false then
				v.curprimary = nil
			end
			if founds == false then
				v.cursecondary = nil
			end
			if founde == false then
				v.curequipment = nil
			end
		end
	end
end]]

util.AddNetworkString( "RequestLoadout" )
util.AddNetworkString( "RequestLoadoutCallback" )

net.Receive( "RequestLoadout", function( len, ply )
	net.Start( "RequestLoadoutCallback" )
		local loadout = {
			[ "primary" ] = ply.oldprim,
			[ "secondary" ] = ply.oldsec,
			[ "equipment" ] = ply.oldeq,
			[ "role" ] = ply.oldrole,
			[ "pattachments" ] = ply.oldpatt,
			[ "sattachments" ] = ply.oldsatt
		}
		net.WriteTable( loadout )
	net.Send( ply )
end )

hook.Add( "PlayerButtonDown", "DropWeapons", function( ply, bind ) 
	if bind == KEY_Q then
		if not ply:IsFrozen() then
			if ply and IsValid( ply ) and ply:IsPlayer() and ply:Alive() then
				ply:ConCommand( "cw_dropweapon" )
			end
		end
	end
end )

hook.Add( "AllowPlayerPickup", "CheckPickups", function( ply, ent )
	return false 
end )

hook.Add( "PlayerDeath", "clearthings", function( ply )
	for k, v in pairs( ply:GetWeapons() ) do
		--Normally, you'd want to check to ensure it's a CW2.0 weapon we're using CW2.0's weapon drop function for, but the function does it itself
		CustomizableWeaponry:dropWeapon( ply, v ) 
	end
	--[[ply.curprimary = nil
	ply.cursecondary = nil
	ply.curequipment = nil]]
end )

return true

end