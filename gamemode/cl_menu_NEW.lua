--[[Sounds descriptions + name 
(all in directory buttons/_.wav)
- "Failure" sound - button2.wav
- Another "failure" sound - button8.wav
- High-pitched "success" sound - button24.wav
- Lower-pitched "success" sound - button3.wav
- Locked option sound - combine_button_locked.wav
- Light "click" - lightswitch2.wav

(all in directory ui/_.wav)
- Basic Gmod menu "click" - buttonclick.wav
- Basic Gmod menu "back" - buttonclickrelease.wav
- Basic Gmod menu "hover" - buttonrollover.wav
]]

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

--[[hook.Add("InitPostEntity", "PrecacheWeaponModelsToPreventInitialMenuOpeningLag", function() --DISABLED until I stop getting those client errors
    for k, v in pairs(weapons.GetList()) do
		util.PrecacheModel( v.WorldModel )
	end
end)]]

GM.teamNumberToName = {"redTeamName", "blueTeamName", "soloTeamName"}

function GM:LoadoutMenu()
	if self.Main and self.Main:IsValid() then return end

	if not self.roleMainButtonNumber then
		self:RoleSelectionMenu()
		return
	end

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
	self.Main:SetSize(800, 600)
	self.Main:SetTitle("")
	self.Main:SetVisible(true)
	self.Main:SetDraggable(false)
	self.Main:ShowCloseButton(false)
	self.Main:MakePopup()
	self.Main:Center()
    self.Main.Paint = function()
		--Derma_DrawBackgroundBlur(self.Main, CurTime())
		surface.SetDrawColor(0, 0, 0, 250)
        surface.DrawRect(0, 0, self.Main:GetWide(), self.Main:GetTall())
    end
	self.Main.Think = function()
		if self.Main:IsValid() then
			self.Main:MakePopup()
		end
	end

	self.playerInfoMainPictureSize = 64
	self.playerInfoMain = vgui.Create("DPanel", self.Main)
	self.playerInfoMain:SetPos(0, 0)
	self.playerInfoMain:SetSize(self.Main:GetWide(), self.playerInfoMainPictureSize + 4)
	self.playerInfoMainHalf = self.playerInfoMain:GetWide() / 2
	self.playerInfoMain.Paint = function()
		draw.SimpleText(LocalPlayer():Nick(), "DermaLarge", self.playerInfoMainPictureSize + 6, self.playerInfoMainPictureSize / 4, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		draw.SimpleText(LocalPlayer():SteamID(), "DermaLarge", self.playerInfoMainPictureSize + 6, self.playerInfoMainPictureSize * (3 / 4), Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		draw.SimpleText("Role: " .. self.Roles[self.roleMainButtonNumber][self.teamNumberToName[LocalPlayer():Team()]], "DermaLarge", self.playerInfoMain:GetWide() / 2, self.playerInfoMainPictureSize / 4, Color( 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		draw.SimpleText("Armor: " .. self.Roles[self.roleMainButtonNumber].armorRating.armorName, "DermaLarge", self.playerInfoMain:GetWide() / 2, self.playerInfoMainPictureSize * (3 / 4), Color( 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

		surface.SetDrawColor(255, 255, 255)
		surface.DrawLine(self.playerInfoMain:GetWide() / 2 - 6, 2,  self.playerInfoMain:GetWide() / 2 - 6, self.playerInfoMain:GetTall() - 2)
	end

	self.playerInfoMainPicture = vgui.Create("AvatarImage", self.playerInfoMain)
	self.playerInfoMainPicture:SetPos(2, 2)
	self.playerInfoMainPicture:SetSize(self.playerInfoMainPictureSize, self.playerInfoMainPictureSize)
	self.playerInfoMainPicture:SetPlayer(LocalPlayer(), 64)

	self.playerInfoMainShop = vgui.Create("DButton", self.playerInfoMain)
	self.playerInfoMainShop:SetSize(self.playerInfoMainPictureSize, self.playerInfoMainPictureSize)
	self.playerInfoMainShop:SetPos(self.playerInfoMain:GetWide() - self.playerInfoMainPictureSize)
	self.playerInfoMainShop:SetText("")
	self.playerInfoMainShop.DoClick = function()
		surface.PlaySound("buttons/lightswitch2.wav")
		--Insert shop menu function here
		self.Main:Remove() --Just here temporarily
	end
	self.playerInfoMainShop.Paint = function()
		surface.SetDrawColor(175, 175, 175)
		surface.SetMaterial(Material("something"))
		surface.DrawTexturedRect(1, 1, self.playerInfoMainShop:GetWide() - 1, self.playerInfoMainShop:GetTall() - 1)
		
		if self.playerInfoMainShop.hover then
			surface.SetDrawColor(255, 255, 255)
			surface.DrawTexturedRect(1, 1, self.playerInfoMainShop:GetWide() - 1, self.playerInfoMainShop:GetTall() - 1)
			surface.DrawOutlinedRect(0, 0, self.playerInfoMainShop:GetWide(), self.playerInfoMainShop:GetTall())
		end
	end
	self.playerInfoMainShop.OnCursorEntered = function()
		surface.PlaySound("garrysmod/ui_hover.wav")
		self.playerInfoMainShop.hover = true
	end
	self.playerInfoMainShop.OnCursorExited = function()
		self.playerInfoMainShop.hover = false
	end

	self.weaponPanelHeight = 150
	self.playerInfoMainPrimary = vgui.Create("WeaponMenuPanel", self.Main)
	self.playerInfoMainPrimary:SetSize(self.Main:GetWide(), self.weaponPanelHeight)
	self.playerInfoMainPrimary:SetPos(0, self.weaponPanelHeight)
	self.playerInfoMainPrimary:SetWep("cw_kk_ins2_ak74", "primary")
	self.playerInfoMainPrimary:SetAttach("kk_ins2_aimpoint", "kk_ins2_pbs5", nil, nil, "kk_ins2_fnfal_skins")
	self.playerInfoMainPrimary:Finish()

	self.playerInfoMainSecondary = vgui.Create("WeaponMenuPanel", self.Main)
	self.playerInfoMainSecondary:SetSize(self.Main:GetWide(), self.weaponPanelHeight)
	self.playerInfoMainSecondary:SetPos(0, self.weaponPanelHeight * 2 + 1)
	self.playerInfoMainSecondary:SetWep("cw_kk_ins2_m9", "secondary")
	self.playerInfoMainSecondary:Finish()

	self.playerInfoMainEquipment = vgui.Create("WeaponMenuPanel", self.Main)
	self.playerInfoMainEquipment:SetSize(self.Main:GetWide(), self.weaponPanelHeight)
	self.playerInfoMainEquipment:SetPos(0, self.weaponPanelHeight * 3 + 2)
	self.playerInfoMainEquipment:SetWep("cw_kk_ins2_nade_m67", "equipment")
	self.playerInfoMainEquipment:Finish()
end

--//Similar to the menu system of Insurgency, players will select their roles in a separate menu
--//Plan: list all teammate's and their roles, and a summary of the enemy's roles
--//I would like the teammate and enemy role roster update dynamically
function GM:RoleSelectionMenu()
	if self.roleMain and self.roleMain:IsValid() then return end

    net.Start("RequestLevel")
	net.SendToServer()

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
		--Derma_DrawBackgroundBlur(self.roleMain, CurTime())
		surface.SetDrawColor(0, 0, 0, 220)
        surface.DrawRect(0, 0, self.roleMain:GetWide(), self.roleMain:GetTall())
    end
	self.roleMain.Think = function()
		if self.roleMain:IsValid() then
			self.roleMain:MakePopup()
		end
	end

	self.roleMainBottomBarHeight = 50

	self.roleMainDesc = vgui.Create("DButton", self.roleMain)
	self.roleMainDesc:SetPos(0, self.roleMain:GetTall() - self.roleMainBottomBarHeight)
	self.roleMainDesc:SetSize(self.roleMain:GetWide() / 2, self.roleMainBottomBarHeight)
	self.roleMainDesc:SetText("")
	self.roleMainDesc.Paint = function()
		local w, h = self.roleMainDesc:GetSize()
		surface.SetDrawColor(180, 180, 180)
		surface.DrawRect(1, 1, w - 2, h - 2)
		if self.roleMainButtonNumber then
			draw.SimpleText("Role Description: " .. self.Roles[self.roleMainButtonNumber]["roleDescription"], "DermaDefault", w / 2, h / 2, Color(0, 0, 0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		else
			draw.SimpleText("Role Description: None selected.", "DermaDefault", w / 2, h / 2, Color(0, 0, 0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end

		if self.roleMainDescHover then
			surface.SetDrawColor(255, 255, 255)
            surface.DrawOutlinedRect(0, 0, w, h)
		end
	end
	self.roleMainDesc.DoClick = function()
		if not self.roleMainButtonNumber then return end
		surface.PlaySound("buttons/lightswitch2.wav")
		self.roleMain:Remove()
		self:RoleDescriptions(self.roleMainButtonNumber)
	end
	self.roleMainDesc.OnCursorEntered = function()
		if not self.roleMainButtonNumber then return end
		self.roleMainDescHover = true
		surface.PlaySound("garrysmod/ui_hover.wav")
	end
	self.roleMainDesc.OnCursorExited = function()
		self.roleMainDescHover = false
	end

	self.roleMainArmor = vgui.Create("DButton", self.roleMain)
	self.roleMainArmor:SetPos(self.roleMain:GetWide() / 2, self.roleMain:GetTall() - self.roleMainBottomBarHeight)
	self.roleMainArmor:SetSize(self.roleMain:GetWide() / 2, self.roleMainBottomBarHeight)
	self.roleMainArmor:SetText("")
	self.roleMainArmor.Paint = function()
		local w, h = self.roleMainArmor:GetSize()
		surface.SetDrawColor(180, 180, 180)
		surface.DrawRect(1, 1, w - 2, h - 2)
		if self.roleMainButtonNumber then
			draw.SimpleText("Armor Type: " .. self.Roles[self.roleMainButtonNumber]["armorRating"].armorName or "None", self.font, w / 2, h / 2, Color(0, 0, 0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		else
			draw.SimpleText("Armor type: None.", self.font, w / 2, h / 2, Color(0, 0, 0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
		if self.roleMainArmorHover then
			surface.SetDrawColor(255, 255, 255)
            surface.DrawOutlinedRect(0, 0, w, h)
		end
	end
	self.roleMainArmor.DoClick = function()
		if not self.roleMainButtonNumber then return end
		surface.PlaySound("buttons/lightswitch2.wav")
		self.roleMain:Remove()
		self:ArmorDescription(self.roleMainButtonNumber)
	end
	self.roleMainArmor.OnCursorEntered = function()
		if not self.roleMainButtonNumber then return end
		self.roleMainArmorHover = true
		surface.PlaySound("garrysmod/ui_hover.wav")
	end
	self.roleMainArmor.OnCursorExited = function()
		self.roleMainArmorHover = false
	end
	
	self.roleMainButtonWide = self.roleMain:GetWide() / 4
	self.roleMainButtonWideSpacer = (self.roleMain:GetWide() - (self.roleMainButtonWide * 3)) / 4
	self.roleMainButtonTall = (self.roleMain:GetTall() - self.roleMainBottomBarHeight) / 4
	self.roleMainButtonTallSpacer = ((self.roleMain:GetTall() - self.roleMainBottomBarHeight) - (self.roleMainButtonTall * 3)) / 4
	self.roleMainButtonPOS = {
		[1] = {x = self.roleMainButtonWideSpacer, 										y = self.roleMainButtonTallSpacer},
		[2] = {x = (self.roleMainButtonWideSpacer * 2) + self.roleMainButtonWide, 		y = self.roleMainButtonTallSpacer},
		[3] = {x = (self.roleMainButtonWideSpacer * 3) + (self.roleMainButtonWide * 2), y = self.roleMainButtonTallSpacer},
		[4] = {x = self.roleMainButtonWideSpacer, 										y = (self.roleMainButtonTallSpacer * 2) + self.roleMainButtonTall},
		[5] = {x = (self.roleMainButtonWideSpacer * 2) + self.roleMainButtonWide, 		y = (self.roleMainButtonTallSpacer * 2) + self.roleMainButtonTall},
		[6] = {x = (self.roleMainButtonWideSpacer * 3) + (self.roleMainButtonWide * 2), y = (self.roleMainButtonTallSpacer * 2) + self.roleMainButtonTall},
		[7] = {x = self.roleMainButtonWideSpacer, 										y = (self.roleMainButtonTallSpacer * 3) + (self.roleMainButtonTall * 2)},
		[8] = {x = (self.roleMainButtonWideSpacer * 2) + self.roleMainButtonWide, 		y = (self.roleMainButtonTallSpacer * 3) + (self.roleMainButtonTall * 2)},
		[9] = {x = (self.roleMainButtonWideSpacer * 3) + (self.roleMainButtonWide * 2), y = (self.roleMainButtonTallSpacer * 3) + (self.roleMainButtonTall * 2)}
	}
	net.Receive("RequestLevelCallback", function(len, ply)
		self.playerLevel = tonumber(net.ReadString()) or 1
		local titleCounter = 0
		for k, v in ipairs(self.roleMainButtonPOS) do
			local but = vgui.Create("RoleSelectionButton", self.roleMain, "but" .. k)
			but:SetPos(self.roleMainButtonPOS[k].x, self.roleMainButtonPOS[k].y)
			but:SetSize(self.roleMainButtonWide, self.roleMainButtonTall)
			but:SetText(GAMEMODE.Roles[k - titleCounter][self.teamNumberToName[LocalPlayer():Team()]])
			but:SetRole(k - titleCounter)
			if k == 2 then
				but:IsTitle(true)
				titleCounter = titleCounter + 1
			else
				if k > GAMEMODE.playerLevel then 
					but:IsLocked(true)
				end
			end
		end
	end)

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
        draw.RoundedBoxEx(16, 0, 0, self.roleTeam:GetWide(), self.roleTeam:GetTall(), Color(0, 0, 0, 220), true, false, true, false)
		draw.SimpleText("Your Team", "DermaDefault", self.roleTeam:GetWide() - 4, 2, Color(255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
		if not self.roleTeamScrollTeamInfo then
			draw.RoundedBoxEx(16, 0, 0, self.roleTeam:GetWide(), self.roleTeam:GetTall(), Color(0, 0, 0, 100), true, false, true, false)
			draw.SimpleText("Loading Teammate Information", "DermaDefault", self.roleTeamScroll:GetWide() / 2, self.roleTeamScroll:GetTall() / 2, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
    end
	self.roleTeam.Think = function()
		if not self.roleMain:IsValid() then
			self.roleTeam:Remove()
			return
		end
		if self.roleTeam then
			self.roleTeam:MakePopup()
		end
		if not self.roleTeam:HasFocus() then
			self.roleTeam:RequestFocus()
		end
	end

	self.roleTeamScroll = vgui.Create("DScrollPanel", self.roleTeam)
	self.roleTeamScroll:SetPos(0, 18)
	self.roleTeamScroll:SetSize(self.roleTeam:GetWide(), self.roleTeam:GetTall() - 18)
	--[[self.roleTeamScroll.Paint = function()
		if not IsValid(self.roleTeamScroll:GetChildren()) then
			draw.RoundedBoxEx(16, 0, 0, self.roleTeam:GetWide(), self.roleTeam:GetTall(), Color(0, 0, 0, 100), true, false, true, false)
			draw.SimpleText("Loading Teammate Information", "DermaDefault", self.roleTeamScroll:GetWide() / 2, self.roleTeamScroll:GetTall() / 2, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
	end]]
	self.roleTeamScrollPanelHeight = 50
		--TO-DO
	--[[local sbar = self.roleTeamScroll:GetVBar()
	sbar.Paint = function()

	end]]

	--//Clears and recreates the roleTeamScroll scroll panel
	function self:RefreshTeamRoles(teamTable)
		self.roleTeamScroll:Clear()
		if #teamTable == 0 then
			local noPlayer = vgui.Create("DPanel", self.roleTeamScroll)
			noPlayer:SetPos(0, 0)
			noPlayer:SetSize(self.roleTeamScroll:GetWide(), self.roleTeamScroll:GetTall())
			noPlayer.Paint = function()
				draw.SimpleText("No Information To Display", "DermaLarge", noPlayer:GetWide() / 2, noPlayer:GetTall() / 2, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end
			return
		end

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
		self.roleTeamScrollTeamInfo = net.ReadTable()
		if self.roleTeamScroll:IsValid() then
			self:RefreshTeamRoles(self.roleTeamScrollTeamInfo)
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
        draw.RoundedBoxEx(16, 0, 0, self.roleEnemy:GetWide(), self.roleEnemy:GetTall(), Color(0, 0, 0, 220), false, true, false, true)
		draw.SimpleText("Enemy Role Count", "DermaDefault", 4, 2, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
		if not self.roleEnemyRoleCount then
			draw.RoundedBoxEx(4, 0, 0, self.roleEnemy:GetWide(), self.roleEnemy:GetTall(), Color(0, 0, 0, 220), false, true, false, true)
			draw.SimpleText("Loading Enemy Role Count", "DermaDefault", self.roleEnemy:GetWide() / 2, self.roleEnemy:GetTall() / 2, Color(0, 0, 0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
    end
	self.roleEnemy.Think = function()
		if not self.roleMain:IsValid() then
			self.roleEnemy:Remove()
			return
		end
		if self.roleEnemy:IsValid() then
			self.roleEnemy:MakePopup()
		end
		if not self.roleEnemy:HasFocus() then
			self.roleEnemy:RequestFocus()
		end
	end

	self.roleEnemyScroll = vgui.Create("DScrollPanel", self.roleEnemy)
	self.roleEnemyScroll:SetPos(0, 18)
	self.roleEnemyScroll:SetSize(self.roleEnemy:GetWide(), self.roleEnemy:GetTall() - 18)
	--[[self.roleEnemyScroll.Paint = function()
		if not IsValid(self.roleEnemyScroll:GetChildren()) then
			draw.RoundedBoxEx(16, 0, 0, self.roleEnemy:GetWide(), self.roleEnemy:GetTall(), Color(0, 0, 0, 220), false, true, false, true)
			draw.SimpleText("Loading Enemy Role Count", "DermaDefault", self.roleEnemy:GetWide() / 2, self.roleEnemy:GetTall() / 2, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
	end]]
	self.roleEnemyScrollPanelHeight = 50
		--TO-DO
	--[[local sbar = self.roleEnemyScroll:GetVBar()
	sbar.Paint = function()

	end]]

	--//Clears and recreates the roleEnemyScroll scroll panel
	function self:RefreshEnemyRoles(enemyTable)
		self.roleEnemyScroll:Clear()
		if #enemyTable == 0 then
			local noPlayer = vgui.Create("DPanel", self.roleEnemyScroll)
			noPlayer:SetPos(0, 0)
			noPlayer:SetSize(self.roleEnemyScroll:GetWide(), self.roleEnemyScroll:GetTall())
			noPlayer.Paint = function()
				draw.SimpleText("No Information To Display", "DermaLarge", noPlayer:GetWide() / 2, noPlayer:GetTall() / 2, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end
			return
		end

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
		self:RefreshEnemyRoles(self.roleEnemyRoleCount)
	end)
end

function GM:RoleDescriptions(role)
	if self.roleDescMenu and self.roleDescMenu:IsValid() then return end

	self.roleDescMenu = vgui.Create("DFrame")
	self.roleDescMenu:SetSize(600, 300)
	self.roleDescMenu:SetTitle("")
	self.roleDescMenu:SetVisible(true)
	self.roleDescMenu:SetDraggable(false)
	self.roleDescMenu:ShowCloseButton(false)
	self.roleDescMenu:MakePopup()
	self.roleDescMenu:Center()
	self.roleDescMenuX, self.roleDescMenuY = self.roleDescMenu:GetPos()
    self.roleDescMenu.Paint = function()
		--Derma_DrawBackgroundBlur(self.roleDescMenu, CurTime())
		surface.SetDrawColor(0, 0, 0, 220)
        surface.DrawRect(0, 0, self.roleDescMenu:GetWide(), self.roleDescMenu:GetTall())
    end
	self.roleDescMenu.Think = function()
		if self.roleMain:IsValid() then
			self.roleDescMenu:Remove()
		elseif self.roleDescMenu:IsValid() then
			self.roleDescMenu:MakePopup()
		end
	end

	self.roleDescMenuRoleWidth = self.roleDescMenu:GetWide() / 3
	for k, v in pairs(self.Roles) do
		local but = vgui.Create("RoleDescriptionButton", self.roleDescMenu)
		but:SetSize(self.roleDescMenuRoleWidth, self.roleDescMenu:GetTall() / #self.Roles)
		but:SetPos(0, (k - 1) * (self.roleDescMenu:GetTall() / #self.Roles))
		but:SetText(v[self.teamNumberToName[LocalPlayer():Team()]])
		but:SetRole(k)
		if role == k then
			but:DoClick()
		end
	end

	self.roleDescMenuInfo = vgui.Create("DPanel", self.roleDescMenu)
	self.roleDescMenuInfo:SetSize(self.roleDescMenu:GetWide() - self.roleDescMenuRoleWidth, self.roleDescMenu:GetTall())
	self.roleDescMenuInfo:SetPos(self.roleDescMenuRoleWidth, 0)
	self.roleDescMenuPOS = {
		{x = self.roleDescMenuInfo:GetWide() / 4, y = self.roleDescMenuInfo:GetTall() * (1 / 5)},
		{x = self.roleDescMenuInfo:GetWide() * (3 / 4), y = self.roleDescMenuInfo:GetTall() * (1 / 5)},
		
		{x = self.roleDescMenuInfo:GetWide() / 4, y = self.roleDescMenuInfo:GetTall() * (2 / 5)},
		{x = self.roleDescMenuInfo:GetWide() / 2, y = self.roleDescMenuInfo:GetTall() * (2 / 5)},
		{x = self.roleDescMenuInfo:GetWide() * (3 / 4), y = self.roleDescMenuInfo:GetTall() * (2 / 5)},

		{x = self.roleDescMenuInfo:GetWide() / 4, y = self.roleDescMenuInfo:GetTall() * (3 / 5)},
		{x = self.roleDescMenuInfo:GetWide() / 2, y = self.roleDescMenuInfo:GetTall() * (3 / 5)},
		{x = self.roleDescMenuInfo:GetWide() * (3 / 4), y = self.roleDescMenuInfo:GetTall() * (3 / 5)},

		{x = self.roleDescMenuInfo:GetWide() / 4, y = self.roleDescMenuInfo:GetTall() * (4 / 5)},
		{x = self.roleDescMenuInfo:GetWide() / 2, y = self.roleDescMenuInfo:GetTall() * (4 / 5)},
		{x = self.roleDescMenuInfo:GetWide() * (3 / 4), y = self.roleDescMenuInfo:GetTall() * (4 / 5)}
	}
	self.roleDescMenuInfo.Paint = function()
		local w, h = self.roleDescMenuInfo:GetSize()

		surface.SetDrawColor(255, 255, 255)
		surface.DrawLine(0, 0, w, 0)
		surface.DrawLine(w - 1, 0, w - 1, h)
		surface.DrawLine(w, h - 1, 0, h - 1)
		surface.DrawLine(0, 0, 0, self.roleDescMenuButtonDownY)
		surface.DrawLine(0, self.roleDescMenuButtonDownY + self.roleDescMenuButtonDownTall, 0, h)
		draw.SimpleText(self.Roles[self.roleDescMenuButtonNumber][self.teamNumberToName[LocalPlayer():Team()]], "DermaLarge", self.roleDescMenuInfo:GetWide() / 2, 20, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		--draw.SimpleText(self.Roles[self.roleDescMenuButtonNumber].roleDescription, "DermaDefault", self.roleDescMenuInfo:GetWide() / 2, 36, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		print(self.Roles[self.roleDescMenuButtonNumber].roleDescriptionExpanded[1], self.Roles[self.roleDescMenuButtonNumber].roleDescriptionExpanded[1][1], self.Roles[self.roleDescMenuButtonNumber].roleDescriptionExpanded[1][2], self.Roles[self.roleDescMenuButtonNumber].roleDescriptionExpanded[1][3])
		for k, v in pairs(self.Roles[self.roleDescMenuButtonNumber].roleDescriptionExpanded) do

			surface.SetFont("DermaDefault")
			local w, h = surface.GetTextSize(v[1] .. ": ")
			surface.SetDrawColor(255, 255, 255)
			surface.SetTextPos(self.roleDescMenuPOS[k].x - (w / 2), self.roleDescMenuPOS[k].y - (h / 2))
			surface.DrawText(v[1] .. ":")
			
			surface.SetDrawColor(v[3])
			surface.SetTextPos(self.roleDescMenuPOS[k].x + (w / 2), self.roleDescMenuPOS[k].y - (h / 2))
			surface.DrawText(v[2])
		end
		--Draw role information
	end

	self.roleDescMenuExit = vgui.Create("DFrame")
	self.roleDescMenuExit:SetSize(8, 8)
	self.roleDescMenuExit:SetPos(self.roleDescMenuX + self.roleDescMenu:GetWide() + 2, self.roleDescMenuY)
	self.roleDescMenuExit:SetTitle("")
	self.roleDescMenuExit:SetVisible(true)
	self.roleDescMenuExit:SetDraggable(false)
	self.roleDescMenuExit:ShowCloseButton(false)
	self.roleDescMenuExit:MakePopup()
	self.roleDescMenuExitX, self.roleDescMenuExitY = self.roleDescMenuExit:GetPos()
	self.roleDescMenuExit.Think = function()
		if not self.roleDescMenu:IsValid() then
			self.roleDescMenuExit:Remove()
		end
	end

	self.roleDescMenuExitButton = vgui.Create("DButton", self.roleDescMenuExit)
	self.roleDescMenuExitButton:SetPos(0, 0)
	self.roleDescMenuExitButton:SetSize(self.roleDescMenuExit:GetWide(), self.roleDescMenuExit:GetTall())
	self.roleDescMenuExitButton:SetText("X")
	self.roleDescMenuExitButton.DoClick = function()
		surface.PlaySound("buttons/lightswitch2.wav")
		self.roleDescMenu:Remove()
		self.roleDescMenuExit:Remove()
		self:RoleSelectionMenu()
	end
end

function GM:ArmorDescription(armor)
	if self.armorDescMenu and self.armorDescMenu:IsValid() then return end

	self.armorDescMenu = vgui.Create("DFrame")
	self.armorDescMenu:SetSize(600, 200)
	self.armorDescMenu:SetTitle("")
	self.armorDescMenu:SetVisible(true)
	self.armorDescMenu:SetDraggable(false)
	self.armorDescMenu:ShowCloseButton(false)
	self.armorDescMenu:MakePopup()
	self.armorDescMenu:Center()
	self.armorDescMenuX, self.armorDescMenuY = self.armorDescMenu:GetPos()
    self.armorDescMenu.Paint = function()
		--Derma_DrawBackgroundBlur(self.armorDescMenu, CurTime())
		surface.SetDrawColor(0, 0, 0, 220)
        surface.DrawRect(0, 0, self.armorDescMenu:GetWide(), self.armorDescMenu:GetTall())
    end
	self.armorDescMenu.Think = function()
		if self.armorDescMenu:IsValid() then
			self.armorDescMenu:MakePopup()
		end
	end

	self.armorDescMenuButtonWidth = self.armorDescMenu:GetWide() / 3
	self.armorDescMenuInfo = vgui.Create("DPanel", self.armorDescMenu)
	self.armorDescMenuInfo:SetSize(self.armorDescMenu:GetWide() - self.armorDescMenuButtonWidth, self.armorDescMenu:GetTall())
	self.armorDescMenuInfo:SetPos(self.armorDescMenuButtonWidth, 0)
	self.armorDescMenuInfo.Paint = function()
		local w, h = self.armorDescMenuInfo:GetSize()

		surface.SetDrawColor(255, 255, 255)
		surface.DrawLine(0, 0, w, 0)
		surface.DrawLine(w - 1, 0, w - 1, h)
		surface.DrawLine(w, h - 1, 0, h - 1)
		surface.DrawLine(0, 0, 0, self.armorDescMenuButtonDownY)
		surface.DrawLine(0, self.armorDescMenuButtonDownY + self.armorDescMenuButtonDownTall, 0, h)

		draw.SimpleText("Damage Scaling %", "DermaDefault", self.armorDescMenuInfo:GetWide() / 4, 6, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		surface.DrawLine(self.armorDescMenuInfo:GetWide() / 2, 7, self.armorDescMenuInfo:GetWide() / 2, self.armorDescMenuInfo:GetTall() - 7)
		draw.SimpleText("Health and Movement Scaling %", "DermaDefault", self.armorDescMenuInfo:GetWide() * 0.75, 6, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end

	self.armorNumberToIcon = {
		damageScaling = {"menu/headpic.png", "menu/chestpic2.png", "menu/armpic.png", "menu/legpic.png"},
		movementScaling = {"menu/walkpic.png", "menu/runpic.png", "menu/jumppic2.png"}
	}

	function self:DrawDescriptionPanel(armor) --TO TEST
		if #self.armorDescMenuInfo:GetChildren() > 0 then
			for k, v in pairs(self.armorDescMenuInfo:GetChildren()) do
				if string.StartWith(v:GetName(), "aii") then
					v:Remove()
				end
			end
		end
		
		for k, v in pairs(self.Armor[armor].damageScaling) do
			local but = vgui.Create("ArmorInfoIcon", self.armorDescMenuInfo, "aii" .. k)
			but:SetPos(0, self.armorDescMenuInfo:GetTall() / 4 * (k - 1))
			but:SetSize(self.armorDescMenuInfo:GetWide() / 2, self.armorDescMenuInfo:GetTall() / 4)
			but:SetText(v)
			but:SetImage(self.armorNumberToIcon.damageScaling[k])
			but:SetArmor(armor)
			but:SetWhatScale("damageScaling", k)
			but:Finish()
		end
		
		self.armorDescMenuInfoHealth = vgui.Create("ArmorInfoIcon", self.armorDescMenuInfo, "aii" .. tostring(#self.Armor[armor].damageScaling + 1))
		self.armorDescMenuInfoHealth:SetPos(self.armorDescMenuInfo:GetWide() / 2, 0)
		self.armorDescMenuInfoHealth:SetSize(self.armorDescMenuInfo:GetWide() / 2, self.armorDescMenuInfo:GetTall() / 4)
		self.armorDescMenuInfoHealth:SetText(self.Armor[armor].healthScaling)
		self.armorDescMenuInfoHealth:SetImage("menu/healthpic.png")
		self.armorDescMenuInfoHealth:SetArmor(armor)
		self.armorDescMenuInfoHealth:SetWhatScale("healthScaling")
		self.armorDescMenuInfoHealth:Finish()
		
		for k, v in pairs(self.Armor[armor].movementScaling) do
			local but = vgui.Create("ArmorInfoIcon", self.armorDescMenuInfo, "aii" .. (#self.Armor[armor].damageScaling + 1 + k))
			but:SetPos(self.armorDescMenuInfo:GetWide() / 2, self.armorDescMenuInfo:GetTall() / 4 * k)
			but:SetSize(self.armorDescMenuInfo:GetWide() / 2, self.armorDescMenuInfo:GetTall() / 4)
			but:SetText(v)
			but:SetImage(self.armorNumberToIcon.movementScaling[k])
			but:SetArmor(armor)
			but:SetWhatScale("movementScaling", k)
			but:Finish()
		end
	end

	for k, v in pairs(self.Armor) do
		local but = vgui.Create("ArmorDescriptionButton", self.armorDescMenu)
		but:SetSize(self.armorDescMenuButtonWidth, self.armorDescMenu:GetTall() / 4)
		but:SetPos(0, self.armorDescMenu:GetTall() / 4 * (k - 1))
		but:SetText(v.armorName)
		but:SetArmor(k)
		if armor == k then
			but:DoClick()
		end
	end

	self.armorDescMenuExit = vgui.Create("DFrame")
	self.armorDescMenuExit:SetSize(8, 8)
	self.armorDescMenuExit:SetPos(self.armorDescMenuX + self.armorDescMenu:GetWide() + 2, self.armorDescMenuY)
	self.armorDescMenuExit:SetTitle("")
	self.armorDescMenuExit:SetVisible(true)
	self.armorDescMenuExit:SetDraggable(false)
	self.armorDescMenuExit:ShowCloseButton(false)
	self.armorDescMenuExit:MakePopup()
	self.armorDescMenuExitX, self.armorDescMenuExitY = self.armorDescMenuExit:GetPos()
	self.armorDescMenuExit.Think = function()
		if not self.armorDescMenu or not self.armorDescMenu:IsValid() then
			self.armorDescMenuExit:Remove()
		end
	end

	self.armorDescMenuExitButton = vgui.Create("DButton", self.armorDescMenuExit)
	self.armorDescMenuExitButton:SetPos(0, 0)
	self.armorDescMenuExitButton:SetSize(self.armorDescMenuExit:GetWide(), self.armorDescMenuExit:GetTall())
	self.armorDescMenuExitButton:SetText("X")
	self.armorDescMenuExitButton.DoClick = function()
		surface.PlaySound("buttons/lightswitch2.wav")
		self.armorDescMenu:Remove()
		self.armorDescMenuExit:Remove()
		self:RoleSelectionMenu()
	end
end

--[[net.Receive("SendRoleToServerCallback", function()
	GAMEMODE.
end)]]