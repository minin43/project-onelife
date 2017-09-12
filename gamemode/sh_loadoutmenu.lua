print( "sh_loadoutmenu initialization..." )
--OLD LAYOUT: { <weapon name>, <class>, <unlock level>, <world model>, <cost>, { <damage>, <accuracy>, <rate of fire> } }
--NEW LAYOUT: { weaponName = "weapon name", weaponClass = "class name", weaponWeight = 0, weaponRoles = { roles by level = shop price } }
--Red team: 3 ARs, 3 SMGs, 3 DMRs, 1 SR, 1 HMG, 1 SG	Blue team: 
primaries = primaries or {
	[1] = {
		{ weaponName = "AK-74", 		weaponClass = "cw_kk_ins2_ak74", 		weaponWeight = 0, weaponRoles = {} }, --AR
		{ weaponName = "AKM", 			weaponClass = "cw_kk_ins2_akm", 		weaponWeight = 0, weaponRoles = {} }, --AR
		{ weaponName = "AKS-74u", 		weaponClass = "cw_kk_ins2_aks74u", 		weaponWeight = 0, weaponRoles = {} }, --SMG
		{ weaponName = "FN FAL", 		weaponClass = "cw_kk_ins2_fnfal", 		weaponWeight = 0, weaponRoles = {} }, --AR
		{ weaponName = "M1 Carbine", 	weaponClass = "cw_kk_ins2_m1a1", 		weaponWeight = 0, weaponRoles = {} }, --DMR
		{ weaponName = "M1A1 Carbine", 	weaponClass = "cw_kk_ins2_m1a1_para", 	weaponWeight = 0, weaponRoles = {} }, --DMR
		{ weaponName = "Mosin Nagant", 	weaponClass = "cw_kk_ins2_mosin", 		weaponWeight = 0, weaponRoles = {} }, --SR
		{ weaponName = "MP-40", 		weaponClass = "cw_kk_ins2_mp40", 		weaponWeight = 0, weaponRoles = {} }, --SMG
		{ weaponName = "RPK", 			weaponClass = "cw_kk_ins2_rpk", 		weaponWeight = 0, weaponRoles = {} }, --HMG
		{ weaponName = "SKS", 			weaponClass = "cw_kk_ins2_sks", 		weaponWeight = 0, weaponRoles = {} }, --DMR
		{ weaponName = "Sterling", 		weaponClass = "cw_kk_ins2_sterling", 	weaponWeight = 0, weaponRoles = {} }, --SMG
		{ weaponName = "TOZ", 			weaponClass = "cw_kk_ins2_toz", 		weaponWeight = 0, weaponRoles = {} } --SG
	},
	[2] = { --I think we're missing some weapons here
		{ weaponName = "AC-556", 		weaponClass = "cw_kk_ins2_mini14", 			weaponWeight = 0, weaponRoles = {} },
		{ weaponName = "Galil", 		weaponClass = "cw_kk_ins2_galil", 			weaponWeight = 0, weaponRoles = {} }, --AR
		{ weaponName = "Galil ACE", 	weaponClass = "cw_kk_ins2_cstm_galil_ace", 	weaponWeight = 0, weaponRoles = {} }, --AR
		{ weaponName = "HK MP5K", 		weaponClass = "cw_kk_ins2_mp5k", 			weaponWeight = 0, weaponRoles = {} }, --SMG
		{ weaponName = "HK UMP .45", 	weaponClass = "cw_kk_ins2_ump45", 			weaponWeight = 0, weaponRoles = {} }, --SMG
		{ weaponName = "L1A1", 			weaponClass = "cw_kk_ins2_l1a1", 			weaponWeight = 0, weaponRoles = {} },
		{ weaponName = "M14 EBR", 		weaponClass = "cw_kk_ins2_m14", 			weaponWeight = 0, weaponRoles = {} },
		{ weaponName = "M16A4", 		weaponClass = "cw_kk_ins2_m16a4", 			weaponWeight = 0, weaponRoles = {} }, --AR
		{ weaponName = "M249", 			weaponClass = "cw_kk_ins2_m249", 			weaponWeight = 0, weaponRoles = {} },
		{ weaponName = "M40A1", 		weaponClass = "cw_kk_ins2_m40a1", 			weaponWeight = 0, weaponRoles = {} },
		{ weaponName = "M4A1", 			weaponClass = "cw_kk_ins2_m4a1", 			weaponWeight = 0, weaponRoles = {} }, --AR
		{ weaponName = "M590", 			weaponClass = "cw_kk_ins2_m590", 			weaponWeight = 0, weaponRoles = {} },
		{ weaponName = "MK18", 			weaponClass = "cw_kk_ins2_mk18", 			weaponWeight = 0, weaponRoles = {} } --AR
	},
	[3] = {
		--Intentionally left blank
	}
}


secondaries = secondaries or {
	[1] = {
		{ weaponName = "M1911", 		weaponClass = "cw_kk_ins2_m1911", 	weaponWeight = 0, weaponRoles = { 1, 2, 3, 4, 5, 6, 7, 8 } },
		{ weaponName = "Makarov", 	weaponClass = "cw_kk_ins2_makarov", 	weaponWeight = 0, weaponRoles = { 1, 2, 3, 4, 5, 6, 7, 8 } },
		{ weaponName = "Model 10", 	weaponClass = "cw_kk_ins2_revolver", 	weaponWeight = 0, weaponRoles = { 1, 2, 3, 4, 5, 6, 7, 8 } }
	},
	[2] = {
		{ weaponName = "Beretta M9", 	weaponClass = "cw_kk_ins2_m9", 		weaponWeight = 0, weaponRoles = { 1, 2, 3, 4, 5, 6, 7, 8 } },
		{ weaponName = "M45", 		weaponClass = "cw_kk_ins2_m45", 		weaponWeight = 0, weaponRoles = { 1, 2, 3, 4, 5, 6, 7, 8 } },
		{ weaponName = "Model 10", 	weaponClass = "cw_kk_ins2_revolver", 	weaponWeight = 0, weaponRoles = { 1, 2, 3, 4, 5, 6, 7, 8 } }
	},
	[3] = {
		--Intentionally left blank
	}
}

--// Layout: "Equipment name", "equipment class", "roles to receive"
equipment = equipment or {
	[1] = {
		{ weaponName = "F1 Frag", 		weaponClass = "cw_kk_ins2_nade_f1", 	weaponWeight = 0, weaponRoles = { 2, 5, 7, 8 } },
		{ weaponName = "IED", 			weaponClass = "cw_kk_ins2_nade_ied", 	weaponWeight = 0, weaponRoles = { 7 } },
		{ weaponName = "RPG-7", 			weaponClass = "cw_kk_ins2_rpg", 	weaponWeight = 0, weaponRoles = { 5 } },
		{ weaponName = "Molotov", 		weaponClass = "cw_kk_ins2_nade_molotov",weaponWeight = 0, weaponRoles = { 3, 7 } },
		{ weaponName = "M18 Smoke", 		weaponClass = "cw_kk_ins2_nade_m18",weaponWeight = 0, weaponRoles = { 1, 2, 3, 4, 7, 8 } },
		{ weaponName = "M84 Flash", 		weaponClass = "cw_kk_ins2_nade_m84",weaponWeight = 0, weaponRoles = { 1, 2, 3, 7, 8 } },
		--{ weaponName = "GP35", 			weaponClass = "cw_kk_ins2_gp25", 	weaponWeight = 0, weaponRoles = { 7 } },
		{ weaponName = "P2A1 Flare Gun", 	weaponClass = "cw_kk_ins2_p2a1", 	weaponWeight = 0, weaponRoles = { 1, 2, 3, 4, 5, 6, 7, 8 } } --This is the flare gun, for night maps, I guess
	},
	[2] = {
		{ weaponName = "M67 Frag", 		weaponClass = "cw_kk_ins2_nade_m67", 		weaponWeight = 0, weaponRoles = { 2, 5, 7, 8 } },
		{ weaponName = "C4", 				weaponClass = "cw_kk_ins2_nade_c4", 	weaponWeight = 0, weaponRoles = { 7 } },
		{ weaponName = "AT-4", 			weaponClass = "cw_kk_ins2_at4", 			weaponWeight = 0, weaponRoles = { 5 } },
		{ weaponName = "ANM-14", 			weaponClass = "cw_kk_ins2_nade_anm14",	weaponWeight = 0, weaponRoles = { 3, 7 } },
		{ weaponName = "M18 Smoke", 		weaponClass = "cw_kk_ins2_nade_m18", 	weaponWeight = 0, weaponRoles = { 1, 2, 3, 4, 7, 8 } },
		{ weaponName = "M84 Flash", 		weaponClass = "cw_kk_ins2_nade_m84", 	weaponWeight = 0, weaponRoles = { 1, 2, 3, 7, 8 } },
		--{ weaponName = "GP35", 			weaponClass = "cw_kk_ins2_gp25", 		weaponWeight = 0, weaponRoles = { 7 } },
		{ weaponName = "P2A1 Flare Gun", 	weaponClass = "cw_kk_ins2_p2a1", 		weaponWeight = 0, weaponRoles = { 1, 2, 3, 4, 5, 6, 7, 8 } } --This is the flare gun, for night maps, I guess
	},
	[3] = {
		--Intentionally left blank
	}
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
		ply:RemoveAmmo( ply:GetAmmoCount( "cw_kk_ins2_nade_c4" ), "cw_kk_ins2_nade_c4" )
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