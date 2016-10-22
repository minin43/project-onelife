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
end )

--Stolen from Zet0r
local blood_overlay = Material("hud/damageoverlay.png", "unlitgeneric smooth")
local bloodpulse = true
local pulse = 0

hook.Add( "HUDPaint", "hud_main", function()

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
	
	--
	
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

--I think this is the healthbar above teammate's head?
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
    if( IsValid(player:GetRagdollEntity()) and *insert code about spectating someone here* ) then 
		local CameraPos = player:GetRagdollEntity():GetAttachment( player:GetRagdollEntity():LookupAttachment( "eyes" ) )  
		return { origin = CameraPos.Pos, angles = CameraPos.Ang, fov = 90 }
	end
end)]]