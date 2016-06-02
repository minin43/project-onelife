hook.Add( "DoPlayerDeath", "SendDeathScreen", function( ply, att, dmginfo )
	anyteammate = table.Random( team.GetPlayers( ply:Team() ) )

	timer.Simple( 1.5, function()
		timer.Simple( 3, function()
			ply:SpectateEntity( anyteammate )
			ply:Spectate( OBS_MODE_CHASE )
		end)
		ply.num = 4
		umsg.Start( "DeathScreen", ply )
			umsg.Short( ply.num )
		umsg.End()
		
		local steamid = ply:SteamID()
		timer.Create( "SendUpdates_" .. steamid, 1, 2, function()
			if ply:IsValid() and ply:IsPlayer() then
				umsg.Start( "UpdateDeathScreen", ply )
					ply.num = ply.num - 1
					if ply.num < 0 then
						ply.num = 0
					end
					umsg.Short( ply.num )
				umsg.End()
				
			end
		end )
		
		timer.Simple( 4, function()
		umsg.Start( "CloseDeathScreen", ply )
		umsg.End()
		end)
		
	end )
end )