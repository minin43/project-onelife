surface.CreateFont("VoteDefault", {font = "BankGothic", size = 18})
surface.CreateFont("VoteDescription", {font = "BankGothic", size = 12})
surface.CreateFont("VoteTitle", {font = "BankGothic", size = 24})

--//Voting shit
net.Receive("StartGMVote", function()
	--//Format: number order = {1 = Game type name, 2 = Game type description}
	GAMEMODE.availableGametypes = net.ReadTable()
	PrintTable(GAMEMODE.availableGametypes)

	--//If, for some reason, client doesn't get ANY game types, prevent the creation of the panels and send the player an error
	if #GAMEMODE.availableGametypes < 1 then
		error("No gametypes were sent to client, preventing Vote panel creation, please contact gamemode owner to resolve the issue.")
	elseif LocalPlayer():Team() != 1 and LocalPlayer():Team() != 2 and LocalPlayer():Team() != 3 then
		LocalPlayer():ChatPrint("Gamemode vote has been started, but you're not on a team! You won't be able to vote next time unless you join one.")
		return
	end

	GAMEMODE.PANELWIDE = 300 --Does not account for any bordering done by paint functions
	GAMEMODE.voteMainTall = 24 + 3 --VoteTitle size + 3 + 3 for border/spacer on top

	GAMEMODE.availableGametypesMarkups = {}
	for k, v in ipairs(GAMEMODE.availableGametypes) do
		GAMEMODE.availableGametypesMarkups[k] = {
			markup.Parse("<font=VoteDefault><colour=" .. GAMEMODE.myTeam.menuTeamColor.r .. ", " .. GAMEMODE.myTeam.menuTeamColor.g .. ", " .. GAMEMODE.myTeam.menuTeamColor.b .. ">" .. k .. "</colour>. " .. v[2] .. "</font>", GAMEMODE.PANELWIDE),
			markup.Parse("<font=VoteDescription>" .. v[3] .. "</font>", GAMEMODE.PANELWIDE)
		}

		--//3rd & 4th values are the positions to draw the markup objects in the 1st and 2nd positions, respectively
		GAMEMODE.availableGametypesMarkups[k][3] = GAMEMODE.voteMainTall
		GAMEMODE.availableGametypesMarkups[k][4] = GAMEMODE.voteMainTall + GAMEMODE.availableGametypesMarkups[k][1]:GetHeight()

		--//Total height calculation for voteMain
		GAMEMODE.voteMainTall = GAMEMODE.voteMainTall + GAMEMODE.availableGametypesMarkups[k][1]:GetHeight() + GAMEMODE.availableGametypesMarkups[k][2]:GetHeight() + 5
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
		draw.SimpleText("Vote for a game type...", "VoteTitle", 3, 3, Color(GAMEMODE.myTeam.menuTeamColor.r, GAMEMODE.myTeam.menuTeamColor.g, GAMEMODE.myTeam.menuTeamColor.b), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)

		for k, v in pairs(GAMEMODE.availableGametypesMarkups) do
			v[1]:Draw(3, 2 + v[3], TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			v[2]:Draw(3, 1 + v[4], TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
		end
		if GAMEMODE.voteMain.selectedOption then
			surface.SetDrawColor(GAMEMODE.myTeam.menuTeamColorLightAccent.r, GAMEMODE.myTeam.menuTeamColorLightAccent.g, GAMEMODE.myTeam.menuTeamColorLightAccent.b)
			surface.DrawOutlinedRect(2, GAMEMODE.availableGametypesMarkups[GAMEMODE.voteMain.selectedOption][3], GAMEMODE.voteMain:GetWide() - 1, GAMEMODE.availableGametypesMarkups[GAMEMODE.voteMain.selectedOption][1]:GetHeight() + GAMEMODE.availableGametypesMarkups[GAMEMODE.voteMain.selectedOption][2]:GetHeight() + 5)
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
					net.WriteInt(GAMEMODE.voteMain.selectedOption, 4)
				net.SendToServer()
				LocalPlayer():ChatPrint("You voted for game type: " .. GAMEMODE.availableGametypes[GAMEMODE.voteMain.selectedOption][2])
				GAMEMODE.voteMain:SetKeyboardInputEnabled(false)
				return
			end
		end
	end
	GAMEMODE.voteMain:MoveTo(1, 100, 2)

	local dontuse
	net.Receive("EndVote", function()
		if dontuse then return end
		dontuse = true
		GAMEMODE.winnerGameType = net.ReadString()

		GAMEMODE.winnerMainMarkup = markup.Parse("<font=VoteDefault>The winning mode is:\n</font><font=VoteTitle>    <colour=" .. GAMEMODE.myTeam.menuTeamColor.r .. ", " .. GAMEMODE.myTeam.menuTeamColor.g .. ", " .. GAMEMODE.myTeam.menuTeamColor.b .. ">" .. GAMEMODE.winnerGameType .. "</colour></font>", GAMEMODE.PANELWIDE) -- GAMEMODE.PANELWIDE same # as GAMEMODE.winnerMain x size
		GAMEMODE.winnerMainTall = GAMEMODE.winnerMainMarkup:GetHeight()

		GAMEMODE.winnerMain = vgui.Create("DFrame")
		GAMEMODE.winnerMain:SetSize(GAMEMODE.PANELWIDE, GAMEMODE.winnerMainTall + 6)
		GAMEMODE.winnerMain:SetPos(-1 - GAMEMODE.PANELWIDE, 100)
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
		GAMEMODE.voteMain:MoveTo(-1 - GAMEMODE.PANELWIDE, 100, 2)
		timer.Simple(2.1, function()
			GAMEMODE.winnerMain:MoveTo(1, 100, 2)
		end)
	end)
end)

net.Receive("StartMapVote", function()

	if LocalPlayer():Team() != 1 and LocalPlayer():Team() != 2 and LocalPlayer():Team() != 3 then
		LocalPlayer():ChatPrint("Map vote has been started, but you're not on a team! You won't be able to vote next time unless you join one.")
		return
	end

	GAMEMODE.voteMain2Tall = 24 + 3 --Font size of VoteTitle + 3 + 3 for a spacer above and below the title

	for k, v in pairs(GAMEMODE.availableMaps) do
		v.Markup = markup.Parse("<font=VoteDefault><colour=" .. GAMEMODE.myTeam.menuTeamColor.r .. ", " .. GAMEMODE.myTeam.menuTeamColor.g .. ", " .. GAMEMODE.myTeam.menuTeamColor.b .. ">" .. k .. "</colour>. " .. v.Name .. "</font>")
		if GAMEMODE.availableMaps[k - 1] then
			v.markupPosition = GAMEMODE.availableMaps[k - 1].markupPosition + GAMEMODE.availableMaps[k - 1].Markup:GetHeight() + 4 --1 pixel border and 1 pixel spacer between edge and text * 2 for top and bottom
		else
			v.markupPosition = GAMEMODE.voteMain2Tall --We should only ever run this else statement for the first map in the list
		end
		GAMEMODE.voteMain2Tall = GAMEMODE.voteMain2Tall + v.Markup:GetHeight() + 4
	end

	GAMEMODE.voteMain2 = vgui.Create("DFrame")
	GAMEMODE.voteMain2:SetSize(GAMEMODE.PANELWIDE, GAMEMODE.voteMain2Tall)
	GAMEMODE.voteMain2:SetPos(-1 - GAMEMODE.PANELWIDE, 100 + GAMEMODE.winnerMain:GetTall() + 2)
	GAMEMODE.voteMain2:SetTitle("")
	GAMEMODE.voteMain2:SetVisible(true)
	GAMEMODE.voteMain2:SetDraggable(false)
	GAMEMODE.voteMain2:ShowCloseButton(false)
	GAMEMODE.voteMain2.Paint = function()
		surface.SetDrawColor(GAMEMODE.myTeam.menuTeamColorDarkAccent.r, GAMEMODE.myTeam.menuTeamColorDarkAccent.g, GAMEMODE.myTeam.menuTeamColorDarkAccent.b)
		surface.DrawRect(0, 0, GAMEMODE.voteMain2:GetSize())
		surface.SetDrawColor(GAMEMODE.myTeam.menuTeamColorAccent.r, GAMEMODE.myTeam.menuTeamColorAccent.g, GAMEMODE.myTeam.menuTeamColorAccent.b)
		surface.DrawOutlinedRect(0, 0, GAMEMODE.voteMain2:GetWide(), GAMEMODE.voteMain2:GetTall())
		draw.SimpleText("Vote for a map...", "VoteTitle", 3, 3, Color(GAMEMODE.myTeam.menuTeamColor.r, GAMEMODE.myTeam.menuTeamColor.g, GAMEMODE.myTeam.menuTeamColor.b), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)

		for k, v in pairs(GAMEMODE.availableMaps) do
			v.Markup:Draw(3, v.markupPosition + 2, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
		end
		if GAMEMODE.voteMain2.selectedOption then
			surface.SetDrawColor(GAMEMODE.myTeam.menuTeamColorLightAccent.r, GAMEMODE.myTeam.menuTeamColorLightAccent.g, GAMEMODE.myTeam.menuTeamColorLightAccent.b)
			surface.DrawOutlinedRect(1, GAMEMODE.availableMaps[GAMEMODE.voteMain2.selectedOption].markupPosition, GAMEMODE.voteMain2:GetWide() - 1, GAMEMODE.availableMaps[GAMEMODE.voteMain2.selectedOption].Markup:GetHeight() + 4)
		end
	end
	GAMEMODE.voteMain2.Think = function()
		if GAMEMODE.voteMain2.selectedOption then 
			return 
		end
		for k, v in pairs(GAMEMODE.keyEnumsTable) do
			if input.IsKeyDown(v) and GAMEMODE.availableMaps[k] then
				GAMEMODE.voteMain2.selectedOption = k
				net.Start("EndVoteCallback")
					net.WriteInt(GAMEMODE.voteMain2.selectedOption, 4)
				net.SendToServer()
				LocalPlayer():ChatPrint("You voted for map: " .. GAMEMODE.availableMaps[GAMEMODE.voteMain2.selectedOption].Name)
				GAMEMODE.voteMain2:SetKeyboardInputEnabled(false)
				return
			end
		end
	end
	GAMEMODE.voteMain2:MoveTo(1, 100 + GAMEMODE.winnerMain:GetTall() + 2, 2)

	net.Receive("EndVote", function()
		GAMEMODE.winnerMap = net.ReadString()

		GAMEMODE.winnerMain2Markup = markup.Parse("<font=VoteDefault>The winning map is:\n</font><font=VoteTitle>    <colour=" .. GAMEMODE.myTeam.menuTeamColor.r .. ", " .. GAMEMODE.myTeam.menuTeamColor.g .. ", " .. GAMEMODE.myTeam.menuTeamColor.b .. ">" .. GAMEMODE.winnerMap .. "</font>", GAMEMODE.PANELWIDE)
		GAMEMODE.winnerMain2Tall = GAMEMODE.winnerMain2Markup:GetHeight()

		GAMEMODE.winnerMain2 = vgui.Create("DFrame")
		GAMEMODE.winnerMain2:SetSize(GAMEMODE.PANELWIDE + 6, GAMEMODE.winnerMain2Tall + 6)
		GAMEMODE.winnerMain2:SetPos(-1 - GAMEMODE.PANELWIDE, 100 + GAMEMODE.winnerMain:GetTall() + 2)
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
		GAMEMODE.voteMain2:MoveTo(-1 - GAMEMODE.PANELWIDE, 100 + GAMEMODE.winnerMain:GetTall() + 2, 2)
		timer.Simple(2.1, function()
			GAMEMODE.winnerMain2:MoveTo(1, 100 + GAMEMODE.winnerMain:GetTall() + 2, 2)
		end)
	end)
end)