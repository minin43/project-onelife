AddCSLuaFile( "cl_init.lua" ) -- Test comment
AddCSLuaFile( "hud.lua" )
AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_scoreboard.lua" )
AddCSLuaFile( "cl_lvl.lua" )
AddCSLuaFile( "cl_loadout.lua" )
AddCSLuaFile( "cl_money.lua" )
AddCSLuaFile( "cl_flags.lua" )
AddCSLuaFile( "cl_feed.lua" )
AddCSLuaFile( "cl_customspawns.lua" )
AddCSLuaFile( "cl_leaderboards.lua" )

include( "shared.lua" )
include( "player.lua" )
include( "sv_lvlhandler.lua" )
include( "sv_loadoutmenu.lua" )
include( "sv_stattrak.lua" )
include( "sv_moneyhandler.lua" )
include( "sv_feed.lua" )
include( "sv_flags.lua" )
include( "sv_customspawns.lua" )
include( "sv_leaderboards.lua" )
include( "sv_roundhandler.lua" )
include( "sv_playerhandler.lua" )

for k, v in pairs( file.Find( "onelife/gamemode/perks/*.lua", "LUA" ) ) do
	include( "/perks/" .. v )
end

local _Ply = FindMetaTable( "Player" )
function _Ply:AddScore( score )
	local num = self:GetNWInt( "tdm_score" )
	self:SetNWInt( "tdm_score", num + score )
end

util.AddNetworkString( "tdm_loadout" )
util.AddNetworkString( "tdm_deathnotice" )

if not file.Exists( "onelife", "DATA" ) then
	file.CreateDir( "onelife" )
end

if not file.Exists( "onelife/users", "DATA" ) then
	file.CreateDir( "onelife/users" )
end

function id( steamid )
	local x = string.gsub( steamid, ":", "x" )
	return x
end

function unid( steamid )
	local x = string.gsub( steamid, "x", ":" )
	return string.upper( x )
end

function GM:Initialize()
	game.ConsoleCommand( "cw_keep_attachments_post_death 0\n" )
	
	-- remove hl2:dm weapons / ammo
	timer.Simple( 0, function()
		for k, v in pairs( ents.FindByClass( "weapon_*" ) ) do
			SafeRemoveEntity( v )
		end
		for k, v in pairs( ents.FindByClass( "item_*" ) ) do
			if v ~= "item_healthcharger" then
				SafeRemoveEntity( v )
			end
		end

		for k, v in pairs( ents.FindByClass( "func_breakable" ) ) do
			SafeRemoveEntity( v )
		end
		for k, v in pairs( ents.FindByClass( "prop_dynamic" ) ) do
			SafeRemoveEntity( v )
		end
	end )
end

function GM:PlayerConnect( name, ip )
	for k, v in pairs( player.GetAll() ) do
		v:ChatPrint( "Player " .. name .. " has joined the game." )
	end
end

function GM:ShowHelp( ply ) --F1
	local wep = ply:GetActiveWeapon()
	
	if not IsValid(wep) or not wep.CW20Weapon or wep.dt.State == CW_IDLE then
		ply:ConCommand( "tdm_spawnmenu" )
	end
end

function GM:PlayerInitialSpawn( ply )
	if not file.Exists( "onelife/users/" .. id( ply:SteamID() ) .. ".txt", "DATA" ) then
		file.Write( "onelife/users/" .. id( ply:SteamID() ) .. ".txt", util.TableToJSON( { ply:Name(), {} } ) )
	else
		local contents = util.JSONToTable( file.Read( "onelife/users/" .. id( ply:SteamID() ) .. ".txt" ) )
		if ply:Name() ~= contents[ 1 ] then
			file.Write( "onelife/users/" .. id( ply:SteamID() ) .. ".txt", util.TableToJSON( { ply:Name(), contents[ 2 ] } ) )
		end
	end

	if ply:IsBot() then
		ply:SetTeam( 2 )
		self.BaseClass:PlayerSpawn( ply )
		return
	end

	ply:ConCommand( "cw_customhud 0" )
	ply:ConCommand( "cw_customhud_ammo 0" )
	ply:ConCommand( "cw_crosshair 1" )
	ply:ConCommand( "cw_blur_reload 0" )
	ply:ConCommand( "cw_blur_customize 0" )
	ply:ConCommand( "cw_blur_aim_telescopic 0" )
	ply:ConCommand( "cw_simple_telescopics 0" )
	ply:ConCommand( "cw_customhud_ammo 1" )
	ply:ConCommand( "cw_laser_quality 1" )
	ply:ConCommand( "cw_alternative_vm_pos 0" )

	ply:SetTeam( team.BestAutoJoinTeam() )
	anyteammate = table.Random( team.GetPlayers( ply:Team() ) )
	ply:SpectateEntity( anyteammate )
	ply:Spectate( OBS_MODE_CHASE )
	--ply:ConCommand( "tdm_spawnmenu" )
end

function GM:PlayerDeathSound()
	return true
end

function GM:PlayerDisconnected( ply )
	for k, v in pairs( player.GetAll() ) do
		v:ChatPrint( "Player " .. ply:Nick() .. " has disconnected (" .. ply:SteamID() .. ")." )
	end
end

--[[function GM:PlayerDeathThink( ply )
	if ply.NextSpawnTime and ply.NextSpawnTime > CurTime() then 
		return
	end
	if ply:KeyPressed( IN_JUMP ) then
		ply:Spawn()
		umsg.Start( "CloseDeathScreen", ply )
		umsg.End()
	end
end]]

local col = {}
col[0] = Vector( 0, 0, 0 )
col[1] = Vector( 1.0, .2, .2 )
col[2] = Vector( .2, .2, 1.0 )

load = load or {} -- load[
preload = preload or {} -- preload[

net.Receive( "tdm_loadout", function( len, pl )
	local p = net.ReadString() // primary
	local s = net.ReadString() // secondary
	local e = net.ReadString() // extra
	local perks = net.ReadString()
	if( pl:IsValid() ) then
		preload[ pl ] = {
			primary = p,
			secondary = s,
			extra = e,
			perk = perks
		}
		if not load[ pl ] or not pl:Alive() then
			load[ pl ] = {
				primary = p,
				secondary = s,
				extra = e,
				perk = perks
			}
		end
	end
end )

hook.Add( "PlayerDeath", "FixLoadoutExploit", function( ply, inf, att )
	local pl = preload[ ply ]
	if ( pl ) then
		load[ ply ] = {
			primary = pl.primary,
			secondary = pl.secondary,
			extra = pl.extra,
			perk = pl.perk
		}
	end
end )

function giveLoadout( ply )
	ply:StripWeapons()
	local l = load[ply]
	if( l ) then
		ply:Give( l.primary )
		ply:Give( l.secondary )
		
		if l.extra then
			if l.extra == "grenades" then
				ply:RemoveAmmo( 2, "Frag Grenades" )
				ply:GiveAmmo( 2, "Frag Grenades", true )
			elseif l.extra == "attachment" then
				CustomizableWeaponry.giveAttachments( ply, CustomizableWeaponry.registeredAttachmentsSKey, true )
			else
				ply:Give( l.extra )
			end
		end
		
		if l.perk then
			local t = l.perk
			ply[t] = true
		end
	end
end

function changeTeam( ply, cmd, args )
	local t = tonumber( args[1] )
	
	if( t ~= 0 and t ~= 1 and t ~= 2 ) then
		ply:ChatPrint( "Error: no valid team selected." )
		return
	end
		
	if( t == ply:Team() ) then
		ply:ChatPrint( "You are already on that team!" )
		return
	end
	
	ply:Spectate( OBS_MODE_NONE )
	ply:SetTeam( t )
end


concommand.Add( "tdm_setteam", changeTeam )

local function GetValid()
	local validEnts = {}
	for k, v in next, player.GetAll() do
		if IsValid( v ) and v:Team() and v:Team() ~= 0 then
			table.insert( validEnts, v )
		end
	end
	return validEnts
end

local function getRedTeam()
	local teammates = {}
	for k, v in next, player.GetAll() do
		if IsValid( v ) and v:Team() and v:Team() == 1 then
			table.insert( teammates, v )
		end
	end
	return teammates
end

local function getBlueTeam()
	local teammates = {}
	for k, v in next, player.GetAll() do
		if IsValid( v ) and v:Team() and v:Team() == 2 then
			table.insert( teammates, v )
		end
	end
	return teammates
end

local function getBlackTeam()
	local teammates = {}
	for k, v in next, player.GetAll() do
		if IsValid( v ) and v:Team() and v:Team() == 3 then
			table.insert( teammates, v )
		end
	end
	return teammates
end

function SetupSpectator( ply )
	ply:StripWeapons()
	local teammates
	if ply:Team() == 1 then
		teammates = getRedTeam()
	elseif ply:Team() == 2 then
		teammates = getBlueTeam()
	else
		teammates = getBlackTeam()
	end
	if #teammates == 0 then
		ply:Spectate( OBS_MODE_ROAMING )
		return
	end
	ply:SpectateEntity( table.Random( teammates ) )
	ply:Spectate( OBS_MODE_CHASE )
end

local function NextSpec( ply )
	if not ply:GetObserverTarget() or ply:GetObserverTarget() == NULL then
		return
	end
	local teammates
	if ply:Team() == 1 then
		teammates = getRedTeam()
	elseif ply:Team() == 2 then
		teammates = getBlueTeam()
	else
		teammates = getBlackTeam()
	end
	if not ply:GetObserverTarget() or ply:GetObserverTarget() == NULL then
		return
	end
	local pos = table.KeyFromValue( teammates, ply:GetObserverTarget() )
	if not pos then
		return
	end
	local newpos
	if pos + 1 > #teammates then
		newpos = table.GetFirstKey( teammates )
	else
		newpos = pos + 1
	end
	return teammates[ newpos ]
end

local function PrevSpec( ply )
	if not ply:GetObserverTarget() or ply:GetObserverTarget() == NULL then
		return
	end
	local teammates
	if ply:Team() == 1 then
		teammates = getRedTeam()
	elseif ply:Team() == 2 then
		teammates = getBlueTeam()
	else
		teammates = getBlackTeam()
	end
	if not ply:GetObserverTarget() or ply:GetObserverTarget() == NULL then
		return
	end
	local pos = table.KeyFromValue( teammates, ply:GetObserverTarget() )
	if not pos then
		return
	end
	local newpos
	if pos - 1 > #teammates then
		newpos = table.GetFirstKey( teammates )
	else
		newpos = pos - 1
	end
	return teammates[ newpos ]
end

hook.Add( "PlayerButtonDown", "SpectatorControls", function( ply, key )
	if !ply:Alive() then
		if key == MOUSE_LEFT then
			if not ply:GetObserverTarget() or ply:GetObserverTarget() == ply then
				ply:SpectateEntity( anyteammate )
			else
				ply:SpectateEntity( PrevSpec( ply ) )
			end
		elseif key == MOUSE_RIGHT then
			if not ply:GetObserverTarget() or ply:GetObserverTarget() == ply then
				ply:SpectateEntity( anyteammate )
			else
				ply:SpectateEntity( NextSpec( ply ) )
			end
		end		
	end
end )

hook.Add( "PlayerDisconnected", "Spec_DC", function( ply )
	for k, v in next, player.GetAll() do
		if !v:Alive() then
			if v:GetObserverTarget() == ply then
				v:SpectateEntity( NextSpec( v ) )
				if v:GetObserverTarget() == v or v:GetObserverTarget() == nil then
					v:Spectate( anyteammate )
				end
			end
		end
	end
end )

local dontgive = {
	"fas2_ammobox",
	"fast2_ifak",
	"fas2_m67",
	"seal6-claymore"
}

function GM:PlayerSpawn( ply )
	if ply.curprimary then
		ply.curprimary = nil
	end
	if ply.cursecondary then
		ply.cursecondary = nil
	end
	if ply.curextra then
		ply.curextra = nil
	end

	if( ply:Team() == 0 ) then
		ply:Spectate( OBS_MODE_IN_EYE )
		SetupSpectator( ply )
		return
	end
	
	ply:AllowFlashlight( true )
	
	if ply:IsPlayer() and load[ ply ] ~= nil then
		if( load[ply].perk ~= nil ) then
			ply.perk = true
		else
			ply.perk = false
		end
	end
	
	self.BaseClass:PlayerSpawn( ply )
	
		local redmodels = {
		"models/player/group03/male_01.mdl",
		"models/player/group03/male_02.mdl",
		"models/player/group03/male_03.mdl",
		"models/player/group03/male_04.mdl",
		"models/player/group03/male_05.mdl"
		}
		
    local bluemodels = {
		"models/player/group03/male_06.mdl",
		"models/player/group03/male_07.mdl",
		"models/player/group03/male_08.mdl",
		"models/player/group03/male_09.mdl"
		}
		
    if ply:Team() == 1 then
		ply:SetModel(table.Random(redmodels))
	elseif ply:Team() == 2 then
		ply:SetModel(table.Random(bluemodels))
	end
	
	ply:SetPlayerColor( col[ply:Team()] )
	giveLoadout( ply )

	ply:SetJumpPower( 170 ) -- CTDM value was 170
	
	ply:SetWalkSpeed( 180 ) --CTDM value was 180
	ply:SetRunSpeed( 300 ) --CTDM value was 300


	timer.Simple( 1, function()
		if ply:IsPlayer() then
			for k, v in pairs( ply:GetWeapons() ) do
				local x = v:GetPrimaryAmmoType()
				local y = v:Clip1()
				local give = true
				
				for k2, v2 in next, dontgive do
					if v2 == v then
						give = false
						break
					end
				end
				if give == true then
					ply:GiveAmmo( ( y * 5 ), x, true )
				end
			end
			ply:GiveAmmo( 2, "40MM", true )
		end
	end )
	
	ply:SetColor( Color( 255, 255, 255, 200 ) )
	ply:SetRenderMode( RENDERMODE_TRANSALPHA )
	ply:SetNoCollideWithTeammates( true )

end

function GM:PlayerDeath( vic, inf, att )
	if( vic:IsValid() and att:IsValid() and att:IsPlayer() ) then
		net.Start( "tdm_deathnotice" )
			net.WriteEntity( vic )
			net.WriteEntity( att )
		net.Broadcast()
	end		
end

function GM:ScalePlayerDamage( ply, hitgroup, dmginfo )
	if hitgroup == HITGROUP_HEAD then
		if IsValid( ply ) then
			dmginfo:ScaleDamage( 1.5 )
		end
	elseif hitgroup == HITGROUP_CHEST then
		if IsValid( ply ) then
			dmginfo:ScaleDamage( 1 )
		end
	elseif hitgroup == HITGROUP_STOMACH then
		if IsValid( ply ) then
			dmginfo:ScaleDamage( 1 )
		end
	elseif hitgroup == HITGROUP_LEFTARM then
		if IsValid( ply ) then
			dmginfo:ScaleDamage( 0.9 )
		end
	elseif hitgroup == HITGROUP_RIGHTARM then
		if IsValid( ply ) then
			dmginfo:ScaleDamage( 0.9 )
		end
	elseif hitgroup == HITGROUP_LEFTLEG then
		if IsValid( ply ) then
			dmginfo:ScaleDamage( 0.85 )
		end
	elseif hitgroup == HITGROUP_RIGHTLEG then
		if IsValid( ply ) then
			dmginfo:ScaleDamage( 0.85 )
		end
	else
		if IsValid( ply ) then
			dmginfo:ScaleDamage( 1 )
		end
	end
end

function isPlayerMoving( ply )
	if ply:KeyDown( IN_FORWARD ) or ply:KeyDown( IN_LEFT ) or ply:KeyDown( IN_RIGHT ) or ply:KeyDown( IN_BACK ) then
		return true
	end
	
	return false
end

function GM:GetFallDamage( ply, speed )
	speed = speed - 540
	return ( speed * ( 100 / ( 1024 - 580 ) ) )
end
