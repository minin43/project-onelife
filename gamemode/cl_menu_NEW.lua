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

hook.Add("InitPostEntity", "PrecacheWeaponModelsToPreventInitialMenuOpeningLag", function()
    for k, v in pairs(weapons.GetList()) do
		util.PrecacheModel( v.WorldModel )
	end
end)

function GM:LoadoutMenu()

    if self.Main then return end

    if not self.playerLevel then
        net.Start( "RequestLevel" )
		net.SendToServer()
		net.Receive( "RequestLevelCallback", function( len, ply )
			self.playerLevel = tonumber( net.ReadString() )
		end )
    end
    if not self.playerMoney then
        net.Start( "RequestMoney" )
		net.SendToServer()
		net.Receive( "RequestMoneyCallback", function()
			self.playerMoney = tonumber( net.ReadString() )
		end )
    end

end