hook.Add( "PostPlayerDeath", "fullteameliminationchecker", function( vic, info, att )
    DeadTeamCheck()
end )

function DeadTeamCheck()
    if !GetGlobalBool( "GameInProgress" ) then return end
    
    print( "Somebody's died/disconnected!")
    local reddead = true
    local bluedead = true
    for k, v in pairs( team.GetAllTeams() ) do
        if team.GetName( k ) == "Black" then print ( "No need to check black team." )
        elseif team.GetName( k ) == "Red" then
            for k, v in pairs( team.GetPlayers( 1 ) ) do
                if v:Alive() then reddead = false print( "Someone on red team is still alive..." ) end
            end
        elseif team.GetName( k ) == "Blue" then
            for k, v in pairs( team.GetPlayers( 2 ) ) do
                if v:Alive() then bluedead = false print( "Someone on blue team is still alive..." ) end
            end
        end
    end
    
    if reddead and bluedead then
        print( "Everyone is dead! Round draw!" )
        RoundEnd( GetGlobalInt( "Round" ), 3 )
    elseif reddead then
        print( "Red team eliminated, Blue team wins!" )
        RoundEnd( GetGlobalInt( "Round" ), 2 )
    elseif bluedead then
        print( "Blue team eliminated, Red team wins!" )
        RoundEnd( GetGlobalInt( "Round" ), 1 )
    end
end

function GM:PlayerDeathThink()
    return false
end

function GM:PlayerDisconnected( ply )
    DeadTeamCheck()
end