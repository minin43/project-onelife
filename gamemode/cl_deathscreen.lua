local time
local main
local grow
local showtext
usermessage.Hook( "DeathScreen", function( um )
	grow = ( ScrH() / 3 )
	showtext = 0
	surface.PlaySound( "gunshot.ogg" )

	time = um:ReadShort()
	main = vgui.Create( "DPanel" )
	main:SetSize( ScrW(), ScrH() )
	main.Paint = function()
		surface.SetDrawColor( 0, 0, 0, 255 )
		surface.DrawRect( 0, 0, main:GetWide(), grow )
	end
	
	usermessage.Hook( "CloseDeathScreen", function()
		main:Remove()
	end )
end )

usermessage.Hook( "UpdateDeathScreen", function( um )
	grow = grow * 2
	showtext = showtext + 1
	surface.PlaySound( "gunshot.ogg" )
end )