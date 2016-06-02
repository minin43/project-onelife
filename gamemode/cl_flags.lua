flags = {}
status = {}
local ang1 = Angle( 0, 0, 0 )
local up = Vector( 0, 0, 30 )	
local offset = Vector( 0, 0, 85 )
local cs3d2d = cam.Start3D2D
local ce3d2d = cam.End3D2D
local sdc = surface.DrawCircle
local sdl = surface.DrawLine
local ssdc = surface.SetDrawColor
local sstc = surface.SetTextColor
local sstp = surface.SetTextPos
local sdt = surface.DrawText
local sdr = surface.DrawRect
local drb = draw.RoundedBox
local ssf = surface.SetFont
local next = next
local Color = Color
local Vector = Vector
local lp = LocalPlayer
local Angle = Angle
local ScrH = ScrH
local ScrW = ScrW
local tostring = tostring
local tonumber = tonumber

surface.CreateFont( "DrawFlagNames", {
	font = "Arial",
	size = 30
} )

hook.Add( "PostDrawOpaqueRenderables", "DrawFlags", function()
	for k, v in next, flags do
		local col = Color( 0, 255, 0 )
		if status[ v[ 1 ] ] == -1 or v[ 4 ] == -10 then
			col = Color( 0, 0, 255 )
		elseif status[ v[ 1 ] ] == 1 or v[ 4 ] == 10 then
			col = Color( 255, 0, 0 )
		elseif status[ v[ 1 ] ] == 0 or v[ 4 ] == 0 then
			col = Color( 255, 255, 255 )
		else
			col = Color( 255, 255, 255 )
		end

		local trace = v[ 2 ]
		--[[
		local up = Vector( 0, 0, 50 )
		
		cs3d2d( trace + up, ang1, 1 ) 
			sdc( v[ 3 ], 0, 5, col ) 
		ce3d2d()
		]]
		local ang = lp():EyeAngles()
		local pos = trace + offset + ang:Up()
		
		ang:RotateAroundAxis( ang:Forward(), 90 )
		ang:RotateAroundAxis( ang:Right(), 90 )
		ssdc( col )
		cs3d2d( pos, Angle( 0, ang.y, 90 ), 0.25 )
			sdl( 0, -100, 0, 375 )
			sdl( 0, -100, 70, 20 )
			sdl( 0, 20, 70, 20 )
		ce3d2d()
	end
	--ang1 = ang1 + Angle( 0, 0.02, 0 )
end )


net.Receive( "SendFlags", function()
	local f = net.ReadTable()
	local s = net.ReadTable()
	flags = f
	status = s
end )

local curFlagNumber = nil
local progress = vgui.Create( "DPanel" )
progress:SetSize( 600, 20 )
progress.Paint = function()
	if curFlagNumber then
		local x = 0
		local p = curFlagNumber
		x = 5 * p + 50
		ssdc( 0, 0, 255, 200 )
		sdr( x * 3, 0, 300 - x * 3, progress:GetTall() )

		ssdc( 255, 0, 0, 200 )
		sdr( 0, 0, x * 3, progress:GetTall() )
		return true
	end
end
progress:SetVisible( false )
progress:SetPos( ScrW() / 2 - 150, ScrH() - 40 )
hook.Add( "HUDPaint", "ProgressBar", function()
	--local flagnum = 0
	if curFlagNumber then
		progress:SetVisible( true )
	else
		progress:SetVisible( false )
	end
	--[[
	drb( 4, 30, ScrH() - 90, #flags * 40, 30, Color( 0, 0, 0, 220 ) )
	for k, v in next, flags do
		ssf( "DrawFlagNames" )
		if status[ v[ 1 ] ] == 1 then
			sstc( 255, 0, 0 )
		elseif status[ v[ 1 ] ] == -1 then
			sstc( 0, 0, 255 )
		elseif status[ v[ 1 ] ] == 0 then
			sstc( 255, 255, 255 )
		end
		sstp( 40 + ( 40 * flagnum ), ScrH() - 89 )
		sdt( tostring( v[ 1 ] ) )
		flagnum = flagnum + 1
	end
	flagnum = 0
	]]
end )
usermessage.Hook( "UpdateNumber", function( um )
	local num = tonumber( um:ReadString() )
	if num == 69 then
		curFlagNumber = nil
	else
		if progress:IsVisible() and curFlagNumber ~= 9 and curFlagNumber ~= -9 and curFlagNumber ~= 10 and curFlagNumber ~= -10 then
			surface.PlaySound( "ui/hud_capping_flag_01_wave.mp3" )
		end
		curFlagNumber = num			
	end
end )