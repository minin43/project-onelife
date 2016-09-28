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

function Menu()
    local CurrentLevel = 0
	local currentTeam = LocalPlayer():Team()
	local TeamColor, FontColor

    if LocalPlayer().CanCustomizeLoadout == false then
        return
    end

	if currentTeam == 0 then --???
		TeamColor = Color( 255, 255, 255 )
		FontColor = Color( 255, 255, 255 )
	elseif currentTeam == 1 then --red
		TeamColor = Color( 100, 15, 15 )
		FontColor = Color( 255, 255, 255 )
	elseif currentTeam == 2 then --blue
		TeamColor = Color( 15, 15, 160 )
		FontColor = Color( 255, 255, 255 )
    elseif currentTeam == 3 then --black/FFA
        TeamColor = Color( 15, 160, 15 )
        FontColor = Color( 0, 0, 0 )
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
		surface.SetDrawColor( 0, 0, 0, 245 )
        surface.DrawRect( 0, 0, main:GetWide(), main:GetTall() )
    end

	local tabs = vgui.Create( "DPanel", main )
	tabs:SetPos( 0, 0 )
	tabs:SetSize( main:GetWide(), 30 )

	--//Can be found in sv_loadoutmenu.lua
	net.Start( "RequestRoles" )
	net.SendToServer()
	net.Receive( "RequestRolesCallback", function()
		roles = net.ReadTable()
	end )
	print( roles )

	--//Can be found in sv_lvlhandler.lua
	net.Start( "RequestLevel" )
	net.SendToServer()
	net.Receive( "RequestLevelCallback", function()
		lvl = net.ReadInt( 8 )
	end )

	for k, v in pairs( roles ) do
		local teamnumber = LocalPlayer():Team()
		
		local rbutton = vgui.Create( "DButton", tabs )
		rbutton:SetSize( tabs:GetWide() / ( #roles + 1 ), tabs:GetTall() )
		rbutton:SetPos( k * ( tabs:GetWide() / ( #roles + 1 ) ) - ( tabs:GetWide() / ( #roles + 1 ) ), 0 )
		rbutton.Paint = function()
			if lvl >= k then
				draw.SimpleText( roles[ k ].teamnumber, "insert_font_here", primariesbutton:GetWide() / 2, primariesbutton:GetTall() / 2, FontColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
				return true --is this needed?
			else
				draw.SimpleText( "Locked", "insert_font_here", primariesbutton:GetWide() / 2, primariesbutton:GetTall() / 2, FontColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		end
		rbutton.DoClick = function()
			LocalPlayer():EmitSound( "buttons/button22.wav" ) --shouldn't this be surface.PlaySound?
			hint:SetVisible( false )
			if lvl >= k then
				tabs:SetActiveTab( role )
			end
		end

		role = vgui.Create( "DPanel", main )
		role:SetSize( main:GetWide(), main:GetTall() - tabs:GetTall() )
		role:SetPos( 0, tabs:GetTall() )
		role.Paint = function()
			
		end
		tabs:AddSheet( "Level", role )
	end

	local spawn = vgui.Create( "DButton", tabs )
	spawn:SetSize( tabs:GetWide() / ( #roles + 1 ), tabs:GetTall() )
	spawn:SetPos( tabs:GetWide() - spawn:GetWide() )
	spawn:SetText( "Redeploy" )
	spawn.DoClick = function()
		main:Close()
	end

	end

	--[[local rbutton1 = vgui.Create( "DButton", tabs )
	rbutton1:SetSize( tabs:GetWide() / 9, tabs:GetTall() )
	rbutton1:SetPos( 0, 0 )
	rbutton1.Paint = function()
		draw.SimpleText( "insert_role_name_here", "insert_font_here", primariesbutton:GetWide() / 2, primariesbutton:GetTall() / 2, FontColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		return true
	end
	rbutton1.DoClick = function()
		choose:SetActiveTab( role1 )
		LocalPlayer():EmitSound( "buttons/button22.wav" )
		--ClearInfo()
		hint:SetVisible( false )
	end
	local rbutton2 = vgui.Create( "DButton", tabs )

	local rbutton3 = vgui.Create( "DButton", tabs )
	local rbutton4 = vgui.Create( "DButton", tabs )
	local rbutton5 = vgui.Create( "DButton", tabs )
	local rbutton6 = vgui.Create( "DButton", tabs )
	local rbutton7 = vgui.Create( "DButton", tabs )
	local rbutton8 = vgui.Create( "DButton", tabs )

	local pages = vgui.Create( "DPropertySheet", main )
	pages:SetPos( 0, tabs:GetTall() )
	pages:SetSize( main:GetWide() , main:GetTall() / 10 )
	pages.Paint = function() end

	local role1 = vgui.Create( "DPanel", pages )

	pages:AddSheet( "Level1", role1 )
	pages:AddSheet( "Level2", role2 )
	pages:AddSheet( "Level3", role3 )
	pages:AddSheet( "Level4", role4 )
	pages:AddSheet( "Level5", role5 )
	pages:AddSheet( "Level6", role6 )
	pages:AddSheet( "Level7", role7 )
	pages:AddSheet( "Level8", role8 )]]

	--[[ --This is option 1 with 1 column and 3 jutting rows, kinda like "|=" but with 1 more row
	--Role and player information column
    local col = vgui.Create( "DPanel", main )
    col:SetPos( 0, 0 )
	col:SetSize( main:GetWide() / 4, main:GetTall() )
    col.Paint = function()
        surface.SetDrawColor( TeamColor )
        surface.DrawOutlinedRect( 0, 0, col:GetWide(), col:GetTall() )
    end

	local spawn = vgui.Create( "DButton", col )
	spawn:SetSize( col:GetWide() - 20, col:GetTall() / 8 )
	spawn:SetPos( 10, col:GetTall() - spawn:GetTall() - 10 )
	spawn:SetText( "Redeploy" )
	spawn.DoClick = function()
		main:Close()
	end

	--Primary weapon list, attachment list, and gun information
	local row1 = vgui.Create( "DPanel", main )
	row1:SetPos( col:GetWide(), 0 )
	row1:SetSize( main:GetWide() - col:GetWide(), main:GetTall() / 3.0 )
    row1.Paint = function()
        surface.SetDrawColor( TeamColor )
        surface.DrawOutlinedRect( 0, 0, row1:GetWide(), row1:GetTall() )
    end

	--Secondary weapon list, attachment list, and gun information
	local row2 = vgui.Create( "DPanel", main )
	row2:SetPos( col:GetWide(), row1:GetTall() )
	row2:SetSize( main:GetWide() - col:GetWide(), main:GetTall() / 3.0 + 2 )
    row2.Paint = function()
        surface.SetDrawColor( TeamColor )
        surface.DrawOutlinedRect( 0, 0, row2:GetWide(), row2:GetTall() )
    end

	--Equipment list and model, nothing else, should I add something else?
	local row3 = vgui.Create( "DPanel", main )
	row3:SetPos( col:GetWide(), row1:GetTall() + row2:GetTall() )
	row3:SetSize( main:GetWide() - col:GetWide(), main:GetTall() / 3.0 )
    row3.Paint = function()
        surface.SetDrawColor( TeamColor )
        surface.DrawOutlinedRect( 0, 0, row3:GetWide(), row3:GetTall() )
    end]]
end

concommand.Add( "pol_menu", Menu )