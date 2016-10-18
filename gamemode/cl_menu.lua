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

surface.CreateFont( "Exo 2 Small", {
	font = "Exo 2",
	size = 15,
	weight = 500
} )

surface.CreateFont( "Exo 2 Regular", {
	font = "Exo 2",
	size = 20,
	weight = 500
} )

surface.CreateFont( "Exo 2 Regular Underlined", {
	font = "Exo 2",
	size = 20,
	weight = 500,
	underline = true
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
	for k, v in pairs( GetModels() ) do
		util.PrecacheModel( v )
	end
end

function LoadoutMenu()
	if GetGlobalBool( "RoundInProgress" ) == true then
        return
    end
	
	if main then return	end

	local teamnumber = LocalPlayer():Team()
	local TeamColor
	if teamnumber == 0 then --???
		TeamColor = Color( 255, 255, 255 )
	elseif teamnumber == 1 then --red
		TeamColor = Color( 100, 15, 15 )
	elseif teamnumber == 2 then --blue
		TeamColor = Color( 33, 150, 243, 100 )
    elseif teamnumber == 3 then --black/FFA
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
	main.Think = function()
		if GetGlobalBool( "RoundInProgress" ) == true then
			main:Close()
			main = nil
		end
	end

	hook.Add( "PlayerButtonDown", function( ply, button )
		if button == "KEY_C" and main:IsValid() then
			main:Close()
			main = nil
		end
	end )

	local tabs = vgui.Create( "DPanel", main )
	tabs:SetPos( 0, 0 )
	tabs:SetSize( main:GetWide(), 30 )
	tabs.Paint = function()
        surface.SetDrawColor( TeamColor )
        surface.DrawRect( 0, 0, tabs:GetWide(), tabs:GetTall() )
    end

	local lvl = 0
	net.Start( "RequestLevel" )
	net.SendToServer()
	net.Receive( "RequestLevelCallback", function( len, ply )
		lvl = tonumber( net.ReadString() )
	end )

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
			if lvl >= k and currentsheet != k then
				DrawSheet( k )
				surface.PlaySound( "buttons/button22.wav" )
				selectedrole = v[ teamnumber ]
			end
		end
	end

	local spawn = vgui.Create( "DButton", tabs )
	spawn:SetSize( tabs:GetWide() / ( #roles + 1 ), tabs:GetTall() )
	spawn:SetPos( tabs:GetWide() - spawn:GetWide(), 0 )
	spawn:SetText( "Redeploy" )
	spawn.DoClick = function()
		surface.PlaySound( "buttons/button22.wav" )
		main:Close()
		if main then
			main = nil
			if !page then return end
			for k, v in pairs( roles ) do
				page[ v[ teamnumber ] ] = nil
			end
		end
		net.Start( "SetLoadout" )
			local loadout = {
				[ "primary" ] = selectedprimary or "",
				[ "secondary" ] = selectedsecondary or "",
				[ "equipment" ] = selectedequipment or "",
				[ "role" ] = selectedrole or "",
				[ "pattachments" ] = pattach or { },
				[ "sattachments" ] = sattach or { }
			}
			print( "Sending server these weapons:" )
			print( loadout[ "primary" ] )
			PrintTable( loadout[ "pattachments" ] )
			print( loadout[ "secondary" ] )
			PrintTable( loadout[ "sattachments" ] )
			print( loadout[ "equipment" ] )
			
			net.WriteTable( loadout )
		net.SendToServer()
	end

end

--This code is in a seperate function to keep things looking cleaner and not having all of the sheets being created inside an OnClick function, because that would look shitty
local currentsheet = nil
function DrawSheet( num )
	selectedprimary = nil
	selectedsecondary = nil
	selectedequipment = nil

	if currentsheet and currentsheet:IsValid() then
		currentsheet:Close()
		currentsheet = nil
	end

	local teamnumber = LocalPlayer():Team()
	local TeamColor
	if teamnumber == 0 then --???
		TeamColor = Color( 255, 255, 255 )
	elseif teamnumber == 1 then --red
		TeamColor = Color( 100, 15, 15 )
	elseif teamnumber == 2 then --blue
		TeamColor = Color( 33, 150, 243, 100 )
    elseif teamnumber == 3 then --black/FFA
        TeamColor = Color( 15, 160, 15 )
	end

	local availableprimaries = { }
	local availablesecondaries = { }
	local availableequipment = { }
	local attachmentlists = { }
	page = { }
	button = { }
	pattach = { }
	sattach = { }
	for k, v in pairs( roles ) do
		if num == k then
			--//Here is where lots of the screen drawing will be done
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

			--Gotta make sure we only get the primary weapons available for the class
			table.Empty( availableprimaries )
			for k2, v2 in pairs( primaries[ teamnumber ] ) do
				if table.HasValue( v2[ "roles" ], k ) then
					table.insert( availableprimaries, v2 )
				end
			end

			--//This is all the primary weapon buttons that get created
			for k2, v2 in pairs( availableprimaries ) do
				button[ v2[ "name" ] ] = vgui.Create( "DButton", primariesscrollpanel )
				button[ v2[ "name" ] ]:SetPos( 0, 35 * ( k2 - 1 ) + 35 )
				button[ v2[ "name" ] ]:SetSize( primariesscrollpanel:GetWide(), 45 )
				button[ v2[ "name" ] ]:SetText( "" )
				button[ v2[ "name" ] ].Paint = function()
					if !primariesscrollpanel then return end
					draw.SimpleText( v2["name"], "Exo 2 Regular", primariesscrollpanel:GetWide() / 2, 35 / 2, Color( 150, 150, 150 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
					if selectedprimary == v2[ "class" ] then
						surface.SetDrawColor( TeamColor )
        				surface.DrawOutlinedRect( 0, 0, button[ v2[ "name" ] ]:GetWide(), button[ v2[ "name" ] ]:GetTall() )
					end 
				end
				button[ v2[ "name" ] ].DoClick = function()
					surface.PlaySound( "buttons/button22.wav" )
					selectedprimary = v2["class"]
				end
			end

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
			primarymodel:SetCamPos( Vector( -45, 0, 0 ) )
			primarymodel:SetLookAt( Vector( 5, 0, 2 ) )
			primarymodel:SetAmbientLight( Color( 200, 200, 200 ) )
			primarymodel.Think = function()
				if selectedprimary then
					primarymodel:SetModel( weapons.Get( selectedprimary ).WorldModel )
				end
			end

			local customizeprimary = vgui.Create( "DButton", primarymodelpanel )
			customizeprimary:SetSize( primarymodelpanel:GetWide(), primarymodelpanel:GetTall() )
			customizeprimary:SetPos( 0, 0 )
			customizeprimary:SetText( "" )
			customizeprimary.Paint = function()
				if !primariesscrollpanel then return end
					draw.SimpleText( "Click to customize weapon", "Exo 2 Regular", customizeprimary:GetWide() / 2, customizeprimary:GetTall() - 30, Color( 100, 100, 100 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
				end
			customizeprimary.DoClick = function()
				if !selectedprimary then return end
				surface.PlaySound( "buttons/button22.wav" )
				CustomizeWeapon( selectedprimary, "primary" )
				pattach = { }
			end

			--//If the panel name is anything to go by, the weapon info on the right hand side of the screen
			local primaryinfopanel = vgui.Create( "DPanel", page[ v[ teamnumber ] ] )
			primaryinfopanel:SetPos( page[ v[ teamnumber ] ]:GetWide() * ( 2 / 3 ) - 1, page[ v[ teamnumber ] ] )
			primaryinfopanel:SetSize( page[ v[ teamnumber ] ]:GetWide() / 3 + 1, page[ v[ teamnumber ] ]:GetTall() / 3 )
			primaryinfopanel.Paint = function()
				if !selectedprimary then return end
				surface.SetDrawColor( TeamColor )
        		surface.DrawOutlinedRect( 0, 0, primaryinfopanel:GetWide(), primaryinfopanel:GetTall() )
				local offset = 50 --offset in the y
				local wep = weapons.Get( selectedprimary )
				--//Title
				surface.SetFont( "Exo 2 Large" )
				local info = "Weapon Information"
				local infowidth, infoheight = surface.GetTextSize( info )
				draw.SimpleText( info, "Exo 2 Large", primaryinfopanel:GetWide() / 2 - ( infowidth / 2 ), 10, Color( 255, 240, 240 ) )
				--//Column 1
				local shotgun
				if selectedprimary == "cw_kk_ins2_toz" or selectedprimary == "cw_kk_ins2_m590" then --insert any and all shotgun classnames here
					shotgun = 25
					draw.SimpleText( "Pellets: " .. math.Round( wep.Shots, 3 ), "Exo 2 Regular", 4, 27 + offset, Color( 255, 255, 255 ) )
					draw.SimpleText( "Spread: " .. math.Round( wep.ClumpSpread, 3 ), "Exo 2 Regular", 4, 102 + offset, Color( 255, 255, 255 ) )
				else
					shotgun = 0
					draw.SimpleText( "Accuracy: " .. math.Round( wep.AimSpread, 3 ), "Exo 2 Regular", 4, 77 + offset, Color( 255, 255, 255 ) ) --This is for aimed only, hipfire will always be unknown
				end
				draw.SimpleText( "Damage: " .. math.Round( wep.Damage, 3 ), "Exo 2 Regular", 4, 2 + offset, Color( 255, 255, 255 ) )
				draw.SimpleText( "Fire rate: " .. math.Round( wep.FireDelay, 3 ), "Exo 2 Regular", 4, 27 + offset + shotgun, Color( 255, 255, 255 ) )
				draw.SimpleText( "Recoil: " .. math.Round( wep.Recoil, 3 ), "Exo 2 Regular", 4, 52 + offset + shotgun, Color( 255, 255, 255 ) )
				--//Column 2
				draw.SimpleText( "Weight: " .. math.Round( wep.SpeedDec, 3 ), "Exo 2 Regular", primaryinfopanel:GetWide() / 2 + 4, 2 + offset, Color( 255, 255, 255 ) )
				draw.SimpleText( "Clip Size: " .. math.Round( wep.Primary.ClipSize, 3 ), "Exo 2 Regular", primaryinfopanel:GetWide() / 2 + 4, 27 + offset, Color( 255, 255, 255 ) )
				draw.SimpleText( "Reload Length (seconds): " --[[.. math.Round( wep.ReloadTime, 3 )]], "Exo 2 Regular", primaryinfopanel:GetWide() / 2 + 4, 52 + offset, Color( 255, 255, 255 ) )
				draw.SimpleText( "Spread Per Shot: " .. math.Round( wep.SpreadPerShot, 3 ), "Exo 2 Regular", primaryinfopanel:GetWide() / 2 + 4, 77 + offset, Color( 255, 255, 255 ) )
				draw.SimpleText( "Maximum Spread: " .. math.Round( wep.MaxSpreadInc, 3 ), "Exo 2 Regular", primaryinfopanel:GetWide() / 2 + 4, 102 + offset, Color( 255, 255, 255 ) )
			end


			--//Secondaries row//--


			local secondariesscrollpanel = vgui.Create( "DScrollPanel", page[ v[ teamnumber ] ] )
			secondariesscrollpanel:SetSize( page[ v[ teamnumber ] ]:GetWide() / 3 , page[ v[ teamnumber ] ]:GetTall() / 3 )
			secondariesscrollpanel:SetPos( 0, page[ v[ teamnumber ] ]:GetTall() / 3 )
			secondariesscrollpanel.Paint = function()
				draw.SimpleText( "Secondaries", "Exo 2 Large", secondariesscrollpanel:GetWide() / 2, 35 / 2, Color( 200, 200, 200 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
				surface.SetDrawColor( TeamColor )
        		surface.DrawOutlinedRect( 0, 0, secondariesscrollpanel:GetWide(), 35 )
			end

			table.Empty( availablesecondaries )
			for k2, v2 in pairs( secondaries[ teamnumber ] ) do
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
					if selectedsecondary == v2[ "class" ] then
						surface.SetDrawColor( TeamColor )
        				surface.DrawOutlinedRect( 0, 0, button[ v2[ "name" ] ]:GetWide(), button[ v2[ "name" ] ]:GetTall() )
					end 
				end
				button[ v2[ "name" ] ].DoClick = function()
					surface.PlaySound( "buttons/button22.wav" )
					selectedsecondary = v2["class"]
				end
			end

			local secondarymodelpanel = vgui.Create( "DPanel", page[ v[ teamnumber ] ] )
			secondarymodelpanel:SetPos( page[ v[ teamnumber ] ]:GetWide() / 3, page[ v[ teamnumber ] ]:GetTall() / 3 )
			secondarymodelpanel:SetSize( page[ v[ teamnumber ] ]:GetWide() / 3 , page[ v[ teamnumber ] ]:GetTall() / 3 )
			secondarymodelpanel.Paint = function()
				if !page[ v[ teamnumber ] ] then return end
				surface.SetDrawColor( TeamColor )
        		surface.DrawOutlinedRect( 0, 0, secondarymodelpanel:GetWide(), secondarymodelpanel:GetTall() )
			end

			local secondarymodel = vgui.Create( "DModelPanel", secondarymodelpanel )
			secondarymodel:SetSize( secondarymodelpanel:GetWide(), secondarymodelpanel:GetTall() )
			secondarymodel:SetCamPos( Vector( -45, 0, 0 ) )
			secondarymodel:SetLookAt( Vector( 5, 0, 2 ) )
			secondarymodel:SetAmbientLight( Color( 200, 200, 200 ) )
			secondarymodel.Think = function()
				if selectedsecondary then
					secondarymodel:SetModel( weapons.Get( selectedsecondary ).WorldModel )
				end
			end

			local customizesecondary = vgui.Create( "DButton", secondarymodelpanel )
			customizesecondary:SetSize( secondarymodelpanel:GetWide(), secondarymodelpanel:GetTall() )
			customizesecondary:SetPos( 0, 0 )
			customizesecondary:SetText( "" )
			customizesecondary.Paint = function()
				if !secondariesscrollpanel then return end
					draw.SimpleText( "Click to customize weapon", "Exo 2 Regular", customizesecondary:GetWide() / 2, customizesecondary:GetTall() - 30, Color( 100, 100, 100 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
				end
			customizesecondary.DoClick = function()
				if !selectedsecondary then return end
				surface.PlaySound( "buttons/button22.wav" )
				CustomizeWeapon( selectedsecondary, "secondary" )
				sattach = { }
			end
			customizesecondary.Think = function()
				if !selectedsecondary then
					surface.SetDrawColor( Color( 200, 200, 200 ) )
        			surface.DrawRect( 0, secondarymodelpanel:GetTall() - customizesecondary:GetTall(), secondarymodelpanel:GetWide(), customizesecondary:GetTall() )
				end
			end

			--//If the panel name is anything to go by, the weapon info on the right hand side of the screen
			local secondaryinfopanel = vgui.Create( "DPanel", page[ v[ teamnumber ] ] )
			secondaryinfopanel:SetPos( page[ v[ teamnumber ] ]:GetWide() * ( 2 / 3 ) - 1, page[ v[ teamnumber ] ]:GetTall() / 3 )
			secondaryinfopanel:SetSize( page[ v[ teamnumber ] ]:GetWide() / 3 + 1, page[ v[ teamnumber ] ]:GetTall() / 3 )
			secondaryinfopanel.Paint = function()
				if !selectedsecondary then return end
				surface.SetDrawColor( TeamColor )
        		surface.DrawOutlinedRect( 0, 0, secondaryinfopanel:GetWide(), secondaryinfopanel:GetTall() )
				local wep = weapons.Get( selectedsecondary )
				local offset = 50 --offset in the y
				--//Title
				surface.SetFont( "Exo 2 Large" )
				local info = "Weapon Information"
				local infowidth, infoheight = surface.GetTextSize( info )
				draw.SimpleText( info, "Exo 2 Large", secondaryinfopanel:GetWide() / 2 - ( infowidth / 2 ), 10, Color( 255, 240, 240 ) )
				--//Column 1
				draw.SimpleText( "Damage: " .. math.Round( wep.Damage, 3 )	, "Exo 2 Regular", 4, 2 + offset, Color( 255, 255, 255 ) )
				draw.SimpleText( "Fire rate: " .. math.Round( wep.FireDelay, 3 ), "Exo 2 Regular", 4, 27 + offset, Color( 255, 255, 255 ) )
				draw.SimpleText( "Recoil: " .. math.Round( wep.Recoil, 3 ), "Exo 2 Regular", 4, 52 + offset, Color( 255, 255, 255 ) )
				draw.SimpleText( "Accuracy: " .. math.Round( wep.AimSpread, 3 ), "Exo 2 Regular", 4, 77 + offset, Color( 255, 255, 255 ) ) --This is for aimed only, hipfire will always be unknown
				--//Column 2
				draw.SimpleText( "Weight: " .. math.Round( wep.SpeedDec, 3 ), "Exo 2 Regular", secondaryinfopanel:GetWide() / 2 + 4, 2 + offset, Color( 255, 255, 255 ) )
				draw.SimpleText( "Clip Size: " .. math.Round( wep.Primary.ClipSize, 3 ), "Exo 2 Regular", secondaryinfopanel:GetWide() / 2 + 4, 27 + offset, Color( 255, 255, 255 ) )
				draw.SimpleText( "Reload Length (seconds): " --[[.. math.Round( wep.ReloadTime, 3 )]], "Exo 2 Regular", secondaryinfopanel:GetWide() / 2 + 4, 52 + offset, Color( 255, 255, 255 ) )
				draw.SimpleText( "Spread Per Shot: " .. math.Round( wep.SpreadPerShot, 3 ), "Exo 2 Regular", secondaryinfopanel:GetWide() / 2 + 4, 77 + offset, Color( 255, 255, 255 ) )
				draw.SimpleText( "Maximum Spread: " .. math.Round( wep.MaxSpreadInc, 3 ), "Exo 2 Regular", secondaryinfopanel:GetWide() / 2 + 2, 102 + offset, Color( 255, 255, 255 ) )
			end


			--//Equipment row


			local equipmentscrollpanel = vgui.Create( "DScrollPanel", page[ v[ teamnumber ] ] )
			equipmentscrollpanel:SetSize( page[ v[ teamnumber ] ]:GetWide() / 3 , page[ v[ teamnumber ] ]:GetTall() / 3 )
			equipmentscrollpanel:SetPos( 0, page[ v[ teamnumber ] ]:GetTall() * ( 2 / 3 ) )
			equipmentscrollpanel.Paint = function()
				draw.SimpleText( "Equipment", "Exo 2 Large", equipmentscrollpanel:GetWide() / 2, 35 / 2, Color( 200, 200, 200 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
				surface.SetDrawColor( TeamColor )
        		surface.DrawOutlinedRect( 0, 0, equipmentscrollpanel:GetWide(), 35 )
			end

			table.Empty( availableequipment )
			for k2, v2 in pairs( equipment[ teamnumber ] ) do
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
					if selectedequipment == v2[ "class" ] then
						surface.SetDrawColor( TeamColor )
        				surface.DrawOutlinedRect( 0, 0, button[ v2[ "name" ] ]:GetWide(), button[ v2[ "name" ] ]:GetTall() )
					end 
				end
				button[ v2[ "name" ] ].DoClick = function()
					surface.PlaySound( "buttons/button22.wav" )
					selectedequipment = v2["class"]
				end
			end


			--//The information section, for shit like level and stuff, right next to the equipment list
			--//Maybe include a running character holding the selected weapons in between the equipment list and role info?

			--local aplayer = ents.Create( LocalPlayer():GetModel() ) or ents.Create( "models/player/group03/male_01.mdl" )
			--aplayer:Spawn()

			local information = vgui.Create( "DPanel", page[ v[ teamnumber ] ] )
			information:SetSize( page[ v[ teamnumber ] ]:GetWide() * ( 2 / 3 ), page[ v[ teamnumber ] ]:GetTall() / 3 )
			information:SetPos( page[ v[ teamnumber ] ]:GetWide() / 3, page[ v[ teamnumber ] ]:GetTall() - ( page[ v[ teamnumber ] ]:GetTall() / 3) )
			information.Paint = function()
				if !page[ v[ teamnumber ] ] then return end
				surface.SetDrawColor( 255, 255, 255 )
        		surface.DrawRect( 0, 0, information:GetWide(), information:GetTall() )
				draw.DrawText( "Role: " .. v[ teamnumber ], "Exo 2 Large", 2, 2, Color( 50, 50, 50 ) ) --I need to look at all the different ways I can draw text, this way is shitty
				draw.DrawText( v[ 4 ], "Exo 2 Regular", 2, 30, Color( 50, 50, 50 ) ) --I need to look at all the different ways I can draw text, this way is shitty
			end
		end
	end
end

--This is the menu that opens when you press the "customize weapon" button, also in a seperate function to keep things looking clean and not having everything inside an OnClick function
function CustomizeWeapon( wep, weptype )


	local teamnumber = LocalPlayer():Team()
	local TeamColor
	if teamnumber == 0 then --???
		TeamColor = Color( 255, 255, 255 )
	elseif teamnumber == 1 then --red
		TeamColor = Color( 100, 15, 15 )
	elseif teamnumber == 2 then --blue
		TeamColor = Color( 33, 150, 243, 100 )
    elseif teamnumber == 3 then --black/FFA
        TeamColor = Color( 15, 160, 15 )
	end

	for k, v in pairs( main:GetChildren() ) do
		if v:GetName() == "DLabel" then
			v:SetDisabled( true )
		elseif v:GetName() == "DPanel" then
			v:SetDisabled( true )
			for k2, v2 in pairs( v:GetChildren() ) do
				v2:SetEnabled( false )
			end
		elseif v:GetName() == "DButton" then --For some reason button wants to be special
			v:SetEnabled( false )
		end
	end

	customizemain = vgui.Create( "DFrame" )
	customizemain:SetSize( 800, 650 ) --Consider adjusting
	customizemain:SetTitle( "" )
	customizemain:SetVisible( true )
	customizemain:SetDraggable( false )
	customizemain:ShowCloseButton( false )
	customizemain:MakePopup()
	customizemain:Center()
	customizemain.Paint = function()
		if !customizemain then return end
		Derma_DrawBackgroundBlur( customizemain, CurTime() )
		surface.SetDrawColor( Color( 0, 0, 0, 250 ) )
		surface.DrawRect( 0, 0, customizemain:GetWide(), customizemain:GetTall() )
	end

	local modelpanel = vgui.Create( "DPanel", customizemain )
	modelpanel:SetPos( 0, 0 )
	modelpanel:SetSize( customizemain:GetWide(), customizemain:GetTall() / 3 )
	modelpanel.Paint = function()
		if !customizemain then return end
		surface.SetDrawColor( TeamColor )
    	surface.DrawOutlinedRect( 0, 0, modelpanel:GetWide(), modelpanel:GetTall() )
	end

	local model = vgui.Create( "DModelPanel", modelpanel )
	model:SetSize( modelpanel:GetWide(), modelpanel:GetTall() )
	model:SetCamPos( Vector( 0, 50, 0 ) )
	model:SetLookAt( Vector( 5, 0, 0 ) )
	model:SetAmbientLight( Color( 200, 200, 200 ) )
	function model:LayoutEntity( Entity ) return end
	model.Think = function()
		if wep then
			model:SetModel( weapons.Get( wep ).WorldModel )
		end
	end

	local attachmenttypes = { "Sight", "Barrel", "Under", "Lasers", "Miscellaneous", "Ammo" }
	local bar = vgui.Create( "DPanel", customizemain )
	bar:SetSize( customizemain:GetWide(), 35 + 1 )
	bar:SetPos( 0, customizemain:GetTall() / 3 - 1 )
	bar.Paint = function()
		if !customizemain then return end
		surface.SetDrawColor( TeamColor )
    	surface.DrawRect( 0, 0, bar:GetWide(), bar:GetTall() )
		for k, v in pairs( attachmenttypes ) do
			draw.SimpleText( v, "Exo 2 Regular", bar:GetWide() / #attachmenttypes * k - ( bar:GetWide() / #attachmenttypes / 2), bar:GetTall() / 2, FontColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		end
	end

	list = { }
	for k, v in pairs( attachmenttypes ) do
		list[ v ] = vgui.Create( "DScrollPanel", customizemain )
		list[ v ]:SetSize( customizemain:GetWide() / #attachmenttypes + 1, customizemain:GetTall() / 3 )
		list[ v ]:SetPos( customizemain:GetWide() / #attachmenttypes * ( k - 1 ), customizemain:GetTall() / 3 )
		list[ v ].Paint = function()
			surface.SetDrawColor( TeamColor )
        	surface.DrawOutlinedRect( 0, 0, list[ v ]:GetWide(), list[ v ]:GetTall() )
		end

		local counter = 0
		selectedattachment = nil
		for k2, v2 in pairs( wep_att[ wep ] ) do
			if v2[ 1 ] == v then
				counter = counter + 1
				local usedtext = CustomizableWeaponry.registeredAttachmentsSKey[ k2 ].displayName
				if #usedtext > 12 then usedtext = CustomizableWeaponry.registeredAttachmentsSKey[ k2 ].displayNameShort end
				local usedcolor = Color( 120, 120, 120)
				
				list[ k2 ] = vgui.Create( "DButton", list[ v ] )
				list[ k2 ]:SetSize( list[ v ]:GetWide(), 22 )
				list[ k2 ]:SetPos( 0, counter * 22 + 20 )
				list[ k2 ]:SetText( "" )
				list[ k2 ].Paint = function()
					if !list[ k2 ] or !list or list[ k2 ] == NULL then return end
					if ( weptype == "primary" and pattach[ v ] == k2 ) or ( weptype == "secondary" and sattach[ v ] == k2 ) then
						surface.SetDrawColor( Color( 0, 80, 0 ) )
        				surface.DrawRect( 0, 0, list[ k2 ]:GetWide(), list[ k2 ]:GetTall() )
					elseif selectedattachment == k2 then
						surface.SetDrawColor( Color( 250, 250, 250 ) )
        				surface.DrawOutlinedRect( 0, 0, list[ k2 ]:GetWide() - 1, list[ k2 ]:GetTall() )
					end
					draw.SimpleText( usedtext, "Exo 2 Regular", list[ k2 ]:GetWide() / 2, list[ k2 ]:GetTall() / 2, usedcolor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
				end
				list[ k2 ].DoClick = function()
					selectedattachment = k2
					selectedattachmenttype = v2[ 1 ]
					surface.PlaySound( "buttons/button22.wav" )
				end
				list[ k2 ].Think = function()
					if wep_att[ wep ][ k2 ][ "unlocked" ] then
						usedcolor = Color( 200, 200, 200 )
					else
						usedcolor = Color( 70, 70, 70 )
					end
				end
			end
		end
	
		--[[local icon = vgui.Create( "SpawnIcon", modelpanel )
		icon:SetSize( 60, 60 )
		if k <= #attachmenttypes / 2 then
			icon:SetPos( 10, ( 30 * k ) + 20 )
		else
			icon:SetPos( modelpanel:GetWide() - 30 - icon:GetWide(), ( 30 * ( k - ( k / 2 ) ) + 20 )
		end
		icon.Think = function()
			if selectedattachment then
				icon:SetModel( selectedattachment )
			--else
				--icon:SetModel( "" ) --icon:SetModel( nil ) or draw a black overlay using Paint
			end
		end]]
	end

	local money = 0
	net.Start( "RequestMoney" )
	net.SendToServer()
	net.Receive( "RequestMoneyCallback", function( len, ply )
		money = tonumber( net.ReadString() )
	end )

	local attachmentdatapanel = vgui.Create( "DPanel", customizemain )
	attachmentdatapanel:SetSize( customizemain:GetWide(), customizemain:GetTall() / 3 + 2 )
	attachmentdatapanel:SetPos( 0, customizemain:GetTall() * ( 2 / 3 ) - 1 )
	attachmentdatapanel.Paint = function()
		if !customizemain then return end
		surface.SetDrawColor( TeamColor )
    	surface.DrawOutlinedRect( 0, 0, attachmentdatapanel:GetWide(), attachmentdatapanel:GetTall() )

		draw.SimpleText( "Cash: $" .. money, "Exo 2 Regular", attachmentdatapanel:GetWide() - 6, 5, Color( 150, 150, 150 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_RIGHT )

		if !selectedattachment then return end
		local attachdescription = ""
		surface.SetFont( "Exo 2 Large" )
		local info = "Description: "
		local infowidth, infoheight = surface.GetTextSize( info )
		for k, v in pairs( CustomizableWeaponry.registeredAttachmentsSKey[ selectedattachment ].description ) do
			draw.SimpleText( v[ "t" ], "Exo 2 Regular", infowidth - 40, 40 + ( 20 * ( k - 1 ) ), Color( v[ "c" ][ "r" ], v[ "c" ][ "g" ], v[ "c" ][ "b" ] ) )
		end
		draw.SimpleText( "Attachment name: " .. CustomizableWeaponry.registeredAttachmentsSKey[ selectedattachment ].displayName, "Exo 2 Large", 6, 5, Color( 150, 150, 150 ) )
		draw.SimpleText( "Description: ", "Exo 2 Regular", 6, 40, Color( 150, 150, 150 ) )
		draw.SimpleText( "Stat modifiers: ", "Exo 2 Regular", attachmentdatapanel:GetWide() / 2 + 6, 40, Color( 200, 200, 200 ) )
		local counter = 0
		for k, v in pairs( CustomizableWeaponry.registeredAttachmentsSKey[ selectedattachment ].statModifiers ) do
			counter = counter + 1
			draw.SimpleText( k .. ":  " .. v, "Exo 2 Regular", attachmentdatapanel:GetWide() / 2 + 121, 40 + ( 20 * ( counter - 1 ) ), Color( 150, 150, 150 ) )
		end
	end

	local buybutton = vgui.Create( "DButton", attachmentdatapanel )
	buybutton:SetSize( attachmentdatapanel:GetWide() / 3, 20 )
	buybutton:SetPos( ( attachmentdatapanel:GetWide() / 2 ) - ( buybutton:GetWide() + 1 ), attachmentdatapanel:GetTall() - buybutton:GetTall() )
	buybutton:SetText( "" )
	buybutton.Paint = function()
		if !selectedattachment or !attachmentdatapanel then return end
		surface.SetDrawColor( TeamColor )
        surface.DrawRect( 0, 0, buybutton:GetWide(), buybutton:GetTall() )
		if wep_att[ wep ][ selectedattachment ][ "unlocked" ] then
			draw.SimpleText( "Attachment is unlocked", "Exo 2 Regular", buybutton:GetWide() / 2, buybutton:GetTall() / 2, Color( 200, 200, 200 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		else
			draw.SimpleText( "Unlock price: " .. wep_att[ wep ][ selectedattachment ][ 2 ], "Exo 2 Regular", buybutton:GetWide() / 2, buybutton:GetTall() / 2, Color( 200, 200, 200 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		end
	end
	buybutton.DoClick = function()
		if wep_att[ wep ][ selectedattachment ][ "unlocked" ] then return end
		if money < wep_att[ wep ][ selectedattachment ][ 2 ] then return end
		surface.PlaySound( "buttons/button22.wav" )
		print( "Buying attachment: ", selectedattachment, " on weapon: ", wep, " for $", wep_att[ wep ][ selectedattachment ][ 2 ] )
		net.Start( "BuyAttachment" )
			net.WriteString( wep )
			net.WriteString( selectedattachment )
			--net.WriteString( wep_att[ wep ][ selectedattachment ][ 1 ] )
			net.WriteString( tostring( wep_att[ wep ][ selectedattachment ][ 2 ] ) )
		net.SendToServer()
		net.Receive( "BuyAttachmentCallback", function( len, ply )
			money = tonumber( net.ReadString() )
		end )
		wep_att[ wep ][ selectedattachment ][ "unlocked" ] = true
	end

	local equipbutton = vgui.Create( "DButton", attachmentdatapanel )
	equipbutton:SetSize( attachmentdatapanel:GetWide() / 3, 20 )
	equipbutton:SetPos( ( attachmentdatapanel:GetWide() / 2 ) + 1, attachmentdatapanel:GetTall() - equipbutton:GetTall() )
	equipbutton:SetText( "" )
	equipbutton.Paint = function()
		if !selectedattachment or !attachmentdatapanel then return end
		surface.SetDrawColor( TeamColor )
        surface.DrawRect( 0, 0, equipbutton:GetWide(), equipbutton:GetTall() )
		if wep_att[ wep ][ selectedattachment ][ "unlocked" ] then
			draw.SimpleText( "Equip Attachment", "Exo 2 Regular", equipbutton:GetWide() / 2, equipbutton:GetTall() / 2, Color( 200, 200, 200 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		else
			draw.SimpleText( "Attachment locked", "Exo 2 Regular", equipbutton:GetWide() / 2, equipbutton:GetTall() / 2, Color( 200, 200, 200 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		end
	end
	equipbutton.Think = function()
		if !selectedattachment or !attachmentdatapanel then return end
		if wep_att[ wep ][ selectedattachment ][ "unlocked" ] then
			equipbutton:SetEnabled( true )
		else
			equipbutton:SetEnabled( false )
		end
	end
	equipbutton.DoClick = function()
		surface.PlaySound( "buttons/button22.wav" )
		for k3, v3 in pairs( primaries[ teamnumber ] ) do
			if v3[ "class" ] == wep then
				pattach[ selectedattachmenttype ] = selectedattachment
				break
			end
		end
		for k3, v3 in pairs( secondaries[ teamnumber ] ) do
			if v3[ "class" ] == wep then
				sattach[ selectedattachmenttype ] = selectedattachment
				break
			end
		end
	end

	--[[		If I want to sort, I'll have to change the format of wep_att[ wep ][ attachment ]
		for k, v in pairs( wep_att[ wep ] ) do
		if !table.HasValue( allatachmenttypes, v[ 1 ] ) then
			table.insert( allatachmenttypes, typekeys.v[ 1 ], v[ 1 ] )
		end
	end]]

	local closebutton = vgui.Create( "DButton", modelpanel )
	closebutton:SetSize( modelpanel:GetWide(), modelpanel:GetTall() )
	closebutton:SetPos( 0, 0 )
	closebutton:SetText( "" )
	closebutton.Paint = function()
		if !customizemain then return end
			draw.SimpleText( weapons.Get( wep ).PrintName, "Exo 2 Regular", closebutton:GetWide() / 2, 30, Color( 100, 100, 100 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			draw.SimpleText( "Click to close weapon customization", "Exo 2 Regular", closebutton:GetWide() / 2, closebutton:GetTall() - 30, Color( 100, 100, 100 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		end
	closebutton.DoClick = function()
		surface.PlaySound( "buttons/button22.wav" )
		customizemain:Close()
		--Close function:
		for k, v in pairs( main:GetChildren() ) do
			if v:GetName() == "DLabel" then
				v:SetDisabled( false )
			elseif v:GetName() == "DPanel" then
				v:SetDisabled( false )
				for k2, v2 in pairs( v:GetChildren() ) do
					v2:SetEnabled( true )
				end
			elseif v:GetName() == "DButton" then --For some reason button wants to be special
				v:SetEnabled( true )
			end
		end
	end
end

concommand.Add( "pol_menu", LoadoutMenu )

hook.Add( "PlayerButtonDown", function( ply, button )
	print( ply, button )
	if button == "KEY_C" and !main:IsValid() then
		print("Client pressed C")
		LoadoutMenu()
	end
end )