surface.CreateFont( "Exo 2", {
	font = "Exo 2",
	size = 24,
	weight = 400
} )

surface.CreateFont( "Exo 2 Subhead", {
	font = "Exo 2",
	size = 16,
	weight = 400
} )

surface.CreateFont( "Exo 2 Button", {
	font = "Exo 2",
	size = 14,
	weight = 700
} )

local teamIcon = Material( "tdm/ic_account_circle_white_24dp.png", "noclamp smooth" )
local gradient = surface.GetTextureID( "gui/gradient" )

function SpawnMenu()

	if main then
		return
	end

	local currentTeam = LocalPlayer():Team()
	local TeamColor, FontColor
	if currentTeam == 0 then --fucking scrubs
		TeamColor = Color( 76, 175, 80 )
		FontColor = Color( 255, 255, 255 )
	elseif currentTeam == 1 then --red
		TeamColor = Color( 244, 67, 54 )
		FontColor = Color( 255, 255, 255 )
	elseif currentTeam == 2 then --blue
		TeamColor = Color( 33, 150, 243 )
		FontColor = Color( 255, 255, 255 )
	end

	main = vgui.Create( "DFrame" )
	main:SetSize( 380, 320 )
	main:SetTitle( "" )
	main:SetVisible( true )
	main:SetDraggable( false )
	main:ShowCloseButton( true )
	main:MakePopup()
	main:Center()	
	main.btnMaxim:Hide()
	main.btnMinim:Hide() 
	main.btnClose:Hide()
	
	main.Paint = function()
		Derma_DrawBackgroundBlur( main, CurTime() )
		surface.SetDrawColor( 255, 255, 255, 255 )
		surface.DrawRect( 0, 0, main:GetWide(), main:GetTall() )
		surface.SetDrawColor( TeamColor )
		surface.DrawRect( 0, 0, main:GetWide(), 56 )
		surface.SetFont( "Exo 2" )
		surface.SetTextColor( FontColor )
		surface.SetTextPos( 72, 16 )
		surface.DrawText( "Choose Team" )
		surface.SetTexture( gradient )
		surface.SetDrawColor( 0, 0, 0, 164 )
		surface.DrawTexturedRectRotated( main:GetWide() / 2, 56 + 4, 8, main:GetWide(), 270 )
	end
	
	local spec = vgui.Create( "DButton", main )
	local specnum = 0
	spec.alpha = 0
	spec.CursorHover = false
	spec:SetPos( 0, 56 + 72 * 2 )
	spec:SetSize( main:GetWide(), 72 )
	spec.Think = function()
		specnum = #team.GetPlayers( 0 )
		if !spec.CursorHover then
			spec.alpha = Lerp( FrameTime() * 20, spec.alpha, 0 )
		else
			spec.alpha = Lerp( FrameTime() * 20, spec.alpha, 164 )
		end
	end
	
	spec.Paint = function()
		surface.SetDrawColor( 56, 142, 60, 255 )
		surface.SetMaterial( teamIcon )
		surface.DrawTexturedRect( 16, 16, 40, 40 )
		surface.SetFont( "Exo 2" )
		surface.SetTextColor( 0, 0, 0, 255 )
		surface.SetTextPos( 72, 16 )
		surface.DrawText( "Spectators" )
		surface.SetFont( "Exo 2 Subhead" )
		surface.SetTextColor( 128, 128, 128, 255 )
		surface.SetTextPos( 72, 40 )
		if specnum == 1 then
			surface.DrawText( "There is currently " .. specnum .. " player spectating." )
		else
			surface.DrawText( "There are currently " .. specnum .. " players spectating." )
		end
		return true
	end
	
	spec.DoClick = function()
		RunConsoleCommand( "tdm_setteam", "0" )
		LocalPlayer():EmitSound( "buttons/button22.wav" )
		main:Close()
	end
	spec.OnCursorEntered = function()
		spec.CursorHover = true
	end
	spec.OnCursorExited = function()
		spec.CursorHover = false
	end

	local red = vgui.Create( "DButton", main )
	local rednum = 0
	red.alpha = 0
	red.CursorHover = false
	red:SetPos( 0, 56 + 72 )
	red:SetSize( main:GetWide(), 72 )
	red.Think = function()
		rednum = #team.GetPlayers( 1 )
		if !red.CursorHover then
			red.alpha = Lerp( FrameTime() * 20, red.alpha, 0 )
		else
			red.alpha = Lerp( FrameTime() * 20, red.alpha, 164 )
		end
	end
	
	red.Paint = function()
		surface.SetDrawColor( 0, 0, 0, 64 )
		surface.DrawRect( 72, 71, red:GetWide(), 1 )
		surface.SetDrawColor( 213, 0, 0, 255 )
		surface.SetMaterial( teamIcon )
		surface.DrawTexturedRect( 16, 16, 40, 40 )
		surface.SetFont( "Exo 2" )
		surface.SetTextColor( 0, 0, 0, 255 )
		surface.SetTextPos( 72, 16 )
		surface.DrawText( "Red Team" )
		surface.SetFont( "Exo 2 Subhead" )
		surface.SetTextColor( 128, 128, 128, 255 )
		surface.SetTextPos( 72, 40 )
		if rednum == 1 then
			surface.DrawText( "There is currently " .. rednum .. " player in this team." )
		else
			surface.DrawText( "There are currently " .. rednum .. " players in this team." )
		end
		return true
	end
	
	red.DoClick = function()
		LocalPlayer():EmitSound( "buttons/button22.wav" )
		if LocalPlayer():Team() ~= 0 then
			LocalPlayer():ConCommand( "kill" )
		end
		LocalPlayer().blue = false
		LocalPlayer().red = true
		main:Close()
		LocalPlayer():ConCommand( "tdm_loadout" )
	end
	red.OnCursorEntered = function()
		red.CursorHover = true
	end
	red.OnCursorExited = function()
		red.CursorHover = false
	end

	local blue = vgui.Create( "DButton", main )
	local bluenum = 0
	blue.alpha = 0
	blue.CursorHover = false
	blue:SetPos( 0, 56 )
	blue:SetSize( main:GetWide(), 72 )
	blue.Think = function()
		bluenum = #team.GetPlayers( 2 )
		if !blue.CursorHover then
			blue.alpha = Lerp( FrameTime() * 20, blue.alpha, 0 )
		else
			blue.alpha = Lerp( FrameTime() * 20, blue.alpha, 164 )
		end
	end
	
	blue.Paint = function()
		surface.SetDrawColor( 0, 0, 0, 64 )
		surface.DrawRect( 72, 71, blue:GetWide(), 1 )
		surface.SetDrawColor( 41, 98, 255, 255 )
		surface.SetMaterial( teamIcon )
		surface.DrawTexturedRect( 16, 16, 40, 40 )
		surface.SetFont( "Exo 2" )
		surface.SetTextColor( 0, 0, 0, 255 )
		surface.SetTextPos( 72, 16 )
		surface.DrawText( "Blue Team" )
		surface.SetFont( "Exo 2 Subhead" )
		surface.SetTextColor( 128, 128, 128, 255 )
		surface.SetTextPos( 72, 40 )
		if bluenum == 1 then
			surface.DrawText( "There is currently " .. bluenum .. " player in this team." )
		else
			surface.DrawText( "There are currently " .. bluenum .. " players in this team." )
		end
		return true
	end
	
	blue.DoClick = function()
		LocalPlayer():EmitSound( "buttons/button22.wav" )
		if LocalPlayer():Team() ~= 0 then
			LocalPlayer():ConCommand( "kill" )
		end
		LocalPlayer().blue = true
		LocalPlayer().red = false
		main:Close()
		LocalPlayer():ConCommand( "tdm_loadout" )
	end
	blue.OnCursorEntered = function()
		blue.CursorHover = true
	end
	blue.OnCursorExited = function()
		blue.CursorHover = false
	end
	
	local hover = vgui.Create( "DShape", main )
	hover:SetType( "Rect" )
	hover:SetPos( 0, 56 + 72 * 2 - 8 )
	hover:SetSize( main:GetWide(), 16 )

	hover.Paint = function()
		surface.SetTexture( gradient )
		surface.SetDrawColor( 0, 0, 0, spec.alpha )
		surface.DrawTexturedRectRotated( hover:GetWide() / 2, 4, 8, hover:GetWide(), 90 )
		surface.SetDrawColor( 0, 0, 0, red.alpha )
		surface.DrawTexturedRectRotated( hover:GetWide() / 2, 3 + 8, 8, hover:GetWide(), 270 )
	end

	local hover2 = vgui.Create( "DShape", main )
	hover2:SetType( "Rect" )
	hover2:SetPos( 0, 56 + 72 * 3 )
	hover2:SetSize( main:GetWide(), 8 )

	hover2.Paint = function()
		surface.SetTexture( gradient )
		surface.SetDrawColor( 0, 0, 0, spec.alpha )
		surface.DrawTexturedRectRotated( hover2:GetWide() / 2, 3, 8, hover2:GetWide(), 270 )
	end

	local hover3 = vgui.Create( "DShape", main )
	hover3:SetType( "Rect" )
	hover3:SetPos( 0, 56 + 72 * 1 - 8 )
	hover3:SetSize( main:GetWide(), 16 )

	hover3.Paint = function()
		surface.SetTexture( gradient )
		surface.SetDrawColor( 0, 0, 0, red.alpha )
		surface.DrawTexturedRectRotated( hover:GetWide() / 2, 4, 8, hover:GetWide(), 90 )
		surface.SetDrawColor( 0, 0, 0, blue.alpha )
		surface.DrawTexturedRectRotated( hover3:GetWide() / 2, 3 + 8, 8, hover3:GetWide(), 270 )
	end

	local close = vgui.Create( "DButton", main )
	close.Hover = false
	close.Click = false
	close:SetSize( 64, 36 )
	close:SetPos( main:GetWide() - close:GetWide() - 16, main:GetTall() - close:GetTall() - 8 )
	
	function PaintClose()
		if not main then return end
		if close.Hover then
			draw.RoundedBox( 4, 0, 0, close:GetWide(), close:GetTall(), Color( 0, 0, 0, 255 * 0.2 ) )
		end
		if close.Click then
			draw.RoundedBox( 4, 0, 0, close:GetWide(), close:GetTall(), Color( 0, 0, 0, 255 * 0.2 ) )
		end
		draw.SimpleText( "CLOSE", "Exo 2 Button", close:GetWide() / 2, close:GetTall() / 2, TeamColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		return true
	end
	close.Paint = PaintClose

	close.OnCursorEntered = function()
		close.Hover = true
	end
	close.OnCursorExited = function()
		close.Hover = false
	end

	close.OnMousePressed = function()
		LocalPlayer():EmitSound( "buttons/button22.wav" )
		close.Click = true
	end
	close.OnMouseReleased = function()
		close.Click = false
		main:Close()
	end
	
	main.OnClose = function()
		main:Remove()
		if main then
			main = nil
		end
	end
	
end
concommand.Add( "tdm_spawnmenu", SpawnMenu )