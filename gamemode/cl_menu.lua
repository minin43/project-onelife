--[[
    surface.CreateFont( "", {
	font = "",
	size = 0,
	weight = 400
    italic = true
} )
https://wiki.garrysmod.com/page/surface/CreateFont

local bought = Material( "tdm/ic_done_white_24dp.png", "noclamp smooth" )
https://wiki.garrysmod.com/page/Global/Material

]]

surface.CreateFont( "Exo 2 Tab", {
	font = "Exo 2",
	size = 20,
	weight = 500
} )

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

--//The net message can be found in sv_loadoutmenu.lua
function PrecacheModels()
	net.Start( "RequestWeaponModels" )
	net.SendToServer()
	net.Receive( "RequestWeaponModelsCallback", function()
		local m = net.ReadTable()
		for k, v in pairs( m ) do
			util.PrecacheModel( v )
		end
	end )
end

--//The net message can be found in sv_loadoutmenu.lua
local primaries, secondaries, equipment
function GetWeapons()
	net.Start( "RequestWeapons" )
	net.SendToServer()
	net.Receive( "RequestWeaponsCallback", function()
		--Table layouts: { ["name"] = "weapon name", ["class"] = "class name", ["roles"] = { roles by level } }
		local p = net.ReadTable()
		local s = net.ReadTable()
		local e = net.ReadTable()
		primaries = p
		secondaries = s
		equipment = e
		AttemptMenu()
	end )
	return p2, s2, e2
end

--//The net message can be found in sv_loadoutmenu.lua
local roles
function GetRoles()
	net.Start( "RequestRoles" )
	net.SendToServer()
	net.Receive( "RequestRolesCallback", function()
		local r = net.ReadTable()
		roles = r
		AttemptMenu()
	end )
	return roles
end

--//The net message can be found in sv_lvlhandler.lua
local lvl
function GetLevel()
	net.Start( "RequestLevel" )
	net.SendToServer()
	net.Receive( "RequestLevelCallback", function()
		local l = net.ReadInt( 8 ) or 1
		lvl = l
		AttemptMenu()
	end )
	return lvl
end

--//The net message can be found in sv_moneyhandler.lua
local money
function GetMoney()
	net.Start( "RequestMoney" )
	net.SendToServer()
	net.Receive( "RequestMoneyCallback", function()
		local num = tonumber( net.ReadString() )
		money = num
		AttemptMenu()
	end )
	return money
end

--//The net message can be found in sv_attachmenthandler.lua
local boughtattachments, allattachments
function GetAttachData( wep )
	net.Start( "RequestAttachments" )
		net.WriteString( wep )
	net.SendToServer()
	net.Receive( "RequestAttachmentsCallback", function()
		local av = net.ReadTable() --this table is all of the player's bought attachments,  { ["wep_class"] = { ["attachment"] = "attachmenttype" }
		local at = net.ReadTable() --the key is the attachment name, v is a table of the attachment's type and attachment's price
		boughtattachments = av
		allattachments = at
	end )
	return boughtattachments, allattachments
end

function LoadoutMenu()
	--print( "LoadoutMenu called" )
	if LocalPlayer().CanCustomizeLoadout == false then
        return
    end

	primaries, secondaries, equipment = GetWeapons()
	--print( primaries, secondaries, equipment, GetWeapons() )
	roles = GetRoles()
	--print( role )
	lvl = GetLevel()
	--print( lvl )
	money = GetMoney()
	--print( money )
end

function AttemptMenu()
	--print( "menu attempted")
	if !primaries or !roles or !lvl or !money then --[[print( "Menu creation failed" )]] return end
	if main then return	end

	--PrecacheModels()

	local currentTeam = LocalPlayer():Team()
	local TeamColor
	if currentTeam == 0 then --???
		TeamColor = Color( 255, 255, 255 )
	elseif currentTeam == 1 then --red
		TeamColor = Color( 100, 15, 15 )
	elseif currentTeam == 2 then --blue
		TeamColor = Color( 33, 150, 243, 100 )
    elseif currentTeam == 3 then --black/FFA
        TeamColor = Color( 15, 160, 15 )
	end

    main = vgui.Create( "DFrame" )
	main:SetSize( ScrW() - 70, ScrH() - 70 )
	main:SetTitle( "" )
	main:SetVisible( true )
	main:SetDraggable( false )
	main:ShowCloseButton( false )
	main:MakePopup()
	main:Center()
    main.Paint = function()
		Derma_DrawBackgroundBlur( main, CurTime() )
		surface.SetDrawColor( 0, 0, 0, 250 )
        surface.DrawRect( 0, 0, main:GetWide(), main:GetTall() )
    end

	local tabs = vgui.Create( "DPanel", main )
	tabs:SetPos( 0, 0 )
	tabs:SetSize( main:GetWide(), 30 )
	tabs.Paint = function()
        surface.SetDrawColor( TeamColor )
        surface.DrawRect( 0, 0, tabs:GetWide(), tabs:GetTall() )
    end

	local teamnumber = LocalPlayer():Team()
	for k, v in pairs( roles ) do

		local button = vgui.Create( "DButton", tabs )
		button:SetSize( tabs:GetWide() / ( #roles + 1 ), tabs:GetTall() )
		button:SetPos( k * ( tabs:GetWide() / ( #roles + 1 ) ) - ( tabs:GetWide() / ( #roles + 1 ) ), 0 )
		button:SetText( "" )
		button.Paint = function()
			if lvl >= k then
				draw.SimpleText( v[ teamnumber ], "Exo 2 Tab", button:GetWide() / 2, button:GetTall() / 2, FontColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			else
				draw.SimpleText( "Locked", "Exo 2 Tab", button:GetWide() / 2, button:GetTall() / 2, FontColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			end
		end
		button.DoClick = function()
			--print( "button.DoClick called" )
			if lvl >= k then
				DrawSheet( k )
				LocalPlayer():EmitSound( "buttons/button22.wav" ) --shouldn't this be surface.PlaySound?
				--print( "Setting active tab # ", k )
			end
		end

	end

	local spawn = vgui.Create( "DButton", tabs )
	spawn:SetSize( tabs:GetWide() / ( #roles + 1 ), tabs:GetTall() )
	spawn:SetPos( tabs:GetWide() - spawn:GetWide(), 0 )
	spawn:SetText( "Redeploy" )
	spawn.DoClick = function()
		main:Close()
		if main then
			main = nil
			for k, v in pairs( roles ) do
				page[ v[ teamnumber ] ] = nil
			end
		end
	end

end

function DrawSheet( num )
	--print( "DrawSheet function called for tab: ", num )
	local teamnumber = LocalPlayer():Team()
	page = { }
	button = { }
	for k, v in pairs( roles ) do
		if num != k then
			if page[ v[ teamnumber ] ] then
				page[ v[ teamnumber ] ]:Close()
				page[ v[ teamnumber ] ] = nil
			end
			for k2, v2 in pairs( primaries ) do
				if button[ v2[ "name" ] ] then
					--button[ v2[ "name" ] ]:SetText( "" )
					button[ v2[ "name" ] ] = nil
				end
			end
		else
			--print( "Role ", k, " was selected..." )
			--//Here is where most of the screen drawing will be done
			page[ v[ teamnumber ] ] = vgui.Create( "DFrame", main )
			page[ v[ teamnumber ] ]:SetSize( main:GetWide(), main:GetTall() - 30 ) --30 because that's how tall tabs is
			page[ v[ teamnumber ] ]:SetPos( 0, 30 )
			page[ v[ teamnumber ] ]:SetTitle( "" )
			page[ v[ teamnumber ] ]:SetVisible( true )
			page[ v[ teamnumber ] ]:SetDraggable( false )
			page[ v[ teamnumber ] ]:ShowCloseButton( false )
			page[ v[ teamnumber ] ].Paint = function()
				surface.SetDrawColor( 0, 0, 0, 5 )
        		surface.DrawRect( 0, 0, main:GetWide(), main:GetTall() - 30 )
    		end

			--//Primaries row//--
			local primariesscrollpanel = vgui.Create( "DScrollPanel", page[ v[ teamnumber ] ] )
			primariesscrollpanel:SetSize( page[ v[ teamnumber ] ]:GetWide() / 6 , page[ v[ teamnumber ] ]:GetTall() / 3 )
			primariesscrollpanel:SetPos( 0, 0 )

			local availableprimaries = { }
			for k2, v2 in pairs( primaries ) do
				if table.HasValue( v2[ "roles" ], k ) then
					table.insert( availableprimaries, k2, v2 )
				end
			end

			for k2, v2 in pairs( availableprimaries ) do
				button[ v2[ "name" ] ] = vgui.Create( "DButton", primariesscrollpanel )
				button[ v2[ "name" ] ]:SetPos( 0, 35 * ( k2 - 1 ) )
				button[ v2[ "name" ] ]:SetSize( primariesscrollpanel:GetWide(), 35 )
				button[ v2[ "name" ] ]:SetText( "" )
				button[ v2[ "name" ] ].Paint = function()
					if !primariesscrollpanel then return end
					draw.SimpleText( v2["name"], "Exo 2 Tab", primariesscrollpanel:GetWide() / 2, 35 / 2, Color( 100, 100, 100 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
				end
				button[ v2[ "name" ] ].DoClick = function()
					print( "button.DoClick called for primary weapons list for ", v2[ "name" ] )
					LocalPlayer():EmitSound( "buttons/button22.wav" ) --shouldn't this be surface.PlaySound?
					selectedprimary = v2["class"]
				end
			end

			local primarymodelpanel = vgui.Create( "DPanel", page[ v[ teamnumber ] ] )
			primarymodelpanel:SetPos( page[ v[ teamnumber ] ]:GetWide() / 3, 0 )
			primarymodelpanel:SetSize( page[ v[ teamnumber ] ]:GetWide() / 3 , page[ v[ teamnumber ] ]:GetTall() / 3 )
			primarymodelpanel.Paint = function()
				if !page[ v[ teamnumber ] ] then return end
				surface.SetDrawColor( 255, 0, 0 )
        		surface.DrawRect( 0, 0, primarymodelpanel:GetWide(), primarymodelpanel:GetTall() )
			end

			local primarymodel = vgui.Create( "DModelPanel", primarymodelpanel )
			--primarymodel:SetModel( "insert model directory here" )

			--//Secondaries row//--
			local secondarymodelpanel = vgui.Create( "DPanel", page[ v[ teamnumber ] ] )
			secondarymodelpanel:SetPos( page[ v[ teamnumber ] ]:GetWide() / 3, page[ v[ teamnumber ] ]:GetTall() / 3 )
			secondarymodelpanel:SetSize( page[ v[ teamnumber ] ]:GetWide() / 3 , page[ v[ teamnumber ] ]:GetTall() / 3 )
			secondarymodelpanel.Paint = function()
				if !page[ v[ teamnumber ] ] then return end
				surface.SetDrawColor( 255, 255, 0 )
        		surface.DrawRect( 0, 0, secondarymodelpanel:GetWide(), secondarymodelpanel:GetTall() )
			end

			local secondaryymodel = vgui.Create( "DModelPanel", secondarymodelpanel )
			--secondaryymodel:SetModel( "insert model directory here" )

			local information = vgui.Create( "DPanel", page[ v[ teamnumber ] ] )
			information:SetSize( page[ v[ teamnumber ] ]:GetWide() / 3, page[ v[ teamnumber ] ]:GetTall() / 3 )
			information:SetPos( page[ v[ teamnumber ] ]:GetWide() - ( page[ v[ teamnumber ] ]:GetWide() / 3 ), page[ v[ teamnumber ] ]:GetTall() - ( page[ v[ teamnumber ] ]:GetTall() / 3) )
			information.Paint = function()
				if !page[ v[ teamnumber ] ] then return end
				surface.SetDrawColor( 255, 255, 255 )
        		surface.DrawRect( 0, 0, information:GetWide(), information:GetTall() )
				draw.SimpleText( v[ 4 ], "Exo 2 Tab", 0, 0, Color( 50, 50, 50 ) ) --I need to look at all the different ways I can draw text, this way is shitty
				--print( v[ 4 ] )
			end
		end
	end
end

concommand.Add( "pol_menu", LoadoutMenu )