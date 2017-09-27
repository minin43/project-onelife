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
        net.Start( "RequestLevel" )
		net.SendToServer()
		net.Receive( "RequestLevelCallback", function( len, ply )
			self.playerLevel = tonumber( net.ReadString() )
		end )
    end
    if not self.playerMoney then
        net.Start( "RequestMoney" )
		net.SendToServer()
		net.Receive( "RequestMoneyCallback", function()
			self.playerMoney = tonumber( net.ReadString() )
		end )
    end

	self.Main = vgui.Create( "DFrame" )
	self.Main:SetSize( ScrW() - 70, ScrH() - 70 )
	self.Main:SetTitle( "" )
	self.Main:SetVisible( true )
	self.Main:SetDraggable( false )
	self.Main:ShowCloseButton( false )
	self.Main:MakePopup()
	self.Main:Center()
    self.Main.Paint = function()
		Derma_DrawBackgroundBlur( self.Main, CurTime() )
		surface.SetDrawColor( 0, 0, 0, 250 )
        surface.DrawRect( 0, 0, self.Main:GetWide(), self.Main:GetTall() )
    end
	self.Main.Think = function()
		if customizeself.Main then
			customizeself.Main:MakePopup()
		end
	end

end

--//Similar to the menu system of Insurgency, players will select their roles on a separate menu
--//Plan: list all teammate's and their roles, and a summary of the enemy's roles
function GM:RoleMenu()

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
		surface.SetDrawColor(0, 0, 0, 250)
        surface.DrawRect(0, 0, self.roleMain:GetWide(), self.roleMain:GetTall())
    end
	self.roleMain.Think = function()
		if self.roleMain then
			self.roleMain:MakePopup()
		end
	end
	
	--//When you select a role, display role-sepcific information, if it's an unlocked role, automatically select it
	self.roleMainPanel = vgui.Create("DPanel", self.roleMain)
	self.roleMainPanel:SetSize(self.roleMain:GetWide(), self.roleMain:GetTall())
	self.roleMainPanel:SetPos(0, 0)
	self.roleMainPanel.Paint = function()

	end

	self.roleTeam = vgui.Create("DFrame")
	self.roleTeam:SetSize(200, 600)
	self.roleTeam:SetPos(self.roleMainX - self.roleTeam:GetWide() - 4, self.roleMainY)
	self.roleTeamX, self.roleTeamY = self.roleTeam:GetPos()
	self.roleTeam:SetTitle("")
	self.roleTeam:SetVisible(true)
	self.roleTeam:SetDraggable(false)
	self.roleTeam:ShowCloseButton(false)
	self.roleTeam:MakePopup()
    self.roleTeam.Paint = function()
		surface.SetDrawColor(0, 0, 0, 250)
        surface.DrawRect(0, 0, self.roleTeam:GetWide(), self.roleTeam:GetTall())
    end
	self.roleTeam.Think = function()
		if self.roleTeam then
			self.roleTeam:MakePopup()
		end
	end

	self.roleTeamScroll = vgui.Create("DScrollPanel", self.roleTeam)
	self.roleTeamScroll:SetPos(0, 10)
	self.roleTeamScroll:SetSize(self.roleTeam:GetWide(), self.roleTeam:GetTall() - 10)
	self.roleTeamScroll.Paint = function()

	end

end