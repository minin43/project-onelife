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

local gradient = surface.GetTextureID( "gui/gradient" )
local voice = Material( "sound.png" )
local novoice = Material( "sound_none.png" )
local voicemuted = Material( "sound_mute.png" )

local levelgroups = {
	{ 1, "Private", "materials/ranks/private.png"},
	{ 2, "Private First Class", "materials/ranks/privatefirstclass.png"},
	{ 3, "Corporal", "materials/ranks/corporal.png"},
	{ 4, "Specialist", "materials/ranks/specialist.png"},
	{ 5, "Sergeant", "materials/ranks/sergeant.png"},
	{ 6, "Staff Sergeant", "materials/ranks/staffsergeant.png"},
	{ 7, "Sergeant First Class", "materials/ranks/sergeantfirstclass.png"},
	{ 8, "Master Sergeant", "materials/ranks/mastersergeant.png"},
    --//Here starts ranks that give nothing new
	{ 9, "First Sergeant", "materials/ranks/firstsergeant.png"},
	{ 10, "Sergeant Major", "materials/ranks/sergeantmajor.png"},
	{ 11, "Second Lieutenant", "materials/ranks/secondlieutenant.png"},
	{ 12, "First Lieutenant", "materials/ranks/firstlieutenant.png"},
	{ 13, "Captain", "materials/ranks/captain.png"},
	{ 14, "Major", "materials/ranks/major.png"},
	{ 15, "Lieutenant Colonel", "materials/ranks/lieutenantcolonel.png"},
	{ 16, "Colonel", "materials/ranks/colonel.png"}
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
	[ 2 ] = Color( 33, 150, 243, 100 ),
	[ 3 ] = Color( 15, 160, 15 )
}

--//Order of info, left to right: Level Icon - ULX Icon (if applicable) - Name - Score - Role - Ping - Mute icon| Level Icon - ULX Icon (if applicable) - Name - Ping
--//Only members of your team will show up as alive or dead (dead members will be faded)
--//No K/D/A bullshit because that only promotes toxicity; score only. I can maybe provide a career K/D on the loadout customization screen...
local teamheaders = {
	"Score",
	"Role",
	"Ping"
}

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
		draw.SimpleText( team.GetName( LocalPlayer():Team() ), "Exo 2 Regular", 66, 56 / 2, Color( 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
		local width, height = 0, 0
		for k, v in next, teamheaders do
			draw.SimpleText( v, "Exo 2 Small", myteam:GetWide() - width - ( 29 * ( k - 1 ) ) - 24 - 42, 56 / 2, white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
			local _width, _height = surface.GetTextSize( v )
			width = width + _width
		end
		surface.SetTexture( gradient )
		surface.SetDrawColor( 0, 0, 0, 164 )
		surface.DrawTexturedRectRotated( myteam:GetWide() / 2, 56 + 4, 8, myteam:GetWide(), 270 )
	end

	dlist = vgui.Create( "DPanelList", myteam )
	dlist:SetPos( 1, 56 )
	dlist:SetSize( myteam:GetWide() - 2, myteam:GetTall() - 56 )	
	dlist:EnableVerticalScrollbar( true )
	dlist:SetSpacing( 2 )

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
			draw.SimpleText( team.GetName( enemyteamnumber ), "Exo 2 Regular", 66, 56 / 2, Color( 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
			local width, height = 0, 0
			for k, v in next, enemyheaders do
				draw.SimpleText( v, "Exo 2 Small", enemyteam:GetWide() - width - ( 29 * ( k - 1 ) ) - 24 - 42, 56 / 2, white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
				local _width, _height = surface.GetTextSize( v )
				width = width + _width
			end
			surface.SetTexture( gradient )
			surface.SetDrawColor( 0, 0, 0, 164 )
			surface.DrawTexturedRectRotated( enemyteam:GetWide() / 2, 56 + 4, 8, enemyteam:GetWide(), 270 )
		end
		
		local pos = Vector( enemyteam:GetPos() )
		enemyteam:SetPos( pos.x + 295, pos.y ) --Offsets the frame by a half + 5 pixel buffer
		
		enemyteam.Think = function()
			if input.IsMouseDown( MOUSE_RIGHT ) then
				enemyteam:MakePopup()
				myteam:MakePopup()
			end
		end
		
		dlist2 = vgui.Create( "DPanelList", enemyteam )
		dlist2:SetPos( 1, 56 )
		dlist2:SetSize( enemyteam:GetWide() - 2, enemyteam:GetTall() - 45 )	
		dlist2:EnableVerticalScrollbar( true )
		dlist2:SetSpacing( 2 )
	--end

	for k, v in pairs( team.GetAll() ) do
		for k2, v2 in pairs( team.GetSortedPlayers( v ) ) do
			local playerrow = vgui.Create( "DPanel" )
			playerrow:SetSize( 578, 30 )
			--//Every other panel gets highlighted
			playerrow.Paint = function()
				if k % 2 == 0 then
					surface.SetDrawColor( 0, 0, 0, 64 )
					surface.DrawRect( 0, 0, playerrow:GetSize() )
				end
			end

			--//This sets the color to be used based on the player's ULX group
			local namecolor = Color( 255, 255, 255 )
			local group = v:GetUserGroup()
			for k2, v2 in pairs( colors ) do
				if isstring( k2 ) and group == k2 then
					namecolor = v2
					break
				end
			end

			local levelrank = levelgroups[ 1 ][ 3 ]
			for k2, v2 in pairs( levelgroups ) do
				if tonumber( v:GetNWString( "level" ) ) == v2[ 1 ] then
					levelrank = Material( v2[ 3 ] )
					break
				end
			end

			local ulxrank = "icon16/status_online.png"
			for k2, v2 in pairs( icongroups ) do
				if v:SteamID() == v2[ 1 ] then
					ulxrank = Material( v2[ 3 ] )
					break
				elseif group == v2[ 1 ] then
					ulxrank = Material( v2[ 3 ] )
					break
				end
			end

			--warherb
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
	--[[if spec then
		spec:SetVisible( false )
	end]]
end