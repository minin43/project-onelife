--//This file is strictly for creating/registering custom vgui elements

local roleSelectionButton = {}
roleSelectionButton.font = "DermaLarge"
roleSelectionButton.text = "nil"
roleSelectionButton.imgsrc = ""
roleSelectionButton.img = Material(roleSelectionButton.imgsrc)
roleSelectionButton.title = false
roleSelectionButton.hover = false
roleSelectionButton.locked = false
roleSelectionButton.selected = false
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
        GM.roleMainButtonDown = self.role
    end
end

function roleSelectionButton:OnCursorEntered()
    --surface.PlaySound("")
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
            if self.cursorEntered or GM.roleMainButtonDown == self then
                surface.SetDrawColor(255, 255, 255)
                surface.DrawOutlinedRect(0, 0, w, h)
            end
        end
    end
end

vgui.Register("RoleSelectionButton", roleSelectionButton, "DButton")

local roleDescriptionButton = {}
roleDescriptionButton.text = ""

function roleDescriptionButton:SetText(txt)
    self.text = txt
end

function roleDescriptionButton:OnCursorEntered()
    self.cursorEntered = true
end

function roleDescriptionButton:OnCursorExited()
    self.cursorEntered = false
end

function roleDescriptionButton:Paint()

end

function roleDescriptionButton:DoClick()

end