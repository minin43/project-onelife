print( "sh_rolehandler initialization..." )
roleplayermodels = {
    [ "Task Force 141" ] = { "Models/mw2guy/diver/diver_01.mdl", "Models/mw2guy/diver/diver_02.mdl", "Models/mw2guy/BZ/bzgb01.mdl", "Models/mw2guy/BZ/bzghost.mdl", "Models/mw2guy/BZ/bzsoap.mdl", "Models/mw2guy/BZ/tfbzw01.mdl", "Models/mw2guy/BZ/tfbzw02.mdl" },
    [ "US Army Rangers" ] = { "Models/CODMW2/CODMW2.mdl", "Models/CODMW2/CODMW2H.mdl", "Models/CODMW2/CODMW2HE.mdl", "Models/CODMW2/CODMW2HEXE.mdl", "Models/CODMW2/CODMW2M.mdl" },
    [ "Navy Seals" ] = { "Models/CODMW2/T_CODM.mdl", "Models/CODMW2/T_CODMW2.mdl", "Models/CODMW2/T_CODMW2H.mdl", "Models/mw2guy/BZ/tfbz01.mdl", "Models/mw2guy/BZ/tfbz02.mdl", "Models/mw2guy/BZ/tfbz03.mdl" },
    [ "Spetsnaz" ] = { "Models/mw2guy/RUS/gassoldier.mdl", "Models/mw2guy/RUS/soldier_a.mdl", "Models/mw2guy/RUS/soldier_c.mdl", "Models/mw2guy/RUS/soldier_d.mdl", "Models/mw2guy/RUS/soldier_e.mdl", "Models/mw2guy/RUS/soldier_f.mdl",  },
    [ "Militia" ] = { "Models/COD players/opfor1.mdl", "Models/COD players/opfor2.mdl", "Models/COD players/opfor3.mdl", "Models/COD players/opfor4.mdl", "Models/COD players/opfor4.mdl", "Models/COD players/opfor6.mdl" },
    [ "OpFor" ] = { "Models/COD players/opfor1.mdl", "Models/COD players/opfor2.mdl", "Models/COD players/opfor3.mdl", "Models/COD players/opfor4.mdl", "Models/COD players/opfor4.mdl", "Models/COD players/opfor6.mdl" }
}
roleplayermodels[ "Solo" ] = {  }

damagescaling = {
--//[ ArmorType type ] = { head, chest/stomach, arms, legs }
--//Default scaling: head = 1.5, chest & stomach = 1, arms = 0.9, legs = 0.85
    [ "light" ] = { 1.8, 1.1, 1, 0.9 },
    [ "standard" ] = { 1.5, 1, 0.9, 0.85 },
    [ "heavy" ] = { 1.3, 0.9, 0.9, 0.85 },
    [ "superheavy" ] = { 1, 0.8, 0.7, 0.65 }
}

healthscaling = {
--//[ ArmorType type ] = { maxhealth/starting health }
    [ "light" ] = 90,
    [ "standard" ] = 100,
    [ "heavy" ] = 100,
    [ "superheavy" ] = 110
}

--//We don't need no special key for these because we know roles are sorted numerically
roletoarmor = { "standard", "light", "superheavy", "light", "superheavy", "light", "heavy", "standard" }

armorspeed = {
--//[ ArmorType type ] = { walkspeed = 140, runspeed = 260, jumpstrength = 170 }
    [ "light" ] = { 140, 280, 190 },
    [ "standard" ] = { 140, 260, 170 },
    [ "heavy" ] = { 140, 245, 170 },
    [ "superheavy" ] = { 120, 235, 150 }
}

if SERVER then

hook.Add( "ScalePlayerDamage", "DamageReductions", function( ply, hitgroup, dmginfo )
	if CheckRole( ply ) != 0 and ply.ArmorType and !dmginfo:IsFallDamage() and IsValid( ply ) then
		if hitgroup == HITGROUP_HEAD then
			dmginfo:ScaleDamage( damagescaling[ ply.ArmorType ][ 1 ] )
	    elseif hitgroup == HITGROUP_CHEST then
			dmginfo:ScaleDamage( damagescaling[ ply.ArmorType ][ 2 ] )
	    elseif hitgroup == HITGROUP_STOMACH then
			dmginfo:ScaleDamage( damagescaling[ ply.ArmorType ][ 2 ] )
	    elseif hitgroup == HITGROUP_LEFTARM then
			dmginfo:ScaleDamage( damagescaling[ ply.ArmorType ][ 3 ] )
	    elseif hitgroup == HITGROUP_RIGHTARM then
			dmginfo:ScaleDamage( damagescaling[ ply.ArmorType ][ 3 ] )
	    elseif hitgroup == HITGROUP_LEFTLEG then
			dmginfo:ScaleDamage( damagescaling[ ply.ArmorType ][ 4 ] )
	    elseif hitgroup == HITGROUP_RIGHTLEG then
			dmginfo:ScaleDamage( damagescaling[ ply.ArmorType ][ 4 ] )
	    else
			dmginfo:ScaleDamage( 1 )
	    end
	end
end )

hook.Add( "PlayerSpawn", "SetRoleModifiers", SetRole )

function SetRole( ply )
    timer.Simple( 0.1, function()
        print( "SetRole called for ", ply:Nick() )

        ply:SetModel( roleplayermodels[ team.GetName( ply:Team() ) ][ math.random( #roleplayermodels[ team.GetName( ply:Team() ) ] ) ] )
        print( "Setting ", ply:Nick(), "'s model to ", ply:GetModel() )

        local myrole = CheckRole( ply ) --this returns a number, not a string
        if !myrole or myrole == 0 then return end

        --ply.role = roles[ myrole ][ ply:Team() ]

        if roletoarmor[ myrole ] then
            ply.ArmorType = roletoarmor[ myrole ]
            ply:SetNWString( "ArmorType", ply.ArmorType )
            ply:SetWalkSpeed( armorspeed[ ply.ArmorType ][ 1 ] )
            ply:SetRunSpeed( armorspeed[ ply.ArmorType ][ 2 ] )
            ply:SetJumpPower( armorspeed[ ply.ArmorType ][ 3 ] )
        end

        if healthscaling[ ply.ArmorType ] then
            ply:SetMaxHealth( healthscaling[ ply.ArmorType ] )
            ply:SetHealth( healthscaling[ ply.ArmorType ] )
        end
        
    end )
end

end