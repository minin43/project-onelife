--//This file is strictly for creating/registering custom vgui elements
--//Never done this before so I apologize now if I make some mistakes

local roleSelectionButton = {}
roleSelectionButton.font = "DermaLarge"
roleSelectionButton.text = ""
roleSelectionButton.imgsrc = ""
roleSelectionButton.img = Material(roleSelectionButton.imgsrc)
roleSelectionButton.title = false
roleSelectionButton.locked = false
roleSelectionButton.role = 1 --Default value, always unlocked

function roleSelectionButton:SetFont(font)
    self.font = font
end

function roleSelectionButton:SetText(text)
    self.text = text
end

function roleSelectionButton:SetRole(num)
    self.role = num
end

function roleSelectionButton:IsTitle(bool)
    self.title = bool
end

function roleSelectionButton:IsLocked(bool)
    self.locked = bool
end

function roleSelectionButton:SetImage(img)
    self.imgsrc = img
    self.img = Material(self.imgsrc)
end

function roleSelectionButton:DoClick()
    if self.title or self.locked then return end
    if GAMEMODE.roleMainButtonNumber != self.role then
        GAMEMODE.roleMainButtonNumber = self.role
        surface.PlaySound("buttons/lightswitch2.wav")
    else
        net.Start("SendRoleToServer")
            net.WriteString(tostring(self.role))
        net.SendToServer()
        self:GetParent():Close()
        GAMEMODE:LoadoutMenu() --It is assumed this button will close its parent and open up the Loadout Menu
    end
end

function roleSelectionButton:OnCursorEntered()
    if self.title or self.locked then return end
    surface.PlaySound("garrysmod/ui_hover.wav")
    self.cursorEntered = true
end

function roleSelectionButton:OnCursorExited()
    self.cursorEntered = false
end

function roleSelectionButton:Paint()
    local w, h = self:GetSize()

    if self.img then --if IsValid(self.img) then
        surface.SetDrawColor(255, 255, 255)
        surface.SetMaterial(self.img)
        surface.DrawTexturedRect(1, 1, w - 2, h - 2)
    else
        surface.SetDrawColor(180, 180, 180)
        surface.DrawRect(1, 1, w - 2, h - 2)
    end

    if self.title then
        draw.SimpleTextOutlined("Select a role", self.font, w / 2, h / 2, Color(0, 0, 0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(255, 255, 255))
    else
        if self.locked then
            surface.SetDrawColor(100, 0, 0, 150)
            surface.DrawRect(1, 1, w - 2, h - 2)
            draw.SimpleTextOutlined("LOCKED", self.font, w / 2, h / 2, Color(0, 0, 0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(255, 255, 255))
        else
            draw.SimpleTextOutlined(self.text, self.font, w / 2, h / 2, Color(0, 0, 0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(255, 255, 255))
            if self.cursorEntered or GAMEMODE.roleMainButtonNumber == self.role then
                surface.SetDrawColor(255, 255, 255)
                surface.DrawOutlinedRect(0, 0, w, h)
            end
        end
    end
    return true
end

--//

vgui.Register("RoleSelectionButton", roleSelectionButton, "DButton")

local roleDescriptionButton = {}
roleDescriptionButton.text = ""
roleDescriptionButton.font = "DermaLarge"

function roleDescriptionButton:SetText(txt)
    self.text = txt
end

function roleDescriptionButton:SetRole(num)
    self.role = num
end

function roleDescriptionButton:SetFont(fnt)
    self.font = fnt
end

function roleDescriptionButton:OnCursorEntered()
    surface.PlaySound("garrysmod/ui_hover.wav")
    self.cursorEntered = true
end

function roleDescriptionButton:OnCursorExited()
    self.cursorEntered = false
end

function roleDescriptionButton:Paint()
    local w, h = self:GetSize()

    draw.SimpleText(self.text, self.font, w / 2, h / 2, Color(175, 175, 175), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    surface.SetDrawColor(175, 175, 175)
    surface.DrawLine(0, 0, w, 0)
    surface.DrawLine(0, 0, 0, h)
    surface.DrawLine(0, h - 1, w, h - 1)
    if self.cursorEntered or GAMEMODE.roleDescMenuButtonNumber == self.role then
        draw.SimpleText(self.text, self.font, w / 2, h / 2, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        surface.SetDrawColor(255, 255, 255)
        surface.DrawLine(0, 0, w, 0)
        surface.DrawLine(0, 0, 0, h)
       -- if self.role == #GAMEMODE.Roles then
            surface.DrawLine(0, h - 1, w, h - 1)
        --else
            --surface.DrawLine(0, h, w, h)
        --end
    end
    return true
end

function roleDescriptionButton:DoClick()
    surface.PlaySound("buttons/lightswitch2.wav")
    GAMEMODE.roleDescMenuButtonNumber = self.role
    GAMEMODE.roleDescMenuButtonDownX, GAMEMODE.roleDescMenuButtonDownY = self:GetPos()
    GAMEMODE.roleDescMenuButtonDownWide, GAMEMODE.roleDescMenuButtonDownTall = self:GetSize()
end

vgui.Register("RoleDescriptionButton", roleDescriptionButton, "DButton")

--//

local armorDescriptionButton = table.Copy(roleDescriptionButton)

function armorDescriptionButton:SetArmor(num)
    self.armor = num
end

function armorDescriptionButton:DoClick()
    surface.PlaySound("buttons/lightswitch2.wav")
    GAMEMODE.armorDescMenuButtonDown = self.armor
    GAMEMODE.armorDescMenuButtonDownX, GAMEMODE.armorDescMenuButtonDownY = self:GetPos()
    GAMEMODE.armorDescMenuButtonDownWide, GAMEMODE.armorDescMenuButtonDownTall = self:GetSize()
    GAMEMODE:DrawDescriptionPanel(self.armor)
end

function armorDescriptionButton:Paint()
    local w, h = self:GetSize()

    draw.SimpleText(self.text, self.font, w / 2, h / 2, Color(175, 175, 175), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    surface.SetDrawColor(175, 175, 175)
    surface.DrawLine(0, 0, w, 0)
    surface.DrawLine(0, 0, 0, h)
    surface.DrawLine(0, h, w, h)
    if self.cursorEntered or GAMEMODE.armorDescMenuButtonDown == self.armor then
        draw.SimpleText(self.text, self.font, w / 2, h / 2, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        surface.SetDrawColor(255, 255, 255)
        surface.DrawLine(0, 0, w, 0)
        surface.DrawLine(0, 0, 0, h)
        --[[surface.DrawLine(0, h - 1, w, h - 1)
        if self.armor == #GAMEMODE.Armor then
            surface.DrawLine(0, h - 1, w, h)
        else]]
            surface.DrawLine(0, h, w, h)
        --end
    end
    return true
end

vgui.Register("ArmorDescriptionButton", armorDescriptionButton, "DButton")

local armorInfoIcon = {}
armorInfoIcon.font = "DermaDefault"
armorInfoIcon.scaleType = "damageScaling"
armorInfoIcon.imgsrc = ""
armorInfoIcon.img = Material(armorInfoIcon.imgsrc)
armorInfoIcon.color = Color(255, 255, 255)
armorInfoIcon.armor = 2
armorInfoIcon.scale = 0

function armorInfoIcon:SetFont(font)
    self.font = font
end

function armorInfoIcon:SetImage(img)
    self.imgsrc = img
    self.img = Material(armorInfoIcon.imgsrc)
end

function armorInfoIcon:SetArmor(num)
    self.armor = num
end

function armorInfoIcon:SetWhatScale(text, num)
    self.scaleType = text
    self.scaleNum = num
end

function armorInfoIcon:Finish() --I can't quite think of where to put this code, so instead I'm going require this function be called after the vgui element setup is done
    if self.armor == 2 then return end

    if self.scaleType == "healthScaling" then
        if GAMEMODE.Armor[self.armor][self.scaleType] > GAMEMODE.Armor[2][self.scaleType] then
            self.color = Color(0, 160, 0)
        elseif GAMEMODE.Armor[self.armor][self.scaleType] < GAMEMODE.Armor[2][self.scaleType] then
            self.color = Color(170, 0, 0)
        end
    else
        if GAMEMODE.Armor[self.armor][self.scaleType][self.scaleNum] > GAMEMODE.Armor[2][self.scaleType][self.scaleNum] then
            self.color = Color(0, 160, 0)
        elseif GAMEMODE.Armor[self.armor][self.scaleType][self.scaleNum] < GAMEMODE.Armor[2][self.scaleType][self.scaleNum] then
            self.color = Color(170, 0, 0)
        end
    end
end

function armorInfoIcon:Paint()
    local w, h = self:GetSize()


    --if self.img then --
    if IsValid(self.img) then
        surface.SetDrawColor(255, 255, 255)
        surface.SetMaterial(self.img)
        if w > h then
            surface.DrawTexturedRect(0, 0, h, h)
            draw.SimpleText(tostring(self.scale * 100), self.font, (w + h) / 2, h / 2, self.color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        elseif w < h then
            surface.DrawTexturedRect(0, 0, w, w)
            draw.SimpleText(tosrting(self.scale * 100), self.font, w / 2, (h + w) / 2, self.color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        else
            surface.DrawTexturedRect(0, 0, w, h)
        end
    end
    return true
end

vgui.Register("ArmorInfoIcon", armorInfoIcon, "DPanel")

local weaponPanel = {}
weaponPanel.wepClass = "cw_kk_ins2_ak74" -- default in case SetWep fails to call
weaponPanel.type = "primary"
weaponPanel.font = "DermaDefault"
weaponPanel.attachmentButtonSize = 64
weaponPanel.weaponModelWide = 200
weaponPanel.isShotgun = false
weaponPanel.isEquipment = false
weaponPanel.worseColor = Color(170, 0, 0)
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

function weaponPanel:Init()
    self.attachments = { -- order is: sight, barrel, under, laser, mod, ammo, contract
        {"kk_ins2_kobra", false},
        {"kk_ins2_pbs5", false},
        {"kk_ins2_vertgrip", false},
        {"kk_ins2_anpeq15", false},
        {"kk_ins2_magnifier", false},
        {"am_magnum", false},
        {"kk_ins2_sights_cstm", false}
    }
    self.copiedWeaponTable = { --Order: SWEP table key, display string, attribute value, color (if applicable)
        {"Damage", "Damage: ", 0, Color(255, 255, 255)},
        {"FireDelay", "Fire rate: ", 0, Color(255, 255, 255)},
        {"Recoil", "Recoil: ", 0, Color(255, 255, 255)},
        {"AimSpread", "Accuracy: ", 0, Color(255, 255, 255)},
        {"SpeedDec", "Weight: ", 0, Color(255, 255, 255)},
        {"ClipSize", "Clip Size: ", 0, Color(255, 255, 255)}, --This is under a sub-table, will have to manually check
        {"base_reload", "Reload Length (seconds): ", 0, Color(255, 255, 255)}, --Also under a sub-table
        {"SpreadPerShot", "Spread Per Shot: ", 0, Color(255, 255, 255)},
        {"MaxSpreadInc", "Maximum Spread: ", 0, Color(255, 255, 255)}
    }
end

function weaponPanel:SetFont(font)
    self.font = font
end

function weaponPanel:SetType(type)
    self.type = type
end

function weaponPanel:SetWep(wep, type)
    local temptable = weapons.GetStored(wep)

    self.wepClass = wep
    self.type = type
    self.wepName = GAMEMODE.menuDisplayName[self.wepClass] or temptable.PrintName
    if self.type != "equipment" then
        if temptable.Shots > 1 then
            self.isShotgun = true
        end
        for k, v in pairs(self.copiedWeaponTable) do
            if self.isShotgun then
                if v[1] == "Damage" then
                    v[3] = temptable[v[1]] * temptable.Shots
                elseif v[1] == "Aimspread" then
                    v = {"ClumpSpread", "Pellet Spread: ", math.Round(temptable["ClumpSpread"], 3)}
                elseif v[1] == "base_reload" then
                    v[2] = "Reload Time (per shell): "
                    v[3] = temptable.ReloadTimes.base_reload_insert[1]
                elseif v[1] == "ClipSize" then
                    v[3] = temptable.Primary.ClipSize
                end
            else
                if v[1] == "ClipSize" then
                    v[3] = temptable.Primary.ClipSize
                elseif v[1] == "base_reload" then
                    v[3] = temptable.ReloadTimes.base_reload[1]
                else
                    v[3] = math.Round(temptable[v[1]], 3)
                end
            end
        end
    else
        --[[local spawnedEnt = ents.Create(temptable.projectileClass)
        
        Fire grenades:
            -Burn Duration (ExplodeRadius)
            -Explosion Radius (ExplodeDamage)
            -Impact damage (BurnDuration)
        Frag grenades:
            -Explosion damage (ExplodeDamage)
            -Explosion radius (ExplodeRadius)
            -Fuze time --To create
        Smoke grenade:
            -Smoke radius (ExplodedRadius)
            -Smoke duration --To create
        Flash grenade:
            -Flash duration (FlashDuration)
            -Max Distance (FlashDistance) --will decay over this much distance
            -Full effect Distance (MaxIntensityDistance) --if an entity is THIS close to the grenade upon explosion, the intensity of the flashbang will be maximum
            -Fuze time --To create
        Launched Explosives (AT-4, RPG-7):
            -Explosion Damage (BlastDamage)
            -Explosion Radius (BlastRadius)
            -Launcher reload length
            -Launcher weight
        Detonated Explosives:
            -Explosion Radius (BlastRadius)
            -Explosion Damage (BlastDamage)
        Flare Gun:
            -Flare duration (TimeToLive)
            -Light Radius (BurnRadius)
        ]]
    end
end

function weaponPanel:SetAttach(sight, barrel, under, laser, mod, ammo, contract)
    local temptable = table.Copy(self.copiedWeaponTable)
    if CustomizableWeaponry.registeredAttachmentsSKey[sight] then
        self.attachments[1] = {sight, true}
        if CustomizableWeaponry.registeredAttachmentsSKey[sight].statModifiers and #CustomizableWeaponry.registeredAttachmentsSKey[sight].statModifiers > 0 then
            for k, v in pairs(CustomizableWeaponry.registeredAttachmentsSKey[sight].statModifiers) do
                for k2, v2 in pairs(self.copiedWeaponTable) do
                    if string.StartWith(k, v2[1]) then
                        v2[3] = v2[3] + v
                        if v2[3] > temptable[k2][3] then
                            v2[4] = self.betterColor
                        elseif v2[3] < temptable[k2][3] then
                            v2[4] = self.worseColor
                        else
                            v2[4] = Color(255, 255, 255)
                        end
                    end
                end
            end
        end
    end
    if CustomizableWeaponry.registeredAttachmentsSKey[barrel] then
        self.attachments[2] = {barrel, true}
        if CustomizableWeaponry.registeredAttachmentsSKey[barrel].statModifiers then
            for k, v in pairs(CustomizableWeaponry.registeredAttachmentsSKey[barrel].statModifiers) do
                for k2, v2 in pairs(self.copiedWeaponTable) do
                    if string.StartWith(k, v2[1]) then
                        v2[3] = v2[3] + v
                        if v2[3] > temptable[k2][3] then
                            v2[4] = self.betterColor
                        elseif v2[3] < temptable[k2][3] then
                            v2[4] = self.worseColor
                        else
                            v2[4] = Color(255, 255, 255)
                        end
                    end
                end
            end
        end
    end
    if CustomizableWeaponry.registeredAttachmentsSKey[under] then
        self.attachments[3] = {under, true}
        if CustomizableWeaponry.registeredAttachmentsSKey[under].statModifiers then
            for k, v in pairs(CustomizableWeaponry.registeredAttachmentsSKey[under].statModifiers) do
                for k2, v2 in pairs(self.copiedWeaponTable) do
                    if string.StartWith(k, v2[1]) then
                        v2[3] = v2[3] + v
                        if v2[3] > temptable[k2][3] then
                            v2[4] = self.betterColor
                        elseif v2[3] < temptable[k2][3] then
                            v2[4] = self.worseColor
                        else
                            v2[4] = Color(255, 255, 255)
                        end
                    end
                end
            end
        end
    end
    if CustomizableWeaponry.registeredAttachmentsSKey[laser] then
        self.attachments[4] = {laser, true}
        if CustomizableWeaponry.registeredAttachmentsSKey[laser].statModifiers then
            for k, v in pairs(CustomizableWeaponry.registeredAttachmentsSKey[laser].statModifiers) do
                for k2, v2 in pairs(self.copiedWeaponTable) do
                    if string.StartWith(k, v2[1]) then
                        v2[3] = v2[3] + v
                        if v2[3] > temptable[k2][3] then
                            v2[4] = self.betterColor
                        elseif v2[3] < temptable[k2][3] then
                            v2[4] = self.worseColor
                        else
                            v2[4] = Color(255, 255, 255)
                        end
                    end
                end
            end
        end
    end
    if CustomizableWeaponry.registeredAttachmentsSKey[mod] then
        self.attachments[5] = {mod, true}
        if CustomizableWeaponry.registeredAttachmentsSKey[mod].statModifiers then
            for k, v in pairs(CustomizableWeaponry.registeredAttachmentsSKey[mod].statModifiers) do
                for k2, v2 in pairs(self.copiedWeaponTable) do
                    if string.StartWith(k, v2[1]) then
                        v2[3] = v2[3] + v
                        if v2[3] > temptable[k2][3] then
                            v2[4] = self.betterColor
                        elseif v2[3] < temptable[k2][3] then
                            v2[4] = self.worseColor
                        else
                            v2[4] = Color(255, 255, 255)
                        end
                    end
                end
            end
        end
    end
    if CustomizableWeaponry.registeredAttachmentsSKey[ammo] then
        self.attachments[6] = {ammo, true}
        if CustomizableWeaponry.registeredAttachmentsSKey[ammo].statModifiers then
            for k, v in pairs(CustomizableWeaponry.registeredAttachmentsSKey[ammo].statModifiers) do
                for k2, v2 in pairs(self.copiedWeaponTable) do
                    if string.StartWith(k, v2[1]) then
                        v2[3] = v2[3] + v
                        if v2[3] > temptable[k2][3] then
                            v2[4] = self.betterColor
                        elseif v2[3] < temptable[k2][3] then
                            v2[4] = self.worseColor
                        else
                            v2[4] = Color(255, 255, 255)
                        end
                    end
                end
            end
        end
    end
    if CustomizableWeaponry.registeredAttachmentsSKey[contract] then --This doesn't ever change any stats
        self.attachments[7] = {contract, true}
    end
end

function weaponPanel:Paint()
    draw.RoundedBoxEx(16, 0, 0, self:GetWide(), self:GetTall(), Color(255, 255, 255), true, true, true, true)
    draw.RoundedBoxEx(16, 4, 4, self:GetWide() - 8, self:GetTall() - 8, Color(0, 0, 0), true, true, true, true)
    draw.RoundedBoxEx(16, 5, 5, self:GetWide() - 10, self:GetTall() - 10, Color(100, 100, 100), true, true, true, true)
    for k, v in pairs(self.copiedWeaponTable) do
        if k < 4 then
            draw.SimpleText(v[2] .. v[3], self.font, self.weaponModelWide + 6, 15 * k, v[4], TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        elseif k < 7 then
            draw.SimpleText(v[2] .. v[3], self.font, self.weaponModelWide + (self:GetWide() - self.weaponModelWide) / 3, 15 * (k - 3), v[4], TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        elseif k < 10 then
            draw.SimpleText(v[2] .. v[3], self.font, self.weaponModelWide + (self:GetWide() - self.weaponModelWide) * (2 / 3), 15 * (k - 6), v[4], TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        end
    end
    return true
end

function weaponPanel:Finish() --I can't think of a function to otherwise put this in and I don't care to test for another one
    self.attachmentButtonSpacer = (self:GetWide() - (self.attachmentButtonSize * #self.attachments)) / (#self.attachments + 1)
    for k, v in pairs(self.attachments) do
        local but = vgui.Create("DButton", self)
        but:SetSize(self.attachmentButtonSize, self.attachmentButtonSize)
        but:SetPos(self.attachmentButtonSpacer * k + (self.attachmentButtonSize * (k - 1)), self:GetTall() - self.attachmentButtonSize - 6)
        but:SetText("")
        but.DoClick = function()
            surface.PlaySound("buttons/lightswitch2.wav")
            --Opens attachment customization menu, can quick-purchase attachments from here instead of from the shop
        end
        but.Paint = function()
            if v[2] then
                surface.SetDrawColor(255, 255, 255)
                surface.SetTexture(CustomizableWeaponry.registeredAttachmentsSKey[v[1]].displayIcon)
                surface.DrawTexturedRect(1, 1, self.attachmentButtonSize - 1, self.attachmentButtonSize - 1)
                surface.SetDrawColor(175, 175, 175)
                surface.DrawOutlinedRect(0, 0, self.attachmentButtonSize, self.attachmentButtonSize)
                if but.hover then
                    surface.SetDrawColor(255, 255, 255)
                    surface.DrawOutlinedRect(0, 0, self.attachmentButtonSize, self.attachmentButtonSize)
                end
            else
                surface.SetDrawColor(255, 255, 255)
                surface.SetTexture(CustomizableWeaponry.registeredAttachmentsSKey[v[1]].displayIcon)
                surface.DrawTexturedRect(1, 1, self.attachmentButtonSize - 1, self.attachmentButtonSize - 1)
                surface.SetDrawColor(175, 175, 175)
                surface.DrawOutlinedRect(0, 0, self.attachmentButtonSize, self.attachmentButtonSize)
                if not but.hover then
                    surface.SetDrawColor(175, 175, 175)
                    surface.DrawOutlinedRect(0, 0, self.attachmentButtonSize, self.attachmentButtonSize)
                    surface.SetDrawColor(0, 0, 0, 200)
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
    end

    local weaponModelPanel = vgui.Create("DModelPanel", self)
    weaponModelPanel:SetPos(2, 2)
    weaponModelPanel:SetSize(self.weaponModelWide, 70)
    weaponModelPanel:SetModel(weapons.GetStored(self.wepClass).WorldModel)
    weaponModelPanel:SetCamPos(Vector(0, 35, 0)) --Courtesy of Spy
    weaponModelPanel:SetLookAt(Vector(0, 0, 0)) --Courtesy of Spy
    weaponModelPanel:SetFOV(90) --Courtesy of Spy
    --weaponModelPanel:GetEntity():SetAngles
    weaponModelPanel:GetEntity():SetPos(Vector(-6, 13.5, -1))
    weaponModelPanel:SetAmbientLight(Color(255, 255, 255))
    weaponModelPanel.LayoutEntity = function() return true end --Disables rotation

    local but = vgui.Create("DButton", weaponModelPanel)
    but:SetSize(weaponModelPanel:GetWide(), weaponModelPanel:GetTall())
    but:SetPos(0, 0)
    but:SetText("")
    but.DoClick = function()
        surface.PlaySound("buttons/lightswitch2.wav")
        --Opens weapon selection menu, can quick-purchase weapons from here instead of from the shop
    end
    but.Paint = function()
        draw.SimpleTextOutlined(self.wepName, "DermaDefault", but:GetWide() / 2, but:GetTall() / 2, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))
        surface.SetDrawColor(175, 175, 175)
        surface.DrawOutlinedRect(1, 1, but:GetWide() - 1, but:GetTall() - 1)
        if but.hover then
            surface.SetDrawColor(255, 255, 255)
            surface.DrawOutlinedRect(1, 1, but:GetWide() - 1, but:GetTall() - 1)
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
end

vgui.Register("WeaponMenuPanel", weaponPanel, "DPanel")