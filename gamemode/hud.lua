local draw = draw
local hook = hook
local math = math
local surface = surface
local table = table

local gradient = surface.GetTextureID( "gui/gradient" )
local damage = Material( "tdm/damage.png" )
local pointer = surface.GetTextureID( "gui/point.png" )

surface.CreateFont( "test", { font = "BF4 Numbers", size = 70, weight = 1, antialias = true } )
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
surface.CreateFont( "LevelBG", { font = "Exo 2", size = 18, blursize = 2 } )

surface.CreateFont( "UT3", { font = "Unreal Tournament", size = 125, antialias = false, shadow = false, outline = true } )
surface.CreateFont( "UT3-Back", { font = "Unreal Tournament", size = 128, antialias = false, shadow = false, outline = true } )
surface.CreateFont( "UT3-Small", { font = "Unreal Tournament", size = 79, antialias = true } )

local redicon = Material( "hud/redicon.png" )
local redicon2 = Material( "hud/redicon2.png" )
local blueicon = Material( "hud/blueicon.png" )
local blueicon2 = Material( "hud/blueicon2.png" )

CreateClientConVar( "hud_lag", 1, true, true )
CreateClientConVar( "hud_halo", 1, true, true )
CreateClientConVar( "hud_fade", 1, true, true )
CreateClientConVar( "hud_indicator", 1, true, true )
CreateClientConVar( "hud_showexp", 0, true, true )

-- http://lua-users.org/wiki/FormattingNumbers

LP = LocalPlayer

--//Hide the standard HL2 HUD elements
local hide = {
	"CHudHealth",
	"CHudBattery",
	"CHudAmmo",
	"CHudSecondaryAmmo",
	"CHudDamageIndictator"
}
function hidehud( name )
	if( table.HasValue( hide, name ) ) then
		return false
	end
	
	return true
end
hook.Add( "HUDShouldDraw", "hidehud", hidehud )

local musictimes = {
	[ "Militia_gamelost" ] = 9,
	[ "Militia_gamewon" ] = 13,
	[ "Militia_roundstart" ] = 12,

	[ "Navy Seals_gamelost" ] = 17,
	[ "Navy Seals_gamewon" ] = 11,
	[ "Navy Seals_roundstart" ] = 13,
	
	[ "OpFor_gamelost" ] = 9,
	[ "OpFor_gamewon" ] = 20,
	[ "OpFor_roundstart" ] = 14,
	
	[ "Spetsnaz_gamelost" ] = 21,
	[ "Spetsnaz_gamewon" ] = 13,
	[ "Spetsnaz_roundstart" ] = 15,
	
	[ "Task Force 141_gamelost" ] = 22,
	[ "Task Force 141_gamewon" ] = 10,
	[ "Task Force 141_roundstart" ] = 12,
	
	[ "US Army Rangers_gamelost" ] = 16,
	[ "US Army Rangers_gamewon" ] = 16,
	[ "US Army Rangers_roundstart" ] = 15
}

local typeannouncement = {
	--// [ "gametype" ] = "round start sound based on game type"
	[ "lts" ] = "roundstart",
	[ "moretocome" ] = "tdm"
}

net.Receive( "RoundPrepStart", function( len, ply )
	local round = tonumber( net.ReadString() )
	timer.Simple( 30 - musictimes[ team.GetName( LocalPlayer():Team() ) .. "_roundstart" ], function()
		surface.PlaySound( "music/" .. team.GetName( LocalPlayer():Team() ) .. "_roundstart.mp3" )
	end )
	timer.Simple( 30, function()
		surface.PlaySound( "dialogue/" .. team.GetName( LocalPlayer():Team() ) .. "_roundstart.wav" )
	end )
end )

net.Receive( "RoundEnd", function( len, ply )
	local victor = tonumber( net.ReadString() )
	local leader = tonumber( net.ReadString() )
	local result
	if victor == LocalPlayer():Team() then result = "roundwon" else result = "roundlost" end
	timer.Simple( 2, function()
		surface.PlaySound( "dialogue/" .. team.GetName( LocalPlayer():Team() ) .. "_" .. result .. ".wav" )
	end )
end )

net.Receive( "GameEnd", function( len, ply )
	local victor = tonumber( net.ReadString() )
	local result
	if victor == LocalPlayer():Team() then result = "gamewon" else result = "gamelost" end
	--This might need to be a general "next round" music piece
	surface.PlaySound( "music/" .. team.GetName( LocalPlayer():Team() ) .. "_" .. result .. ".mp3" )
	timer.Simple( 5, function()
		surface.PlaySound( "dialogue/" .. team.GetName( LocalPlayer():Team() ) .. "_" .. result .. math.random( 1, 3 ) .. ".wav" )
	end )
end )

net.Receive( "LastAlive", function( len, ply )
	timer.Simple( 2, function()
		surface.PlaySound( "dialogue/" .. team.GetName( LocalPlayer():Team() ) .. "_" .. "lastalive" .. math.random( 1, 5 ) .. ".wav" )
	end )
end )

--[[
usermessage.Hook( "startmusic", function()
	if LocalPlayer():Team() == 1 then
		surface.PlaySound( "mw2music/spawn/redspawn" .. math.random( 1, 2 ) .. ".ogg" )
		print( "Outcome sound: red spawn" )
	elseif LocalPlayer():Team() == 2 then
		surface.PlaySound( "mw2music/spawn/bluespawn" .. math.random( 1, 4 ) .. ".ogg" )
		print( "Outcome sound: blue spawn" )
	end
end )

usermessage.Hook( "endmusic", function()
	if GetGlobalInt( "RoundWinner" ) == 1 then
		if LocalPlayer():Team() == 1 then
			surface.PlaySound( "mw2music/victory/redvictory" .. math.random( 1, 2 ) .. ".ogg" )
			print( "Outcome sound: red victory" )
		elseif LocalPlayer():Team() == 2 then
			surface.PlaySound( "mw2music/defeat/bluedefeat" .. math.random( 1, 4 ) .. ".ogg" )
			print( "Outcome sound: blue defeat" )
		end
	elseif GetGlobalInt( "RoundWinner" ) == 2 then
		if LocalPlayer():Team() == 1 then
			surface.PlaySound( "mw2music/defeat/reddefeat" .. math.random( 1, 2 ) .. ".ogg" )
			print( "Outcome sound: red defeat" )
		elseif LocalPlayer():Team() == 2 then
			surface.PlaySound( "mw2music/victory/bluevictory" .. math.random( 1, 4 ) .. ".ogg" )
			print( "Outcome sound: blue victory" )
		end
	elseif GetGlobalInt( "RoundWinner" ) == 3 then
		if LocalPlayer():Team() == 1 then
			surface.PlaySound( "mw2music/defeat/reddefeat" .. math.random( 1, 2 ) .. ".ogg" )
			print( "Outcome sound: red defeat" )
		elseif LocalPlayer():Team() == 2 then
			surface.PlaySound( "mw2music/defeat/bluedefeat" .. math.random( 1, 4 ) .. ".ogg" )
			print( "Outcome sound: blue defeat" )
		end
	end
	print( GetGlobalInt( "RoundWinner" ) )
end )]]

net.Receive( "SetTeam", function( len, ply )
	--if LocalPlayer():Team() != 1 or LocalPlayer():Team() != 2 or LocalPlayer():Team() != 3 then
	local hoverone, hovertwo

	local teamset = vgui.Create( "DFrame" )
	teamset:SetSize( ScrW(), 500 )
	teamset:SetPos( 0, ScrH() / 5 )
	teamset:SetTitle( "" )
	teamset:SetVisible( true )
	teamset:SetDraggable( false )
	teamset:ShowCloseButton( false )
	teamset:MakePopup()
	teamset.Paint = function()
		if !teamset then return end
		surface.SetDrawColor( 0, 0, 0, 200 )
		surface.DrawRect( 0, 0, teamset:GetWide(), teamset:GetTall() )
	end

	local teamone = vgui.Create( "DButton", teamset )
	teamone:SetSize( teamset:GetWide() / 3, teamset:GetTall() )
	teamone:SetPos( 0, 0 )
	teamone:SetText( "" )
	teamone.Paint = function()
		if !teamset then return end
		surface.SetDrawColor( 100, 15, 15, 100 )
		surface.DrawRect( 0, 0, teamone:GetWide(), teamone:GetTall() )
		draw.DrawText( "Click to join:", "Exo 2 Large", teamone:GetWide() / 2, teamone:GetTall() / 7 - 10, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		draw.DrawText( team.GetName( 1 ), "Exo 2 Large", teamone:GetWide() / 2, teamone:GetTall() / 5, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		surface.SetMaterial( Material( "hud/icons/icon_" .. team.GetName( 1 ) .. ".png" ) )
		surface.SetDrawColor( 255, 255, 255, 255 )
		--surface.DrawTexturedRect( teamone:GetWide() / 2 - 185, teamone:GetTall() / 2 - 125, 270, 250 )

		if hoverone then

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
	teamtwo:SetSize( teamset:GetWide() / 3, teamset:GetTall() )
	teamtwo:SetPos( teamset:GetWide() / 3 * 2, 0 )
	teamtwo:SetText( "" )
	teamtwo.Paint = function()
		if !teamset then return end
		surface.SetDrawColor( 33, 150, 243, 100 )
		surface.DrawRect( 0, 0, teamtwo:GetWide(), teamtwo:GetTall() )
		draw.DrawText( "Click to join:", "Exo 2 Large", teamtwo:GetWide() / 2, teamtwo:GetTall() / 7 - 10, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		draw.DrawText( team.GetName( 2 ), "Exo 2 Large", teamtwo:GetWide() / 2, teamtwo:GetTall() / 5, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		surface.SetMaterial( Material( "hud/icons/icon_" .. team.GetName( 2 ) .. ".png" ) )
		surface.SetDrawColor( 255, 255, 255, 255 )
		--surface.DrawTexturedRect( 0, 0, teamtwo:GetWide() / 2, teamtwo:GetTall() / 2 )
	end
	teamtwo.OnCursorEntered = function()
		hoverone = true
	end
	teamtwo.OnCursorExited = function()
		hoverone = false
	end
	teamtwo.DoClick = function()
		surface.PlaySound( "buttons/button22.wav" )
		RunConsoleCommand( "pol_setteam", 2 )
		teamset:Close()
		teamset = nil
	end

end )

--Stolen from Zet0r
local blood_overlay = Material("hud/damageoverlay.png", "unlitgeneric smooth")
local bloodpulse = true
local pulse = 0

local badtimes = { [ 0 ] = "00", "01", "02", "03", "04", "05", "06", "07", "08", "09" }
local usedseconds

--//DermaDefault vs Exo 2
hook.Add( "HUDPaint", "hud_main", function()

	local teamnumber = LocalPlayer():Team()
	local MyTeamColor, EnemyTeamColor, MyTeamScore, EnemyTeamScore
	if teamnumber == 0 then --???
		MyTeamColor = Color( 255, 255, 255 )
		EnemyTeamColor = Color( 255, 255, 255 )
	elseif teamnumber == 1 then --red
		MyTeamColor = Color( 100, 15, 15, 100 )
		EnemyTeamColor = Color( 33, 150, 243, 100 )
		MyTeamScore = GetGlobalInt( "RedTeamWins" )
		EnemyTeamScore = GetGlobalInt( "BlueTeamWins" ) 
	elseif teamnumber == 2 then --blue
		MyTeamColor = Color( 33, 150, 243, 100 )
		EnemyTeamColor = Color( 100, 15, 15, 100 )
		MyTeamScore = GetGlobalInt( "BlueTeamWins" )
		EnemyTeamScore = GetGlobalInt( "RedTeamWins" )
    elseif teamnumber == 3 then --black/FFA
        MyTeamColor = Color( 15, 160, 15 )
		EnemyTeamColor = Color( 15, 160, 15 )
		--MyTeamScore = GetGlobalInt( "PersonalWins" ) EnemyTeamScore = GetGlobalInt( "TopEnemyWins" )
	end

	--//Center Time Rectangle
	timeleft = string.FormattedTime( tostring( GetGlobalInt( "RoundTime" ) ) )
	surface.SetDrawColor( 0, 0, 0, 200 )
	surface.DrawRect( ScrW() / 2 - 24, 2, 48, 21 )
	if badtimes[ timeleft.s ] then usedseconds = badtimes[ timeleft.s ] else usedseconds = timeleft.s end
	draw.SimpleText( timeleft.m .. ":" .. usedseconds, "DermaDefaultBold", ScrW() / 2, 12, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	--//My Team's Score Rectangle
	surface.SetDrawColor( MyTeamColor )
	surface.DrawRect( ScrW() / 2 - 48, 2, 24, 21 )
	draw.SimpleText( MyTeamScore, "DermaDefaultBold", ScrW() / 2 - 36, 12,  Color( 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	--//Enemy's Score Rectangle
	surface.SetDrawColor( EnemyTeamColor )
	surface.DrawRect( ScrW() / 2 + 24, 2, 24, 21 )
	draw.SimpleText( EnemyTeamScore, "DermaDefaultBold", ScrW() / 2 + 36, 12,  Color( 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

	surface.SetFont( "DermaDefaultBold" )
	gminfo = "Project: OneLife | WORK IN PROGRESS | Build# 102816"
	local num = surface.GetTextSize( gminfo )
	surface.SetDrawColor( 50, 50, 50, 200 )
	surface.DrawRect( 30, 30, num + 4, 20 )
	surface.SetTextColor( 255, 255, 255 )
	surface.SetTextPos( 32, 32 )
	surface.DrawText( gminfo )

	if !LocalPlayer():Alive() then return end

	local fade = (math.Clamp(LocalPlayer():Health()/LocalPlayer():GetMaxHealth(), 0.2, 0.5)-0.2)/0.3
	local fade2 = 1 - math.Clamp(LocalPlayer():Health()/LocalPlayer():GetMaxHealth(), 0, 0.5)/0.5
	
	surface.SetMaterial(blood_overlay)
	surface.SetDrawColor(255,255,255,255-fade*255)
	surface.DrawTexturedRect( -10, -10, ScrW()+20, ScrH()+20)
		
	if fade2 > 0 then
		if bloodpulse then
			pulse = math.Approach(pulse, 255, math.Clamp(pulse, 1, 50)*FrameTime()*100)
			if pulse >= 255 then bloodpulse = false end
		else
			if pulse <= 0 then bloodpulse = true end
			pulse = math.Approach(pulse, 0, -255*FrameTime())
		end
		surface.SetDrawColor(255,255,255,pulse*fade2)
		surface.DrawTexturedRect( -10, -10, ScrW()+20, ScrH()+20)
	end

	if LP():Alive() and LP():Team() ~= 0 then
		if LP():Health() < (LP():GetMaxHealth() * 0.3) and LP():Health() > (LP():GetMaxHealth() * 0.2) then
			surface.PlaySound( "hud/Heartbeat.ogg")
		elseif LP():Health() <= (LP():GetMaxHealth() * 0.2) and LP():Health() > (LP():GetMaxHealth() * 0.1) then
			surface.PlaySound( "hud/Heartbeatfaster.ogg")
		elseif LP():Health() <= (LP():GetMaxHealth() * 0.1) then
			surface.PlaySound( "hud/Heartbeatfastest.ogg")
		end
	end
	
end )

net.Receive( "tdm_deathnotice", function()
	local victim = net.ReadEntity()
	local attacker = net.ReadEntity()
	
	if attacker and victim and IsValid( attacker ) and IsValid( victim ) and attacker ~= NULL and victim ~= NULL then
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

surface.CreateFont( "Vote", { font = "Exo 2", size = 15 } )
surface.CreateFont( "Vote Larger", { font = "Exo 2", size = 20 } )
surface.CreateFont( "Vote Huge", { font = "Exo 2", size = 30 } )
--//Voting shit
net.Receive( "StartGMVote", function()
	local gametypes = net.ReadTable()
	local selectedoption

	mainframe = vgui.Create( "DFrame" )
	mainframe:SetSize( 200, ( 140 + ( 40 * ( math.Clamp( #gametypes - 4, 0, #gametypes ) ) ) ) ) --All text height = 22 title, 24 for each option name, 
	mainframe:SetPos( -201, 100 )
	mainframe:SetTitle( "" )
	mainframe:SetVisible( true )
	mainframe:SetDraggable( false )
	mainframe:ShowCloseButton( false )
	--mainframe:MakePopup()
	--mainframe:SetMouseInputEnabled( false )
	mainframe.Paint = function()
		draw.RoundedBox( 1, 0, 0, mainframe:GetWide(), mainframe:GetTall(), Color( 10, 10, 10, 230 ) )
		draw.DrawText( "Vote for a game type...", "Vote Larger", 2, 2 )
		for k, v in pairs( gametypes ) do
			draw.DrawText( k .. ". " .. v[ 2 ], "Vote", 4, 39 * ( k - 1 ) + 2 + 22 )
			draw.DrawText( v[ 3 ], "Vote", 8, 39 * ( k - 1 ) + 15 + 2 + 22 )
		end
		if selectedoption then
			surface.SetDrawColor( 255, 255, 255 )
			surface.DrawOutlinedRect( 0, 39 * ( selectedoption - 1 ) + 2 + 22, mainframe:GetWide(), 39 )
		end
	end
	local keyenums = { KEY_1, KEY_2, KEY_3, KEY_4, KEY_5, KEY_6, KEY_7, KEY_8, KEY_9 }
	mainframe.Think = function()
		if selectedoption then 
			--mainframe:SetKeyboardInputEnabled( false )
			return 
		end
		for k, v in pairs( keyenums ) do
			if input.IsKeyDown( v ) then
				selectedoption = k
				net.Start( "EndVoteCallback" )
					net.WriteString( tostring( selectedoption ) )
				net.SendToServer()
				print( "You selected option: ", gametypes[ selectedoption ][ 2 ] )
				return
			end
		end
	end
	mainframe:MoveTo( 1, 100, 2 )

	local dontuse
	net.Receive( "EndVote", function()
		if dontuse then return end
		dontuse = true
		local winner = net.ReadString()

		winnerframe = vgui.Create( "DFrame" )
		winnerframe:SetSize( 200, 100 )
		winnerframe:SetPos( -201, 100 )
		winnerframe:SetTitle( "" )
		winnerframe:SetVisible( true )
		winnerframe:SetDraggable( false )
		winnerframe:ShowCloseButton( false )
		--winnerframe:MakePopup()
		--winnerframe:SetMouseInputEnabled( false )
		--winnerframe:SetKeyboardInputEnabled( false )
		winnerframe.Paint = function()
			draw.RoundedBox( 1, 0, 0, winnerframe:GetWide(), winnerframe:GetTall(), Color( 10, 10, 10, 230 ) )
			draw.DrawText( "The winning mode is: ", "Vote Larger", 4, 4 )
			draw.DrawText( winner, "Vote Larger", 12, 28 )
		end
		mainframe:MoveTo( -201, 100, 2 )
		timer.Simple( 2.1, function()
			winnerframe:MoveTo( 1, 100, 2 )
		end )
	end )
end )

net.Receive( "StartMapVote", function()
	local maps = net.ReadTable()
	local selectedoption

	mainframe2 = vgui.Create( "DFrame" )
	mainframe2:SetSize( 200, ( 140 + ( 17 * ( math.Clamp( #maps - 4, 0, #maps ) ) ) ) ) 
	mainframe2:SetPos( -201, 100 + winnerframe:GetTall() + 2 )
	mainframe2:SetTitle( "" )
	mainframe2:SetVisible( true )
	mainframe2:SetDraggable( false )
	mainframe2:ShowCloseButton( false )
	--mainframe2:MakePopup()
	--mainframe2:SetMouseInputEnabled( false )
	mainframe2.Paint = function()
		draw.RoundedBox( 1, 0, 0, mainframe2:GetWide(), mainframe2:GetTall(), Color( 10, 10, 10, 230 ) )
		draw.DrawText( "Vote for a map...", "Vote Larger", 2, 2 )
		for k, v in pairs( maps ) do
			draw.DrawText( k .. ". " .. v, "Vote", 4, 17 * ( k - 1 ) + 2 + 22 )
		end
		if selectedoption then
			surface.SetDrawColor( 255, 255, 255 )
			surface.DrawOutlinedRect( 0, 17 * ( selectedoption - 1 ) + 2 + 22, mainframe2:GetWide(), 15 )
		end
	end
	local keyenums = { KEY_1, KEY_2, KEY_3, KEY_4, KEY_5, KEY_6, KEY_7, KEY_8, KEY_9 }
	mainframe2.Think = function()
		if selectedoption then 
			--mainframe2:SetKeyboardInputEnabled( false )
			return 
		end
		for k, v in pairs( keyenums ) do
			if input.IsKeyDown( v ) then
				selectedoption = k
				net.Start( "EndVoteCallback" )
					net.WriteString( tostring( maps[ selectedoption ] ) )
				net.SendToServer()
				print( "You selected option: ", maps[ selectedoption ] )
				return
			end
		end
	end
	mainframe2:MoveTo( 1, 100 + winnerframe:GetTall() + 2, 2 )

	net.Receive( "EndVote", function()
		local winner = net.ReadString()

		local winnerframe2 = vgui.Create( "DFrame" )
		winnerframe2:SetSize( 200, 100 )
		winnerframe2:SetPos( -201, 100 + winnerframe:GetTall() + 2 )
		winnerframe2:SetTitle( "" )
		winnerframe2:SetVisible( true )
		winnerframe2:SetDraggable( false )
		winnerframe2:ShowCloseButton( false )
		--winnerframe2:MakePopup()
		--winnerframe2:SetMouseInputEnabled( false )
		--winnerframe2:SetKeyboardInputEnabled( false )
		winnerframe2.Paint = function()
			draw.RoundedBox( 1, 0, 0, winnerframe2:GetWide(), winnerframe2:GetTall(), Color( 10, 10, 10, 230 ) )
			draw.DrawText( "The winning map is: ", "Vote Larger", 4, 4 )
			draw.DrawText( winner, "Vote Larger", 12, 28 )
		end
		mainframe2:MoveTo( -201, 100 + winnerframe:GetTall() + 2, 2 )
		timer.Simple( 2.1, function()
			winnerframe2:MoveTo( 1, 100 + winnerframe:GetTall() + 2, 2 )
		end )
	end )
end )

--Use these for the soon-to-be-implemented bombs
--[[usermessage.Hook( "enemyflagcaptured", function( um )
end )

usermessage.Hook( "friendlyflagcaptured", function( um )
end )]]

surface.CreateFont( "wlarge", {
 font = "BF4 Numbers",
 size = 100,
 weight = 0,
 antialias = true
} )

surface.CreateFont( "wsmall", {
 font = "BF4 Numbers",
 size = 60,
 weight = 0,
 antialias = true
} )

--First person death, stolen from a workshop addon
 hook.Add( "CalcView", "CalcView:GmodDeathView", function( player, origin, angles, fov )
    if IsValid( player:GetRagdollEntity() ) then --and *insert code about spectating someone here* ) then 
		local CameraPos = player:GetRagdollEntity():GetAttachment( player:GetRagdollEntity():LookupAttachment( "eyes" ) )  
		return { origin = CameraPos.Pos, angles = CameraPos.Ang, fov = 90 }
	end
end)