print( "sv_bombs initialization..." )
hook.Add( "GameStart", "SetBombs", function( mode )
	objspawn = objspawn or { }

	-- Pasting this in console gets everyone's current location: lua_run for k, v in pairs(player.GetAll()) do print(v, v:GetPos())end useful for getting good spawn positions

	objspawn[ "hotpoint" ] = {
		[ "gm_devruins" ] = {
			--//Vector positions, hotpoint size
			{ Vector( 0, 0, 0 ), 200 }
		}
		[ "de_crash" ] = {
			{ Vector( 0, 0, 0 ), 200 },
			{ Vector( 0, 0, 0 ), 200 }
		}
		[ "de_keystone_beta" ] = {
			{ Vector( 0, 0, 0 ), 200 },
			{ Vector( 0, 0, 0 ), 200 }
		}
		[ "de_secretcamp" ] = {
			{ Vector( 0, 0, 0 ), 200 }
		}
		[ "ttt_bf3_scrapmetal" ] = {
			{ Vector( 0, 0, 0 ), 200 },
			{ Vector( 0, 0, 0 ), 200 }
		}
	}

	objspawn[ "cache" ] = {
		[ "gm_devruins" ] = {
			[ "A" ] = { }
		}
		[ "de_crash" ] = {
			[ "A" ] = { }
			[ "B" ] = { }
		}
		[ "de_keystone_beta" ] = {
			[ "A" ] = { }
			[ "B" ] = { }
		}
		[ "de_secretcamp" ] = {
			[ "A" ] = { }
			[ "B" ] = { }
		}
		[ "ttt_bf3_scrapmetal" ] = {
			[ "A" ] = { }
		}
	}

	objspawn[ "hq" ] = {
		[ "gm_devruins" ] = {
			[ 1 ] = { }
			[ 2 ] = { }
		}
		[ "de_crash" ] = {
			[ 1 ] = { }
			[ 2 ] = { }
		}
		[ "de_keystone_beta" ] = {
			[ 1 ] = { }
			[ 2 ] = { }
		}
		[ "de_secretcamp" ] = {
			[ 1 ] = { }
			[ 2 ] = { }
		}
		[ "ttt_bf3_scrapmetal" ] = {
			[ 1 ] = { }
			[ 2 ] = { }
		}
	}

	if not objspawn[ mode ][ game.GetMap() ] then
		return
	--else
	
	end
end )