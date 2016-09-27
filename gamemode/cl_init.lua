include( "shared.lua" )
include( "hud.lua" )
include( "cl_scoreboard.lua" )
include( "cl_lvl.lua" )
include( "cl_menu.lua" )
include( "cl_money.lua" )
include( "cl_flags.lua" )
include( "cl_feed.lua" )
include( "cl_customspawns.lua" )
include( "cl_leaderboards.lua" )

net.Receive( "SetMagician", function()
	local bool = net.ReadBool()
	local wep = net.ReadEntity()
	local num = net.ReadInt( 32 )
	local tbl = {}
	
	if bool and tbl[num] == nil then
		wep["ReloadSpeed"] = ( wep["ReloadSpeed"] * 1.5 )
		tbl[num] = wep
	elseif !bool and tbl[num] == wep then
		savedwep["ReloadSpeed"] = ( savedwep["ReloadSpeed"] / 1.5 )
	end
end)