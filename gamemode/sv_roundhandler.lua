
function StartGame( mode, time )
    if !mode or !time then
        print( "Invalid mode type or round time." )
        return
    end
    SetGlobalBool( "GameInProgress", true )
    StartRound( mode, time, 1 )
end

local function StartRound( mode, round )
    SetGlobalInt( "RoundTime", time )
    RoundPrep( mode, round )
end

--Round preperation stuff
local function RoundPrep( mode, round )
    SetGlobalInt( "RoundTime", 180 ) 
    print( "We are starting round: ", round)
    if !allteamsvalid() then print( "Not all teams are valid!" ) return end
    
    game.CleanUpMap()
    print( "Round preperation starting, cleaning up map..." )

    if round != 1 then
        ChangeSides()
    end

    for k, v in pairs( player.GetAll() ) do
        v:Spawn()
	    v:Lock()
        v.CanCustomizeLoadout = true
        v:ConCommand( "tdm_spawnmenu" )
        print( "Spawning and locking: ", v )
    end
    
    timer.Simple( 15, function()
        print( "15 second timer finished, starting round/game.")
        RoundBegin( mode, round )
    end)
    --hook.Call
end 

--Game starting, player movement freed
local function RoundBegin( mode, round )
    print( "Starting game/round..." )
    --Start the round's countdown timer
    timer.Create( "Time Countdown", 1, 0, function()
        SetGlobalInt( "RoundTime", GetGlobalInt( "RoundTime" ) - 1 )
        if GetGlobalInt( "RoundTime" ) == 0 then
            RoundEnd( mode, round, 3 )
            SetGlobalInt( "RoundTime", -1 )
            timer.Remove( "Time Countdown" )
        end
    end )

    for k, v in pairs( player.GetAll() ) do
	    v:UnLock()
        v.CanCustomizeLoadout = false
        print( "Unlocking: ", v )
    end
    --hook.Call
end

--Game finishes, restart round if needed and deliver rewards
local RedTeamWins, BlueTeamWins
local function RoundEnd( mode, round, victor)
    if !GetGlobalBool( "GameInProgress" ) then return end
    if timer.Exists( "Time Countdown" ) then
        timer.Remove( "Time Countdown" )
    end

    if victor == 1 then
        RedTeamWins = RedTeamWins + 1
        -
    elseif victor == 2 then
        BlueTeamWins = BlueTeamWins + 1
        -
    end
    --hook.Call

    local winner
    if RedTeamWins == 3 then
        winner = "Red"
    elseif BlueTeamWins == 3 then
        winner = "Blue"
    else
        print( "Nobody's won the game yet." )
        timer.Simple( 15, function()
            StartRound( mode, round + 1 )
            --hook.Call( "StartPrep" )
            return
        end )
    end
    if winner then hook.Call( "GameWinner",  )

    if roundnumber != GetGlobalInt( "MaxRound" ) then
        print( "EndGame hook called, commencing new round..." )
        timer.Simple( 15, function()
            StartRound( mode, round + 1 )
            --hook.Call( "StartPrep" )
            return
        end )
        return
    end

    print( roundnumber, GetGlobalInt( "MaxRound" ), roundnumber != GetGlobalInt( "MaxRound" ) )
    print( "Max round limit reached, there's nothing left to do..." )
    SetGlobalBool( "GameInProgress", false )
    SetGlobalInt( "RoundTime", -1 ) 
    SetGlobalString( "Gametype", "none" )
	SetGlobalBool( "RoundFinished", true )
    gametype = "none"
    return
    --hook.Call
end )

--This needs to go on a different file--
hook.Add( "PostPlayerDeath", "fullteameliminationchecker", function( vic, info, att )
    if !GetGlobalBool( "GameInProgress" ) then return end
    
    print( "Somebody's died!")
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
        SetGlobalInt( "RoundWinner", 3 )
        print( "Everyone is dead! Round draw!" )
        umsg.Start( "endmusic", player.GetAll() )
	    umsg.End()
        hook.Call( "EndGame" )
    elseif reddead then
        SetGlobalInt( "RoundWinner", 2 )
        print( "Red team eliminated, Blue team wins!" )
        umsg.Start( "endmusic", player.GetAll() )
	    umsg.End()
        hook.Call( "EndGame" )
    elseif bluedead then
        SetGlobalInt( "RoundWinner", 1 )
        print( "Blue team eliminated, Red team wins!" )
        umsg.Start( "endmusic", player.GetAll() )
	    umsg.End()
        hook.Call( "EndGame" )
    end
end )

function ReturnGameType()
    if gametype == NULL then gametype = "none" end
    return gametype
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
            print( "Red team's validity is: ", table.Count( team.GetPlayers( 1 ) ) > 0 )
        elseif team.GetName( k ) == "Blue" then
            print( "Blue Team teamchecker commencing..." )
            if table.Count( team.GetPlayers( 2 ) ) > 0 then
                bluevalid = true
            end
            print( "Blue team's validity is: ", table.Count( team.GetPlayers( 2 ) ) > 0 )
        end
    end
    
    if redvalid and bluevalid then
        print( "All teams are valid" )
        return true
    end    
    return false
end

function GM:PlayerDeathThink()
    return false
end

function GM:PlayerDisconnected( ply )
    if GetGlobalBool( "RoundFinished" ) or !GetGlobalBool( "GameInProgress" ) then return end
    
    print( "Somebody's disconnected")
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
        SetGlobalInt( "RoundWinner", 3 )
        print( "Everyone is dead! Round draw!" )
        hook.Call( "EndGame" )
    elseif reddead then
        SetGlobalInt( "RoundWinner", 2 )
        print( "Red team eliminated, Blue team wins!" )
        hook.Call( "EndGame" )
    elseif bluedead then
        SetGlobalInt( "RoundWinner", 1 )
        print( "Blue team eliminated, Red team wins!" )
        hook.Call( "EndGame" )
    end
        
end