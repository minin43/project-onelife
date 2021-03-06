--//Default damage scaling: head = 1.5, chest & stomach = 1, arms = 0.9, legs = 0.85
--//Gmod move speeds: walkSpeed = 200, runSpeed = 400, jumpPower = 200
--//My move speeds: walkSpeed = 140, runSpeed = 260, jumpStrength = 170
GM.Armor = {
    {
        armorName = "Light",
        healthScaling = 85,
        damageScaling = {2.0, 1.2, 1, 0.9}, --Order: head, chest, arms, legs
        movementScaling = {140, 260, 170} --Order: walkSpeed, runSpeed, jumpPower
    },
    {
        armorName = "Standard",
        healthScaling = 100,
        damageScaling = {2.0, 1.1, 0.9, 0.85},
        movementScaling = {120, 240, 160}
    },
    {
        armorName = "Heavy",
        healthScaling = 100,
        damageScaling = {2.0, 1.0, 0.9, 0.85},
        movementScaling = {120, 230, 150}
    },
    {
        armorName = "Super Heavy",
        healthScaling = 115,
        damageScaling = {1.5, 0.9, 0.7, 0.65},
        movementScaling = {100, 220, 130}
    }
}

--// Refer to this for future descriptions: http://insurgency.wikia.com/wiki/Insurgency
GM.Roles = {
    [1] = {
        redTeamName = "Militant",
        blueTeamName = "Rifleman",
        soloTeamName = "Rifleman",
        roleDescription = "Standard armored fighter. Granted access to most weapon types and frag grenades.", --Currently don't have a use for this
        roleDescriptionExpanded = {
            {"Assault Rifles", "Full"},
            {"Sub-Machine Guns", "Partial"},
            {"Shotguns", "None"},
            {"Heavy Machine Guns", "None"},
            {"D.M.R.s", "Partial"},
            {"Snipers", "None"},
            {"Frag Grenades", "Full"},
            {"Flash Grenades", "None"},
            {"Smoke Grenades", "None"},
            {"Fire Grenades", "None"},
            {"Remote Explosives", "None"},
            {"Explosive Launchers", "None"}
        },
        armorRating = GM.Armor[2],
        roleIcon = Material("menu/role_icons/role_rifleman_icon_fixed.png", "smooth")
    },
    [2] = {
        redTeamName = "Scout",
        blueTeamName = "Reconnaissance",
        soloTeamName = "Recon",
        roleDescription = "Lightly armored but fast-moving fighter. Granted access to all short-range weaponry and flash grenades.",
        roleDescriptionExpanded = {
            {"Assault Rifles", "None"},
            {"Sub-Machine Guns", "Full"},
            {"Shotguns", "Full"},
            {"Heavy Machine Guns", "None"},
            {"D.M.R.s", "None"},
            {"Snipers", "None"},
            {"Frag Grenades", "None"},
            {"Flash Grenades", "Full"},
            {"Smoke Grenades", "None"},
            {"Fire Grenades", "None"},
            {"Remote Explosives", "None"},
            {"Explosive Launchers", "None"}
        },
        armorRating = GM.Armor[1],
        roleIcon = Material("menu/role_icons/role_recon_icon_fixed.png", "smooth")
    },
    [3] = {
        redTeamName = "Gunner",
        blueTeamName = "Support",
        soloTeamName = "Gunner",
        roleDescription = "Super heavily armored supportive fighter. Granted access to LMGs, some long-distance DMRs, and smoke and fire grenades.",
        roleDescriptionExpanded = {
            {"Assault Rifles", "Partial"},
            {"Sub-Machine Guns", "None"},
            {"Shotguns", "None"},
            {"Heavy Machine Guns", "Full"},
            {"D.M.R.s", "Partial"},
            {"Snipers", "None"},
            {"Frag Grenades", "None"},
            {"Flash Grenades", "None"},
            {"Smoke Grenades", "Full"},
            {"Fire Grenades", "Full"},
            {"Remote Explosives", "None"},
            {"Explosive Launchers", "None"}
        },
        armorRating = GM.Armor[4],
        roleIcon = Material("menu/role_icons/role_support_icon_fixed.png", "smooth")
    },
    [4] = {
        redTeamName = "Sharpshooter",
        blueTeamName = "Designated Marksman",
        soloTeamName = "Marksman",
        roleDescription = "Lightly armored supportive fighter. Granted access to all DMRs but no sniper rifle.",
        roleDescriptionExpanded = {
            {"Assault Rifles", "Partial"},
            {"Sub-Machine Guns", "None"},
            {"Shotguns", "None"},
            {"Heavy Machine Guns", "None"},
            {"D.M.R.s", "Full"},
            {"Snipers", "None"},
            {"Frag Grenades", "None"},
            {"Flash Grenades", "None"},
            {"Smoke Grenades", "Full"},
            {"Fire Grenades", "None"},
            {"Remote Explosives", "None"},
            {"Explosive Launchers", "None"}
        },
        armorRating = GM.Armor[1],
        roleIcon = Material("menu/role_icons/role_marksman_icon_fixed.png", "smooth")
    },
    [5] = {
        redTeamName = "Striker",
        blueTeamName = "Demolitions",
        soloTeamName = "Demolitions",
        roleDescription = "Super heavily armored fighter. Granted access to all launchers and Assault Rifles, but no grenades.",
        roleDescriptionExpanded = {
            {"Assault Rifles", "Full"},
            {"Sub-Machine Guns", "None"},
            {"Shotguns", "None"},
            {"Heavy Machine Guns", "None"},
            {"D.M.R.s", "None"},
            {"Snipers", "None"},
            {"Frag Grenades", "None"},
            {"Flash Grenades", "None"},
            {"Smoke Grenades", "None"},
            {"Fire Grenades", "None"},
            {"Remote Explosives", "None"},
            {"Explosive Launchers", "Full"}
        },
        armorRating = GM.Armor[4],
        roleIcon = Material("menu/role_icons/role_demolitions_icon_fixed.png", "smooth")
    },
    [6] = {
        redTeamName = "Sniper",
        blueTeamName = "Sniper",
        soloTeamName = "Sniper",
        roleDescription = "Lightly armored supportive fighter. Granted access to all sniper rifles but no grenades.",
        roleDescriptionExpanded = {
            {"Assault Rifles", "None"},
            {"Sub-Machine Guns", "None"},
            {"Shotguns", "None"},
            {"Heavy Machine Guns", "None"},
            {"D.M.R.s", "None"},
            {"Snipers", "Full"},
            {"Frag Grenades", "None"},
            {"Flash Grenades", "None"},
            {"Smoke Grenades", "None"},
            {"Fire Grenades", "None"},
            {"Remote Explosives", "None"},
            {"Explosive Launchers", "None"}
        },
        armorRating = GM.Armor[1],
        roleIcon = Material("menu/role_icons/role_sniper_icon_fixed.png", "smooth")
    },
    [7] = {
        redTeamName = "Sapper",
        blueTeamName = "Breacher",
        soloTeamName = "Breacher",
        roleDescription = "Heavily armored supportive fighter. Granted access to all throwable and remotely detonated explosives.",
        roleDescriptionExpanded = {
            {"Assault Rifles", "Partial"},
            {"Sub-Machine Guns", "Partial"},
            {"Shotguns", "Partial"},
            {"Heavy Machine Guns", "None"},
            {"D.M.R.s", "None"},
            {"Snipers", "None"},
            {"Frag Grenades", "Full"},
            {"Flash Grenades", "Full"},
            {"Smoke Grenades", "Full"},
            {"Fire Grenades", "Full"},
            {"Remote Explosives", "Full"},
            {"Explosive Launchers", "None"}
        },
        armorRating = GM.Armor[3],
        roleIcon = Material("menu/role_icons/role_breacher_icon_fixed.png", "smooth")
    },
    [8] = {
        redTeamName = "Expert",
        blueTeamName = "Specialist",
        soloTeamName = "Specialist",
        roleDescription = "Special armored fighter. Granted access to extra, unique weapons for proving themselves in combat.",
        roleDescriptionExpanded = {
            {"Assault Rifles", "Full"},
            {"Sub-Machine Guns", "Full"},
            {"Shotguns", "Full"},
            {"Heavy Machine Guns", "Full"},
            {"D.M.R.s", "Full"},
            {"Snipers", "None"},
            {"Frag Grenades", "Full"},
            {"Flash Grenades", "Full"},
            {"Smoke Grenades", "Full"},
            {"Fire Grenades", "Full"},
            {"Remote Explosives", "None"},
            {"Explosive Launchers", "None"}
        },
        armorRating = GM.Armor[2],
        roleIcon = Material("menu/role_icons/role_specialist_icon_fixed.png", "smooth")
    }
}

for k, v in pairs(GM.Roles) do
    for k2, v2 in pairs(v.roleDescriptionExpanded) do
        if v2[2] == "Full" then
            v2[3] = Color(0, 160, 0)
        elseif v2[2] == "Partial" then
            v2[3] = Color(238, 210, 2)
        elseif v2[2] == "None" then
            v2[3] = Color(170, 0, 0)
        end
    end
end

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
	if ply.role != 0 and ply.armorRating and !dmginfo:IsFallDamage() and IsValid( ply ) then
		if hitgroup == HITGROUP_HEAD then
			dmginfo:ScaleDamage(ply.armorRating.damageScaling[1])
	    elseif hitgroup == HITGROUP_CHEST or hitgroup == HITGROUP_STOMACH then
			dmginfo:ScaleDamage(ply.armorRating.damageScaling[2])
	    elseif hitgroup == HITGROUP_LEFTARM or hitgroup == HITGROUP_RIGHTARM then
			dmginfo:ScaleDamage(ply.armorRating.damageScaling[3])
	    elseif hitgroup == HITGROUP_LEFTLEG or hitgroup == HITGROUP_RIGHTLEG then
			dmginfo:ScaleDamage(ply.armorRating.damageScaling[4])
	    else
			dmginfo:ScaleDamage( 1 )
	    end
	end
end )

hook.Add( "PlayerSpawn", "SetRoleModifiers", function(ply)
    ply.role = ply.role or 1
    GAMEMODE:SetRole(ply, ply.role)
end)

function GM:SetRole(ply, role) --ply is the player ent, role is a num
    timer.Simple( 0, function() --timer.Simple with 0 time runs on next server tick
        if ply:Team() != 1 and ply:Team() != 2 and ply:Team() != 3 then return end

        ply:SetModel( self.playerModelByRole[team.GetName(ply:Team())][math.random(#self.playerModelByRole[team.GetName(ply:Team())])] )

        ply.armorRating = self.Roles[role].armorRating

        if ply.armorRating.movementScaling then
            ply:SetNWString( "ArmorType", tostring(ply.armorRating.armorName) )
            ply:SetWalkSpeed( ply.armorRating.movementScaling[1] )
            ply:SetRunSpeed( ply.armorRating.movementScaling[2] )
            ply:SetJumpPower( ply.armorRating.movementScaling[3] )
        end

        if ply.armorRating.healthScaling then
            ply:SetMaxHealth( ply.armorRating.healthScaling )
            ply:SetHealth( ply.armorRating.healthScaling )
        end
    end )
end

end