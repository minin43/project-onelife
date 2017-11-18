surface.CreateFont("VoteDefault", {font = "BankGothic", size = 18})
surface.CreateFont("VoteDescription", {font = "BankGothic", size = 9})
surface.CreateFont("VoteTitle", {font = "BankGothic", size = 27})

--//Voting shit
net.Receive("StartGMVote", function()
	--//Format: number order = {1 = Game type name, 2 = Game type description}
	GAMEMODE.availableGametypes = net.ReadTable()

	--//If, for some reason, client doesn't get ANY game types, prevent the creation of the panels and send the player an error
	if #GAMEMODE.availableGametypes < 1 then
		error("No gametypes were sent to client, preventing Vote panel creation, please contact gamemode owner to resolve the issue.")
	end

	GAMEMODE.PANELWIDE = 200 --Does not account for any bordering done by paint functions
	GAMEMODE.voteMainTall = 27 + 1--Same # as VoteTile size, since that's the title

	GAMEMODE.availableGametypesMarkups = {}
	for k, v in ipairs(GAMEMODE.availableGametypes) do
		GAMEMODE.availableGametypesMarkups[k] = {
			markup.Parse("<font=VoteDefault>" .. k .. ". " .. v[1] .. "</font>", GAMEMODE.PANELWIDE),
			markup.Parse("<font=VoteDescription>" .. v[2] .. "</font>", GAMEMODE.PANELWIDE)
		}
		--//3rd & 4th values are the positions to draw the markup objects in the 1st and 2nd positions, respectively
		GAMEMODE.availableGametypesMarkups[k][3] = (GAMEMODE.availableGametypesMarkups[k - 1][3] or 0) + GAMEMODE.availableGametypesMarkups[k][1]:GetHeight() + 1
		GAMEMODE.availableGametypesMarkups[k][4] = (GAMEMODE.availableGametypesMarkups[k - 1][4] or 0) + GAMEMODE.availableGametypesMarkups[k][2]:GetHeight() + 1

		--//Total height calculation for voteMain
		GAMEMODE.voteMainTall = GAMEMODE.voteMainTall + GAMEMODE.availableGametypesMarkups[k][1]:GetHeight() + GAMEMODE.availableGametypesMarkups[k][2]:GetHeight()
	end

	GAMEMODE.voteMain = vgui.Create("DFrame")
	GAMEMODE.voteMain:SetSize(GAMEMODE.PANELWIDE + 6, GAMEMODE.voteMainTall + 12 + (3 * #GAMEMODE.availableGametypes))
	GAMEMODE.voteMain:SetPos(-1 - GAMEMODE.PANELWIDE, 100)
	GAMEMODE.voteMain:SetTitle("")
	GAMEMODE.voteMain:SetVisible(true)
	GAMEMODE.voteMain:SetDraggable(false)
	GAMEMODE.voteMain:ShowCloseButton(false)
	GAMEMODE.voteMain.Paint = function()
		surface.SetDrawColor(GAMEMODE.myTeam.menuTeamColorDarkAccent.r, GAMEMODE.myTeam.menuTeamColorDarkAccent.g, GAMEMODE.myTeam.menuTeamColorDarkAccent.b)
		surface.DrawRect(0, 0, GAMEMODE.voteMain:GetSize())
		surface.SetDrawColor(GAMEMODE.myTeam.menuTeamColorAccent.r, GAMEMODE.myTeam.menuTeamColorAccent.g, GAMEMODE.myTeam.menuTeamColorAccent.b)
		surface.DrawOutlinedRect(1, 1, GAMEMODE.voteMain:GetWide() - 1, GAMEMODE.voteMain:GetTall() - 1)
		draw.DrawText("Vote for a game type...", "VoteTitle", 3, 3)

		for k, v in pairs(GAMEMODE.availableGametypesMarkups) do
			v[1]:Draw(3, 27 + 3 + v[3], TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			v[2]:Draw(3, 27 + 3 + v[4], TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
		end
		if GAMEMODE.voteMain.selectedOption then
			surface.SetDrawColor(GAMEMODE.myTeam.menuTeamColorLightAccent.r, GAMEMODE.myTeam.menuTeamColorLightAccent.g, GAMEMODE.myTeam.menuTeamColorLightAccent.b)
			surface.DrawOutlinedRect(1, 27 + 3 + GAMEMODE.availableGametypesMarkups[GAMEMODE.voteMain.selectedOption][3], GAMEMODE.voteMain:GetWide() - 1, 27 + 3 + GAMEMODE.availableGametypesMarkups[GAMEMODE.voteMain.selectedOption][4])
		end
	end
	GAMEMODE.keyEnumsTable = {KEY_1, KEY_2, KEY_3, KEY_4, KEY_5, KEY_6, KEY_7, KEY_8, KEY_9}
	GAMEMODE.voteMain.Think = function()
		if GAMEMODE.voteMain.selectedOption then 
			return 
		end
		for k, v in pairs(GAMEMODE.keyEnumsTable) do
			if input.IsKeyDown(v) and GAMEMODE.availableGametypes[k] then
				GAMEMODE.voteMain.selectedOption = k
				net.Start("EndVoteCallback")
					net.WriteString(GAMEMODE.availableGametypes[GAMEMODE.voteMain.selectedOption].Name)
				net.SendToServer()
				LocalPlayer():ChatPrint("You voted for game type: " .. GAMEMODE.availableGametypes[GAMEMODE.voteMain.selectedOption].Name)
				GAMEMODE.voteMain:SetKeyboardInputEnabled(false)
				return
			end
		end
	end
	GAMEMODE.voteMain:MoveTo( 1, 100, 2 )

	local dontuse
	net.Receive("EndVote", function()
		if dontuse then return end
		dontuse = true
		GAMEMODE.winnerGameType = net.ReadString()

		GAMEMODE.winnerMainMarkup = markup.Parse("<font=VoteDefault>The winning mode is:\n</font><font=VoteTitle>    " .. GAMEMODE.winnerGameType .. "</font>", 200) -- 200 same # as GAMEMODE.winnerMain x size
		GAMEMODE.winnerMainTall = GAMEMODE.winnerMainMarkup:GetHeight()

		GAMEMODE.winnerMain = vgui.Create("DFrame")
		GAMEMODE.winnerMain:SetSize(200 + 6, GAMEMODE.winnerMainTall + 6)
		GAMEMODE.winnerMain:SetPos(-201, 100)
		GAMEMODE.winnerMain:SetTitle("")
		GAMEMODE.winnerMain:SetVisible(true)
		GAMEMODE.winnerMain:SetDraggable(false)
		GAMEMODE.winnerMain:ShowCloseButton(false)
		--GAMEMODE.winnerMain:MakePopup()
		--GAMEMODE.winnerMain:SetMouseInputEnabled(false)
		--GAMEMODE.winnerMain:SetKeyboardInputEnabled(false)
		GAMEMODE.winnerMain.Paint = function()
			surface.SetDrawColor(GAMEMODE.myTeam.menuTeamColorDarkAccent.r, GAMEMODE.myTeam.menuTeamColorDarkAccent.g, GAMEMODE.myTeam.menuTeamColorDarkAccent.b)
			surface.DrawRect(0, 0, GAMEMODE.winnerMain:GetSize())
			surface.SetDrawColor(GAMEMODE.myTeam.menuTeamColorAccent.r, GAMEMODE.myTeam.menuTeamColorAccent.g, GAMEMODE.myTeam.menuTeamColorAccent.b)
			surface.DrawOutlinedRect(1, 1, GAMEMODE.winnerMain:GetWide() - 1, GAMEMODE.winnerMain:GetTall() - 1)
			GAMEMODE.winnerMainMarkup:Draw(GAMEMODE.winnerMain:GetWide() / 2, 3, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
		end
		GAMEMODE.voteMain:MoveTo( -201, 100, 2 )
		timer.Simple( 2.1, function()
			GAMEMODE.winnerMain:MoveTo( 1, 100, 2 )
		end )
	end )
end )

net.Receive("StartMapVote", function()
	GAMEMODE.availableMaps = net.ReadTable()

	GAMEMODE.voteMain2Tall = #GAMEMODE.availableMaps * (18 + 1) --font size of VoteDefault

	GAMEMODE.voteMain2 = vgui.Create("DFrame")
	GAMEMODE.voteMain2:SetSize(200, GAMEMODE.voteMain2Tall + 27 + 4)
	GAMEMODE.voteMain2:SetPos(-201, 100 + GAMEMODE.winnerMain:GetTall() + 2)
	GAMEMODE.voteMain2:SetTitle("")
	GAMEMODE.voteMain2:SetVisible(true)
	GAMEMODE.voteMain2:SetDraggable(false)
	GAMEMODE.voteMain2:ShowCloseButton(false)
	GAMEMODE.voteMain2.Paint = function()
		surface.SetDrawColor(GAMEMODE.myTeam.menuTeamColorDarkAccent.r, GAMEMODE.myTeam.menuTeamColorDarkAccent.g, GAMEMODE.myTeam.menuTeamColorDarkAccent.b)
		surface.DrawRect(0, 0, GAMEMODE.voteMain2:GetSize())
		surface.SetDrawColor(GAMEMODE.myTeam.menuTeamColorAccent.r, GAMEMODE.myTeam.menuTeamColorAccent.g, GAMEMODE.myTeam.menuTeamColorAccent.b)
		surface.DrawOutlinedRect(1, 1, GAMEMODE.voteMain2:GetWide() - 1, GAMEMODE.voteMain2:GetTall() - 1)
		draw.DrawText("Vote for a map...", "VoteTitle", 3, 3 )

		for k, v in pairs(maps) do
			draw.DrawText( k .. ". " .. v, "VoteDefault", 3, 18 * ( k - 1 ) + 27 + 4 )
		end
		if GAMEMODE.voteMain2.selectedOption then
			surface.SetDrawColor( 255, 255, 255 )
			surface.DrawOutlinedRect( 0, 17 * ( selectedOption - 1 ) + 2 + 22, GAMEMODE.voteMain2:GetWide(), 15 )
		end
	end
	GAMEMODE.voteMain2.Think = function()
		if GAMEMODE.voteMain2.selectedOption then 
			return 
		end
		for k, v in pairs(GAMEMODE.keyEnumsTable) do
			if input.IsKeyDown(v) then
				GAMEMODE.voteMain2.selectedOption = k
				net.Start("EndVoteCallback")
					net.WriteString(maps[GAMEMODE.voteMain2.selectedOption])
				net.SendToServer()
				LocalPlayer():ChatPrint("You selected option: " .. maps[GAMEMODE.voteMain2.selectedOption])
				GAMEMODE.voteMain2:SetKeyboardInputEnabled(false)
				return
			end
		end
	end
	GAMEMODE.voteMain2:MoveTo(1, 100 + GAMEMODE.winnerMain:GetTall() + 2, 2)

	net.Receive("EndVote", function()
		GAMEMODE.winnerMap = net.ReadString()

		GAMEMODE.winnerMain2Markup = markup.Parse("<font=VoteDefault>The winning map is:\n</font><font=VoteTitle>    " .. GAMEMODE.winnerMap .. "</font>", 200)
		GAMEMODE.winnerMain2Tall = GAMEMODE.winnerMain2Markup:GetHeight()

		GAMEMODE.winnerMain2 = vgui.Create("DFrame")
		GAMEMODE.winnerMain2:SetSize(200 + 6, GAMEMODE.winnerMain2Tall + 6)
		GAMEMODE.winnerMain2:SetPos(-201, 100 + GAMEMODE.winnerMain:GetTall() + 2)
		GAMEMODE.winnerMain2:SetTitle("")
		GAMEMODE.winnerMain2:SetVisible(true)
		GAMEMODE.winnerMain2:SetDraggable(false)
		GAMEMODE.winnerMain2:ShowCloseButton(false)
		--GAMEMODE.winnerMain2:MakePopup()
		--GAMEMODE.winnerMain2:SetMouseInputEnabled(false)
		--GAMEMODE.winnerMain2:SetKeyboardInputEnabled(false)
		GAMEMODE.winnerMain2.Paint = function()
			surface.SetDrawColor(GAMEMODE.myTeam.menuTeamColorDarkAccent.r, GAMEMODE.myTeam.menuTeamColorDarkAccent.g, GAMEMODE.myTeam.menuTeamColorDarkAccent.b)
			surface.DrawRect(0, 0, GAMEMODE.winnerMain2:GetSize())
			surface.SetDrawColor(GAMEMODE.myTeam.menuTeamColorAccent.r, GAMEMODE.myTeam.menuTeamColorAccent.g, GAMEMODE.myTeam.menuTeamColorAccent.b)
			surface.DrawOutlinedRect(1, 1, GAMEMODE.winnerMain2:GetWide() - 1, GAMEMODE.winnerMain2:GetTall() - 1)
			GAMEMODE.winnerMain2Markup:Draw(3, 3, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
		end
		GAMEMODE.voteMain2:MoveTo(-201, 100 + GAMEMODE.winnerMain:GetTall() + 2, 2)
		timer.Simple(2.1, function()
			GAMEMODE.winnerMain2:MoveTo(1, 100 + GAMEMODE.winnerMain:GetTall() + 2, 2)
		end )
	end )
end )