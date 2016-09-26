
--OLD LAYOUT: { <weapon name>, <class>, <unlock level>, <world model>, <cost>, { <damage>, <accuracy>, <rate of fire> } }  
--NEW LAYOUT: { <weapon name>, <class>, { roles by level } }
--{ ["name"] = "", 			["class"] = "", 		["roles"] = { 0 } }

primaries = {
	["1"] = {
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
	}
	["2"] = {
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
	}
	["3"] = {
		--Intentionally left blank
	}
}


secondaries = {
	["1"] = {
		{ ["name"] = "M1911", 		["class"] = "cw_kk_ins2_m1911", 	["roles"] = { 1, 2, 3, 4, 5, 6, 7, 8 } },
		{ ["name"] = "Makarov", 	["class"] = "cw_kk_ins2_makarov", 	["roles"] = { 1, 2, 3, 4, 5, 6, 7, 8 } },
		{ ["name"] = "Model 10", 	["class"] = "cw_kk_ins2_revolver", 	["roles"] = { 1, 2, 3, 4, 5, 6, 7, 8 } }
	}
	["2"] = {
		{ ["name"] = "Beretta M9", 	["class"] = "cw_kk_ins2_m9", 		["roles"] = { 1, 2, 3, 4, 5, 6, 7, 8 } },
		{ ["name"] = "M45", 		["class"] = "cw_kk_ins2_m45", 		["roles"] = { 1, 2, 3, 4, 5, 6, 7, 8 } },
		{ ["name"] = "Model 10", 	["class"] = "cw_kk_ins2_revolver", 	["roles"] = { 1, 2, 3, 4, 5, 6, 7, 8 } }
	}
	["3"] = {
		--Intentionally left blank
	}
}

--// Layout: "Equipment name", "equipment class", "equipment worldmodel", ""
equipment = {
	["1"] = {
		{ ["name"] = "F1 Frag", 	["class"] = "cw_kk_ins2_nade_f1", 	["roles"] = { 2, 5, 7, 8 } },
		{ ["name"] = "IED", 		["class"] = "cw_kk_ins2_nade_ied", 	["roles"] = { 7 } },
		{ ["name"] = "RPG-7", 		["class"] = "cw_kk_ins2_rpg", 		["roles"] = { 5 } },
		{ ["name"] = "M18 Smoke", 	["class"] = "cw_kk_ins2_nade_m18", 	["roles"] = { 1, 2, 3, 4, 7, 8 } },
		{ ["name"] = "M84 Flash", 	["class"] = "cw_kk_ins2_nade_m84", 	["roles"] = { 1, 2, 3, 7, 8 } },
		{ ["name"] = "GP35", 		["class"] = "cw_kk_ins2_gp25", 		["roles"] = { 7 } },
		{ ["name"] = "P2A1", 		["class"] = "cw_kk_ins2_p2a1", 		["roles"] = { 1, 2, 3, 4, 5, 6, 7, 8 } } --This is the flare gun, for night maps, I guess
	}
	["2"] = {
		{ ["name"] = "M67 Frag", 	["class"] = "cw_kk_ins2_nade_m67", 	["roles"] = { 2, 5, 7, 8 } },
		{ ["name"] = "C4", 			["class"] = "cw_kk_ins2_nade_c4", 	["roles"] = { 7 } },
		{ ["name"] = "AT-4", 		["class"] = "cw_kk_ins2_at4", 		["roles"] = { 5 } },
		{ ["name"] = "M18 Smoke", 	["class"] = "cw_kk_ins2_nade_m18", 	["roles"] = { 1, 2, 3, 4, 7, 8 } },
		{ ["name"] = "M84 Flash", 	["class"] = "cw_kk_ins2_nade_m84", 	["roles"] = { 1, 2, 3, 7, 8 } },
		{ ["name"] = "GP35", 		["class"] = "cw_kk_ins2_gp25", 		["roles"] = { 7 } },
		{ ["name"] = "P2A1", 		["class"] = "cw_kk_ins2_p2a1", 		["roles"] = { 1, 2, 3, 4, 5, 6, 7, 8 } } --This is the flare gun, for night maps, I guess
	}
	["3"] = {
		--Intentionally left blank
	}
}

--// { "Blue Team Name", "Red Team Name", levelrequired, "Role Description" }
--// Refer to this for future descriptions: http://insurgency.wikia.com/wiki/Insurgency
roles = {
	{ "Rifleman", 				"Militant", 	1, "Standard fighter, gets access to most weapon types but no frag grenade." },
	{ "Reconnaissance", 		"Scout", 		2, "Lightly armored but fast-moving fighter, gets access to all short-range weaponry and all grenades." },
	{ "Support", 				"Gunner", 		3, "Supportive fighter, gets access to LMGs and some long-distance DMRs, but no frag grenades." },
	{ "Designated Marksman", 	"Sharpshooter", 4, "Lightly armored supportive fighter, gets access to all DMRs but no flash/frag grenades." },
	{ "Demolitions", 			"Striker", 		5, "Heavily armored fighter, gets access to all launchers but no smoke/flash grenade." },
	{ "Sniper", 				"Sniper", 		6, "Lightly armored supportive fighter, gets access to all sniper rifles but no grenades." },
	{ "Breacher", 				"Sapper", 		7, "Medium armored supportive fighter, gets access to all throwable and remotely detonated explosives." },
	{ "Specialist", 			"Expert", 		8, "Medium armored fighter, gets access to extra, unique weapons for proving themselves in battle." }
}

local models = { }
local function GetModels()
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
end

local function TeamThree()
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
			if !table.HasValue( equipment[3], v2 )
				table.insert( equipment[3], v2 )
			end
		end
	end
end
hook.Add( "to-do hook", "TeamThree", TeamThree() )

--Sends a table of all the weapon models for instant precaching on the client
net.Receive( "RequestWeaponModels", function( len, ply )
	GetModels()
	net.Start( "RequestWeaponModelsCallback" )
		net.WriteTable( models )
	net.Send( ply )
	table.Empty( models )
end )

--Sends a table of the player's team's weapons ONLY
net.Receive( "RequestWeapons", function( len, ply )
	local team = ply:Team()
	net.Start( "RequestWeaponsCallback" )
		net.WriteTable( primaries[team] )
		net.WriteTable( secondaries[team] )
		net.WriteTable( equipment[team] )
	net.Send( ply )
	end
end )

--Sends a table of all roles (we can't seperate this base on team because of the table's structure)
net.Receive( "RequestRoles", function( len, ply )
	net.Start( "RequestRolesCallback" )
		net.WriteTable( roles )
	net.Send( ply )
end )

--Sends a player's rank (obviously) for use with the Roles tables
net.Receive( "GetRank", function( len, ply )
	net.Start( "GetRankCallback" )
		net.WriteString( tostring( lvl.GetLevel( ply ) ) )
	net.Send( ply )
end )


--//Up next is a bunch of weapon detection for allowing/disallowing certain item pickups//--


function isPrimary( class )
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
	end
end

hook.Add( "PlayerButtonDown", "DropWeapons", function( ply, bind ) 
	if bind == KEY_Q then
		if not ply.CanCustomizeLoadout then
			if ply and IsValid( ply ) and ply:IsPlayer() and ply:Alive() then
				ply:ConCommand( "cw_dropweapon" )
			end
		end
	end
end )

hook.Add( "AllowPlayerPickup" "CheckPickups", function( ply, ent )
	if !ent:IsWeapon then return end
	CheckWeapons( ply )
	if isPrimary( wep:GetClass() ) then
		if ply.curprimary == nil then
			if ent.rspawn then
				return false
			else
				return true
			end
		else
			return false
		end
	elseif isSecondary( ent:GetClass() ) then
		if ply.cursecondary == nil then
			if ent.rspawn then
				return false
			else		
				return true
			end
		else
			return false
		end
	elseif isEquipment( ent:GetClass() ) then
		if ply.curequipment == nil then
			if ent.rspawn then
				return false
			else		
				return true
			end
		else
			return false
		end
	end
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