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
        if not GM.gameData[ vic:Nick() ] then
            GM.gameData[ vic:Nick() ] = {kills = 0, deaths = 0, headshots = 0}
        end
        if not GM.gameData[ att:Nick() ] then
            GM.gameData[ att:Nick() ] = {kills = 0, deaths = 0, headshots = 0}
        end

        GM.gameData[ att:Nick() ].kills = GM.gameData[ att:Nick() ].kills + 1
		GM.gameData[ vic:Nick() ].deaths = GM.gameData[ vic:Nick() ].deaths + 1
        if vic:LastHitGroup() == "HITGROUP_HEAD" then
            GM.gameData[ att:Nick() ].headshots = GM.gameData[ att ].headshots + 1
        end
	end
end )

util.AddNetworkString( "MVPList" )

hook.Add( "GameEnd", "EndGameMVP", function( winner )
    --On game end, send all players an MVP list
    GM.mostKills, GM.mostDeaths, GM.mostHeadshots, GM.mostObj = {players = {}, amount = 0}, {players = {}, amount = 0}, {players = {}, amount = 0}, {players = {}, amount = 0}

    for k, v in pairs( GM.gameData ) do
        if v.kills > GM.mostKills.amount then
            table.Empty( GM.mostKills )
            GM.mostKills.players[1] = k
            GM.mostkills.amount = v.kills
        elseif v.kills == GM.mostKills.amount then
            GM.mostkills.players[#GM.mostKills.players + 1] = k
        end
        if v.deaths > GM.mostDeaths.amount then
            table.Empty( GM.mostDeaths )
            GM.mostDeaths.players[1] = k
            GM.mostDeaths.amount = v.deaths
        elseif v.deaths == GM.mostDeaths.amount then
            GM.mostDeaths.players[#GM.mostDeaths.players + 1] = k
        end
        if v.headshots > GM.mostHeadshots.amount then
            table.Empty( GM.mostHeadshots )
            GM.mostHeadshots.players[1] = k
            GM.mostHeadshots.amount = v.headshots
        elseif v.headshots == GM.mostHeadshots.amount then
            GM.mostHeadshots.players[#GM.mostHeadshots.players + 1] = k
        end
        --How should we calculate objective accolades? Maybe substitute kills for score?
    end

    net.Start( "MVPList" )
        net.WriteTable( GM.mostKills )
        net.WriteTable( GM.mostDeaths )
        net.WriteTable( GM.mostHeadshots )
        --net.WriteTable( mostObj )
    net.Broadcast()
end )