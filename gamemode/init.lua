AddCSLuaFile( "cl_init.lua" ) -- Test comment
AddCSLuaFile( "hud.lua" )
AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "spawnmenu.lua" )
AddCSLuaFile( "cl_scoreboard.lua" )
AddCSLuaFile( "cl_lvl.lua" )
AddCSLuaFile( "cl_loadout.lua" )
AddCSLuaFile( "cl_money.lua" )
AddCSLuaFile( "cl_flags.lua" )
AddCSLuaFile( "cl_feed.lua" )
AddCSLuaFile( "cl_deathscreen.lua" )
AddCSLuaFile( "cl_customspawns.lua" )
AddCSLuaFile( "cl_leaderboards.lua" )

include( "shared.lua" )
include( "player.lua" )
include( "sv_lvl.lua" )
include( "sv_loadout.lua" )
include( "sv_stattrak.lua" )
include( "sv_money.lua" )
include( "sv_feed.lua" )
include( "sv_flags.lua" )
include( "sv_deathscreen.lua" )
include( "sv_customspawns.lua" )
include( "sv_leaderboards.lua" )
include( "sv_teambalance.lua" )
include( "sv_roundhandler.lua" )

for k, v in pairs( file.Find( "onelife/gamemode/perks/*.lua", "LUA" ) ) do
	include( "/perks/" .. v )
end

local _Ply = FindMetaTable( "Player" )
function _Ply:AddScore( score )
	local num = self:GetNWInt( "tdm_score" )
	self:SetNWInt( "tdm_score", num + score )
end

local _flags = file.Find( "flags/*", "GAME" )
for k, v in next, _flags do
	resource.AddSingleFile( "flags/" .. v )
end

util.AddNetworkString( "tdm_loadout" )
util.AddNetworkString( "tdm_spawnoverlay" )
util.AddNetworkString( "tdm_deathnotice" )
util.AddNetworkString( "tdm_killcountnotice" )

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

local color_red = Color( 255, 0, 0 )
local color_blue = Color( 0, 0, 255 )
local color_green = Color( 102, 255, 51 )
local color_white = Color( 255, 255, 255 )

function EndRound( win, lose )
	timer.Destroy( "RoundTimer" )
	timer.Destroy( "Tickets" )
	hook.Run( "MatchHistory_MatchComplete" )
	if not GetGlobalBool( "RoundFinished" ) == true then
		SetGlobalBool( "RoundFinished", true )
		if win == 1 and lose == 2 then
			for k, v in next, team.GetPlayers( 1 ) do
				umsg.Start( "tdm_win", v )
				umsg.End()
                AddNotice(v, "WON THE ROUND", SCORECOUNTS.ROUND_WON, NOTICETYPES.ROUND)
                AddRewards(v, SCORECOUNTS.ROUND_WON)
			end
			for k, v in next, team.GetPlayers( 2 ) do
				umsg.Start( "tdm_lose", v )
				umsg.End()
                AddNotice(v, "LOST THE ROUND", SCORECOUNTS.ROUND_LOST, NOTICETYPES.ROUND)
                AddRewards(v, SCORECOUNTS.ROUND_LOST)
			end
		elseif win == 2 and lose == 1 then
			for k, v in next, team.GetPlayers( 2 ) do
				umsg.Start( "tdm_win", v )
				umsg.End()
                AddNotice(v, "WON THE ROUND", SCORECOUNTS.ROUND_WON, NOTICETYPES.ROUND)
                AddRewards(v, SCORECOUNTS.ROUND_WON)
			end
			for k, v in next, team.GetPlayers( 1 ) do
				umsg.Start( "tdm_lose", v )
				umsg.End()
                AddNotice(v, "LOST THE ROUND", SCORECOUNTS.ROUND_LOST, NOTICETYPES.ROUND)
                AddRewards(v, SCORECOUNTS.ROUND_LOST)
			end	
		elseif win == 0 and lose == 0 then
			for k, v in next, player.GetAll() do
				umsg.Start( "tdm_tie", v )
				umsg.End()
                AddNotice(v, "TIED", SCORECOUNTS.ROUND_TIED, NOTICETYPES.ROUND)
                AddRewards(v, SCORECOUNTS.ROUND_TIED)
			end
		end
        for k, v in pairs( ents.FindByClass( "cw_*" ) ) do
            SafeRemoveEntity( v )
        end
        hook.Call( "Pointshop2GmIntegration_RoundEnded" )
		timer.Create( "StopRespawningWithWeapons", 5, 5, function() 
        for k, v in next, player.GetAll() do
            if v:Team() ~= 0 then
                v:StripWeapons()
                v:Give( "weapon_crowbar" )
                v:SetWalkSpeed( 200 )
                v:SetRunSpeed( 360 )
            end

        end
		end )
        if win == 1 then
            ULib.tsayColor( nil, true, color_red, "Red Team Won! ", color_white, "Mapvote will start in ", color_green, "30 seconds", color_white, "." )
        elseif win == 2 then
            ULib.tsayColor( nil, true, color_blue, "Blue Team Won! ", color_white, "Mapvote will start in ", color_green, "30 seconds", color_white, "." )
        elseif win == 0 then
            ULib.tsayColor( nil, true, color_green, "Tie! ", color_white, "Mapvote will start in ", color_green, "30 seconds", color_white, "." )
        else
            ULib.tsayColor( nil, true, color_green, "Unknown Win Condition, something broke! ", color_white, "Mapvote will start in ", color_green, "30 seconds", color_white, "." )
        end
        timer.Create( "notify_players", 1, 30, function()
            if timer.RepsLeft( "notify_players" ) % 5 == 0 then
                ULib.tsayColor( nil, true, color_white, "Mapvote will start in ", color_green, tostring( timer.RepsLeft( "notify_players" ) ) .. " seconds", color_white, "." )
            end
        end )
        timer.Simple( 30, function()
            if MAPVOTE then
                MAPVOTE:StartMapVote()
            end
        end )
    end
end

function GM:Initialize()

	SetGlobalInt( "RoundTime", 1800 ) -- 30 mins
	SetGlobalBool( "RoundFinished", false )
	
	SetGlobalInt( "RedTickets", 300 )	--
	SetGlobalInt( "BlueTickets", 300 )	-- all of these should be the same number
	SetGlobalInt( "MaxTickets", 300 ) 	--
	
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
	
	timer.Create( "RoundTimer", 1, 0, function()
		local cur = GetGlobalInt( "RoundTime" )
		if cur - 1 > 0 then
			SetGlobalInt( "RoundTime", cur - 1 )
		elseif cur - 1 <= 0 and GetGlobalBool( "RoundFinished" ) ~= true then
			SetGlobalInt( "RoundTime", 0 )
			if GetGlobalBool( "ticketmode" ) then
				local bl = GetGlobalInt( "BlueTickets" )
				local re = GetGlobalInt( "RedTickets" )
				if bl > re then
					EndRound( 2, 1 )
				elseif re > bl then
					EndRound( 1, 2 )
				elseif re == bl then
					EndRound( 0, 0 )
				end
			else
				if GetGlobalInt( "control" ) == 1 then
					EndRound( 1, 2 )
				elseif GetGlobalInt( "control" ) == 2 then
					EndRound( 2, 1 )
				elseif GetGlobalInt( "control" ) == 0 then
					EndRound( 0, 0 )
				else
					EndRound( 0, 0 )
				end
			end
		end
	end )
end

function GM:Think()
	if GetGlobalBool( "RoundFinished" ) then
		if not GetConVar( "sv_alltalk" ):GetInt() == 3 then
			game.ConsoleCommand( "sv_alltalk 3\n" )
		end
	else
		return
	end
end

function GM:PlayerConnect( name, ip )
	for k, v in pairs( player.GetAll() ) do
		v:ChatPrint( "Player " .. name .. " has joined the game." )
	end
end

function GM:ShowHelp( ply )
	local wep = ply:GetActiveWeapon()
	
	if not IsValid(wep) or not wep.CW20Weapon or wep.dt.State == CW_IDLE then
		ply:ConCommand( "tdm_spawnmenu" )
	end
end

function GM:ShowTeam( ply )
	local wep = ply:GetActiveWeapon()
	
	if not IsValid(wep) or not wep.CW20Weapon or wep.dt.State == CW_IDLE then
		ply:ConCommand( "tdm_loadout" )
		umsg.Start( "ClearTable", ply )
		umsg.End()
	end
end

function GM:ShowSpare1( ply )
	local wep = ply:GetActiveWeapon()
	
	if not IsValid(wep) or not wep.CW20Weapon or wep.dt.State == CW_IDLE then
		--ply:PS_ToggleMenu()
	end
end

function GM:ShowSpare2( ply )
	local tr = util.TraceLine( util.GetPlayerTrace( ply ) )

	if IsValid( tr.Entity ) then ply:PrintMessage( HUD_PRINTCONSOLE, "ent: " .. tr.Entity:GetClass() ) end
end

defaultWalkSpeed = 180
defaultRunSpeed = 300

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
		ply:SetTeam( 1 )
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

	--[[for i=1, 9 do
		ply:ConCommand( "bind \"" .. i .. "\" \"slot" .. i .. "\"" )
		print(" bind \"" .. i .. "\" \"slot" .. i .. "\"" )
	end]]

	ply:SetTeam( team.BestAutoJoinTeam() )
	ply:SpectateEntity( anyteammate )
	ply:Spectate( OBS_MODE_CHASE )
	--ply:ConCommand( "tdm_spawnmenu" )
end

function GM:PlayerDeathSound()
	return true
end

timer.Create( "Tickets", 5, 0, function()
    local f = flags[game.GetMap()];
    if f != nil then
        local numFlags = #f;
        if numFlags > 0 then
            SetGlobalBool( "ticketmode", true )
        else
            SetGlobalBool( "ticketmode", false )
        end
    else
        SetGlobalBool("ticketmode", false);
    end -- fixed by cobalt 1/30/2015
    
	if GetGlobalBool( "ticketmode" ) == true then
		if GetGlobalInt( "control" ) == 1 then
			if GetGlobalInt( "allcontrol" ) == 1 then
				SetGlobalInt( "BlueTickets", GetGlobalInt( "BlueTickets" ) - 2 )
				if GetGlobalInt( "BlueTickets" ) <= 0 then
					EndRound( 1, 2 )
				end
			else
				SetGlobalInt( "BlueTickets", GetGlobalInt( "BlueTickets" ) - 1 )
				if GetGlobalInt( "BlueTickets" ) <= 0 then
					EndRound( 1, 2 )
				end
			end
		elseif GetGlobalInt( "control" ) == 2 then
			if GetGlobalInt( "allcontrol" ) == 2 then
				SetGlobalInt( "RedTickets", GetGlobalInt( "RedTickets" ) - 2 )
				if GetGlobalInt( "RedTickets" ) <= 0 then
					EndRound( 2, 1 )
				end			
			else
				SetGlobalInt( "RedTickets", GetGlobalInt( "RedTickets" ) - 1 )
				if GetGlobalInt( "RedTickets" ) <= 0 then
					EndRound( 2, 1 )
				end					
			end
		end
	end
end )

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

hook.Add( "PlayerSay", "tdm_say", function( ply, text, bTeam )
	local tab = {
		"how do i switch weapons",
		"switch weapons",
		"change weapons",
		"change loadout",
		"switch loadout",
		"different weapons",
		"how do i change weapons"
	}		
		
	if( text:lower() == "!team" ) then
		ply:ConCommand( "tdm_spawnmenu" )
	elseif( text:lower() == "!loadout" ) then
		ply:ConCommand( "tdm_loadout" )
		umsg.Start( "ClearTable", ply )
		umsg.End()
	end
	for k, v in next, tab do
		if string.find( text:lower(), v ) then
			ULib.tsayColor( nil, false, Color( 255, 255, 255 ), "To change your loadout, press F2." )
			break
		end
	end	
	return
end )



local col = {}
col[0] = Vector( 0, 0, 0 )
col[1] = Vector( 1.0, .2, .2 )
col[2] = Vector( .2, .2, 1.0 )

load = load or {}
preload = preload or {}

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

	hook.Run( "MatchHistory_JoinTeam", ply, t )
	
	ply:Spectate( OBS_MODE_NONE )
	ply:SetTeam( t )
	ply:Spawn()
	if ply:Team() == 0 then
		ULib.tsayColor( nil, false, Color( 255, 255, 255 ), "Player ", team.GetColor( ply:Team() ), ply:Nick(), Color( 255, 255, 255 ), " is joining the spectators" )
	elseif ply:Team() == 1 then
		ULib.tsayColor( nil, false, Color( 255, 255, 255 ), "Player ", team.GetColor( ply:Team() ), ply:Nick(), Color( 255, 255, 255 ), " is joining the ", team.GetColor( ply:Team() ), "red team" )
	elseif ply:Team() == 2 then
		ULib.tsayColor( nil, false, Color( 255, 255, 255 ), "Player ", team.GetColor( ply:Team() ), ply:Nick(), Color( 255, 255, 255 ), " is joining the ", team.GetColor( ply:Team() ), "blue team" )
	end
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

function SetupSpectator( ply )
	ply:StripWeapons()
	local ent = GetValid()
	if #ent == 0 then
		ply:Spectate( OBS_MODE_ROAMING )
		return
	end
	ply:SpectateEntity( table.Random( ent ) )
	ply:Spectate( OBS_MODE_IN_EYE )
end

local function NextSpec( ply )
	if ply:Team() == 0 then
		local specs = GetValid()
		if not ply:GetObserverTarget() or ply:GetObserverTarget() == NULL then
			return
		end
		local pos = table.KeyFromValue( specs, ply:GetObserverTarget() )
		if not pos then
			return
		end
		local newpos
		if pos + 1 > #specs then
			newpos = table.GetFirstKey( specs )
		else
			newpos = pos + 1
		end
		return specs[ newpos ]
	end
end

local function PrevSpec( ply )
	if ply:Team() == 0 then
		local specs = GetValid()
		if not ply:GetObserverTarget() or ply:GetObserverTarget() == NULL then
			return
		end
		local pos = table.KeyFromValue( specs, ply:GetObserverTarget() )
		if not pos then
			return
		end
		local newpos
		if pos - 1 < 1 then
			newpos = table.GetLastKey( specs )
		else
			newpos = pos - 1
		end
		return specs[ newpos ]
	end
end

hook.Add( "PlayerButtonDown", "SpectatorControls", function( ply, key )
	if ply:Team() == 0 then
		if key == KEY_R then
			if ply:GetObserverMode() == OBS_MODE_IN_EYE then
				ply:Spectate( OBS_MODE_CHASE )
			elseif ply:GetObserverMode() == OBS_MODE_CHASE then
				ply:Spectate( OBS_MODE_ROAMING )
			elseif ply:GetObserverMode() == OBS_MODE_ROAMING then
				ply:Spectate( OBS_MODE_IN_EYE )
			end
		elseif key == MOUSE_LEFT and ply:GetObserverMode() ~= OBS_MODE_ROAMING then
			if not ply:GetObserverTarget() or ply:GetObserverTarget() == ply then
				ply:SpectateEntity( GetValid()[ 1 ] )
			else
				ply:SpectateEntity( PrevSpec( ply ) )
			end
		elseif key == MOUSE_RIGHT and ply:GetObserverMode() ~= OBS_MODE_ROAMING then
			if not ply:GetObserverTarget() or ply:GetObserverTarget() == ply then
				ply:SpectateEntity( GetValid()[ 1 ] )
			else
				ply:SpectateEntity( NextSpec( ply ) )
			end
		end		
	end
end )

hook.Add( "PlayerDisconnected", "Spec_DC", function( ply )
	for k, v in next, player.GetAll() do
		if v:Team() == 0 then
			if v:GetObserverTarget() == ply then
				v:SpectateEntity( NextSpec( v ) )
				if v:GetObserverTarget() == v or v:GetObserverTarget() == nil then
					v:Spectate( OBS_MODE_ROAMING )
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
	
	ply.spawning = true
	
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
        --[["models/characters/insurgent_standard.mdl",
		"models/characters/insurgent_sapper.mdl",
		"models/characters/insurgent_machinegunner.mdl",
		"models/characters/insurgent_light.mdl",
		"models/characters/insurgent_heavy.mdl",
		"models/characters/insurgent_fighter.mdl"]]
		}
    local bluemodels = {
		"models/player/group03/male_06.mdl",
		"models/player/group03/male_07.mdl",
		"models/player/group03/male_08.mdl",
		"models/player/group03/male_09.mdl"
        --[["models/characters/security_standard.mdl",
		"models/characters/security_rifleman.mdl",
		"models/characters/security_light.mdl",
		"models/characters/security_heavy.mdl",
		"models/characters/security_specialist.mdl"]]
		}
    if (ply:Team() == 1) then
		ply:SetModel(table.Random(redmodels))
	elseif (ply:Team() == 2) then
		ply:SetModel(table.Random(bluemodels))
	end
	ply:SetPlayerColor( col[ply:Team()] )
	giveLoadout( ply )
	
	--default walk speed 180
	--default run speed 300

	ply:SetJumpPower( 170 ) -- Decreased Jump hight due to jumping bastards.
	
	ply:SetWalkSpeed( defaultWalkSpeed )
	ply:SetRunSpeed( defaultRunSpeed )

	if GetGlobalBool( "RoundFinished" ) then
		ply:SetWalkSpeed( 200 )
		ply:SetRunSpeed( 360 )
	end

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
	net.Start( "tdm_spawnoverlay" )
		net.WriteString( "" )
	net.Send( ply )
	
	timer.Simple( 5, function()
		if ply and ply ~= NULL then
			ply:SetMaterial( "" )
			ply:SetColor( Color( 255, 255, 255, 255 ) )
			ply.spawning = false
		end
	end )
	
	if GetGlobalBool( "RoundFinished" ) then
		timer.Simple( 0, function()
			--ply:GodEnable()
			ply:StripWeapons()
			ply:Give( "weapon_crowbar" )
		end )
	end

end

function GM:PlayerDeath( vic, inf, att )
	if( vic:IsValid() and att:IsValid() and att:IsPlayer() ) then
		if( vic == att ) then
			return
		end
		vic:SetFOV( 0, 0 )
		net.Start( "tdm_deathnotice" )
			net.WriteEntity( vic )
			net.WriteString( att.LastUsedWep )
			net.WriteEntity( att )
			net.WriteString( tostring( vic:LastHitGroup() == HITGROUP_HEAD ) )
		net.Broadcast()
		if GetGlobalBool( "ticketmode" ) then
			local t = vic:Team()
			if t == 1 then
				SetGlobalInt( "RedTickets", GetGlobalInt( "RedTickets" ) - 1 )
				if GetGlobalInt( "RedTickets" ) <= 0 then
					EndRound( 1, 2 )
				end
			elseif t == 2 then
				SetGlobalInt( "BlueTickets", GetGlobalInt( "BlueTickets" ) - 1 )
				if GetGlobalInt( "BlueTickets" ) <= 0 then
					EndRound( 2, 1 )
				end
			end
		end
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
			dmginfo:ScaleDamage( 0.8 )
		end
	elseif hitgroup == HITGROUP_RIGHTLEG then
		if IsValid( ply ) then
			dmginfo:ScaleDamage( 0.8 )
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

function GM:EntityTakeDamage( ply, dmginfo )
	if( ply.spawning ) then
		local dmg = dmginfo:GetDamage()
		if dmginfo:GetAttacker() and dmginfo:GetAttacker() ~= NULL and dmginfo:GetAttacker():IsPlayer() and dmginfo:GetAttacker():Team() ~= ply:Team() then
			dmginfo:GetAttacker():TakeDamage( dmg )
			dmginfo:GetAttacker():ChatPrint( "Don't shoot people in spawn protection!" )
		end
		dmginfo:ScaleDamage( 0 )
		return dmginfo
	end
	
	if( dmginfo:GetAttacker():IsPlayer() and dmginfo:GetAttacker().spawning ) then
		dmginfo:GetAttacker().spawning = false
		--dmginfo:ScaleDamage( 0 )
		return dmginfo
	end
	
	if( GetConVarNumber( "tdm_ffa" ) == 1 ) then
		if( not dmginfo:IsExplosionDamage() ) then
			dmginfo:ScaleDamage( 1 )
		end
	end
	
    return dmginfo
end

function GM:GetFallDamage( ply, speed )
	speed = speed - 540
	return ( speed * ( 100 / ( 1024 - 580 ) ) )
end

hook.Add( "EntityTakeDamage", "DamageIndicator", function( vic, dmg )
	local ply = dmg:GetAttacker()
	if vic:IsValid() and vic:IsPlayer() and ply:IsValid() and ply:IsPlayer() and ply:Team() ~= vic:Team() then
		umsg.Start( "damage", vic )
			umsg.Vector( ply:GetPos() )
		umsg.End()
	end
end )

hook.Add( "PlayerDeath", "DamageIndicatorClear", function( vic )
	umsg.Start( "damage_death", vic )
	umsg.End()
end )
