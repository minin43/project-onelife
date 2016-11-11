--// key is player name, value is table where 1 = kills, 2 = deaths, and 3 = headshots - Should I add more?
leaderboard = { }

hook.Add( "PlayerDeath", "GlobalKills", function( vic, wep, att )
	if vic and att and IsValid( vic ) and IsValid( att ) and vic != NULL and att != NULL and att:IsPlayer() then
        if not leaderboard[ vic:Nick() ] then
            leaderboard[ vic:Nick() ] = { 0, 0, 0 }
        end
        if not leaderboard[ att:Nick() ] then
            leaderboard[ att:Nick() ] = { 0, 0, 0 }
        end

        leaderboard[ att:Nick() ][ 1 ] = leaderboard[ att ][ 1 ] + 1
		leaderboard[ vic:Nick() ][ 2 ] = leaderboard[ vic ][ 2 ] + 1
        if vic:LastHitGroup() == "HITGROUP_HEAD" then
            leaderboard[ att:Nick() ][ 3 ] = leaderboard[ att ][ 3 ] + 1
        end
	end
end )

util.AddNetworkString( "MVPList" )

hook.Add( "GameEnd", "EndGameMVP", function( winner )
    --On game end, send all players an MVP list
    local mostkills, mostdeaths, mostheadshots, mostobj = { }, { }, { }, { }
    for k, v in pairs( leaderboard ) do
        if v[ 1 ] > mostkills[ 1 ] then
            table.Empty( mostkills )
            mostkills[ k ] = v[ 1 ]
        elseif v[ 1 ] == mostkills[ 1 ] then
            table.insert( mostkills, k, v[ 1 ] )
        end
        if v[ 2 ] > mostdeaths[ 1 ] then
            table.Empty( mostdeaths )
            mostdeaths[ k ] = v[ 2 ]
        elseif v[ 2 ] == mostdeaths[ 1 ] then
            table.insert( mostdeaths, k, v[ 2 ] )
        end
        if v[ 3 ] > mostheadshots[ 1 ] then
            table.Empty( mostheadshots )
            mostheadshots[ k ] = v[ 3 ]
        elseif v[ 3 ] == mostheadshots[ 3 ] then
            table.insert( mostheadshots, k, v[ 3 ] )
        end
        --How should we calculate objective accolades? Maybe substitute kills for score?
    end

    net.Start( "MVPList" )
        net.WriteTable( mostkills )
        net.WriteTable( mostdeaths )
        net.WriteTable( mostheadshots )
        --net.WriteTable( mostobj )
    net.Broadcast()
end )