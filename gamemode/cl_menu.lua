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
	size = 10,
	weight = 500
} )

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
	for k, v in pairs( GetModels() ) do
		util.PrecacheModel( v )
	end
end

--[[//The net message can be found in sv_loadoutmenu.lua
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
end]]

--[[//The net message can be found in sv_loadoutmenu.lua
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
end]]

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

--[[//The net message can be found in sv_attachmenthandler.lua
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
end]]

function LoadoutMenu()
	if LocalPlayer().CanCustomizeLoadout == false then --As I figured out, this isn't being used, remember to broadcast a global variable, or something, to stop it instead
        return
    end

	--primaries, secondaries, equipment = GetWeapons()
	--roles = GetRoles()
	lvl = GetLevel()
	money = GetMoney()
end

--This code is in a seperate function to server as a buffer for receiving net messages. 
--Might be able to circumvent by making the sv_loadoutmenu a shared file and only keeping lvl and money
function AttemptMenu()
	if !lvl or !money then return end
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
	--[[main.Think = function()
		if LocalPlayer().CanCustomizeLoadout == false  then
			main:Close()
			main = nil
		end
	end]]

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
			if lvl >= k and currentsheet != k then
				DrawSheet( k )
				surface.PlaySound( "buttons/button22.wav" ) --shouldn't this be surface.PlaySound?
				selectedrole = v[ teamnumber ]
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
		net.Start( "SetLoadout" )
			local loadout = {
				[ "primary" ] = selectedprimary or "",
				[ "secondary" ] = selectedsecondary or "",
				[ "equipment" ] = selectedequipment or "",
				[ "role" ] = selectedrole or ""--,
				--[ "pattachments" ] = primattachments or ""
				--[ "sattachments" ] = secattachments or ""
			}
			net.WriteTable( loadout )
		net.SendToServer()
	end

end

--This code is in a seperate function to keep things looking cleaner 
--and not having all of the sheets being created inside an OnClick function
local currentsheet = nil
function DrawSheet( num )
	selectedprimary = ""
	selectedsecondary = ""
	selectedequipment = ""

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
			for k2, v2 in pairs( primaries[ teamnumber ] ) do
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
					surface.PlaySound( "buttons/button22.wav" ) --shouldn't this be surface.PlaySound?
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
			customizeprimary:SetSize( primarymodelpanel:GetWide(), primarymodelpanel:GetTall() )
			customizeprimary:SetPos( 0, 0 )
			customizeprimary:SetText( "" )
			customizeprimary.Paint = function()
				if !secondariesscrollpanel then return end
					draw.SimpleText( "Click to customize weapon", "Exo 2 Small", customizeprimary:GetWide() / 2, customizesecondary:GetTall() - 30, Color( 100, 100, 100 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
				end
			customizeprimary.DoClick = function()
				if !selectedprimary then return end
				surface.PlaySound( "buttons/button22.wav" ) --shouldn't this be surface.PlaySound?
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
				if !selectedprimary then return end
				local wep = weapons.Get( selectedprimary )
				--//Column 1
				local shotgun
				if selectedprimary == "" or selectedprimary == "" then --insert any and all shotgun classnames here
					shotgun = 25
					draw.DrawText( "Pellets: " .. wep.Shots, "Exo 2 Regular", 2, 27, Color( 255, 255, 255 ) )
					draw.DrawText( "Spread: " .. wep.ClumpSpread, "Exo 2 Regular", 2, 102, Color( 255, 255, 255 ) )
				else
					shotgun = 0
					draw.DrawText( "Accuracy: " .. wep.AimSpread, "Exo 2 Regular", 2, 102, Color( 255, 255, 255 ) ) --This is for aimed only, hipfire will always be unknown
				end
				draw.DrawText( "Damage: " .. wep.Damage, "Exo 2 Regular", 2, 2, Color( 255, 255, 255 ) )
				draw.DrawText( "Fire rate: " .. wep.FireDelay, "Exo 2 Regular", 2, 27 + shotgun, Color( 255, 255, 255 ) )
				draw.DrawText( "Recoil: " .. wep.Recoil, "Exo 2 Regular", 2, 52 + shotgun, Color( 255, 255, 255 ) )
				--//Column 2
				draw.DrawText( "Weight: " .. wep.SpeedDec, "Exo 2 Regular", primaryinfopanel / 2 + 2, 2, Color( 255, 255, 255 ) )
				draw.DrawText( "Clip Size: " .. wep.ClipSize, "Exo 2 Regular", primaryinfopanel / 2 + 2, 27, Color( 255, 255, 255 ) )
				draw.DrawText( "Reload Length: " .. ( wep.ReloadSpeed * wep.ReloadTime ), "Exo 2 Regular", primaryinfopanel / 2 + 2, 52, Color( 255, 255, 255 ) )
				draw.DrawText( "Spread Per Shot: " .. wep.SpreadPerShot, "Exo 2 Regular", primaryinfopanel / 2 + 2, 77, Color( 255, 255, 255 ) )
				draw.DrawText( "Maximum Spread: " .. wep.MaxSpreadInc, "Exo 2 Regular", primaryinfopanel / 2 + 2, 102, Color( 255, 255, 255 ) )

			end
			--[[Add breathing to all of the guns?
			--// Aim breathing related \\--
SWEP.AimBreathingEnabled - boolean, if set to true, then when aiming a slight breathing view effect will be applied to the view. DEFAULT IS false
SWEP.AimBreathingIntensity - integer/float, defines the intensity of the breathing camera movement when aiming, 1 is 100%, 1.5 is 150%, etc.; DEFAULT is 1
SWEP.BreathRegenRate - integer/float, the rate at which breath regenerates, default is 0.2
SWEP.BreathDrainRate - integer/float, the rate at which breath drains while holding it, default is 0.1
SWEP.BreathIntensityDrainRate - integer/float, the rate at which the intensity of the breathing view impact decreases while holding breath, default is 1
SWEP.BreathIntensityRegenRate - integer/float, the rate at which the intensity of the breathing view impact increases while not holding breath, default is  2
SWEP.BreathHoldVelocityMinimum - integer/float, if our velocity surpasses this, we can't hold our breath, default is 30
SWEP.BreathDelay - integer/float, delay in between breath hold phases, default is 0.8
SWEP.BreathRegenDelay - integer/float, delay until breath starts regenerating, default is 0.5
SWEP.MinimumBreathPercentage - integer/float, we can only hold our breath if our breath meter surpasses this (in percentage), default is 0.5]]


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
				end
				button[ v2[ "name" ] ].DoClick = function()
					surface.PlaySound( "buttons/button22.wav" ) --shouldn't this be surface.PlaySound?
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
			customizesecondary:SetSize( secondarymodelpanel:GetWide(), secondarymodelpanel:GetTall() )
			customizesecondary:SetPos( 0, 0 )
			customizesecondary:SetText( "" )
			customizesecondary.Paint = function()
				if !secondariesscrollpanel then return end
					draw.SimpleText( "Click to customize weapon", "Exo 2 Regular", customizesecondary:GetWide() / 2, customizesecondary:GetTall() - 30, Color( 100, 100, 100 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
				end
			customizesecondary.DoClick = function()
				if !selectedsecondary then return end
				surface.PlaySound( "buttons/button22.wav" ) --shouldn't this be surface.PlaySound?
				CustomizeWeapon( selectedsecondary )
			end
			customizesecondary.Think = function()
				if !selectedsecondary then
					surface.SetDrawColor( Color( 200, 200, 200 ) )
        			surface.DrawRect( 0, secondarymodelpanel:GetTall() - customizesecondary:GetTall(), secondarymodelpanel:GetWide(), customizesecondary:GetTall() )
				end
			end

			local secondaryinfopanel = vgui.Create( "DPanel", page[ v[ teamnumber ] ] )
			secondaryinfopanel:SetPos( page[ v[ teamnumber ] ]:GetWide() * ( 2 / 3 ), 0 )
			secondaryinfopanel:SetSize( page[ v[ teamnumber ] ]:GetWide() / 3 , page[ v[ teamnumber ] ]:GetTall() / 3 )
			secondaryinfopanel.Paint = function()

			end
			secondaryinfopanel.Think = function()
				if !selectedsecondary then return end
				local wep = weapons.Get( selectedsecondary )
				--//Column 1
				draw.DrawText( "Damage: " .. wep.Damage, "Exo 2 Regular", 2, 2, Color( 255, 255, 255 ) )
				draw.DrawText( "Fire rate: " .. wep.FireDelay, "Exo 2 Regular", 2, 27, Color( 255, 255, 255 ) )
				draw.DrawText( "Recoil: " .. wep.Recoil, "Exo 2 Regular", 2, 52, Color( 255, 255, 255 ) )
				draw.DrawText( "Accuracy: " .. wep.AimSpread, "Exo 2 Regular", 2, 77, Color( 255, 255, 255 ) ) --This is for aimed only, hipfire will always be unknown
				--//Column 2
				draw.DrawText( "Weight: " .. wep.SpeedDec, "Exo 2 Regular", secondaryinfopanel / 2 + 2, 2, Color( 255, 255, 255 ) )
				draw.DrawText( "Clip Size: " .. wep.ClipSize, "Exo 2 Regular", secondaryinfopanel / 2 + 2, 27, Color( 255, 255, 255 ) )
				draw.DrawText( "Reload Length: " .. ( wep.ReloadSpeed * wep.ReloadTime ), "Exo 2 Regular", secondaryinfopanel / 2 + 2, 52, Color( 255, 255, 255 ) )
				draw.DrawText( "Spread Per Shot: " .. wep.SpreadPerShot, "Exo 2 Regular", secondaryinfopanel / 2 + 2, 77, Color( 255, 255, 255 ) )
				draw.DrawText( "Maximum Spread: " .. wep.MaxSpreadInc, "Exo 2 Regular", secondaryinfopanel / 2 + 2, 102, Color( 255, 255, 255 ) )

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
				end
				button[ v2[ "name" ] ].DoClick = function()
					surface.PlaySound( "buttons/button22.wav" ) --shouldn't this be surface.PlaySound?
					selectedequipment = v2["class"]
				end
			end


			--//The information section, for shit like money and stuff, right next to the equipment list
			--//Maybe include a running character holding the selected weapons in between the equipment list and role info?


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

	local modelpanel = vgui.Create( "DPanel", customizemain )
		modelpanel:SetPos( customizemain:GetWide() / 3, customizemain:GetTall() / 3 )
		modelpanel:SetSize( customizemain:GetWide() / 3 , customizemain:GetTall() / 3 )
		modelpanel.Paint = function()
			if !customizemain then return end
			--surface.SetDrawColor( 0, 0, 0 )
       		--surface.DrawRect( 0, 0, primarymodelpanel:GetWide(), primarymodelpanel:GetTall() )
			surface.SetDrawColor( TeamColor )
       		surface.DrawOutlinedRect( 0, 0, modelpanel:GetWide(), modelpanel:GetTall() )
		end

		local secondarymodel = vgui.Create( "DModelPanel", modelpanel )
		secondarymodel:SetSize( modelpanel:GetWide(), modelpanel:GetTall() )
		secondarymodel:SetCamPos( Vector( -55, 0, 0 ) )
		secondarymodel:SetLookAt( Vector( 5, 0, 2 ) )
		secondarymodel:SetAmbientLight( Color( 200, 200, 200 ) )
		secondarymodel.Think = function()
			if selectedsecondary then
				secondarymodel:SetModel( weapons.Get( selectedsecondary ).WorldModel )
			end
		end
	end

	attachmenttypes = { "Sight", "Barrel", "Under", "Lasers", "Magazine", "Flavor", "Ammo" }
	for k, v in pairs( attachmenttypes ) do
		local button = vgui.Create( "DButton", customizemain )
		button:SetSize( customizemain:GetWide() / ( #attachmenttypes ), tabs:GetTall() )
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

	for k, v in pairs( wep_att[ wep ] ) do
		if !table.HasValue( allatachmenttypes, v[ 1 ] ) then
			table.insert( allatachmenttypes, typekeys.v[ 1 ], v[ 1 ] )
		end
	end

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
	-Have the weapon model as the majority of the seconadry menu, with a bunch of lists underneath of the attachment types and close button at the bottom
	-Do like TDM and have columns of attachments (instead of weapons) with the right hand side showing the model and a short description
	-Left hand side is a giant picture of the weapon with blank attachment icons at the bottom, one for each available type,
	right hand side is attachment information and clicking on a blank icon brings up a list of all the attachments above the icon
	-Rip off Insurgency's customization, with all the lists on one, non-rotating, giant weapon model? This might be perfect for
	dynamic worldmodel changing, which can be done but IDK if I'm capable
	]]

	--Close function:
	main:SetDisabled( false )
	for k, v in pairs( main:GetChildren() ) do
		v:SetDisabled( false )
	end
end

concommand.Add( "pol_menu", LoadoutMenu )