--[[
    surface.CreateFont( "", {
	font = "",
	size = 0,
	weight = 400
    italic = true
} )
https://wiki.garrysmod.com/page/surface/CreateFont

local bought = Material( "tdm/ic_done_white_24dp.png", "noclamp smooth" )
https://wiki.garrysmod.com/page/Global/Material
]]

-- http://lua-users.org/wiki/FormattingNumbers
local function comma_value( amount )
	local formatted = amount
	while true do  
		formatted, k = string.gsub( formatted, "^(-?%d+)(%d%d%d)", '%1,%2' )
		if ( k == 0 ) then
			break
		end
	end
	return formatted
end

hook.Add("InitPostEntity", "PrecacheWeaponModelsToPreventInitialMenuOpeningLag", function()
    for k, v in pairs(weapons.GetList()) do
		util.PrecacheModel( v.WorldModel )
	end
end)

function GM:LoadoutMenu()
    if self.Main then return end

    if not self.playerLevel then
        net.Start("RequestLevel")
		net.SendToServer()
		net.Receive("RequestLevelCallback", function(len, ply)
			self.playerLevel = tonumber(net.ReadString())
		end)
    end
    if not self.playerMoney then
        net.Start("RequestMoney")
		net.SendToServer()
		net.Receive("RequestMoneyCallback", function()
			self.playerMoney = tonumber(net.ReadString())
		end)
    end

	self.Main = vgui.Create("DFrame")
	self.Main:SetSize(ScrW() - 70, ScrH() - 70)
	self.Main:SetTitle("")
	self.Main:SetVisible(true)
	self.Main:SetDraggable(false)
	self.Main:ShowCloseButton(false)
	self.Main:MakePopup()
	self.Main:Center()
    self.Main.Paint = function()
		Derma_DrawBackgroundBlur(self.Main, CurTime())
		surface.SetDrawColor(0, 0, 0, 250)
        surface.DrawRect(0, 0, self.Main:GetWide(), self.Main:GetTall())
    end
	self.Main.Think = function()
		if customizeself.Main then
			customizeself.Main:MakePopup()
		end
	end

end

--//Similar to the menu system of Insurgency, players will select their roles in a separate menu
--//Plan: list all teammate's and their roles, and a summary of the enemy's roles
--//I would like the teammate and enemy role roster update dynamically
function GM:RoleMenu()
	if self.roleMain then return end

	self.roleMain = vgui.Create("DFrame")
	self.roleMain:SetSize(800, 600)
	self.roleMain:SetTitle("")
	self.roleMain:SetVisible(true)
	self.roleMain:SetDraggable(false)
	self.roleMain:ShowCloseButton(false)
	self.roleMain:MakePopup()
	self.roleMain:Center()
	self.roleMainX, self.roleMainY = self.roleMain:GetPos()
    self.roleMain.Paint = function()
		Derma_DrawBackgroundBlur(self.roleMain, CurTime())
		surface.SetDrawColor(0, 0, 0, 220)
        surface.DrawRect(0, 0, self.roleMain:GetWide(), self.roleMain:GetTall())
    end
	self.roleMain.Think = function()
		if self.roleMain then
			self.roleMain:MakePopup()
		end
	end

	self.roleMainBottomBarHeight = 100

	self.roleMainDesc = vgui.Create("DButton", self.roleMain)
	self.roleMainDesc:SetPos(0, self.roleMain:GetTall() - self.roleMainBottomBarHeight)
	self.roleMainDesc:SetSize(self.roleMain:GetWide() / 2, self.roleMainBottomBarHeight)
	self.roleMainDesc:SetText("")
	self.roleMainDesc.Paint = function()
		surface.SetDrawColor(180, 180, 180)
        surface.DrawRect(1, 1, w - 2, h - 2)
		draw.SimpleText("", self.font, w / 2, h / 2, Color(0, 0, 0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
	self.roleMainDesc.DoClick = function()
		--surface.PlaySound("")
		self.roleMain:Close()
		--Open new derma panel
	end
	self.roleMainDesc.OnCuursorEntered = function()
		self.roleMainDescHover = true
	end
	self.roleMainDesc.OnCursorExited = function()
		self.roleMainDescHover = false
	end

	self.roleMainArmor = vgui.Create("DButton", self.roleMain)
	self.roleMainArmor:SetPos(self.roleMain:GetWide() / 2, self.roleMain:GetTall() - self.roleMainBottomBarHeight)
	self.roleMainArmor:SetSize(self.roleMain:GetWide() / 2, self.roleMainBottomBarHeight)
	self.roleMainArmor:SetText("")
	self.roleMainArmor.Paint = function()

	end
	self.roleMainArmor.DoClick = function()
		--surface.PlaySound("")
		self.roleMain:Close()
		--Open new derma panel
	end
	self.roleMainArmor.OnCuursorEntered = function()

	end
	self.roleMainArmor.OnCursorExited = function()

	end
	
	--//When you select a role, display role-sepcific information, if it's an unlocked role, automatically select it
	--[[self.roleMainPanel = vgui.Create("DPanel", self.roleMain)
	self.roleMainPanel:SetSize(self.roleMain:GetWide(), self.roleMain:GetTall())
	self.roleMainPanel:SetPos(0, 0)
	self.roleMainPanel.Paint = function()
		surface.SetDrawColor()
		surface.DrawRect()
	end]]
	self.roleMainButtonWide = self.roleMain:GetWide() / 4
	self.roleMainButtonWideSpacer = (self.roleMain:GetWide() - (self.roleMainButtonWide * 3)) / 4
	self.roleMainButtonTall = (self.roleMain:GetTall() - self.roleMainBottomBarHeight) / 4
	self.roleMainButtonTallSpacer = ((self.roleMain:GetTall() - 0) - (self.roleMainButtonTall * 3)) / 4
	self.roleMainButtonPOS = {
		{x = self.roleMainButtonWideSpacer, y = self.roleMainButtonTallSpacer},
		{x = (self.roleMainButtonWideSpacer * 2) + self.roleMainButtonWide, y = self.roleMainButtonTallSpacer},
		{x = (self.roleMainButtonWideSpacer * 3) + (self.roleMainButtonWide * 2), y = self.roleMainButtonTallSpacer},
		{x = self.roleMainButtonWideSpacer, y = (self.roleMainButtonTallSpacer * 2) + self.roleMainButtonTall},
		{x = (self.roleMainButtonWideSpacer * 2) + self.roleMainButtonWide, y = (self.roleMainButtonTallSpacer * 2) + self.roleMainButtonTall},
		{x = (self.roleMainButtonWideSpacer * 3) + (self.roleMainButtonWide * 2), y = (self.roleMainButtonTallSpacer * 2) + self.roleMainButtonTall},
		{x = self.roleMainButtonWideSpacer, y = (self.roleMainButtonTallSpacer * 2) + (self.roleMainButtonTall * 2)},
		{x = (self.roleMainButtonWideSpacer * 2) + self.roleMainButtonWide, y = (self.roleMainButtonTallSpacer * 2) + (self.roleMainButtonTall * 2)},
		{x = (self.roleMainButtonWideSpacer * 3) + (self.roleMainButtonWide * 2), y = (self.roleMainButtonTallSpacer * 2) + (self.roleMainButtonTall * 2)}
	}
	if LocalPlayer():Team() == 1 then
		self.teamToRoleName = "redTeamName"
	elseif LocalPlayer():Team() == 2 then
		self.teamToRoleName = "blueTeamName"
	elseif LocalPlayer():Team() == 3 then
		self.teamToRoleName ="soloTeamName"
	end
	for k, v in pairs(self.roleMainButtonPOS) do
		local but = vgui.Create("RoleButton", self.roleMain, "but" .. k)
		but:SetPos(self.roleMainButtonPOS[k].x, self.roleMainButtonPOS[k].y)
		but:SetSize(self.roleMainButtonWide, self.roleMainButtonTall)
		but:SetText(self.Roles[k][self.teamToRoleName])
		if k == 2 then
			but:IsTitle(true)
		else
			if k > self.playerLevel then 
				but:IsLocked(true)
			else
				but.DoClick = function()
					self.roleMainButtonDown = but
					--surface.PlaySound("")
				end
			end
		end
	end

	self.roleTeam = vgui.Create("DFrame")
	self.roleTeam:SetSize(200, 400)
	self.roleTeam:SetPos(self.roleMainX - self.roleTeam:GetWide(), self.roleMainY + 100)
	self.roleTeamX, self.roleTeamY = self.roleTeam:GetPos()
	self.roleTeam:SetTitle("")
	self.roleTeam:SetVisible(true)
	self.roleTeam:SetDraggable(false)
	self.roleTeam:ShowCloseButton(false)
	self.roleTeam:MakePopup()
    self.roleTeam.Paint = function()
        draw.RoundedBoxEx(4, 0, 0, self.roleTeam:GetWide(), self.roleTeam:GetTall(), Color(0, 0, 0, 220), true, false, true, false)
		draw.SimpleText("Your Team", "DermaDefault", self.roleTeamScroll:GetWide() - 2, 2, Color(255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
    end
	self.roleTeam.Think = function()
		if not self.roleMain then
			self.roleTeam:Close()
			return
		end
		if self.roleTeam then
			self.roleTeam:MakePopup()
		end
	end

	self.roleTeamScroll = vgui.Create("DScrollPanel", self.roleTeam)
	self.roleTeamScroll:SetPos(0, 10)
	self.roleTeamScroll:SetSize(self.roleTeam:GetWide(), self.roleTeam:GetTall() - 10)
	self.roleTeamScroll.Paint = function()
		if not IsValid(self.roleTeamScroll:GetChildren()) then
			draw.RoundedBoxEx(4, 0, 0, self.roleTeam:GetWide(), self.roleTeam:GetTall(), Color(0, 0, 0, 100), true, false, true, false)
			draw.SimpleText("Loading Teammate Information", "DermaDefault", self.roleTeamScroll:GetWide() / 2, self.roleTeamScroll:GetTall() / 2, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
	end
	self.roleTeamScrollPanelHeight = 50
		--TO-DO
	--[[local sbar = self.roleTeamScroll:GetVBar()
	sbar.Paint = function()

	end]]

	--//Clears and recreates the roleTeamScroll scroll panel
	self:RefreshTeamRoles(teamTable)
		self.roleTeamScroll:Clear()

		local spacerPanelHeight = 5
		for k, v in pairs(teamTable) do
			local playerPanel = vgui.Create("DPanel", self.roleTeamScroll)
			playerPanel:SetPos(0, self.roleTeamScrollPanelHeight * (k - 1) + spacerPanelHeight * (k - 1))
			playerPanel:SetSize(self.roleTeamScroll:GetWide(), self.roleTeamScrollPanelHeight)
			playerPanel:SetText("")
			playerPanel.Paint = function()
				draw.SimpleText(v.Name, "DermaDefault", 5, playerPanel:GetTall() / 2, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
				draw.SimpleText("Role: " .. v.Role, "DermaDefault", playerPanel:GetWide() * (5 / 8), playerPanel:GetTall() / 2, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			end

			if teamTable[k + 1] then --If there's another player to add to the scroll panel, add a spacer panel
				local spacerPanel = vgui.Create("DPanel", self.roleTeamScroll)
				spacerPanel:SetPos(0, self.roleTeamScrollPanelHeight * k + spacerPanelHeight * (k - 1))
				spacerPanel:SetSize(self.roleTeamScroll:GetWide(), spacerPanelHeight)
				spacerPanel:SetText("")
				spacerPanel.Paint = function()
					surface.SetDrawColor(255, 255, 255)
					surface.DrawLine(2, 3, spacerPanel:GetWide() - 2, 3)
				end
			end
		end
	end

	net.Start("RequestTeamRoles")
	net.SendToServer()
	net.Receive("RequestTeamRolesCallback", function()
		local teamInfo = net.ReadTable()
		if self.roleTeamScroll then
			self:RefreshTeamRoles(teamInfo)
		end
	end)

	self.roleEnemy = vgui.Create("DFrame")
	self.roleEnemy:SetSize(200, 400)
	self.roleEnemy:SetPos(self.roleMainX + self.roleMain:GetWide(), self.roleMainY + 100)
	self.roleEnemyX, self.roleEnemyY = self.roleEnemy:GetPos()
	self.roleEnemy:SetTitle("")
	self.roleEnemy:SetVisible(true)
	self.roleEnemy:SetDraggable(false)
	self.roleEnemy:ShowCloseButton(false)
	self.roleEnemy:MakePopup()
		local textOffset = 10
    self.roleEnemy.Paint = function()
        draw.RoundedBoxEx(4, 0, 0, self.roleEnemy:GetWide(), self.roleEnemy:GetTall(), Color(0, 0, 0, 220), false, true, false, true)
		draw.SimpleText("Enemy Role Count", "DermaDefault", 2, 2, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
		--[[if not self.roleEnemyRoleCount then
			draw.RoundedBoxEx(4, 0, 0, self.roleEnemy:GetWide(), self.roleEnemy:GetTall(), Color(255, 252, 255, 220), false, true, false, true)
			draw.SimpleText("Loading Enemy Role Count", "DermaDefault", self.roleEnemy:GetWide() / 2, self.roleEnemy:GetTall() / 2, Color(0, 0, 0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end]]
    end
	self.roleEnemy.Think = function()
		if not self.roleMain then
			self.roleEnemy:Close()
			return
		end
		if self.roleEnemy then
			self.roleEnemy:MakePopup()
		end
	end

	self.roleEnemyScroll = vgui.Create("DScrollPanel", self.roleEnemy)
	self.roleEnemyScroll:SetPos(0, 10)
	self.roleEnemyScroll:SetSize(self.roleEnemy:GetWide(), self.roleEnemy:GetTall() - 10)
	self.roleEnemyScroll.Paint = function()
		if not IsValid(self.roleEnemyScroll:GetChildren()) then
			draw.RoundedBoxEx(4, 0, 0, self.roleEnemy:GetWide(), self.roleEnemy:GetTall(), Color(255, 252, 255, 220), false, true, false, true)
			draw.SimpleText("Loading Enemy Role Count", "DermaDefault", self.roleEnemy:GetWide() / 2, self.roleEnemy:GetTall() / 2, Color(0, 0, 0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
	end
	self.roleEnemyScrollPanelHeight = 50
		--TO-DO
	--[[local sbar = self.roleEnemyScroll:GetVBar()
	sbar.Paint = function()

	end]]

	--//Clears and recreates the roleEnemyScroll scroll panel
	self:RefreshEnemyRoles(enemyTable)
		self.roleEnemyScroll:Clear()

		local spacerPanelHeight = 5
		local counter = 1 --Need a counter this time around because the role name is saved as the key value in enemyTable
		for k, v in pairs(enemyTable) do
			local playerPanel = vgui.Create("DPanel", self.roleEnemyScroll)
			playerPanel:SetPos(0, self.roleEnemyScrollPanelHeight * (counter - 1) + spacerPanelHeight * (counter - 1))
			playerPanel:SetSize(self.roleEnemyScroll:GetWide(), self.roleEnemyScrollPanelHeight)
			playerPanel:SetText("")
			playerPanel.Paint = function()
				draw.SimpleText("Role: " .. k, "DermaDefault", 5, playerPanel:GetTall() / 2, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
				draw.SimpleText("Amount of players: " .. v, "DermaDefault", playerPanel:GetWide() * (3 / 4), playerPanel:GetTall() / 2, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			end

			if enemyTable[counter + 1] then --If there's another role to add to the scroll panel, add a spacer panel
				local spacerPanel = vgui.Create("DPanel", self.roleEnemyScroll)
				spacerPanel:SetPos(0, self.roleEnemyScrollPanelHeight * counter + spacerPanelHeight * (counter - 1))
				spacerPanel:SetSize(self.roleEnemyScroll:GetWide(), spacerPanelHeight)
				spacerPanel:SetText("")
				spacerPanel.Paint = function()
					surface.SetDrawColor(255, 255, 255)
					surface.DrawLine(2, 3, spacerPanel:GetWide() - 2, 3)
				end
			end
			counter = counter + 1
		end
	end

	net.Start("RequestEnemyRoles")
	net.SendToServer()
	net.Receive("RequestEnemyRolesCallback", function()
		self.roleEnemyRoleCount = net.ReadTable()
		self.RefreshEnemyRoles(self.roleEnemyRoleCount)
	end)
end