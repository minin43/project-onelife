--//This file is strictly for creating/registering custom vgui elements

local roleButton = {}
roleButton.font = "DermaLarge"
roleButton.text = ""
roleButton.imgsrc = ""
roleButton.img = Material(roleButton.imgsrc)
roleButton.title = false
roleButton.hover = false
roleButton.locked = false
roleButton.selected = false

function roleButton:SetFont(font)
    self.font = font
end

function roleButton:SetText(text)
    self.text = text
end

function roleButton:IsTitle(bool)
    self.title = bool
end

function roleButton:IsLocked(bool)
    roleButton.locked = bool
end

function roleButton:SetImage(img)
    self.imgsrc = img
    self.img = Material(roleButton.imgsrc)
end

--[[function roleButton:Selected(bool)
    if bool == true or bool == false then
        self.selected = bool
    else
        return self.selected
    end
end]]

function roleButton:OnCursorEntered()
    --surface.PlaySound("")
end

function roleButton:Paint()
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
            if hover or GM.roleMainButtonDown == self then
                surface.SetDrawColor(255, 255, 255)
                surface.DrawOutlinedRect(0, 0, w, h)
            end
        end
    end
end

vgui.Register("RoleButton", roleButton, "DButton")