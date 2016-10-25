
--OLD LAYOUT: { <weapon name>, <class>, <unlock level>, <world model>, <cost>, { <damage>, <accuracy>, <rate of fire> } }  
--NEW LAYOUT: { ["name"] = "weapon name", ["class"] = "class name", ["roles"] = { roles by level } }

primaries = primaries or {
	[1] = {
		{ ["name"] = "AK-74", 			["class"] = "cw_kk_ins2_ak74", 		["roles"] = { 5, 8 } },
		{ ["name"] = "AKM", 			["class"] = "cw_kk_ins2_akm", 		["roles"] = { 1, 2, 3, 4, 5, 6, 7, 8 } },
		{ ["name"] = "AKS-74u", 		["class"] = "cw_kk_ins2_aks74u", 	["roles"] = { 2, 8 } },
		{ ["name"] = "FN FAL", 			["class"] = "cw_kk_ins2_fnfal", 	["roles"] = { 4, 7 } },
		{ ["name"] = "M1 Carbine", 		["class"] = "cw_kk_ins2_m1a1", 		["roles"] = { 1, 3 } },
		{ ["name"] = "M1A1 Carbine", 	["class"] = "cw_kk_ins2_m1a1_para", ["roles"] = { 4 } },
		{ ["name"] = "Mosin Nagant", 	["class"] = "cw_kk_ins2_mosin", 	["roles"] = { 6, 8 } },
		{ ["name"] = "MP-40", 			["class"] = "cw_kk_ins2_mp40", 		["roles"] = { 1, 2 } },
		{ ["name"] = "RPK", 			["class"] = "cw_kk_ins2_rpk", 		["roles"] = { 3, 8 } },
		{ ["name"] = "SKS", 			["class"] = "cw_kk_ins2_sks", 		["roles"] = { 4, 6 } },
		{ ["name"] = "Sterling", 		["class"] = "cw_kk_ins2_sterling", 	["roles"] = { 2, 7 } },
		{ ["name"] = "TOZ", 			["class"] = "cw_kk_ins2_toz", 		["roles"] = { 2, 5, 8 } }
	},
	[2] = {
		{ ["name"] = "AC-556", 		["class"] = "cw_kk_ins2_mini14", 			["roles"] = { 5, 7 } },
		{ ["name"] = "Galil", 		["class"] = "cw_kk_ins2_galil", 			["roles"] = { 1, 5 } },
		{ ["name"] = "Galil ACE", 	["class"] = "cw_kk_ins2_cstm_galil_ace", 	["roles"] = { 8 } },
		{ ["name"] = "HK MP5K", 	["class"] = "cw_kk_ins2_mp5k", 				["roles"] = { 2, 7 } },
		{ ["name"] = "HK UMP .45", 	["class"] = "cw_kk_ins2_ump45", 			["roles"] = { 1, 2, 8 } },
		{ ["name"] = "L1A1", 		["class"] = "cw_kk_ins2_l1a1", 				["roles"] = { 3, 4 } },
		{ ["name"] = "M14 EBR", 	["class"] = "cw_kk_ins2_m14", 				["roles"] = { 4, 6 } },
		{ ["name"] = "M16A4", 		["class"] = "cw_kk_ins2_m16a4", 			["roles"] = { 1, 2, 3, 4, 6 } },
		{ ["name"] = "M249", 		["class"] = "cw_kk_ins2_m249", 				["roles"] = { 3 } },
		{ ["name"] = "M40A1", 		["class"] = "cw_kk_ins2_m40a1", 			["roles"] = { 6 } },
		{ ["name"] = "M4A1", 		["class"] = "cw_kk_ins2_m4a1", 				["roles"] = { 5, 7 } },
		{ ["name"] = "M590", 		["class"] = "cw_kk_ins2_m590", 				["roles"] = { 2, 8 } },
		{ ["name"] = "MK18", 		["class"] = "cw_kk_ins2_mk18", 				["roles"] = { 8 } }
	},
	[3] = {
		--Intentionally left blank
	}
}


secondaries = secondaries or {
	[1] = {
		{ ["name"] = "M1911", 		["class"] = "cw_kk_ins2_m1911", 	["roles"] = { 1, 2, 3, 4, 5, 6, 7, 8 } },
		{ ["name"] = "Makarov", 	["class"] = "cw_kk_ins2_makarov", 	["roles"] = { 1, 2, 3, 4, 5, 6, 7, 8 } },
		{ ["name"] = "Model 10", 	["class"] = "cw_kk_ins2_revolver", 	["roles"] = { 1, 2, 3, 4, 5, 6, 7, 8 } }
	},
	[2] = {
		{ ["name"] = "Beretta M9", 	["class"] = "cw_kk_ins2_m9", 		["roles"] = { 1, 2, 3, 4, 5, 6, 7, 8 } },
		{ ["name"] = "M45", 		["class"] = "cw_kk_ins2_m45", 		["roles"] = { 1, 2, 3, 4, 5, 6, 7, 8 } },
		{ ["name"] = "Model 10", 	["class"] = "cw_kk_ins2_revolver", 	["roles"] = { 1, 2, 3, 4, 5, 6, 7, 8 } }
	},
	[3] = {
		--Intentionally left blank
	}
}

--// Layout: "Equipment name", "equipment class", "roles to receive"
equipment = equipment or {
	[1] = {
		{ ["name"] = "F1 Frag", 		["class"] = "cw_kk_ins2_nade_f1", 	["roles"] = { 2, 5, 7, 8 } },
		{ ["name"] = "IED", 			["class"] = "cw_kk_ins2_nade_ied", 	["roles"] = { 7 } },
		{ ["name"] = "RPG-7", 			["class"] = "cw_kk_ins2_rpg", 		["roles"] = { 5 } },
		{ ["name"] = "M18 Smoke", 		["class"] = "cw_kk_ins2_nade_m18", 	["roles"] = { 1, 2, 3, 4, 7, 8 } },
		{ ["name"] = "M84 Flash", 		["class"] = "cw_kk_ins2_nade_m84", 	["roles"] = { 1, 2, 3, 7, 8 } },
		{ ["name"] = "GP35", 			["class"] = "cw_kk_ins2_gp25", 		["roles"] = { 7 } },
		{ ["name"] = "P2A1 Flare Gun", 	["class"] = "cw_kk_ins2_p2a1", 		["roles"] = { 1, 2, 3, 4, 5, 6, 7, 8 } } --This is the flare gun, for night maps, I guess
	},
	[2] = {
		{ ["name"] = "M67 Frag", 		["class"] = "cw_kk_ins2_nade_m67", 	["roles"] = { 2, 5, 7, 8 } },
		{ ["name"] = "C4", 				["class"] = "cw_kk_ins2_nade_c4", 	["roles"] = { 7 } },
		{ ["name"] = "AT-4", 			["class"] = "cw_kk_ins2_at4", 		["roles"] = { 5 } },
		{ ["name"] = "M18 Smoke", 		["class"] = "cw_kk_ins2_nade_m18", 	["roles"] = { 1, 2, 3, 4, 7, 8 } },
		{ ["name"] = "M84 Flash", 		["class"] = "cw_kk_ins2_nade_m84", 	["roles"] = { 1, 2, 3, 7, 8 } },
		{ ["name"] = "GP35", 			["class"] = "cw_kk_ins2_gp25", 		["roles"] = { 7 } },
		{ ["name"] = "P2A1 Flare Gun", 	["class"] = "cw_kk_ins2_p2a1", 		["roles"] = { 1, 2, 3, 4, 5, 6, 7, 8 } } --This is the flare gun, for night maps, I guess
	},
	[3] = {
		--Intentionally left blank
	}
}

--// { "Red Team Name", "Blue Team Name", "FFA Team Name", "Role Description" }
--// Refer to this for future descriptions: http://insurgency.wikia.com/wiki/Insurgency
roles = {
	{ "Militant", 		"Rifleman", 			"Rifleman", 	"Standard fighter, gets access to most weapon types but no frag grenade." },
	{ "Scout", 			"Reconnaissance", 		"Recon", 		"Lightly armored but fast-moving fighter, gets access to all short-range weaponry and all grenades." },
	{ "Gunner", 		"Support", 				"Support", 		"Supportive fighter, gets access to LMGs and some long-distance DMRs, but no frag grenades." },
	{ "Sharpshooter", 	"Designated Marksman", 	"Marksman", 	"Lightly armored supportive fighter, gets access to all DMRs but no flash/frag grenades." },
	{ "Striker", 		"Demolitions", 			"Demolitions", 	"Heavily armored fighter, gets access to all launchers but no smoke/flash grenade." },
	{ "Sniper", 		"Sniper", 				"Sniper", 		"Lightly armored supportive fighter, gets access to all sniper rifles but no grenades." },
	{ "Sapper", 		"Breacher", 			"Breacher", 	"Medium armored supportive fighter, gets access to all throwable and remotely detonated explosives." },
	{ "Expert", 		"Specialist", 			"Specialist", 	"Medium armored fighter, gets access to extra, unique weapons for proving themselves in battle." }
}

if CLIENT then

local models = { }
function GetModels()
	for k, v in pairs( primaries ) do
		for k2, v2 in pairs( v ) do
			local model = weapons.Get( v2["class"] )
			table.insert( models, model["WorldModel"] )
		end
	end
	for k, v in pairs( secondaries ) do
		for k2, v2 in pairs( v ) do
			local model = weapons.Get( v2["class"] )
			table.insert( models, model["WorldModel"] )
		end
	end
	for k, v in pairs( equipment ) do
		for k2, v2 in pairs( v ) do
			local model = weapons.Get( v2["class"] )
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
--hook.Add( "to-do hook", "TeamThree", TeamThree() )

--//Should I edit CW2.0's pickup function as as to disallow multiple weapon pickups, or rewrite it here?
if SERVER then  	
	--//This gives the player their new weapons/attachments when the hit "Redeploy" in the menu
	util.AddNetworkString( "SetLoadout" )
	net.Receive( "SetLoadout", function( len, ply )
		--if !ply:IsAlive() then return end
		--ply.oldprim, ply.oldsec, ply.oldeq, ply.oldpatt, ply.oldsatt

		local loadout = net.ReadTable()
		local give40mm = false
		ply:StripWeapons()
		--This COULD be a table and a for statement... but meh...
		ply:RemoveAmmo( ply:GetAmmoCount( "cw_kk_ins2_nade_m18" ), "cw_kk_ins2_nade_m18" )
		ply:RemoveAmmo( ply:GetAmmoCount( "cw_kk_ins2_nade_m67" ), "cw_kk_ins2_nade_m67" )
		ply:RemoveAmmo( ply:GetAmmoCount( "cw_kk_ins2_nade_m84" ), "cw_kk_ins2_nade_m84" )
		ply:RemoveAmmo( ply:GetAmmoCount( "cw_kk_ins2_nade_c4" ),  "cw_kk_ins2_nade_c4" )
		ply:RemoveAmmo( ply:GetAmmoCount( "cw_kk_ins2_nade_ied" ), "cw_kk_ins2_nade_ied" )
		teamnumber = ply:Team()

		if loadout then
			--TO-DO: check for client consistency between what's given and ACTUAL unlocked attachments
			if loadout[ "primary" ] then
				ply:Give( loadout[ "primary" ] )
				ply.oldprim = loadout[ "primary" ]

			end
			if loadout[ "secondary" ] then
				ply:Give( loadout[ "secondary" ] )
				ply.oldsec = loadout[ "secondary" ]
			end
			if loadout[ "equipment" ] then
				ply:Give( loadout[ "equipment" ] )
				ply.oldeq = loadout[ "equipment" ]
			end
			if loadout[ "role" ] then
				ply.oldrole = loadout[ "role" ]
				ply:SetNWString( "role", ply.oldrole )
			end
			if loadout[ "pattachments" ] and loadout[ "primary" ] then
				timer.Simple( 0.3, function()
					for k, v in pairs( loadout[ "pattachments" ] ) do
						ply:GetWeapon( loadout[ "primary" ] ):attachSpecificAttachment( v )
						if v == "kk_ins2_gl_gp25" or v == "kk_ins2_gl_m203" then 
							give40mm = true 
						end
					end
				end )
				ply.oldpatt = loadout[ "pattachments" ]
			end
			if loadout[ "sattachments" ] and loadout[ "secondary" ] then
				timer.Simple( 0.3, function()
					for k, v in pairs( loadout[ "sattachments" ] ) do
						ply:GetWeapon( loadout[ "secondary" ] ):attachSpecificAttachment( v, k, false )
					end
				end )
				ply.oldsatt = loadout[ "sattachments" ]
			end
		end

		if teamnumber == 1 then
			ply:Give( "cw_kk_ins2_mel_gurkha" )
		elseif teamnumber == 2 then
			ply:Give( "cw_kk_ins2_mel_bayonet" )
		else
			randomtable = { "cw_kk_ins2_mel_gurkha", "cw_kk_ins2_mel_bayonet" }
			ply:Give( table.Random( randomtable ) )
		end
		
		--//Give ammo here
		local ammoneeded = {
			[ "cw_kk_ins2_nade_m18" ] = 2,
			[ "cw_kk_ins2_nade_m67" ] = 2,
			[ "cw_kk_ins2_nade_f1" ] = 2,
			[ "cw_kk_ins2_rpg" ] = 1,
			[ "cw_kk_ins2_nade_m84" ] = 2,
			[ "cw_kk_ins2_gp25" ] = 3,
			[ "cw_kk_ins2_p2a1" ] = 2,
			[ "cw_kk_ins2_nade_c4" ] = 1,
			[ "cw_kk_ins2_at4" ] = 1,
			[ "cw_kk_ins2_nade_ied" ] = 1
		}
		local previouslyremoved = { }
		timer.Simple( 0.25, function()
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
	end )

	function GiveOldLoadout( ply )
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
			print( "The player has attachments to equip..." )
			timer.Simple( 0.3, function()
				for k, v in pairs( ply.oldpatt ) do
					print( v )
					ply:GetWeapon( ply.oldprim ):attachSpecificAttachment( v )
				end
			end )
		end
		if ply.oldsatt and ply.oldsec then
			timer.Simple( 0.3, function()
				for k, v in pairs( ply.oldsatt ) do
					ply:GetWeapon( ply.oldsec ):attachSpecificAttachment( v )
				end
			end )
		end

		if teamnumber == 1 then
			ply:Give( "cw_kk_ins2_mel_gurkha" )
		elseif teamnumber == 2 then
			ply:Give( "cw_kk_ins2_mel_bayonet" )
		else
			randomtable = { "cw_kk_ins2_mel_gurkha", "cw_kk_ins2_mel_bayonet" }
			ply:Give( table.Random( randomtable ) )
		end

		--//Give ammo here
		local ammoneeded = {
			[ "cw_kk_ins2_nade_m18" ] = 2,
			[ "cw_kk_ins2_nade_m67" ] = 2,
			[ "cw_kk_ins2_nade_f1" ] = 2,
			[ "cw_kk_ins2_rpg" ] = 1,
			[ "cw_kk_ins2_nade_m84" ] = 2,
			[ "cw_kk_ins2_gp25" ] = 3,
			[ "cw_kk_ins2_p2a1" ] = 2,
			[ "cw_kk_ins2_nade_c4" ] = 1,
			[ "cw_kk_ins2_at4" ] = 1,
			[ "cw_kk_ins2_nade_ied" ] = 1
		}
		local previouslyremoved = { }
		timer.Simple( 0.25, function()
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
	end


--[[function isPrimary( class )
	for k, v in pairs( primaries ) do
		for k2, v2 in pairs( v ) do
			if class == v2.class then
				return true
			end
		end
	end
	return false
end

function isSecondary( class )
	for k, v in pairs( secondaries ) do
		for k2, v2 in pairs( v ) do
			if class == v2.class then
				return true
			end
		end
	end
	return false
end

function isEquipment( class )
	for k, v in pairs( equipment ) do
		for k2, v2 in pairs( v ) do
			if class == v2.class then
				return true
			end
		end
	end
	return false
end

function CheckWeapons( ply )
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

hook.Add( "PlayerButtonDown", "DropWeapons", function( ply, bind ) 
	if bind == KEY_Q then
		if not ply.CanCustomizeLoadout then
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
	ply.curprimary = nil
	ply.cursecondary = nil
	ply.curequipment = nil
end )

return true

end