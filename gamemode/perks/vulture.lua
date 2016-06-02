hook.Add( "PlayerSpawn", "Vulture", function( ply )
timer.Simple( 0.1, function()
if CheckPerk( ply ) == "vulture" then
	ply.class = "Vulture"
    ply:SetWalkSpeed( 190 ) --default is 180
	ply:SetRunSpeed ( 300 ) --default is 300
    ply:SetJumpPower( 180 ) --default is 170
    
    --[[if (ply:Team() == 1) then
		ply:SetModel()
	elseif (ply:Team() == 2) then
		ply:SetModel()
	end]] --Unique playermodel goes here
    
    ply:SetMaxHealth( 90 )
    ply:SetHealth( 90 )
    end
end )
end )

hook.Add( "EntityTakeDamage", "Vulture", function( ply, dmginfo )
	if CheckPerk( dmginfo:GetAttacker() ) == "vulture" then
		if ply == nil || dmginfo == nil || dmginfo:GetAttacker() == nil then
        	return
    	end
		if (ply:Health() - dmginfo:GetDamage()) < 11 then
			dmginfo:AddDamage(10)
			ply.executions = ply.executions + 1
		end
	end
end )

hook.Add( "PlayerDeath", "Vulture", function( ply, inf, att )
	if att and IsValid( att ) and att ~= NULL and load[ att ] ~= nil then
		if load[ att ].perk and load[ att ].perk ~= nil and load[ att ].perk == "vulture" then
			local ammo = ents.Create( "cw_ammo_kit_small" )
			if ( !IsValid( ammo ) ) then return end
			ammo:SetPos( ply:GetPos() )
			ammo.AmmoCapacity = 1
			ammo:Spawn()
			ammo:Activate()
			timer.Simple( 30, function()
				if IsValid( ammo ) then
					ammo:Remove()
				end
			end )
		end
	end
end )

RegisterPerk( "Vulture", "vulture", 1, "Tired of enemies living with low life? Execute enemies below 10 HP! Enemies will also drop ammo packs when killed." )

--[[hook.Add( "EntityTakeDamage", "Thornmail", function( ply, dmginfo )
	if dmginfo:GetAttacker():IsPlayer() and dmginfo:IsBulletDamage() and dmginfo:GetAttacker():Team() ~= ply:Team() then
		if CheckPerk( dmginfo:GetAttacker() ) == "thorns" then
			dmginfo:GetAttacker():TakeDamage( dmginfo:GetDamage() * 0.1 )
			dmginfo:ScaleDamage( 0.8 )
		end
	end
end )

RegisterPerk( "Thornmail", "thorns", 65, "Reflect 10% damage and absorb 10% damage." )]]