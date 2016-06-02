hook.Add( "PlayerSpawn", "Brainstorm", function( ply )
timer.Simple( 0.1, function()
if CheckPerk( ply ) == "brainstorm" then
	ply.class = "Brainstorm"
    ply:SetWalkSpeed( 200 ) --default is 180
	ply:SetRunSpeed ( 290 ) --default is 300
    ply:SetJumpPower( 170 ) --default is 170
    
    --[[if (ply:Team() == 1) then
		ply:SetModel()
	elseif (ply:Team() == 2) then
		ply:SetModel()
	end]] --Unique playermodel goes here
    
    ply:SetMaxHealth( 85 )
    ply:SetHealth( 85 )
    end
end )
end )

hook.Add( "ScalePlayerDamage", "Brainstorm", function( ply, hitgroup, dmginfo )
	if CheckPerk( ply ) == "brainstorm" and hitgroup == HITGROUP_HEAD then
		dmginfo:ScaleDamage( 0 )
		ply.headshotsblocked = ply.headshotsblocked + 1
	end
end )

hook.Add( "EntityTakeDamage", "Brainstorm1", function( ply, dmginfo )
	if CheckPerk( ply ) == "brainstorm" then
		if ply == nil || dmginfo == nil || dmginfo:GetAttacker() == nil then
        	return
    	end
		if dmginfo:GetDamage() > 60 then
			dmginfo:ScaleDamage( 0.5 )
			ply.highdamageblocked = ply.highdamageblocked + 1
		end
	end
end )

RegisterPerk( "Brainstorm", "brainstorm", 1, "Grants slightly increased movespeed, immunity to headshots, and resistance to high-damage weaponry." )