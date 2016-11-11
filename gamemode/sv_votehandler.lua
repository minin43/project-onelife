print( "sv_votehandler initialization..." )
util.AddNetworkString( "StartGMVote" )
util.AddNetworkString( "EndVote" )
util.AddNetworkString( "EndVoteCallback" )
util.AddNetworkString( "StartMapVote" )

--// Format: "gametype name as seen in roundhandler", "Full name", "Description"
local availablegamemodes = {
    { "lts", "Last Team Standing", "Eliminate the enemy team." },
    { "lts", "More to come...", "No description here!" }
}

--// Self-explanatory
local availablemaps = {
    "gm_devruins",
    "de_crash",
    "de_keystone_beta",
    "de_secretcamp",
    "ttt_bf3_scrapmetal"
}

local votes = { }
hook.Add( "GameEnd", "EndGameVoting", function( winner )
    --On game end, ask all players to vote for a map
    --This will all be drawn in hud.lua
    net.Start( "StartGMVote" )
        net.WriteTable( availablegamemodes )
    net.Broadcast()

    --After 30 seconds, set a winning mode, save it in a file - based on any sent votes - and start the map vote
    --After another 30 seconds, set a winning map and change to it
    timer.Simple( 30, function()
        local winningmode = table.GetWinningKey( votes )
        SetWinner( "mode", winningmode )
        print( "The winning gametype is: ", winningmode )
        for k, v in pairs( player.GetAll() ) do
            for k2, v2 in pairs( availablegamemodes ) do
                if winningmode == v2[ 1 ] then
                    net.Start( "EndVote" )
                        net.WriteString( v2[ 2 ] )
                    net.Send( v )
                end
            end

            timer.Simple( 5, function()
                net.Start( "StartMapVote" )
                    net.WriteTable( availablemaps )
                net.Send( v )
            end )
        end

        timer.Simple( 35, function()
            local winningmap = table.GetWinningKey( votes ) or availablemaps[ 1 ]
            PrintTable( votes )
            print( "Switching map to: ", winningmap )
            SetWinner( "map", winningmap )
            for k, v in pairs( player.GetAll() ) do
                net.Start( "EndVote" )
                    net.WriteString( winningmap )
                net.Send( v )
            end
        end)
    end)

    for k, v in pairs( availablegamemodes ) do
        votes[ v[ 1 ] ] = 0
    end

    net.Receive( "EndVoteCallback", function( len, ply )
        print( "EndVoteCallback received")
        local playervote = net.ReadString()
        print( ply:Nick() .. " voted for: ", playervote )
        if votes[ playervote ] then
            votes[ playervote ] = votes[ playervote ] + 1
        end
    end)
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