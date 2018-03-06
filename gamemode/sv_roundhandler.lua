GM.modes = {
    lts = {
        Rounds = 5,
        roundTime = 180,
        Solo = false,
        Name = "Last Team Standing",
        Description = "Eliminate the enemy team.",
        Voteable = true
    },
    cache = {
        Rounds = 5,
        roundTime = 240,
        Solo = false,
        Name = "Weapons Cache",
        Description = "Blue team must destroy Red team's weapons cache.",
        Voteable = false
    },
    oma = {
        Rounds = 5,
        roundTime = 180,
        Solo = true,
        Name = "One Man Army",
        Description = "Every man for themself.",
        Voteable = false
    },
    hot = {
        Rounds = 5,
        roundTime = 240,
        Solo = false,
        Name = "HotPoint",
        Description = "Capture the neutral single point to win.",
        Voteable = false
    },
    hq = {
        Rounds = 3,
        roundTime = 300,
        Solo = false,
        Name = "Headquarters",
        Description = "Defend your own weapons cache or destroy the enemy's.",
        Voteable = false
    },
    placeholder = {
        Rounds = 0,
        roundTime = 0,
        Solo = false,
        Name = "Nothing here yet",
        Description = "More to come.",
        Voteable = true
    }
}

util.AddNetworkString( "GameStart" )
util.AddNetworkString( "RoundPrepStart" )
util.AddNetworkString( "RoundStart" )
util.AddNetworkString( "RoundEnd" )
util.AddNetworkString( "GameEnd" )
util.AddNetworkString( "LowTime" )
util.AddNetworkString( "CreateCountdown" )
util.AddNetworkString( "Countdown" )

--//The amount of time, in seconds, before a round starts
GM.PreRoundTimer = 20

function GM:StartGame( mode )
    if !self.modes[mode] then
        print( "Invalid mode type, preventing game start." )
        return
    end
    if self.gameInProgress then 
        print( "There is already a game in progress..." )
        return 
    end
    print("Starting game with game type: ", mode)

    self.gameType = mode
    self.gameInProgress = true
    self.roundInProgress = false
    self.Round = 1
    self.redTeam.Wins = 0
    self.blueTeam.Wins = 0
    self.SoloMode = self.modes[mode].Solo

    self:StartRound(self.Round)
    net.Start( "GameStart" )
        net.WriteString( mode )
    net.Broadcast()

    --[[SetGlobalString( "GameType", mode )
    SetGlobalBool( "gameInProgress", true )
    SetGlobalInt( "Round", 1 )
    SetGlobalInt( "RedTeamWins", 0 )
    SetGlobalInt( "BlueTeamWins", 0 )
    SetGlobalBool( "TeamThree", GM.modes[ mode ][ "TeamThree" ] )
    StartRound( 1 )
    hook.Call( "GameStart", nil, mode )
    net.Start( "GameStart" )
        net.WriteString( mode )
    net.Broadcast()]]
end

function GM:StartRound( round )
    print( "Starting round: ", round)
    print("\nStartRound DEBUG - ", self.modes, self.gameType) 
    print(self.modes[self.gameType], self.modes[self.gameType].roundTime)
    SetGlobalInt( "RoundTime", self.modes[self.gameType].roundTime )
    self.Round = round
    self:RoundPrep( self.Round )
end

--Round preperation stuff
function GM:RoundPrep( round )
    print( "Preparing round: ", round)
    if not self:allteamsvalid() then 
        print( "Not all teams are valid, preventing round preperation." )
        self.gameType = "none"
        self.gameInProgress = false
        self.roundInProgress = false
        SetGlobalInt( "RoundTime", 0 ) 
        return 
    end
    game.CleanUpMap()
    print( "All teams are valid, cleaning up map..." )

    --[[if not GAMEMODE.Round % 2 == 0 and not GAMEMODE.Round == 1 then
        --ChangeSides() --To-do function, use this to change everyone's spawn/objective?
    end]]

    --//Spawns and freezes all players
    for k, v in pairs( player.GetAll() ) do
        if v:Team() == 1 or v:Team() == 2 or v:Team() == 3 then
            v:Spawn()
            timer.Simple( 0, function()
	            v:Freeze( true )
            end)
            v:SetObserverMode( OBS_MODE_NONE )
            if v.initialJoin then
                v:SendLua( "LoadoutMenu()" )
                v.initialJoin = false
            end
            --//Found in sh_loadoutmenu//--
            self:ApplyLoadout( v )
            print( "Spawning and locking: ", v )
        end
    end

    --//Calls the respective hook and starts the respective net message
    hook.Call( "RoundPrepStart", self, round )
    net.Start( "RoundPrepStart" )
        net.WriteString( tostring( round ) )
    net.Broadcast()

    --//Starts the countdown
    net.Start( "CreateCountdown" )
    net.Broadcast()
    timer.Create( "Countdown Timer", 1, self.PreRoundTimer, function()
        net.Start( "Countdown" )
            net.WriteString( tostring( timer.RepsLeft( "Countdown Timer" ) ) )
        net.Broadcast()

        --//After 30 seconds has passed, begins the round
        if timer.RepsLeft( "Countdown Timer" ) == 0 then
            print( "30 second timer finished, starting round/game.")
            self:RoundBegin( round )
        end
    end )
end 

--Game starting, player movement freed
function GM:RoundBegin( round )
    print( "Starting round...", round )
    self.roundInProgress = true
    --Start the round's countdown timer
    timer.Create( "Time Countdown", 1, 0, function()
        SetGlobalInt( "RoundTime", GetGlobalInt( "RoundTime" ) - 1 )
        if GetGlobalInt( "RoundTime" ) == 30 then
            for k, v in pairs( player.GetAll() ) do
                if v:Alive() then net.Start( "LowTime" ) net.Send( v ) end
            end
        end

        if GetGlobalInt( "RoundTime" ) < 31 then
            for k, v in pairs( player.GetAll() ) do
                if v:Alive() then v:SendLua( "surface.PlaySound( \"misc/timer_countdown.wav\" )" ) end
            end
        end

        if GetGlobalInt( "RoundTime" ) < 1 then
            self:RoundEnd( 0 )
            SetGlobalInt( "RoundTime", 0 )
            timer.Remove( "Time Countdown" )
        end
    end )

    --Unlocks all player movements but disallows kit customization
    print( "Round has started..." )
    self.roundInProgress = true
    for k, v in pairs( player.GetAll() ) do
	    v:Freeze( false )
        print( "Unlocking: ", v )
        v.alreadysent = false
    end
    hook.Call( "RoundStart", self, round )
    net.Start( "RoundStart" )
        net.WriteString( tostring( round ) )
    net.Broadcast()
end

--Game finishes, restart round if needed and deliver rewards
function GM:RoundEnd( roundVictor )
    print("\nRoundEnd Traceback")
    debug.Trace()
    print("End RoundEnd Traceback\n")
    print("GM:RoundEnd called", roundVictor)
    if timer.Exists( "Time Countdown" ) then
        timer.Remove( "Time Countdown" )
    end

    self.winningTeam = roundVictor
    self.winningTeamColor = Color(0, 0, 0)
    self.roundInProgress = false

    if roundVictor == 1 then
        self.redTeam.Wins = self.redTeam.Wins + 1
        self.winningTeamName = team.GetName( 1 )
        self.winningTeamColor = Color( 100, 15, 15 )

        for k, v in pairs( team.GetPlayers( 1 ) ) do
            self:AddRewards( v, self.SCORECOUNTS.ROUND_WON )
        end
        for k, v in pairs( team.GetPlayers( 2 ) ) do
            self:AddRewards( v, self.SCORECOUNTS.ROUND_LOST )
        end
    elseif roundVictor == 2 then
        self.blueTeam.Wins = self.blueTeam.Wins + 1
        self.winningTeamName = team.GetName( 2 )
        self.winningTeamColor = Color( 30, 80, 180 )

        for k, v in pairs( team.GetPlayers( 1 ) ) do
            self:AddRewards( v, self.SCORECOUNTS.ROUND_LOST )
        end
        for k, v in pairs( team.GetPlayers( 2 ) ) do
            self:AddRewards( v, self.SCORECOUNTS.ROUND_WON )
        end
    end
    ULib.tsayColor( nil, true, self.winningTeamColor, self.winningTeamName, Color( 255, 255, 255 ), " has won round " .. self.Round .. "." )

    if self:IsGameWon() then --Might need to add "winner" parameter
        debug.Trace()
        print( "Game has been won" )
        self.gameType = nil
        self.gameInProgress = false
        self.roundInProgress = false
        SetGlobalInt( "RoundTime", 0 )

        hook.Call( "GameEnd", self, roundVictor )
        net.Start( "GameEnd" )
            net.WriteString( tostring( roundVictor ) )
        net.Broadcast()
        ULib.tsayColor( nil, true, self.winningTeamColor, self.winningTeamName, Color( 255, 255, 255 ), " has won the game." )

        for k, v in pairs( team.GetPlayers( roundVictor ) ) do
            self:AddRewards( v, self.SCORECOUNTS.GAME_WON )
        end
        if roundVictor == 1 then losingteam = 2 elseif roundVictor == 2 then losingteam = 1 end
        for k, v in pairs( team.GetPlayers( losingteam ) ) do
            self:AddRewards( v, self.SCORECOUNTS.GAME_LOST )
        end
    else
        print( "Nobody's won the game yet." )
        timer.Simple( 10, function()
            self:StartRound( self.Round + 1 )
        end )
        local leadingteam
        if self.redTeam.Wins > self.blueTeam.Wins then leadingteam = 1 elseif self.blueTeam.Wins > self.redTeam.Wins then leadingteam = 2 else leadingteam = 0 end
        print("RoundEnd DEBUG:", self, self.Round, roundVictor, leadingteam)
        --hook.Call( "RoundEndHook", self, roundVictor, leadingteam )
        net.Start( "RoundEnd" )
            net.WriteString( tostring( roundVictor ) )
            net.WriteString( tostring( leadingteam ) )
        net.Broadcast()
    end
end 

function GM:IsGameWon()
    print("GM:IsGameWon DEBUG: ", self.redTeam.Wins, self.blueTeam.Wins, self.modes[self.gameType].Rounds)
    if self.redTeam.Wins >= self.modes[self.gameType].Rounds or self.blueTeam.Wins >= self.modes[self.gameType].Rounds then
        return true
    end
    return false
end

function GM:allteamsvalid()
    for k, v in pairs( team.GetAllTeams() ) do
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