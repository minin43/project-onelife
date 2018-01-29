--//This file is strictly for creating/registering custom vgui elements
--//Never done this before so I apologize now if I make some mistakes

local roleSelectionButton = {}
roleSelectionButton.font = "DermaLarge"
roleSelectionButton.text = ""
roleSelectionButton.imgsrc = ""
roleSelectionButton.img = Material("menu/role_rifleman_icon_fixed.png", "smooth")
roleSelectionButton.lockedImg = Material("menu/lock_icon.png", "smooth")
roleSelectionButton.title = false
roleSelectionButton.locked = false
roleSelectionButton.role = 1 --Default value, always unlocked
roleSelectionButton.w, roleSelectionButton.h = 32, 32

function roleSelectionButton:SetFont(font)
    self.font = font
end

function roleSelectionButton:SetText(text)
    self.text = text
end

function roleSelectionButton:SetRole(num)
    self.role = num
    self.img = GAMEMODE.Roles[num].roleIcon
end

function roleSelectionButton:SetImageSize(w, h)
    self.w = w
    self.h = h or w
end

function roleSelectionButton:IsLocked(bool)
    self.locked = bool
end

function roleSelectionButton:DoClick()
    if self.locked then return end
    GAMEMODE.roleMainButtonNumber = self.role
    surface.PlaySound("buttons/lightswitch2.wav")
    if GAMEMODE.roleInfoMain and GAMEMODE.roleInfoMain:IsValid() then
        GAMEMODE.roleInfoMain:Remove()
        GAMEMODE:RoleSelection(self.role, true)
    else
        GAMEMODE:RoleSelection(self.role)
    end
    roleSelectionButton.selectedButton = self
end

function roleSelectionButton:OnCursorEntered()
    if self.locked then return end
    surface.PlaySound("garrysmod/ui_hover.wav")
    self.cursorEntered = true
end

function roleSelectionButton:OnCursorExited()
    self.cursorEntered = false
end

function roleSelectionButton:Paint()
    local w, h = self:GetSize()
    
    if self.locked then
        surface.SetDrawColor(255, 255, 255)
        surface.SetMaterial(self.lockedImg)
        surface.DrawTexturedRect(0, 0, self.w, self.h)
        draw.SimpleText("LOCKED", self.font, w / 2, self.h + ((h - self.h) / 2), Color(180, 0, 0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        --self.lockedImg:SetFloat("$pp_colour_addr", 1)
    else
        surface.SetDrawColor(255, 255, 255)
        surface.SetMaterial(self.img)
        surface.DrawTexturedRect(0, 0, self.w, self.h)

        draw.SimpleText(self.text, self.font, w / 2, self.h + ((h - self.h) / 2), Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        if self.cursorEntered then
            surface.SetDrawColor(GAMEMODE.myTeam.menuTeamColorLightAccent.r, GAMEMODE.myTeam.menuTeamColorLightAccent.g, GAMEMODE.myTeam.menuTeamColorLightAccent.b)
            surface.DrawOutlinedRect(0, 0, w, h)
        end
    end

    if roleSelectionButton.selectedButton == self then
        surface.SetDrawColor(GAMEMODE.myTeam.menuTeamColorLightAccent.r, GAMEMODE.myTeam.menuTeamColorLightAccent.g, GAMEMODE.myTeam.menuTeamColorLightAccent.b)
        surface.DrawOutlinedRect(0, 0 - 1, w, h + 2)
    end
    return true
end

vgui.Register("RoleSelectionButton", roleSelectionButton, "DButton")

--//

local infoIcon = {}
infoIcon.lineOne = ""
infoIcon.lineTwo = ""
infoIcon.font = "DermaDefault"
infoIcon.imgSize = 64
infoIcon.img = Material("failicon")

function infoIcon:SetFont(font)
    self.font = font
end

function infoIcon:SetText(line1, line2)
    self.lineOne = line1
    self.lineTwo = line2
end

function infoIcon:SetColor(color)
    self.lineTwoColor = color
end

function infoIcon:SetImg(img, size)
    self.img = img
    self.imgSize = size or self.imgSize or self:GetTall()
end

function infoIcon:Paint()
    local w, h = self:GetSize()

    surface.SetDrawColor(255, 255, 255)
    surface.SetMaterial(self.img)
    surface.DrawTexturedRect(0, 0, self.imgSize, self.imgSize)

    draw.SimpleText(self.lineOne, self.font, self.imgSize + 6, self:GetTall() / 3, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    draw.SimpleText(self.lineTwo, self.font, self.imgSize + 6, self:GetTall() / 3 * 2, self.lineTwoColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
end

vgui.Register("InfoIcon", infoIcon, "DPanel")

--//

surface.CreateFont("MW2FontInfoPanel", {
	font = "BF4 Numbers",
	size = 20,
	weight = 500,
	antialias = true
})

local infoPanel = {}
infoPanel.text = ""
infoPanel.titletext = ""
infoPanel.font = "DermaDefault"
infoPanel.titlefont = "DermaLarge"
infoPanel.color = {}

function infoPanel:SetText(text, titletext)
    self.text = text
    self.titletext = titletext
    self.parsedtext = markup.Parse("<font=MW2FontInfoPanel>" .. self.text .. "</font>", self:GetWide())
end

function infoPanel:SetFont(font, titlefont)
    self.font = font
    self.titlefont = titlefont
end

function infoPanel:SetColor(color)
    self.color = color
end

function infoPanel:SetParent(parentPanel)
    self.parentPanel = parentPanel
end

function infoPanel:Paint()
    surface.SetDrawColor(self.color.menuTeamColorDarkAccent.r, self.color.menuTeamColorDarkAccent.g, self.color.menuTeamColorDarkAccent.b)
    surface.DrawRect(0, 0, self:GetSize())
    surface.SetDrawColor(self.color.menuTeamColorAccent.r, self.color.menuTeamColorAccent.g, self.color.menuTeamColorAccent.b)
    surface.DrawOutlinedRect(0, 0, self:GetSize())
    surface.SetDrawColor(self.color.menuTeamColor.r, self.color.menuTeamColor.g, self.color.menuTeamColor.b)
    surface.DrawLine(6, 6 + draw.GetFontHeight(self.titlefont), self:GetWide() - 6, 6 + draw.GetFontHeight(self.titlefont))

    draw.SimpleText(self.titletext, self.titlefont, 6, 6, Color(self.color.menuTeamColor.r, self.color.menuTeamColor.g, self.color.menuTeamColor.b), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
    self.parsedtext:Draw(6, 12 + draw.GetFontHeight(self.titlefont), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
    return true
end

function infoPanel:Think()
    if not self.parentPanel or not self.parentPanel:Valid() then
        self:Remove()
    else
        local w, h = self.parentPanel:GetPos()
        self:SetPos(w + self.parentPanel:GetWide() + 6, h)
    end
end

function string.Wrap(str,font,linewide)
	surface.SetFont(font)
	local txt = ""
	for line in string.gmatch(str.."\n","([^\n]*)\n")do
		local w = 0
		for word in string.gmatch(line.." ","([^ ]*) ")do
			local wordwide,_ = surface.GetTextSize(word.." ")
			w = w + wordwide
			if w > linewide then
				txt = txt .. "\n"
				w = wordwide
			end
			txt = txt .. word .. " "
		end
		txt = txt:sub(1,txt:len()-1) .. "\n"
	end
	txt = txt:sub(1,txt:len()-1)
	return txt
end

vgui.Register("InfoPanel", infoPanel, "DFrame")

--//

surface.CreateFont("WeaponPanelTitle", {
	font = "BankGothic",
	size = 22,
	weight = 500,
	antialias = true
})

surface.CreateFont("WeaponPanelInfoFont", {
	font = "BankGothic",
	size = 16,
	weight = 500,
	antialias = true
})

--//This class gets quite messy.

local weaponPanel = {}
weaponPanel.wepClass = "cw_kk_ins2_ak74" -- default in case SetWep fails to call
weaponPanel.font = "DermaDefault"
weaponPanel.masterTable = weapons.GetStored(weaponPanel.wepClass)
weaponPanel.attachmentButtonSize = 64
weaponPanel.weaponModelWide = 200
weaponPanel.worseColor = {238, 210, 2}
weaponPanel.betterColor = {0, 160, 0}
--weaponPanel.textTable = {} --needs to be instantiated for draw to not freak out if it starts getting called before Finish() gets called
weaponPanel.attachmentOrder = {
    ["Sight"] = 1, 
    ["Barrel"] = 2, 
    ["Under"] = 3, 
    ["Lasers"] = 4, 
    ["More Sight"] = 5, 
    ["Magazine"] = 6, 
    ["Reload Aid"] = 7, 
    ["Variant"] = 8, 
    ["Ammo"] = 9, 
    ["Flavor"] = 10, 
    ["Package"] = 11, 
    ["Stock"] = 12, 
    ["Sight Contract"] = 13
}
weaponPanel.defaultAttachmentIcons = {
    ["Sight"] = CustomizableWeaponry.registeredAttachmentsSKey.kk_ins2_kobra.displayIcon,
    ["Barrel"] = CustomizableWeaponry.registeredAttachmentsSKey.kk_ins2_suppressor_ins.displayIcon,
    ["Under"] = CustomizableWeaponry.registeredAttachmentsSKey.kk_ins2_vertgrip.displayIcon,
    ["Lasers"] = CustomizableWeaponry.registeredAttachmentsSKey.kk_ins2_anpeq15.displayIcon,
    ["More Sight"] = CustomizableWeaponry.registeredAttachmentsSKey.kk_ins2_magnifier.displayIcon,
    ["Magazine"] = CustomizableWeaponry.registeredAttachmentsSKey.kk_ins2_mag_fal_30.displayIcon,
    ["Reload Aid"] = CustomizableWeaponry.registeredAttachmentsSKey.kk_ins2_revolver_mag.displayIcon,
    ["Variant"] = CustomizableWeaponry.registeredAttachmentsSKey.kk_ins2_galil_sar.displayIcon, --Fairly certain this is a galil-only thing
    ["Ammo"] = CustomizableWeaponry.registeredAttachmentsSKey.am_magnum.displayIcon,
    ["Flavor"] = CustomizableWeaponry.registeredAttachmentsSKey.kk_ins2_fnfal_skin.displayIcon,
    ["Package"] = CustomizableWeaponry.registeredAttachmentsSKey.kk_ins2_rpk_sopmod.displayIcon,
    ["Stock"] = CustomizableWeaponry.registeredAttachmentsSKey.bg_vss_foldable_stock.displayIcon,
    ["Sight Contract"] = CustomizableWeaponry.registeredAttachmentsSKey.kk_ins2_sights_cstm.displayIcon
}
weaponPanel.attachmentPositionOffset = {
    [""] = Vector(0, 0, 0),
    [""] = Vector(0, 0, 0),
    [""] = Vector(0, 0, 0),
    [""] = Vector(0, 0, 0),
    [""] = Vector(0, 0, 0),
    [""] = Vector(0, 0, 0),
    [""] = Vector(0, 0, 0),
    [""] = Vector(0, 0, 0),
    [""] = Vector(0, 0, 0),
    [""] = Vector(0, 0, 0),
    [""] = Vector(0, 0, 0)
}
weaponPanel.attachmentAngleOffset = {
    [""] = Vector(0, 0, 0),
    [""] = Vector(0, 0, 0),
    [""] = Vector(0, 0, 0),
    [""] = Vector(0, 0, 0),
    [""] = Vector(0, 0, 0),
    [""] = Vector(0, 0, 0),
    [""] = Vector(0, 0, 0),
    [""] = Vector(0, 0, 0),
    [""] = Vector(0, 0, 0),
    [""] = Vector(0, 0, 0),
    [""] = Vector(0, 0, 0)
}
weaponPanel.sniperTable = {["cw_kk_ins2_mosin"] = true, ["cw_kk_ins2_m40a1"] = true}
weaponPanel.primaryWeaponInfo = { --Format: {variable name in the weapon's file, Display name, Color to display int value, Int value, Lower int value is better boolean}
    {"Damage", "Damage: ", {255, 255, 255}, 0},
    {"FireDelay", "Fire rate: ", {255, 255, 255}, 0, true},
    {"Recoil", "Recoil: ", {255, 255, 255}, 0, true},
    {"AimSpread", "Accuracy: ", {255, 255, 255}, 0, true},
    {"SpeedDec", "Weight: ", {255, 255, 255}, 0, true},
    {"ClipSize", "Clip Size: ", {255, 255, 255}, 0}, --This is under a sub-table, will have to manually check
    {"base_reload", "Reload Speed: ", {255, 255, 255}, 0, true}, --Also under a sub-table
    {"SpreadPerShot", "Spread Per Shot: ", {255, 255, 255}, 0, true},
    {"MaxSpreadInc", "Maximum Spread: ", {255, 255, 255}, 0, true}
}
weaponPanel.primaryWeaponInfoShotgun = {
    {"Damage", "Pellet Damage: ", {255, 255, 255}, 0},
    {"Shots", "Pellets: ", {255, 255, 255}, 0},
    {0, "Max damage: ", {255, 255, 255}, 0},
    {"FireDelay", "Fire rate: ", {255, 255, 255}, 0, true},
    {"Recoil", "Recoil: ", {255, 255, 255}, 0, true},
    {"ClumpSpread", "Pellet Spread: ", {255, 255, 255}, 0, true},
    {"SpeedDec", "Weight: ", {255, 255, 255}, 0, true},
    {"ClipSize", "Clip Size: ", {255, 255, 255}, 0}, --This is under a sub-table, will have to manually check
    {"base_reload_start", "Per-Shell Reload: ", {255, 255, 255}, 0, true}, --Also under a sub-table
    {"base_reload_start_empty", "Empty Reload: ", {255, 255, 255}, 0, true}, --STill under a sub-table
    {"SpreadPerShot", "Spread Per Shot: ", {255, 255, 255}, 0, true},
    {"MaxSpreadInc", "Maximum Spread: ", {255, 255, 255}, 0, true}
}
weaponPanel.secondaryWeaponInfo = {
    {"Damage", "Damage: ", {255, 255, 255}, 0},
    {"FireDelay", "Fire rate: ", {255, 255, 255}, 0, true},
    {"Recoil", "Recoil: ", {255, 255, 255}, 0, true},
    {"SpeedDec", "Weight: ", {255, 255, 255}, 0, true},
    {"ClipSize", "Clip Size: ", {255, 255, 255}, 0}, --This is under a sub-table, will have to manually check
    {"base_reload", "Reload Speed: ", {255, 255, 255}, 0, true}
}
weaponPanel.equipmentWeaponInfo = { --No equipment have attachments that affect important gameplay stats
    cw_kk_ins2_nade_anm14 = {
        {"BurnDuration", "Burn Duration: ", {255, 255, 255}, 0},
        {"ExplodeRadius", "Explosion Radius: ", {255, 255, 255}, 0},
        {"ExplodeDamage", "Impact damage: ", {255, 255, 255}, 0}
    },
    cw_kk_ins2_nade_c4 = {
        {"BlastRadius", "Explosion Radius: ", {255, 255, 255}, 0},
        {"BlastDamage", "Explosion Damage: ", {255, 255, 255}, 0}
    },
    cw_kk_ins2_nade_f1 = {
        {"ExplodeDamage", "Explosion damage: ", {255, 255, 255}, 0},
        {"ExplodeRadius", "Explosion radius: ", {255, 255, 255}, 0},
        --{"", "Fuze time: ", {255, 255, 255}, 0} --To create
    },
    cw_kk_ins2_nade_m18 = {
        {"ExplodeRadius", "Smoke radius: ", {255, 255, 255}, 0},
        --{"", "Smoke duration: ", {255, 255, 255}, 0} --To create
    },
    cw_kk_ins2_nade_m84 = {
        {"FlashDuration", "Flash duration: ", {255, 255, 255}, 0},
        {"FlashDistance", "Max Distance: ", {255, 255, 255}, 0}, --will decay over this much distance
        {"MaxIntensityDistance", "Full Effect Distance: ", {255, 255, 255}, 0}, --if an entity is THIS close to the grenade upon explosion, the intensity of the flashbang will be maximum
        --{"", "Fuze time: ", {255, 255, 255}, 0} --To create
    },
    cw_kk_ins2_rpg = { --the 5th, boolean, value is used for determining if the value is retrieved from the weapon (launcher) itself
        {"BlastDamage", "Explosion Damage: ", {255, 255, 255}, 0},
        {"BlastRadius", "Explosion Radius: ", {255, 255, 255}, 0},
        {"base_ready", "reload length: ", {255, 255, 255}, 0, true}, --launcher's
        {"SpeedDec", "weight: ", {255, 255, 255}, 0, true} --launcher's
    },
    cw_kk_ins2_p2a1 = {
        {"TimeToLive", "Flare duration: ", {255, 255, 255}, 0},
        {"BurnRadius", "Light Radius: ", {255, 255, 255}, 0}
    }
}
weaponPanel.equipmentWeaponInfo["cw_kk_ins2_nade_hl2"] = table.Copy(weaponPanel.equipmentWeaponInfo["cw_kk_ins2_nade_f1"])
weaponPanel.equipmentWeaponInfo["cw_kk_ins2_nade_ied"] = table.Copy(weaponPanel.equipmentWeaponInfo["cw_kk_ins2_nade_c4"])
weaponPanel.equipmentWeaponInfo["cw_kk_ins2_nade_m67"] = table.Copy(weaponPanel.equipmentWeaponInfo["cw_kk_ins2_nade_f1"])
weaponPanel.equipmentWeaponInfo["cw_kk_ins2_nade_molotov"] = table.Copy(weaponPanel.equipmentWeaponInfo["cw_kk_ins2_nade_anm14"])
weaponPanel.equipmentWeaponInfo["cw_kk_ins2_at4"] = table.Copy(weaponPanel.equipmentWeaponInfo["cw_kk_ins2_rpg"])

function weaponPanel:Init()
    self.textTable = {}
end

function weaponPanel:SetFont(font)
    self.font = font
end

function weaponPanel:SetModelWide(wide)
    self.weaponModelWide = wide
end

function weaponPanel:SetAttachmentWide(wide)
    self.attachmentButtonSize = wide
end

function weaponPanel:SetWep(wep)

    self.wepClass = wep
    self.masterTable = weapons.GetStored(self.wepClass)
    for k, v in pairs(GAMEMODE.menuWeaponInfo) do
        if v[self.wepClass] and v[self.wepClass][1] then
            self.wepName = v[self.wepClass][1]
        end
    end
    self.wepName = self.wepName or self.masterTable.PrintName
    self.attachments = table.Copy(self.masterTable.Attachments)

    local toDelete = {}
    for k, v in pairs(self.attachments) do if v.header == "CSGO" or #self.attachments == 0 then toDelete[k] = true end end--purge unwanted attachment types here
    for k, v in pairs(toDelete) do table.remove(self.attachments, k) end

    --//This assigns a number (other than 0) to the variables we end up displaying
    if GAMEMODE.menuWeaponInfo.secondaries[self.wepClass] then --if weapon is a sidearm (pistol)
        self.wepType = "secondaries"
        self.weaponDisplayInfo = self.secondaryWeaponInfo

        for k, v in pairs(self.weaponDisplayInfo) do
            if v[1] == "ClipSize" then
                v[4] = self.masterTable.Primary[v[1]]
            elseif v[1] == "base_reload" then
                if self.wepClass == "cw_kk_ins2_revolver" then
                    v[4] = self.masterTable.ReloadTimes.base_reload_start[1]
                else
                    v[4] = self.masterTable.ReloadTimes[v[1]][1]
                end
            else
                v[4] = self.masterTable[v[1]]
            end
        end
    elseif GAMEMODE.menuWeaponInfo.equipment[self.wepClass] then --if weapon is equipment (grenades or explosive)
        self.wepType = "equipment"
        self.weaponDisplayInfo = self.equipmentWeaponInfo[self.wepClass]

        net.Start("RequestEntData")
            net.WriteString(self.wepClass)
            net.WriteTable(self.weaponDisplayInfo)
        net.SendToServer()

        net.Receive("RequestEntDataCallback", function()
            --print("DEBUG:----------- RequestEntDataCallback")
            local projectileEnt = net.ReadTable()
            --print("projectileEnt = ", projectileEnt)
            for k, v in pairs(self.weaponDisplayInfo) do
                --print(k, v, v[1], v[2])
                if v[5] then
                    v[4] = self.masterTable[v[1]]
                else
                    v[4] = projectileEnt[v[1]]
                    --print("else DEBUG: ", v[4])
                end
                if self.wepInfoToAdd[k] then
                    self.wepInfoToAdd[k]:InsertColorChange(v[3][1], v[3][2], v[3][3], 255)
                    self.wepInfoToAdd[k]:AppendText(v[4])
                end
            end
        end)
    else --If the weapon isn't a listed secondary or equipment, we'll assume it's a primary
        self.wepType = "primaries"
        if self.masterTable.Shots > 1 then --Check if the primary is a shotgun
            self.weaponDisplayInfo = self.primaryWeaponInfoShotgun

            for k, v in pairs(self.weaponDisplayInfo) do
                if isnumber(v[1]) then
                    v[4] = self.masterTable.Shots * self.masterTable.Damage
                elseif v[1] == "ClipSize" then
                    v[4] = self.masterTable.Primary[v[1]]
                elseif v[1] == "base_reload_start" or v[1] == "base_reload_start_empty" then
                    v[4] = self.masterTable.ReloadTimes[v[1]][1]
                else
                    v[4] = self.masterTable[v[1]]
                end
            end
        else
            self.weaponDisplayInfo = self.primaryWeaponInfo

            print(self.sniperTable, self.wepClass, self.sniperTable[self.wepClass])
            if self.sniperTable[self.wepClass] then
                for k, v in pairs(self.weaponDisplayInfo) do
                    if v[1] == "ClipSize" then
                        v[4] = self.masterTable.Primary[v[1]]
                    elseif v[1] == "base_reload" then
                        v[4] = self.masterTable.ReloadTimes.reload_start[1] + self.masterTable.ReloadTimes.reload_insert[1] + self.masterTable.ReloadTimes.reload_end[1]
                    else
                        v[4] = self.masterTable[v[1]]
                    end
                end
            else
                for k, v in pairs(self.weaponDisplayInfo) do
                    if v[1] == "ClipSize" then
                        v[4] = self.masterTable.Primary[v[1]]
                    elseif v[1] == "base_reload" then
                        v[4] = self.masterTable.ReloadTimes[v[1]][1]
                    else
                        v[4] = self.masterTable[v[1]]
                    end
                end
            end
        end
    end
end

function weaponPanel:SetAttach(attachmentsToEquip, reset) --argument var = {attachmentname, attachmentname, attachmentname}, reset = boolean
    
    self.myAttachmentInfo = self.myAttachmentInfo or {} --we'll be using this when we draw the attachment's icon(s) in our panel

    if not attachmentsToEquip then return end

    for num, attach in pairs(attachmentsToEquip) do --for each of the attachments we're going to add to the display information, do the following
        if CustomizableWeaponry.registeredAttachmentsSKey[attach] then --first, check if it's an actual attachment
            --we need to identify what type of attachment the attachment is
            local attachmentType, toRevert
            for k, v in pairs(self.attachments) do --for each of the attachment slots available on the weapon, do the following:
                if v.atts then 
                    for k2, v2 in ipairs(v.atts) do --identify what type the attachment is - ipairs because we have a string key and don't want it ran
                        if v2 == attach then
                            attachmentType = v.header --save the attachment type in a local variable for validation
                        end
                    end
                end
            end
            --if the attachment isn't available for attaching, there's no type, discontinue function and notify user
            if not attachmentType then ErrorNoHalt("WeaponPanel ERROR - invalid attachment of attachment: ", attach, " attempted on weapon: ", self.wepClass, "\n") return end

            --since the attachment can be attached to the gun, we need to save the attachment in a table for drawing and parameter using for later
            if self.myAttachmentInfo[attachmentType] then --If we have already equipped an attachment in this slot
                toRevert = true --Set a local variable to revert the previous attachment's value changes
            end
            self.myAttachmentInfo[attachmentType] = attach --Attachment location based on attachment type order

            --Now, we need to change text colors, if the attachment has stat modifying colors
            if CustomizableWeaponry.registeredAttachmentsSKey[attach].statModifiers and table.Count(CustomizableWeaponry.registeredAttachmentsSKey[attach].statModifiers) > 0 then --if the attachment modifies stats, then
                for k, v in pairs(CustomizableWeaponry.registeredAttachmentsSKey[attach].statModifiers) do --for each modification it makes
                    for k2, v2 in pairs(self.weaponDisplayInfo) do --for each variable that will be shown to the player
                        if string.StartWith(k, v2[1]) then --if the variable and variable that will be modified by the modification are the same
                            if v2[5] then --if the value is better the lower it is
                                if v < 0 then --if the modifying value lowers our main value
                                    v2[3] = self.betterColor --make it draw green
                                else --if the modifiying value increases our main value
                                    v2[3] = self.worseColor --make it draw red
                                end
                            else --otherwise, do the opposite
                                if v < 0 then
                                    v2[3] = self.worseColor
                                else
                                    v2[3] = self.betterColor
                                end
                            end
                            if toRevert then
                                v2[4] = v[6] --only runs if v[6] has already been set due to a previous attachment being added
                            else
                                v2[6] = v2[4] --save an old version of value in case we revert
                            end
                            v2[4] = v2[4] + v --actually edit the value
                        end
                    end
                end
            end
        end
    end
end

function weaponPanel:Paint()
    surface.SetDrawColor(GAMEMODE.myTeam.menuTeamColor.r, GAMEMODE.myTeam.menuTeamColor.g, GAMEMODE.myTeam.menuTeamColor.b)
    draw.RoundedBox(8, 0, 0, self:GetWide(), self:GetTall(), Color(GAMEMODE.myTeam.menuTeamColorDarkAccent.r, GAMEMODE.myTeam.menuTeamColorDarkAccent.g, GAMEMODE.myTeam.menuTeamColorDarkAccent.b))
    draw.SimpleText(self.wepName, "WeaponPanelTitle", self.weaponModelWide / 2, 2, Color(GAMEMODE.myTeam.menuTeamColor.r, GAMEMODE.myTeam.menuTeamColor.g, GAMEMODE.myTeam.menuTeamColor.b), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
    return true
end

function weaponPanel:Finish() --I can't think of a function to otherwise put this in and I don't care to test for another one

    net.Start("RequestAvailableAttachments")
        net.WriteString(self.wepClass)
        net.WriteString(self.wepType)
    net.SendToServer()

    self.myAttachmentInfo = self.myAttachmentInfo or {} --also called here in case the weapon panel wasn't created with attachments

    self.availableTextSpace = self:GetWide() - self.weaponModelWide + 2
    if #self.weaponDisplayInfo < 4 then
        self.infoTextWide = self.availableTextSpace + 20
        self.infoTextXOffset = self.availableTextSpace / 2
    elseif #self.weaponDisplayInfo < 7 then
        self.infoTextWide = self.availableTextSpace / 2 + 20
        self.infoTextXOffset = self.availableTextSpace / 3
    elseif #self.weaponDisplayInfo < 10 then
        self.infoTextWide = self.availableTextSpace / 3 + 20
        self.infoTextXOffset = self.availableTextSpace / 4
    else
        self.infoTextWide = self.availableTextSpace / 4 + 20
        self.infoTextXOffset = self.availableTextSpace / 5
    end

    for k, v in pairs(self.weaponDisplayInfo) do
        print("\nself.weaponDisplayInfo DEBUG - ", k, v, "\n")
        v[4] = math.Round(v[4], 3)
        self.wepInfoToAdd = {}

        local richTextPanel = vgui.Create("RichText", self)
        richTextPanel:SetSize(self.infoTextWide, (self:GetTall() - self.attachmentButtonSize) / 3)
        if k < 4 then
            richTextPanel:SetPos(self.weaponModelWide, richTextPanel:GetTall() * (k - 1))
        elseif k < 7 then
            richTextPanel:SetPos(self.weaponModelWide + self.infoTextXOffset, richTextPanel:GetTall() * (k - 4))
        elseif k < 10 then
            richTextPanel:SetPos(self.weaponModelWide + self.infoTextXOffset * 2, richTextPanel:GetTall() * (k - 7))
        else
            richTextPanel:SetPos(self.weaponModelWide + self.infoTextXOffset * 3, richTextPanel:GetTall() * (k - 10))
        end
        function richTextPanel:PerformLayout() --Has to be done through this function, because it doesn't work outside of it
            self:SetFontInternal( "MW2FontSmall" )
        end
        richTextPanel:InsertColorChange(150, 150, 150, 255)
        richTextPanel:AppendText(v[2])
        if not GAMEMODE.menuWeaponInfo.equipment[self.wepClass] then
            richTextPanel:InsertColorChange(v[3][1], v[3][2], v[3][3], 255)
            richTextPanel:AppendText(v[4])
        else
            self.wepInfoToAdd[k] = richTextPanel
        end
        richTextPanel:SetVerticalScrollbarEnabled(false)
    end

    self.attachmentButtonSpacer = (self:GetWide() - self.weaponModelWide - (self.attachmentButtonSize * table.Count(self.attachments))) / (table.Count(self.attachments) + 1)
    local outerCount = 1
    net.Receive("RequestAvailableAttachmentsCallback" .. self.wepType, function()
        local availableAttachments = net.ReadTable() or {}

        for k, v in pairs(self.attachments) do

            availableAttachments[k] = availableAttachments[k] or {}

            local but = vgui.Create("DButton", self)

            if self.myAttachmentInfo[v.header] then
                but.textureToDraw = CustomizableWeaponry.registeredAttachmentsSKey[self.myAttachmentInfo[v.header]].displayIcon
            else
                but.textureToDraw = self.defaultAttachmentIcons[v.header]
            end

            but:SetSize(self.attachmentButtonSize, self.attachmentButtonSize)
            but:SetPos(self.weaponModelWide + self.attachmentButtonSpacer * outerCount + (self.attachmentButtonSize * (outerCount - 1)), self:GetTall() - self.attachmentButtonSize - 6)
            but:SetText("")
            but.DoClick = function()
                surface.PlaySound("buttons/lightswitch2.wav")
                if but.isOpen then
                    but.isOpen = false
                else
                    but.isOpen = true
                    local outerCount2 = 1
                    local x, y = but:LocalToScreen(0, 0)
                    local maxHeight = math.Clamp(#availableAttachments[k] + 1, 1, 4)

                    local moreAttachments = vgui.Create("DFrame")
                    moreAttachments:SetSize(but:GetWide(), but:GetTall() * maxHeight)
                    moreAttachments:SetPos(x, y - moreAttachments:GetTall())
                    moreAttachments:SetTitle("")
                    moreAttachments:SetVisible(true)
                    moreAttachments:SetDraggable(false)
                    moreAttachments:ShowCloseButton(false)
                    moreAttachments:MakePopup()
                    moreAttachments:SetDrawOnTop(true) --Prevents the panel from disappearing behind main if you click anywhere but this frame
                    moreAttachments.Paint = function()
                        surface.SetDrawColor(100, 100, 100, 100)
                        surface.DrawRect(0, 0, moreAttachments:GetSize())
                    end
                    
                    moreAttachments.Think = function()
                        if not but.isOpen or not but:IsValid() then
                            moreAttachments:Close() --Close only works on DFrames, I've found out
                        end
                    end

                    local moreAttachmentsList = vgui.Create("DScrollPanel", moreAttachments)
                    moreAttachmentsList:SetSize(moreAttachments:GetSize())
                    moreAttachmentsList:SetPos(0, 0)

                    for k2, v2 in pairs(availableAttachments[k]) do
                        if v2 != self.myAttachmentInfo[v.header] then --If the attachment's currently selected, no point in adding it to the available options
                            local moreAttachments = vgui.Create("AttachmentButton", moreAttachmentsList)
                            moreAttachments:SetSize(but:GetSize())
                            moreAttachments:SetInfo(but, v2, k, self.wepType)
                            moreAttachments:Dock(TOP)

                            outerCount2 = outerCount2 + 1
                        end
                    end
                    
                    local noAttachment = vgui.Create("AttachmentButton", moreAttachmentsList)
                    noAttachment:SetSize(but:GetSize())
                    noAttachment:SetInfo(but, nil, k, self.wepType)
                    noAttachment:Dock(TOP)
                    noAttachment.Paint = function()
                        draw.SimpleText("Remove", "MW2FontSmall", noAttachment:GetWide() / 2, noAttachment:GetTall() / 2, Color(GAMEMODE.myTeam.menuTeamColorAccent.r, GAMEMODE.myTeam.menuTeamColorAccent.g, GAMEMODE.myTeam.menuTeamColorAccent.b), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                        return true
                    end
                    --noAttachment.DoClick = function() end
                end
            end
            but.Paint = function()
                if self.myAttachmentInfo[v.header] then --if there is an attachment set to be equipped
                    surface.SetDrawColor(255, 255, 255)
                    surface.SetTexture(but.textureToDraw)
                    surface.DrawTexturedRect(1, 1, self.attachmentButtonSize - 1, self.attachmentButtonSize - 1)
                    --surface.SetDrawColor(175, 175, 175)
                    --surface.DrawOutlinedRect(0, 0, self.attachmentButtonSize, self.attachmentButtonSize)
                    if but.hover then
                        surface.SetDrawColor(GAMEMODE.myTeam.menuTeamColorLightAccent.r, GAMEMODE.myTeam.menuTeamColorLightAccent.g, GAMEMODE.myTeam.menuTeamColorLightAccent.b)
                        surface.DrawOutlinedRect(0, 0, self.attachmentButtonSize, self.attachmentButtonSize)
                    end
                else --if we're drawing the default icon
                    surface.SetDrawColor(255, 255, 255)
                    surface.SetTexture(but.textureToDraw)
                    surface.DrawTexturedRect(1, 1, self.attachmentButtonSize - 1, self.attachmentButtonSize - 1)
                    if but.hover then
                        surface.SetDrawColor(GAMEMODE.myTeam.menuTeamColorLightAccent.r, GAMEMODE.myTeam.menuTeamColorLightAccent.g, GAMEMODE.myTeam.menuTeamColorLightAccent.b)
                        surface.DrawOutlinedRect(0, 0, self.attachmentButtonSize, self.attachmentButtonSize)
                    end
                    if not but.hover then
                        --surface.SetDrawColor(175, 175, 175)
                        --surface.DrawOutlinedRect(0, 0, self.attachmentButtonSize, self.attachmentButtonSize)
                        surface.SetDrawColor(GAMEMODE.myTeam.menuTeamColorLightAccent.r, GAMEMODE.myTeam.menuTeamColorLightAccent.g, GAMEMODE.myTeam.menuTeamColorLightAccent.b, 5)
                        surface.DrawRect(0, 0, self.attachmentButtonSize, self.attachmentButtonSize)
                    end
                end
                return true
            end
            but.OnCursorEntered = function()
                surface.PlaySound("garrysmod/ui_hover.wav")
                but.hover = true
            end
            but.OnCursorExited = function()
                but.hover = false
            end

            outerCount = outerCount + 1
        end
    end)

    local weaponModelPanel = vgui.Create("DModelPanel", self)
    weaponModelPanel:SetSize(self.weaponModelWide, self:GetTall() - 26)
    weaponModelPanel:SetPos(0, self:GetTall() - weaponModelPanel:GetTall())
    weaponModelPanel:SetModel(weapons.GetStored(self.wepClass).WorldModel)
    weaponModelPanel:SetCamPos(Vector(0, 35, 0)) --Courtesy of Spy
    weaponModelPanel:SetLookAt(Vector(0, 0, 0)) --Courtesy of Spy
    weaponModelPanel:SetFOV(90) --Courtesy of Spy
    --weaponModelPanel:GetEntity():SetAngles
    weaponModelPanel:GetEntity():SetPos(Vector(-6, 13.5, -1))
    weaponModelPanel:SetAmbientLight(Color(255, 255, 255))
    weaponModelPanel.LayoutEntity = function() return true end --Disables rotation

    local panel = vgui.Create("DPanel", self)
    panel:SetSize(self.weaponModelWide, self:GetTall() - 26)
    panel:SetPos(0, self:GetTall() - panel:GetTall())
    panel.Paint = function()
        surface.SetDrawColor(255, 255, 255)
        --surface.DrawOutlinedRect(0, 0, panel:GetSize())
    end
end

vgui.Register("WeaponMenuPanel", weaponPanel, "DPanel")

--//

local attachmentButton = {}

function attachmentButton:SetInfo(basePanel, attachment, attachmentType, baseWepType)
    self.basePanel = basePanel
    self.attachment = attachment
    self.attachmentType = attachmentType
    self.wepType = baseWepType

    --print(self.attachment)
    if self.attachment then
        self.img = CustomizableWeaponry.registeredAttachmentsSKey[self.attachment].displayIcon
    else
        self.img = Material("a") --missing texture
    end
end

function attachmentButton:DoClick()
    surface.PlaySound("buttons/lightswitch2.wav")
    if self.wepType == "primaries" then
        GAMEMODE.PRIMARY_WEAPON_ATTACHMENTS[self.attachmentType] = self.attachment
    elseif self.wepType == "Secondaries" then
        GAMEMODE.SECONDARY_WEAPON_ATTACHMENTS[self.attachmentType] = self.attachment
    elseif self.wepType == "equipment" then
        GAMEMODE.EQUIPMENT_WEAPON_ATTACHMENTS[self.attachmentType] = self.attachment
    end
    self.basePanel.isOpen = false
    GAMEMODE:RefreshWeapons()
end

function attachmentButton:OnCursorEntered()
    surface.PlaySound("garrysmod/ui_hover.wav")
    self.hover = true
end

function attachmentButton:OnCursorExited()
    self.hover = false
end

function attachmentButton:Paint()
    surface.SetDrawColor(GAMEMODE.myTeam.menuTeamColor.r, GAMEMODE.myTeam.menuTeamColor.g, GAMEMODE.myTeam.menuTeamColor.b)
    surface.DrawRect(0, 0, self:GetSize())
    surface.SetDrawColor(255, 255, 255)
    surface.DrawOutlinedRect(0, 0, self:GetSize())

    if self.attachment then
        surface.SetTexture(self.img)
    else
        surface.SetMaterial(self.img)
    end
    surface.DrawTexturedRect(0, 0, self:GetSize())
    if self.hover then
        surface.SetDrawColor(GAMEMODE.myTeam.menuTeamColorLightAccent.r, GAMEMODE.myTeam.menuTeamColorLightAccent.g, GAMEMODE.myTeam.menuTeamColorLightAccent.b)
        --surface.DrawOutlinedRect(0, 0, self:GetSize())
    end
    return true
end

--[[function attachmentButton:Think()
    self:MoveToFront()
    if self.basePanel and self.basePanel:IsValid() and self.basePanel.isOpen then return end
    self:Remove()
end]]

vgui.Register("AttachmentButton", attachmentButton, "DButton")

--//

local weaponPanelList = {}
weaponPanelList.class = "cw_kk_ins2_ak74"
weaponPanelList.font = "DermaDefault"
weaponPanelList.type = "Assault Rifles"

function weaponPanelList:Init()
    self.name = weapons.GetStored(self.class)[PrintName]
    self.typeIcon = GAMEMODE.weaponToIcon[self.type]
end

function weaponPanelList:SetWep(wep)
    self.class = wep
    for k, v in pairs(GAMEMODE.menuWeaponInfo) do
        for k2, v2 in pairs(v) do
            if k2 == self.class then
                self.name = v2[1]
                self.wepSlot = k
            end
        end
    end
end

function weaponPanelList:GetWep()
    return self.class
end

function weaponPanelList:SetType(type)
    self.type = type
    self.typeIcon = GAMEMODE.weaponToIcon[self.type] or Material("a")
end

function weaponPanelList:SetFont(font)
    self.font = font
end

function weaponPanelList:Paint()
    surface.SetDrawColor(255, 255, 255)
    surface.SetMaterial(self.typeIcon)
    surface.DrawTexturedRect(0, 0, self:GetTall(), self:GetTall())

    --surface.DrawLine(0, self:GetTall() - 1, self:GetWide(), self:GetTall() - 1)

    draw.SimpleText(self.name, self.font, self:GetTall() + 6, self:GetTall() / 2, Color(GAMEMODE.myTeam.menuTeamColorLightAccent.r, GAMEMODE.myTeam.menuTeamColorLightAccent.g, GAMEMODE.myTeam.menuTeamColorLightAccent.b), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    if self.hover then
        surface.SetFont(self.font)
        local w, h = surface.GetTextSize(self.name)
        surface.SetDrawColor(GAMEMODE.myTeam.menuTeamColor.r, GAMEMODE.myTeam.menuTeamColor.g, GAMEMODE.myTeam.menuTeamColor.b)
        surface.DrawLine(self:GetTall() + 6, self:GetTall() / 2 + h / 2, self:GetTall() +  6 + w, self:GetTall() / 2 + h / 2)
    end
    return true
end

function weaponPanelList:DoClick()
    surface.PlaySound("buttons/lightswitch2.wav")
    if self.wepSlot == "primaries" then
        GAMEMODE.PRIMARY_WEAPON = self.class
    elseif self.wepSlot == "secondaries" then
        GAMEMODE.SECONDARY_WEAPON = self.class
    elseif self.wepSlot == "equipment" then
        GAMEMODE.EQUIPMENT_WEAPON = self.class
    end
    GAMEMODE:RefreshWeapons()
end

function weaponPanelList:OnCursorEntered()
    surface.PlaySound("garrysmod/ui_hover.wav")
    self.hover = true
end

function weaponPanelList:OnCursorExited()
    self.hover = false
end

function weaponPanelList:Finish()
    local customizeButton = vgui.Create("DButton", self)
    customizeButton:SetSize(self:GetTall() * 3, self:GetTall())
    customizeButton:SetPos(self:GetWide() - customizeButton:GetWide(), 0)
    customizeButton:SetText("")
    customizeButton.DoClick = function()
        surface.PlaySound("buttons/lightswitch2.wav")
        --[[local customizePanel = vgui.Create("DFrame")
        customizePanel:SetSize()
        customizePanel:SetTitle("")
        customizePanel:SetVisible(true)
        customizePanel:SetDraggable(false)
        customizePanel:ShowCloseButton(false)
        customizePanel:MakePopup()
        customizePanel:Center()
        customizePanel:SetDrawOnTop(true)
        customizePanel.Think = function()
            if not GAMEMODE.weaponMain or not GAMEMODE.weaponMain:IsValid() then
                customizePanel:Close()
            end
        end]]
    end
    customizeButton.Paint = function()
        if customizeButton.hover then
            surface.SetDrawColor(GAMEMODE.myTeam.menuTeamColor.r, GAMEMODE.myTeam.menuTeamColor.g, GAMEMODE.myTeam.menuTeamColor.b)
		    surface.SetTexture(surface.GetTextureID("gui/center_gradient"))
            surface.DrawTexturedRect(0, 0, customizeButton:GetSize())
        end
        draw.SimpleText("Customize", self.font, customizeButton:GetWide() / 2, customizeButton:GetTall() / 2, Color(GAMEMODE.myTeam.menuTeamColorAccent.r, GAMEMODE.myTeam.menuTeamColorAccent.g, GAMEMODE.myTeam.menuTeamColorAccent.b), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
    customizeButton.OnCursorEntered = function()
        surface.PlaySound("garrysmod/ui_hover.wav")
        customizeButton.hover = true
        self.hover = false
    end
    customizeButton.OnCursorExited = function()
        customizeButton.hover = false
    end
end

vgui.Register("WeaponPanelList", weaponPanelList, "DButton")