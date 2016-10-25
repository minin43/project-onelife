modes = {
    --//ROUNDS = ROUNDS NEEDED FOR GAME VICTORY, ROUNTIME = TOTAL ALOTTMENT OF TIME GIVEN EVERY ROUND, 
    [ "lts" ] = { --Last Team Standing, your basic one-life team-deathmatch
        [ "Rounds" ] = 11,
        [ "RoundTime" ] = 180,
    },
    [ "cache" ] = { --Destroy Red's weapon cache, attack/defense based mode
        [ "Rounds" ] = 3,
        [ "RoundTime" ] = 240,
    },
    [ "oma" ] = { --One Man Army, Last Team Standing but every man for themself
        [ "Rounds" ] = 3,
        [ "RoundTime" ] = 180,
        TeamThree = true,
    },
    [ "hot" ] = { --HotPoint, whoever captures the single point uncontested wins
        [ "Rounds" ] = 3,
        [ "RoundTime" ] = 240,
    },
    [ "dicks" ] = {
        --[]
    },
    [ "tits" ] = {
        --[]
    }
}

function StartGame( mode )
    if !modes[ mode ] then
        print( "Invalid mode type, preventing game start." )
        return
    end
    if GetGlobalBool( "GameInProgress" ) == true then 
        print( "There is already a game in progress..." )
        return 
    end
    SetGlobalString( "GameType", mode )
    SetGlobalBool( "GameInProgress", true )
    SetGlobalInt( "Round", 1 )
    SetGlobalInt( "RedTeamWins", 0 )
    SetGlobalInt( "BlueTeamWins", 0 )
    SetGlobalBool( "TeamThree", modes[ mode ][ "TeamThree" ] )
    StartRound( 1 )
    hook.Call( "GameStart", nil, mode )
end

function StartRound( round )
    SetGlobalInt( "RoundTime", modes[ GetGlobalString( "GameType" ) ][ "RoundTime" ] )
    SetGlobalInt( "Round", round )
    RoundPrep( round )
end

--Round preperation stuff
function RoundPrep( round ) 
    print( "We are starting round: ", round)
    if !allteamsvalid() then 
        print( "Not all teams are valid, preventing round preperation." ) 
        SetGlobalBool( "GameInProgress", false ) 
        SetGlobalString( "Gametype", "none" )
        SetGlobalBool( "GameInProgress", false )
        SetGlobalBool( "RoundInProgress", false )
        SetGlobalInt( "RoundTime", 0 ) 
        return 
    end
    game.CleanUpMap()
    print( "Round preperation starting, cleaning up map..." )

    if round != 1 then
        --ChangeSides() --To-do function, use this to change everyone's team, red to blue and blue to red, but keep their team name the same
    end

    print( "All teams valid...")
    for k, v in pairs( player.GetAll() ) do
        v:Spawn()
	    v:Freeze( true )
        --//Found in sh_loadoutmenu//--
        GiveOldLoadout( v )
        print( "Spawning and locking: ", v )
    end
    
    timer.Simple( 30, function()
        print( "30 second timer finished, starting round/game.")
        RoundBegin( round )
    end)
    hook.Call( "RoundPrepStart", nil, round )
end 

--Game starting, player movement freed
function RoundBegin( round )
    print( "Starting round...", round )
    --Start the round's countdown timer
    timer.Create( "Time Countdown", 1, 0, function()
        SetGlobalInt( "RoundTime", GetGlobalInt( "RoundTime" ) - 1 )
        if GetGlobalInt( "RoundTime" ) == 0 then
            RoundEnd( round, 0 )
            SetGlobalInt( "RoundTime", -1 )
            timer.Remove( "Time Countdown" )
        end
    end )
    --Unlocks all player movements but disallows kit customization
    print( "Round has started..." )
    SetGlobalBool( "RoundInProgress", true )
    for k, v in pairs( player.GetAll() ) do
	    v:Freeze( false )
        print( "Unlocking: ", v )
    end
    hook.Call( "RoundStart", nil, round )
end

--Game finishes, restart round if needed and deliver rewards
function RoundEnd( round, roundvictor )
    if timer.Exists( "Time Countdown" ) then
        timer.Remove( "Time Countdown" )
    end
    
    local winnername, winnercolor
    if roundvictor == 1 then
        SetGlobalInt( "RedTeamWins", GetGlobalInt( "RedTeamWins" ) + 1 )
        winnername = Team( 1 )[ "Name" ]
        winnercolor = Color( 100, 15, 15 )
    elseif roundvictor == 2 then
        SetGlobalInt( "BlueTeamWins", GetGlobalInt( "BlueTeamWins" ) + 1 )
        winnername = Team( 2 )[ "Name" ]
        winnercolor = Color( 30, 80, 180 )
    end
    ULib.tsayColor( nil, true, winnercolor, winnername, Color( 255, 255, 255 ), " has won round " .. round .. "." )

    if GameWon() then --Might need to add "winner" parameter
        print( "Game has been won" )
        SetGlobalString( "Gametype", "none" )
        SetGlobalBool( "GameInProgress", false )
        SetGlobalBool( "RoundInProgress", false )
        SetGlobalInt( "RoundTime", 0 ) 
        hook.Call( "GameEnd", nil, roundvictor )
    else
        print( "Nobody's won the game yet." )
        timer.Simple( 15, function()
            StartRound( round + 1 )
            SetGlobalBool( "RoundInProgress", false )
        end )
        local leadingteam
        if GetGlobalInt( "RedTeamWins" ) > GetGlobalInt( "BlueTeamWins" ) then leadingteam = 1 elseif GetGlobalInt( "BlueTeamWins" ) > GetGlobalInt( "RedTeamWins" ) then leadingteam = 2 else leadingteam = 0 end
        hook.Call( "RoundEnd", nil, round, roundvictor, leadingteam )
    end
end 

function GameWon()
    print( "Debug", GetGlobalInt( "RedTeamWins" ), GetGlobalInt( "BlueTeamWins" ), modes[ GetGlobalString( "GameType" ) ][ "Rounds" ] )
    if GetGlobalInt( "RedTeamWins" ) >= ( modes[ GetGlobalString( "GameType" ) ][ "Rounds" ] ) or GetGlobalInt( "BlueTeamWins" ) >= ( modes[ GetGlobalString( "GameType" ) ][ "Rounds" ] ) then
        return true
    end
    return false
end

function allteamsvalid()
    print( "Initial Team Checker Initializing...")
    local redvalid = false
    local bluevalid = false
    local blackvalid = false
    for k, v in pairs( team.GetAllTeams() ) do
        --print( k, v, team.GetName( k ), "v value: ", team.GetName( v ) )
        if k == 3 then
            print( "Team 3 teamchecker commencing..." )
            if table.Count( team.GetPlayers( 3 ) ) > 1 then
                blackvalid = true
            end
            print( "Team 3 is valid? ", blackvalid )
        elseif k == 1 then
            print( "Team 1 teamchecker commencing..." )
            if table.Count( team.GetPlayers( 1 ) ) > 0 then
                redvalid = true
            end
            print( "Team 1 is valid? ", redvalid )
        elseif k == 2 then
            print( "Team 2 teamchecker commencing..." )
            if table.Count( team.GetPlayers( 2 ) ) > 0 then
                bluevalid = true
            end
            print( "Team 2 is valid? ", bluevalid )
        end
    end
    
    if redvalid and bluevalid then
        print( "Teams 1 and 2 are valid" )
        return true
    elseif blackvalid then
        print( "Team 3 is valid" )
        return true
    end    
    return false
end