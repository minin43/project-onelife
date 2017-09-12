print( "sv_playerhandler initialization..." )
util.AddNetworkString( "LastAlive" )

hook.Add( "PostPlayerDeath", "fullteameliminationchecker", function( vic, info, att )
    RoundCheck( vic )
end )

GM.alivePlayers = {{ }, { }, { }}

function GM:RoundCheck( lostPly )
    if not GM.GameInProgress or not GM.RoundInProgress then return end

    table.Clear(GM.alivePlayers)
    for teamNumber, teamData in pairs( team.GetAllTeams() ) do
        for key, ply in pairs(team.GetPlayers(teamNumber)) do
            if (teamNumber == 1 or teamNumber == 2 or teamNumber == 3) and ply:Alive() then
                table.insert(GM.alivePlayers[ teamNumber ], ply)
            end
        end
    end

    if GM.soloMode then
        if #GM.alivePlayers[3] == 1 then
            GM.RoundEnd(3)
            return
        end
    end

    if #GM.alivePlayers[lostPly:Team()] > 1 then
        return
    elseif #GM.alivePlayers[lostPly:Team()] == 1 then
        net.Start( "LastAlive" )
        net.Send(GM.alivePlayers[lostPly:Team()])
    elseif #GM.alivePlayers[lostPly:Team()] == 0 then
        if lostPly:Team() == 1 and #GM.alivePlayers[2] > 0 then
            GM.RoundEnd(2)
            return
        elseif lostPly:Team() == 2 and #GM.alivePlayers[1] > 0 then
            GM.RoundEnd(1)
            return
        end
        GM.RoundEnd(0)
    end
end