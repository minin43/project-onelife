hook.Add( "PlayerSpawn", "Murk", function( ply )
timer.Simple( 0.1, function()
if CheckPerk( ply ) == "murk" then
	ply.class = "Murk"
    ply:SetWalkSpeed( 140 ) --default is 180
	ply:SetRunSpeed ( 250 ) --default is 300
    ply:SetJumpPower( 125 ) --default is 170
    
    --[[if (ply:Team() == 1) then
		ply:SetModel()
	elseif (ply:Team() == 2) then
		ply:SetModel()
	end]] --Unique playermodel goes here
    
    ply:SetMaxHealth( 125 )
    ply:SetHealth( 125 )
    end
end )
end )

hook.Add( "ScalePlayerDamage", "Murk", function( ply, hitgroup, dmginfo )
	if CheckPerk( ply ) == "murk" then
		if hitgroup == HITGROUP_CHEST then
			dmginfo:ScaleDamage( 0.6 ) --default is 1.0
		elseif hitgroup == HITGROUP_STOMACH then
			dmginfo:ScaleDamage( 0.4 ) --default is 1.0
        elseif hitgroup == HITGROUP_LEFTARM then
			dmginfo:ScaleDamage( 0.5 ) --default is 0.9
        elseif hitgroup == HITGROUP_RIGHTARM then
			dmginfo:ScaleDamage( 0.5 ) --default is 0.9
        elseif hitgroup == HITGROUP_LEFTLEG then
			dmginfo:ScaleDamage( 0.5 ) --default is 0.8
        elseif hitgroup == HITGROUP_RIGHTLEG then
			dmginfo:ScaleDamage( 0.5 ) --default is 0.8
        elseif hitgroup == HITGROUP_HEAD then
			dmginfo:ScaleDamage( 1.8 ) --default is 1.5
			ply.headshotstaken = ply.headshotstaken + 1
		end
	end
end )

hook.Add( "EntityTakeDamage", "Murk", function( ply, dmginfo )
	if ply:IsPlayer() and dmginfo:IsExplosionDamage() and CheckPerk( ply ) == "murk" then
		dmginfo:ScaleDamage( 0.1 )
	end
end )

RegisterPerk( "Murk", "murk", 1, "Have increased health and take significantly reduced damage from guns and explosives, but move much slower and be extra vulnerable to headshots." )