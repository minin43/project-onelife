hook.Add( "PostPlayerDeath", "fullteameliminationchecker", function( vic, info, att )
    DeadTeamCheck()
end )

function DeadTeamCheck()
    if !GetGlobalBool( "GameInProgress" ) then return end
    
    print( "Somebody's died/disconnected!")
    local reddead = true
    local bluedead = true
    for k, v in pairs( team.GetAllTeams() ) do
        if k == 3 then 
            if GetGlobalBool( "TeamThree" ) then
                for k, v in pairs( team.GetPlayers( 3 ) ) do
                    if v:Alive() then blackdead = false print( "Someone on team 3 is still alive..." ) end
                end
            end
        elseif k == 1 then
            for k, v in pairs( team.GetPlayers( 1 ) ) do
                if v:Alive() then reddead = false print( "Someone on team 1 is still alive..." ) end
            end
        elseif k == 2 then
            for k, v in pairs( team.GetPlayers( 2 ) ) do
                if v:Alive() then bluedead = false print( "Someone on team 2 is still alive..." ) end
            end
        end
    end
    
    if reddead and bluedead then
        if table.Count( team.GetPlayers( 3 ) ) > 1 then end
        print( "Everyone is dead! Round draw!" )
        RoundEnd( GetGlobalInt( "Round" ), 0 )
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