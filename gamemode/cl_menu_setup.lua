--//This file is strictly for creating/registering custom vgui elements

local roleSelectionButton = {}
roleSelectionButton.font = "DermaLarge"
roleSelectionButton.text = ""
roleSelectionButton.imgsrc = ""
roleSelectionButton.img = Material(roleSelectionButton.imgsrc)
roleSelectionButton.title = false
roleSelectionButton.locked = false
roleSelectionButton.Role = 1 --Default value, always unlocked

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
    roleSelectionButton.locked = bool
end

function roleSelectionButton:SetImage(img)
    self.imgsrc = img
    self.img = Material(roleSelectionButton.imgsrc)
end

function roleSelectionButton:DoClick()
    if not roleSelectionButton.locked then
        GM.roleMainButtonNumber = self.role
    end
end

function roleSelectionButton:OnCursorEntered()
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
        draw.SimpleText("Select a role", self.font, w / 2, h / 2, Color(0, 0, 0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    else
        draw.SimpleText(self.text, self.font, w / 2, h / 2, Color(0, 0, 0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        local hover = self:IsHovered()
        if self.locked then
            surface.SetDrawColor(100, 0, 0, 150)
            surface.DrawRect(1, 1, w - 2, h - 2)
            draw.SimpleText("LOCKED", self.font, w / 2, h / 2, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        else
            if self.cursorEntered or GM.roleMainButtonNumber == self then
                surface.SetDrawColor(255, 255, 255)
                surface.DrawOutlinedRect(0, 0, w, h)
            end
        end
    end
end

--//

vgui.Register("RoleSelectionButton", roleSelectionButton, "DButton")

local roleDescriptionButton = {}
roleDescriptionButton.text = ""
roleDescriptionButton.font = "DermaDefault"

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
    if self.cursorEntered or GM.roleDescMenuButtonDown == self.role then
        draw.SimpleText(self.text, self.font, w / 2, h / 2, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        surface.SetDrawColor(255, 255, 255)
        surface.DrawLine(0, 0, w, 0)
        surface.DrawLine(0, 0, 0, h)
        surface.DrawLine(0, h, w, h)
    end
end

function roleDescriptionButton:DoClick()
    GM.roleDescMenuButtonNumber = self.role
end

function roleDescriptionButton:Think()
    GM.roleDescMenuButtonX, GM.roleDescMenuButtonY = self:GetPos()
    GM.roleDesMenuButtonWide, GM.roleDescMenuButtonTall = self:GetSize()
end

vgui.Register("RoleDescriptionButton", roleDescriptionButton, "DButton")

--//

local armorDescriptionButton = table.Copy(roleDescriptionButton)

function armorDescriptionButton:SetArmor(num)
    armorDescriptionButton.armor = num
end

function armorDescriptionButton:DoClick()
    GM.armorDescMenuButtonDown = self.armor
end

function armorDescMenuButtonDown:Paint()
    local w, h = self:GetSize()

    draw.SimpleText(self.text, self.font, w / 2, h / 2, Color(175, 175, 175), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    if self.cursorEntered or GM.armorDescMenuButtonDown == self.armor then
        draw.SimpleText(self.text, self.font, w / 2, h / 2, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        surface.SetDrawColor(255, 255, 255)
        surface.DrawLine(0, 0, w, 0)
        surface.DrawLine(0, 0, 0, h)
        surface.DrawLine(0, h, w, h)
    end
end

function roleDescriptionButton:Think()
    GM.armorDescMenuButtonDownX, GM.armorDescMenuButtonDownY = self:GetPos()
    GM.armorDescMenuButtonDownWide, GM.armorDescMenuButtonDownTall = self:GetSize()
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

function armorInfoIcon:SetNum(num)
    self.scale = num
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
        if self.scale > GM.Armor[2].scaleType then
            self.color = Color(0, 160, 0)
        elseif self.scale < GM.Armor[2].scaleType then
            self.color = Color(170, 0, 0)
        end
    else
        if self.scale > GM.Armor[2].scaleType.scaleNum then
            self.color = Color(0, 160, 0)
        elseif tonumber(text) < GM.Armor[2].scaleType.scaleNum then
            self.color = Color(170, 0, 0)
        end
    end
end

function armorInfoIcon:Paint()
    local w, h = self:GetSize()


    if self.img then --if IsValid(self.img) then
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
end

vgui.Register("ArmorInfoIcon", armorInfoIcon, "DPanel")