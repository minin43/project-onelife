util.AddNetworkString( "StartGMVote" )
util.AddNetworkString( "EndVote" )
util.AddNetworkString( "EndGMVoteCallback" )
util.AddNetworkString( "StartMapVote" )
util.AddNetworkString( "EndMapVoteCallback" )

--// Format: "gametype name as seen in roundhandler", "Full name", "Description"
local availablegamemodes = {
    { "lts", "Last Team Standing", "Eliminate the enemy team." },
    { "lts", "More to come...", "No description here!" }
}

--// Self-explanatory
local availablemaps = {
    "gm_devruins"
}

local votes = { }
hook.Add( "GameEnd", "EndGameVoting", function( winner )
    --On game end, ask all players to vote for a map
    --This will all be drawn in hud.lua
    for k, v in pairs( player.GetAll() ) do
        net.Start( "StartGMVote" )
            net.WriteTable( availablegamemodes )
        net.Send( v )
    end

    --After 15 seconds, set a winning mode, save it in a file - based on any sent votes - and start the map vote
    --After another 15 seconds, set a winning map and change to it
    timer.Simple( 15, function()
        local winningmode = table.GetWinningKey( votes )
        SetWinner( "mode", winningmode )
        for k, v in pairs( player.GetAll() ) do
            net.Start( "EndVote" )
                net.WriteString( winningmode )
            net.Send( v )

            net.Start( "StartMapVote" )
                net.WriteTable( availablemaps )
            net.Send( v )
        end

        timer.Simple( 15, function()
            local winningmap = table.GetWinningKey( votes ) or availablemaps[ 1 ]
            print( "Switching map to: ", winningmap )
            SetWinner( "map", winningmap )
            for k, v in pairs( player.GetAll() ) do
                net.Start( "EndVote" )
                    net.WriteString( winningmode )
                net.Send( v )
            end
        end)
    end)

    for k, v in pairs( availablegamemodes ) do
        votes[ v[ 1 ] ] = 0
    end

    net.Receive( "EndGMVoteCallback", function( len, ply )
        local playervote = net.ReadString()
        if votes[ playervote ] then
            votes[ playervote ] = votes[ playervote ] + 1
        end
    end)

    net.Receive( "EndMapVoteCallback", function( len, ply )
        local playervote = net.ReadString()
        if votes[ playervote ] then
            votes[ playervote ] = votes[ playervote ] + 1
        end
    end )
end )

function GetWinner( tab )
    return table.GetWinningKey( tab )
end

function SetWinner( type, winner )
    if type == "mode" then
        if not file.Exists( "onelife/nextmode", "DATA" ) then
	        file.CreateDir( "onelife/nextmode" )
        end
		file.Write( "onelife/nextmode/mode.txt", winner )
        --We know logically that the mapvote can only come AFTER the next mode has been set, so we can go ahead and add/clear vote table values here
        table.Empty( votes )
        for k, v in pairs( availablemaps ) do
            votes[ v ] = 0
        end
    elseif type == "map" then
        --Give client time to notify the player of the decision
        timer.Simple( 5, function()
            RunConsoleCommand( "changelevel", winner )
        end)
    end
end