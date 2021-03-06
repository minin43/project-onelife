print("init initialization...")
AddCSLuaFile("cl_init.lua") -- Test comment
AddCSLuaFile("cl_fonts.lua")
AddCSLuaFile("cl_hud.lua")
AddCSLuaFile("cl_scoreboard.lua")
AddCSLuaFile("cl_lvl.lua")
AddCSLuaFile("cl_money.lua")
AddCSLuaFile("cl_flags.lua")
--AddCSLuaFile("cl_feed.lua")
AddCSLuaFile("cl_customspawns.lua")
AddCSLuaFile("cl_leaderboards.lua")
AddCSLuaFile("cl_menu_setup.lua")
AddCSLuaFile("cl_menu.lua")
AddCSLuaFile("cl_hud_voting.lua")

AddCSLuaFile("shared.lua")
AddCSLuaFile("sh_attachmenthandler.lua")
AddCSLuaFile("sh_loadoutmenu.lua")
AddCSLuaFile("sh_weaponstats.lua")
AddCSLuaFile("sh_rolehandler.lua")

include("shared.lua")
include("sh_attachmenthandler.lua")
include("sh_loadoutmenu.lua")
include("sh_rolehandler.lua")
include("sh_weaponstats.lua")
include("sv_bombs.lua")
include("sv_feed.lua")
--include("sv_flags.lua")
include("sv_customspawns.lua")
--include("sv_leaderboards.lua")
include("sv_lifestats.lua")
include("sv_lvlhandler.lua")
include("sv_moneyhandler.lua")
include("sv_playerhandler.lua")
include("sv_roundhandler.lua")
include("sv_roundstats.lua")
include("sv_votehandler.lua")
include("sv_menu.lua")
include("sv_playerspawn.lua")

--[[for k, v in pairs( file.Find("onelife/gamemode/perks/*.lua", "LUA") ) do
	include("/perks/" .. v )
end
for k, v in pairs( player.GetAll() ) do
	util.AddNetworkString("InitialUnlock")
	local list = util.JSONToTable( file.Read("onelife/users/" .. id( v:SteamID() ) .. ".txt", "DATA") )
	net.Start("InitialUnlock")
	    net.WriteTable( list[ 2 ] )
	net.Send( v )
end]]

function Team( teamnum )
	for k, v in pairs( team.GetAllTeams() ) do
		if k == teamnum then
			return v
		end
	end
end

local _Ply = FindMetaTable("Player")
function _Ply:AddScore( score )
	local num = self:GetNWInt("pol_score")
	self:SetNWInt("pol_score", num + score )
end

util.AddNetworkString("DeathNotice")
util.AddNetworkString("SetTeam")

if not file.Exists("onelife", "DATA") then
	file.CreateDir("onelife")
end

if not file.Exists("onelife/users", "DATA") then
	file.CreateDir("onelife/users")
end

function id( steamid )
	local x = string.gsub( steamid, ":", "x")
	return x
end

function unid( steamid )
	local x = string.gsub( steamid, "x", ":")
	return string.upper( x )
end

function GM:Initialize()
	
	-- remove hl2:dm weapons / ammo
	timer.Simple( 0, function()
		for k, v in pairs( ents.FindByClass("weapon_*") ) do
			SafeRemoveEntity( v )
		end
		for k, v in pairs( ents.FindByClass("item_*") ) do
			if v ~= "item_healthcharger" then
				SafeRemoveEntity( v )
			end
		end

		for k, v in pairs( ents.FindByClass("func_breakable") ) do
			SafeRemoveEntity( v )
		end
		for k, v in pairs( ents.FindByClass("prop_dynamic") ) do
			SafeRemoveEntity( v )
		end
	end )
end

function GM:PlayerConnect( name, ip )
	for k, v in pairs( player.GetAll() ) do
		v:ChatPrint("Player " .. name .. " has joined the game.")
	end
end

function GM:ShowHelp( ply ) --F1
	local wep = ply:GetActiveWeapon()
	
	if not IsValid(wep) or not wep.CW20Weapon or wep.dt.State == CW_IDLE then
		ply:ConCommand("tdm_spawnmenu")
	end
end

function GM:PlayerInitialSpawn( ply )
	print( ply, " has spawned into the server!")
	if not file.Exists("onelife/users/attachmentunlocks_" .. id( ply:SteamID() ) .. ".txt", "DATA") then --Creates the attachment unlocked file if it doesn't already exist
		file.Write("onelife/users/attachmentunlocks_" .. id( ply:SteamID() ) .. ".txt", util.TableToJSON( { ply:Name(), {} } ) )
	else
		local contents = util.JSONToTable( file.Read("onelife/users/attachmentunlocks_" .. id( ply:SteamID() ) .. ".txt") ) --Updates the file with their most recent player's name
		if ply:Name() ~= contents[ 1 ] then
			file.Write("onelife/users/attachmentunlocks_" .. id( ply:SteamID() ) .. ".txt", util.TableToJSON( { ply:Name(), contents[ 2 ] } ) )
		end
	end
	if not file.Exists("onelife/users/weaponunlocks_" .. id( ply:SteamID() ) .. ".txt", "DATA") then --Creates the weapon unlocked files if it doesn't already exist
		file.Write("onelife/users/weaponunlocks_" .. id( ply:SteamID() ) .. ".txt", util.TableToJSON( { ply:Name(), {} } ) )
	else
		local contents = util.JSONToTable( file.Read("onelife/users/weaponunlocks_" .. id( ply:SteamID() ) .. ".txt") ) --Updates the file with their most recent player's name
		if ply:Name() ~= contents[ 1 ] then
			file.Write("onelife/users/weaponunlocks_" .. id( ply:SteamID() ) .. ".txt", util.TableToJSON( { ply:Name(), contents[ 2 ] } ) )
		end
	end

	if ply:IsBot() then
		ply:SetTeam( 2 )
		self.BaseClass:PlayerSpawn( ply )
		if !GetGlobalBool("GameInProgress") then
			if file.Exists("onelife/nextmode/mode.txt", "DATA") then
				print("Enough plays have joined, starting mode: ", file.Read("onelife/nextmode/mode.txt", "DATA") )
				self:StartGame( file.Read("onelife/nextmode/mode.txt", "DATA") )
			else
				print("No mode specified, starting Last Team Standing...")
				self:StartGame("lts")
			end
		end
		return
	end

	ply:ConCommand("cw_customhud 0")
	ply:ConCommand("cw_customhud_ammo 0")
	ply:ConCommand("cw_crosshair 1")
	ply:ConCommand("cw_blur_reload 0")
	ply:ConCommand("cw_blur_customize 0")
	ply:ConCommand("cw_blur_aim_telescopic 0")
	ply:ConCommand("cw_simple_telescopics 0")
	ply:ConCommand("cw_customhud_ammo 1")
	ply:ConCommand("cw_laser_quality 1")
	ply:ConCommand("cw_alternative_vm_pos 0")

	net.Start("SetTeam")
	net.Send( ply )

	--ply:SetTeam( team.BestAutoJoinTeam() )
	anyteammate = table.Random( team.GetPlayers( ply:Team() ) )
	ply:SpectateEntity( anyteammate )
	ply:Spectate( OBS_MODE_CHASE )
	ply.InitialJoin = true
	ply:SetCanZoom( false )
	--ply:ConCommand("tdm_spawnmenu")
end

function GM:PlayerDeathSound()
	return true
end

function GM:PlayerDisconnected( ply )
	for k, v in pairs( player.GetAll() ) do
		v:ChatPrint("Player " .. ply:Nick() .. " has disconnected (" .. ply:SteamID() .. ").")
	end
	--self:DeadTeamCheck( ply )
	self:RoundCheck(ply)
end

--//Disables player-directed respawning (when clicking or pressing space)
function GM:PlayerDeathThink( ply )
	return false
end

util.AddNetworkString("ValidateTeam")

--Would have liked this to be a part of the gamemode table, but it freaks out concommand if I do so
function changeTeam(ply, cmd, args)
	if GAMEMODE.roundInProgress and ply:Alive() then
		ply:ChatPrint("Cannot switch teams while a round is in progress and you are alive")
		return
	end

	local t = tonumber( args[1] )
	
	if( t ~= 0 and t ~= 1 and t ~= 2 ) then
		ply:ChatPrint("Error: no valid team selected.")
		return
	end
		
	if( t == ply:Team() ) then
		ply:ChatPrint("You are already on that team!")
		return
	end
	
	ply:Spectate( OBS_MODE_NONE )
	ply:SetTeam( t )

	net.Start("ValidateTeam") --Gmod doesn't include any client hooks for team change validation
		net.WriteInt(t, 3)
	net.Send(ply)

	if not GAMEMODE.roundInProgress then
		if file.Exists("onelife/nextmode/mode.txt", "DATA") then
			print("Enough plays have joined, starting mode: ", file.Read("onelife/nextmode/mode.txt", "DATA") )
			GAMEMODE:StartGame( file.Read("onelife/nextmode/mode.txt", "DATA") )
		else
			print("No mode specified, starting Last Team Standing...")
			GAMEMODE:StartGame("lts")
		end
		return
	elseif not timer.Exists("Time Countdown") or not GAMEMODE.roundInProgress then
		if ply:Alive() then
			ply:Kill()
			ply:Spawn()
		end
	end
end

concommand.Add("pol_setteam", changeTeam)

--[[local function GetValid()
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
end]]

local function getTeam( ply )
	local teammates = { }
	for k, v in pairs( team.GetPlayers( ply:Team() ) ) do
		if IsValid( v ) and v:Alive() then
			table.insert( teammates, v )
		end
	end
	return teammates
end

function SetupSpectator( ply )
	ply:StripWeapons()
	local teammates = getTeam( ply )
	ply:SetNWBool("IsSpectating", true )

	if #teammates == 0 then
		ply:Spectate( OBS_MODE_ROAMING )
		return
	end
	local tospec = table.Random( teammates )
	ply:SpectateEntity( tospec )
	ply:Spectate( OBS_MODE_CHASE )
end

local function NextSpec( ply )
	if not ply:GetObserverTarget() or ply:GetObserverTarget() == NULL then
		return
	end
	local teammates = getTeam( ply )
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
	local teammates = getTeam( ply )
	if not ply:GetObserverTarget() or ply:GetObserverTarget() == NULL then
		return
	end
	local pos = table.KeyFromValue( teammates, ply:GetObserverTarget() )
	if not pos then
		return
	end
	local newpos
	if pos - 1 <= 0 then
		newpos = #teammates
	else
		newpos = pos - 1
	end
	return teammates[ newpos ]
end

hook.Add("PlayerButtonDown", "SpectatorControls", function( ply, key )
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

hook.Add("PlayerDisconnected", "Spec_DC", function( ply )
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
	--if leaderboard[ ply:Nick() ] then leaderboard[ ply:Nick() ] = nil end
end )

function GM:PlayerSpawn( ply )
	print( ply:Nick(), " has spawned!")

	util.AddNetworkString("InitialUnlock")
	local list = util.JSONToTable( file.Read("onelife/users/" .. id( ply:SteamID() ) .. ".txt", "DATA") )
	net.Start("InitialUnlock")
	    net.WriteTable( list[ 2 ] )
	net.Send( ply )

	ply:AllowFlashlight( false )

	if ( ply:Team() != 1 and ply:Team() != 2 and ply:Team() != 3 ) or not self.gameInProgress then --!GetGlobalBool("GameInProgress") then --or !GetGlobalBool("RoundInProgress") then
		print("SPAWN DEBUG", ply:Team(), self.gameInProgress)
		print( ply, " is not on a valid team, or the game hasn't been started. Disallowing spawn...")
		--ply:SilentKill()
		ply:Spectate( OBS_MODE_ROAMING )
		SetupSpectator( ply )
		return
	end
	
	--self.BaseClass:PlayerSpawn( ply )
	
	--[[local redmodels = {
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
		ply:SetModel( table.Random( redmodels ) )
	elseif ply:Team() == 2 then
		ply:SetModel (table.Random( bluemodels ) )
	end]]

	ply:SetNWBool("IsSpectating", false )

	--[[ply:SetJumpPower( 170 ) -- CTDM value was 170
	ply:SetWalkSpeed( 140 ) --CTDM value was 180
	ply:SetRunSpeed( 260 ) --CTDM value was 300]]

	ply:SetNoCollideWithTeammates( false )
end

function GM:PlayerDeath( vic, inf, att )
	if( vic:IsValid() and att:IsValid() and att:IsPlayer() ) then
		net.Start("DeathNotice")
			net.WriteEntity( vic )
			net.WriteEntity( att )
		net.Broadcast()
	end	
	
	if GetGlobalBool("GameInProgress") and GetGlobalBool("RoundInProgress") then
		timer.Simple( 3, function()
			vic:ScreenFade( SCREENFADE.OUT, Color( 0, 0, 0 ), 2, 3 )
			timer.Simple( 4, function()
				if vic and vic:IsValid() and !vic:Alive() and GetGlobalBool("GameInProgress") and GetGlobalBool("RoundInProgress") then
					SetupSpectator( vic )
				end
			end )
		end )
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

util.AddNetworkString("SetActiveWeapon")
net.Receive("SetActiveWeapon", function( len, ply )
	local wep = net.ReadString() --this isn't actually the weapon, only it's class name - to prevent excessive net messages
	if ply:HasWeapon( wep ) then ply:SelectWeapon( wep ) end
	--print( ply, " is switching to weapon: ", wep )
end )

--[[local meta = FindMetaTable("Player")
function meta:SelectWeapon( class )
	if ( !self:HasWeapon( class ) ) then return end
	self.DoWeaponSwitch = self:GetWeapon( class )
	print( self, self.DoWeaponSwitch )
end]]
if CustomizableWeaponry then
	CustomizableWeaponry.canOpenInteractionMenu = false
end