local dlist
local dlist2

local TeamColor = {}
TeamColor.red = Color( 244, 67, 54 )
TeamColor.blue = Color( 33, 150, 243 )
TeamColor.spec = Color( 76, 175, 80 )

local white = Color( 255, 255, 255 )
local black = Color( 0, 0, 0 )

local gradient = surface.GetTextureID( "gui/gradient" )
local muteicon = Material( "icon16/sound.png" )
local cardicon = Material( "icon16/vcard.png" )
local deadicon = Material( "icon16/status_offline.png" )

local levelgroups = {
	{ 101, "101", "materials/ranks/101.png"},
	{ 102, "102", "materials/ranks/102.png"},
	{ 103, "103", "materials/ranks/103.png"},
	{ 104, "104", "materials/ranks/104.png"},
	{ 105, "105", "materials/ranks/105.png"},
	{ 106, "106", "materials/ranks/106.png"},
	{ 107, "107", "materials/ranks/107.png"},
	{ 108, "108", "materials/ranks/108.png"},
	{ 109, "109", "materials/ranks/109.png"},
	{ 110, "110", "materials/ranks/110.png"},
	{ 111, "111", "materials/ranks/111.png"},
	{ 112, "112", "materials/ranks/112.png"},
	{ 113, "113", "materials/ranks/113.png"},
	{ 114, "114", "materials/ranks/114.png"},
	{ 115, "115", "materials/ranks/115.png"},
	{ 116, "116", "materials/ranks/116.png"},
	{ 117, "117", "materials/ranks/117.png"},
	{ 118, "118", "materials/ranks/118.png"},
	{ 119, "119", "materials/ranks/119.png"},
	{ 120, "120", "materials/ranks/120.png"},
	{ 121, "121", "materials/ranks/121.png"},
	{ 122, "122", "materials/ranks/122.png"},
	{ 123, "123", "materials/ranks/123.png"},
	{ 124, "124", "materials/ranks/124.png"},
	{ 125, "125", "materials/ranks/125.png"},
	{ 126, "126", "materials/ranks/126.png"},
	{ 127, "127", "materials/ranks/127.png"},
	{ 128, "128", "materials/ranks/128.png"},
	{ 129, "129", "materials/ranks/129.png"},
	{ 130, "130", "materials/ranks/130.png"},
	{ 131, "General", "materials/ranks/Reach-General.png" },
	{ 132, "General [Grade 1]", "materials/ranks/Reach-GeneralG1.png" },
	{ 133, "General [Grade 2]", "materials/ranks/Reach-GeneralG2.png" },
	{ 134, "General [Grade 3]", "materials/ranks/Reach-GeneralG3.png" },
	{ 135, "General [Grade 4]", "materials/ranks/Reach-GeneralG4.png" },
	{ 136, "Field Marshall", "materials/ranks/Reach-FieldMarshall.png" },
	{ 137, "Hero", "materials/ranks/Reach-Hero.png" },
	{ 138, "Legend", "materials/ranks/Reach-Legend.png" },
	{ 139, "Mythic", "materials/ranks/Reach-Mythic.png" },
	{ 140, "Noble", "materials/ranks/Reach-Noble.png" },
	{ 141, "Eclipse", "materials/ranks/Reach-Eclipse.png" },
	{ 142, "Nova", "materials/ranks/Reach-Nova.png" },
	{ 143, "Forerunner", "materials/ranks/Reach-Forerunner.png" },
	{ 144, "Reclaimer", "materials/ranks/Reach-Reclaimer.png" },
	{ 145, "Inheritor", "materials/ranks/Reach-Inheritor.png" },
	{ 146, "New", "materials/ranks/Reach-New.png" },
	{ 150, "150", "materials/ranks/150.png" }
}

local icongroups = {
	{ "STEAM_0:1:38888957", "whuppo", "icon16/bell_error.png" },
	{ "STEAM_0:1:51344477", "Suggested \'Flopper\'", "icon16/plugin_add.png" },
    { "STEAM_0:0:44144010", "cobalt", "icon16/award_star_gold_3.png"},
	{ "operator", "Operator", "icon16/shield.png" }, 
	{ "admin", "Admin", "icon16/shield.png" },
	{ "superadmin", "Super Admin", "icon16/shield.png" },
	{ "headadmin", "Head Admin", "icon16/shield.png" },
	{ "coowner", "Co-Owner", "icon16/shield.png" },
	{ "ultravip", "Ultra VIP", "icon16/star.png" },
	{ "vip+", "VIP+", "icon16/star.png" },
	{ "vip", "VIP", "icon16/star.png" },
	{ "VIP Admin", "Admin", "icon16/star.png" },
	{ "VIP Operator", "Operator", "icon16/star.png" }
}

local colors = {
	{ "creator", Color( 255, 0, 0, 255 ) },
	{ "vip", Color( 56, 177, 242, 255 ) },
	{ "vip+", Color( 56, 177, 242, 255 ) },
	{ "ultravip", Color( 56, 177, 242, 255 ) },
	{ "owner", Color( 200, 0, 0, 255 ) },
	{ "coowner", Color( 200, 0, 0, 255 ) },
	{ "betatester", Color( 180, 180, 180, 255 ) },
	{ "superadmin", Color( 0, 230, 0, 255 ) },
	{ "admin", Color( 220, 180, 0, 255 ) },
	{ "limitedadmin", Color( 205, 127, 50, 255 ) },
	{ "headadmin", Color( 255, 20, 147, 255 ) },
	{ "user", Color( 255, 255, 255 ) }
}

local headers = {
	"Score",
	"Ping",
	"A",
	"D",
	"K",
	"Level"
}

local function AddSpacer( h, num )

	local p = vgui.Create( "DPanel" )
	p:SetSize( 0, h )
	p.Paint = function()
	end
	if num == 1 then
		dlist:AddItem( p )
	elseif num == 2 then
		dlist2:AddItem( p )
	end
	
end

surface.CreateFont( "Exo 2 Header", {
	font = "Exo 2",
	size = 16
} )

surface.CreateFont( "Exo 2 Content", {
	font = "Exo 2",
	size = 18,
	antialias = true
} )

surface.CreateFont( "Exo 2 Content Blur", {
	font = "Exo 2",
	size = 18,
	blursize = 1
} )

surface.CreateFont( "SLabelTop", { 
	font = "Trebuchet24", 
	size = 19, 
	weight = 1, 
	antialias = true 
} )

surface.CreateFont( "SLabelTopSmall", { 
	font = "Trebuchet24", 
	size = 16, 
	weight = 1, 
	antialias = true 
} )

surface.CreateFont( "SLabelName", { 
	font = "Trebuchet24", 
	size = 18, 
	weight = 1, 
	antialias = true 
} )

surface.CreateFont( "SLabelTopLarge", { 
	font = "Trebuchet24", 
	size = 24, 
	weight = 1, 
	antialias = true 
} )

function team.GetSortedPlayers( tea )
	local tab = team.GetPlayers( tea )
	table.sort( tab, function( a, b ) return a:Score() > b:Score() end )
	return tab
end

function SortPlayers()
	local plys = player.GetAll()
	local usergroups = {}
	
	for k, v in next, plys do
		if not usergroups[ v:GetUserGroup() ] then
			usergroups[ v:GetUserGroup() ] = {}
			table.insert( usergroups[ v:GetUserGroup() ], v )
		else
			table.insert( usergroups[ v:GetUserGroup() ], v )
		end
	end

	return usergroups
end

local lvls = {}
local function CreateScoreboard()

	red = vgui.Create( "DFrame" )
	red:ShowCloseButton( false )
	red:SetDraggable( false )
	red:SetTitle( "" )
	red:SetSize( 580, ScrH() - ( ScrH() / 8 ) )
	red:Center()
	red.Paint = function()
		surface.SetDrawColor( 255, 255, 255, 222 )
		surface.DrawRect( 0, 0, red:GetWide(), red:GetTall() )
		surface.SetDrawColor( TeamColor.red )
		surface.DrawRect( 0, 0, red:GetWide(), 56 )
		draw.SimpleText( "Red Team [" .. tostring( #team.GetPlayers( 1 ) ) .. "]", "Exo 2", 66, 56 / 2, white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
		local width, height = 0, 0
		for k, v in next, headers do
			draw.SimpleText( v, "Exo 2 Header", red:GetWide() - width - ( 29 * ( k - 1 ) ) - 24 - 42, 56 / 2, white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
			local _width, _height = surface.GetTextSize( v )
			width = width + _width
		end
		surface.SetTexture( gradient )
		surface.SetDrawColor( 0, 0, 0, 164 )
		surface.DrawTexturedRectRotated( red:GetWide() / 2, 56 + 4, 8, red:GetWide(), 270 )
	end

	red:ParentToHUD()
	local pos = Vector( red:GetPos() )
	red:SetPos( pos.x - 295, pos.y )

	dlist = vgui.Create( "DPanelList", red )
	dlist:SetPos( 1, 56 )
	dlist:SetSize( red:GetWide() - 2, red:GetTall() - 56 )	
	dlist:EnableVerticalScrollbar( true )
	dlist:SetSpacing( 2 )

	blue = vgui.Create( "DFrame" )
	blue:ShowCloseButton( false )
	blue:SetDraggable( false )
	blue:SetTitle( "" )
	blue:SetSize( 580, ScrH() - ( ScrH() / 8 ) )
	blue:Center()
	blue.Paint = function()
		surface.SetDrawColor( 255, 255, 255, 222 )
		surface.DrawRect( 0, 0, blue:GetWide(), blue:GetTall() )
		surface.SetDrawColor( TeamColor.blue )
		surface.DrawRect( 0, 0, blue:GetWide(), 56 )
		draw.SimpleText( "Blue Team [" .. tostring( #team.GetPlayers( 2 ) ) .. "]", "Exo 2", 66, 56 / 2, white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
		local width, height = 0, 0
		for k, v in next, headers do
			draw.SimpleText( v, "Exo 2 Header", blue:GetWide() - width - ( 29 * ( k - 1 ) ) - 24 - 42, 56 / 2, white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
			local _width, _height = surface.GetTextSize( v )
			width = width + _width
		end
		surface.SetTexture( gradient )
		surface.SetDrawColor( 0, 0, 0, 164 )
		surface.DrawTexturedRectRotated( blue:GetWide() / 2, 56 + 4, 8, blue:GetWide(), 270 )
	end
	blue:ParentToHUD()
	local pos = Vector( blue:GetPos() )
	blue:SetPos( pos.x + 295, pos.y )
	
	blue.Think = function()
		if input.IsMouseDown( MOUSE_RIGHT ) then
			blue:MakePopup()
			red:MakePopup()
		end
	end
	
	dlist2 = vgui.Create( "DPanelList", blue )
	dlist2:SetPos( 1, 56 )
	dlist2:SetSize( blue:GetWide() - 2, blue:GetTall() - 45 )	
	dlist2:EnableVerticalScrollbar( true )
	dlist2:SetSpacing( 2 )
	
	AddSpacer( 1, 1 )
	AddSpacer( 1, 2 )
	
	for k, v in next, team.GetSortedPlayers( 1 ) do
	
		local p = vgui.Create( "DPanel" )
		p:SetSize( 578, 30 )
		p.Paint = function()
			if k % 2 == 0 then
				surface.SetDrawColor( 0, 0, 0, 64 )
				surface.DrawRect( 0, 0, p:GetSize() )
			end
		end

		local col
		local group = v:GetUserGroup()
		for k, v in next, colors do
			if group == v[ 1 ] then
				col = v[ 2 ]
				break
			end
		end

		local rank
		for l, m in next, icongroups do
			if v:SteamID() == m[ 1 ] then
				rank = Material( m[ 3 ] )
				break
			elseif group == m[ 1 ] then
				rank = Material( m[ 3 ] )
				break
			end
		end

		local prestige
		for j, n in next, levelgroups do
			if tonumber( v:GetNWString( "level" ) ) == n[ 1 ] then
				prestige = Material( n[ 3 ] )
				break
			end
		end

		local btn = p:Add( "DButton" )
		btn:SetPos( 0, 0 )
		btn:SetSize( 578, 30 )
		btn:SetText( "" )
		if v:Alive() then
			btn.deathAlpha = 0
		else
			btn.deathAlpha = 164
		end
		btn.Paint = function()
			local width, height = 0, 0
			local _x = 66
			--stats
			for k, h in next, headers do
				local text
				if h == "Score" then
					text = v:Score()
				elseif h == "Ping" then
					text = v:Ping()
				elseif h == "A" then
					text = tonumber( v:GetNWString( "assists" ) ) and v:GetNWString( "assists" ) or "0"
				elseif h == "D" then
					text = v:Deaths()
				elseif h == "K" then
					text = v:Frags()
				elseif h == "Level" then
					text = v:GetNWString( "level" )
				end
				if h ~= "Level" then
					draw.SimpleText( text, "Exo 2 Content Blur", btn:GetWide() - width - ( 29 * ( k - 1 ) ) - 20 - 42 + 1, btn:GetTall() / 2 + 1 - 1, black, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
					draw.SimpleText( text, "Exo 2 Content", btn:GetWide() - width - ( 29 * ( k - 1 ) ) - 20 - 42, btn:GetTall() / 2 - 1, black, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
				else
					if ( tonumber( v:GetNWString( "level" ) ) ) > 100 then
						surface.SetMaterial( prestige )
						surface.SetDrawColor( black )
						surface.DrawTexturedRect( btn:GetWide() - width - ( 29 * ( k - 1 ) ) - 20 - 42 - 16 + 1, 6 + 1, 16, 16 )
						surface.SetDrawColor( white )
						surface.DrawTexturedRect( btn:GetWide() - width - ( 29 * ( k - 1 ) ) - 20 - 42 - 16, 6, 16, 16 )
						draw.SimpleText( text, "Exo 2 Content Blur", btn:GetWide() - width - ( 29 * ( k - 1 ) ) - 20 - 42 - 19 + 1, btn:GetTall() / 2 + 1 - 1, Color( 218, 165, 32 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
						draw.SimpleText( text, "Exo 2 Content", btn:GetWide() - width - ( 29 * ( k - 1 ) ) - 20 - 42 - 19, btn:GetTall() / 2 - 1, Color( 218, 165, 32 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
					elseif ( tonumber( v:GetNWString( "level" ) ) ) >= 100 then
						draw.SimpleText( text, "Exo 2 Content Blur", btn:GetWide() - width - ( 29 * ( k - 1 ) ) - 20 - 42 + 1, btn:GetTall() / 2 + 1 - 1, Color( 218, 165, 32 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
						draw.SimpleText( text, "Exo 2 Content", btn:GetWide() - width - ( 29 * ( k - 1 ) ) - 20 - 42, btn:GetTall() / 2 - 1, Color( 218, 165, 32 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
					else
						draw.SimpleText( text, "Exo 2 Content Blur", btn:GetWide() - width - ( 29 * ( k - 1 ) ) - 20 - 42 + 1, btn:GetTall() / 2 + 1 - 1, black, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
						draw.SimpleText( text, "Exo 2 Content", btn:GetWide() - width - ( 29 * ( k - 1 ) ) - 20 - 42, btn:GetTall() / 2 - 1, black, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
					end
				end
				local _width, _height = surface.GetTextSize( h )
				width = width + _width - 2
			end

			--ANATA NO NAMAE WA NAN DESU KA
			if rank then
				surface.SetMaterial( rank )
				surface.SetDrawColor( white )
				surface.DrawTexturedRect( 39, 6, 16, 16 )
				draw.SimpleText( v:Nick(), "Exo 2 Content Blur", 39 + 16 + 1, btn:GetTall() / 2 + 1 - 1, black, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
				draw.SimpleText( v:Nick(), "Exo 2 Content", 39 + 16, btn:GetTall() / 2 - 1, col, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
			else
				draw.SimpleText( v:Nick(), "Exo 2 Content Blur", 39 + 1, btn:GetTall() / 2 + 1 - 1, black, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
				draw.SimpleText( v:Nick(), "Exo 2 Content", 39, btn:GetTall() / 2 - 1, black, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
			end
		
			surface.SetDrawColor( 0, 0, 0, 64 )
			surface.DrawRect( 0, btn:GetTall() - 1, btn:GetWide(), 1 )

			if v:Alive() then
				btn.deathAlpha = Lerp( FrameTime() * 8, btn.deathAlpha, 0 )
			else
				btn.deathAlpha = Lerp( FrameTime() * 8, btn.deathAlpha, 164 )
			end
			surface.SetTexture( gradient )
			surface.SetDrawColor( Color( 164, 0, 0, btn.deathAlpha ) )
			surface.DrawTexturedRect( 0, 0, btn:GetSize() )

			if v == LocalPlayer() then
				surface.SetTexture( gradient )
				surface.SetDrawColor( Color( 0, 0, 0, 164 / 2 ) )
				surface.DrawTexturedRect( 0, 0, btn:GetSize() )
			end
		end
		
		local mute = p:Add( "DCheckBox" )
		local _muteicon = muteicon
		mute:SetPos( 530, 7 )
		mute:SetSize( 16, 16 )
		function mute:OnChange( bVal )
			if ( bVal ) then
				v:SetMuted( true )
				_muteicon = Material( "icon16/sound_mute.png" )
			else
				v:SetMuted( false )
				_muteicon = Material( "icon16/sound.png" )
			end
		end
		mute.Paint = function()
			surface.SetDrawColor( color_white )
			surface.SetMaterial( _muteicon )
			surface.DrawTexturedRect( 0, 0, mute:GetSize() )
		end
		
		local stats = p:Add( "DButton" )
		stats:SetPos( 552, 7 )
		stats:SetSize( 16, 16 )
		stats:SetText( "" )
		stats:SetToolTip( "View " .. v:Nick() .. "'s playercard" )
		stats.Paint = function()
			surface.SetDrawColor( color_white )
			surface.SetMaterial( cardicon )
			surface.DrawTexturedRect( 0, 0, stats:GetSize() )
		end
		stats.DoClick = function()
			OpenPlayercard( v )
		end

		btn.OnCursorEntered = function()
			surface.PlaySound( "garrysmod/ui_hover.wav" )
		end
		
		btn.DoRightClick = function()
			surface.PlaySound( "garrysmod/ui_click.wav" )
			local menu = DermaMenu()
			
				menu:AddOption( "View Profile", function()
					v:ShowProfile() 
				end ):SetIcon( "icon16/world.png" )
				
				if v ~= LocalPlayer() then
					if not v:IsMuted() then
						menu:AddOption( "Mute Player", function()
							v:SetMuted( true )
						end ):SetIcon( "icon16/sound.png" )
					else
						menu:AddOption( "Unmute Player", function()
							v:SetMuted( false )
						end ):SetIcon( "icon16/sound.png" )		
					end
				end
				
				menu:AddOption( "Copy SteamID", function()
					SetClipboardText( v:SteamID() )
				end ):SetIcon( "icon16/tag_blue_edit.png" )
				
				menu:AddOption( "Copy Name", function()
					SetClipboardText( v:Name() )
				end ):SetIcon( "icon16/user_edit.png" )	
				
				menu:AddSpacer()
				
				if ULib.ucl.query( LocalPlayer(), "ulx gag" ) then
					menu:AddOption( "Gag Player", function()
						RunConsoleCommand( "ulx", "gag", v:Nick() )
					end ):SetIcon( "icon16/sound_delete.png" )
					menu:AddOption( "Ungag Player", function()
						RunConsoleCommand( "ulx", "ungag", v:Nick() )
					end ):SetIcon( "icon16/sound_add.png" )			
				end
				
				if ULib.ucl.query( LocalPlayer(), "ulx mute" ) then
					menu:AddOption( "Gag Player", function()
						RunConsoleCommand( "ulx", "mute", v:Nick() )
					end ):SetIcon( "icon16/pencil_delete.png" )
					menu:AddOption( "Ungag Player", function()
						RunConsoleCommand( "ulx", "unmute", v:Nick() )
					end ):SetIcon( "icon16/pencil_add.png" )		
				end
				
				if ULib.ucl.query( LocalPlayer(), "ulx spectate" ) and v ~= LocalPlayer() then
					menu:AddOption( "Spectate", function()
						RunConsoleCommand( "ulx", "spectate", v:Nick() )
					end ):SetIcon( "icon16/zoom.png" )
				end
				
				if ULib.ucl.query( LocalPlayer(), "ulx kick" ) then
					menu:AddOption( "Kick Player", function()

						local Frame = vgui.Create( "DFrame" )
						Frame:SetSize( 250, 98 )
						Frame:Center()
						Frame:MakePopup()
						Frame:SetTitle( "Kick Player" )
						
						local TimeLabel = vgui.Create( "DLabel", Frame )
						TimeLabel:SetPos( 5,27 )
						TimeLabel:SetColor( Color( 0,0,0,255 ) )
						TimeLabel:SetFont( "DermaDefault" )
						TimeLabel:SetText( "Time:" )
						
						local Time = vgui.Create( "DTextEntry", Frame )
						Time:SetPos( 47, 27 )
						Time:SetSize( 198, 20 )
						Time:SetText( "" )
						Time:SetDisabled( true )
						Time:SetEditable( false )
						
						local ReasonLabel = vgui.Create( "DLabel", Frame )
						ReasonLabel:SetPos( 5,50 )
						ReasonLabel:SetColor( Color( 0,0,0,255 ) )
						ReasonLabel:SetFont( "DermaDefault" )
						ReasonLabel:SetText( "Reason:" )
						
						local Reason = vgui.Create( "DTextEntry", Frame )
						Reason:SetPos( 47, 50 )
						Reason:SetSize( 198, 20 )
						Reason:SetText( "" )
						
						local execbutton = vgui.Create( "DButton", Frame )
						execbutton:SetSize( 75, 20 )
						execbutton:SetPos( 47, 73 )
						execbutton:SetText( "Ban!" )
						execbutton.DoClick = function()
							RunConsoleCommand( "ulx", "banid", v:SteamID(), Time:GetText(), Reason:GetText() )
							Frame:Close()
						end
						
						local cancelbutton = vgui.Create( "DButton", Frame )
						cancelbutton:SetSize( 75, 20 )
						cancelbutton:SetPos( 127, 73 )
						cancelbutton:SetText( "Cancel" )
						cancelbutton.DoClick = function( cancelbutton )
							Frame:Close()
						end

					end ):SetIcon( "icon16/disconnect.png" )
				end
				
				if ULib.ucl.query( LocalPlayer(), "ulx banid" ) then
					menu:AddOption( "Ban by SteamID", function()

						local Frame = vgui.Create( "DFrame" )
						Frame:SetSize( 250, 98 )
						Frame:Center()
						Frame:MakePopup()
						Frame:SetTitle( "Ban by SteamID" )
						
						local TimeLabel = vgui.Create( "DLabel", Frame )
						TimeLabel:SetPos( 5,27 )
						TimeLabel:SetColor( Color( 0,0,0,255 ) )
						TimeLabel:SetFont( "DermaDefault" )
						TimeLabel:SetText( "Time:" )
						
						local Time = vgui.Create( "DTextEntry", Frame )
						Time:SetPos( 47, 27 )
						Time:SetSize( 198, 20 )
						Time:SetText( "" )
						
						local ReasonLabel = vgui.Create( "DLabel", Frame )
						ReasonLabel:SetPos( 5,50 )
						ReasonLabel:SetColor( Color( 0,0,0,255 ) )
						ReasonLabel:SetFont( "DermaDefault" )
						ReasonLabel:SetText( "Reason:" )
						
						local Reason = vgui.Create( "DTextEntry", Frame )
						Reason:SetPos( 47, 50 )
						Reason:SetSize( 198, 20 )
						Reason:SetText( "" )
						
						local execbutton = vgui.Create( "DButton", Frame )
						execbutton:SetSize( 75, 20 )
						execbutton:SetPos( 47, 73 )
						execbutton:SetText( "Ban!" )
						execbutton.DoClick = function()
							RunConsoleCommand( "ulx", "banid", v:SteamID(), Time:GetText(), Reason:GetText() )
							Frame:Close()
						end
						
						local cancelbutton = vgui.Create( "DButton", Frame )
						cancelbutton:SetSize( 75, 20 )
						cancelbutton:SetPos( 127, 73 )
						cancelbutton:SetText( "Cancel" )
						cancelbutton.DoClick = function( cancelbutton )
							Frame:Close()
						end
						
					end ):SetIcon( "icon16/tag_blue_delete.png" )		
				end
				
			menu:Open()
			
		end
		
		local a = p:Add( "AvatarImage" )
		a:SetPos( 2, 2 )
		a:SetSize( 26, 26 )
		a:SetPlayer( v )
		
		local abtn = a:Add( "DButton" )
		abtn:SetSize( a:GetSize() )
		abtn:SetText( "" )
		abtn.Paint = function()
		end
		
		abtn.DoClick = function()
			v:ShowProfile()
		end
		
		dlist:AddItem( p )
		
	end
	
	for k, v in next, team.GetSortedPlayers( 2 ) do
	
		local p = vgui.Create( "DPanel" )
		p:SetSize( 578, 30 )
		p.Paint = function()
			if k % 2 == 0 then
				surface.SetDrawColor( 0, 0, 0, 64 )
				surface.DrawRect( 0, 0, p:GetSize() )
			end
		end

		local col
		local group = v:GetUserGroup()
		for k, v in next, colors do
			if group == v[ 1 ] then
				col = v[ 2 ]
				break
			end
		end

		local rank
		for l, m in next, icongroups do
			if v:SteamID() == m[ 1 ] then
				rank = Material( m[ 3 ] )
				break
			elseif group == m[ 1 ] then
				rank = Material( m[ 3 ] )
				break
			end
		end

		local prestige
		for j, n in next, levelgroups do
			if tonumber( v:GetNWString( "level" ) ) == n[ 1 ] then
				prestige = Material( n[ 3 ] )
				break
			end
		end

		local btn = p:Add( "DButton" )
		btn:SetPos( 0, 0 )
		btn:SetSize( 578, 30 )
		btn:SetText( "" )	
		if v:Alive() then
			btn.deathAlpha = 0
		else
			btn.deathAlpha = 164
		end
		btn.Paint = function()
			local width, height = 0, 0
			local _x = 66
			--stats
			for k, h in next, headers do
				local text
				if h == "Score" then
					text = v:Score()
				elseif h == "Ping" then
					text = v:Ping()
				elseif h == "A" then
					text = tonumber( v:GetNWString( "assists" ) ) and v:GetNWString( "assists" ) or "0"
				elseif h == "D" then
					text = v:Deaths()
				elseif h == "K" then
					text = v:Frags()
				elseif h == "Level" then
					text = v:GetNWString( "level" )
				end
				if h ~= "Level" then
					draw.SimpleText( text, "Exo 2 Content Blur", btn:GetWide() - width - ( 29 * ( k - 1 ) ) - 20 - 42 + 1, btn:GetTall() / 2 + 1 - 1, black, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
					draw.SimpleText( text, "Exo 2 Content", btn:GetWide() - width - ( 29 * ( k - 1 ) ) - 20 - 42, btn:GetTall() / 2 - 1, black, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
				else
					if ( tonumber( v:GetNWString( "level" ) ) ) > 100 then
						surface.SetMaterial( prestige )
						surface.SetDrawColor( black )
						surface.DrawTexturedRect( btn:GetWide() - width - ( 29 * ( k - 1 ) ) - 20 - 42 - 16 + 1, 6 + 1, 16, 16 )
						surface.SetDrawColor( white )
						surface.DrawTexturedRect( btn:GetWide() - width - ( 29 * ( k - 1 ) ) - 20 - 42 - 16, 6, 16, 16 )
						draw.SimpleText( text, "Exo 2 Content Blur", btn:GetWide() - width - ( 29 * ( k - 1 ) ) - 20 - 42 - 19 + 1, btn:GetTall() / 2 + 1 - 1, Color( 218, 165, 32 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
						draw.SimpleText( text, "Exo 2 Content", btn:GetWide() - width - ( 29 * ( k - 1 ) ) - 20 - 42 - 19, btn:GetTall() / 2 - 1, Color( 218, 165, 32 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
					elseif ( tonumber( v:GetNWString( "level" ) ) ) >= 100 then
						draw.SimpleText( text, "Exo 2 Content Blur", btn:GetWide() - width - ( 29 * ( k - 1 ) ) - 20 - 42 + 1, btn:GetTall() / 2 + 1 - 1, Color( 218, 165, 32 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
						draw.SimpleText( text, "Exo 2 Content", btn:GetWide() - width - ( 29 * ( k - 1 ) ) - 20 - 42, btn:GetTall() / 2 - 1, Color( 218, 165, 32 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
					else
						draw.SimpleText( text, "Exo 2 Content Blur", btn:GetWide() - width - ( 29 * ( k - 1 ) ) - 20 - 42 + 1, btn:GetTall() / 2 + 1 - 1, black, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
						draw.SimpleText( text, "Exo 2 Content", btn:GetWide() - width - ( 29 * ( k - 1 ) ) - 20 - 42, btn:GetTall() / 2 - 1, black, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
					end
				end
				local _width, _height = surface.GetTextSize( h )
				width = width + _width - 2
			end

			--ANATA NO NAMAE WA NAN DESU KA
			if rank then
				surface.SetMaterial( rank )
				surface.SetDrawColor( white )
				surface.DrawTexturedRect( 39, 6, 16, 16 )
				draw.SimpleText( v:Nick(), "Exo 2 Content Blur", 39 + 16 + 1, btn:GetTall() / 2 + 1 - 1, black, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
				draw.SimpleText( v:Nick(), "Exo 2 Content", 39 + 16, btn:GetTall() / 2 - 1, col, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
			else
				draw.SimpleText( v:Nick(), "Exo 2 Content Blur", 39 + 1, btn:GetTall() / 2 + 1 - 1, black, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
				draw.SimpleText( v:Nick(), "Exo 2 Content", 39, btn:GetTall() / 2 - 1, black, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
			end
		
			surface.SetDrawColor( 0, 0, 0, 64 )
			surface.DrawRect( 0, btn:GetTall() - 1, btn:GetWide(), 1 )

			if v:Alive() then
				btn.deathAlpha = Lerp( FrameTime() * 8, btn.deathAlpha, 0 )
			else
				btn.deathAlpha = Lerp( FrameTime() * 8, btn.deathAlpha, 164 )
			end
			surface.SetTexture( gradient )
			surface.SetDrawColor( Color( 164, 0, 0, btn.deathAlpha ) )
			surface.DrawTexturedRect( 0, 0, btn:GetSize() )

			if v == LocalPlayer() then
				surface.SetTexture( gradient )
				surface.SetDrawColor( Color( 0, 0, 0, 164 / 2 ) )
				surface.DrawTexturedRect( 0, 0, btn:GetSize() )
			end
		end
		
		local mute = p:Add( "DCheckBox" )
		local _muteicon = muteicon
		mute:SetPos( 530, 7 )
		mute:SetSize( 16, 16 )
		function mute:OnChange( bVal )
			if ( bVal ) then
				v:SetMuted( true )
				_muteicon = Material( "icon16/sound_mute.png" )
			else
				v:SetMuted( false )
				_muteicon = Material( "icon16/sound.png" )
			end
		end
		mute.Paint = function()
			surface.SetDrawColor( color_white )
			surface.SetMaterial( _muteicon )
			surface.DrawTexturedRect( 0, 0, mute:GetSize() )
		end
		
		local stats = p:Add( "DButton" )
		stats:SetPos( 552, 7 )
		stats:SetSize( 16, 16 )
		stats:SetText( "" )
		stats:SetToolTip( "View " .. v:Nick() .. "'s playercard" )
		stats.Paint = function()
			surface.SetDrawColor( color_white )
			surface.SetMaterial( cardicon )
			surface.DrawTexturedRect( 0, 0, stats:GetSize() )
		end
		stats.DoClick = function()
			OpenPlayercard( v )
		end

		btn.OnCursorEntered = function()
			surface.PlaySound( "garrysmod/ui_hover.wav" )
		end
		
		btn.DoRightClick = function()
			surface.PlaySound( "garrysmod/ui_click.wav" )
			local menu = DermaMenu()
			
				menu:AddOption( "View Profile", function()
					v:ShowProfile() 
				end ):SetIcon( "icon16/world.png" )
				
				if v ~= LocalPlayer() then
					if not v:IsMuted() then
						menu:AddOption( "Mute Player", function()
							v:SetMuted( true )
						end ):SetIcon( "icon16/sound.png" )
					else
						menu:AddOption( "Unmute Player", function()
							v:SetMuted( false )
						end ):SetIcon( "icon16/sound.png" )		
					end
				end
				
				menu:AddOption( "Copy SteamID", function()
					SetClipboardText( v:SteamID() )
				end ):SetIcon( "icon16/tag_blue_edit.png" )
				
				menu:AddOption( "Copy Name", function()
					SetClipboardText( v:Name() )
				end ):SetIcon( "icon16/user_edit.png" )	
				
				menu:AddSpacer()
				
				if ULib.ucl.query( LocalPlayer(), "ulx gag" ) then
					menu:AddOption( "Gag Player", function()
						RunConsoleCommand( "ulx", "gag", v:Nick() )
					end ):SetIcon( "icon16/sound_delete.png" )
					menu:AddOption( "Ungag Player", function()
						RunConsoleCommand( "ulx", "ungag", v:Nick() )
					end ):SetIcon( "icon16/sound_add.png" )			
				end
				
				if ULib.ucl.query( LocalPlayer(), "ulx mute" ) then
					menu:AddOption( "Gag Player", function()
						RunConsoleCommand( "ulx", "mute", v:Nick() )
					end ):SetIcon( "icon16/pencil_delete.png" )
					menu:AddOption( "Ungag Player", function()
						RunConsoleCommand( "ulx", "unmute", v:Nick() )
					end ):SetIcon( "icon16/pencil_add.png" )		
				end
				
				if ULib.ucl.query( LocalPlayer(), "ulx spectate" ) and v ~= LocalPlayer() then
					menu:AddOption( "Spectate", function()
						RunConsoleCommand( "ulx", "spectate", v:Nick() )
					end ):SetIcon( "icon16/zoom.png" )
				end
				
				if ULib.ucl.query( LocalPlayer(), "ulx kick" ) then
					menu:AddOption( "Kick Player", function()

						local Frame = vgui.Create( "DFrame" )
						Frame:SetSize( 250, 98 )
						Frame:Center()
						Frame:MakePopup()
						Frame:SetTitle( "Kick Player" )
						
						local TimeLabel = vgui.Create( "DLabel", Frame )
						TimeLabel:SetPos( 5,27 )
						TimeLabel:SetColor( Color( 0,0,0,255 ) )
						TimeLabel:SetFont( "DermaDefault" )
						TimeLabel:SetText( "Time:" )
						
						local Time = vgui.Create( "DTextEntry", Frame )
						Time:SetPos( 47, 27 )
						Time:SetSize( 198, 20 )
						Time:SetText( "" )
						Time:SetDisabled( true )
						Time:SetEditable( false )
						
						local ReasonLabel = vgui.Create( "DLabel", Frame )
						ReasonLabel:SetPos( 5,50 )
						ReasonLabel:SetColor( Color( 0,0,0,255 ) )
						ReasonLabel:SetFont( "DermaDefault" )
						ReasonLabel:SetText( "Reason:" )
						
						local Reason = vgui.Create( "DTextEntry", Frame )
						Reason:SetPos( 47, 50 )
						Reason:SetSize( 198, 20 )
						Reason:SetText( "" )
						
						local execbutton = vgui.Create( "DButton", Frame )
						execbutton:SetSize( 75, 20 )
						execbutton:SetPos( 47, 73 )
						execbutton:SetText( "Ban!" )
						execbutton.DoClick = function()
							RunConsoleCommand( "ulx", "banid", v:SteamID(), Time:GetText(), Reason:GetText() )
							Frame:Close()
						end
						
						local cancelbutton = vgui.Create( "DButton", Frame )
						cancelbutton:SetSize( 75, 20 )
						cancelbutton:SetPos( 127, 73 )
						cancelbutton:SetText( "Cancel" )
						cancelbutton.DoClick = function( cancelbutton )
							Frame:Close()
						end

					end ):SetIcon( "icon16/disconnect.png" )
				end
				
				if ULib.ucl.query( LocalPlayer(), "ulx banid" ) then
					menu:AddOption( "Ban by SteamID", function()

						local Frame = vgui.Create( "DFrame" )
						Frame:SetSize( 250, 98 )
						Frame:Center()
						Frame:MakePopup()
						Frame:SetTitle( "Ban by SteamID" )
						
						local TimeLabel = vgui.Create( "DLabel", Frame )
						TimeLabel:SetPos( 5,27 )
						TimeLabel:SetColor( Color( 0,0,0,255 ) )
						TimeLabel:SetFont( "DermaDefault" )
						TimeLabel:SetText( "Time:" )
						
						local Time = vgui.Create( "DTextEntry", Frame )
						Time:SetPos( 47, 27 )
						Time:SetSize( 198, 20 )
						Time:SetText( "" )
						
						local ReasonLabel = vgui.Create( "DLabel", Frame )
						ReasonLabel:SetPos( 5,50 )
						ReasonLabel:SetColor( Color( 0,0,0,255 ) )
						ReasonLabel:SetFont( "DermaDefault" )
						ReasonLabel:SetText( "Reason:" )
						
						local Reason = vgui.Create( "DTextEntry", Frame )
						Reason:SetPos( 47, 50 )
						Reason:SetSize( 198, 20 )
						Reason:SetText( "" )
						
						local execbutton = vgui.Create( "DButton", Frame )
						execbutton:SetSize( 75, 20 )
						execbutton:SetPos( 47, 73 )
						execbutton:SetText( "Ban!" )
						execbutton.DoClick = function()
							RunConsoleCommand( "ulx", "banid", v:SteamID(), Time:GetText(), Reason:GetText() )
							Frame:Close()
						end
						
						local cancelbutton = vgui.Create( "DButton", Frame )
						cancelbutton:SetSize( 75, 20 )
						cancelbutton:SetPos( 127, 73 )
						cancelbutton:SetText( "Cancel" )
						cancelbutton.DoClick = function( cancelbutton )
							Frame:Close()
						end
						
					end ):SetIcon( "icon16/tag_blue_delete.png" )		
				end
				
			menu:Open()
			
		end
		
		local a = p:Add( "AvatarImage" )
		a:SetPos( 2, 2 )
		a:SetSize( 26, 26 )
		a:SetPlayer( v )
		
		local abtn = a:Add( "DButton" )
		abtn:SetSize( a:GetSize() )
		abtn:SetText( "" )
		abtn.Paint = function()
		end
		
		abtn.DoClick = function()
			v:ShowProfile()
		end
		
		dlist2:AddItem( p )
		
	end
	
	local pos = Vector( red:GetPos() )
	spec = vgui.Create( "DPanel" )
	spec:SetPos( pos.x, pos.y + ScrH() - ( ScrH() / 8 ) + 3 )
	spec:SetSize( 1170, 30 )
	spec.Paint = function()
		surface.SetDrawColor( 255, 255, 255, 222 )
		surface.DrawRect( 0, 0, spec:GetSize() )
		surface.SetTextColor( black )
		surface.SetTextPos( 5, 5 )
		surface.SetFont( "Exo 2 Content" )
		
		local asd = {}
		for k, v in next, team.GetPlayers( 0 ) do
			table.insert( asd, v:Nick() )
		end
		
		surface.DrawText( "Spectators: " .. table.concat( asd, ", " ) )
	end
	
end

function GM:ScoreboardShow()
	CreateScoreboard()
end

function GM:ScoreboardHide()
	if not ( red and blue ) then
		return 
	end
	red:SetVisible( false )
	blue:SetVisible( false )
	if spec then
		spec:SetVisible( false )
	end
end