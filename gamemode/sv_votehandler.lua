print( "sv_votehandler initialization..." )
util.AddNetworkString( "StartGMVote" )
util.AddNetworkString( "EndVote" )
util.AddNetworkString( "EndVoteCallback" )
util.AddNetworkString( "StartMapVote" )

hook.Add("GameEnd", "Start Voting", function()
    GAMEMODE:StartVoting()
end)

function GM:StartVoting()
    --Called when the game has completeted

    --//Separates the modes that have "Voteable" set to true from those that have it set to false/nil, and sends all clients the list of voteable modes
    self.voteableModes = { }
    for k, v in pairs(self.modes) do
        if v.Voteable then
            self.voteableModes[#self.voteableModes + 1] = {k, v.Name, v.Description}
            v.Votes = 0
        end

    end
    net.Start( "StartGMVote" )
        net.WriteTable( self.voteableModes )
    net.Broadcast()

    --After 30 seconds, set a winning mode, save it in a file - based on any received votes - and start the map vote
    --After another 30 seconds, set a winning map and change to it
    timer.Simple( 30, function()
        local winningMode, previousVote = {}, 0
        for k, v in pairs(self.voteableModes) do
            if GAMEMODE.modes[v[1]].Votes == previousVote then
                winningMode[#winningMode + 1] = v[1]
            elseif v.Votes > previousVote then
                table.Clear(winningMode)
                winningMode[1] = k
            end
        end
        if #winningMode == 1 then
            self.wonMode = winningMode[1]
        elseif #winningMode > 1 then
            self.wonMode = winningMode[math.random(1, #winningMode)]
        end
        self:SetVoteWinner( "mode", self.wonMode )
        
        net.Start( "EndVote" )
            net.WriteString( self.modes[self.wonMode].Name )
        net.Broadcast()

        timer.Simple( 5, function()
            net.Start( "StartMapVote" )
                net.WriteTable( self.availableMaps )
            net.Broadcast()
        end )

        timer.Simple( 35, function()
            local winningMap, previousVote = {}, 0
            for k, v in pairs(self.availableMaps) do
                if v.Votes == previousVote then
                    winningMap[#winningMap + 1] = k
                elseif v.Votes > previousVote then
                    table.Clear(winningMap)
                    winningMap[1] = k
                end
            end
            if #winningMap == 1 then
                self.wonMap = winningMap[1]
            elseif #winningMap > 1 then
                self.wonMap = winningMap[math.random(1, #winningMap)]
            end
            self:SetVoteWinner( "map", self.wonMap )

            net.Start( "EndVote" )
                net.WriteString( self.wonMap )
            net.Broadcast()
        end)
    end)

    net.Receive( "EndVoteCallback", function( len, ply )
        local playerVote = net.ReadString()
        for k, v in pairs(self.modes) do
            if self.voteableModes[playerVote].Name == v.Name then
                v.Votes = v.Votes + 1 
            end
        end
    end)
end

function GM:SetVoteWinner( type, winner )
    if type == "mode" then
        if not file.Exists( "onelife/nextmode", "DATA" ) then
	        file.CreateDir( "onelife/nextmode" )
        end
		file.Write( "onelife/nextmode/mode.txt", winner )
    elseif type == "map" then
        --Give client time to notify the player of the decision
        timer.Simple( 7, function()
            RunConsoleCommand( "changelevel", winner )
        end)
    end
end