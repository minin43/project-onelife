print( "sv_playerhandler initialization..." )
util.AddNetworkString( "LastAlive" )

hook.Add( "PostPlayerDeath", "fullteameliminationchecker", function( vic, info, att )
    DeadTeamCheck( vic )
end )

function DeadTeamCheck( deadply )
    if !GetGlobalBool( "GameInProgress" ) or !GetGlobalBool( "RoundInProgress" ) then return end
    
    print( "Somebody's died/disconnected!")
    local reddead = true
    local bluedead = true
    local aliveplayers = { [ 1 ] = { }, [ 2 ] = { }, [ 3 ] = { } }
    local teamvalidity = { [ 1 ] = true, [ 2 ] = true, [ 3 ] = true }
    --//Puts all alive players in their respective tables
    for teamnumber, teamdata in pairs( team.GetAllTeams() ) do
        for key, ply in pairs( team.GetPlayers( teamnumber ) ) do
            if ( teamnumber == 1 or teamnumber == 2 or teamnumber == 3 ) and ply:Alive() then
                table.insert( aliveplayers[ teamnumber ], ply )
            end
        end
    end
    
    --//Sends "lastalive" sound to any player if they're the last alive and does some additional thinking
    for teamnumber, allaliveplayers in pairs( aliveplayers ) do
        if #aliveplayers[ teamnumber ] == 0 then
            teamvalidity[ teamnumber ] = false
            print( "Team ", teamnumber, " is not valid." )
        elseif #aliveplayers[ teamnumber ] == 1 then
            if allaliveplayers[ 1 ].alreadysent or deadply:Team() != allaliveplayers[ 1 ]:Team() then continue end
            net.Start( "LastAlive" )
            net.Send( allaliveplayers[ 1 ] )
            print( allaliveplayers[ 1 ]:Nick(), " is the last alive on team ", teamnumber )
            allaliveplayers[ 1 ].alreadysent = true
        elseif teamnumber == 3 and #aliveplayers[ teamnumber ] == 1 and GetGlobalBool( "TeamThree" ) then
            RoundEnd( GetGlobalInt( "Round" ), 3 )
            print( allaliveplayers[ 1 ]:Nick(), " is the last alive and winner for Solo Team" )
            return
        else 
            print( "Team ", teamnumber, " is still valid." )
        end
    end
    
    if !teamvalidity[ 1 ] and !teamvalidity[ 2 ] and !GetGlobalBool( "TeamThree" ) then
        print( "Everyone is dead! Round draw!" )
        RoundEnd( GetGlobalInt( "Round" ), 0 )
    elseif !teamvalidity[ 1 ] then
        print( "Red team eliminated, Blue team wins!" )
        RoundEnd( GetGlobalInt( "Round" ), 2 )
    elseif !teamvalidity[ 2 ] then
        print( "Blue team eliminated, Red team wins!" )
        RoundEnd( GetGlobalInt( "Round" ), 1 )
    end
    table.Empty( aliveplayers )
end

function GM:PlayerDeathThink()
    return false
end