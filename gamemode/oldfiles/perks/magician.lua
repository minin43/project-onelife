hook.Add( "PlayerSpawn", "Magician", function( ply )
timer.Simple( 0.1, function()
if CheckPerk( ply ) == "magician" then
	ply.class = "Magician"
    ply:SetWalkSpeed( 190 ) --default is 180
	ply:SetRunSpeed ( 310 ) --default is 300
    ply:SetJumpPower( 170 ) --default is 170
	if timer.Exists( "magician_" .. ply:SteamID()) and timer.Pause( "magician_" .. ply:SteamID()) then
		timer.UnPause( "magician_" .. ply:SteamID() )
	end
    
    --[[if (ply:Team() == 1) then
		ply:SetModel()
	elseif (ply:Team() == 2) then
		ply:SetModel()
	end]] --Unique playermodel goes here
    
    ply:SetMaxHealth( 100 )
    ply:SetHealth( 100 )
	
	if !CheckPerk( ply ) == "magician" and timer.Exists( "magician_" .. ply:SteamID() ) then
		timer.Pause( "magician_" .. ply:SteamID() )
	end
	end
end )
end )

util.AddNetworkString( "SetMagician" )

hook.Add( "KeyPress", "Magician", function( ply, key )
	if ply.BULLSHIT == nil then
		ply.tbl = {}
		ply.BULLSHIT = true
	end
	
	if CheckPerk( ply ) == "magician" and key == IN_RELOAD and ply != nil then
		for k, v in pairs(ply:GetWeapons()) do
			if v:GetBase() == "cw_base" then
				if ply.tbl[k] == nil then
					v["ReloadSpeed"] = ( v["ReloadSpeed"] * 1.5 )
					ply.tbl[k] = v
				net.Start( "SetMagician" )
					net.WriteBool( true )
					net.WriteEntity( v )
					net.WriteInt( k, 32 )
				net.Send( ply )
				end
			end
		end
	end
	
	if CheckPerk( ply ) != "magician" then
		for k, v in pairs(ply:GetWeapons()) do
			if ply.tbl[k] == v then
				net.Start( "SetMagician" )
					net.WriteBool( false )
					net.WriteEntity( v )
					net.WriteInt( k, 32 )
				net.Send( ply )
			end
		end
	end
end )

hook.Add( "ScalePlayerDamage", "Magician", function( ply, hitgroup, dmginfo )
	if CheckPerk( ply ) == "magician" then
		if hitgroup == HITGROUP_CHEST then
			dmginfo:ScaleDamage( 1.1 ) --default is 1.0
		elseif hitgroup == HITGROUP_STOMACH then
			dmginfo:ScaleDamage( 1.1 ) --default is 1.0
        elseif hitgroup == HITGROUP_LEFTARM then
			dmginfo:ScaleDamage( 1.0 ) --default is 0.9
        elseif hitgroup == HITGROUP_RIGHTARM then
			dmginfo:ScaleDamage( 1.0 ) --default is 0.9
        elseif hitgroup == HITGROUP_LEFTLEG then
			dmginfo:ScaleDamage( 0.9 ) --default is 0.8
        elseif hitgroup == HITGROUP_RIGHTLEG then
			dmginfo:ScaleDamage( 0.9 ) --default is 0.8
        elseif hitgroup == HITGROUP_HEAD then
			dmginfo:ScaleDamage( 1.6 ) --default is 1.5
		end
	end
end )

hook.Add( "EntityTakeDamage", "Magician", function( ply, dmginfo )
	ply.lifesaveable = false
	local vpoint = ply:GetPos()
	local effectdata = EffectData()
	--print( "Initial testing for ", ply )
	if CheckPerk( ply ) == "magician" then
		if ply == nil || dmginfo == nil || dmginfo:GetAttacker() == nil || dmginfo:GetAttacker() == "worldspawn" then
        	return
    	end
		--print( ply, " has Magician as their perk")
		if (ply:Health() - dmginfo:GetDamage()) < 1 then
		--print( ply, " is going to die!")
		if not timer.Exists( "magician_" .. ply:SteamID() ) then
			timer.Create( "magician_" .. ply:SteamID(), 300, 1, function()
				ply.lifesaveable = true
			end )
			--print( "The timer for", ply, " does not exist. Creating and saving life.")
			ply:SetHealth( 100 )
			dmginfo:SetDamage( 0 )
			effectdata:SetOrigin( vpoint )
			util.Effect( "Explosion", effectdata, true, true )
		elseif ply.lifesaveable == true then
			--print("Your free revive is available", ply, ", using now!")
			ply:SetHealth( 100 )
			dmginfo:SetDamage( 0 )
			effectdata:SetOrigin( vpoint )
			util.Effect( "Explosion", effectdata, true, true )
			ply.lifesaveable = false
			timer.Adjust( "magician_" .. ply:SteamID(), 300, 1, function()
				ply.lifesaveable = true
			end )
		end
		--print( "The timer for ", ply, " exists and has ", timer.TimeLeft( "magician_" .. ply:SteamID() ), " seconds left.")
		end
	end
end )

RegisterPerk( "Magician", "magician", 1, "Increased reload speed and increased damage received, but receive a free revive every 5 minutes the class is used." )