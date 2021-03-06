print( "hud initialization..." )
local draw = draw
local hook = hook
local math = math
local surface = surface
local table = table

local gradient = surface.GetTextureID( "gui/gradient" )
local damage = Material( "tdm/damage.png" )
local pointer = surface.GetTextureID( "gui/point.png" )

--[[surface.CreateFont( "test", { font = "BF4 Numbers", size = 70, weight = 1, antialias = true } )
surface.CreateFont( "ammo1", { font = "BF4 Numbers", size = 80, weight = 1, antialias = true } )
surface.CreateFont( "ammo2", { font = "BF4 Numbers", size = 40, weight = 1, antialias = true } )
surface.CreateFont( "time", { font = "BF4 Numbers", size = 30, weight = 1, antialias = true } )
surface.CreateFont( "spectime", { font = "BF4 Numbers", size = 42, weight = 1, antialias = true } )
surface.CreateFont( "getrekt", { font = "BF4 Numbers", size = 70, weight = 1, antialias = true } )
surface.CreateFont( "getrekt2", { font = "BF4 Numbers", size = 60, weight = 1, antialias = true } )
surface.CreateFont( "perky", { font = "BF4 Numbers", size = 20, weight = 1, antialias = true } )
surface.CreateFont( "hp", { font = "BF4 Numbers", size = 23, weight = 1, antialias = true } )
surface.CreateFont( "stattrak", { font = "BF4 Numbers", size = 20, weight = 1, antialias = true } )
surface.CreateFont( "lvl", { font = "BF4 Numbers", size = 15, weight = 600, antialias = true } )
surface.CreateFont( "flags", { font = "BF4 Numbers", size = 25,	weight = 1, antialias = true } )

surface.CreateFont( "PrimaryAmmo", { font = "Exo 2", size = 80 } )
surface.CreateFont( "PrimaryAmmoBG", { font = "Exo 2", size = 80, blursize = 6 } )
surface.CreateFont( "SecondaryAmmo", { font = "Exo 2", size = 40 } )
surface.CreateFont( "SecondaryAmmoBG", { font = "Exo 2", size = 40, blursize = 6 } )
surface.CreateFont( "Health", { font = "Exo 2", size = 20, weight = 500, antialias = true } )
surface.CreateFont( "HealthBG", { font = "Exo 2", size = 80, weight = 600, antialias = true } )
surface.CreateFont( "Time", { font = "Exo 2", size = 28, weight = 1 } )
surface.CreateFont( "Info", { font = "Exo 2", size = 24, weight = 1 } )
surface.CreateFont( "Killfeed", { font = "BF4 Numbers", size = 20, weight = 1 } )
surface.CreateFont( "Tickets", { font = "Exo 2", size = 45 } )
surface.CreateFont( "TicketsBG", { font = "Exo 2", size = 45, blursize = 6 } )
surface.CreateFont( "Name", { font = "Exo 2", size = 24 } )
surface.CreateFont( "NameBG", { font = "Exo 2", size = 24, blursize = 2 } )
surface.CreateFont( "Level", { font = "Exo 2", size = 18 } )
surface.CreateFont( "LevelBG", { font = "Exo 2", size = 18, blursize = 2 } )]]

-- http://lua-users.org/wiki/FormattingNumbers

--//Hide the standard HL2 HUD elements
local hide = {
	"CHudHealth",
	"CHudBattery",
	"CHudAmmo",
	"CHudSecondaryAmmo",
	"CHudDamageIndicator",
	"CHudWeaponSelection",
	"CHudZoom",
	"CHudCrosshair",
	"CHudDeathNotice"
}
function hidehud( name )
	if( table.HasValue( hide, name ) ) then
		return false
	end
	
	return true
end
hook.Add( "HUDShouldDraw", "hidehud", hidehud )

net.Receive( "CreateCountdown", function( len, ply )
	local countdowntimeleft = 30 --Just a default time if we don't receive net message Countdown
	net.Receive( "Countdown", function( len, ply )
		countdowntimeleft = tonumber( net.ReadString() )
	end )
	countdown = vgui.Create( "DFrame" )
	countdown:SetSize( 270, 30 )
	countdown:SetPos( ScrW() / 2 - ( countdown:GetWide() / 2 ), ScrH() / 6 )
	countdown:SetTitle( "" )
	countdown:SetVisible( true )
	countdown:SetDraggable( false )
	countdown:ShowCloseButton( false )
	countdown.Paint = function()
		if !countdown then return end
		draw.RoundedBox( 5, 0, 0, countdown:GetWide(), countdown:GetTall(), Color( 0, 0, 0, 240 ) )
		if countdowntimeleft == 1 then
			draw.DrawText( "Round starting in: " .. countdowntimeleft .. " second", "Exo 2 Regular", countdown:GetWide() / 2, 5, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		elseif countdowntimeleft > 1 then
			draw.DrawText( "Round starting in: " .. countdowntimeleft .. " seconds", "Exo 2 Regular", countdown:GetWide() / 2, 5, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		else
			draw.DrawText( "The round has started...", "Exo 2 Regular", countdown:GetWide() / 2, 5, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		end
	end
	countdown.Think = function()
		if countdowntimeleft == 0 then
			timer.Simple( 2, function()
				if countdown then
					countdown:Close()
					countdown = nil
				end
			end )
			countdowntimeleft = -1
		end
	end
end )

local musictimes = {
	[ "Militia_gamelost" ] = 9,
	[ "Militia_gamewon" ] = 13,
	[ "Militia_roundstart" ] = 11,

	[ "Navy Seals_gamelost" ] = 17,
	[ "Navy Seals_gamewon" ] = 11,
	[ "Navy Seals_roundstart" ] = 12,
	
	[ "OpFor_gamelost" ] = 9,
	[ "OpFor_gamewon" ] = 20,
	[ "OpFor_roundstart" ] = 14,
	
	[ "Spetsnaz_gamelost" ] = 21,
	[ "Spetsnaz_gamewon" ] = 13,
	[ "Spetsnaz_roundstart" ] = 14,
	
	[ "Task Force 141_gamelost" ] = 22,
	[ "Task Force 141_gamewon" ] = 10,
	[ "Task Force 141_roundstart" ] = 11,
	
	[ "US Army Rangers_gamelost" ] = 16,
	[ "US Army Rangers_gamewon" ] = 16,
	[ "US Army Rangers_roundstart" ] = 14
}

local typeannouncement = {
	roundstart = {"lts"},
	destroyObjective = {},
	defendObjective = {}
} --let's make this obsolete by having the team's objective as a string in the team table that we can reference on clients

net.Receive( "RoundPrepStart", function( len, ply )
	local round = tonumber( net.ReadString() )
	timer.Simple( 30 - musictimes[ team.GetName( LocalPlayer():Team() ) .. "_roundstart" ], function()
		surface.PlaySound( "music/" .. team.GetName( LocalPlayer():Team() ) .. "_roundstart.mp3" )
	end )
	timer.Simple( 30, function()
		surface.PlaySound( "announcer/" .. team.GetName( LocalPlayer():Team() ) .. "_roundstart.wav" )
	end )
end )

net.Receive( "RoundEnd", function( len, ply )
	print("RoundEnd RECEIVED")
	local victor = tonumber( net.ReadString() )
	local leader = tonumber( net.ReadString() )
	local result
	if victor == LocalPlayer():Team() then result = "roundwon" else result = "roundlost" end
	print(victor, leader, result)
	timer.Simple( 2, function()
		surface.PlaySound( "announcer/" .. team.GetName( LocalPlayer():Team() ) .. "_" .. result .. ".wav" )
	end )
end )

net.Receive( "GameEnd", function( len, ply )
	local victor = tonumber( net.ReadString() )
	local result
	if victor == LocalPlayer():Team() then result = "gamewon" else result = "gamelost" end
		surface.PlaySound( "music/" .. team.GetName( LocalPlayer():Team() ) .. "_" .. result .. ".mp3" )
	timer.Simple( 5, function()
		surface.PlaySound( "announcer/" .. team.GetName( LocalPlayer():Team() ) .. "_" .. result .. math.random( 1, 3 ) .. ".wav" )
	end )
end )

net.Receive( "LastAlive", function( len, ply )
	timer.Simple( 2, function()
		surface.PlaySound( "announcer/" .. team.GetName( LocalPlayer():Team() ) .. "_" .. "lastalive" .. math.random( 1, 5 ) .. ".wav" )
	end )
end )

net.Receive( "LowTime", function( len, ply )
	surface.PlaySound( "announcer/" .. team.GetName( LocalPlayer():Team() ) .. "_" .. "lowtime.wav" )
end )

net.Receive( "SetTeam", function( len, ply )

	net.Start( "AskTeams" )
	net.SendToServer()
	net.Receive( "AskTeamsCallback", function()
		team.SetUp( 1, net.ReadString(), Color( 255, 0, 0 ) )
		team.SetUp( 2, net.ReadString(), Color( 0, 0, 255 ) )
		team.SetUp( 3, "Solo", Color( 0, 255, 0 ) )
	end )

	--if LocalPlayer():Team() != 1 or LocalPlayer():Team() != 2 or LocalPlayer():Team() != 3 then
	local hoverone, hovertwo
	surface.SetFont( "Exo 2 Large" )
	local info1 = team.GetName( 1 ) .. " (" .. #team.GetPlayers( 1 ) .. ")"
	local info1width, info1height = surface.GetTextSize( info1 )
	local info2 = team.GetName( 2 ) .. " (" .. #team.GetPlayers( 2 ) .. ")"
	local info2width, info2height = surface.GetTextSize( info2 )
	print( "DEBUG: ", team.GetName( 1 ), info1width, team.GetName( 2 ), info2width )

	local teamset = vgui.Create( "DFrame" )
	teamset:SetSize( 400 + info1width + info2width, 300 )
	--teamset:SetPos( 0, ScrH() / 5 )
	teamset:SetTitle( "" )
	teamset:SetVisible( true )
	teamset:SetDraggable( false )
	teamset:ShowCloseButton( false )
	teamset:Center()
	teamset:MakePopup()
	teamset.Paint = function()
		if !teamset then return end
		surface.SetDrawColor( 0, 0, 0, 225 )
		surface.DrawRect( 0, 0, teamset:GetWide(), teamset:GetTall() )
		draw.DrawText( "Select a team", "Exo 2 Regular", teamset:GetWide() / 2, teamset:GetTall() / 2, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		surface.SetDrawColor( 255, 255, 255 )
		surface.DrawLine( teamset:GetWide() / 3 + 1, 10, teamset:GetWide() / 3 + 1, teamset:GetTall() - 10 )
		surface.DrawLine( teamset:GetWide() / 3 * 2 - 1, 10, teamset:GetWide() / 3 * 2 - 1, teamset:GetTall() - 10 )
	end

	local teamone = vgui.Create( "DButton", teamset )
	teamone:SetSize( teamset:GetWide() / 3 - 10, teamset:GetTall() - 10 )
	teamone:SetPos( 5, 5 )
	teamone:SetText( "" )
	teamone.Paint = function()
		if !teamset then return end
		surface.SetDrawColor( 100, 15, 15, 100 )
		surface.DrawRect( 0, 0, teamone:GetWide(), teamone:GetTall() )
		draw.DrawText( "Click to join:", "Exo 2 Large", teamone:GetWide() / 2, 20, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		draw.DrawText( team.GetName( 1 ) .. " (" .. #team.GetPlayers( 1 ) .. ")", "Exo 2 Large", teamone:GetWide() / 2, 55, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		surface.SetMaterial( Material( "hud/icons/icon_" .. team.GetName( 1 ) .. ".png" ) )
		surface.SetDrawColor( 255, 255, 255, 255 )
		surface.DrawTexturedRect( teamone:GetWide() / 2 - 50, teamone:GetTall() / 2 - 30, 100, 100 )

		if hoverone then
			surface.SetDrawColor( 200, 200, 200, 150 )
			surface.DrawRect( 0, 0, teamone:GetWide(), teamone:GetTall() )
		end
	end
	teamone.OnCursorEntered = function()
		hoverone = true
	end
	teamone.OnCursorExited = function()
		hoverone = false
	end
	teamone.DoClick = function()
		surface.PlaySound( "buttons/button22.wav" )
		RunConsoleCommand( "pol_setteam", 1 )
		teamset:Close()
		teamset = nil
	end

	local teamtwo = vgui.Create( "DButton", teamset )
	teamtwo:SetSize( teamset:GetWide() / 3 - 10, teamset:GetTall() - 10 )
	teamtwo:SetPos( teamset:GetWide() / 3 * 2 + 5, 5 )
	teamtwo:SetText( "" )
	teamtwo.Paint = function()
		if !teamset then return end
		surface.SetDrawColor( 33, 150, 243, 100 )
		surface.DrawRect( 0, 0, teamtwo:GetWide(), teamtwo:GetTall() )
		draw.DrawText( "Click to join:", "Exo 2 Large", teamtwo:GetWide() / 2, 20, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		draw.DrawText( team.GetName( 2 ) .. " (" .. #team.GetPlayers( 2 ) .. ")", "Exo 2 Large", teamtwo:GetWide() / 2, 55, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		surface.SetMaterial( Material( "hud/icons/icon_" .. team.GetName( 2 ) .. ".png" ) )
		surface.SetDrawColor( 255, 255, 255, 255 )
		surface.DrawTexturedRect( teamtwo:GetWide() / 2 - 50, teamtwo:GetTall() / 2 - 30, 100, 100 )

		if hovertwo then
			surface.SetDrawColor( 200, 200, 200, 150 )
			surface.DrawRect( 0, 0, teamtwo:GetWide(), teamtwo:GetTall() )
		end
	end
	teamtwo.OnCursorEntered = function()
		hovertwo = true
	end
	teamtwo.OnCursorExited = function()
		hovertwo = false
	end
	teamtwo.DoClick = function()
		surface.PlaySound( "buttons/button22.wav" )
		RunConsoleCommand( "pol_setteam", 2 )
		teamset:Close()
		teamset = nil
	end

end )

--Stolen from Zet0r
local blood_overlay = Material( "hud/damageoverlay.png", "unlitgeneric smooth" )
local bloodpulse = true
local pulse = 0

local badtimes = { [ 0 ] = "00", "01", "02", "03", "04", "05", "06", "07", "08", "09" }
local usedseconds

--local teamicon = Material( "hud/icons/icon_" .. team.GetName( LocalPlayer)():Team() ) .. ".png" )

--//DermaDefault? vs Exo 2
hook.Add( "HUDPaint", "hud_main", function()

	--//This all really aughta been a table...
	local teamnumber = LocalPlayer():Team()
	local MyTeamColor, EnemyTeamColor, MyTeamScore, EnemyTeamScore
	if teamnumber == 0 then --???
		MyTeamColor = Color( 0, 0, 0 )
		EnemyTeamColor = Color( 0, 0, 0 )
	elseif teamnumber == 1 then --red
		MyTeamColor = Color( 100, 15, 15, 200 )
		EnemyTeamColor = Color( 33, 150, 243, 200 )
		MyTeamScore = GetGlobalInt( "RedTeamWins" )
		EnemyTeamScore = GetGlobalInt( "BlueTeamWins" ) 
	elseif teamnumber == 2 then --blue
		MyTeamColor = Color( 33, 150, 243, 200 )
		EnemyTeamColor = Color( 100, 15, 15, 200 )
		MyTeamScore = GetGlobalInt( "BlueTeamWins" )
		EnemyTeamScore = GetGlobalInt( "RedTeamWins" )
    elseif teamnumber == 3 then --black/FFA
        MyTeamColor = Color( 15, 160, 15 )
		EnemyTeamColor = Color( 15, 160, 15 )
		--MyTeamScore = GetGlobalInt( "PersonalWins" ) EnemyTeamScore = GetGlobalInt( "TopEnemyWins" )
	end

	--//Center Time
	local lowtimecolor
	if GetGlobalInt( "RoundTime" ) < 31 and GetGlobalInt( "RoundTime" ) % 2 == 0 then
		lowtimecolor = Color( 255, 0, 0 )
	else
		lowtimecolor = Color( 255, 255, 255 )
	end
	timeleft = string.FormattedTime( tostring( GetGlobalInt( "RoundTime" ) ) )
	surface.SetDrawColor( 0, 0, 0, 200 )
	surface.DrawRect( ScrW() / 2 - 24, 2, 48, 21 )
	if badtimes[ timeleft.s ] then usedseconds = badtimes[ timeleft.s ] else usedseconds = timeleft.s end
	draw.SimpleText( timeleft.m .. ":" .. usedseconds, "DermaDefaultBold", ScrW() / 2, 12, lowtimecolor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	--//My Team's Score
	surface.SetDrawColor( MyTeamColor )
	surface.DrawRect( ScrW() / 2 - 48, 2, 24, 21 )
	draw.SimpleText( MyTeamScore, "DermaDefaultBold", ScrW() / 2 - 36, 12,  Color( 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	--//Enemy's Score
	surface.SetDrawColor( EnemyTeamColor )
	surface.DrawRect( ScrW() / 2 + 24, 2, 24, 21 )
	draw.SimpleText( EnemyTeamScore, "DermaDefaultBold", ScrW() / 2 + 36, 12,  Color( 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

	--//Gamemode information
	surface.SetFont( "DermaDefaultBold" )
	local gminfo = "Project: OneLife | WORK IN PROGRESS | Build# 110416"
	local num = surface.GetTextSize( gminfo )
	surface.SetDrawColor( 50, 50, 50, 200 )
	surface.DrawRect( 30, 30, num + 4, 20 )
	surface.SetTextColor( 255, 255, 255 )
	surface.SetTextPos( 32, 32 )
	surface.DrawText( gminfo )

	if !LocalPlayer():Alive() then return end

	--[[surface.SetFont( "DermaDefaultBold" )
	local teamname = team.GetName( LocalPlayer():Team() )
	local namewide = surface.GetTextSize( teamname )
	surface.SetTextColor( 255, 255, 255 )
	surface.SetTextPos( 54, 54 )
	surface.DrawText( teamname )]]
	if LocalPlayer():Team() == 1 or LocalPlayer():Team() == 2 or LocalPlayer():Team() == 3 then
		surface.SetDrawColor( 50, 50, 50, 200 )
		surface.DrawRect( 30, 52, 44, 44 )
		surface.SetDrawColor( 255, 255, 255 )
		surface.SetMaterial( Material( "hud/icons/icon_" .. team.GetName( LocalPlayer():Team() ) .. ".png" ) )
		surface.DrawTexturedRect( 32, 54, 40, 40 )
	end

	if LocalPlayer():GetNWString( "ArmorType", false ) then
		surface.SetDrawColor( 50, 50, 50, 200 )
		surface.DrawRect( 76, 52, 44, 44 )
		surface.SetDrawColor( 0, 0, 0 )
		surface.SetMaterial( Material( "hud/icons/kevlar_" .. LocalPlayer():GetNWString( "ArmorType" ) .. ".png" ) )
		surface.DrawTexturedRect( 78, 54, 40, 40 )
	end

	--//The Bloodied screen on low HP - thanks Zet0r
	local fade = ( math.Clamp( LocalPlayer():Health() / LocalPlayer():GetMaxHealth(), 0.2, 0.5 ) - 0.2 ) / 0.3
	local fade2 = 1 - math.Clamp( LocalPlayer():Health() / LocalPlayer():GetMaxHealth(), 0, 0.5 ) / 0.5
	
	surface.SetMaterial( blood_overlay )
	surface.SetDrawColor( 255, 255, 255, 255 - fade * 255 )
	surface.DrawTexturedRect( -10, -10, ScrW() + 20, ScrH() + 20 )
		
	if fade2 > 0 then
		if bloodpulse then
			pulse = math.Approach( pulse, 255, math.Clamp( pulse, 1, 50 ) * FrameTime() * 100 )
			if pulse >= 255 then bloodpulse = false end
		else
			if pulse <= 0 then bloodpulse = true end
			pulse = math.Approach( pulse, 0, -255 * FrameTime() )
		end
		surface.SetDrawColor( 255, 255, 255, pulse * fade2 )
		surface.DrawTexturedRect( -10, -10, ScrW() + 20, ScrH() + 20)
	end

	--//The heartbeat that plays faster the closer you are to death
	if LocalPlayer():Alive() and LocalPlayer():Team() ~= 0 then
		if LocalPlayer():Health() < (LocalPlayer():GetMaxHealth() * 0.3) and LocalPlayer():Health() > (LocalPlayer():GetMaxHealth() * 0.2) then
			surface.PlaySound( "hud/Heartbeat.ogg")
		elseif LocalPlayer():Health() <= (LocalPlayer():GetMaxHealth() * 0.2) and LocalPlayer():Health() > (LocalPlayer():GetMaxHealth() * 0.1) then
			surface.PlaySound( "hud/Heartbeatfaster.ogg")
		elseif LocalPlayer():Health() <= (LocalPlayer():GetMaxHealth() * 0.1) then
			surface.PlaySound( "hud/Heartbeatfastest.ogg")
		end
	end

	--Start drawing the armor icon depending on LocalPlayer():GetNWString( "armor" )

	boxwidth = 160
	boxheight = 20 + 2
	textfont = "Exo 2 Regular"
	--activewep = LocalPlayer():GetActiveWeapon()
	local wep1name, wep2name, wep3name, wep4name = " ", " ", " ", " "
	for k, v in pairs( LocalPlayer():GetWeapons() ) do
		if v:GetSlot() == 1 then
			wep1name = "1. " .. v.PrintName
		elseif v:GetSlot() == 2 then
			wep2name = "2. " .. v.PrintName
		elseif v:GetSlot() == 3 then
			wep3name = "3. " .. v.PrintName
		elseif v:GetSlot() == 4 then
			wep4name = "4. " .. v.PrintName
		end
	end

	surface.SetDrawColor( 0, 0, 0, 200 )
	surface.DrawRect( ScrW() / 2 - ( boxwidth * 2) - 10 - 5, ScrH() - boxheight, boxwidth, boxheight )
	surface.DrawRect( ScrW() / 2 - boxwidth - 5, ScrH() - boxheight, boxwidth, boxheight )
	surface.DrawRect( ScrW() / 2 + 5, ScrH() - boxheight, boxwidth, boxheight )
	surface.DrawRect( ScrW() / 2 + boxwidth + 10 + 5, ScrH() - boxheight, boxwidth, boxheight )
	draw.DrawText( wep1name, textfont, ScrW() / 2 - boxwidth - ( boxwidth / 2 ) - 10 - 5, ScrH() - 22, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	draw.DrawText( wep2name, textfont, ScrW() / 2 - ( boxwidth / 2 ) - 5, ScrH() - 22, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	draw.DrawText( wep3name, textfont, ScrW() / 2 + ( boxwidth / 2 ) + 5, ScrH() - 22, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	draw.DrawText( wep4name, textfont, ScrW() / 2 + boxwidth + ( boxwidth / 2 ) + 10 + 5, ScrH() - 22, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

end )

--//This might not work well in a think function... but maybe it will?
hook.Add( "Think", "WeaponSelection", function()
	local heldweapons = { }
	heldweapons[ 0 ] = heldweapons[ 4 ]
	heldweapons[ 1 ] = LocalPlayer():GetWeapons()[ 1 ] or heldweapons[ 2 ]
	heldweapons[ 2 ] = LocalPlayer():GetWeapons()[ 2 ] or heldweapons[ 3 ]
	heldweapons[ 3 ] = LocalPlayer():GetWeapons()[ 3 ] or false
	heldweapons[ 4 ] = LocalPlayer():GetWeapons()[ 4 ] or heldweapons[ 3 ]
	heldweapons[ 5 ] = heldweapons[ 1 ]

	if input.IsKeyDown( KEY_1 ) and !mainframe and !mainframe2 then
		for k, v in pairs( LocalPlayer():GetWeapons() ) do
			if v:GetSlot() == 1 then
				LocalPlayer():SelectWeapon( v:GetClass() )
			end
		end
	elseif input.IsKeyDown( KEY_2 ) and !mainframe and !mainframe2 then
		for k, v in pairs( LocalPlayer():GetWeapons() ) do
			if v:GetSlot() == 2 then
				LocalPlayer():SelectWeapon( v:GetClass() )
			end
		end
	elseif input.IsKeyDown( KEY_3 ) and !mainframe and !mainframe2 then
		for k, v in pairs( LocalPlayer():GetWeapons() ) do
			if v:GetSlot() == 3 then
				LocalPlayer():SelectWeapon( v:GetClass() )
			end
		end
	elseif input.IsKeyDown( KEY_4 ) and !mainframe and !mainframe2 then
		for k, v in pairs( LocalPlayer():GetWeapons() ) do
			if v:GetSlot() == 4 then
				LocalPlayer():SelectWeapon( v:GetClass() )
			end
		end
	elseif input.IsMouseDown( MOUSE_WHEEL_UP ) and heldweapons[ LocalPlayer():GetActiveWeapon():GetSlot() + 1 ] and !mainframe and !mainframe2 then
		LocalPlayer():SelectWeapon( heldweapons[ LocalPlayer():GetActiveWeapon():GetSlot() + 1 ] )
		print( "MOUSE_WHEEL_UP pressed" )
	elseif input.IsMouseDown( MOUSE_WHEEL_DOWN ) and heldweapons[ LocalPlayer():GetActiveWeapon():GetSlot() - 1 ] and !mainframe and !mainframe2 then
		LocalPlayer():SelectWeapon( heldweapons[ LocalPlayer():GetActiveWeapon():GetSlot() - 1 ] )
		print( "MOUSE_WHEEL_DOWN pressed" )
	end

	if input.IsMouseDown( MOUSE_WHEEL_UP ) then
		print( "MOUSE_WHEEL_UP pressed" )
	elseif input.IsMouseDown( MOUSE_WHEEL_DOWN ) then
		print( "MOUSE_WHEEL_DOWN pressed" )
	end
end )

--//Thank you Gmod wiki for having all the best solutions
local meta = FindMetaTable( "Player" )
function meta:SelectWeapon( class )
	if ( !self:HasWeapon( class ) ) then return end
	self.DoWeaponSwitch = self:GetWeapon( class )
end

hook.Add( "CreateMove", "WeaponSwitch", function( cmd )
	if ( !IsValid( LocalPlayer().DoWeaponSwitch ) ) then return end

	cmd:SelectWeapon( LocalPlayer().DoWeaponSwitch )

	if ( LocalPlayer():GetActiveWeapon() == LocalPlayer().DoWeaponSwitch ) then
		LocalPlayer().DoWeaponSwitch = nil
	end
end )

--//Can be found in init.lua - move?
net.Receive( "DeathNotice", function()
	local victim = net.ReadEntity()
	local attacker = net.ReadEntity()
	
	if attacker and victim and IsValid( attacker ) and IsValid( victim ) and attacker:IsPlayer() and victim:IsPlayer() then
		local aname = attacker:Nick()
		local ateam = attacker:Team()
		local vname = victim:Nick()
		local vteam = victim:Team()
		
		if attacker == victim then
		vname = ""
		vteam = ""
			GAMEMODE:AddDeathNotice( aname, ateam, " suicided!", vname, vteam )
		else
			GAMEMODE:AddDeathNotice( aname, ateam, " killed ", vname, vteam )
		end
	elseif attack:IsWorld() and victim:IsPlayer() then
		aname = vname
		ateam = vteam
		vname = ""
		vteam = ""
		GAMEMODE:AddDeathNotice( aname, ateam, " broke his legs.", vname, vteam )
	else
		print( " ADDDEATHNOTICE HIT AN ERROR... Attacker: ", attacker, IsValid( attacker ), " Victim: ", victim, IsValid( victim ) )
	end
end )

--I think this is the healthbar above teammate's head? Set this as the upside-down triangle, colored to show health (green = 100, red = 0)
hook.Add( "PostPlayerDraw", "hud_icon", function( ply ) 
	if !IsValid( ply ) then return end
	if ply == LocalPlayer() then return end
	if !ply:Alive() then return end
	if GetConVarNumber( "tdm_ffa" ) == 1 then return end
	if not LocalPlayer():Alive() or LocalPlayer():Team() == 0 then return end
	if ply:Team() == LocalPlayer():Team() then
		local offset = Vector( 0, 0, 80 )
		local ang = LocalPlayer():EyeAngles()
		local pos = ply:GetPos() + offset + ang:Up()
	 
		ang:RotateAroundAxis( ang:Forward(), 90 )
		ang:RotateAroundAxis( ang:Right(), 90 )

		cam.Start3D2D( pos, Angle( 0, ang.y, 90 ), 0.25 )
			draw.DrawText( ply:GetName(), "Exo 2 Content Blur", 0 + 1, -6 + 1, Color( 0, 0, 0 ), TEXT_ALIGN_CENTER )
			draw.DrawText( ply:GetName(), "Exo 2 Content", 0, -6, team.GetColor( ply:Team() ), TEXT_ALIGN_CENTER )
			surface.SetDrawColor( Color( 0, 0, 0 ) )
			surface.DrawRect( -48, 20, 96, 6 )
			surface.SetTexture( gradient )
			surface.SetDrawColor( team.GetColor( ply:Team() ) )
			surface.DrawOutlinedRect( -50, 18, 100, 10 )
			surface.DrawRect( -48, 20, 96 * ( math.Clamp( ply:Health(), 0, 100 ) / 100 ), 6 )
			surface.SetDrawColor( Color( 0, 0, 0 ) )
			surface.DrawTexturedRectRotated( -( 48 - 96 * ( math.Clamp( ply:Health(), 0, 100 ) / 100 ) / 2 ), 24, 3, 96 * ( math.Clamp( ply:Health(), 0, 100 ) / 100 ), 270 )
			surface.DrawTexturedRectRotated( -( 48 - 96 * ( math.Clamp( ply:Health(), 0, 100 ) / 100 ) / 2 ), 21, 3, 96 * ( math.Clamp( ply:Health(), 0, 100 ) / 100 ), 90 )
		cam.End3D2D()
	end
end )

--//MVP List
net.Receive( "MVPList", function()
	local mostkills = net.ReadTable()
	local mostdeaths = net.ReadTable()
	local mostheadshots = net.ReadTable()

	--Do something here...
end )

--First person death, stolen from a workshop addon
 hook.Add( "CalcView", "CalcView:GmodDeathView", function( player, origin, angles, fov )
    if IsValid( player:GetRagdollEntity() ) and !player:GetNWBool( "IsSpectating" ) then 
		local CameraPos = player:GetRagdollEntity():GetAttachment( player:GetRagdollEntity():LookupAttachment( "eyes" ) )  
		return { origin = CameraPos.Pos, angles = CameraPos.Ang, fov = 90 }
	end
end)