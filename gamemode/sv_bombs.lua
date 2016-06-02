bombspawn = bombspawn or {}

-- Pasting this in console gets everyone's current location: lua_run for k, v in pairs(player.GetAll()) do print(v, v:GetPos())end useful for getting good spawn positions

bombspawn[ "gm_construct" ] = {
	{ "L", Vector( -2402, -1560, -143 ), 300, 0 },
	{ "O", Vector( -2250, -2786, 256 ), 400, 0 },
	{ "G", Vector( -845, 564, -160 ), 200, 0 },
	{ "A", Vector( -4531, 5393, -95 ), 400, 0 },
	{ "N", Vector( 1399, -1659, -143 ), 300, 0 },
	{ "!", Vector( 773, 4239, -31 ), 50, 0 }
}

if not bombspawn[ game.GetMap() ] then
	return
--else
end