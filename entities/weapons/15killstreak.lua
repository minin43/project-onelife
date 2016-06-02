
AddCSLuaFile()

function SWEP:Initialize()
      return self.BaseClass.Initialize(self)
end

SWEP.HoldType = "normal"


SWEP.PrintName = "Rocketeer Drone Reward"
SWEP.Slot = 0

SWEP.ViewModelFOV = 10

SWEP.Base = "weapon_base"

SWEP.SlotPos				= 1

SWEP.ViewModel          = "models/weapons/v_crowbar.mdl"
SWEP.WorldModel         = "models/props/cs_office/microwave.mdl"

SWEP.DrawCrosshair      = false
SWEP.Primary.ClipSize       = -1
SWEP.Primary.DefaultClip    = -1
SWEP.Primary.Automatic      = true
SWEP.Primary.Ammo       = "none"
SWEP.Primary.Delay = 1.0

SWEP.Secondary.ClipSize     = -1
SWEP.Secondary.DefaultClip  = -1
SWEP.Secondary.Automatic    = true
SWEP.Secondary.Ammo     = "none"
SWEP.Secondary.Delay = 1.0

SWEP.NoSights = true

function SWEP:OnDrop()
   self:Remove()
end

function SWEP:PrimaryAttack()
   self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
   self:DroneDrop()
end
function SWEP:SecondaryAttack()
   self:SetNextSecondaryFire( CurTime() + self.Secondary.Delay )
   self:DroneDrop()
end

local throwsound = Sound( "Weapon_SLAM.SatchelThrow" )

-- ye olde droppe code
function SWEP:DroneDrop()
   if SERVER then
      local ply = self.Owner
      if not IsValid(ply) then return end

      if self.Planted then return end

      local vsrc = ply:GetShootPos()
      local vang = ply:GetAimVector()
      local vvel = ply:GetVelocity()
      
      local vthrow = vvel + vang * 200

      local drone = ents.Create("dronesrewrite_artillery")
      if IsValid(drone) then
         drone:SetPos(vsrc + vang * 10)
         drone:Spawn()

         drone:PhysWake()
         local phys = drone:GetPhysicsObject()
         if IsValid(phys) then
            phys:SetVelocity(vthrow)
         end   
         self:Remove()

         self.Planted = true
      end
   end

   self:EmitSound(throwsound)
end

function SWEP:Reload()
   return false
end