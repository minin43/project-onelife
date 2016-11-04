function weapons.OnLoaded()
--// "weapons.OnLoaded is an internal function, which means you can call it but you shouldn't." WAH.
print( "sh_weaponstats initialization..." )
--[[if weapons.Get( "cw_kk_ins2_ak74" ) then
    local wep = weapons.GetStored( "cw_kk_ins2_ak74" )
	--wep.PrintName = ""
    wep.SpeedDec = 0 --Gun Weight
    wep.Slot = 3 --The weapon slot to be used
    --wep.FireModes = {"auto", "semi"} --Available firing types
    wep.Primary.ClipSize = 30 --Weapon clip size
    wep.Primary.DefaultClip	= 30 --Initial clip clip size
    --wep.Primary.Ammo = "" --The ammo type the weapon uses
    wep.FireDelay = 0 --Fire rate
    wep.Recoil = 0 --Recoil
    wep.HipSpread = 0 --Starting spread when firing from the hip
    wep.AimSpread = 0 --Starting Spread when firing while aiming
    wep.VelocitySensitivity = 0 --Spread increase when whipping your gun around
    wep.MaxSpreadInc = 0 --Maximum spread your weapon can achieve
    wep.SpreadPerShot = 0 --Spread increase per bullet
    wep.SpeadCooldown = wep.FireDelay + 0.05 --Length in seconds before the spread reset
    wep.Shots = 1 --How many shots come out of the gun when fired (not ammo consumption)
    wep.Damage = 0 --Damage
    wep.ReloadTimes[ base_reload ] = { 0, 0 } --Time acceleration, time in seconds when ammo is in the clip
    wep.ReloadTimes[ base_reloadempty ] = { 0, 0 } --Time acceleration, time in seconds with an empty magazine
end

if weapons.Get( "cw_kk_ins2_akm" ) then
    local wep = weapons.GetStored( "cw_kk_ins2_akm" )
	--wep.PrintName = ""
    wep.SpeedDec = 0 --Gun Weight
    wep.Slot = 3 --The weapon slot to be used
    --wep.FireModes = {"auto", "semi"} --Available firing types
    wep.Primary.ClipSize = 30 --Weapon clip size
    wep.Primary.DefaultClip	= 30 --Initial clip clip size
    --wep.Primary.Ammo = "" --The ammo type the weapon uses
    wep.FireDelay = 0 --Fire rate
    wep.Recoil = 0 --Recoil
    wep.HipSpread = 0 --Starting spread when firing from the hip
    wep.AimSpread = 0 --Starting Spread when firing while aiming
    wep.VelocitySensitivity = 0 --Spread increase when whipping your gun around
    wep.MaxSpreadInc = 0 --Maximum spread your weapon can achieve
    wep.SpreadPerShot = 0 --Spread increase per bullet
    wep.SpeadCooldown = wep.FireDelay + 0.05 --Length in seconds before the spread reset
    wep.Shots = 1 --How many shots come out of the gun when fired (not ammo consumption)
    wep.Damage = 0 --Damage
    wep.ReloadTimes[ base_reload ] = { 0, 0 } --Time acceleration, time in seconds when ammo is in the clip
    wep.ReloadTimes[ base_reloadempty ] = { 0, 0 } --Time acceleration, time in seconds with an empty magazine
end

if weapons.Get( "cw_kk_ins2_aks74u" ) then
    local wep = weapons.GetStored( "cw_kk_ins2_aks74u" )
	--wep.PrintName = ""
    wep.SpeedDec = 0 --Gun Weight
    wep.Slot = 3 --The weapon slot to be used
    --wep.FireModes = {"auto", "semi"} --Available firing types
    wep.Primary.ClipSize = 30 --Weapon clip size
    wep.Primary.DefaultClip	= 30 --Initial clip clip size
    --wep.Primary.Ammo = "" --The ammo type the weapon uses
    wep.FireDelay = 0 --Fire rate
    wep.Recoil = 0 --Recoil
    wep.HipSpread = 0 --Starting spread when firing from the hip
    wep.AimSpread = 0 --Starting Spread when firing while aiming
    wep.VelocitySensitivity = 0 --Spread increase when whipping your gun around
    wep.MaxSpreadInc = 0 --Maximum spread your weapon can achieve
    wep.SpreadPerShot = 0 --Spread increase per bullet
    wep.SpeadCooldown = wep.FireDelay + 0.05 --Length in seconds before the spread reset
    wep.Shots = 1 --How many shots come out of the gun when fired (not ammo consumption)
    wep.Damage = 0 --Damage
    wep.ReloadTimes[ base_reload ] = { 0, 0 } --Time acceleration, time in seconds when ammo is in the clip
    wep.ReloadTimes[ base_reloadempty ] = { 0, 0 } --Time acceleration, time in seconds with an empty magazine
end

if weapons.Get( "cw_kk_ins2_fnfal" ) then
    local wep = weapons.GetStored( "cw_kk_ins2_fnfal" )
	--wep.PrintName = ""
    wep.SpeedDec = 0 --Gun Weight
    wep.Slot = 3 --The weapon slot to be used
    --wep.FireModes = {"auto", "semi"} --Available firing types
    wep.Primary.ClipSize = 30 --Weapon clip size
    wep.Primary.DefaultClip	= 30 --Initial clip clip size
    --wep.Primary.Ammo = "" --The ammo type the weapon uses
    wep.FireDelay = 0 --Fire rate
    wep.Recoil = 0 --Recoil
    wep.HipSpread = 0 --Starting spread when firing from the hip
    wep.AimSpread = 0 --Starting Spread when firing while aiming
    wep.VelocitySensitivity = 0 --Spread increase when whipping your gun around
    wep.MaxSpreadInc = 0 --Maximum spread your weapon can achieve
    wep.SpreadPerShot = 0 --Spread increase per bullet
    wep.SpeadCooldown = wep.FireDelay + 0.05 --Length in seconds before the spread reset
    wep.Shots = 1 --How many shots come out of the gun when fired (not ammo consumption)
    wep.Damage = 0 --Damage
    wep.ReloadTimes[ base_reload ] = { 0, 0 } --Time acceleration, time in seconds when ammo is in the clip
    wep.ReloadTimes[ base_reloadempty ] = { 0, 0 } --Time acceleration, time in seconds with an empty magazine
end

if weapons.Get( "cw_kk_ins2_m1a1" ) then
    local wep = weapons.GetStored( "cw_kk_ins2_m1a1" )
	--wep.PrintName = ""
    wep.SpeedDec = 0 --Gun Weight
    wep.Slot = 3 --The weapon slot to be used
    --wep.FireModes = {"auto", "semi"} --Available firing types
    wep.Primary.ClipSize = 30 --Weapon clip size
    wep.Primary.DefaultClip	= 30 --Initial clip clip size
    --wep.Primary.Ammo = "" --The ammo type the weapon uses
    wep.FireDelay = 0 --Fire rate
    wep.Recoil = 0 --Recoil
    wep.HipSpread = 0 --Starting spread when firing from the hip
    wep.AimSpread = 0 --Starting Spread when firing while aiming
    wep.VelocitySensitivity = 0 --Spread increase when whipping your gun around
    wep.MaxSpreadInc = 0 --Maximum spread your weapon can achieve
    wep.SpreadPerShot = 0 --Spread increase per bullet
    wep.SpeadCooldown = wep.FireDelay + 0.05 --Length in seconds before the spread reset
    wep.Shots = 1 --How many shots come out of the gun when fired (not ammo consumption)
    wep.Damage = 0 --Damage
    wep.ReloadTimes[ base_reload ] = { 0, 0 } --Time acceleration, time in seconds when ammo is in the clip
    wep.ReloadTimes[ base_reloadempty ] = { 0, 0 } --Time acceleration, time in seconds with an empty magazine
end

if weapons.Get( "cw_kk_ins2_m1a1_para" ) then
    local wep = weapons.GetStored( "cw_kk_ins2_m1a1_para" )
	--wep.PrintName = ""
    wep.SpeedDec = 0 --Gun Weight
    wep.Slot = 3 --The weapon slot to be used
    --wep.FireModes = {"auto", "semi"} --Available firing types
    wep.Primary.ClipSize = 30 --Weapon clip size
    wep.Primary.DefaultClip	= 30 --Initial clip clip size
    --wep.Primary.Ammo = "" --The ammo type the weapon uses
    wep.FireDelay = 0 --Fire rate
    wep.Recoil = 0 --Recoil
    wep.HipSpread = 0 --Starting spread when firing from the hip
    wep.AimSpread = 0 --Starting Spread when firing while aiming
    wep.VelocitySensitivity = 0 --Spread increase when whipping your gun around
    wep.MaxSpreadInc = 0 --Maximum spread your weapon can achieve
    wep.SpreadPerShot = 0 --Spread increase per bullet
    wep.SpeadCooldown = wep.FireDelay + 0.05 --Length in seconds before the spread reset
    wep.Shots = 1 --How many shots come out of the gun when fired (not ammo consumption)
    wep.Damage = 0 --Damage
    wep.ReloadTimes[ base_reload ] = { 0, 0 } --Time acceleration, time in seconds when ammo is in the clip
    wep.ReloadTimes[ base_reloadempty ] = { 0, 0 } --Time acceleration, time in seconds with an empty magazine
end]]

if weapons.Get( "cw_kk_ins2_mosin" ) then
    local wep = weapons.GetStored( "cw_kk_ins2_mosin" )
    print( "Starting edit of weapon: cw_kk_ins2_mosin" )
	--wep.PrintName = ""
    wep.SpeedDec = 40 --Gun Weight
    wep.Slot = 3 --The weapon slot to be used
    --wep.FireModes = {"auto", "semi"} --Available firing types
    wep.Primary.ClipSize = 5 --Weapon clip size
    wep.Primary.DefaultClip	= 5 --Initial clip clip size
    --wep.Primary.Ammo = "" --The ammo type the weapon uses
    wep.FireDelay = 0.3 --Fire rate
    wep.Recoil = 1.6 --Recoil
    wep.HipSpread = 0.055 --Starting spread when firing from the hip
    wep.AimSpread = 0.002 --Starting Spread when firing while aiming
    wep.VelocitySensitivity = 2.1 --Spread increase when whipping your gun around
    wep.MaxSpreadInc = 0.07 --Maximum spread your weapon can achieve
    wep.SpreadPerShot = 0.01 --Spread increase per bullet
    wep.SpeadCooldown = wep.FireDelay + 0.05 --Length in seconds before the spread reset
    wep.Shots = 1 --How many shots come out of the gun when fired (not ammo consumption)
    wep.Damage = 100 --Damage
    --wep.ReloadTimes[ base_reload ] = { 0, 0 } --Time acceleration, time in seconds when ammo is in the clip
    --wep.ReloadTimes[ base_reloadempty ] = { 0, 0 } --Time acceleration, time in seconds with an empty magazine
end

--[[if weapons.Get( "cw_kk_ins2_mp40" ) then
    local wep = weapons.GetStored( "cw_kk_ins2_mp40" )
	--wep.PrintName = ""
    wep.SpeedDec = 0 --Gun Weight
    wep.Slot = 3 --The weapon slot to be used
    --wep.FireModes = {"auto", "semi"} --Available firing types
    wep.Primary.ClipSize = 30 --Weapon clip size
    wep.Primary.DefaultClip	= 30 --Initial clip clip size
    --wep.Primary.Ammo = "" --The ammo type the weapon uses
    wep.FireDelay = 0 --Fire rate
    wep.Recoil = 0 --Recoil
    wep.HipSpread = 0 --Starting spread when firing from the hip
    wep.AimSpread = 0 --Starting Spread when firing while aiming
    wep.VelocitySensitivity = 0 --Spread increase when whipping your gun around
    wep.MaxSpreadInc = 0 --Maximum spread your weapon can achieve
    wep.SpreadPerShot = 0 --Spread increase per bullet
    wep.SpeadCooldown = wep.FireDelay + 0.05 --Length in seconds before the spread reset
    wep.Shots = 1 --How many shots come out of the gun when fired (not ammo consumption)
    wep.Damage = 0 --Damage
    wep.ReloadTimes[ base_reload ] = { 0, 0 } --Time acceleration, time in seconds when ammo is in the clip
    wep.ReloadTimes[ base_reloadempty ] = { 0, 0 } --Time acceleration, time in seconds with an empty magazine
end

if weapons.Get( "cw_kk_ins2_rpk" ) then
    local wep = weapons.GetStored( "cw_kk_ins2_rpk" )
	--wep.PrintName = ""
    wep.SpeedDec = 0 --Gun Weight
    wep.Slot = 3 --The weapon slot to be used
    --wep.FireModes = {"auto", "semi"} --Available firing types
    wep.Primary.ClipSize = 30 --Weapon clip size
    wep.Primary.DefaultClip	= 30 --Initial clip clip size
    --wep.Primary.Ammo = "" --The ammo type the weapon uses
    wep.FireDelay = 0 --Fire rate
    wep.Recoil = 0 --Recoil
    wep.HipSpread = 0 --Starting spread when firing from the hip
    wep.AimSpread = 0 --Starting Spread when firing while aiming
    wep.VelocitySensitivity = 0 --Spread increase when whipping your gun around
    wep.MaxSpreadInc = 0 --Maximum spread your weapon can achieve
    wep.SpreadPerShot = 0 --Spread increase per bullet
    wep.SpeadCooldown = wep.FireDelay + 0.05 --Length in seconds before the spread reset
    wep.Shots = 1 --How many shots come out of the gun when fired (not ammo consumption)
    wep.Damage = 0 --Damage
    wep.ReloadTimes[ base_reload ] = { 0, 0 } --Time acceleration, time in seconds when ammo is in the clip
    wep.ReloadTimes[ base_reloadempty ] = { 0, 0 } --Time acceleration, time in seconds with an empty magazine
end

if weapons.Get( "cw_kk_ins2_sks" ) then
    local wep = weapons.GetStored( "cw_kk_ins2_sks" )
	--wep.PrintName = ""
    wep.SpeedDec = 0 --Gun Weight
    wep.Slot = 3 --The weapon slot to be used
    --wep.FireModes = {"auto", "semi"} --Available firing types
    wep.Primary.ClipSize = 30 --Weapon clip size
    wep.Primary.DefaultClip	= 30 --Initial clip clip size
    --wep.Primary.Ammo = "" --The ammo type the weapon uses
    wep.FireDelay = 0 --Fire rate
    wep.Recoil = 0 --Recoil
    wep.HipSpread = 0 --Starting spread when firing from the hip
    wep.AimSpread = 0 --Starting Spread when firing while aiming
    wep.VelocitySensitivity = 0 --Spread increase when whipping your gun around
    wep.MaxSpreadInc = 0 --Maximum spread your weapon can achieve
    wep.SpreadPerShot = 0 --Spread increase per bullet
    wep.SpeadCooldown = wep.FireDelay + 0.05 --Length in seconds before the spread reset
    wep.Shots = 1 --How many shots come out of the gun when fired (not ammo consumption)
    wep.Damage = 0 --Damage
    wep.ReloadTimes[ base_reload ] = { 0, 0 } --Time acceleration, time in seconds when ammo is in the clip
    wep.ReloadTimes[ base_reloadempty ] = { 0, 0 } --Time acceleration, time in seconds with an empty magazine
end

if weapons.Get( "cw_kk_ins2_sterling" ) then
    local wep = weapons.GetStored( "cw_kk_ins2_sterling" )
	--wep.PrintName = ""
    wep.SpeedDec = 0 --Gun Weight
    wep.Slot = 3 --The weapon slot to be used
    --wep.FireModes = {"auto", "semi"} --Available firing types
    wep.Primary.ClipSize = 30 --Weapon clip size
    wep.Primary.DefaultClip	= 30 --Initial clip clip size
    --wep.Primary.Ammo = "" --The ammo type the weapon uses
    wep.FireDelay = 0 --Fire rate
    wep.Recoil = 0 --Recoil
    wep.HipSpread = 0 --Starting spread when firing from the hip
    wep.AimSpread = 0 --Starting Spread when firing while aiming
    wep.VelocitySensitivity = 0 --Spread increase when whipping your gun around
    wep.MaxSpreadInc = 0 --Maximum spread your weapon can achieve
    wep.SpreadPerShot = 0 --Spread increase per bullet
    wep.SpeadCooldown = wep.FireDelay + 0.05 --Length in seconds before the spread reset
    wep.Shots = 1 --How many shots come out of the gun when fired (not ammo consumption)
    wep.Damage = 0 --Damage
    wep.ReloadTimes[ base_reload ] = { 0, 0 } --Time acceleration, time in seconds when ammo is in the clip
    wep.ReloadTimes[ base_reloadempty ] = { 0, 0 } --Time acceleration, time in seconds with an empty magazine
end

if weapons.Get( "cw_kk_ins2_sterling" ) then
    local wep = weapons.GetStored( "cw_kk_ins2_sterling" )
	--wep.PrintName = ""
    wep.SpeedDec = 0 --Gun Weight
    wep.Slot = 3 --The weapon slot to be used
    --wep.FireModes = {"auto", "semi"} --Available firing types
    wep.Primary.ClipSize = 30 --Weapon clip size
    wep.Primary.DefaultClip	= 30 --Initial clip clip size
    --wep.Primary.Ammo = "" --The ammo type the weapon uses
    wep.FireDelay = 0 --Fire rate
    wep.Recoil = 0 --Recoil
    wep.HipSpread = 0 --Starting spread when firing from the hip
    wep.AimSpread = 0 --Starting Spread when firing while aiming
    wep.VelocitySensitivity = 0 --Spread increase when whipping your gun around
    wep.MaxSpreadInc = 0 --Maximum spread your weapon can achieve
    wep.SpreadPerShot = 0 --Spread increase per bullet
    wep.SpeadCooldown = wep.FireDelay + 0.05 --Length in seconds before the spread reset
    wep.Shots = 1 --How many shots come out of the gun when fired (not ammo consumption)
    wep.Damage = 0 --Damage
    wep.ReloadTimes[ base_reload ] = { 0, 0 } --Time acceleration, time in seconds when ammo is in the clip
    wep.ReloadTimes[ base_reloadempty ] = { 0, 0 } --Time acceleration, time in seconds with an empty magazine
end

if weapons.Get( "cw_kk_ins2_mini14" ) then
    local wep = weapons.GetStored( "cw_kk_ins2_mini14" )
	--wep.PrintName = ""
    wep.SpeedDec = 0 --Gun Weight
    wep.Slot = 3 --The weapon slot to be used
    --wep.FireModes = {"auto", "semi"} --Available firing types
    wep.Primary.ClipSize = 30 --Weapon clip size
    wep.Primary.DefaultClip	= 30 --Initial clip clip size
    --wep.Primary.Ammo = "" --The ammo type the weapon uses
    wep.FireDelay = 0 --Fire rate
    wep.Recoil = 0 --Recoil
    wep.HipSpread = 0 --Starting spread when firing from the hip
    wep.AimSpread = 0 --Starting Spread when firing while aiming
    wep.VelocitySensitivity = 0 --Spread increase when whipping your gun around
    wep.MaxSpreadInc = 0 --Maximum spread your weapon can achieve
    wep.SpreadPerShot = 0 --Spread increase per bullet
    wep.SpeadCooldown = wep.FireDelay + 0.05 --Length in seconds before the spread reset
    wep.Shots = 1 --How many shots come out of the gun when fired (not ammo consumption)
    wep.Damage = 0 --Damage
    wep.ReloadTimes[ base_reload ] = { 0, 0 } --Time acceleration, time in seconds when ammo is in the clip
    wep.ReloadTimes[ base_reloadempty ] = { 0, 0 } --Time acceleration, time in seconds with an empty magazine
end

if weapons.Get( "cw_kk_ins2_galil" ) then
    local wep = weapons.GetStored( "cw_kk_ins2_galil" )
	--wep.PrintName = ""
    wep.SpeedDec = 0 --Gun Weight
    wep.Slot = 3 --The weapon slot to be used
    --wep.FireModes = {"auto", "semi"} --Available firing types
    wep.Primary.ClipSize = 30 --Weapon clip size
    wep.Primary.DefaultClip	= 30 --Initial clip clip size
    --wep.Primary.Ammo = "" --The ammo type the weapon uses
    wep.FireDelay = 0 --Fire rate
    wep.Recoil = 0 --Recoil
    wep.HipSpread = 0 --Starting spread when firing from the hip
    wep.AimSpread = 0 --Starting Spread when firing while aiming
    wep.VelocitySensitivity = 0 --Spread increase when whipping your gun around
    wep.MaxSpreadInc = 0 --Maximum spread your weapon can achieve
    wep.SpreadPerShot = 0 --Spread increase per bullet
    wep.SpeadCooldown = wep.FireDelay + 0.05 --Length in seconds before the spread reset
    wep.Shots = 1 --How many shots come out of the gun when fired (not ammo consumption)
    wep.Damage = 0 --Damage
    wep.ReloadTimes[ base_reload ] = { 0, 0 } --Time acceleration, time in seconds when ammo is in the clip
    wep.ReloadTimes[ base_reloadempty ] = { 0, 0 } --Time acceleration, time in seconds with an empty magazine
end

if weapons.Get( "cw_kk_ins2_cstm_galil_ace" ) then
    local wep = weapons.GetStored( "cw_kk_ins2_cstm_galil_ace" )
	--wep.PrintName = ""
    wep.SpeedDec = 0 --Gun Weight
    wep.Slot = 3 --The weapon slot to be used
    --wep.FireModes = {"auto", "semi"} --Available firing types
    wep.Primary.ClipSize = 30 --Weapon clip size
    wep.Primary.DefaultClip	= 30 --Initial clip clip size
    --wep.Primary.Ammo = "" --The ammo type the weapon uses
    wep.FireDelay = 0 --Fire rate
    wep.Recoil = 0 --Recoil
    wep.HipSpread = 0 --Starting spread when firing from the hip
    wep.AimSpread = 0 --Starting Spread when firing while aiming
    wep.VelocitySensitivity = 0 --Spread increase when whipping your gun around
    wep.MaxSpreadInc = 0 --Maximum spread your weapon can achieve
    wep.SpreadPerShot = 0 --Spread increase per bullet
    wep.SpeadCooldown = wep.FireDelay + 0.05 --Length in seconds before the spread reset
    wep.Shots = 1 --How many shots come out of the gun when fired (not ammo consumption)
    wep.Damage = 0 --Damage
    wep.ReloadTimes[ base_reload ] = { 0, 0 } --Time acceleration, time in seconds when ammo is in the clip
    wep.ReloadTimes[ base_reloadempty ] = { 0, 0 } --Time acceleration, time in seconds with an empty magazine
end

if weapons.Get( "cw_kk_ins2_mp5k" ) then
    local wep = weapons.GetStored( "cw_kk_ins2_mp5k" )
	--wep.PrintName = ""
    wep.SpeedDec = 0 --Gun Weight
    wep.Slot = 3 --The weapon slot to be used
    --wep.FireModes = {"auto", "semi"} --Available firing types
    wep.Primary.ClipSize = 30 --Weapon clip size
    wep.Primary.DefaultClip	= 30 --Initial clip clip size
    --wep.Primary.Ammo = "" --The ammo type the weapon uses
    wep.FireDelay = 0 --Fire rate
    wep.Recoil = 0 --Recoil
    wep.HipSpread = 0 --Starting spread when firing from the hip
    wep.AimSpread = 0 --Starting Spread when firing while aiming
    wep.VelocitySensitivity = 0 --Spread increase when whipping your gun around
    wep.MaxSpreadInc = 0 --Maximum spread your weapon can achieve
    wep.SpreadPerShot = 0 --Spread increase per bullet
    wep.SpeadCooldown = wep.FireDelay + 0.05 --Length in seconds before the spread reset
    wep.Shots = 1 --How many shots come out of the gun when fired (not ammo consumption)
    wep.Damage = 0 --Damage
    wep.ReloadTimes[ base_reload ] = { 0, 0 } --Time acceleration, time in seconds when ammo is in the clip
    wep.ReloadTimes[ base_reloadempty ] = { 0, 0 } --Time acceleration, time in seconds with an empty magazine
end

if weapons.Get( "cw_kk_ins2_ump45" ) then
    local wep = weapons.GetStored( "cw_kk_ins2_ump45" )
	--wep.PrintName = ""
    wep.SpeedDec = 0 --Gun Weight
    wep.Slot = 3 --The weapon slot to be used
    --wep.FireModes = {"auto", "semi"} --Available firing types
    wep.Primary.ClipSize = 30 --Weapon clip size
    wep.Primary.DefaultClip	= 30 --Initial clip clip size
    --wep.Primary.Ammo = "" --The ammo type the weapon uses
    wep.FireDelay = 0 --Fire rate
    wep.Recoil = 0 --Recoil
    wep.HipSpread = 0 --Starting spread when firing from the hip
    wep.AimSpread = 0 --Starting Spread when firing while aiming
    wep.VelocitySensitivity = 0 --Spread increase when whipping your gun around
    wep.MaxSpreadInc = 0 --Maximum spread your weapon can achieve
    wep.SpreadPerShot = 0 --Spread increase per bullet
    wep.SpeadCooldown = wep.FireDelay + 0.05 --Length in seconds before the spread reset
    wep.Shots = 1 --How many shots come out of the gun when fired (not ammo consumption)
    wep.Damage = 0 --Damage
    wep.ReloadTimes[ base_reload ] = { 0, 0 } --Time acceleration, time in seconds when ammo is in the clip
    wep.ReloadTimes[ base_reloadempty ] = { 0, 0 } --Time acceleration, time in seconds with an empty magazine
end

if weapons.Get( "cw_kk_ins2_l1a1" ) then
    local wep = weapons.GetStored( "cw_kk_ins2_l1a1" )
	--wep.PrintName = ""
    wep.SpeedDec = 0 --Gun Weight
    wep.Slot = 3 --The weapon slot to be used
    --wep.FireModes = {"auto", "semi"} --Available firing types
    wep.Primary.ClipSize = 30 --Weapon clip size
    wep.Primary.DefaultClip	= 30 --Initial clip clip size
    --wep.Primary.Ammo = "" --The ammo type the weapon uses
    wep.FireDelay = 0 --Fire rate
    wep.Recoil = 0 --Recoil
    wep.HipSpread = 0 --Starting spread when firing from the hip
    wep.AimSpread = 0 --Starting Spread when firing while aiming
    wep.VelocitySensitivity = 0 --Spread increase when whipping your gun around
    wep.MaxSpreadInc = 0 --Maximum spread your weapon can achieve
    wep.SpreadPerShot = 0 --Spread increase per bullet
    wep.SpeadCooldown = wep.FireDelay + 0.05 --Length in seconds before the spread reset
    wep.Shots = 1 --How many shots come out of the gun when fired (not ammo consumption)
    wep.Damage = 0 --Damage
    wep.ReloadTimes[ base_reload ] = { 0, 0 } --Time acceleration, time in seconds when ammo is in the clip
    wep.ReloadTimes[ base_reloadempty ] = { 0, 0 } --Time acceleration, time in seconds with an empty magazine
end

if weapons.Get( "cw_kk_ins2_m14" ) then
    local wep = weapons.GetStored( "cw_kk_ins2_m14" )
	--wep.PrintName = ""
    wep.SpeedDec = 0 --Gun Weight
    wep.Slot = 3 --The weapon slot to be used
    --wep.FireModes = {"auto", "semi"} --Available firing types
    wep.Primary.ClipSize = 30 --Weapon clip size
    wep.Primary.DefaultClip	= 30 --Initial clip clip size
    --wep.Primary.Ammo = "" --The ammo type the weapon uses
    wep.FireDelay = 0 --Fire rate
    wep.Recoil = 0 --Recoil
    wep.HipSpread = 0 --Starting spread when firing from the hip
    wep.AimSpread = 0 --Starting Spread when firing while aiming
    wep.VelocitySensitivity = 0 --Spread increase when whipping your gun around
    wep.MaxSpreadInc = 0 --Maximum spread your weapon can achieve
    wep.SpreadPerShot = 0 --Spread increase per bullet
    wep.SpeadCooldown = wep.FireDelay + 0.05 --Length in seconds before the spread reset
    wep.Shots = 1 --How many shots come out of the gun when fired (not ammo consumption)
    wep.Damage = 0 --Damage
    wep.ReloadTimes[ base_reload ] = { 0, 0 } --Time acceleration, time in seconds when ammo is in the clip
    wep.ReloadTimes[ base_reloadempty ] = { 0, 0 } --Time acceleration, time in seconds with an empty magazine
end

if weapons.Get( "cw_kk_ins2_m16a4" ) then
    local wep = weapons.GetStored( "cw_kk_ins2_m16a4" )
	--wep.PrintName = ""
    wep.SpeedDec = 0 --Gun Weight
    wep.Slot = 3 --The weapon slot to be used
    --wep.FireModes = {"auto", "semi"} --Available firing types
    wep.Primary.ClipSize = 30 --Weapon clip size
    wep.Primary.DefaultClip	= 30 --Initial clip clip size
    --wep.Primary.Ammo = "" --The ammo type the weapon uses
    wep.FireDelay = 0 --Fire rate
    wep.Recoil = 0 --Recoil
    wep.HipSpread = 0 --Starting spread when firing from the hip
    wep.AimSpread = 0 --Starting Spread when firing while aiming
    wep.VelocitySensitivity = 0 --Spread increase when whipping your gun around
    wep.MaxSpreadInc = 0 --Maximum spread your weapon can achieve
    wep.SpreadPerShot = 0 --Spread increase per bullet
    wep.SpeadCooldown = wep.FireDelay + 0.05 --Length in seconds before the spread reset
    wep.Shots = 1 --How many shots come out of the gun when fired (not ammo consumption)
    wep.Damage = 0 --Damage
    wep.ReloadTimes[ base_reload ] = { 0, 0 } --Time acceleration, time in seconds when ammo is in the clip
    wep.ReloadTimes[ base_reloadempty ] = { 0, 0 } --Time acceleration, time in seconds with an empty magazine
end

if weapons.Get( "cw_kk_ins2_m249" ) then
    local wep = weapons.GetStored( "cw_kk_ins2_m249" )
	--wep.PrintName = ""
    wep.SpeedDec = 0 --Gun Weight
    wep.Slot = 3 --The weapon slot to be used
    --wep.FireModes = {"auto", "semi"} --Available firing types
    wep.Primary.ClipSize = 30 --Weapon clip size
    wep.Primary.DefaultClip	= 30 --Initial clip clip size
    --wep.Primary.Ammo = "" --The ammo type the weapon uses
    wep.FireDelay = 0 --Fire rate
    wep.Recoil = 0 --Recoil
    wep.HipSpread = 0 --Starting spread when firing from the hip
    wep.AimSpread = 0 --Starting Spread when firing while aiming
    wep.VelocitySensitivity = 0 --Spread increase when whipping your gun around
    wep.MaxSpreadInc = 0 --Maximum spread your weapon can achieve
    wep.SpreadPerShot = 0 --Spread increase per bullet
    wep.SpeadCooldown = wep.FireDelay + 0.05 --Length in seconds before the spread reset
    wep.Shots = 1 --How many shots come out of the gun when fired (not ammo consumption)
    wep.Damage = 0 --Damage
    wep.ReloadTimes[ base_reload ] = { 0, 0 } --Time acceleration, time in seconds when ammo is in the clip
    wep.ReloadTimes[ base_reloadempty ] = { 0, 0 } --Time acceleration, time in seconds with an empty magazine
end]]

if weapons.Get( "cw_kk_ins2_m40a1" ) then
    local wep = weapons.GetStored( "cw_kk_ins2_m40a1" )
    print( "Starting edit of weapon: cw_kk_ins2_m40a1" )
	--wep.PrintName = ""
    wep.SpeedDec = 40 --Gun Weight
    wep.Slot = 3 --The weapon slot to be used
    --wep.FireModes = {"auto", "semi"} --Available firing types
    wep.Primary.ClipSize = 5 --Weapon clip size
    wep.Primary.DefaultClip	= 5 --Initial clip clip size
    --wep.Primary.Ammo = "" --The ammo type the weapon uses
    wep.FireDelay = 0.3 --Fire rate
    wep.Recoil = 1.6 --Recoil
    wep.HipSpread = 0.055 --Starting spread when firing from the hip
    wep.AimSpread = 0.002 --Starting Spread when firing while aiming
    wep.VelocitySensitivity = 2.1 --Spread increase when whipping your gun around
    wep.MaxSpreadInc = 0.07 --Maximum spread your weapon can achieve
    wep.SpreadPerShot = 0.01 --Spread increase per bullet
    wep.SpeadCooldown = wep.FireDelay + 0.05 --Length in seconds before the spread reset
    wep.Shots = 1 --How many shots come out of the gun when fired (not ammo consumption)
    wep.Damage = 100 --Damage
    --wep.ReloadTimes[ base_reload ] = { 0, 0 } --Time acceleration, time in seconds when ammo is in the clip
    --wep.ReloadTimes[ base_reloadempty ] = { 0, 0 } --Time acceleration, time in seconds with an empty magazine
end

--[[if weapons.Get( "cw_kk_ins2_m4a1" ) then
    local wep = weapons.GetStored( "cw_kk_ins2_m4a1" )
	--wep.PrintName = ""
    wep.SpeedDec = 0 --Gun Weight
    wep.Slot = 3 --The weapon slot to be used
    --wep.FireModes = {"auto", "semi"} --Available firing types
    wep.Primary.ClipSize = 30 --Weapon clip size
    wep.Primary.DefaultClip	= 30 --Initial clip clip size
    --wep.Primary.Ammo = "" --The ammo type the weapon uses
    wep.FireDelay = 0 --Fire rate
    wep.Recoil = 0 --Recoil
    wep.HipSpread = 0 --Starting spread when firing from the hip
    wep.AimSpread = 0 --Starting Spread when firing while aiming
    wep.VelocitySensitivity = 0 --Spread increase when whipping your gun around
    wep.MaxSpreadInc = 0 --Maximum spread your weapon can achieve
    wep.SpreadPerShot = 0 --Spread increase per bullet
    wep.SpeadCooldown = wep.FireDelay + 0.05 --Length in seconds before the spread reset
    wep.Shots = 1 --How many shots come out of the gun when fired (not ammo consumption)
    wep.Damage = 0 --Damage
    wep.ReloadTimes[ base_reload ] = { 0, 0 } --Time acceleration, time in seconds when ammo is in the clip
    wep.ReloadTimes[ base_reloadempty ] = { 0, 0 } --Time acceleration, time in seconds with an empty magazine
end

if weapons.Get( "cw_kk_ins2_m590" ) then
    local wep = weapons.GetStored( "cw_kk_ins2_m590" )
	--wep.PrintName = ""
    wep.SpeedDec = 0 --Gun Weight
    wep.Slot = 3 --The weapon slot to be used
    --wep.FireModes = {"auto", "semi"} --Available firing types
    wep.Primary.ClipSize = 30 --Weapon clip size
    wep.Primary.DefaultClip	= 30 --Initial clip clip size
    --wep.Primary.Ammo = "" --The ammo type the weapon uses
    wep.FireDelay = 0 --Fire rate
    wep.Recoil = 0 --Recoil
    wep.HipSpread = 0 --Starting spread when firing from the hip
    wep.AimSpread = 0 --Starting Spread when firing while aiming
    wep.VelocitySensitivity = 0 --Spread increase when whipping your gun around
    wep.MaxSpreadInc = 0 --Maximum spread your weapon can achieve
    wep.SpreadPerShot = 0 --Spread increase per bullet
    wep.SpeadCooldown = wep.FireDelay + 0.05 --Length in seconds before the spread reset
    wep.Shots = 1 --How many shots come out of the gun when fired (not ammo consumption)
    wep.Damage = 0 --Damage
    wep.ReloadTimes[ base_reload ] = { 0, 0 } --Time acceleration, time in seconds when ammo is in the clip
    wep.ReloadTimes[ base_reloadempty ] = { 0, 0 } --Time acceleration, time in seconds with an empty magazine
end

if weapons.Get( "cw_kk_ins2_mk18" ) then
    local wep = weapons.GetStored( "cw_kk_ins2_mk18" )
	--wep.PrintName = ""
    wep.SpeedDec = 0 --Gun Weight
    wep.Slot = 3 --The weapon slot to be used
    --wep.FireModes = {"auto", "semi"} --Available firing types
    wep.Primary.ClipSize = 30 --Weapon clip size
    wep.Primary.DefaultClip	= 30 --Initial clip clip size
    --wep.Primary.Ammo = "" --The ammo type the weapon uses
    wep.FireDelay = 0 --Fire rate
    wep.Recoil = 0 --Recoil
    wep.HipSpread = 0 --Starting spread when firing from the hip
    wep.AimSpread = 0 --Starting Spread when firing while aiming
    wep.VelocitySensitivity = 0 --Spread increase when whipping your gun around
    wep.MaxSpreadInc = 0 --Maximum spread your weapon can achieve
    wep.SpreadPerShot = 0 --Spread increase per bullet
    wep.SpeadCooldown = wep.FireDelay + 0.05 --Length in seconds before the spread reset
    wep.Shots = 1 --How many shots come out of the gun when fired (not ammo consumption)
    wep.Damage = 0 --Damage
    wep.ReloadTimes[ base_reload ] = { 0, 0 } --Time acceleration, time in seconds when ammo is in the clip
    wep.ReloadTimes[ base_reloadempty ] = { 0, 0 } --Time acceleration, time in seconds with an empty magazine
end

if weapons.Get( "cw_kk_ins2_m1911" ) then
    local wep = weapons.GetStored( "cw_kk_ins2_m1911" )
	--wep.PrintName = ""
    wep.SpeedDec = 0 --Gun Weight
    wep.Slot = 3 --The weapon slot to be used
    --wep.FireModes = {"auto", "semi"} --Available firing types
    wep.Primary.ClipSize = 30 --Weapon clip size
    wep.Primary.DefaultClip	= 30 --Initial clip clip size
    --wep.Primary.Ammo = "" --The ammo type the weapon uses
    wep.FireDelay = 0 --Fire rate
    wep.Recoil = 0 --Recoil
    wep.HipSpread = 0 --Starting spread when firing from the hip
    wep.AimSpread = 0 --Starting Spread when firing while aiming
    wep.VelocitySensitivity = 0 --Spread increase when whipping your gun around
    wep.MaxSpreadInc = 0 --Maximum spread your weapon can achieve
    wep.SpreadPerShot = 0 --Spread increase per bullet
    wep.SpeadCooldown = wep.FireDelay + 0.05 --Length in seconds before the spread reset
    wep.Shots = 1 --How many shots come out of the gun when fired (not ammo consumption)
    wep.Damage = 0 --Damage
    wep.ReloadTimes[ base_reload ] = { 0, 0 } --Time acceleration, time in seconds when ammo is in the clip
    wep.ReloadTimes[ base_reloadempty ] = { 0, 0 } --Time acceleration, time in seconds with an empty magazine
end

if weapons.Get( "cw_kk_ins2_makarov" ) then
    local wep = weapons.GetStored( "cw_kk_ins2_makarov" )
	--wep.PrintName = ""
    wep.SpeedDec = 0 --Gun Weight
    wep.Slot = 3 --The weapon slot to be used
    --wep.FireModes = {"auto", "semi"} --Available firing types
    wep.Primary.ClipSize = 30 --Weapon clip size
    wep.Primary.DefaultClip	= 30 --Initial clip clip size
    --wep.Primary.Ammo = "" --The ammo type the weapon uses
    wep.FireDelay = 0 --Fire rate
    wep.Recoil = 0 --Recoil
    wep.HipSpread = 0 --Starting spread when firing from the hip
    wep.AimSpread = 0 --Starting Spread when firing while aiming
    wep.VelocitySensitivity = 0 --Spread increase when whipping your gun around
    wep.MaxSpreadInc = 0 --Maximum spread your weapon can achieve
    wep.SpreadPerShot = 0 --Spread increase per bullet
    wep.SpeadCooldown = wep.FireDelay + 0.05 --Length in seconds before the spread reset
    wep.Shots = 1 --How many shots come out of the gun when fired (not ammo consumption)
    wep.Damage = 0 --Damage
    wep.ReloadTimes[ base_reload ] = { 0, 0 } --Time acceleration, time in seconds when ammo is in the clip
    wep.ReloadTimes[ base_reloadempty ] = { 0, 0 } --Time acceleration, time in seconds with an empty magazine
end

if weapons.Get( "cw_kk_ins2_revolver" ) then
    local wep = weapons.GetStored( "cw_kk_ins2_revolver" )
	--wep.PrintName = ""
    wep.SpeedDec = 0 --Gun Weight
    wep.Slot = 3 --The weapon slot to be used
    --wep.FireModes = {"auto", "semi"} --Available firing types
    wep.Primary.ClipSize = 30 --Weapon clip size
    wep.Primary.DefaultClip	= 30 --Initial clip clip size
    --wep.Primary.Ammo = "" --The ammo type the weapon uses
    wep.FireDelay = 0 --Fire rate
    wep.Recoil = 0 --Recoil
    wep.HipSpread = 0 --Starting spread when firing from the hip
    wep.AimSpread = 0 --Starting Spread when firing while aiming
    wep.VelocitySensitivity = 0 --Spread increase when whipping your gun around
    wep.MaxSpreadInc = 0 --Maximum spread your weapon can achieve
    wep.SpreadPerShot = 0 --Spread increase per bullet
    wep.SpeadCooldown = wep.FireDelay + 0.05 --Length in seconds before the spread reset
    wep.Shots = 1 --How many shots come out of the gun when fired (not ammo consumption)
    wep.Damage = 0 --Damage
    wep.ReloadTimes[ base_reload ] = { 0, 0 } --Time acceleration, time in seconds when ammo is in the clip
    wep.ReloadTimes[ base_reloadempty ] = { 0, 0 } --Time acceleration, time in seconds with an empty magazine
end

if weapons.Get( "cw_kk_ins2_m9" ) then
    local wep = weapons.GetStored( "cw_kk_ins2_m9" )
	--wep.PrintName = ""
    wep.SpeedDec = 0 --Gun Weight
    wep.Slot = 3 --The weapon slot to be used
    --wep.FireModes = {"auto", "semi"} --Available firing types
    wep.Primary.ClipSize = 30 --Weapon clip size
    wep.Primary.DefaultClip	= 30 --Initial clip clip size
    --wep.Primary.Ammo = "" --The ammo type the weapon uses
    wep.FireDelay = 0 --Fire rate
    wep.Recoil = 0 --Recoil
    wep.HipSpread = 0 --Starting spread when firing from the hip
    wep.AimSpread = 0 --Starting Spread when firing while aiming
    wep.VelocitySensitivity = 0 --Spread increase when whipping your gun around
    wep.MaxSpreadInc = 0 --Maximum spread your weapon can achieve
    wep.SpreadPerShot = 0 --Spread increase per bullet
    wep.SpeadCooldown = wep.FireDelay + 0.05 --Length in seconds before the spread reset
    wep.Shots = 1 --How many shots come out of the gun when fired (not ammo consumption)
    wep.Damage = 0 --Damage
    wep.ReloadTimes[ base_reload ] = { 0, 0 } --Time acceleration, time in seconds when ammo is in the clip
    wep.ReloadTimes[ base_reloadempty ] = { 0, 0 } --Time acceleration, time in seconds with an empty magazine
end

if weapons.Get( "cw_kk_ins2_m45" ) then
    local wep = weapons.GetStored( "cw_kk_ins2_m45" )
	--wep.PrintName = ""
    wep.SpeedDec = 0 --Gun Weight
    wep.Slot = 3 --The weapon slot to be used
    --wep.FireModes = {"auto", "semi"} --Available firing types
    wep.Primary.ClipSize = 30 --Weapon clip size
    wep.Primary.DefaultClip	= 30 --Initial clip clip size
    --wep.Primary.Ammo = "" --The ammo type the weapon uses
    wep.FireDelay = 0 --Fire rate
    wep.Recoil = 0 --Recoil
    wep.HipSpread = 0 --Starting spread when firing from the hip
    wep.AimSpread = 0 --Starting Spread when firing while aiming
    wep.VelocitySensitivity = 0 --Spread increase when whipping your gun around
    wep.MaxSpreadInc = 0 --Maximum spread your weapon can achieve
    wep.SpreadPerShot = 0 --Spread increase per bullet
    wep.SpeadCooldown = wep.FireDelay + 0.05 --Length in seconds before the spread reset
    wep.Shots = 1 --How many shots come out of the gun when fired (not ammo consumption)
    wep.Damage = 0 --Damage
    wep.ReloadTimes[ base_reload ] = { 0, 0 } --Time acceleration, time in seconds when ammo is in the clip
    wep.ReloadTimes[ base_reloadempty ] = { 0, 0 } --Time acceleration, time in seconds with an empty magazine
end

if weapons.Get( "cw_kk_ins2_nade_f1" ) then
    local wep = weapons.GetStored( "cw_kk_ins2_nade_f1" )
	--wep.PrintName = ""
    wep.SpeedDec = 0 --Gun Weight
    wep.Slot = 3 --The weapon slot to be used
    --wep.FireModes = {"auto", "semi"} --Available firing types
    wep.Primary.ClipSize = 30 --Weapon clip size
    wep.Primary.DefaultClip	= 30 --Initial clip clip size
    --wep.Primary.Ammo = "" --The ammo type the weapon uses
    wep.FireDelay = 0 --Fire rate
    wep.Recoil = 0 --Recoil
    wep.HipSpread = 0 --Starting spread when firing from the hip
    wep.AimSpread = 0 --Starting Spread when firing while aiming
    wep.VelocitySensitivity = 0 --Spread increase when whipping your gun around
    wep.MaxSpreadInc = 0 --Maximum spread your weapon can achieve
    wep.SpreadPerShot = 0 --Spread increase per bullet
    wep.SpeadCooldown = wep.FireDelay + 0.05 --Length in seconds before the spread reset
    wep.Shots = 1 --How many shots come out of the gun when fired (not ammo consumption)
    wep.Damage = 0 --Damage
    wep.ReloadTimes[ base_reload ] = { 0, 0 } --Time acceleration, time in seconds when ammo is in the clip
    wep.ReloadTimes[ base_reloadempty ] = { 0, 0 } --Time acceleration, time in seconds with an empty magazine
end

if weapons.Get( "cw_kk_ins2_nade_ied" ) then
    local wep = weapons.GetStored( "cw_kk_ins2_nade_ied" )
	--wep.PrintName = ""
    wep.SpeedDec = 0 --Gun Weight
    wep.Slot = 3 --The weapon slot to be used
    --wep.FireModes = {"auto", "semi"} --Available firing types
    wep.Primary.ClipSize = 30 --Weapon clip size
    wep.Primary.DefaultClip	= 30 --Initial clip clip size
    --wep.Primary.Ammo = "" --The ammo type the weapon uses
    wep.FireDelay = 0 --Fire rate
    wep.Recoil = 0 --Recoil
    wep.HipSpread = 0 --Starting spread when firing from the hip
    wep.AimSpread = 0 --Starting Spread when firing while aiming
    wep.VelocitySensitivity = 0 --Spread increase when whipping your gun around
    wep.MaxSpreadInc = 0 --Maximum spread your weapon can achieve
    wep.SpreadPerShot = 0 --Spread increase per bullet
    wep.SpeadCooldown = wep.FireDelay + 0.05 --Length in seconds before the spread reset
    wep.Shots = 1 --How many shots come out of the gun when fired (not ammo consumption)
    wep.Damage = 0 --Damage
    wep.ReloadTimes[ base_reload ] = { 0, 0 } --Time acceleration, time in seconds when ammo is in the clip
    wep.ReloadTimes[ base_reloadempty ] = { 0, 0 } --Time acceleration, time in seconds with an empty magazine
end

if weapons.Get( "cw_kk_ins2_rpg" ) then
    local wep = weapons.GetStored( "cw_kk_ins2_rpg" )
	--wep.PrintName = ""
    wep.SpeedDec = 0 --Gun Weight
    wep.Slot = 3 --The weapon slot to be used
    --wep.FireModes = {"auto", "semi"} --Available firing types
    wep.Primary.ClipSize = 30 --Weapon clip size
    wep.Primary.DefaultClip	= 30 --Initial clip clip size
    --wep.Primary.Ammo = "" --The ammo type the weapon uses
    wep.FireDelay = 0 --Fire rate
    wep.Recoil = 0 --Recoil
    wep.HipSpread = 0 --Starting spread when firing from the hip
    wep.AimSpread = 0 --Starting Spread when firing while aiming
    wep.VelocitySensitivity = 0 --Spread increase when whipping your gun around
    wep.MaxSpreadInc = 0 --Maximum spread your weapon can achieve
    wep.SpreadPerShot = 0 --Spread increase per bullet
    wep.SpeadCooldown = wep.FireDelay + 0.05 --Length in seconds before the spread reset
    wep.Shots = 1 --How many shots come out of the gun when fired (not ammo consumption)
    wep.Damage = 0 --Damage
    wep.ReloadTimes[ base_reload ] = { 0, 0 } --Time acceleration, time in seconds when ammo is in the clip
    wep.ReloadTimes[ base_reloadempty ] = { 0, 0 } --Time acceleration, time in seconds with an empty magazine
end

if weapons.Get( "cw_kk_ins2_nade_m67" ) then
    local wep = weapons.GetStored( "cw_kk_ins2_nade_m67" )
	--wep.PrintName = ""
    wep.SpeedDec = 0 --Gun Weight
    wep.Slot = 3 --The weapon slot to be used
    --wep.FireModes = {"auto", "semi"} --Available firing types
    wep.Primary.ClipSize = 30 --Weapon clip size
    wep.Primary.DefaultClip	= 30 --Initial clip clip size
    --wep.Primary.Ammo = "" --The ammo type the weapon uses
    wep.FireDelay = 0 --Fire rate
    wep.Recoil = 0 --Recoil
    wep.HipSpread = 0 --Starting spread when firing from the hip
    wep.AimSpread = 0 --Starting Spread when firing while aiming
    wep.VelocitySensitivity = 0 --Spread increase when whipping your gun around
    wep.MaxSpreadInc = 0 --Maximum spread your weapon can achieve
    wep.SpreadPerShot = 0 --Spread increase per bullet
    wep.SpeadCooldown = wep.FireDelay + 0.05 --Length in seconds before the spread reset
    wep.Shots = 1 --How many shots come out of the gun when fired (not ammo consumption)
    wep.Damage = 0 --Damage
    wep.ReloadTimes[ base_reload ] = { 0, 0 } --Time acceleration, time in seconds when ammo is in the clip
    wep.ReloadTimes[ base_reloadempty ] = { 0, 0 } --Time acceleration, time in seconds with an empty magazine
end

if weapons.Get( "cw_kk_ins2_nade_c4" ) then
    local wep = weapons.GetStored( "cw_kk_ins2_nade_c4" )
	--wep.PrintName = ""
    wep.SpeedDec = 0 --Gun Weight
    wep.Slot = 3 --The weapon slot to be used
    --wep.FireModes = {"auto", "semi"} --Available firing types
    wep.Primary.ClipSize = 30 --Weapon clip size
    wep.Primary.DefaultClip	= 30 --Initial clip clip size
    --wep.Primary.Ammo = "" --The ammo type the weapon uses
    wep.FireDelay = 0 --Fire rate
    wep.Recoil = 0 --Recoil
    wep.HipSpread = 0 --Starting spread when firing from the hip
    wep.AimSpread = 0 --Starting Spread when firing while aiming
    wep.VelocitySensitivity = 0 --Spread increase when whipping your gun around
    wep.MaxSpreadInc = 0 --Maximum spread your weapon can achieve
    wep.SpreadPerShot = 0 --Spread increase per bullet
    wep.SpeadCooldown = wep.FireDelay + 0.05 --Length in seconds before the spread reset
    wep.Shots = 1 --How many shots come out of the gun when fired (not ammo consumption)
    wep.Damage = 0 --Damage
    wep.ReloadTimes[ base_reload ] = { 0, 0 } --Time acceleration, time in seconds when ammo is in the clip
    wep.ReloadTimes[ base_reloadempty ] = { 0, 0 } --Time acceleration, time in seconds with an empty magazine
end

if weapons.Get( "cw_kk_ins2_at4" ) then
    local wep = weapons.GetStored( "cw_kk_ins2_at4" )
	--wep.PrintName = ""
    wep.SpeedDec = 0 --Gun Weight
    wep.Slot = 3 --The weapon slot to be used
    --wep.FireModes = {"auto", "semi"} --Available firing types
    wep.Primary.ClipSize = 30 --Weapon clip size
    wep.Primary.DefaultClip	= 30 --Initial clip clip size
    --wep.Primary.Ammo = "" --The ammo type the weapon uses
    wep.FireDelay = 0 --Fire rate
    wep.Recoil = 0 --Recoil
    wep.HipSpread = 0 --Starting spread when firing from the hip
    wep.AimSpread = 0 --Starting Spread when firing while aiming
    wep.VelocitySensitivity = 0 --Spread increase when whipping your gun around
    wep.MaxSpreadInc = 0 --Maximum spread your weapon can achieve
    wep.SpreadPerShot = 0 --Spread increase per bullet
    wep.SpeadCooldown = wep.FireDelay + 0.05 --Length in seconds before the spread reset
    wep.Shots = 1 --How many shots come out of the gun when fired (not ammo consumption)
    wep.Damage = 0 --Damage
    wep.ReloadTimes[ base_reload ] = { 0, 0 } --Time acceleration, time in seconds when ammo is in the clip
    wep.ReloadTimes[ base_reloadempty ] = { 0, 0 } --Time acceleration, time in seconds with an empty magazine
end]]

end