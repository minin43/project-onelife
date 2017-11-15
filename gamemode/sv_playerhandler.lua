print( "sv_playerhandler initialization..." )
util.AddNetworkString( "LastAlive" )

hook.Add( "PostPlayerDeath", "fullteameliminationchecker", function( vic, info, att )
    GAMEMODE:RoundCheck( vic )
end )

GM.alivePlayers = {[1] = { }, [2] = { }, [3] = { }}

function GM:RoundCheck( lostPly )
    print("GM:RoundCheck called ")
    if not self.gameInProgress or not self.roundInProgress then return end

    table.Empty(self.alivePlayers[1])
    table.Empty(self.alivePlayers[2])
    table.Empty(self.alivePlayers[3])
    for teamNumber, teamData in pairs( team.GetAllTeams() ) do
        for key, ply in pairs(team.GetPlayers(teamNumber)) do
            if (teamNumber == 1 or teamNumber == 2 or teamNumber == 3) and ply:Alive() then
                table.insert(self.alivePlayers[teamNumber], ply)
            end
        end
    end

    if self.soloMode then
        if #self.alivePlayers[3] < 2 then
            self:RoundEnd(3)
            return
        end
    end

    if #self.alivePlayers[lostPly:Team()] > 1 then
        return
    elseif #self.alivePlayers[lostPly:Team()] == 1 then
        net.Start( "LastAlive" )
        net.Send(self.alivePlayers[lostPly:Team()])
    elseif #self.alivePlayers[lostPly:Team()] == 0 then
        print("RoundCheck DEBUG ---------- ", lostPly:Team(), #self.alivePlayers[lostPly:Team()], #self.alivePlayers[2], #self.alivePlayers[1])
        if lostPly:Team() == 1 and #self.alivePlayers[2] > 0 then
            print("RoundCheck DEBUG ---------- Winning team: 2")
            self:RoundEnd(2)
            return
        elseif lostPly:Team() == 2 and #self.alivePlayers[1] > 0 then
            print("RoundCheck DEBUG ---------- Winning team: 1")
            self:RoundEnd(1)
            return
        end
        print("RoundCheck DEBUG ---------- No winning team")
        self:RoundEnd(0)
    end
end