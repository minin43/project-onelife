--// key is player name, value is table where 1 = kills, 2 = deaths, and 3 = headshots - Should I add more?
GM.gameData = { }

function table.IsEmpty( tab )
    for k, v in pairs(tab) do
        if v then return false end
    end
    return true
end

hook.Add( "PlayerDeath", "GlobalKills", function( vic, wep, att )
	if vic and att and IsValid( vic ) and IsValid( att ) and vic != NULL and att != NULL and att:IsPlayer() then
        if not GAMEMODE.gameData[ vic:Nick() ] then
            GAMEMODE.gameData[ vic:Nick() ] = {kills = 0, deaths = 0, headshots = 0}
        end
        if not GAMEMODE.gameData[ att:Nick() ] then
            GAMEMODE.gameData[ att:Nick() ] = {kills = 0, deaths = 0, headshots = 0}
        end

        GAMEMODE.gameData[ att:Nick() ].kills = GAMEMODE.gameData[ att:Nick() ].kills + 1
		GAMEMODE.gameData[ vic:Nick() ].deaths = GAMEMODE.gameData[ vic:Nick() ].deaths + 1
        if vic:LastHitGroup() == "HITGROUP_HEAD" then
            GAMEMODE.gameData[ att:Nick() ].headshots = GAMEMODE.gameData[ att ].headshots + 1
        end
	end
end )

util.AddNetworkString( "MVPList" )

hook.Add( "GameEnd", "EndGameMVP", function( winner )
    --On game end, send all players an MVP list
    GAMEMODE.mostKills, GAMEMODE.mostDeaths, GAMEMODE.mostHeadshots, GAMEMODE.mostObj = {players = {}, amount = 0}, {players = {}, amount = 0}, {players = {}, amount = 0}, {players = {}, amount = 0}

    for k, v in pairs( GAMEMODE.gameData ) do
        if v.kills > GAMEMODE.mostKills.amount then
            table.Empty( GAMEMODE.mostKills.players )
            GAMEMODE.mostKills.players[1] = k
            GAMEMODE.mostKills.amount = v.kills
        elseif v.kills == GAMEMODE.mostKills.amount then
            GAMEMODE.mostKills.players[#GAMEMODE.mostKills.players + 1] = k
        end
        if v.deaths > GAMEMODE.mostDeaths.amount then
            table.Empty( GAMEMODE.mostDeaths.players )
            GAMEMODE.mostDeaths.players[1] = k
            GAMEMODE.mostDeaths.amount = v.deaths
        elseif v.deaths == GAMEMODE.mostDeaths.amount then
            GAMEMODE.mostDeaths.players[#GAMEMODE.mostDeaths.players + 1] = k
        end
        if v.headshots > GAMEMODE.mostHeadshots.amount then
            table.Empty( GAMEMODE.mostHeadshots.players )
            GAMEMODE.mostHeadshots.players[1] = k
            GAMEMODE.mostHeadshots.amount = v.headshots
        elseif v.headshots == GAMEMODE.mostHeadshots.amount then
            GAMEMODE.mostHeadshots.players[#GAMEMODE.mostHeadshots.players + 1] = k
        end
        --How should we calculate objective accolades? Maybe substitute kills for score?
    end

    net.Start( "MVPList" )
        net.WriteTable( GAMEMODE.mostKills )
        net.WriteTable( GAMEMODE.mostDeaths )
        net.WriteTable( GAMEMODE.mostHeadshots )
        --net.WriteTable( mostObj )
    net.Broadcast()
end )