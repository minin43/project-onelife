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

surface.CreateFont( "Exo 2 Regular", {
	font = "Exo 2",
	size = 20,
	weight = 500
} )

surface.CreateFont( "Exo 2 Large", {
	font = "Exo 2",
	size = 30,
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
	if LocalPlayer().CanCustomizeLoadout == false then
        return
    end

	primaries, secondaries, equipment = GetWeapons()
	roles = GetRoles()
	lvl = GetLevel()
	money = GetMoney()
end

--This code is in a seperate function to server as a buffer for receiving net messages. 
--Might be able to circumvent by making the sv_loadoutmenu a shared file and only keeping lvl and money
function AttemptMenu()
	if !primaries or !roles or !lvl or !money then return end
	if main then return	end

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

	PrecacheModels()

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
				draw.SimpleText( v[ teamnumber ], "Exo 2 Regular", button:GetWide() / 2, button:GetTall() / 2, FontColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			else
				draw.SimpleText( "Locked", "Exo 2 Regular", button:GetWide() / 2, button:GetTall() / 2, FontColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			end
		end
		button.DoClick = function()
			--print( "button.DoClick called" )
			if lvl >= k and currentsheet != k then
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

--This code is in a seperate function to keep things looking cleaner 
--and not having all of the sheets being created inside an OnClick function
local currentsheet = nil
function DrawSheet( num )

	if currentsheet and currentsheet:IsValid() then
		--print( currentsheet )
		currentsheet:Close()
		currentsheet = nil
	end

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

	local teamnumber = LocalPlayer():Team()
	local availableprimaries = { }
	local availablesecondaries = { }
	local availableequipment = { }
	local attachmentlists = { }
	local selectedprimary, selectedsecondary, selectedequipment
	page = { }
	button = { }
	for k, v in pairs( roles ) do
		if num == k then
			--//Here is where most of the screen drawing will be done
			page[ v[ teamnumber ] ] = vgui.Create( "DFrame", main )
			currentsheet = page[ v[ teamnumber ] ]
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


			--//This is the initial panel
			local primariesscrollpanel = vgui.Create( "DScrollPanel", page[ v[ teamnumber ] ] )
			primariesscrollpanel:SetSize( page[ v[ teamnumber ] ]:GetWide() / 3 , page[ v[ teamnumber ] ]:GetTall() / 3 )
			primariesscrollpanel:SetPos( 0, 0 )
			primariesscrollpanel.Paint = function()
				draw.SimpleText( "Primaries", "Exo 2 Large", primariesscrollpanel:GetWide() / 2, 35 / 2, Color( 150, 150, 150 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
				surface.SetDrawColor( TeamColor )
        		surface.DrawOutlinedRect( 0, 0, primariesscrollpanel:GetWide(), 35 )
			end

			table.Empty( availableprimaries )
			for k2, v2 in pairs( primaries ) do
				if table.HasValue( v2[ "roles" ], k ) then
					table.insert( availableprimaries, v2 )
				end
			end

			--//This is all the buttons that get created
			for k2, v2 in pairs( availableprimaries ) do
				button[ v2[ "name" ] ] = vgui.Create( "DButton", primariesscrollpanel )
				button[ v2[ "name" ] ]:SetPos( 0, 35 * ( k2 - 1 ) + 35 )
				button[ v2[ "name" ] ]:SetSize( primariesscrollpanel:GetWide(), 45 )
				button[ v2[ "name" ] ]:SetText( "" )
				button[ v2[ "name" ] ].Paint = function()
					if !primariesscrollpanel then return end
					draw.SimpleText( v2["name"], "Exo 2 Regular", primariesscrollpanel:GetWide() / 2, 35 / 2, Color( 100, 100, 100 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
				end
				button[ v2[ "name" ] ].Think = function()
					if selectedprimary == v2[ "class" ] then --It works, I just have to get the outlining done right. Or maybe a highlight?
						surface.SetDrawColor( TeamColor )
        				surface.DrawOutlinedRect( 0, 35 * ( k2 - 1 ), primariesscrollpanel:GetWide(), 35 )
					end
				end
				button[ v2[ "name" ] ].DoClick = function()
					LocalPlayer():EmitSound( "buttons/button22.wav" ) --shouldn't this be surface.PlaySound?
					selectedprimary = v2["class"]
					--[[net.Start( "RequestAttachments" )
						net.WriteString( selectedprimary )
					net.SendToServer()
					if attachmentlists then
						print( "attachmentlists is valid, emptying table..." ) --this isn't working as intended
						for k3, v3 in pairs( attachmentlists ) do
							v3:CloseMenu()
						end
						table.Empty( attachmentlists )
					end]]
				end
			end

			--[[net.Receive( "RequestAttachmentsCallback", function()
				local ba = net.ReadTable()
				boughtattachments = ba
				local alllength = table.Count( wep_att[ selectedprimary ] )
				local counter = 0
				local attachmentnames = {
					[ "kk_ins2_kobra" ] = "Kobra",
					[ "kk_ins2_eotech" ] = "Eotech",
					[ "kk_ins2_aimpoint" ] = "Aimpoint",
					[ "kk_ins2_elcan" ] = "Elcan",
					[ "" ] = "",
					[ "" ] = "",
					[ "" ] = "",
					[ "" ] = "",
					[ "" ] = "",
					[ "" ] = "",
					[ "" ] = "",
					[ "" ] = "",
					[ "" ] = "",
					[ "" ] = "",
					[ "" ] = "",
					[ "" ] = "",
					[ "" ] = "",
					[ "" ] = "",
					[ "" ] = "",
					[ "" ] = ""
				}
				--table.Empty( attachmentlists )

				for k2, v2 in pairs( wep_att[ selectedprimary ] ) do
					if !attachmentlists[ v2[ 1 ] ] then
						counter = counter + 1
						attachmentlists[ v2[ 1 ] ] = vgui.Create( "DComboBox", page[ v[ teamnumber ] ] )
						attachmentlists[ v2[ 1 ] ]:SetSize( page[ v[ teamnumber ] ]:GetWide() / 6 , page[ v[ teamnumber ] ]:GetTall() / ( 3 * alllength ) )
						attachmentlists[ v2[ 1 ] ]:SetPos( primariesscrollpanel:GetWide(), ( attachmentlists[ v2[ 1 ] ]:GetTall() * counter ) + 2 )
						attachmentlists[ v2[ 1 ] ]:Clear()
						attachmentlists[ v2[ 1 ] ]:SetValue( v2[ 1 ] )
						attachmentlists[ v2[ 1 ] ]:AddChoice( k2 )
					else
						attachmentlists[ v2[ 1 ] ]:AddChoice( k2 )
					end
				end
			end )]]

			--//This is the 3d model backdrop to be used by the 3d model for referencing
			local primarymodelpanel = vgui.Create( "DPanel", page[ v[ teamnumber ] ] )
			primarymodelpanel:SetPos( page[ v[ teamnumber ] ]:GetWide() / 3, 0 )
			primarymodelpanel:SetSize( page[ v[ teamnumber ] ]:GetWide() / 3 , page[ v[ teamnumber ] ]:GetTall() / 3 )
			primarymodelpanel.Paint = function()
				if !page[ v[ teamnumber ] ] then return end
				surface.SetDrawColor( TeamColor )
        		surface.DrawOutlinedRect( 0, 0, primarymodelpanel:GetWide(), primarymodelpanel:GetTall() )
			end

			local primarymodel = vgui.Create( "DModelPanel", primarymodelpanel )
			primarymodel:SetSize( primarymodelpanel:GetWide(), primarymodelpanel:GetTall() )
			primarymodel:SetCamPos( Vector( -55, 0, 0 ) )
			primarymodel:SetLookAt( Vector( 5, 0, 2 ) )
			primarymodel:SetAmbientLight( Color( 200, 200, 200 ) )
			primarymodel.Think = function()
				if selectedprimary then
					primarymodel:SetModel( weapons.Get( selectedprimary ).WorldModel )
				end
			end

			local customizeprimary = vgui.Create( "DButton", primarymodelpanel )
			customizeprimary:SetSize( primarymodelpanel:GetWide(), primarymodelpanel:GetTall() / 8 )
			customizeprimary:SetPos( 0, primarymodelpanel:GetTall() - customizeprimary:GetTall() )
			customizeprimary:SetText( "Customize Weapon" )
			--[[customizeprimary.Paint = function()
				if !secondariesscrollpanel then return end
					draw.SimpleText( "Customize Weapon", "Exo 2 Regular", customizeprimary:GetWide() / 2, 35 / 2, Color( 100, 100, 100 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
				end]]
			customizeprimary.DoClick = function()
				if !selectedprimary then return end
				LocalPlayer():EmitSound( "buttons/button22.wav" ) --shouldn't this be surface.PlaySound?
				CustomizeWeapon( selectedprimary )
			end

			--[[List of things I can add in: SpeedDeceleration (or weight), clip size, firedelay, recoil, hipspread, aimspread, velocity sensitivity, maxspread, spread per shot, 
			shots (for shotgun - maybe just incorporate into damage?), damage, clumpspread for shotguns, shotgun-specific reload speed on a per shell basis ]]
			local primaryinfopanel = vgui.Create( "DPanel", page[ v[ teamnumber ] ] )
			primaryinfopanel:SetPos( page[ v[ teamnumber ] ]:GetWide() * ( 2 / 3 ), 0 )
			primaryinfopanel:SetSize( page[ v[ teamnumber ] ]:GetWide() / 3 , page[ v[ teamnumber ] ]:GetTall() / 3 )
			primaryinfopanel.Paint = function()

			end
			primaryinfopanel.Think = function()

			end


			--//Secondaries row//--


			local secondariesscrollpanel = vgui.Create( "DScrollPanel", page[ v[ teamnumber ] ] )
			secondariesscrollpanel:SetSize( page[ v[ teamnumber ] ]:GetWide() / 3 , page[ v[ teamnumber ] ]:GetTall() / 3 )
			secondariesscrollpanel:SetPos( 0, page[ v[ teamnumber ] ]:GetTall() / 3 )
			secondariesscrollpanel.Paint = function()
				draw.SimpleText( "Secondaries", "Exo 2 Large", secondariesscrollpanel:GetWide() / 2, 35 / 2, Color( 150, 150, 150 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
				surface.SetDrawColor( TeamColor )
        		surface.DrawOutlinedRect( 0, 0, secondariesscrollpanel:GetWide(), 35 )
			end

			table.Empty( availablesecondaries )
			for k2, v2 in pairs( secondaries ) do
				if table.HasValue( v2[ "roles" ], k ) then
					table.insert( availablesecondaries, v2 )
				end
			end

			for k2, v2 in pairs( availablesecondaries ) do
				button[ v2[ "name" ] ] = vgui.Create( "DButton", secondariesscrollpanel )
				button[ v2[ "name" ] ]:SetPos( 0, 35 * ( k2 - 1 ) + 35 )
				button[ v2[ "name" ] ]:SetSize( secondariesscrollpanel:GetWide(), 35 )
				button[ v2[ "name" ] ]:SetText( "" )
				button[ v2[ "name" ] ].Paint = function()
					if !secondariesscrollpanel then return end
					draw.SimpleText( v2["name"], "Exo 2 Regular", secondariesscrollpanel:GetWide() / 2, 35 / 2, Color( 100, 100, 100 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
				end
				button[ v2[ "name" ] ].DoClick = function()
					LocalPlayer():EmitSound( "buttons/button22.wav" ) --shouldn't this be surface.PlaySound?
					selectedsecondary = v2["class"]
				end
			end

			local secondarymodelpanel = vgui.Create( "DPanel", page[ v[ teamnumber ] ] )
			secondarymodelpanel:SetPos( page[ v[ teamnumber ] ]:GetWide() / 3, page[ v[ teamnumber ] ]:GetTall() / 3 )
			secondarymodelpanel:SetSize( page[ v[ teamnumber ] ]:GetWide() / 3 , page[ v[ teamnumber ] ]:GetTall() / 3 )
			secondarymodelpanel.Paint = function()
				if !page[ v[ teamnumber ] ] then return end
				--surface.SetDrawColor( 0, 0, 0 )
        		--surface.DrawRect( 0, 0, primarymodelpanel:GetWide(), primarymodelpanel:GetTall() )
				surface.SetDrawColor( TeamColor )
        		surface.DrawOutlinedRect( 0, 0, secondarymodelpanel:GetWide(), secondarymodelpanel:GetTall() )
			end

			local secondarymodel = vgui.Create( "DModelPanel", secondarymodelpanel )
			secondarymodel:SetSize( secondarymodelpanel:GetWide(), secondarymodelpanel:GetTall() )
			secondarymodel:SetCamPos( Vector( -55, 0, 0 ) )
			secondarymodel:SetLookAt( Vector( 5, 0, 2 ) )
			secondarymodel:SetAmbientLight( Color( 200, 200, 200 ) )
			secondarymodel.Think = function()
				if selectedsecondary then
					secondarymodel:SetModel( weapons.Get( selectedsecondary ).WorldModel )
				end
			end

			local customizesecondary = vgui.Create( "DButton", secondarymodelpanel )
			customizesecondary:SetSize( secondarymodelpanel:GetWide(), secondarymodelpanel:GetTall() / 8 )
			customizesecondary:SetPos( 0, secondarymodelpanel:GetTall() - customizesecondary:GetTall() )
			customizesecondary:SetText( "Customize Weapon" )
			--[[customizesecondary.Paint = function()
				if !secondariesscrollpanel then return end
					draw.SimpleText( "Customize Weapon", "Exo 2 Regular", customizesecondary:GetWide() / 2, 35 / 2, Color( 100, 100, 100 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
				end]]
			customizesecondary.DoClick = function()
				if !selectedsecondary then return end
				LocalPlayer():EmitSound( "buttons/button22.wav" ) --shouldn't this be surface.PlaySound?
				CustomizeWeapon( selectedsecondary )
			end
			customizesecondary.Think = function()
				if !selectedsecondary then
					surface.SetDrawColor( Color( 200, 200, 200 ) )
        			surface.DrawRect( 0, secondarymodelpanel:GetTall() - customizesecondary:GetTall(), secondarymodelpanel:GetWide(), customizesecondary:GetTall() )
				end
			end


			--//Equipment row


			local equipmentscrollpanel = vgui.Create( "DScrollPanel", page[ v[ teamnumber ] ] )
			equipmentscrollpanel:SetSize( page[ v[ teamnumber ] ]:GetWide() / 3 , page[ v[ teamnumber ] ]:GetTall() / 3 )
			equipmentscrollpanel:SetPos( 0, page[ v[ teamnumber ] ]:GetTall() * ( 2 / 3 ) )
			equipmentscrollpanel.Paint = function()
				draw.SimpleText( "Equipment", "Exo 2 Large", equipmentscrollpanel:GetWide() / 2, 35 / 2, Color( 150, 150, 150 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
				surface.SetDrawColor( TeamColor )
        		surface.DrawOutlinedRect( 0, 0, equipmentscrollpanel:GetWide(), 35 )
			end

			table.Empty( availableequipment )
			for k2, v2 in pairs( equipment ) do
				if table.HasValue( v2[ "roles" ], k ) then
					table.insert( availableequipment, v2 )
				end
			end

			for k2, v2 in pairs( availableequipment ) do
				button[ v2[ "name" ] ] = vgui.Create( "DButton", equipmentscrollpanel )
				button[ v2[ "name" ] ]:SetPos( 0, 35 * ( k2 - 1 ) + 35 )
				button[ v2[ "name" ] ]:SetSize( equipmentscrollpanel:GetWide(), 35 )
				button[ v2[ "name" ] ]:SetText( "" )
				button[ v2[ "name" ] ].Paint = function()
					if !equipmentscrollpanel then return end
					draw.SimpleText( v2["name"], "Exo 2 Regular", equipmentscrollpanel:GetWide() / 2, 35 / 2, Color( 100, 100, 100 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
				end
				button[ v2[ "name" ] ].DoClick = function()
					LocalPlayer():EmitSound( "buttons/button22.wav" ) --shouldn't this be surface.PlaySound?
					selectedequipment = v2["class"]
				end
			end


			--//The information section, for shit like money and stuff


			local information = vgui.Create( "DPanel", page[ v[ teamnumber ] ] )
			information:SetSize( page[ v[ teamnumber ] ]:GetWide() * ( 2 / 3 ), page[ v[ teamnumber ] ]:GetTall() / 3 )
			information:SetPos( page[ v[ teamnumber ] ]:GetWide() / 3, page[ v[ teamnumber ] ]:GetTall() - ( page[ v[ teamnumber ] ]:GetTall() / 3) )
			information.Paint = function()
				if !page[ v[ teamnumber ] ] then return end
				surface.SetDrawColor( 255, 255, 255 )
        		surface.DrawRect( 0, 0, information:GetWide(), information:GetTall() )
				draw.SimpleText( v[ 4 ], "Exo 2 Regular", 0, 0, Color( 50, 50, 50 ) ) --I need to look at all the different ways I can draw text, this way is shitty
			end
		end
	end
end

--This is the menu that opens when you press the "customize weapon" button
function CustomizeWeapon( wep )
	main:SetDisabled( true )
	for k, v in pairs( main:GetChildren() ) do
		v:SetDisabled( true )
	end

	customizemain = vgui.Create( "DFrame" )
	customizemain:SetSize( ScrW() / 21, ScrH() / 9 ) --Consider adjusting
	customizemain:SetTitle( "" )
	customizemain:SetVisible( true )
	customizemain:SetDraggable( false )
	customizemain:ShowCloseButton( false )
	customizemain:MakePopup()
	customizemain:Center()
	customizemain.Paint = function()
		surface.SetDrawColor( Color( 0, 0, 0, 250 ) )
		surface.DrawRect( 0, 0, customizemain:GetWide(), customizemain:GetTall() )
	end

	allatachmenttypes = { }
	typekeys = { "Sight" = 1, "Barrel" = 2, "Under" = 3, "Lasers" = 4, "Magazine" = 5, "Flavor" = 6, "Ammo" = 7 }
	--table.SortByMember( wep_att[ wep ], wep_att[ wep ].4
	for k, v in pairs( wep_att[ wep ] ) do
		if !table.HasValue( allatachmenttypes, v[ 1 ] ) then
			table.insert( allatachmenttypes, typekeys.v[ 1 ], v[ 1 ] )
		end
	end
	table.ClearKeys( allatachmenttypes )
	print( "Printing all attachment types table:" )
	PrintTable( allatachmenttypes )

	local tabs = vgui.Create( "DPanel", customizemain )
	tabs:SetPos( 0, 0 )
	tabs:SetSize( main:GetWide() - 100, 30 )
	tabs.Paint = function()
        surface.SetDrawColor( TeamColor )
        surface.DrawRect( 0, 0, tabs:GetWide(), tabs:GetTall() )
    end

	--//Oh shit I'm doing this wrong
	for k, v in pairs( allatachmenttypes ) do
		local button = vgui.Create( "Dbutton", tabs )
		button:SetSize( tabs:GetWide() / ( #allatachmenttypes ), tabs:GetTall() )
		button:SetPos( k * ( tabs:GetWide() / ( #allatachmenttypes ) ) - ( tabs:GetWide() / ( #allatachmenttypes ) ), 0 )
		button:SetText( "" )
		button.Paint = function()
			draw.SimpleText( v, "Exo 2 Regular", button:GetWide() / 2, button:GetTall() / 2, FontColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		end
		button.DoClick = function()
			--print( "button.DoClick called" )
			if lvl >= k and currentsheet != k then
				DrawSheet( k )
				LocalPlayer():EmitSound( "buttons/button22.wav" ) --shouldn't this be surface.PlaySound?
				--print( "Setting active tab # ", k )
			end
		end
	end


	--[[
	-Do like TDM and have columns of attachments (instead of weapons) with the right hand side showing the model and a short description
	-Left hand side is a giant picture of the weapon with blank attachment icons at the bottom, one for each available type,
	right hand side is attachment information and clicking on a blank icon brings up a list of all the attachments above the icon
	-Rip off Insurgency's customization, with all the lists on one, non-rotating, giant weapon model? This might be perfect for
	dynamic worldmodel changing
	]]

	--Close function:
	main:SetDisabled( false )
	for k, v in pairs( main:GetChildren() ) do
		v:SetDisabled( false )
	end
end

concommand.Add( "pol_menu", LoadoutMenu )