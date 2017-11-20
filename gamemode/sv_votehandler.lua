print("sv_votehandler initialization...")
util.AddNetworkString("StartGMVote")
util.AddNetworkString("EndVote")
util.AddNetworkString("EndVoteCallback")
util.AddNetworkString("StartMapVote")

hook.Add("GameEnd", "Start Voting", function()
    GAMEMODE:StartVoting()
end)

function GM:StartVoting()
    --Called when the game has completeted

    --//Separates the modes that have "Voteable" set to true from those that have it set to false/nil, and sends all clients the list of voteable modes
    self.voteableModes = { }
    for k, v in pairs(self.modes) do
        if v.Voteable then self.voteableModes[#self.voteableModes + 1] = {k, v.Name, v.Description, Votes = 0} end
    end
    
    net.Start("StartGMVote")
        net.WriteTable(self.voteableModes)
    net.Broadcast()

    --After 30 seconds, set a winning mode, save it in a file - based on any received votes - and start the map vote
    --After another 30 seconds, set a winning map and change to it
    timer.Simple(30, function()
        --//Instead of "finishing" the voting and running a check, we just assume we've been receiving votes and run a check once the time is over
        self.winningMode = {}
        for k, v in pairs(self.voteableModes) do --Extract the needed information to run table.GetWinningKey
            self.winningMode[v[1]] = v.Votes
        end
        self.wonMode = table.GetWinningKey(self.winningMode)
        self:SetVoteWinner("mode", self.wonMode)
        self.doMapVote = true
        
        net.Start("EndVote")
            net.WriteString(self.modes[self.wonMode].Name)
        net.Broadcast()

        timer.Simple(5, function()
            net.Start("StartMapVote")
            net.Broadcast()
        end)

        timer.Simple(35, function()
            self.winningMap = {}
            for k, v in pairs(self.availableMaps) do --Extract the needed information to run table.GetWinningKey
                self.winningMap[v.Name] = v.Votes
            end
            self.wonMap = table.GetWinningKey(self.winningMap)
            self:SetVoteWinner("map", self.wonMap)

            net.Start("EndVote")
                net.WriteString(self.wonMap)
            net.Broadcast()
        end)
    end)

    net.Receive("EndVoteCallback", function(len, ply)
        local playerVote = net.ReadInt(4)

        if self.doMapVote then
            self.availableMaps[playerVote].Votes = self.availableMaps[playerVote].Votes + 1
        else
            self.voteableModes[playerVote].Votes = self.voteableModes[playerVote].Votes + 1
        end
    end)
end

function GM:SetVoteWinner(type, winner)
    if type == "mode" then
        if not file.Exists("onelife/nextmode", "DATA") then
	        file.CreateDir("onelife/nextmode")
        end
		file.Write("onelife/nextmode/mode.txt", winner)
    elseif type == "map" then
        --Give client time to notify the player of the decision
        timer.Simple(7, function()
            RunConsoleCommand("changelevel", winner)
        end)
    end
end