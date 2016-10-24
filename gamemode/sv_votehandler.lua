util.AddNetworkString( "StartGMVote" )
util.AddNetworkString( "EndVote" )
util.AddNetworkString( "EndVoteCallback" )
util.AddNetworkString( "SendWinner" )
util.AddNetworkString( "" )
util.AddNetworkString( "" )
util.AddNetworkString( "" )
util.AddNetworkString( "Callback" )

--// Format: "gametype name as seen in roundhandler", "Full name", "Description"
local availablegamemodes = {
    { "lts", "Last Team Standing", "Eliminate the enemy team." },
    { "lts", "More to come...", "No description here!" }
}

--// Self-explanatory
local availablemaps = {
    "gm_devmap"
}

local votes = { }
hook.Add( "GameEnd", "EndGameVoting", function( winner )
    for k, v in pairs( player.GetAll() ) do
        net.Start( "StartGMVote" )
            net.WriteTable( availablegamemodes )
        net.Send( v )
    end

    timer.Simple( 30, function()
        for k, v in pairs( player.GetAll() ) do
            --//This should close client-side voting and set the voted winner
            net.Start( "EndVote" )
            net.Send( v )
        end
    end)

    for k, v in pairs( availablegamemodes ) do
        votes[ v ] = 0
    end
    net.Receive( "EndGMVoteCallback", function( len, ply )
        local vote = tonumber( net.ReadString() )
        if vote > #availablegamemodes then vote = 1
        if votes[ vote ] then
            votes[ vote ] = votes[ vote ] + 1
        end
    end)

    SetType( GetWinner( votes ) )



end )

function GetWinner( tab )
    return table.GetWinningKey( tab )
end