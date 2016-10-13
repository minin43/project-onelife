modes = {
    [ "lts" ] = { --Last Team Standing, your basic one-life team-deathmatch
        [ "Rounds" ] = 3,
        [ "RoundTime" ] = 180,
    },
    [ "cache" ] = { --Destroy Red's weapon cache, attack/defense based mode
        [ "Rounds" ] = 5,
        [ "RoundTime" ] = 240,
    },
    [ "oma" ] = { --One Man Army, Last Team Standing but every man for themself
        [ "Rounds" ] = 3,
        [ "RoundTime" ] = 180,
    },
    [ "hot" ] = { --HotPoint, whoever captures the single point uncontested wins
        [ "Rounds" ] = 5,
        [ "RoundTime" ] = 240,
    },
    [ "dicks" ] = {
        []
    },
    [ "tits" ] = {
        []
    }
}

function StartGame( mode )
    if !modes[ mode ] then
        print( "Invalid mode type, preventing game start." )
        return
    end
    SetGlobalInt( "RoundWinner", 0 )
    SetGlobalString( "GameType", mode )
    SetGlobalBool( "GameInProgress", true )
    SetGlobalInt( "Round", 1 )
    SetGlobalInt( "RedTeamWins", 0 )
    SetGlobalInt( "BlueTeamWins", 0 )
    StartRound( 1 )
end

function StartRound( round )
    SetGlobalInt( "RoundTime", 180 )
    SetGlobalInt( "Round", round )
    RoundPrep( round )
end

--Round preperation stuff
function RoundPrep( round ) 
    print( "We are starting round: ", round)
    if !allteamsvalid() then print( "Not all teams are valid, preventing round preperation." ) return end
    game.CleanUpMap()
    print( "Round preperation starting, cleaning up map..." )

    if round != 1 then
        --ChangeSides() --To-do function
    end

    print( "All teams valid...")
    for k, v in pairs( player.GetAll() ) do
        v:Spawn()
	    v:Freeze( true )
        GiveOldLoadout( v )
        --v.CanCustomizeLoadout = true This doesn't auto-work across server/client, we'll have to send out a message, hook, or set a global variable saying to close and disallow customization
        --v:ConCommand( "pol_menu" ) don't force this, only force the previous loadout
        print( "Spawning and locking: ", v )
    end
    
    timer.Simple( 30, function()
        print( "30 second timer finished, starting round/game.")
        RoundBegin( round )
    end)
    --hook.Call
end 

--Game starting, player movement freed
function RoundBegin( round )
    print( "Starting game/round..." )
    --Start the round's countdown timer
    timer.Create( "Time Countdown", 1, 0, function()
        SetGlobalInt( "RoundTime", GetGlobalInt( "RoundTime" ) - 1 )
        if GetGlobalInt( "RoundTime" ) == 0 then
            RoundEnd( round, 3 )
            SetGlobalInt( "RoundTime", -1 )
            timer.Remove( "Time Countdown" )
        end
    end )
    --Unlocks all player movements but disallows kit customization
    print( "Round has started..." )
    for k, v in pairs( player.GetAll() ) do
	    v:Freeze( false )
        v.CanCustomizeLoadout = false
        print( "Unlocking: ", v )
    end
    --hook.Call
end

--Game finishes, restart round if needed and deliver rewards
function RoundEnd( round, victor )
    if timer.Exists( "Time Countdown" ) then
        timer.Remove( "Time Countdown" )
    end
    SetGlobalInt( "RoundWinner", victor )
    if victor == 1 then
        SetGlobalInt( "RedTeamWins", GetGlobalInt( "RedTeamWins" ) + 1 )
    elseif victor == 2 then
        SetGlobalInt( "BlueTeamWins", GetGlobalInt( "BlueTeamWins" ) + 1 )
    end
    --hook.Call

    if GameWon() then --Might need to add "winner" parameter
        --To-do include a mapvote
        print( "Game has been won" )
        SetGlobalString( "Gametype", "none" )
        SetGlobalBool( "GameInProgress", false )
        SetGlobalInt( "RoundTime", 0 ) 
        --hook.Call( "GameWinner",  )
        return
    else
        print( "Nobody's won the game yet." )
        timer.Simple( 15, function()
            StartRound( round + 1 )
        end )
    end
end 

function GameWon()
    if GetGlobalInt( "RedTeamWins" ) == 3 or GetGlobalInt( "BlueTeamWins" ) == 3 then
        return true
    end
    return false
end

function allteamsvalid()
    print( "AllTeamsValid Initializing...")
    local redvalid = false
    local bluevalid = false
    for k, v in pairs( team.GetAllTeams() ) do
        --print( k, v, team.GetName( k ), "v value: ", team.GetName( v ) )
        if team.GetName( k ) == "Black" then print( "This team is the FFA team" )
        elseif team.GetName( k ) == "Red" then
            print( "Red Team teamchecker commencing..." )
            if table.Count( team.GetPlayers( 1 ) ) > 0 then
                redvalid = true
            end
            print( "Red team's validity is: ", redvalid )
        elseif team.GetName( k ) == "Blue" then
            print( "Blue Team teamchecker commencing..." )
            if table.Count( team.GetPlayers( 2 ) ) > 0 then
                bluevalid = true
            end
            print( "Blue team's validity is: ", bluevalid )
        end
    end
    
    if redvalid and bluevalid then
        print( "All teams are valid" )
        return true
    end    
    return false
end