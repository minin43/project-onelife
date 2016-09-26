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
		TeamColor = Color( 160, 15, 15 )
		FontColor = Color( 255, 255, 255 )
	elseif currentTeam == 2 then --blue
		TeamColor = Color( 15, 15, 160 )
		FontColor = Color( 255, 255, 255 )
    elseif currentTeam == 3 then --black/FFA
        TeamColor = Color( 15, 160, 15 )
        FontColor = Color( 0, 0, 0 )
	end

    main = vgui.Create( "DFrame" )
	main:SetSize( ScrW() - 20, ScrH() - 20 )
	main:SetTitle( "" )
	main:SetVisible( true )
	main:SetDraggable( false )
	main:ShowCloseButton( true )
	main:MakePopup()
	main:Center()
    main.Paint = function()
		Derma_DrawBackgroundBlur( main, CurTime() )
		surface.SetDrawColor( 15, 15, 15, 255 )
        surface.DrawRect( 0, 0, main:GetWide(), main:GetTall() )
    end

    local col = vgui.Create( "DPanel", main )
    local x, y = main:GetPos()
    col:SetPos( x, y )
	col:SetSize( main:GetWide() / 4, main:GetTall() )
    col.Paint = function()
        local x, y = col:GetPos()
        surface.SetDrawColor( TeamColor )
        surface.DrawOutlinedRect( 0, 0, x, y )
    end
end

concommand.Add( "pol_menu", Menu )