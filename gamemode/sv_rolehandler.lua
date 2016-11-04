print( "sv_rolehandler initialization..." )
local roleplayermodels = {
    [ 1 ] = {
        [ "Militant" ] = "",
        [ "Scout" ] = "",
        [ "Gunner" ] = "",
        [ "Sharpshooter" ] = "",
        [ "Striker" ] = "",
        [ "Sniper" ] = "",
        [ "Sapper" ] = "",
        [ "Expert" ] = ""
    },
    [ 2 ] = {
        [ "Rifleman" ] = "",
        [ "Reconnaissance" ] = "",
        [ "Support" ] = "",
        [ "Designated Marksman" ] = "",
        [ "Demolitions" ] = "",
        [ "Sniper" ] = "",
        [ "Breacher" ] = "",
        [ "Specialist" ] = ""
    },
    [ 3 ] = {
        [ "Rifleman" ] = "",
        [ "Recon" ] = "",
        [ "Gunner" ] = "",
        [ "Marksman" ] = "",
        [ "Demolitions" ] = "",
        [ "Sniper" ] = "",
        [ "Breacher" ] = "",
        [ "Specialist" ] = ""
    }
}

function SetArmor( ply, type )
    local armorspeed = {
    --//[ armor type ] = { walkspeed = 140, runspeed = 260, jumpstrength = 170 }
        [ "light" ] = { 140, 280, 190 },
        [ "standard" ] = { 140, 260, 170 },
        [ "heavy" ] = { 140, 245, 170 },
        [ "superheavy" ] = { 120, 235, 150 }
    }
    if ply and armorspeed[ type ] then
        ply:SetWalkSpeed( armorspeed[ type ][ 1 ] )
        ply:SetRunSpeed( armorspeed[ type ][ 2 ] )
        ply:SetJumpPower( armorspeed[ type ][ 3 ] )
        ply.Armor = type
    end
end

hook.Add( "ScalePlayerDamage", "DamageReductions", function( ply, hitgroup, dmginfo )
	if CheckRole( ply ) != 0 and ply.Armor and !dmginfo:IsFallDamage() and IsValid( ply ) then
        local damagescaling = {
        --//[ armor type ] = { head, chest/stomach, arms, legs }
        --//Default scaling: head = 1.5, chest & stomach = 1, arms = 0.9, legs = 0.85
            [ "light" ] = { 1.8, 1.1, 1, 0.9 },
            [ "standard" ] = { 1.5, 1, 0.9, 0.85 },
            [ "heavy" ] = { 1.3, 0.9, 0.9, 0.85 },
            [ "superheavy" ] = { 1, 0.8, 0.7, 0.65 }
        }
		if hitgroup == HITGROUP_HEAD then
			dmginfo:ScaleDamage( damagescaling[ ply.Armor ][ 1 ] )
	    elseif hitgroup == HITGROUP_CHEST then
			dmginfo:ScaleDamage( damagescaling[ ply.Armor ][ 2 ] )
	    elseif hitgroup == HITGROUP_STOMACH then
			dmginfo:ScaleDamage( damagescaling[ ply.Armor ][ 2 ] )
	    elseif hitgroup == HITGROUP_LEFTARM then
			dmginfo:ScaleDamage( damagescaling[ ply.Armor ][ 3 ] )
	    elseif hitgroup == HITGROUP_RIGHTARM then
			dmginfo:ScaleDamage( damagescaling[ ply.Armor ][ 3 ] )
	    elseif hitgroup == HITGROUP_LEFTLEG then
			dmginfo:ScaleDamage( damagescaling[ ply.Armor ][ 4 ] )
	    elseif hitgroup == HITGROUP_RIGHTLEG then
			dmginfo:ScaleDamage( damagescaling[ ply.Armor ][ 4 ] )
	    else
			dmginfo:ScaleDamage( 1 )
	    end
	end
end )

hook.Add( "PlayerSpawn", "SetRoleModifiers", function( ply )
    timer.Simple( 0.1, function()
        local myrole = CheckRole( ply )
        if !myrole or myrole == 0 then return end
        local healthscaling = {
        --//[ armor type ] = { maxhealth/starting health }
            [ "light" ] = 90,
            [ "standard" ] = 100,
            [ "heavy" ] = 100,
            [ "superheavy" ] = 110
        }
        local roletoarmor = { "standard", "light", "superheavy", "light", "superheavy", "light", "heavy", "standard" }
        local armorspeed = {
        --//[ armor type ] = { walkspeed = 140, runspeed = 260, jumpstrength = 170 }
            [ "light" ] = { 140, 280, 190 },
            [ "standard" ] = { 140, 260, 170 },
            [ "heavy" ] = { 140, 245, 170 },
            [ "superheavy" ] = { 120, 235, 150 }
        }

        ply.role = roles[ myrole ][ ply:Team() ]

        if roletoarmor[ myrole ] then
            ply.Armor = roletoarmor[ myrole ]
            ply:SetWalkSpeed( armorspeed[ ply.Armor ][ 1 ] )
            ply:SetRunSpeed( armorspeed[ ply.Armor ][ 2 ] )
            ply:SetJumpPower( armorspeed[ ply.Armor ][ 3 ] )
        end

        if healthscaling[ ply.Armor ] then
            ply:SetMaxHealth( healthscaling[ ply.Armor ] )
            ply:SetHealth( healthscaling[ ply.Armor ] )
        end
        
        --ply:SetModel( roleplayermodels[ ply:Team() ][ ply.role ] )
    end )
end )