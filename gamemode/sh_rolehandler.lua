--// Refer to this for future descriptions: http://insurgency.wikia.com/wiki/Insurgency
GM.Roles = {
    {
        redTeamName = "Militant",
        blueTeamName = "Rifleman",
        soloTeamName = "Rifleman",
        roleDescription = "Standard armored fighter. Granted access to most weapon types and frag grenades.",
        armorRating = self.Armor.standard
    },
    {
        redTeamName = "Scout",
        blueTeamName = "Reconnaissance",
        soloTeamName = "Recon",
        roleDescription = "Lightly armored but fast-moving fighter. Granted access to all short-range weaponry and flash grenades.",
        armorRating = self.Armor.light
    },
    {
        redTeamName = "Gunner",
        blueTeamName = "Support",
        soloTeamName = "Gunner",
        roleDescription = "Super heavily armored supportive fighter. Granted access to LMGs, some long-distance DMRs, and smoke grenades.",
        armorRating = self.Armor.superheavy
    },
    {
        redTeamName = "Sharpshooter",
        blueTeamName = "Designated Marksman",
        soloTeamName = "Marksman",
        roleDescription = "Lightly armored supportive fighter. Granted access to all DMRs but no sniper rifle.",
        armorRating = self.Armor.light
    },
    {
        redTeamName = "Striker",
        blueTeamName = "Demolitions",
        soloTeamName = "Demolitions",
        roleDescription = "Super heavily armored fighter. Granted access to all launchers and Assault Rifles, but no grenades.",
        armorRating = self.Armor.superheavy
    },
    {
        redTeamName = "Sniper",
        blueTeamName = "Sniper",
        soloTeamName = "Sniper",
        roleDescription = "Lightly armored supportive fighter. Granted access to all sniper rifles but no grenades.",
        armorRating = self.Armor.light
    },
    {
        redTeamName = "Sapper",
        blueTeamName = "Breacher",
        soloTeamName = "Breacher",
        roleDescription = "Heavily armored supportive fighter. Granted access to all throwable and remotely detonated explosives.",
        armorRating = self.Armor.heavy
    },
    {
        redTeamName = "Expert",
        blueTeamName = "Specialist",
        soloTeamName = "Specialist",
        roleDescription = "Special armored fighter. Granted access to extra, unique weapons for proving themselves in combat.",
        armorRating = self.Armor.standard
    },
}

--//Default damage scaling: head = 1.5, chest & stomach = 1, arms = 0.9, legs = 0.85
--//Base move speeds: walkSpeed = 140, runSpeed = 260, jumpStrength = 170
GM.Armor = {
    light = {
        healthScaling = 85,
        damageScaling = {
            head = 2.0,
            torso = 1.2,
            arms = 1,
            legs = 0.9
        },
        movementScaling = {
            walkSpeed = 140,
            runSpeed = 260,
            jumpStrength = 170
        },
    },
    standard = {
        healthScaling = 100,
        damageScaling = {
            head = 2.0,
            torso = 1.1,
            arms = 0.9,
            legs = 0.85
        },
        movementScaling = {
            walkSpeed = 120,
            runSpeed = 240,
            jumpStrength = 160
        },
    },
    heavy = {
        healthScaling = 100,
        damageScaling = {
            head = 2.0,
            torso = 1.0,
            arms = 0.9,
            legs = 0.85
        },
        movementScaling = {
            walkSpeed = 120,
            runSpeed = 230,
            jumpStrength = 150
        },
    },
    superheavy = {
        healthScaling = 115
        damageScaling = {
            head = 1.5,
            torso = 0.9,
            arms = 0.7,
            legs = 0.65
        }
        movementScaling = { 
            walkSpeed = 100,
            runSpeed = 220,
            jumpStrength = 130
        }
    }
}

GM.playerModelByRole = {
    ["Task Force 141"] = {
        "Models/mw2guy/diver/diver_01.mdl", 
        "Models/mw2guy/diver/diver_02.mdl", 
        "Models/mw2guy/BZ/bzgb01.mdl", 
        "Models/mw2guy/BZ/bzghost.mdl", 
        "Models/mw2guy/BZ/bzsoap.mdl", 
        "Models/mw2guy/BZ/tfbzw01.mdl", 
        "Models/mw2guy/BZ/tfbzw02.mdl" },
    ["US Army Rangers"] = {
        "Models/CODMW2/CODMW2.mdl", 
        "Models/CODMW2/CODMW2H.mdl", 
        "Models/CODMW2/CODMW2HE.mdl", 
        "Models/CODMW2/CODMW2HEXE.mdl", 
        "Models/CODMW2/CODMW2M.mdl" },
    ["Navy Seals"] = {
        "Models/CODMW2/T_CODM.mdl", 
        "Models/CODMW2/T_CODMW2.mdl", 
        "Models/CODMW2/T_CODMW2H.mdl", 
        "Models/mw2guy/BZ/tfbz01.mdl", 
        "Models/mw2guy/BZ/tfbz02.mdl", 
        "Models/mw2guy/BZ/tfbz03.mdl" },
    ["Spetsnaz"] = {
        "Models/mw2guy/RUS/gassoldier.mdl", 
        "Models/mw2guy/RUS/soldier_a.mdl", 
        "Models/mw2guy/RUS/soldier_c.mdl", 
        "Models/mw2guy/RUS/soldier_d.mdl", 
        "Models/mw2guy/RUS/soldier_e.mdl", 
        "Models/mw2guy/RUS/soldier_f.mdl",  },
    ["Militia"] = {
        "Models/COD players/opfor1.mdl", 
        "Models/COD players/opfor2.mdl", 
        "Models/COD players/opfor3.mdl", 
        "Models/COD players/opfor4.mdl", 
        "Models/COD players/opfor4.mdl", 
        "Models/COD players/opfor6.mdl" },
    ["OpFor"] = {
        "Models/COD players/opfor1.mdl", 
        "Models/COD players/opfor2.mdl", 
        "Models/COD players/opfor3.mdl", 
        "Models/COD players/opfor4.mdl", 
        "Models/COD players/opfor4.mdl", 
        "Models/COD players/opfor6.mdl" }
}
GM.playerModelByRole[ "Solo" ] = {  }

if SERVER then

hook.Add( "ScalePlayerDamage", "DamageScaling", function( ply, hitgroup, dmginfo )
	if CheckRole( ply ) != 0 and ply.armorRating and !dmginfo:IsFallDamage() and IsValid( ply ) then
		if hitgroup == HITGROUP_HEAD then
			dmginfo:ScaleDamage(ply.armorRating.damageScaling.head)
	    elseif hitgroup == HITGROUP_CHEST or hitgroup == HITGROUP_STOMACH then
			dmginfo:ScaleDamage(ply.armorRating.damageScaling.torso)
	    elseif hitgroup == HITGROUP_LEFTARM or hitgroup == HITGROUP_RIGHTARM then
			dmginfo:ScaleDamage(ply.armorRating.damageScaling.arms)
	    elseif hitgroup == HITGROUP_LEFTLEG or hitgroup == HITGROUP_RIGHTLEG then
			dmginfo:ScaleDamage(ply.armorRating.damageScaling.legs)
	    else
			dmginfo:ScaleDamage( 1 )
	    end
	end
end )

hook.Add( "PlayerSpawn", "SetRoleModifiers", SetRole )

function GM:SetRole( ply, role )
    timer.Simple( 0, function() --timer.Simple with 0 time runs on next server tick
        if ply:Team() != 1 and ply:Team() != 2 and ply:Team() != 3 then return end

        ply:SetModel( self.playerModelByRoleplayerModelByRole[team.GetName(ply:Team())][math.random(#playerModelByRole[team.GetName(ply:Team())])] )

        ply.armorRating = self.Role[role][armorRating]

        if ply.armorRating.movementScaling then
            ply:SetNWString( "ArmorType", tostring(ply.armorRating) )
            ply:SetwalkSpeed( ply.armorRating.movementScaling.walkSpeed )
            ply:SetrunSpeed( ply.armorRating.movementScaling.runSpeed )
            ply:SetJumpPower( ply.armorRating.movementScaling.jumpStrength )
        end

        if ply.armorRating.healthScaling then
            ply:SetMaxHealth( ply.armorRating.healthScaling )
            ply:SetHealth( ply.armorRating.healthScaling )
        end
    end )
end

end