util.AddNetworkString( "RequestWeapons" )
util.AddNetworkString( "RequestWeaponsCallback" )
util.AddNetworkString( "RequestWeaponsList" )
util.AddNetworkString( "RequestWeaponsListCallback" )
util.AddNetworkString( "GetRank" )
util.AddNetworkString( "GetRankCallback" )
util.AddNetworkString( "GetCurWeapons" )
util.AddNetworkString( "GetCurWeaponsCallback" )
util.AddNetworkString( "GetULXRank" )
util.AddNetworkString( "GetULXRankCallback" )

function id( steamid )
	local x = string.gsub( steamid, ":", "x" )
	return x
end

function unid( steamid )
	local x = string.gsub( steamid, "x", ":" )
	return string.upper( x )
end

--== { <weapon name>, <class>, <unlock level>, <world model>, <cost>, { <damage>, <accuracy>, <rate of fire> } }               

--== RANK ASSOCIATION
--== any weapon with these unlock level will need this rank to be unlocked
--== 201: VIP
--== 202: VIP+
--== 203: Ultra VIP
--== 204: Any "Staff" Rank
--== 205: Head Admin
--== 206: Co-Owner
--== 209: Developer

primaries = {
	{ "AK-74", 		"cw_ak74", 		0, 	"models/weapons/w_rif_ak47.mdl", 		0, 		{ 0, 0, 0} },
	{ "AR-15", 		"cw_ar15", 		0, 	"models/weapons/w_rif_m4a1.mdl", 		0, 	{ 0, 0, 0} },
	{ "G3A3", 		"cw_g3a3", 		0, 	"models/weapons/w_snip_g3sg1.mdl", 		0, 	{ 0, 0, 0} },
	{ "L115", 		"cw_l115", 		0, 	"models/weapons/w_cstm_l96.mdl", 		0, 	{ 0, 0, 0} },
	{ "MP5", 		"cw_mp5", 		0, 	"models/weapons/w_smg_mp5.mdl", 		0, 	{ 0, 0, 0} },
	{ "G36C", 		"cw_g36c", 		0, 	"models/weapons/cw20_g36c.mdl", 		0, 	{ 0, 0, 0} },
	{ "M3 Super 90","cw_m3super90", 0, 	"models/weapons/w_cstm_m3super90.mdl", 	0, 	{ 0, 0, 0} },
	{ "M14", 		"cw_m14", 		0, 	"models/weapons/w_cstm_m14.mdl", 		0, 	{ 0, 0, 0} },
	{ "SCAR-H", 	"cw_scarh", 	0, 	"models/cw2/rifles/w_scarh.mdl", 		0, 	{ 0, 0, 0} },
	{ "UMP .45", 	"cw_ump45", 	0, "models/weapons/w_smg_ump45.mdl", 		0, 	{ 0, 0, 0} },
	{ "VSS", 		"cw_vss", 		0, "models/cw2/rifles/w_vss.mdl", 			0, 	{ 0, 0, 0} }
}


secondaries = {
	{ "M1911",			"cw_m1911",		0,	"models/weapons/cw_pist_m1911.mdl",		0,   	{ 0, 0, 0 } },
	{ "Deagle",			"cw_deagle",	0,	"models/weapons/w_pist_deagle.mdl",		0,   { 0, 0, 0 } },
	{ "MR96",			"cw_mr96",		0,	"models/weapons/w_357.mdl",				0,   { 0, 0, 0 } },
	{ "Five Seven",		"cw_fiveseven",	0,	"models/weapons/w_pist_fiveseven.mdl",	0,   { 0, 0, 0 } },
	{ "MAC-11",			"cw_mac11",		0,	"models/weapons/w_cst_mac11.mdl",		0,   { 0, 0, 0 } },
	{ "Makarov",		"cw_makarov",	0,	"models/cw2/pistols/w_makarov.mdl",		0,   { 0, 0, 0 } },
	{ "P99",			"cw_p99",		0,	"models/weapons/w_pist_p228.mdl",		0,   { 0, 0, 0 } }
}

extras = {
	{ "Fists", "weapon_fists", 1, "models/weapons/c_arms_citizen.mdl", 0 },
	{ "Frag Grenade x2", "grenades", 0, "models/weapons/w_cw_fraggrenade_thrown.mdl", 0 },
	{ "Flash Grenades", "cw_flash_grenade", 0, "models/weapons/w_eq_flashbang.mdl", 0 },
	{ "Smoke Grenades", "cw_smoke_grenade", 0, "models/weapons/w_eq_smokegrenade.mdl", 0 },
	{ "Medkit", "weapon_medkit", 0, "models/weapons/w_medkit.mdl", 0 }
}

perks = {}

function RegisterPerk( name, value, lvl, hint )
	table.insert( perks, { name, value, lvl, hint } )
	table.sort( perks, function( a, b ) return a[ 3 ] < b[ 3 ] end )
end

function CheckPerk( ply )
	if ply:IsPlayer() and load[ ply ] ~= nil then
		if ply.perk and load[ ply ].perk then
			return load[ ply ].perk
		end
	end
end

////////////////////

net.Receive( "RequestWeapons", function( len, ply )
	net.Start( "RequestWeaponsCallback" )
		net.WriteTable( primaries )
		net.WriteTable( secondaries )
		net.WriteTable( extras )
		net.WriteTable( perks )
	net.Send( ply )
end )

net.Receive( "RequestWeaponsList", function( len, ply )
	net.Start( "RequestWeaponsListCallback" )
		net.WriteTable( primaries )
		net.WriteTable( secondaries )
		net.WriteTable( extras )
		net.WriteTable( perks )
	net.Send( ply )
end )

net.Receive( "GetRank", function( len, ply )
	net.Start( "GetRankCallback" )
		net.WriteString( tostring( lvl.GetLevel( ply ) ) )
	net.Send( ply )
end )

net.Receive( "GetCurWeapons", function( len, ply )
	local i = id( ply:SteamID() )
	local fil = util.JSONToTable( file.Read( "tdm/users/" .. i .. ".txt", "DATA" ) )
	local tab = fil[ 2 ]
	net.Start( "GetCurWeaponsCallback" )
		if not tab or #tab == 0 then
			tab = { "" }
		end
		net.WriteTable( tab )
	net.Send( ply )
end )

////////////////////////

vip = {
	{ "vip", 201 },
--  { "operator", 201 },
	{ "vip+", 202 },
	{ "ultravip", 203 },
--	{ "admin", 204 },
	{ "superadmin", 204 },
	{ "headadmin", 205 },
	{ "coowner", 206 },
	{ "owner", 206 },
	{ "creator", 206 },
	{ "Developer", 209 },
	{ "Secret", 206 },
	{ "VIP Operator", 203 },
	{ "VIP Admin", 203 } 
}

net.Receive( "GetULXRank", function( len, ply )
	local rank = 0
	for k, v in next, vip do
		if ply:IsUserGroup( v[ 1 ] ) then
			rank = v[ 2 ]
		end
	end
	net.Start( "GetULXRankCallback" )
		net.WriteString( rank )
	net.Send( ply )
end)

////////////////////////

function isPrimary( class )
	for k, v in next, primaries do
		if class == v[ 2 ] then
			return true
		end
	end
	
	return false
end

function isSecondary( class )
	for k, v in next, secondaries do
		if class == v[ 2 ] then
			return true
		end
	end
	
	return false
end

function isExtra( class )
	for k, v in next, extras do
		if class == v[ 2 ] then
			return true
		end
	end
	
	return false
end

function FixExploit( ply, wep )
	ply:StripWeapon( wep )
	local ent = ents.Create( wep )
	ent:SetPos( ply:GetPos() )
	ent:Spawn()
end

function CheckWeapons()
	for k, v in next, player.GetAll() do
		if v and v ~= NULL and IsValid( v ) and v:Alive() then
			if v:GetWeapons() then
				local foundp = false
				local founds = false
				local founde = false
				for q, w in next, v:GetWeapons() do
					if isPrimary( w:GetClass() ) then
						if foundp then
							--FixExploit( v, w:GetClass() )
						else
							v.curprimary = w:GetClass()
							foundp = true
						end
					elseif isSecondary( w:GetClass() ) then
						if founds then
							--FixExploit( v, w:GetClass() )
						else
							v.cursecondary = w:GetClass() 
							founds = true
						end
					elseif isExtra( w:GetClass() ) then
						if founde then
							--FixExploit( v, w:GetClass() )
						else
							v.curextra = w:GetClass()
							founde = true
						end
					end
				end
				if foundp == false then
					v.curprimary = nil
				end
				if founds == false then
					v.cursecondary = nil
				end
				if founde == false then
					v.curextra = nil
				end
			end
		end
	end
end
local weaponPrevent = 0
hook.Add( "Think", "CheckPlayersWeapons", function() 
	if CurTime() > weaponPrevent then
		weaponPrevent = CurTime() + 4
		CheckWeapons()
	end
end)

hook.Add( "PlayerButtonDown", "DropWeapons", function( ply, bind ) 
	if bind == KEY_Q then
		if not ply.spawning then
			if ply and IsValid( ply ) and ply:IsPlayer() and ply:Team() ~= nil and ply:Team() ~= 0 then
				if ply:GetActiveWeapon() and ply:GetActiveWeapon() ~= NULL then
					if isExtra( ply:GetActiveWeapon():GetClass() ) then
						return
					end
					local wep = ply:GetActiveWeapon()
					local toSpawn = ents.Create( wep:GetClass() )
					toSpawn:SetClip1( wep:Clip1() )
					toSpawn:SetClip2( wep:Clip2() )
					ply:StripWeapon( wep:GetClass() )
					toSpawn:SetPos( ply:GetShootPos() + ( ply:GetAimVector() * 20 ) )
					toSpawn:Spawn()
					toSpawn.rspawn = true
					timer.Simple( 0.5, function()
						toSpawn.rspawn = nil
					end )
					timer.Simple( 15, function()
                        if toSpawn == nil || toSpawn:GetOwner() == nil then 
                            return 
                        end -- fixed by cobalt 1/30/16
						if toSpawn:GetOwner():IsValid() and toSpawn:GetOwner():IsPlayer() then 
						else
							toSpawn:Remove()
						end
					end )
					local phys = toSpawn:GetPhysicsObject()
					if phys and IsValid( phys ) and phys ~= NULL then
						phys:SetVelocity( ply:EyeAngles():Forward() * 300 )
					end
				end
			end
		end
	end
end )

function GM:WeaponEquip( wep )
	timer.Simple( 0, function() -- this will call the following on the next frame
        if wep == nil || wep:GetOwner() == nil then
            return;
        end -- fixed by cobalt 1/30/16
		if not IsValid( wep:GetOwner() ) then
			return
		end
		local ply = wep:GetOwner()
		if not ply or ply == NULL or ( not ply:IsValid() ) then
			return
		end
		if not ply.spawning then
			ply:RemoveAmmo( wep:Clip1(), wep:GetPrimaryAmmoType() )
		end
	end )
end

hook.Add( "PlayerCanPickupWeapon", "CheckPickups", function( ply, wep )
	if isPrimary( wep:GetClass() ) then
		if ply.curprimary == nil then
			if wep.rspawn then
				return false
			else
				return true
			end
		else
			return false
		end
	elseif isSecondary( wep:GetClass() ) then
		if ply.cursecondary == nil then
			if wep.rspawn then
				return false
			else		
				return true
			end
		else
			return false
		end
	elseif isExtra( wep:GetClass() ) then
		if ply.curextra == nil then
			if wep.rspawn then
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
	if ply.LastUsedWep then	
		if not isExtra( ply.LastUsedWep ) then
			local ent = ents.Create( ply.LastUsedWep )
			ent:SetPos( ply:GetPos() )
			ent:Spawn()
			timer.Simple( 15, function()
                if ent == nil || ent:GetOwner() == nil then return end -- fixed by cobalt 1/30/16
				if ent:GetOwner():IsValid() and ent:GetOwner():IsPlayer() then 
				else
					ent:Remove()
				end
			end )
		end
	end
	ply.curprimary = nil
	ply.cursecondary = nil
	ply.curextra = nil
end )