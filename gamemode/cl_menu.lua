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

--//Someone's gonna have to back and get a SHIT LOAD of fonts! -Blazing Saddles
surface.CreateFont("MW2Font", {
	font = "BankGothic",
	size = 18,
	weight = 500,
	antialias = true
})

surface.CreateFont("MW2FontSmall", {
	font = "BankGothic",
	size = 12,
	weight = 500,
	antialias = true
})

surface.CreateFont("MW2FontUnderlined", {
	font = "BankGothic",
	size = 18,
	weight = 500,
	antialias = true,
	underline = true
})

surface.CreateFont("MW2FontLarge", {
	font = "BankGothic",
	size = 30,
	weight = 500,
	antialias = true
})

-- http://lua-users.org/wiki/FormattingNumbers
--//Used to format SteamIDs
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

--//Hook identifier self-explanatory
hook.Add("InitPostEntity", "PrecacheWeaponModelsToPreventInitialMenuOpeningLag", function()
	for k, v in pairs(weapons.GetList()) do
		if v.WorldModel then
			util.PrecacheModel( v.WorldModel )
		end
	end
end)

GM.teamNumberToName = {"redTeamName", "blueTeamName", "soloTeamName"} --This could be a part of the team table...

hook.Add("PostGamemodeLoaded", "AddIcons", function()
	--Have to do this in a post-gamemode-loaded hook because apparently our Roles table wouldn't have been created at this point otherwise
	GAMEMODE.weaponToIcon = {}
	GAMEMODE.weaponToIcon[GAMEMODE.Roles[1].roleDescriptionExpanded[1][1]] = Material("menu/weapon_icons/assaultrifle_icon.png", "smooth")
	GAMEMODE.weaponToIcon[GAMEMODE.Roles[1].roleDescriptionExpanded[2][1]] = Material("menu/weapon_icons/smg_icon.png", "smooth")
	GAMEMODE.weaponToIcon[GAMEMODE.Roles[1].roleDescriptionExpanded[3][1]] = Material("menu/weapon_icons/shotgun_icon.png", "smooth")
	GAMEMODE.weaponToIcon[GAMEMODE.Roles[1].roleDescriptionExpanded[4][1]] = Material("menu/role_icons/role_support_icon_fixed.png", "smooth")
	GAMEMODE.weaponToIcon[GAMEMODE.Roles[1].roleDescriptionExpanded[5][1]] = Material("menu/weapon_icons/dmr_icon.png", "smooth")
	GAMEMODE.weaponToIcon[GAMEMODE.Roles[1].roleDescriptionExpanded[6][1]] = Material("menu/weapon_icons/sniper_icon.png", "smooth")
	GAMEMODE.weaponToIcon[GAMEMODE.Roles[1].roleDescriptionExpanded[7][1]] = Material("menu/weapon_icons/frag_grenade_icon.png", "smooth")
	GAMEMODE.weaponToIcon[GAMEMODE.Roles[1].roleDescriptionExpanded[8][1]] = Material("menu/weapon_icons/flash_grenade_icon.png", "smooth")
	GAMEMODE.weaponToIcon[GAMEMODE.Roles[1].roleDescriptionExpanded[9][1]] = Material("menu/weapon_icons/smoke_grenade_icon.png", "smooth")
	GAMEMODE.weaponToIcon[GAMEMODE.Roles[1].roleDescriptionExpanded[10][1]] = Material("menu/weapon_icons/fire_grenade_icon.png", "smooth")
	GAMEMODE.weaponToIcon[GAMEMODE.Roles[1].roleDescriptionExpanded[11][1]] = Material("menu/weapon_icons/remote_icon.png", "smooth")
	GAMEMODE.weaponToIcon[GAMEMODE.Roles[1].roleDescriptionExpanded[12][1]] = Material("menu/weapon_icons/launcher_icon.png", "smooth")
	GAMEMODE.weaponToIcon[GAMEMODE.weaponTypes[13]]							= Material("menu/weapon_icons/pistol_icon.png", "smooth")
	
	--Doesn't need to be here but kept here anyway
	GAMEMODE.armorToIcon = {
		healthScaling = Material("menu/armor_icons/health_icon.png", "smooth"),
		movementScaling = {
			{"Walk Speed", Material("menu/armor_icons/walk_icon.png", "smooth")},
			{"Run Speed", Material("menu/armor_icons/run_icon.png", "smooth")},
			{"Jump Power", Material("menu/armor_icons/jump_icon.png", "smooth")}
		},
		damageScaling = {
			{"Head Damage", Material("menu/armor_icons/head_icon.png", "smooth")},
			{"Chest Damage", Material("menu/armor_icons/chest_icon.png", "smooth")},
			{"Arm Damage", Material("menu/armor_icons/arm_icon.png", "smooth")},
			{"Leg Damage", Material("menu/armor_icons/leg_icon.png", "smooth")}
		}
	}
end)

--//The loadout menu that opens when you press C, set weapons from here
function GM:LoadoutMenu(role, roleNotNeeded, selectedWeapons)
	if self.Main and self.Main:IsValid() then return end

	if role then
		self.myRole = role
	end
	if not self.myRole then
		self:RoleSelectionMenu()
		return
	end

	net.Start("RequestLevel")
	net.SendToServer()
	net.Receive("RequestLevelCallback", function(len, ply)
		self.playerLevel = tonumber(net.ReadString())
		self.playerInfoMainLevelText = markup.Parse("<font=DermaLarge>Level: <colour=" .. self.myTeam.menuTeamColorLightAccent.r .. "," .. self.myTeam.menuTeamColorLightAccent.g .. "," .. self.myTeam.menuTeamColorLightAccent.b .. ">" .. self.playerLevel .. "</colour></font>")			
	end)

	net.Start("RequestMoney")
	net.SendToServer()
	net.Receive("RequestMoneyCallback", function()
		self.playerMoney = tonumber(net.ReadString())
		self.playerInfoMainMoneyText = markup.Parse(("<font=DermaLarge>Cash: $<colour=" .. self.myTeam.menuTeamColorLightAccent.r .. "," .. self.myTeam.menuTeamColorLightAccent.g .. "," .. self.myTeam.menuTeamColorLightAccent.b .. ">" .. comma_value(self.playerMoney) .. "</colour></font>"))
	end)

	--//The main panel, everything parented to this
	self.Main = vgui.Create("DFrame")
	self.Main:SetSize(800, 400)
	self.Main:SetTitle("")
	self.Main:SetVisible(true)
	self.Main:SetDraggable(false)
	self.Main:ShowCloseButton(false)
	self.Main:MakePopup()
	self.Main:Center()
	self.MainX, self.MainY = self.Main:GetPos()
    self.Main.Paint = function()
		surface.SetDrawColor(self.myTeam.menuTeamColorLightAccent.r, self.myTeam.menuTeamColorLightAccent.g, self.myTeam.menuTeamColorLightAccent.b)
		surface.DrawRect(0, 0, self.Main:GetWide(), self.Main:GetTall())

		draw.RoundedBox(8, 0, 0, self.Main:GetWide(), 50 + 64 + 4, Color(self.myTeam.menuTeamColorDarkAccent.r, self.myTeam.menuTeamColorDarkAccent.g, self.myTeam.menuTeamColorDarkAccent.b))

		draw.SimpleText("Customize Your Loadout", "MW2FontLarge", 13 / 2, 25, Color(self.myTeam.menuTeamColor.r, self.myTeam.menuTeamColor.g, self.myTeam.menuTeamColor.b), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		surface.SetDrawColor(self.myTeam.menuTeamColor.r, self.myTeam.menuTeamColor.g, self.myTeam.menuTeamColor.b)
		surface.DrawLine(6, 50, self.Main:GetWide() - 6, 50)

		surface.SetDrawColor(self.myTeam.menuTeamColorAccent.r, self.myTeam.menuTeamColorAccent.g, self.myTeam.menuTeamColorAccent.b)
		surface.DrawOutlinedRect(0, 0, self.Main:GetWide(), self.Main:GetTall())
    end
	self.Main.Think = function()
		self.MainX, self.MainY = self.Main:GetPos()
	end

	--//Opens the "available weapons" part of the loadout menu, still parented to Main
	self:LoadoutMenuExt()

	--//The button that allows you to switch your role
	surface.SetFont("MW2Font")
	self.mainNewRoletextWide, self.mainNewRoletextTall = surface.GetTextSize(self.Roles[self.myRole][self.teamNumberToName[LocalPlayer():Team()]])
	self.mainNewRole = vgui.Create("DButton", self.Main)
	self.mainNewRole:SetSize(12 + self.mainNewRoletextWide, self.mainNewRoletextTall)
	self.mainNewRole:SetPos(self.Main:GetWide() / 4 * 3 - self.mainNewRole:GetWide() / 2 - 10, 25 - self.mainNewRole:GetTall() / 2)
	self.mainNewRole:SetText("")
	self.mainNewRole.Paint = function()
		local w, h = self.mainNewRole:GetSize()
		
		surface.SetDrawColor(self.myTeam.menuTeamColor.r, self.myTeam.menuTeamColor.g, self.myTeam.menuTeamColor.b)
		surface.SetTexture(surface.GetTextureID("gui/center_gradient"))
		surface.DrawTexturedRect(0, 0, w, h)
		draw.SimpleText(self.Roles[self.myRole][self.teamNumberToName[LocalPlayer():Team()]], "MW2Font", w / 2, h / 2, Color(255, 255, 255, 150), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		
		if self.mainNewRoleHover then
			draw.SimpleText(self.Roles[self.myRole][self.teamNumberToName[LocalPlayer():Team()]], "MW2Font", w / 2, h / 2, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			surface.SetDrawColor(self.myTeam.menuTeamColorAccent.r, self.myTeam.menuTeamColorAccent.g, self.myTeam.menuTeamColorAccent.b, 50)
			surface.SetTexture(surface.GetTextureID("gui/center_gradient"))
			surface.DrawTexturedRect(0, 0, w, h)
		end
	end
	self.mainNewRole.DoClick = function()
		surface.PlaySound("buttons/lightswitch2.wav")
		self:RoleSelectionMenu()
		self.Main:Remove()
		self.mainNewRoleHover = false
	end
	self.mainNewRole.OnCursorEntered = function()
		surface.PlaySound("garrysmod/ui_hover.wav")
		self.mainNewRoleHover = true
	end
	self.mainNewRole.OnCursorExited = function()
		self.mainNewRoleHover = false
	end

	--//The exit button that closes Main and all accompanying panels
	self.mainExitButton = vgui.Create("DButton", self.Main)
	self.mainExitButton:SetSize(20, 30)
	self.mainExitButton:SetPos(self.Main:GetWide() - self.mainExitButton:GetWide() - 12, 25 - self.mainExitButton:GetTall() / 2)
	self.mainExitButton:SetText("")
	self.mainExitButton.Paint = function()
		draw.SimpleText("X", "MW2FontLarge", 0, 0, Color(175, 175, 175))
		if self.mainExitButtonHover then
			draw.SimpleText("X", "MW2FontLarge", 0, 0, Color(self.myTeam.menuTeamColorLightAccent.r, self.myTeam.menuTeamColorLightAccent.g, self.myTeam.menuTeamColorLightAccent.b))
		end
	end
	self.mainExitButton.DoClick = function()
		self.Main:Remove()
		surface.PlaySound("buttons/lightswitch2.wav")
		self.mainExitButtonHover = false

		local loadoutTable = {
			["role"] = self.myRole,
			["primWeapon"] = self.PRIMARY_WEAPON,
			["primWeaponAttachments"] = self.PRIMARY_WEAPON_ATTACHMENTS,
			["secondWeapon"] = self.SECONDARY_WEAPON,
			["secondWeaponAttachments"] = self.SECONDARY_WEAPON_ATTACHMENTS,
			["equipWeapon"] = self.EQUIPMENT_WEAPON,
			["equipWeaponAttachments"] = self.EQUIPMENT_WEAPON_ATTACHMENTS
		}
		net.Start("VerifyLoadout")
			net.WriteTable(loadoutTable)
		net.SendToServer()
		file.Write("onelife/personalinfo/lastloadout" .. LocalPlayer():Team() .. self.myRole .. ".txt", util.TableToJSON(loadoutTable))
	end
	self.mainExitButton.OnCursorEntered = function()
		surface.PlaySound("garrysmod/ui_hover.wav")
		self.mainExitButtonHover = true
	end
	self.mainExitButton.OnCursorExited = function()
		self.mainExitButtonHover = false
	end

	self.playerInfoMainPictureSize = 64 --The font we're using for the Name and SteamID is 30 pixels tall, so with both rows together it's a base size of 60, + 2 + 2 for spacing
	self.playerInfoMain = vgui.Create("DPanel", self.Main) --This is the top bar panel below the title
	self.playerInfoMain:SetPos(0, 50)
	self.playerInfoMain:SetSize(self.Main:GetWide(), self.playerInfoMainPictureSize + 4)
	self.playerInfoMainHalf = self.playerInfoMain:GetWide() / 2
	self.playerInfoMain.Paint = function()
		draw.SimpleText(LocalPlayer():Nick(), "DermaLarge", self.playerInfoMainPictureSize + 12, 2, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
		draw.SimpleText(LocalPlayer():SteamID(), "DermaLarge", self.playerInfoMainPictureSize + 12, self.playerInfoMain:GetTall() / 2 + 2, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
		if self.playerInfoMainLevelText then
			self.playerInfoMainLevelText:Draw(self.playerInfoMain:GetWide() / 2, 2, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
		end
		if self.playerInfoMainMoneyText then
			self.playerInfoMainMoneyText:Draw(self.playerInfoMain:GetWide() / 2, self.playerInfoMain:GetTall() / 2 + 2, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
		end

		surface.SetDrawColor(self.myTeam.menuTeamColor.r, self.myTeam.menuTeamColor.g, self.myTeam.menuTeamColor.b)
		surface.DrawLine(self.playerInfoMain:GetWide() / 2 - 6, 2,  self.playerInfoMain:GetWide() / 2 - 6, self.playerInfoMain:GetTall() - 2)
	end

	self.playerInfoMainPicture = vgui.Create("AvatarImage", self.playerInfoMain)
	self.playerInfoMainPicture:SetPos(6, 2)
	self.playerInfoMainPicture:SetSize(self.playerInfoMainPictureSize, self.playerInfoMainPictureSize)
	self.playerInfoMainPicture:SetPlayer(LocalPlayer(), 64)

	self.playerInfoMainShop = vgui.Create("DButton", self.playerInfoMain)
	self.playerInfoMainShop:SetSize(self.playerInfoMainPictureSize, self.playerInfoMainPictureSize)
	self.playerInfoMainShop:SetPos(self.playerInfoMain:GetWide() - self.playerInfoMainPictureSize)
	self.playerInfoMainShop:SetText("")
	self.playerInfoMainShop.DoClick = function()
		surface.PlaySound("buttons/lightswitch2.wav")
		--self.Main:Close()
		self:ShopMenu()
	end
	self.playerInfoMainShop.Paint = function()
		surface.SetDrawColor(175, 175, 175)
		surface.SetMaterial(Material("menu/shop_icon_fixed.png", "smooth")) --I know it's expensive but performance isn't a problem
		surface.DrawTexturedRect(1, 1, self.playerInfoMainShop:GetWide() - 1, self.playerInfoMainShop:GetTall() - 1)
		
		if self.playerInfoMainShop.hover then
			surface.SetDrawColor(self.myTeam.menuTeamColorLightAccent.r, self.myTeam.menuTeamColorLightAccent.g, self.myTeam.menuTeamColorLightAccent.b)
			surface.DrawTexturedRect(1, 1, self.playerInfoMainShop:GetWide() - 1, self.playerInfoMainShop:GetTall() - 1)
			--surface.DrawOutlinedRect(0, 0, self.playerInfoMainShop:GetWide(), self.playerInfoMainShop:GetTall())
		end
	end
	self.playerInfoMainShop.OnCursorEntered = function()
		surface.PlaySound("garrysmod/ui_hover.wav")
		self.playerInfoMainShop.hover = true
	end
	self.playerInfoMainShop.OnCursorExited = function()
		self.playerInfoMainShop.hover = false
	end

	self.defaultWeapons = {
		{
			"cw_kk_ins2_ak74",
			"cw_kk_ins2_aks74u",
			"cw_kk_ins2_rpk",
			"cw_kk_ins2_m1a1",
			"cw_kk_ins2_ak74",
			"cw_kk_ins2_mosin",
			"cw_kk_ins2_ak74",
			"cw_kk_ins2_ak74",
			["secondary"] = "cw_kk_ins2_makarov"
		},
		{
			"cw_kk_ins2_m4a1",
			"cw_kk_ins2_mp5k",
			"cw_kk_ins2_m249",
			"cw_kk_ins2_m14",
			"cw_kk_ins2_m4a1",
			"cw_kk_ins2_m40a1",
			"cw_kk_ins2_m4a1",
			"cw_kk_ins2_m4a1",
			["secondary"] = "cw_kk_ins2_m9"
		}
	}

	self.previousLoadout = util.JSONToTable(file.Read("onelife/personalinfo/lastloadout" .. LocalPlayer():Team() .. self.myRole .. ".txt", "DATA"))

	self.PRIMARY_WEAPON = self.previousLoadout.primWeapon or self.defaultWeapons[LocalPlayer():Team()][self.myRole]
	self.SECONDARY_WEAPON = self.previousLoadout.secondWeapon or self.defaultWeapons[LocalPlayer():Team()].secondary
	self.EQUIPMENT_WEAPON = self.previousLoadout.equipWeapon or "cw_kk_ins2_p2a1"

	self.PRIMARY_WEAPON_ATTACHMENTS = self.previousLoadout.primWeaponAttachments or {}
	self.SECONDARY_WEAPON_ATTACHMENTS = self.previousLoadout.secondWeaponAttachments or {}
	self.EQUIPMENT_WEAPON_ATTACHMENTS = self.previousLoadout.equipWeaponAttachments or {}

	self.PRIMARY_WEAPON_BACKUP = ""
	self.SECONDARY_WEAPON_BACKUP = ""
	self.EQUIPMENT_WEAPON_BACKUP = ""

	self.PRIMARY_WEAPON_ATTACHMENTS_BACKUP = {}
	self.SECONDARY_WEAPON_ATTACHMENTS_BACKUP = {}
	self.EQUIPMENT_WEAPON_ATTACHMENTS_BACKUP = {}

	self.weaponPanelHeight = (self.Main:GetTall() - self.playerInfoMain:GetTall() - 50) / 2
	function self:RefreshWeapons()

		if self.PRIMARY_WEAPON != self.PRIMARY_WEAPON_BACKUP or self.PRIMARY_WEAPON_ATTACHMENTS != self.PRIMARY_WEAPON_ATTACHMENTS_BACKUP then
			if self.playerInfoMainPrimary and self.playerInfoMainPrimary:IsValid() then
				self.playerInfoMainPrimary:Remove()
				self.playerInfoMainPrimary = nil
			end
		end
		if not (self.playerInfoMainPrimary and self.playerInfoMainPrimary:IsValid()) then
			self.playerInfoMainPrimary = vgui.Create("WeaponMenuPanel", self.Main, "playerInfoMainPrimary")
			self.playerInfoMainPrimary:SetSize(self.Main:GetWide() - 4, self.weaponPanelHeight)
			self.playerInfoMainPrimary:SetPos(2, self.playerInfoMain:GetTall() + 50 + 1)
			self.playerInfoMainPrimary:SetAttachmentWide(60)
			self.playerInfoMainPrimary:SetModelWide(225)
			self.playerInfoMainPrimary:SetFont("MW2FontSmall")
			self.playerInfoMainPrimary:SetWep(self.PRIMARY_WEAPON)
			self.playerInfoMainPrimary:SetAttach(self.PRIMARY_WEAPON_ATTACHMENTS)
			self.playerInfoMainPrimary:Finish()

			self.PRIMARY_WEAPON_BACKUP = self.PRIMARY_WEAPON
			self.PRIMARY_WEAPON_ATTACHMENTS_BACKUP = self.PRIMARY_WEAPON_ATTACHMENTS
		end

		if self.SECONDARY_WEAPON != self.SECONDARY_WEAPON_BACKUP or self.SECONDARY_WEAPON_ATTACHMENTS != self.SECONDARY_WEAPON_ATTACHMENTS_BACKUP then
			if self.playerInfoMainSecondary and self.playerInfoMainSecondary:IsValid() then
				self.playerInfoMainSecondary:Remove()
				self.playerInfoMainSecondary = nil
			end
		end
		if not (self.playerInfoMainSecondary and self.playerInfoMainSecondary:IsValid()) then
			self.playerInfoMainSecondary = vgui.Create("WeaponMenuPanel", self.Main, "playerInfoMainSecondary")
			self.playerInfoMainSecondary:SetSize(self.Main:GetWide() / 3 * 2 - 4, self.weaponPanelHeight - 4)
			self.playerInfoMainSecondary:SetPos(2, self.playerInfoMain:GetTall() + 50 + self.weaponPanelHeight + 2)
			self.playerInfoMainSecondary:SetAttachmentWide(65)
			self.playerInfoMainSecondary:SetFont("MW2FontSmall")
			self.playerInfoMainSecondary:SetWep(self.SECONDARY_WEAPON)
			self.playerInfoMainSecondary:SetAttach(self.SECONDARY_WEAPON_ATTACHMENTS)
			self.playerInfoMainSecondary:Finish()

			self.SECONDARY_WEAPON_BACKUP = self.SECONDARY_WEAPON
			self.SECONDARY_WEAPON_ATTACHMENTS_BACKUP = self.SECONDARY_WEAPON_ATTACHMENTS
		end
		
		if self.EQUIPMENT_WEAPON != self.EQUIPMENT_WEAPON_BACKUP or self.EQUIPMENT_WEAPON_ATTACHMENTS != self.EQUIPMENT_WEAPON_ATTACHMENTS_BACKUP then
			if self.playerInfoMainEquipment and self.playerInfoMainEquipment:IsValid() then
				self.playerInfoMainEquipment:Remove()
				self.playerInfoMainEquipment = nil
			end
		end
		if not (self.playerInfoMainEquipment and self.playerInfoMainEquipment:IsValid()) then
			self.playerInfoMainEquipment = vgui.Create("WeaponMenuPanel", self.Main, "playerInfoMainEquipment")
			self.playerInfoMainEquipment:SetSize(self.Main:GetWide() / 3, self.weaponPanelHeight - 4)
			self.playerInfoMainEquipment:SetPos(self.Main:GetWide() / 3 * 2 - 1, self.playerInfoMain:GetTall() + 50 + self.weaponPanelHeight + 2)
			self.playerInfoMainEquipment:SetModelWide(100)
			self.playerInfoMainEquipment:SetFont("MW2FontSmall")
			self.playerInfoMainEquipment:SetWep(self.EQUIPMENT_WEAPON)
			self.playerInfoMainEquipment:SetAttach(self.EQUIPMENT_WEAPON_ATTACHMENTS)
			self.playerInfoMainEquipment:Finish()

			self.EQUIPMENT_WEAPON_BACKUP = self.EQUIPMENT_WEAPON
			self.EQUIPMENT_WEAPON_ATTACHMENTS_BACKUP = self.EQUIPMENT_WEAPON_ATTACHMENTS
		end
	end
	self:RefreshWeapons()
end

--//The bottom half of the loadout menu that displays available weapons to the player
function GM:LoadoutMenuExt()

	self.weaponMain = vgui.Create("DFrame")
	self.weaponMain:SetSize(self.Main:GetWide(), 300)
	self.weaponMain:SetPos(self.MainX, self.MainY + self.Main:GetTall() + 6)
	self.weaponMain:SetTitle("")
	self.weaponMain:SetVisible(true)
	self.weaponMain:SetDraggable(false)
	self.weaponMain:ShowCloseButton(false)
	self.weaponMain:MakePopup()
	self.Main:MoveTo(self.MainX, self.MainY - (self.weaponMain:GetTall() / 2), 0, 0, 0)
	self.weaponMain:MoveTo(self.MainX, self.MainY + self.Main:GetTall() - (self.weaponMain:GetTall() / 2) + 6, 0, 0, 0)
	self.weaponMain.Paint = function()
		surface.SetDrawColor(self.myTeam.menuTeamColorDarkAccent.r, self.myTeam.menuTeamColorDarkAccent.g, self.myTeam.menuTeamColorDarkAccent.b)
		surface.DrawRect(0, 0, self.weaponMain:GetWide(), self.weaponMain:GetTall())

		--surface.SetDrawColor(self.myTeam.menuTeamColorDarkAccent.r, self.myTeam.menuTeamColorDarkAccent.g, self.myTeam.menuTeamColorDarkAccent.b)
		--surface.DrawRect(0, 0, self.weaponMain:GetWide(), 50 + 64 + 4)

		surface.SetDrawColor(self.myTeam.menuTeamColor.r, self.myTeam.menuTeamColor.g, self.myTeam.menuTeamColor.b)
		draw.SimpleText("Available Unlocked Weapons", "MW2FontLarge", 13 / 2, 25, Color(self.myTeam.menuTeamColor.r, self.myTeam.menuTeamColor.g, self.myTeam.menuTeamColor.b), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		surface.DrawLine(6, 50, self.weaponMain:GetWide() - 6, 50) --horizontal underline for frame title

		draw.SimpleText("Primary Weapons", "MW2Font", self.weaponMain:GetWide() / 3 / 2, 50 + 9 + 2, Color(self.myTeam.menuTeamColor.r, self.myTeam.menuTeamColor.g, self.myTeam.menuTeamColor.b), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		surface.DrawLine(12, 50 + 18 + 4, self.weaponMain:GetWide() / 3 - 12, 50 + 18 + 4) --horizontal underline for Primary Weapons title

		draw.SimpleText("Secondary Weapons", "MW2Font", self.weaponMain:GetWide() / 3 + (self.weaponMain:GetWide() / 3 / 2), 50 + 9 + 2, Color(self.myTeam.menuTeamColor.r, self.myTeam.menuTeamColor.g, self.myTeam.menuTeamColor.b), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		surface.DrawLine(self.weaponMain:GetWide() / 3 + 12, 50 + 18 + 4, self.weaponMain:GetWide() / 3 * 2 - 12, 50 + 18 + 4) --horizontal underline for Secondary Weapons title

		draw.SimpleText("Equipment", "MW2Font", self.weaponMain:GetWide() / 3 * 2 + (self.weaponMain:GetWide() / 3 / 2), 50 + 9 + 2, Color(self.myTeam.menuTeamColor.r, self.myTeam.menuTeamColor.g, self.myTeam.menuTeamColor.b), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		surface.DrawLine(self.weaponMain:GetWide() / 3 * 2 + 12, 50 + 18 + 4, self.weaponMain:GetWide() - 12, 50 + 18 + 4) --horizontal underline for Equipment title

		surface.SetDrawColor(self.myTeam.menuTeamColorAccent.r, self.myTeam.menuTeamColorAccent.g, self.myTeam.menuTeamColorAccent.b)
		surface.DrawLine(self.weaponMain:GetWide() / 3, 50 + 6, self.weaponMain:GetWide() / 3, self.weaponMain:GetTall() - 6) --vertical line separating primary/secondary weapons list
		surface.DrawLine(self.weaponMain:GetWide() / 3 * 2, 50 + 6, self.weaponMain:GetWide() / 3 * 2, self.weaponMain:GetTall() - 6) --vertical line separating secondary/equipment weapons list

		surface.SetDrawColor(self.myTeam.menuTeamColorAccent.r, self.myTeam.menuTeamColorAccent.g, self.myTeam.menuTeamColorAccent.b)
		surface.DrawOutlinedRect(0, 0, self.weaponMain:GetWide(), self.weaponMain:GetTall())
	end
	self.weaponMain.Think = function()
		if not self.Main or not self.Main:IsValid() then
			self.weaponMain:Remove()
		end
		if self.weaponMain:IsValid() then
			self.weaponMain:MakePopup()
		end
	end

	net.Start("RequestAvailableWeapons")
		net.WriteInt(self.myRole, 5)
		print("myRole DEBUG - ", self.myRole)
	net.SendToServer()

	self.weaponMainWeaponListTall = self.weaponMain:GetTall() - 50 - 18 - 8 --Includes spacing
	self.weaponMainPrimaryList = vgui.Create("DScrollPanel", self.weaponMain)
	self.weaponMainPrimaryList:SetSize(self.weaponMain:GetWide() / 3 - 8, self.weaponMainWeaponListTall)
	self.weaponMainPrimaryList:SetPos(4, self.weaponMain:GetTall() - self.weaponMainPrimaryList:GetTall() - 2)

	self.weaponMainSecondaryList = vgui.Create("DScrollPanel", self.weaponMain)
	self.weaponMainSecondaryList:SetSize(self.weaponMain:GetWide() / 3 - 8, self.weaponMainWeaponListTall)
	self.weaponMainSecondaryList:SetPos(self.weaponMain:GetWide() / 3 + 4, self.weaponMain:GetTall() - self.weaponMainSecondaryList:GetTall() - 2)

	self.weaponMainEquipmentList = vgui.Create("DScrollPanel", self.weaponMain)
	self.weaponMainEquipmentList:SetSize(self.weaponMain:GetWide() / 3 - 8, self.weaponMainWeaponListTall)
	self.weaponMainEquipmentList:SetPos(self.weaponMain:GetWide() / 3 * 2 + 4, self.weaponMain:GetTall() - self.weaponMainEquipmentList:GetTall() - 2)

	net.Receive("RequestAvailableWeaponsCallback", function()
		local allWeapons = net.ReadTable()

		for k, v in pairs(allWeapons.primaries) do
			local weaponPanel = vgui.Create("WeaponPanelList", self.weaponMain)
			weaponPanel:SetSize(self.weaponMainPrimaryList:GetWide(), 30)
			weaponPanel:SetFont("MW2FontSmall")
			weaponPanel:SetWep(v.class)
			weaponPanel:SetType(v.type)
			weaponPanel:Dock(TOP)
			weaponPanel:Finish()

			self.weaponMainPrimaryList:AddItem(weaponPanel)
		end

		for k, v in pairs(allWeapons.secondaries) do
			local weaponPanel = vgui.Create("WeaponPanelList", self.weaponMain)
			weaponPanel:SetSize(self.weaponMainSecondaryList:GetWide(), 30)
			weaponPanel:SetFont("MW2FontSmall")
			weaponPanel:SetWep(v.class)
			weaponPanel:SetType(v.type)
			weaponPanel:Dock(TOP)
			weaponPanel:Finish()
			
			self.weaponMainSecondaryList:AddItem(weaponPanel)
		end
		for k, v in pairs(allWeapons.equipment) do
			local weaponPanel = vgui.Create("WeaponPanelList", self.weaponMain)
			weaponPanel:SetSize(self.weaponMainEquipmentList:GetWide(), 30)
			weaponPanel:SetFont("MW2FontSmall")
			weaponPanel:SetWep(v.class)
			weaponPanel:SetType(v.type)
			weaponPanel:Dock(TOP)
			weaponPanel:Finish()
			
			self.weaponMainEquipmentList:AddItem(weaponPanel)
		end
	end)

end

--//Similar to the menu system of Insurgency, players will select their roles in a separate menu
function GM:RoleSelectionMenu()
	if self.roleMain and self.roleMain:IsValid() then return end

    net.Start("RequestLevel")
	net.SendToServer()

	self.roleMain = vgui.Create("DFrame")
	self.roleMain:SetSize(850, 170)
	self.roleMain:SetTitle("")
	self.roleMain:SetVisible(true)
	self.roleMain:SetDraggable(false)
	self.roleMain:ShowCloseButton(false)
	self.roleMain:MakePopup()
	self.roleMain:Center()
	self.roleMainX, self.roleMainY = self.roleMain:GetPos()
    self.roleMain.Paint = function()
		--Derma_DrawBackgroundBlur(self.roleMain, CurTime())
		surface.SetDrawColor(self.myTeam.menuTeamColorDarkAccent.r, self.myTeam.menuTeamColorDarkAccent.g, self.myTeam.menuTeamColorDarkAccent.b)
		surface.DrawRect(0, 0, self.roleMain:GetWide(), self.roleMain:GetTall())

		draw.SimpleText("Select A Role", "MW2FontLarge", 13 / 2, 25, Color(self.myTeam.menuTeamColor.r, self.myTeam.menuTeamColor.g, self.myTeam.menuTeamColor.b), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		surface.SetDrawColor(self.myTeam.menuTeamColor.r, self.myTeam.menuTeamColor.g, self.myTeam.menuTeamColor.b)
		surface.DrawLine(6, 50, self.roleMain:GetWide() - 6, 50)

		surface.SetDrawColor(self.myTeam.menuTeamColorAccent.r, self.myTeam.menuTeamColorAccent.g, self.myTeam.menuTeamColorAccent.b)
		surface.DrawOutlinedRect(0, 0, self.roleMain:GetWide(), self.roleMain:GetTall())
    end
	self.roleMain.Think = function()
		if self.roleMain:IsValid() then
			self.roleMain:MakePopup()
		end
	end

	self.roleMainInfo = vgui.Create("DButton", self.roleMain)
	self.roleMainInfoSize = 50 - 12 --Top bar height - (spacer length * 2)
	self.roleMainInfo:SetSize(self.roleMainInfoSize, self.roleMainInfoSize)
	self.roleMainInfo:SetPos(self.roleMain:GetWide() - self.roleMainInfoSize - 6, 6) --6 = spacer length
	self.roleMainInfo:SetText("")
	--self.roleMainInfoIcon = Material("menu/information_icon_fixed.png", "smooth")
	self.roleMainInfo.Paint = function()
		local w, h = self.roleMainInfo:GetSize()

		surface.SetDrawColor(175, 175, 175)
		--surface.SetMaterial(self.roleMainInfoIcon)
		surface.SetTexture(surface.GetTextureID("gui/info"))
		surface.DrawTexturedRect(0, 0, w, h)

		if self.roleMainInfoHover then
			surface.SetDrawColor(self.myTeam.menuTeamColorLightAccent.r, self.myTeam.menuTeamColorLightAccent.g, self.myTeam.menuTeamColorLightAccent.b)
			surface.DrawTexturedRect(0, 0, w, h)
		end
	end
	self.roleMainInfoPanelText = "Select one of the available roles to see more information about it, and to confirm your selection. You'll next get to customize your loadout. A new role unlocks after every level-up, and each role is a bit different."
	self.roleMainInfo.DoClick = function()
		surface.PlaySound("buttons/lightswitch2.wav")
		if not self.roleMainInfoPanel or not self.roleMainInfoPanel:IsValid() then
			local w, h = self.roleMain:GetPos()
			self.roleMainInfoPanel = vgui.Create("InfoPanel")
			self.roleMainInfoPanel:SetParent(self.roleMain)
			self.roleMainInfoPanel:SetPos(w + self.roleMain:GetWide() + 6, h)
			self.roleMainInfoPanel:SetSize(310, self.roleMain:GetTall())
			self.roleMainInfoPanel:SetText(self.roleMainInfoPanelText, "How this works...")
			self.roleMainInfoPanel:SetFont("MW2Font", "MW2FontLarge")
			self.roleMainInfoPanel:SetColor(self.myTeam)
			self.roleMainInfoPanel:SetTitle("")
			self.roleMainInfoPanel:SetVisible(true)
			self.roleMainInfoPanel:SetDraggable(false)
			self.roleMainInfoPanel:ShowCloseButton(false)
			self.roleMainInfoPanel:MakePopup()
		else
			self.roleMainInfoPanel:Remove()
			self.roleMainInfoPanel = nil
		end
	end
	self.roleMainInfo.OnCursorEntered = function()
		surface.PlaySound("garrysmod/ui_hover.wav")
		self.roleMainInfoHover = true
	end
	self.roleMainInfo.OnCursorExited = function()
		self.roleMainInfoHover = false
	end

	self.roleMainButtonWide = self.roleMain:GetWide() / (#self.Roles + 1)
	self.roleMainButtonWideSpacer = (self.roleMain:GetWide() - (self.roleMainButtonWide * #self.Roles)) / (#self.Roles + 1)
	self.roleMainButtonTall = self.roleMain:GetTall() - 50  - (6 * 2) -- 50 = top bar height, 6 = spacer length
	self.roleMainButtonTallSpacer = 6

	net.Receive("RequestLevelCallback", function(len, ply)
		GAMEMODE.playerLevel = tonumber(net.ReadString()) or 1
		for k, v in ipairs(GAMEMODE.Roles) do
			local but = vgui.Create("RoleSelectionButton", self.roleMain, "but" .. k)
			but:SetSize(self.roleMainButtonWide, self.roleMainButtonTall)
			but:SetPos(self.roleMainButtonWideSpacer * k + self.roleMainButtonWide * (k - 1), self.roleMain:GetTall()  - self.roleMainButtonTall - self.roleMainButtonTallSpacer)
			but:SetImageSize(self.roleMainButtonWide)
			but:SetFont("MW2Font")
			but:SetText(GAMEMODE.Roles[k][self.teamNumberToName[LocalPlayer():Team()]])
			but:SetRole(k)
			if k > GAMEMODE.playerLevel then 
				but:IsLocked(true)
			end
		end
	end)
end

function GM:RoleSelection(role, skipAnimation)
	if (self.Main and self.Main:IsValid()) or (self.roleInfoMain and self.roleInfoMain:IsValid()) then return end

	self.roleInfoMain = vgui.Create("DFrame")
	self.roleInfoMain:SetSize(self.roleMain:GetWide(), 600)
	if not skipAnimation then
		self.roleInfoMain:SetPos(self.roleMainX, self.roleMainY + self.roleMain:GetTall() + 6) --6 = spacer length
	else
		self.roleInfoMain:SetPos(self.roleMainX, self.roleMainY - (self.roleInfoMain:GetTall() / 2) + self.roleMain:GetTall() + 6)
	end
	self.roleInfoMain:SetTitle("")
	self.roleInfoMain:SetVisible(true)
	self.roleInfoMain:SetDraggable(false)
	self.roleInfoMain:ShowCloseButton(false)
	self.roleInfoMain:MakePopup()
	self.roleInfoMain.Paint = function()
		surface.SetDrawColor(self.myTeam.menuTeamColorDarkAccent.r, self.myTeam.menuTeamColorDarkAccent.g, self.myTeam.menuTeamColorDarkAccent.b)
		surface.DrawRect(0, 0, self.roleInfoMain:GetWide(), self.roleInfoMain:GetTall())

		draw.SimpleText("Role Information:", "MW2FontLarge", 13 / 2, 25, Color(self.myTeam.menuTeamColor.r, self.myTeam.menuTeamColor.g, self.myTeam.menuTeamColor.b), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		surface.SetDrawColor(self.myTeam.menuTeamColor.r, self.myTeam.menuTeamColor.g, self.myTeam.menuTeamColor.b)
		surface.DrawLine(6, 50, self.roleInfoMain:GetWide() - 6, 50)
		surface.DrawLine(12, (self.roleInfoMain:GetTall() - 50) / 2 + 50, self.roleInfoMain:GetWide() - 12, (self.roleInfoMain:GetTall() - 50) / 2 + 50) --6 of course being the global spacer

		surface.SetFont("MW2FontLarge")
		local titlewide, titletall = surface.GetTextSize("Role Information:")
		draw.SimpleText(self.Roles[role][self.teamNumberToName[LocalPlayer():Team()]], "MW2FontLarge", titlewide + 13 / 2 + 12, 25, Color(self.myTeam.menuTeamColorAccent.r, self.myTeam.menuTeamColorAccent.g, self.myTeam.menuTeamColorAccent.b), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

		surface.SetDrawColor(self.myTeam.menuTeamColorAccent.r, self.myTeam.menuTeamColorAccent.g, self.myTeam.menuTeamColorAccent.b)
		surface.DrawOutlinedRect(0, 0, self.roleInfoMain:GetWide(), self.roleInfoMain:GetTall())

		draw.SimpleText("Weapon Access", "MW2FontUnderlined", 12, 50 + 6, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
		draw.SimpleText("Armor Information", "MW2FontUnderlined", 12, (self.roleInfoMain:GetTall() - 50) / 2 + 50 + 6, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
	end
	self.roleInfoMain.Think = function()
		if not self.roleMain:IsValid() then
			self.roleInfoMain:Remove()
		end
	end
	if not skipAnimation then
		self.roleMain:MoveTo(self.roleMainX, self.roleMainY - (self.roleInfoMain:GetTall() / 2), 1.5, 0, -1)
		self.roleInfoMain:MoveTo(self.roleMainX, self.roleMainY - (self.roleInfoMain:GetTall() / 2) + self.roleMain:GetTall() + 6, 1.5, 0, -1)
	end

	self.roleInfoMainInfo = vgui.Create("DButton", self.roleInfoMain)
	self.roleInfoMainInfoSize = 50 - 12 --Top bar height - (spacer length * 2)
	self.roleInfoMainInfo:SetSize(self.roleInfoMainInfoSize, self.roleInfoMainInfoSize)
	self.roleInfoMainInfo:SetPos(self.roleInfoMain:GetWide() - self.roleInfoMainInfoSize - 6, 6) --6 = spacer length
	self.roleInfoMainInfo:SetText("")
	--self.roleInfoMainInfoIcon = Material("menu/information_icon_fixed.png", "smooth")
	self.roleInfoMainInfo.Paint = function()
		local w, h = self.roleInfoMainInfo:GetSize()

		surface.SetDrawColor(175, 175, 175)
		--surface.SetMaterial(self.roleInfoMainInfoIcon)
		surface.SetTexture(surface.GetTextureID("gui/info"))
		surface.DrawTexturedRect(0, 0, w, h)

		if self.roleInfoMainInfoHover then
			surface.SetDrawColor(self.myTeam.menuTeamColorLightAccent.r, self.myTeam.menuTeamColorLightAccent.g, self.myTeam.menuTeamColorLightAccent.b)
			surface.DrawTexturedRect(0, 0, w, h)
		end
	end
	self.roleInfoMainInfo.DoClick = function()
		surface.PlaySound("buttons/lightswitch2.wav")
		if not self.roleInfoMainInfoPanel or not self.roleInfoMainInfoPanel:IsValid() then
			local w, h = self.roleInfoMain:GetPos()
			self.roleInfoMainInfoPanel = vgui.Create("InfoPanel")
			self.roleInfoMainInfoPanel:SetPos(w + self.roleInfoMain:GetWide() + 6, h)
			self.roleInfoMainInfoPanel:SetSize(310, self.roleInfoMain:GetTall() / 5)
			self.roleInfoMainInfoPanel:SetText(self.Roles[role].roleDescription, "Role Description:")
			self.roleInfoMainInfoPanel:SetFont("MW2Font", "MW2FontLarge")
			self.roleInfoMainInfoPanel:SetColor(self.myTeam)
			self.roleInfoMainInfoPanel:SetParent(self.roleInfoMain)
			self.roleInfoMainInfoPanel:SetTitle("")
			self.roleInfoMainInfoPanel:SetVisible(true)
			self.roleInfoMainInfoPanel:SetDraggable(false)
			self.roleInfoMainInfoPanel:ShowCloseButton(false)
			self.roleInfoMainInfoPanel:MakePopup()
		else
			self.roleInfoMainInfoPanel:Remove()
			self.roleInfoMainInfoPanel = nil
		end
	end
	self.roleInfoMainInfo.OnCursorEntered = function()
		surface.PlaySound("garrysmod/ui_hover.wav")
		self.roleInfoMainInfoHover = true
	end
	self.roleInfoMainInfo.OnCursorExited = function()
		self.roleInfoMainInfoHover = false
	end

	self.roleInfoMainFinish = vgui.Create("DButton", self.roleInfoMain)
	self.roleInfoMainFinish:SetSize(210, 20)
	self.roleInfoMainFinish:SetPos(self.roleInfoMain:GetWide() / 2 - (self.roleInfoMainFinish:GetWide() / 2), self.roleInfoMain:GetTall() - self.roleInfoMainFinish:GetTall() - 12) --6 = spacer length
	self.roleInfoMainFinish:SetText("")
	self.roleInfoMainFinish.Paint = function()
		local w, h = self.roleInfoMainFinish:GetSize()

		surface.SetDrawColor(self.myTeam.menuTeamColor.r, self.myTeam.menuTeamColor.g, self.myTeam.menuTeamColor.b)
		surface.SetTexture(surface.GetTextureID("gui/center_gradient"))
		surface.DrawTexturedRect(0, 0, w, h)
		draw.SimpleText("Confirm Role Choice", "MW2Font", w / 2, h / 2, Color(255, 255, 255, 150), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

		if self.roleInfoMainFinishHover then
			draw.SimpleText("Confirm Role Choice", "MW2Font", w / 2, h / 2, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			surface.SetDrawColor(self.myTeam.menuTeamColorAccent.r, self.myTeam.menuTeamColorAccent.g, self.myTeam.menuTeamColorAccent.b, 50)
			surface.SetTexture(surface.GetTextureID("gui/center_gradient"))
			surface.DrawTexturedRect(0, 0, w, h)
		end
	end
	self.roleInfoMainFinish.DoClick = function()
		self:LoadoutMenu(role)
		surface.PlaySound("buttons/lightswitch2.wav")
		self.roleInfoMainFinishHover = false
		self.roleMain:Remove()
	end
	self.roleInfoMainFinish.OnCursorEntered = function()
		surface.PlaySound("garrysmod/ui_hover.wav")
		self.roleInfoMainFinishHover = true
	end
	self.roleInfoMainFinish.OnCursorExited = function()
		self.roleInfoMainFinishHover = false
	end

	--Not the best way to draw my icons for weapon availablility and armor information, but I didn't like working with custom vgui elements
	for k, v in ipairs(self.Roles[role].roleDescriptionExpanded) do
		local icon = vgui.Create("InfoIcon", self.roleInfoMain)
		icon:SetSize(self.roleInfoMain:GetWide() / 4 - 6, ((self.roleInfoMain:GetTall() / 2 - 50) - 18 - 12) / 3)
		icon:SetFont("MW2FontSmall")
		icon:SetText(v[1], v[2])
		icon:SetColor(v[3])
		icon:SetImg(self.weaponToIcon[v[1]], 64)
		local baseYOffset = 50 + 12 + 18 --top bar + spacer + Section header height
		if k < 4 then
			icon:SetPos(12, baseYOffset + (6  * (k - 1)) + (icon:GetTall() * (k - 1)))
		elseif k < 7 then
			icon:SetPos(self.roleInfoMain:GetWide() / 4 + 6, baseYOffset + (6  * (k - 4)) + (icon:GetTall() * (k - 4)))
		elseif k < 10 then
			icon:SetPos(self.roleInfoMain:GetWide() / 4 * 2 + 6, baseYOffset + (6  * (k - 7)) + (icon:GetTall() * (k - 7)))
		else
			icon:SetPos(self.roleInfoMain:GetWide() / 4 * 3, baseYOffset + (6  * (k - 10)) + (icon:GetTall() * (k - 10)))
		end
	end

	for k, v in pairs(self.Roles[role].armorRating) do
		local baseYOffset = ((self.roleInfoMain:GetTall() - 50) / 2) + 50 + 12 + 18 --top half of self.roleInfoMain + top bar + spacer + Section header height
		if isstring(v) then
			local armorName = vgui.Create("DPanel", self.roleInfoMain)
			armorName:SetSize(80, 12)
			armorName:SetPos(self.roleInfoMain:GetWide() / 2 - armorName:GetWide() / 2, self.roleInfoMain:GetTall() - 52 - self.roleInfoMainFinish:GetTall() - 22)
			armorName.Paint = function()
				draw.SimpleText("Armor Type:", "MW2FontSmall", 0, armorName:GetTall() / 2 + 2, Color(self.myTeam.menuTeamColor.r, self.myTeam.menuTeamColor.g, self.myTeam.menuTeamColor.b), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			end
		elseif istable(v) then
			if k == "damageScaling" then
				for k2, v2 in pairs(v) do
					local icon = vgui.Create("InfoIcon", self.roleInfoMain)
					icon:SetSize(self.roleInfoMain:GetWide() / 4 - 6, ((self.roleInfoMain:GetTall() / 2 - 50) - 18 - 12) / 3)
					icon:SetFont("MW2FontSmall")
					icon:SetPos(12 + ((self.roleInfoMain:GetWide() / 4) * (k2 - 1)), baseYOffset)
					icon:SetImg(self.armorToIcon[k][k2][2])
					icon:SetText(self.armorToIcon[k][k2][1], tostring(v2 * 100) .. "%")
					if v2 < self.Armor[2][k][k2] then
						icon:SetColor(Color(0, 160, 0))
					elseif v2 > self.Armor[2][k][k2] then
						icon:SetColor(Color(238, 210, 2))
					end
				end
			else
				for k2, v2 in pairs(v) do
					local icon = vgui.Create("InfoIcon", self.roleInfoMain)
					icon:SetSize(self.roleInfoMain:GetWide() / 4 - 6, ((self.roleInfoMain:GetTall() / 2 - 50) - 18 - 12) / 3)
					icon:SetFont("MW2FontSmall")
					icon:SetPos(12 + ((self.roleInfoMain:GetWide() / 4) * (k2 - 1)), baseYOffset + icon:GetTall() + 6)
					icon:SetImg(self.armorToIcon[k][k2][2])
					icon:SetText(self.armorToIcon[k][k2][1], v2)
					if v2 > self.Armor[2][k][k2] then
						icon:SetColor(Color(0, 160, 0))
					elseif v2 < self.Armor[2][k][k2] then
						icon:SetColor(Color(238, 210, 2))
					end
				end
			end
		else
			local icon = vgui.Create("InfoIcon", self.roleInfoMain)
			icon:SetSize(self.roleInfoMain:GetWide() / 4 - 6, ((self.roleInfoMain:GetTall() / 2 - 50) - 18 - 12) / 3)
			icon:SetFont("MW2FontSmall")
			icon:SetPos(12 + (self.roleInfoMain:GetWide() / 4 * 3), baseYOffset + icon:GetTall() + 6)
			icon:SetImg(self.armorToIcon[k])
			icon:SetText("Health", v)
			if v > self.Armor[2][k] then
				icon:SetColor(Color(0, 160, 0))
			elseif v < self.Armor[2][k] then
				icon:SetColor(Color(238, 210, 2))
			end
		end
	end

	self.roleInfoMainArmors = vgui.Create("DPanel", self.roleInfoMain)
	self.roleInfoMainArmors:SetSize(self.roleInfoMain:GetWide(), 20)
	self.roleInfoMainArmors:SetPos(0, self.roleInfoMain:GetTall() - 52 - self.roleInfoMainFinish:GetTall())
	self.roleInfoMainArmorsPOS = {
		{x = self.roleInfoMainArmors:GetWide() / 8, y = self.roleInfoMainArmors:GetTall() / 2, name = self.Armor[1].armorName .. " Armor"},
		{x = self.roleInfoMainArmors:GetWide() / 8 + (self.roleInfoMainArmors:GetWide() / 4), y = self.roleInfoMainArmors:GetTall() / 2, name = self.Armor[2].armorName .. " Armor"},
		{x = self.roleInfoMainArmors:GetWide() / 8 + (self.roleInfoMainArmors:GetWide() / 4 * 2), y = self.roleInfoMainArmors:GetTall() / 2, name = self.Armor[3].armorName .. " Armor"},
		{x = self.roleInfoMainArmors:GetWide() / 8 + (self.roleInfoMainArmors:GetWide() / 4 * 3), y = self.roleInfoMainArmors:GetTall() / 2, name = self.Armor[4].armorName .. " Armor"}
	}
	local toHighlight = table.KeyFromValue(self.Armor, self.Roles[role].armorRating)
	self.roleInfoMainArmors.Paint = function()
		surface.SetDrawColor(self.myTeam.menuTeamColor.r, self.myTeam.menuTeamColor.g, self.myTeam.menuTeamColor.b)
		surface.DrawLine(self.roleInfoMainArmors:GetWide() / 4, 0, self.roleInfoMainArmors:GetWide() / 4, self.roleInfoMainArmors:GetTall())
		surface.DrawLine(self.roleInfoMainArmors:GetWide() / 4 * 2, 0, self.roleInfoMainArmors:GetWide() / 4 * 2, self.roleInfoMainArmors:GetTall())
		surface.DrawLine(self.roleInfoMainArmors:GetWide() / 4 * 3, 0, self.roleInfoMainArmors:GetWide() / 4 * 3, self.roleInfoMainArmors:GetTall())

		for i = 1, 4 do
			if i == toHighlight then
				draw.SimpleText(self.roleInfoMainArmorsPOS[toHighlight].name, "MW2Font", self.roleInfoMainArmorsPOS[toHighlight].x, self.roleInfoMainArmorsPOS[toHighlight].y, Color(self.myTeam.menuTeamColorLightAccent.r, self.myTeam.menuTeamColorLightAccent.g, self.myTeam.menuTeamColorLightAccent.b), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			else
				draw.SimpleText(self.roleInfoMainArmorsPOS[i].name, "MW2Font", self.roleInfoMainArmorsPOS[i].x, self.roleInfoMainArmorsPOS[i].y, Color(175, 175, 175), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end
		end
	end
end

--The menu that appears when you click on the shopping cart
function GM:ShopMenu()
	print("ShopMenu function debug", LocalPlayer():Team())
	if LocalPlayer():Team() != 1 and LocalPlayer():Team() != 2 and LocalPlayer():Team() != 3 then return end

	self.Main:Close()
	
	net.Start("RequestPurchasedWeapons")
	net.SendToServer()

	--//Get what weapon types we want to display in the shop
	self.availableWeaponTypes = {}
	local extraTable = {}
	for k, v in pairs(self.menuWeaponInfo.primaries) do
		if not extraTable[table.KeyFromValue(self.weaponTypes, v[2])] then
			extraTable[table.KeyFromValue(self.weaponTypes, v[2])] = v[2]
		end
	end
	for k, v in pairs(self.menuWeaponInfo.secondaries) do
		if not extraTable[table.KeyFromValue(self.weaponTypes, v[2])] then
			extraTable[table.KeyFromValue(self.weaponTypes, v[2])] = v[2]
		end
	end
	for k, v in pairs(extraTable) do --Done because there's a bunch of open numbers in self.weaponTypes, like 6, 7, 8, 9, etc
		self.availableWeaponTypes[#self.availableWeaponTypes + 1] = v
	end

	--//The width and height of the two panels (weapons and attachments), the rest of the menu scales with these numbers
	self.shopMainWide = 350
	self.shopMainTall = 550

	self.shopMainWeapon = vgui.Create("DFrame")
	self.shopMainWeapon:SetSize(self.shopMainWide, self.shopMainTall)
	self.shopMainWeapon:SetTitle("")
	self.shopMainWeapon:SetVisible(true)
	self.shopMainWeapon:SetDraggable(false)
	self.shopMainWeapon:ShowCloseButton(false)
	self.shopMainWeapon:MakePopup()
	self.shopMainWeapon:Center()
	self.shopMainWeapon.Paint = function()
		surface.SetDrawColor(self.myTeam.menuTeamColorDarkAccent.r, self.myTeam.menuTeamColorDarkAccent.g, self.myTeam.menuTeamColorDarkAccent.b)
		surface.DrawRect(0, 0, self.shopMainWeapon:GetWide(), self.shopMainWeapon:GetTall())

		surface.SetDrawColor(self.myTeam.menuTeamColorAccent.r, self.myTeam.menuTeamColorAccent.g, self.myTeam.menuTeamColorAccent.b)
		surface.DrawOutlinedRect(0, 0, self.shopMainWeapon:GetWide(), self.shopMainWeapon:GetTall())

		surface.SetDrawColor(self.myTeam.menuTeamColor.r, self.myTeam.menuTeamColor.g, self.myTeam.menuTeamColor.b)
		draw.SimpleText("Weapons", "MW2FontLarge", self.shopMainWeapon:GetWide() - (13 / 2), 25, Color(self.myTeam.menuTeamColor.r, self.myTeam.menuTeamColor.g, self.myTeam.menuTeamColor.b), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
		surface.DrawLine(6, 50, self.shopMainWeapon:GetWide() - 6, 50)
	end
	self.shopMainWeapon.Think = function()
		if not self.shopMainAttachment or not self.shopMainAttachment:IsValid() then
			self.shopMainWeapon:Remove()
		end
		self.shopMainWeaponX, self.shopMainWeaponY = self.shopMainWeapon:GetPos()
	end
	self.shopMainWeaponX, self.shopMainWeaponY = self.shopMainWeapon:GetPos()

	self.shopMainWeaponList = vgui.Create("DScrollPanel", self.shopMainWeapon)
	self.shopMainWeaponList:SetSize(self.shopMainWeapon:GetWide() - 6, self.shopMainWeapon:GetTall() / 2)
	self.shopMainWeaponList:SetPos(3, 50 + 3)
	self.shopMainWeaponList.Paint = function()
		surface.SetDrawColor(self.myTeam.menuTeamColorLightAccent.r, self.myTeam.menuTeamColorLightAccent.g, self.myTeam.menuTeamColorLightAccent.b)
		surface.DrawOutlinedRect(0, 0, self.shopMainWeaponList:GetSize())
	end

	self.purchasedWeapons = {}
	self.weaponShopWeaponPanelTall = 35
	net.Receive("RequestPurchasedWeaponsCallback", function() --May need to be called down below
		self.purchasedWeapons = net.ReadTable()
		local counter = 0
		for k, v in pairs(self.availableWeaponTypes) do --List off all of the available weapons that can be purchased
			local typeTitle = vgui.Create("DPanel", self.shopMainWeaponList)
			typeTitle:SetSize(self.shopMainWeaponList:GetWide(), self.weaponShopWeaponPanelTall)
			typeTitle:SetPos(0, counter * self.weaponShopWeaponPanelTall)
			typeTitle.Paint = function()
				draw.SimpleText(v, "MW2FontLarge", typeTitle:GetWide() / 2, typeTitle:GetTall() / 2, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				surface.SetDrawColor(self.myTeam.menuTeamColorLightAccent.r, self.myTeam.menuTeamColorLightAccent.g, self.myTeam.menuTeamColorLightAccent.b)
				surface.DrawLine(8, typeTitle:GetTall() - 2, typeTitle:GetWide() - 8, typeTitle:GetTall() - 2)
			end

			counter = counter + 1
			local emptyCheck = counter
			if v == self.weaponTypes[13] then
				for k2, v2 in pairs(self.menuWeaponInfo.secondaries) do
					if not self.purchasedWeapons[k2] and v2[3] == 3 then
						local weaponShopWeaponPanel = vgui.Create("DButton", self.shopMainWeaponList)
						weaponShopWeaponPanel:SetSize(self.shopMainWeaponList:GetWide(), self.weaponShopWeaponPanelTall)
						weaponShopWeaponPanel:SetPos(0, counter * self.weaponShopWeaponPanelTall)
						weaponShopWeaponPanel:SetText("")
						weaponShopWeaponPanel.DoClick = function()
							surface.PlaySound("buttons/lightswitch2.wav")
							self:RefreshShopWeapon() --Missing wep
						end
						weaponShopWeaponPanel.OnCursorEntered = function()
							weaponShopWeaponPanel.hover = true
						end
						weaponShopWeaponPanel.OnCursorExited = function()
							weaponShopWeaponPanel.hover = false
						end
						weaponShopWeaponPanel.Paint = function()--weaponListPaint(v2[1], weaponShopWeaponPanel.hover, weaponShopWeaponPanel:GetWide(), weaponShopWeaponPanel:GetTall())
							if weaponShopWeaponPanel.hover then
								draw.SimpleText(v2[1], "MW2Font", weaponShopWeaponPanel:GetWide() / 2, weaponShopWeaponPanel:GetTall() / 2, Color(self.myTeam.menuTeamColor.r, self.myTeam.menuTeamColor.g, self.myTeam.menuTeamColor.b), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
							else
								draw.SimpleText(v2[1], "MW2Font", weaponShopWeaponPanel:GetWide() / 2, weaponShopWeaponPanel:GetTall() / 2, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
							end
						end

						counter = counter + 1
					end
				end
			else
				for k2, v2 in pairs(self.menuWeaponInfo.primaries) do
					if not self.purchasedWeapons[k2] and v2[3] == 3 and v == v2[2] then
						local weaponShopWeaponPanel = vgui.Create("DButton", self.shopMainWeaponList)
						weaponShopWeaponPanel:SetSize(self.shopMainWeaponList:GetWide(), self.weaponShopWeaponPanelTall)
						weaponShopWeaponPanel:SetPos(0, counter * self.weaponShopWeaponPanelTall)
						weaponShopWeaponPanel:SetText("")
						weaponShopWeaponPanel.DoClick = function()
							surface.PlaySound("buttons/lightswitch2.wav")
							self:RefreshShopWeapon() --Missing wep
						end
						weaponShopWeaponPanel.OnCursorEntered = function()
							weaponShopWeaponPanel.hover = true
						end
						weaponShopWeaponPanel.OnCursorExited = function()
							weaponShopWeaponPanel.hover = false
						end
						weaponShopWeaponPanel.Paint = function()--weaponListPaint(v2[1], weaponShopWeaponPanel.hover, weaponShopWeaponPanel:GetWide(), weaponShopWeaponPanel:GetTall())
							if weaponShopWeaponPanel.hover then
								draw.SimpleText(v2[1], "MW2Font", weaponShopWeaponPanel:GetWide() / 2, weaponShopWeaponPanel:GetTall() / 2, Color(self.myTeam.menuTeamColor.r, self.myTeam.menuTeamColor.g, self.myTeam.menuTeamColor.b), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
							else
								draw.SimpleText(v2[1], "MW2Font", weaponShopWeaponPanel:GetWide() / 2, weaponShopWeaponPanel:GetTall() / 2, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
							end
						end

						counter = counter + 1
					end
				end
			end
			if emptyCheck == counter then --If the type doesn't have any weapons to display, remove the type from the list
				typeTitle:Remove()
				counter = counter - 1
			end
		end
	end)

	function self:RefreshShopWeapon(wep)
		if weaponShopSelectedWeaponPanel then weaponShopSelectedWeaponPanel:Remove() weaponShopSelectedWeaponPanel = nil end
		local weaponShopSelectedWeaponPanel = vgui.Create("DPanel", self.shopMainWeapon)
		weaponShopSelectedWeaponPanel:SetPos(0, self.shopMainWeapon:GetTall() / 2 + 1)
		weaponShopSelectedWeaponPanel:SetSize(self.shopMainWeapon:GetWide(), self.shopMainWeapon:GetTall() / 2)
		weaponShopSelectedWeaponPanel.Paint = function()

		end

		local weaponShopSelectedWeaponPanelModel = vgui.Create("DModelPanel", weaponShopSelectedWeaponPanel)
		weaponShopSelectedWeaponPanelModel:SetSize(weaponShopSelectedWeaponPanelModel:GetWide(), weaponShopSelectedWeaponPanelModel:GetTall() / 2)
		weaponShopSelectedWeaponPanelModel:SetPos(0, 0)
		weaponShopSelectedWeaponPanelModel:SetModel(wep:GetModel())

		--//Let's do some bars for damage, accuracy, recoil, ammo, and maybe some more like DPS
	end

	--[[self.shopMainWeaponTypeButtons = {}
	for k, v in pairs(self.availableWeaponTypes) do
		self.shopMainWeaponTypeButtons[k] = vgui.Create("DButton", self.shopMainWeapon)
		self.shopMainWeaponTypeButtons[k]:SetSize(#self.availableWeaponTypes / (self.shopMainWeapon:GetWide() - 4), 30)
		self.shopMainWeaponTypeButtons[k]:SetPos((k - 1) * #self.availableWeaponTypes + 2, - 50 + 1 + self.shopMainWeaponTypeButtons[k]:GetTall())
		self.shopMainWeaponTypeButtons[k]:SetText("")
		self.shopMainWeaponTypeButtons[k].DoClick = function()
			surface.PlaySound("buttons/lightswitch2.wav")
			self:RefreshShopWeapons()
		end
		self.shopMainWeaponTypeButtons[k].Paint = function()
			surface.SetDrawColor(self.myTeam.menuTeamColorLightAccent.r, self.myTeam.menuTeamColorLightAccent.g, self.myTeam.menuTeamColorLightAccent.b)
			surface.DrawOutlinedRect(0, 0, self.shopMainWeaponTypeButtons[k]:GetSize())
			draw.SimpleText(v, "MW2Font", self.shopMainWeaponTypeButtons[k]:GetWide() / 2, self.shopMainWeaponTypeButtons[k]:GetTall() / 2, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			
			if self.shopMainWeaponTypeButtons[k].hover then
				surface.SetDrawColor(self.myTeam.menuTeamColorLightAccent.r, self.myTeam.menuTeamColorLightAccent.g, self.myTeam.menuTeamColorLightAccent.b)
				--surface.DrawTexturedRect(1, 1, self.shopMainWeaponTypeButtons[k]:GetWide() - 1, self.shopMainWeaponTypeButtons[k]:GetTall() - 1)
				surface.DrawOutlinedRect(0, 0, self.shopMainWeaponTypeButtons[k]:GetWide(), self.shopMainWeaponTypeButtons[k]:GetTall())
			end
		end
		self.shopMainWeaponTypeButtons[k].OnCursorEntered = function()
			surface.PlaySound("garrysmod/ui_hover.wav")
			self.shopMainWeaponTypeButtons[k].hover = true
		end
		self.shopMainWeaponTypeButtons[k].OnCursorExited = function()
			self.shopMainWeaponTypeButtons[k].hover = false
		end
	end]]

	function self:RefreshShopWeapons()

	end

	--//The attachment, right half of the shop menu, dedicated to purchasing attachments
	self.shopMainAttachment = vgui.Create("DFrame")
	self.shopMainAttachment:SetSize(self.shopMainWide, self.shopMainTall)
	self.shopMainAttachment:SetTitle("")
	self.shopMainAttachment:SetVisible(true)
	self.shopMainAttachment:SetDraggable(false)
	self.shopMainAttachment:ShowCloseButton(false)
	self.shopMainAttachment:MakePopup()
	self.shopMainAttachment:Center()
	self.shopMainAttachment.Paint = function()
		surface.SetDrawColor(self.myTeam.menuTeamColorDarkAccent.r, self.myTeam.menuTeamColorDarkAccent.g, self.myTeam.menuTeamColorDarkAccent.b)
		surface.DrawRect(0, 0, self.shopMainAttachment:GetWide(), self.shopMainAttachment:GetTall())

		surface.SetDrawColor(self.myTeam.menuTeamColorAccent.r, self.myTeam.menuTeamColorAccent.g, self.myTeam.menuTeamColorAccent.b)
		surface.DrawOutlinedRect(0, 0, self.shopMainAttachment:GetWide(), self.shopMainAttachment:GetTall())

		surface.SetDrawColor(self.myTeam.menuTeamColor.r, self.myTeam.menuTeamColor.g, self.myTeam.menuTeamColor.b)
		draw.SimpleText("Attachments", "MW2FontLarge", 13 / 2, 25, Color(self.myTeam.menuTeamColor.r, self.myTeam.menuTeamColor.g, self.myTeam.menuTeamColor.b), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		surface.DrawLine(6, 50, self.shopMainAttachment:GetWide() - 6, 50)
	end
	self.shopMainAttachment.Think = function()
		if not self.shopMainWeapon or not self.shopMainWeapon:IsValid() then
			self.shopMainAttachment:Remove()
		end
		self.shopMainAttachmentX, self.shopMainAttachmentY = self.shopMainAttachment:GetPos()
	end
	self.shopMainAttachmentX, self.shopMainAttachmentY = self.shopMainAttachment:GetPos()

	function self:RefreshShopAttachments(weapon)

	end

	--//Just the shop title frame, no unique logic
	surface.SetFont("MW2FontLarge")
	self.shopMainTitleWide, self.shopMainTitleTall = surface.GetTextSize("| -- Weapon & Attachment Shop -- |")
	self.shopMainTitle = vgui.Create("DFrame")
	self.shopMainTitle:SetSize(self.shopMainTitleWide + 10, self.shopMainTitleTall + 10)
	self.shopMainTitle:SetTitle("")
	self.shopMainTitle:SetVisible(true)
	self.shopMainTitle:SetDraggable(false)
	self.shopMainTitle:ShowCloseButton(false)
	self.shopMainTitle:MakePopup()
	self.shopMainTitle:Center()
	self.shopMainTitle.Paint = function()
		surface.SetDrawColor(self.myTeam.menuTeamColorDarkAccent.r, self.myTeam.menuTeamColorDarkAccent.g, self.myTeam.menuTeamColorDarkAccent.b)
		surface.DrawRect(0, 0, self.shopMainTitle:GetWide(), self.shopMainTitle:GetTall())

		surface.SetDrawColor(self.myTeam.menuTeamColorAccent.r, self.myTeam.menuTeamColorAccent.g, self.myTeam.menuTeamColorAccent.b)
		surface.DrawOutlinedRect(0, 0, self.shopMainTitle:GetWide(), self.shopMainTitle:GetTall())

		surface.SetDrawColor(self.myTeam.menuTeamColor.r, self.myTeam.menuTeamColor.g, self.myTeam.menuTeamColor.b)
		draw.SimpleText("| -- Weapon & Attachment Shop -- |", "MW2FontLarge", self.shopMainTitle:GetWide() / 2, self.shopMainTitle:GetTall() / 2, Color(self.myTeam.menuTeamColor.r, self.myTeam.menuTeamColor.g, self.myTeam.menuTeamColor.b), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
	self.shopMainTitle.Think = function()
		if not self.shopMainWeapon or not self.shopMainWeapon:IsValid() or not self.shopMainAttachment or not self.shopMainAttachment:IsValid() then
			self.shopMainTitle:Remove()
		end
		self.shopMainTitleX, self.shopMainTitleY = self.shopMainTitle:GetPos()
	end
	self.shopMainTitleX, self.shopMainTitleY = self.shopMainTitle:GetPos()

	--//Shows player $ and provides a close button
	self.shopMainInfoText = markup.Parse("<font=MW2Font><colour=" .. self.myTeam.menuTeamColor.r .. "," .. self.myTeam.menuTeamColor.g .. "," .. self.myTeam.menuTeamColor.b .. ">Your Cash: $</colour>" .. comma_value(self.playerMoney))
	self.shopMainInfo = vgui.Create("DFrame")
	self.shopMainInfo:SetSize(self.shopMainInfoText:GetWidth() + 55 + 10, self.shopMainInfoText:GetHeight() + 10)
	self.shopMainInfo:SetTitle("")
	self.shopMainInfo:SetVisible(true)
	self.shopMainInfo:SetDraggable(false)
	self.shopMainInfo:ShowCloseButton(false)
	self.shopMainInfo:MakePopup()
	self.shopMainInfo:Center()
	self.shopMainInfo.Paint = function()
		surface.SetDrawColor(self.myTeam.menuTeamColorDarkAccent.r, self.myTeam.menuTeamColorDarkAccent.g, self.myTeam.menuTeamColorDarkAccent.b)
		surface.DrawRect(0, 0, self.shopMainInfo:GetWide(), self.shopMainInfo:GetTall())

		surface.SetDrawColor(self.myTeam.menuTeamColorAccent.r, self.myTeam.menuTeamColorAccent.g, self.myTeam.menuTeamColorAccent.b)
		surface.DrawOutlinedRect(0, 0, self.shopMainInfo:GetWide(), self.shopMainInfo:GetTall())

		surface.SetDrawColor(self.myTeam.menuTeamColor.r, self.myTeam.menuTeamColor.g, self.myTeam.menuTeamColor.b)
		self.shopMainInfoText:Draw(5, self.shopMainInfo:GetTall() / 2 - 1, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	end
	self.shopMainInfo.Think = function()
		if not self.shopMainWeapon or not self.shopMainWeapon:IsValid() or not self.shopMainAttachment or not self.shopMainAttachment:IsValid() then
			self.shopMainInfo:Remove()
		end
		self.shopMainInfoX, self.shopMainInfoY = self.shopMainInfo:GetPos()
	end
	self.shopMainInfoX, self.shopMainInfoY = self.shopMainInfo:GetPos()

	self.shopMainExitButton = vgui.Create("DButton", self.shopMainInfo)
	self.shopMainExitButton:SetSize(20, self.shopMainInfo:GetTall())
	self.shopMainExitButton:SetPos(self.shopMainInfo:GetWide() - self.shopMainExitButton:GetWide() - 5, -2)
	self.shopMainExitButton:SetText("")
	self.shopMainExitButton.Paint = function()
		draw.SimpleText("X", "MW2FontLarge", 0, 0, Color(175, 175, 175))
		if self.shopMainExitButton.hover then
			draw.SimpleText("X", "MW2FontLarge", 0, 0, Color(self.myTeam.menuTeamColorLightAccent.r, self.myTeam.menuTeamColorLightAccent.g, self.myTeam.menuTeamColorLightAccent.b))
		end
	end
	self.shopMainExitButton.DoClick = function()
		self.shopMainWeapon:Remove()
		self.shopMainAttachment:Remove()
		self.shopMainInfo:Remove()
		self.shopMainExitButton.hover = false
		self:LoadoutMenu()
	end
	self.shopMainExitButton.OnCursorEntered = function()
		self.shopMainExitButton.hover = true
	end
	self.shopMainExitButton.OnCursorExited = function()
		self.shopMainExitButton.hover = false
	end

	self.shopMainTitle:MoveTo(self.shopMainTitleX, self.shopMainTitleY - (self.shopMainTitle:GetTall() / 2) - (self.shopMainWeapon:GetTall() / 2) - 2, 0)
	self.shopMainInfo:MoveTo(self.shopMainInfoX, self.shopMainInfoY + (self.shopMainInfo:GetTall() / 2) + (self.shopMainWeapon:GetTall() / 2) + 2, 0)
	self.shopMainWeapon:MoveTo(self.shopMainWeaponX - (self.shopMainWeapon:GetWide() / 2) - 1, self.shopMainWeaponY, 0)
	self.shopMainAttachment:MoveTo(self.shopMainAttachmentX + (self.shopMainAttachment:GetWide() / 2) + 1, self.shopMainAttachmentY, 0)

	--[[self.shopMainWeaponTypeButtons = {}
	for k, v in pairs(self.availableWeaponTypes) do
		self.shopMainWeaponTypeButtons[k] = vgui.Create("DButton", self.shopMain)
		self.shopMainWeaponTypeButtons[k]:SetSize(self.playerInfoMainPictureSize, self.playerInfoMainPictureSize)
		self.shopMainWeaponTypeButtons[k]:SetPos(self.playerInfoMain:GetWide() - self.playerInfoMainPictureSize)
		self.shopMainWeaponTypeButtons[k]:SetText("")
		self.shopMainWeaponTypeButtons[k].DoClick = function()
			surface.PlaySound("buttons/lightswitch2.wav")
			self:RefreshShopWeapons()
		end
		self.shopMainWeaponTypeButtons[k].Paint = function()
			
			
			if self.shopMainWeaponTypeButtons[k].hover then
				surface.SetDrawColor(self.myTeam.menuTeamColorLightAccent.r, self.myTeam.menuTeamColorLightAccent.g, self.myTeam.menuTeamColorLightAccent.b)
				surface.DrawTexturedRect(1, 1, self.shopMainWeaponTypeButtons[k]:GetWide() - 1, self.shopMainWeaponTypeButtons[k]:GetTall() - 1)
				--surface.DrawOutlinedRect(0, 0, self.shopMainWeaponTypeButtons[k]:GetWide(), self.shopMainWeaponTypeButtons[k]:GetTall())
			end
		end
		self.shopMainWeaponTypeButtons[k].OnCursorEntered = function()
			surface.PlaySound("garrysmod/ui_hover.wav")
			self.shopMainWeaponTypeButtons[k].hover = true
		end
		self.shopMainWeaponTypeButtons[k].OnCursorExited = function()
			self.shopMainWeaponTypeButtons[k].hover = false
		end
	end

	function self:RefreshShopWeapons()
		if #self.shopMainWeaponList:GetChildren() > 0 then 
			for k, v in pairs(self.shopMainWeaponList:GetChildren()) do
				v:Remove()
			end
		end

		self.shopMainWeaponList = vgui.Create("DScrollPanel", self.shopMain)
		
	end]]
end

function GM:TeamSelectionMenu()
	--//After selecting one of two available teams, auto-opens LoadoutMenu()
	if (self.Main and self.Main:IsValid()) or (self.roleInfoMain and self.roleInfoMain:IsValid()) then return end --Later include functionality for when shop is open

	--[[net.Start("RequestTeamBalanceStatus") --Asked when menu initially opens up, received once after and whenever a play switches teams
	net.SendToServer()]]

	self.teamMain = vgui.Create("DFrame")
	self.teamMain:SetSize(1000, 428) --21:9 aspect ratio, it should actually be 428.5 but I don't think you can do half-pixels
	self.teamMain:SetTitle("")
	self.teamMain:SetVisible(true)
	self.teamMain:SetDraggable(false)
	self.teamMain:ShowCloseButton(false)
	self.teamMain:MakePopup()
	self.teamMain:Center()
	self.teamMain.Paint = function()
		surface.SetDrawColor(255, 255, 255, 100)
		surface.DrawRect(0, 0, self.teamMain:GetWide(), self.teamMain:GetTall())
	end
	self.teamMain.Think = function()
		if (self.Main and self.Main:IsValid()) or (self.roleInfoMain and self.roleInfoMain:IsValid()) then
			self.teamMain:Remove()
		end
	end

	self.redTeamJoinable = true
	self.teamMainRedTeam = vgui.Create("DButton", self.teamMain)
	self.teamMainRedTeam:SetSize()
	self.teamMainRedTeam:SetPos(0, 0)
	self.teamMainRedTeam:SetText("")
	self.teamMainRedTeam.Paint = function()

	end
	self.teamMainRedTeam.DoClick = function()
		if not self.redTeamJoinable then return end

	end
	self.teamMainRedTeam.OnCursorEntered = function()
		if not self.redTeamJoinable then return end
		self.teamMainRedTeamHover = true
	end
	self.teamMainRedTeam.OnCursorExited = function()
		self.teamMainRedTeamHover = false
	end

	self.blueTeamJoinable = true
	self.teamMainBlueTeam = vgui.Create("DButton", self.teamMain)
	self.teamMainBlueTeam:SetSize()
	self.teamMainBlueTeam:SetPos()
	self.teamMainBlueTeam:SetText("")
	self.teamMainBlueTeam.Paint = function()

	end
	self.teamMainBlueTeam.DoClick = function()
		if not self.blueTeamJoinable then return end

	end
	self.teamMainBlueTeam.OnCursorEntered = function()
		if not self.blueTeamJoinable then return end
		self.teamMainBlueTeamHover = true
	end
	self.teamMainBlueTeam.OnCursorExited = function()
		self.teamMainBlueTeamHover = false
	end

	net.Receive("RequestTeamBalanceStatusCallback", function()
		self.redTeamJoinable = net.ReadBool()
		self.blueTeamJoinable = net.ReadBool()
		if not self.redTeamJoinable then
			self.teamMainRedTeamHover = false
		elseif not self.blueTeamJoinable then
			self.teamMainBlueTeam = false
		end
	end)
end

concommand.Add("pol_menu", GM.LoadoutMenu)

function GM:PlayerButtonDown( ply, button )
	if input.GetKeyName( button ) == "c" then
		if self.Main and self.Main:IsValid() then
			self.Main:Close()
			self.Main = nil
		else
			self:LoadoutMenu()
		end
	end
end