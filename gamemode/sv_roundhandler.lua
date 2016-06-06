gametime = nil
gametype = nil
function SetGameTypeClassic()
    print( "Setting game type to 'classic'" )
    gametime = 300
    gametype = "Classic"
    SetGlobalInt( "MaxRound", 4 )
    hook.Call( "StartPrep" )
end

--[[function GameTypeFFA()
    gametime = 900
    gametype = "Free For All"
    SetGlobalInt( "Round", 1 )
end]]

hook.Add( "SetGameType", "setthegametype", function(  )
    --gametype should only ever be full gametype names, such as "Classic"
    --If concatenation doesn't work, we're gonna have to use if-else statements
    SetGameTypeClassic()
    SetGlobalInt( "RoundWinner", -1 )
end )

--Round preperation stuff
roundnumber = 0
hook.Add( "StartPrep", "prepthenewround", function()
    SetGlobalInt( "RoundTime", gametime ) 
    SetGlobalString( "Gametype", gametype )
	SetGlobalBool( "RoundFinished", false )
    SetGlobalBool( "GameInProgress", false )
    roundnumber = roundnumber + 1
    print( "Setting up global variables...", GetGlobalInt( "RoundTime"),  GetGlobalString( "Gametype"), GetGlobalBool( "RoundFinished"), GetGlobalBool( "GameInProgress") )
    print( "We are starting round: ", roundnumber)
    
    if !allteamsvalid() then print( "Not all teams are valid!" ) return end
    
    game.CleanUpMap()
    print( "Preperation phase starting, cleaning up map..." )
    umsg.Start( "startmusic", player.GetAll() )
	umsg.End()

    for k, v in pairs( player.GetAll() ) do
        v:Spawn()
	    v:Lock()
        v.CanCustomizeLoadout = true
        v:ConCommand( "tdm_spawnmenu" )
        print( "Spawning and locking: ", v )
    end
    
    timer.Simple( 15, function()
        print( "15 second timer finished, starting round/game.")
        hook.Call( "StartGame" )
    end)
end )

--Game starting, player movement freed
hook.Add( "StartGame", "roundstart", function()
    print( "Starting game/round..." )
    SetGlobalBool( "GameInProgress", true )
    timer.Create( "Time Countdown", 1, 0, function()
        SetGlobalInt( "RoundTime", GetGlobalInt( "RoundTime" ) - 1 )
    end)

    for k, v in pairs( player.GetAll() ) do
	    v:UnLock()
        v.CanCustomizeLoadout = false
        print( "Unlocking: ", v )
    end
    
end )

hook.Add( "Think", "WinnerChecker", function()
    if GetGlobalInt( "RoundTime" ) == 0 then
        timer.Remove( "Time Countdown" )
        print( "Time expired, ending game!" )
        hook.Call( "EndGame" )
        SetGlobalInt( "RoundTime", -1 )
    end
    
    --[[if GetGlobalInt( "RoundWinner" ) == 1 or GetGlobalInt( "RoundWinner" ) == 2 or GetGlobalInt( "RoundWinner" ) == 3 then
        hook.Call( "EndGame" )
        print( "Somebody's won the game!" )
    end]]
    
end )

--Game finishes, restart round if needed and deliver rewards
hook.Add( "EndGame", "ongameend", function()
    if !GetGlobalBool( "GameInProgress" ) then return end
    if roundnumber != GetGlobalInt( "MaxRound" ) then
        print( "EndGame hook called, commencing new round..." )
        timer.Simple( 15, function()
            print( "Max round limit not reached, starting new round." ) 
            hook.Call( "StartPrep" )
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
end )

hook.Add( "PostPlayerDeath", "fullteameliminationchecker", function( vic, info, att )
    if GetGlobalBool( "RoundFinished" ) or !GetGlobalBool( "GameInProgress" ) then return end
    
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