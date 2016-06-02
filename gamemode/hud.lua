local draw = draw
local hook = hook
local math = math
local surface = surface
local table = table

local gradient = surface.GetTextureID( "gui/gradient" )
local damage = Material( "tdm/damage.png" )

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
--CreateClientConVar( "hud_old", 0, true, true )

--CreateClientConVar( "hud_zoom", 1, true, true )
--CreateClientConVar( "whuppowhatareyoudoingpleasestopthis", 0, true, true )

-- http://lua-users.org/wiki/FormattingNumbers
local function comma_value( amount )
	local formatted = amount
	while true do  
		formatted, k = string.gsub( formatted, "^(-?%d+)(%d%d%d)", '%1,%2' )
		if ( k == 0 ) then
			break
		end
	end
	return formatted
end

LP = LocalPlayer

weps = {}
CurrentLifeWeps = {}
capture = {}

net.Receive( "SendInitialStatTrak", function()
	CurrentLifeWeps = net.ReadTable()
	weps = net.ReadTable()
end )

net.Receive( "UpdateStatTrak", function()
	local wep = net.ReadString()
	local newnum = net.ReadString()

	for k, v in next, CurrentLifeWeps do
		if v[ 1 ] == wep then
			v[ 2 ] = newnum
		end
	end
end )

net.Receive( "BroadcastCaptures", function()
	local tab = net.ReadTable()
	capture = tab
end )

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

function surface.DrawFadingText( col, text )
	local alpha = math.Round( 0.5 * ( 1 + math.sin( 2 * math.pi * 0.6 * CurTime() ) ), 3 )
	local color = col
	color.a = alpha * 255
	surface.SetTextColor( color )
	surface.DrawText( text )
end

function EndScreen()
	local fade = math.Round( 0.5 * ( 1 + math.sin( 2 * math.pi * 0.6 * CurTime() ) ), 3 )
end

local hl = {}

hitpos = {}
local hpdrain = 0

usermessage.Hook( "startmusic", function()
	surface.PlaySound( "mw2music/spawn/rangerspawn.ogg" )
end )

usermessage.Hook( "endmusic", function()
	surface.PlaySound( "mw2music/victory/rangervictory.ogg" )
end )

usermessage.Hook( "damage", function( msg )
	if GetConVarNumber( "hud_indicator" ) == 0 then return end

	local dmg = msg:ReadVector()
	local pos = LocalPlayer():GetPos()
	local png = LocalPlayer():EyeAngles()
	if png.y < -90 and png.y > 90 then
		png.y = png.y + 360
	elseif png.y > 90 and png.y < -90 then
		png.y = png.y - 360
	end
	local vec = dmg - pos
	local ang = vec:Angle()
	local ttl = 4
	--print( ang.y - png.y )
	table.insert( hitpos, { ang.y - png.y, ttl } )
end )

usermessage.Hook( "damage_death", function()
	hitpos = {}
end )


local drawtime = {
	{ x = ScrW() / 2 - 90 + 20, y = 0 },
	{ x = ScrW() / 2 + 90 - 22, y = 0 },
	{ x = ScrW() / 2 + 75 - 22, y = 30 },
	{ x = ScrW() / 2 - 75 + 20, y = 30 }
}
local drawtime_fix = {
	{ x = ScrW() / 2 - 90 + 20, y = 22 },
	{ x = ScrW() / 2 + 90 - 22, y = 22 },
	{ x = ScrW() / 2 + 75 - 22, y = 30 },
	{ x = ScrW() / 2 - 75 + 20, y = 30 }
}
local drawscore = {
	{ x = ScrW() / 2 - 90 - 40, y = 0 },
	{ x = ScrW() / 2 + 90 + 42, y = 0 },
	{ x = ScrW() / 2 + 75 + 42, y = 22 },
	{ x = ScrW() / 2 - 75 - 40, y = 22 }
}

globalblue, globalred, bluealpha, redalpha = 0, 0, 0, 0
levelpercent = 0
curmoney = 0

function draw.Circle( x, y, radius, seg )
	local cir = {}

	table.insert( cir, { x = x, y = y, u = 0.5, v = 0.5 } )
	for i = 0, seg do
		local a = math.rad( ( i / seg ) * -360 )
		table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )
	end

	local a = math.rad( 0 ) -- This is need for non absolute segment counts
	table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )

	surface.DrawPoly( cir )
end

local blood_overlay = Material("hud/damageoverlay.png", "unlitgeneric smooth")
local bloodpulse = true
local pulse = 0

hook.Add( "HUDPaint", "hud_main", function()

	if GetGlobalBool( "RoundFinished" ) == true or GetConVarNumber( "hud_disable" ) != 0 or LocalPlayer().disablehud == true then
		return
	end
	
	local teamscheme

	teamscheme = Color( 0, 0, 0, 200)
	if LocalPlayer():Team() == 0 then
		teamscheme = Color( 255, 255, 255, 200)
		if LocalPlayer():GetObserverTarget() then
			n = LP():GetObserverTarget():Name()
			nhp = LP():GetObserverTarget():Health()
		else
			n = "Nobody"
			nhp = 100
		end
		if LocalPlayer():GetObserverMode() == OBS_MODE_ROAMING then
			draw.SimpleText( "Press [R] to change to First-Person", "DermaDefault", ScrW() / 2 + 1, ScrH() - 50 + 1, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM )
			draw.SimpleText( "Press [R] to change to First-Person", "DermaDefault", ScrW() / 2, ScrH() - 50, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM )
		elseif LocalPlayer():GetObserverMode() == OBS_MODE_CHASE then
			draw.SimpleText( "Press [R] to change to Free Roam", "DermaDefault", ScrW() / 2 + 1, ScrH() - 50 + 1, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM )
			draw.SimpleText( "Press [R] to change to Free Roam", "DermaDefault", ScrW() / 2, ScrH() - 50, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM )
			draw.SimpleText( "Spectating: " .. n .. " (" .. nhp .. "%)", "DermaDefault", ScrW() / 2 + 1, ScrH() - 32 + 1, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM )
			draw.SimpleText( "Spectating: " .. n .. " (" .. nhp .. "%)", "DermaDefault", ScrW() / 2, ScrH() - 32, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM )
		elseif LocalPlayer():GetObserverMode() == OBS_MODE_IN_EYE then
			draw.SimpleText( "Press [R] to change to Third-Person", "DermaDefault", ScrW() / 2 + 1, ScrH() - 50 + 1, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM )
			draw.SimpleText( "Press [R] to change to Third-Person", "DermaDefault", ScrW() / 2, ScrH() - 50, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM )
			draw.SimpleText( "Spectating: " .. n .. " (" .. nhp .. "%)", "DermaDefault", ScrW() / 2 + 1, ScrH() - 32 + 1, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM )
			draw.SimpleText( "Spectating: " .. n .. " (" .. nhp .. "%)", "DermaDefault", ScrW() / 2, ScrH() - 32, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM )
		end
			
	elseif LocalPlayer():Team() == 1 then
		teamscheme = Color( 175, 0, 0, 150)
	elseif LocalPlayer():Team() == 2 then
		teamscheme = Color( 0, 0, 255, 150)
	end
	
		if LP():Alive() then
			for k, v in next, hitpos do
				surface.SetMaterial( damage )
				surface.SetDrawColor( 0, 0, 0, 255 * v[ 2 ] )
				surface.DrawTexturedRectRotated( ScrW() / 2, ScrH() / 2, 288, 288, v[ 1 ] - 180 )
				v[ 2 ] = v[ 2 ] - 0.1
				if v[ 2 ] <= 0 then
					table.remove( hitpos, k )
				end
			end
			
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
		end
	
	--Draws the center-top polygons and writes the time and red/blue team's tickets, stolen from spectator mode
	draw.NoTexture()
		surface.SetDrawColor( 0, 0, 0, 200 )
		surface.DrawPoly( drawtime )
		surface.DrawPoly( drawtime_fix )
		surface.SetDrawColor( 0, 0, 0, 200 )
		surface.DrawPoly( drawscore )
		local num = GetGlobalInt( "RoundTime" )
		local col
		--Sets time red with 1 minute remaining
		if num <= 60 then
			col = Color( 255, 0, 0, 255 )
		elseif num > 60 then
			col = Color( 255, 255, 255, 200 )
		end
		local t = string.FormattedTime( tostring( num ) )
		t.m = tostring( t.m )
		t.s = tostring( t.s )
		if #t.m == 1 then
			t.m = "0" .. t.m
		end
		if #t.s == 1 then
			t.s = "0" .. t.s
		end
		draw.SimpleText( t.m .. ":" .. t.s, "spectime", ScrW() / 2, 11, col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		
		if GetGlobalBool( "ticketmode" ) == true then
			redtix = GetGlobalInt( "RedTickets" )
			draw.SimpleText( redtix, "time", ScrW() / 2 - 70, 9, Color( 255, 0, 0, 177 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
			
			bluetix = GetGlobalInt( "BlueTickets" )
			draw.SimpleText( bluetix, "time", ScrW() / 2 + 70, 9, Color( 0, 0, 255, 177 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
		else
			draw.SimpleText( "TDM", "time", ScrW() / 2 - 70, 9, Color( 255, 0, 0, 177 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
			draw.SimpleText( "TDM", "time", ScrW() / 2 + 70, 9, Color( 0, 0, 255, 177 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
		end

	surface.SetFont( "Info" )
	local info = "[F1] Choose Team | [F2] Choose Loadout"
	local infowidth, infoheight = surface.GetTextSize( info )

	--Round timer
	local _time = GetGlobalInt( "RoundTime" )
	local col = Color( 255, 255, 255, 255 )
	if _time <= 60 then
		col = Color( math.abs( math.sin( RealTime() * ( 13 - ( _time / 5 ) ) ) * 205 ) + 50, 0, 0, 255 )
	end
	local time = string.FormattedTime( tostring( _time ) )
	time.m = tostring( time.m )
	time.s = tostring( time.s )
	if #time.m == 1 then
		time.m = "0" .. time.m
	end
	if #time.s == 1 then
		time.s = "0" .. time.s
	end
	
	--Creates the boxes in the top left hand corner for F1 and F2 commands
	surface.SetDrawColor( teamscheme ) 
	surface.SetTexture( gradient )
	surface.DrawRect( 32, 32, infowidth + 9, infoheight + 5 ) --Align it with gamemode name/version text set below
	surface.SetDrawColor( Color( 0, 0, 0, 50) )
	surface.DrawRect( 32, 32, infowidth + 11, infoheight + 7 )

	--Writes the text in string "info" set above
	surface.SetFont( "Info" )
	surface.SetTextColor( 255, 255, 255, 200 )
	surface.SetTextPos( 36, 33 )
	surface.DrawText( info )

	--Gamemode name & version number
	surface.SetTextColor( 255, 255, 255, 135 )
	surface.SetTextPos( 32, 64 ) --Align it with grey box in the top left hand corner rectangle set above
	surface.DrawText( "Conquest Team Deathmatch V. 052416" )

	
	if LP():Alive() and LocalPlayer():Team() ~= 0 then
		
		local hp = LocalPlayer():Health()
		local maxhp = LocalPlayer():GetMaxHealth()
		if hpdrain > hp then
			hpdrain = Lerp( FrameTime() * 2, hpdrain, hp )
		else
			hpdrain = hp
		end

		--Clamp: "Clamps a number between a minimum and maximum value"
		hp = math.Clamp( hp, 0, maxhp )
		hpdrain = math.Clamp( hpdrain, 0, maxhp )
		
		surface.SetTextColor( 255, 255, 255, 255 )
		if LocalPlayer():Team() == 1 then
			--Draw Icon
			surface.SetMaterial( redicon2 )
			surface.SetDrawColor( 0, 0, 0, 200 )
			surface.DrawTexturedRect( ScrW() - 231, ScrH() - 246, (ScrW() / 9.6), (ScrH() / 5.4) )
			surface.SetDrawColor( 255, 50, 50, 255 )
			surface.DrawTexturedRect( ScrW() - 235, ScrH() - 250, (ScrW() / 9.6), (ScrH() / 5.4) )
			--draw.NoTexture()
			--Draw Icon Background
			--surface.DrawRect( ScrW() - 250, ScrH() - 265, 250, 300 )
		elseif LocalPlayer():Team() == 2 then
			draw.NoTexture()
			surface.SetDrawColor( 200, 200, 255, 255 )
			surface.SetMaterial( blueicon2 )
			surface.DrawTexturedRect( ScrW() - 235, ScrH() - 255, (ScrW() / 9.6), (ScrH() / 5.4) )
			draw.NoTexture()
		end
		
		--Old Health bar code, keeping just in case its ever needed
		--[[Health bar background
		surface.SetDrawColor( Color( 0, 0, 0, 200 ) )
		surface.DrawRect( ScrW() - 225, ScrH() - 50, 180, 10 )
		
		--Red health bar on damage taken
		surface.SetDrawColor( Color( 255, 0, 0, 200 ) )
		surface.DrawRect( ScrW() - 303 + ( 231 - ( 231 * ( hpdrain / 100 ) ) ) + hl.x, ScrH() - 106 + hl.y, 232 - ( 231 - ( 231 * ( hpdrain / 100 ) ) ), 10 )
			
	if (hp <= 25) then
		--Turns health bar red when below 25
		surface.SetDrawColor( Color( 240, 0, 0, 255 ) )
		surface.DrawRect( ScrW() - 303 + ( 231 - ( 231 * ( hp / 100 ) ) ) + hl.x, ScrH() - 106 + hl.y, 232 - ( 231 - ( 231 * ( hp / 100 ) ) ), 10 )
			draw.SimpleText( "HEALTH LOW", "Killfeed", ScrW() - 290 + hl.x, ScrH() - 105 + hl.y, Color( 255, 0, 0, 200 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM )
	        draw.SimpleText( "HEALTH LOW", "LevelBG", ScrW() - 290 + hl.x, ScrH() - 105 + hl.y, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM )
	else
		--Standard health bar
		surface.SetDrawColor( Color( 255, 255, 255, 255 ) )
		surface.DrawRect( ScrW() - 303 + ( 231 - ( 231 * ( hp / 100 ) ) ) + hl.x, ScrH() - 106 + hl.y, 232 - ( 231 - ( 231 * ( hp / 100 ) ) ), 10 )
		
	end
		--White accent line beneath health bar
		surface.SetDrawColor( Color( 255, 255, 255, 255 ) )
		surface.DrawRect( ScrW() - 303 + hl.x, ScrH() - 96 + hl.y, 232, 2 )]]

		--Health #
		draw.SimpleText( hp, "HealthBG", ScrW() - 110, ScrH() - 255, teamscheme, TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM )
		draw.SimpleText( "/ " .. maxhp .. " HP", "Health", ScrW() - 44, ScrH() - 265, Color( 0, 0, 0, 200), TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM )
		draw.SimpleText( "/ " .. maxhp .. " HP", "Health", ScrW() - 45, ScrH() - 266, Color( 255, 255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM )

		-- left side
		local teamcolor = team.GetColor( LP():Team() )
		local n = 11
		teamcolor = Color( math.Clamp( teamcolor.r, 255 / n * ( n - 1 ), 255 ), math.Clamp( teamcolor.g, 255 / n * ( n - 1 ), 255 ), math.Clamp( teamcolor.b, 255 / n * ( n - 1 ), 255 ) )

		local exp = currentexp
		local nextexp = nextlvlexp
		local lvl = currentlvl
		
		local percent = exp / nextexp
		local loading

		if currentlvl == -1 and currentexp == -1 and nextlvlexp == -1 then
			if CurTime() % 2 >= 0 and CurTime() % 2 <= 2 / 3 then
				loading = "."
			elseif CurTime() % 2 >= 2 / 3 and CurTime() % 2 <= 2 / 3 * 2 then
				loading = ".."
			elseif CurTime() % 2 >= 2 / 3 * 2 and CurTime() % 2 <= 2 then
				loading = "..."
			end
		else
			levelpercent = Lerp( FrameTime() * 8, levelpercent, percent )
		end

		--Experience Bar & Level shite
		surface.SetDrawColor( Color( 0, 0, 0, 200 ) )
		surface.DrawRect( 44, ScrH() - 106, 231, 10 )
		
		surface.SetDrawColor( teamscheme )
		surface.DrawRect( 44, ScrH() - 106, 1 + ( 231 * levelpercent ), 10 )
		surface.SetDrawColor( teamcolor )
		surface.DrawRect( 44, ScrH() - 96, 231, 2 )

		for i = 0, 4 do 
			draw.SimpleText( LP():GetName(), "NameBG", 48, ScrH() - 135, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM )
			if currentlvl == -1 and currentexp == -1 and nextlvlexp == -1 then
				draw.SimpleText( "Receiving game data" .. loading, "LevelBG", 50, ScrH() - 110, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM )
			else
				if GetConVarNumber( "hud_showexp" ) == 0 then
					draw.SimpleText( "[ " .. math.Round( percent * 100, 1 ) .. "% ] Level " .. lvl, "LevelBG", 50, ScrH() - 110, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM )
				else
					draw.SimpleText( "[ " .. exp .. " / " .. nextexp .. " ] Level " .. lvl, "LevelBG", 50, ScrH() - 110, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM )
				end
			end
		end
		draw.SimpleText( LP():GetName(), "Name", 48, ScrH() - 135, teamcolor, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM )
		if currentlvl == -1 and currentexp == -1 and nextlvlexp == -1 then
			draw.SimpleText( "Receiving game data" .. loading, "Level", 50, ScrH() - 110, teamcolor, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM )
		else
			if GetConVarNumber( "hud_showexp" ) == 0 then
				draw.SimpleText( "[ " .. math.Round( percent * 100, 1 ) .. "% ] Level " .. lvl, "Level", 50, ScrH() - 110, teamcolor, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM )
			else
				draw.SimpleText( "[ " .. exp .. " / " .. nextexp .. " ] Level " .. lvl, "Level", 50, ScrH() - 110, teamcolor, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM )
			end
		end

		curmoney = Lerp( FrameTime() * 12, curmoney, math.Clamp( curAmt, 0, curAmt ) )

		for i = 0, 4 do
			draw.SimpleText( "$" .. comma_value( math.Round( curmoney ) ), "LevelBG", 48, ScrH() - 76, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM )
		end
		draw.SimpleText( "$" .. comma_value( math.Round( curmoney ) ), "Level", 48, ScrH() - 76, teamcolor, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM )

		local wep = LP():GetActiveWeapon()
		
		if wep and wep ~= NULL then 

			wep = wep:GetClass()
			
			local num
			for k, v in next, CurrentLifeWeps do
				if v[ 1 ] == wep then
					num = tostring( v[ 2 ] )
				end
			end
			if not num then 
				num = "0"
			end
			
			local cnum = 0
			local curnum = 0
			for k, v in next, weps do
				if wep == k then
					curnum = table.Count( weps[ k ] )
					for k, v in next, weps[ k ] do
						if tonumber( num ) >= v[ 2 ] then
							cnum = cnum + 1
						end
					end
				end
			end

			if cnum >= curnum then
				cnum = 0
				curnum = 0 
			end

			if cnum != 0 or curnum != 0 then
				for i = 0, 4 do
					draw.SimpleText( num .. " / " .. tostring( weps[ wep ][ cnum + 1 ][ 2 ] ) .. " KILLS", "LevelBG", 48, ScrH() - 58, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM )
				end
				draw.SimpleText( num .. " / " .. tostring( weps[ wep ][ cnum + 1 ][ 2 ] ) .. " KILLS", "Level", 48, ScrH() - 58, teamcolor, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM )
			else
				for i = 0, 4 do
					draw.SimpleText( num .. " KILLS", "LevelBG", 48, ScrH() - 58, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM )
				end
				draw.SimpleText( num .. " KILLS", "Level", 48, ScrH() - 58, teamcolor, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM )
			end
			
		end


	end
	
	if LP():Alive() and LP() ~= NULL and LP():GetActiveWeapon() ~= NULL then
		local activewep = LP():GetActiveWeapon()
		local primaryammo = activewep:GetPrimaryAmmoType()
		local ammocount = LP():GetAmmoCount( primaryammo )
		local c1 = activewep:Clip1()
		local _c1, _ammocount

		if( activewep ~= NULL and primaryammo ~= NULL and ammocount > -1 ) then
			if( c1 < 0 ) then
				c1 = "---"
			end
			if( ammocount <= 0 ) then
				ammocount = "---"
			end
			
			if string.len( tostring( c1 ) ) == 2 then
				_c1 = "0" .. c1
			elseif string.len( tostring( c1 ) ) == 1 then
				_c1 = "00" .. c1
			else
				_c1 = ""
			end
			--[[Ammo count on right side of screen, keeping just in case we ever need it
			draw.SimpleText( _c1, "PrimaryAmmo", ScrW() - 290, ScrH() - 110, Color( 0, 0, 0, 120 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM )
			draw.SimpleText( c1, "PrimaryAmmo", ScrW() - 290, ScrH() - 110, Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM )

			draw.SimpleText( ammocount, "SecondaryAmmoBG", ScrW() - 80, ScrH() - 130, Color( 0, 0, 0, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM )
			if string.len( tostring( ammocount ) ) == 2 then
				_ammocount = "0" .. ammocount
			elseif string.len( tostring( ammocount ) ) == 1 then
				_ammocount = "00" .. ammocount
			else
				_ammocount = ""
			end
			draw.SimpleText( _ammocount, "SecondaryAmmo", ScrW() - 220, ScrH() - 100, Color( 0, 0, 0, 120 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM )
			draw.SimpleText( ammocount, "SecondaryAmmo", ScrW() - 220, ScrH() - 100, Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM )

			surface.SetFont( "ammo2" )
			surface.SetTextColor( Color( 255, 255, 255, 200 ) )
			surface.SetTextPos( ScrW() - 285, ScrH() - 155 )
			surface.DrawText( "/" )]]
			
		end
	end
	
	if GetGlobalBool( "ticketmode" ) == true then

		-- holy fuck im lazy
		local offsetx = 30
		local offsety = -31

		--Moving flag notice code (the stuff that floats around your HUD)
		for k, v in next, flags do
			local col
			if status[ v[ 1 ] ] == 1 then
				col = Color( 255, 0, 0 )
			elseif status[ v[ 1 ] ] == -1 then
				col = Color( 0, 0, 255 )
			elseif status[ v[ 1 ] ] == 0 then
				col = Color( 255, 255, 255 )
			end
			local pos = ( v[ 2 ] + Vector( 0, 0, 150 ) ):ToScreen()
			local xx = v[ 2 ]
			local dist = xx:Distance( LP():GetPos() ) / 39
			if pos.x > ScrW() then	
				pos.x = ScrW() - 40
			end
			if pos.x <= 0 then
				pos.x = 20
			end
			if pos.y > ScrH() then
				pos.y = ScrH() - 20
			end
			if pos.y < 0 then
				pos.y = 20
			end
			
			surface.SetFont( "flags" )
			surface.SetTextPos( pos.x, pos.y )
			surface.SetTextColor( col )
			if capture[ v[ 1 ] ] and capture[ v[ 1 ] ].capturing and capture[ v[ 1 ] ].capturing == true then
				surface.DrawFadingText( col, v[ 1 ] )
			else
				surface.DrawText( v[ 1 ] )
			end		
			surface.SetFont( "DermaDefault" )
			surface.DrawText( " " .. tostring( math.Round( dist ) ) .. "m" )
		end

		if LP():Alive() then -- tickets stuff

			--Grey box used to surreound the flags, keeping just in case its ever needed
			--[[surface.SetDrawColor( Color( 0, 0, 0, 166 ) )
			draw.RoundedBoxEx( 8, 74 + hl.x - offsetx, ScrH() - 142 - 36 + hl.y - offsety, 227, 35, Color( 0, 0, 0, 166 ), true, true )
			surface.DrawRect( 74 + hl.x - offsetx, ScrH() - 142 - 36 + hl.y - offsety, 227, 35 )]]
			
			local red = GetGlobalInt( "RedTickets" )
			local blue = GetGlobalInt( "BlueTickets" )

			if red ~= globalred then
				globalred = red
				redalpha = 1
			end

			if blue ~= globalblue then
				globalblue = blue
				bluealpha = 1
			end

			redalpha = Lerp( FrameTime() * 6.4, redalpha, 0 )
			bluealpha = Lerp( FrameTime() * 6.4, bluealpha, 0 )

			local flagnum = 0
			local position = 5--228 / 2 + 78 --192?
			position = position - 22 * ( #flags / 2 )
			for k, v in next, flags do
				surface.SetFont( "flags" )
				local col
				if status[ v[ 1 ] ] == 1 then
					surface.SetTextColor( 255, 0, 0 )
					col = Color( 255, 0, 0 )
				elseif status[ v[ 1 ] ] == -1 then
					surface.SetTextColor( 0, 0, 255 )
					col = Color( 0, 0, 255 )
				elseif status[ v[ 1 ] ] == 0 then
					surface.SetTextColor( 255, 255, 255 )
					col = Color( 255, 255, 255 )
				end
				surface.SetTextPos( --[[position + ( 22 * flagnum ) + 774 ScrW() / 2 position +]] ( ScrW() / 2 ) + ( 22 * flagnum ) + position, 33 )
				--surface.SetTextPos( position + ( 22 * flagnum ) + hl.x - offsetx, ScrH() - 175 + hl.y - offsety )
				if capture[ v[ 1 ] ] and capture[ v[ 1 ] ].capturing and capture[ v[ 1 ] ].capturing == true then
					surface.DrawFadingText( col, tostring( v[ 1 ] ) )
				else
					surface.DrawText( tostring( v[ 1 ] ) )
				end				
				flagnum = flagnum + 1
			end
		end
	end

end )

local function GetPrintName( wep )
    if wep == nil || wep == NULL then return end
    if weapons.Get(wep) == nil then return "" end 
	if weapons.Get( wep ).PrintName ~= nil then
		return weapons.Get( wep ).PrintName
	elseif weapons.Get( wep ).ClassName ~= nil then
		return weapons.Get( wep ):GetClass()
	else
		return tostring( wep )
	end
end

local killtables = {}
net.Receive( "tdm_deathnotice", function()
	local victim = net.ReadEntity()
	local inf = net.ReadString()
	local attacker = net.ReadEntity()
	local hs = tobool( net.ReadString() )
	
	if attacker and victim and IsValid( attacker ) and IsValid( victim ) and attacker ~= NULL and victim ~= NULL then
		local aname = attacker:Nick()
		local ateam = attacker:Team()
		local vname = victim:Nick()
		local vteam = victim:Team()
		--local wepname = weapons.Get( attacker:GetActiveWeapon():GetClass() ).PrintName
		local wepname = GetPrintName( inf )

		if not table.HasValue( killtables, wepname ) then
			killicon.AddFont( wepname, "Killfeed", "[ " .. wepname .." ]", Color( 255, 255, 255, 255 ) )
			killicon.AddFont( wepname .. "-hs", "Killfeed", "[ " .. wepname .." - HEAD ]", Color( 255, 255, 255, 255 ) )
		end
		if hs then
			if aname == LocalPlayer():Nick() then
				GAMEMODE:AddDeathNotice( aname, 3, wepname .. "-hs", vname, vteam )
			else
				GAMEMODE:AddDeathNotice( aname, ateam, wepname .. "-hs", vname, vteam )
			end
		else
			if aname == LocalPlayer():Nick() then
				GAMEMODE:AddDeathNotice( aname, 3, wepname, vname, vteam )
			else
				GAMEMODE:AddDeathNotice( aname, ateam, wepname, vname, vteam )
			end
		end
	end
end )



net.Receive( "tdm_killcountnotice", function()
	local attacker = net.ReadEntity()
	local killcount = tonumber( net.ReadString() )
	
	if attacker and IsValid( attacker ) and attacker ~= NULL then
		local aname = attacker:Nick()
		local ateam = attacker:Team()
		
		local kcname = "\"something\" KILL"
		if killcount == 2 then
			kcname = "DOUBLE KILL"
		elseif killcount == 3 then
			kcname = "MULTI KILL"
		elseif killcount == 4 then
			kcname = "MEGA KILL"
		elseif killcount == 5 then
			kcname = "ULTRA KILL"
		elseif killcount >= 6 then
			kcname = "UNREAL"
		end
		
		if not table.HasValue( killtables, kcname ) then
			killicon.AddFont( kcname, "perky", "[ " .. kcname .. " ]", Color( 255, 64, 64, 255 ) )
			draw.DrawText( kcname, "default", ScrW() * 0.5, ScrH() * 0.25, Color( 255, 0, 0, 255), TEXT_ALIGN_CENTER)
			--print( kcname, "SHOULD BE DRAWING TEXT")
		end
		
		if aname == LocalPlayer():Nick() then
			GAMEMODE:AddDeathNotice( aname, 3, kcname, "", 0 )
		else
			GAMEMODE:AddDeathNotice( aname, ateam, kcname, "", 0 )
		end
	end
end )

usermessage.Hook( "tdm_win", function()
	surface.PlaySound( "ui/MP_Music_Winning_End_01_Wave3.mp3" )
	EndScreen()
end )

usermessage.Hook( "tdm_lose", function()
	surface.PlaySound( "ui/MP_Music_Losing_End_01_Wave.mp3" )
	EndScreen()
end )

usermessage.Hook( "tdm_tie", function()
	surface.PlaySound( "ui/MP_Music_Winning_End_01_Wave3.mp3" )
	EndScreen()
end )

--nade indicator
surface.CreateFont( "nade", { font = "Arial", size = 30, weight = 4000 } )
local function nade()
	if not LP() then LP = LocalPlayer end
	local dist = 800
	if LP():Team() ~= 0 then
		for k, v in pairs( ents.GetAll() ) do
			if( IsValid( v ) and ( not v:IsPlayer() ) ) then
				if( v:GetClass() == "fas2_thrown_m67" or v:GetClass() == "fas2_40mm_frag" or v:GetClass() == "cw_grenade_thrown" ) then
					if( v:GetPos():Distance( LP():GetPos() ) < dist ) then
						local Pos = v:GetPos():ToScreen()
						surface.DrawCircle( Pos.x, Pos.y, 16.5, Color( 220, 65, 15, 200 ) )
						
						if( v:GetPos():Distance( LP():GetPos() ) < ( dist / 2 ) ) then
							draw.SimpleText( "!", "nade", Pos.x, Pos.y - 15, Color( 220, 65, 15, 200 ), TEXT_ALIGN_CENTER )
						end
					end
				end
			end
		end
	end
end
hook.Add( "HUDPaint", "nade", nade )

net.Receive( "tdm_spawnoverlay", function( len, ply )

	alpha = 255
	
	local time = CurTime()		
	hook.Add( "HUDPaint", "spawno", function()
		surface.SetDrawColor( Color( 0, 0, 0, alpha ) )
		surface.DrawRect( 0, 0, ScrW(), ScrH() )
		
		surface.SetFont( "test" )
		surface.SetTextColor( 255, 255, 255, alpha > 100 and alpha or 100 )
		surface.SetTextPos( ( ScrW() / 2 ) - 150, ScrH() - ( ScrH() / 1.1 ) )
		surface.DrawText( "[Spawn Protection Enabled]" )
		if CurTime() - time >= 0.0162 then
			if alpha - 1 >= 0 then
				alpha = alpha - 1
			end
			time = CurTime()
		end		
	end )

	timer.Simple( 5, function()
		hook.Remove( "HUDPaint", "spawno" )
		timer.Destroy( "spawning" )
	end )
end )

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

hook.Add( "PreDrawHalos", "AddHalos", function()
	if GetConVarNumber( "tdm_ffa" ) == 1 then
		return
	end
	if GetConVarNumber( "hud_halo" ) == 0 then
		return
	end
	local halo_ply = {}
	local halo_ply_team1 = {}
	local halo_ply_team2 = {}
	for k, v in pairs( player.GetAll() ) do
		if LP():Team() ~= 0 then
			if ( v:IsPlayer() and v:IsValid() and v:Alive() and v ~= LP() and v:Team() == LP():Team() ) then
				table.insert( halo_ply, v )
			end
		else
			if ( v:IsPlayer() and v:IsValid() and v:Alive() and v ~= LP() and v:Team() == 1 ) then
				table.insert( halo_ply_team1, v )
			elseif ( v:IsPlayer() and v:IsValid() and v:Alive() and v ~= LP() and v:Team() == 2 ) then
				table.insert( halo_ply_team2, v )
			end
		end
	end
	if LP():Team() ~= 0 then
		halo.Add( halo_ply, team.GetColor( LP():Team() ), 1, 1, 1 )
	else
		halo.Add( halo_ply_team1, team.GetColor( 1 ), 1, 1, 1, true, true )
		halo.Add( halo_ply_team2, team.GetColor( 2 ), 1, 1, 1, true, true )
	end
end )

usermessage.Hook( "enemyflagcaptured", function( um )
	local flag = um:ReadString()
	local alpha = 1
	local off = false
	hook.Add( "HUDPaint", "efc", function()
		surface.SetFont( "test" )
		surface.SetTextColor( 0, 0, 0, alpha )
		local str = "FLAG " .. flag .. " LOST"
		local strsize = surface.GetTextSize( str )
		surface.SetTextPos( ScrW() / 2 - ( strsize / 2 ) + 2, 250 + 2 )
		surface.DrawText( str )
		surface.SetTextColor( 255, 255, 255, alpha )
		local str = "FLAG " .. flag .. " LOST"
		local strsize = surface.GetTextSize( str )
		surface.SetTextPos( ScrW() / 2 - ( strsize / 2 ), 250 )	
		surface.DrawText( str )
		if off == false then
			alpha = alpha + 1.5
			if alpha > 255 then 
				alpha = 255
			end
		else
			alpha = alpha - 1.5
		end
		if alpha <= 0 then
			hook.Remove( "HUDPaint", "efc" )
			alpha = 1
		end
	end )
	timer.Simple( 3, function()
		off = true
	end )
end )

usermessage.Hook( "friendlyflagcaptured", function( um )
	local flag = um:ReadString()
	local alpha = 1
	local off = false
	hook.Add( "HUDPaint", "efc", function()
		surface.SetFont( "test" )
		surface.SetTextColor( 0, 0, 0, alpha )
		local str = "FLAG " .. flag .. " CAPTURED"
		local strsize = surface.GetTextSize( str )
		surface.SetTextPos( ScrW() / 2 - ( strsize / 2 ) + 2, 250 + 2 )
		surface.DrawText( str )
		surface.SetTextColor( 255, 255, 255, alpha )
		local str = "FLAG " .. flag .. " CAPTURED"
		local strsize = surface.GetTextSize( str )
		surface.SetTextPos( ScrW() / 2 - ( strsize / 2 ), 250 )	
		surface.DrawText( str )
		if off == false then
			alpha = alpha + 1.5
			if alpha > 255 then 
				alpha = 255
			end
		else
			alpha = alpha - 1.5
		end
		if alpha <= 0 then
			hook.Remove( "HUDPaint", "efc" )
			alpha = 1
		end
	end )
	timer.Simple( 3, function()
		off = true
	end )
end )

function PostProcess()
	if GetConVarNumber( "hud_fade" ) == 0 then
		return
	end
	if not LP() then LP = LocalPlayer end
	local num = 1

	if LP():Alive() and LP():Team() ~= 0 then
		if LP():Health() <= 50 then
			local x = LP():Health()
			num = 0.02 * x - .03
		else
			num = 1
		end
	elseif not LP():Alive() and LP():Team() ~= 0 then
		num = 0.02 * 1 - 0.03
	end

    local tab = {}
	tab[ "$pp_colour_addr" ] = 0
	tab[ "$pp_colour_addg" ] = 0
	tab[ "$pp_colour_addb" ] = 0
	tab[ "$pp_colour_brightness" ] = 0
	tab[ "$pp_colour_contrast" ] = 1
	tab[ "$pp_colour_colour" ] = num
	tab[ "$pp_colour_mulr" ] = 0
	tab[ "$pp_colour_mulg" ] = 0
    tab[ "$pp_colour_mulb" ] = 0
	
    DrawColorModify( tab )
	if LP():Health() <= 20 or ( not LP():Alive() and LP():Team() ~= 0 ) then
		DrawMotionBlur( 0.4, 0.25, 0.01 )
	end
	
end
hook.Add( "RenderScreenspaceEffects", "PostProcessing", PostProcess )

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

local data
hook.Add( "PostDrawOpaqueRenderables", "DrawWeaponHints", function()
	local ent = LocalPlayer():GetEyeTrace().Entity
	if ent then
		if IsValid( ent ) and ent:IsWeapon() and ent:GetPos():Distance( LocalPlayer():GetPos() ) <= 400 then
			local data = data or weapons.Get( ent:GetClass() )
			
			function GetInfo( check, check2 )
				if check then
					return check
				elseif check2 then
					return check2
				else
					return 0
				end
			end
			
			local info = {
				[ 1 ] = GetInfo( data.PrintName, data.ClassName ),
				[ 2 ] = GetInfo( data.Damage, data.Primary.Damage ),
				[ 3 ] = GetInfo( data.HipCone, data.Primary.Spray ),
				[ 4 ] = GetInfo( data.AimCone, data.Primary.Cone ),
				[ 5 ] = GetInfo( data.ReloadTime ),
				[ 6 ] = GetInfo( data.Recoil, data.Primary.KickUp ),
				[ 7 ] = GetInfo( ent.Primary.ClipSize )
			}
			
			local ang = LocalPlayer():EyeAngles()
			local pos = ent:GetPos() + ang:Up()
		 
			ang:RotateAroundAxis( ang:Forward(), 90 )
			ang:RotateAroundAxis( ang:Right(), 90 )

			cam.Start3D2D( pos, Angle( 0, ang.y, 90 ), 0.1 )
				surface.SetDrawColor( Color( 0, 0, 0, 150 ) )
				surface.DrawRect( -250, -70, 500, -390 )
				local tc = {
					x = -250,
					y = -390 - 70
				}
				
				draw.DrawText( info[ 1 ], "wlarge", 0, tc.y - 10, color_white, TEXT_ALIGN_CENTER )
				surface.SetDrawColor( color_white )
				surface.DrawLine( tc.x + 50, tc.y + 97, tc.x + 450, tc.y + 100 )
				
				local col0
				local text0
				if info[ 2 ] >= 40 then
					col0 = Color( 0, 255, 0, 255 )
				elseif info[ 2 ] <= 25 then
					col0 = Color( 255, 0, 0, 255 )
				else
					col0 = Color( 255, 210, 0, 255 )
				end
				
				draw.DrawText( "Damage", "wsmall", tc.x + 20, tc.y + 102, col0, TEXT_ALIGN_LEFT )
				draw.DrawText( info[ 2 ], "wsmall", tc.x + 480, tc.y + 102, col0, TEXT_ALIGN_RIGHT )
				
				local col
				local text
				if info[ 4 ] >= 0.01 then
					col = Color( 255, 0, 0, 255 )
					text = "Poor"
				elseif info[ 4 ] <= 0.001 then
					col = Color( 0, 255, 0, 255 )
					text = "Good"
				else
					col = Color( 255, 210, 0, 255 )
					text = "Average"
				end
				draw.DrawText( "Accuracy", "wsmall", tc.x + 20, tc.y + 154, col, TEXT_ALIGN_LEFT )
				draw.DrawText( text, "wsmall", tc.x + 480, tc.y + 154, col, TEXT_ALIGN_RIGHT )
				
				local col2
				if info[ 5 ] then
					text2 = info[ 5 ] .. "s"
					if info[ 5 ] >= 3 then
						col2 = Color( 255, 0, 0, 255 )
					elseif info[ 5 ] < 2 then
						col2 = Color( 0, 255, 0, 255 )
					else
						col2 = Color( 255, 210, 0, 255 )
					end
				elseif info[ 5 ] == nil then
					col2 = color_white
					text2 = "N/A"
				end
				
				draw.DrawText( "Reload", "wsmall", tc.x + 20, tc.y + 206, col2, TEXT_ALIGN_LEFT )
				draw.DrawText( text2, "wsmall", tc.x + 480, tc.y + 206, col2, TEXT_ALIGN_RIGHT )
				
				local col3
				local text3
				if info[ 6 ] >= 1.5 then
					col3 = Color( 255, 0, 0, 255 )
					text3 = "High"
				elseif info[ 6 ] <= 0.7 then
					col3 = Color( 0, 255, 0, 255 )
					text3 = "Low"
				else
					col3 = Color( 255, 210, 0, 255 )
					text3 = "Average"
				end
				draw.DrawText( "Recoil", "wsmall", tc.x + 20, tc.y + 258, col3, TEXT_ALIGN_LEFT )
				draw.DrawText( text3, "wsmall", tc.x + 480, tc.y + 258, col3, TEXT_ALIGN_RIGHT )
				
				local col4
				if info[ 7 ] > 30 then
					col4 = Color( 0, 255, 0, 255 )
				elseif info[ 7 ] <= 20 then
					col4 = Color( 255, 0, 0, 255 )
				else
					col4 = Color( 255, 210, 0, 255 )
				end
				
				draw.DrawText( "Clip Size", "wsmall", tc.x + 20, tc.y + 310, col4, TEXT_ALIGN_LEFT )
				draw.DrawText( info[ 7 ], "wsmall", tc.x + 480, tc.y + 310, col4, TEXT_ALIGN_RIGHT )
				
			cam.End3D2D()
			
		end
	end
end )

--[[First person death
 hook.Add( "CalcView", "CalcView:GmodDeathView", function( player, origin, angles, fov )
    if( IsValid(player:GetRagdollEntity()) ) then 
		local CameraPos = player:GetRagdollEntity():GetAttachment( player:GetRagdollEntity():LookupAttachment( "eyes" ) )  
		return { origin = CameraPos.Pos, angles = CameraPos.Ang, fov = 90 }
	end
end)]]