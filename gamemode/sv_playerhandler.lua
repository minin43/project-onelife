print( "sv_playerhandler initialization..." )
util.AddNetworkString( "LastAlive" )

hook.Add( "PostPlayerDeath", "fullteameliminationchecker", function( vic, info, att )
    RoundCheck( vic )
end )

GM.alivePlayers = {{ }, { }, { }}

function GM:RoundCheck( lostPly )
    if not self.GameInProgress or not self.RoundInProgress then return end

    table.Clear(self.alivePlayers)
    for teamNumber, teamData in pairs( team.GetAllTeams() ) do
        for key, ply in pairs(team.GetPlayers(teamNumber)) do
            if (teamNumber == 1 or teamNumber == 2 or teamNumber == 3) and ply:Alive() then
                table.insert(self.alivePlayers[ teamNumber ], ply)
            end
        end
    end

    if self.soloMode then
        if #self.alivePlayers[3] == 1 then
            self.RoundEnd(3)
            return
        end
    end

    if #self.alivePlayers[lostPly:Team()] > 1 then
        return
    elseif #self.alivePlayers[lostPly:Team()] == 1 then
        net.Start( "LastAlive" )
        net.Send(self.alivePlayers[lostPly:Team()])
    elseif #self.alivePlayers[lostPly:Team()] == 0 then
        if lostPly:Team() == 1 and #self.alivePlayers[2] > 0 then
            self.RoundEnd(2)
            return
        elseif lostPly:Team() == 2 and #self.alivePlayers[1] > 0 then
            self.RoundEnd(1)
            return
        end
        self.RoundEnd(0)
    end
end