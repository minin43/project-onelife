print( "cl_scoreboard initialization..." )
surface.CreateFont( "Exo 2 Regular", {
	font = "Exo 2",
	size = 40,
	weight = 400
} )

surface.CreateFont( "Exo 2 Small", {
	font = "Exo 2",
	size = 30,
	weight = 400
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

local gradient = surface.GetTextureID( "gui/gradient" )
local voice = Material( "icon16/sound.png" )
local novoice = Material( "icon16/sound_none.png" )
local voicemuted = Material( "icon16/sound_mute.png" )

local levelgroups = {
	{ 1, "Private", "ranks/private.png"},
	{ 2, "Private First Class", "ranks/privatefirstclass.png"},
	{ 3, "Corporal", "ranks/corporal.png"},
	{ 4, "Specialist", "ranks/specialist.png"},
	{ 5, "Sergeant", "ranks/sergeant.png"},
	{ 6, "Staff Sergeant", "ranks/staffsergeant.png"},
	{ 7, "Sergeant First Class", "ranks/sergeantfirstclass.png"},
	{ 8, "Master Sergeant", "ranks/mastersergeant.png"},
    --//Here starts ranks that give nothing new
	{ 9, "First Sergeant", "ranks/firstsergeant.png"},
	{ 10, "Sergeant Major", "ranks/sergeantmajor.png"},
	{ 11, "Second Lieutenant", "ranks/secondlieutenant.png"},
	{ 12, "First Lieutenant", "ranks/firstlieutenant.png"},
	{ 13, "Captain", "ranks/captain.png"},
	{ 14, "Major", "ranks/major.png"},
	{ 15, "Lieutenant Colonel", "ranks/lieutenantcolonel.png"},
	{ 16, "Colonel", "ranks/colonel.png"}
}

local icongroups = {
	{ "STEAM_0:0:34834901", "Logan", 			"icon16/award_star_gold_3.png"}, --Das me
	{ "user", 				"user", 			"icon16/status_online.png" },
    { "vip", 				"VIP", 				"icon16/star.png" },
    { "vip+", 				"VIP+", 			"icon16/star.png" },
	{ "moderator", 			"Moderator", 		"icon16/shield.png" },
	{ "vipmod", 			"VIP Moderator", 	"icon16/shield.png" },
	{ "admin", 				"Admin", 			"icon16/shield.png" },
	{ "senioradmin", 		"Senior Admin", 	"icon16/shield.png" },
	{ "headadmin", 			"Head Admin", 		"icon16/shield.png" },
	{ "superadmin", 		"Super Admin", 		"icon16/shield.png" },
	{ "coowner", 			"Co-Owner", 		"icon16/shield.png" },
	{ "owner", 				"Owner", 			"icon16/shield.png" }
}


local colors = {
    [ "user" ] = Color( 255, 255, 255, 255 ), --White (TRIGGERED)
    [ "vip" ] = Color( 56, 177, 242, 255 ), --Blue
    [ "vip+" ] = Color( 55, 243, 243, 255 ), --Sky Blue
    [ "moderator" ] = Color( 180, 10, 10, 255 ), --Dark Red
    [ "vipmod" ] = Color( 228, 87, 255, 255 ), --a mod who's bought VIP, Light Purple
    [ "admin" ] = Color( 255, 0, 0, 255 ), --Red
    [ "senioradmin" ] = Color( 204, 102, 0, 255 ), --Dark Orange
    [ "headadmin" ] = Color( 255, 153, 51, 255 ), --Bright Orange
    [ "superadmin" ] = Color( 255, 255, 0, 255 ), --Yellow
    [ "coowner" ] = Color( 255, 0, 127, 255 ), --Grey
    [ "owner" ] = Color( 128, 128, 128, 255 ), --Magenta
    [ "developer" ] = Color( 255, 215, 0, 255 ), --Gold (because gold's my favorite color)
	--//This is for team colors
	[ 0 ] = Color( 255, 255, 255 ),
	[ 1 ] = Color( 100, 15, 15 ),
	[ 2 ] = Color( 30, 80, 180 ),
	[ 3 ] = Color( 15, 160, 15 )
}

--//Order of info, left to right: Level Icon - ULX Icon (if applicable) - Name - Score - Role - Ping - Mute icon| Level Icon - ULX Icon (if applicable) - Name - Ping
--//Only members of your team will show up as alive or dead (dead members will be faded)
--//No K/D/A bullshit because that only promotes toxicity; score only. I can maybe provide a career K/D on the loadout customization screen...
local teamheaders = {
	"Score",
	"            Role", --this is an incredibly janky-ass duct-tape-y fix...
	"Ping"
}
table.Reverse( teamheaders )

local enemyheaders = {
	"Ping"
}

function team.GetSortedPlayers( teamtouse )
	local teamtable = team.GetPlayers( teamtouse )
	table.sort( teamtable, function( a, b ) return a:Score() > b:Score() end )
	return teamtable
end

function CreateScoreboard()

	myteam = vgui.Create( "DFrame" )
	myteam:ShowCloseButton( false )
	myteam:SetDraggable( false )
	myteam:SetTitle( "" )
	myteam:SetSize( 580, ScrH() - ( ScrH() / 6 ) )
	myteam:Center()
	myteam:ParentToHUD()
	myteam.Paint = function()
		surface.SetDrawColor( 10, 10, 10, 220 )
		surface.DrawRect( 0, 0, myteam:GetWide(), myteam:GetTall() )
		surface.SetDrawColor( colors[ LocalPlayer():Team() ] )
		surface.DrawRect( 0, 0, myteam:GetWide(), 56 )
		if LocalPlayer():Team() == 1 then
			surface.SetMaterial( Material( "hud/icons/icon_" .. team.GetName( 1 ) .. ".png" ) )
		elseif LocalPlayer():Team() == 2 then
			surface.SetMaterial( Material( "hud/icons/icon_" .. team.GetName( 2 ) .. ".png" ) )
		end
		surface.SetDrawColor( 255, 255, 255, 255 )
		surface.DrawTexturedRect( 15, 10, 36, 36 )
		draw.SimpleText( team.GetName( LocalPlayer():Team() ), "Exo 2 Regular", 66, 56 / 2, Color( 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
		local width, height = 0, 0
		for k, v in pairs( table.Reverse( teamheaders ) ) do
			draw.SimpleText( v, "Exo 2 Small", myteam:GetWide() - width - ( 45 * ( k - 1 ) ) - 48, 56 / 2, white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
			local _width, _height = surface.GetTextSize( v )
			width = width + _width
		end
		surface.SetTexture( gradient )
		surface.SetDrawColor( 0, 0, 0, 164 )
		surface.DrawTexturedRectRotated( myteam:GetWide() / 2, 56 + 4, 8, myteam:GetWide(), 270 )
	end
	myteam.Think = function()
		if input.IsMouseDown( MOUSE_RIGHT ) then
			myteam:MakePopup()
			--if !TeamThree() then
				enemyteam:MakePopup()
				switchteams:MakePopup()
			--end
		end
	end

	dlist = vgui.Create( "DScrollPanel", myteam )
	dlist:SetPos( 1, 57 )
	dlist:SetSize( myteam:GetWide() - 2, myteam:GetTall() - 54 )	
	--dlist:SetPadding( 2 )
	--dlist:EnableVerticalScrollbar( true )
	--dlist:SetSpacing( 2 )

	--if !TeamThree() then
		local pos = Vector( myteam:GetPos() )
		myteam:SetPos( pos.x - 295, pos.y ) --Offsets the frame by a half + 5 pixel buffer

		local enemyteaminfo, enemyteamnumber
		if LocalPlayer():Team() == 1 then enemyteamnumber = 2 else enemyteamnumber = 1 end

		enemyteam = vgui.Create( "DFrame" )
		enemyteam:ShowCloseButton( false )
		enemyteam:SetDraggable( false )
		enemyteam:SetTitle( "" )
		enemyteam:SetSize( 580, ScrH() - ( ScrH() / 6 ) )
		enemyteam:Center()
		enemyteam:ParentToHUD()
		enemyteam.Paint = function()
			surface.SetDrawColor( 10, 10, 10, 220 )
			surface.DrawRect( 0, 0, enemyteam:GetWide(), enemyteam:GetTall() )
			surface.SetDrawColor( colors[ enemyteamnumber ] )
			surface.DrawRect( 0, 0, enemyteam:GetWide(), 56 )
			if LocalPlayer():Team() == 1 then
				surface.SetMaterial( Material( "hud/icons/icon_" .. team.GetName( 2 ) .. ".png" ) )
			elseif LocalPlayer():Team() == 2 then
				surface.SetMaterial( Material( "hud/icons/icon_" .. team.GetName( 1 ) .. ".png" ) )
			end
			surface.SetDrawColor( 255, 255, 255, 255 )
			surface.DrawTexturedRect( 15, 10, 36, 36 )
			draw.SimpleText( team.GetName( enemyteamnumber ), "Exo 2 Regular", 66, 56 / 2, Color( 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
			local width, height = 0, 0
			for k, v in next, enemyheaders do
				draw.SimpleText( v, "Exo 2 Small", enemyteam:GetWide() - width - ( 45 * ( k - 1 ) ) - 48, 56 / 2, white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
				local _width, _height = surface.GetTextSize( v )
				width = width + _width
			end
			surface.SetTexture( gradient )
			surface.SetDrawColor( 0, 0, 0, 164 )
			surface.DrawTexturedRectRotated( enemyteam:GetWide() / 2, 56 + 4, 8, enemyteam:GetWide(), 270 )
		end

		local pos = Vector( enemyteam:GetPos() )
		enemyteam:SetPos( pos.x + 295, pos.y ) --Offsets the frame by a half + 5 pixel buffer

		switchteams = vgui.Create( "DFrame" )
		switchteams:ShowCloseButton( false )
		switchteams:SetDraggable( false )
		switchteams:SetTitle( "" )
		switchteams:SetSize( 300, 70 )
		switchteams:SetPos( ScrW() / 2 + ( enemyteam:GetWide() - switchteams:GetWide() ), ScrH() / 2 - ( enemyteam:GetTall() / 2 ) - switchteams:GetTall() - 5 )
		switchteams:ParentToHUD()
		switchteams.Paint = function()
			surface.SetDrawColor( colors[ enemyteamnumber ] )
			surface.DrawRect( switchteams:GetWide() / 3, 0, switchteams:GetWide(), switchteams:GetTall() )
			surface.SetDrawColor( colors[ enemyteamnumber ] )
			draw.NoTexture()
			surface.DrawPoly( { x = switchteams:GetWide() / 3, y = 0 }, { x = switchteams:GetWide() / 3, y = switchteams:GetTall() }, { x = 0, y = switchteams:GetTall() } )
		end
		
		local switchteamshover = false
		switchteamsbutton = vgui.Create( "DButton", switchteams )
		switchteamsbutton:SetSize( switchteams:GetWide() / 2, switchteams:GetTall() - 4 )
		switchteamsbutton:SetPos( switchteams:GetWide() / 2 - 2, 2 )
		switchteamsbutton:SetText( "" )
		switchteamsbutton.Paint = function()
			surface.SetFont( "Exo 2 Large" )
			draw.DrawText( "Click to Switch Teams", "Exo 2 Regular", switchteamsbutton:GetWide() / 2, switchteamsbutton:GetTall() / 2, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			if switchteamshover then
				surface.SetDrawColor( 200, 200, 200, 50 )
				surface.DrawRect( 0, 0, switchteamsbutton:GetWide(), switchteamsbutton:GetTall() )
			end
		end
		switchteams.DoClick = function()
			if LocalPlayer():Team() == 2 then
				LocalPlayer():Concommand( "pol_setteam 1" )
			elseif LocalPlayer():Team() == 1 then
				LocalPlayer():Concommand( "pol_setteam 2" )
			end
		end
		switchteams.OnCursorEntered = function()
			switchteamshover = true
		end
		switchteams.OnCursorExited = function()
			switchteamshover = false
		end
		
		dlist2 = vgui.Create( "DPanelList", enemyteam )
		dlist2:SetPos( 1, 56 )
		dlist2:SetSize( enemyteam:GetWide() - 2, enemyteam:GetTall() - 54 )	
		--dlist2:EnableVerticalScrollbar( true )
		--dlist2:SetSpacing( 2 )
	--end

	for k, v in pairs( team.GetAllTeams() ) do
		for k2, v2 in pairs( team.GetSortedPlayers( k ) ) do
			local playerbase = vgui.Create( "DPanel" )
			playerbase:SetSize( 580, 30 )
			playerbase:SetPos( 0, playerbase:GetTall() * ( k2 - 1 ) )

			--//This sets the color to be used based on the player's ULX group
			local namecolor = Color( 255, 255, 255 )
			local group = v2:GetUserGroup()
			for k3, v3 in pairs( colors ) do
				if isstring( k3 ) and group == k3 then
					namecolor = v3
					break
				end
			end

			local levelrank = Material( levelgroups[ 1 ][ 3 ] )
			for k3, v3 in pairs( levelgroups ) do
				if tonumber( v2:GetNWString( "level" ) ) == v3[ 1 ] then
					levelrank = Material( v3[ 3 ] )
					break
				end
			end

			local ulxrank = "icon16/status_online.png"
			for k3, v3 in pairs( icongroups ) do
				if v2:SteamID() == v3[ 1 ] then
					ulxrank = Material( v3[ 3 ] )
					break
				elseif group == v3[ 1 ] then
					ulxrank = Material( v3[ 3 ] )
					break
				end
			end

			playerbase.Paint = function()
				if v2:Team() == LocalPlayer():Team() then
					headertouse = table.Reverse( teamheaders )
				else
					headertouse = table.Reverse( enemyheaders )
				end

				if v2:Alive() and ( v2:Team() == LocalPlayer():Team() ) then
					surface.SetDrawColor( colors[ v2:Team() ] )
				else
					surface.SetDrawColor( 0, 0, 0, 64 )
				end
				surface.SetTexture( gradient )
				--surface.SetDrawColor( 0, 0, 0, 164 )
				surface.DrawTexturedRectRotated( 0, 0, playerbase:GetSize(), myteam:GetWide(), 0 )
				surface.DrawTexturedRectRotated( 0, 0, playerbase:GetSize(), myteam:GetWide(), 0 )
				surface.DrawTexturedRectRotated( 0, 0, playerbase:GetSize(), myteam:GetWide(), 0 )
				--surface.DrawRect( 0, 0, playerbase:GetSize() )
				surface.SetDrawColor( Color( 255, 255, 255, 5 ) )
				surface.DrawRect( 0, 0, playerbase:GetSize() )

				if ulxrank then
					surface.SetDrawColor( Color( 255, 255, 522, 255 ) )
					surface.SetMaterial( ulxrank )
					surface.DrawTexturedRect( 7, 6, 16, 16 )
				end

				if levelrank then
					surface.SetDrawColor( Color( 255, 255, 255, 255 ) )
					surface.SetMaterial( levelrank )
					surface.DrawTexturedRect( 30, 6, 16, 16 )
				end

				draw.SimpleText( v2:Nick(), "Exo 2 Content Blur", 39 + 16 + 2, playerbase:GetTall() / 2 + 1 - 1, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
				draw.SimpleText( v2:Nick(), "Exo 2 Content", 39 + 16, playerbase:GetTall() / 2 - 1, namecolor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )

				local width, height = 0, 0
				local text
				for k3, v3 in pairs( headertouse ) do
					if v3 == "Score" then
						text = v2:Score() or 0
					elseif v3 == "            Role" then
						text = v2:GetNWString( "role" ) or "None"
					elseif v3 == "Ping" then
						text = v2:Ping() or 0
					end
					draw.SimpleText( text, "Exo 2 Small", playerbase:GetWide() - width - ( 45 * ( k3 - 1 ) ) - 48, playerbase:GetTall() / 2, Color( 255, 255, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
					local _width, _height = surface.GetTextSize( v3 )
					width = width + _width
				end
			end

			if v2 != LocalPlayer() and v2:Team() == LocalPlayer():Team() then
				--voice, novoice, voicemuted
				local muteicon = playerbase:Add( "DCheckBox" )
				muteicon:SetPos( 545, 7 )
				muteicon:SetSize( 16, 16 )
				muteicon.DoClick = function()
					if v2:IsMuted() then
						v2:SetMuted( false )
					elseif !v2:IsMuted() then
						v2:SetMuted( true )
					end
				end
				muteicon.Paint = function()
					if v2:IsMuted() then
						surface.SetMaterial( voicemuted )
					elseif v2:IsSpeaking() then
						surface.SetMaterial( voice )
					else
						surface.SetMaterial( novoice )
					end
					surface.SetDrawColor( Color( 255, 255, 255, 255 ) )
					surface.DrawTexturedRect( 0, 0, muteicon:GetSize() )
				end
			end
			
			if v2:Team() == LocalPlayer():Team() then
				dlist:AddItem( playerbase )
			elseif ( LocalPlayer():Team() == 1 and v2:Team() == 2 ) or ( LocalPlayer():Team() == 2 and v2:Team() == 1 ) then
				dlist2:AddItem( playerbase )
			end
		end
	end
end

function GM:ScoreboardShow()
	CreateScoreboard()
end

function GM:ScoreboardHide()
	if not ( myteam and enemyteam ) then
		return 
	end
	myteam:SetVisible( false )
	enemyteam:SetVisible( false )
	switchteams:SetVisible( false )
	--[[if spec then
		spec:SetVisible( false )
	end]]
end