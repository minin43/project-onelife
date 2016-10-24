ULib.tsay(nil, "perk reloaded")
hook.Add( "EntityTakeDamage", "Pyro", function( ply, dmginfo )
    if !ply:IsPlayer() then return end
    if ply == nil || dmginfo == nil || dmginfo:GetAttacker() == nil then -- Fixed by cobalt 1/30/16
        return
    end 
	if dmginfo:GetAttacker():IsPlayer() and dmginfo:IsBulletDamage() and dmginfo:GetAttacker():Team() ~= ply:Team() then
		if CheckPerk( dmginfo:GetAttacker() ) == "pyro" then
			local num = math.random( 1, 1000 )
			
			if num < 100 and ply:IsOnFire() then
				local explosion = ents.Create( "env_explosion" )
                ply.pyroOnFire = nil;
				if IsValid( explosion ) then
					explosion:SetPos( ply:GetPos() )
					explosion:SetOwner( dmginfo:GetAttacker() )
					explosion:Spawn()
					explosion:SetKeyValue( "iMagnitude", ply:Health() * 2 )
					explosion:Fire( "Explode", 0, 0 )
				end

				if not ply:Alive() then
					ply:Kill()
				end
			elseif num < 200 then
                ULib.tsay(nil, tostring(dmginfo:GetAttacker()))
                ply.pyroOnFire = dmginfo:GetAttacker()
				ply:Ignite( 5 )
                timer.Simple(5, function()
                    ply.pyroOnFire = nil
                end)
			end

		end
	end
end )

hook.Add("EntityTakeDamage", "getFireDeaths", function(victim, dmginfo)
    if !IsValid(victim) && victim:IsPlayer() then
        return
    end
    if dmginfo:GetDamageType() == DMG_FIRE && dmginfo:GetDamage() >= victim:Health() then
        hook.Run("PlayerFireDamageDeath", victim)
    end
end )

hook.Add("PlayerFireDamageDeath", "fireDeath", function(victim)
    ULib.tsay(nil, "PlayerFireDamageDeath called")
    if IsValid(victim.pyroOnFire) then
        ULib.tsay(nil, "found player on fire")
        local killer = victim.pyroOnFire -- Get the stored player
        ULib.tsay(nil, "killer = " .. tostring(killer))
        if (killer == nil || !IsValid(killer)) then 
            ULib.tsay(nil, "Killer is not valid")
            return 
        end
        killer:AddFrags(1);
        local col = Color(255, 0, 83)
        AddNotice(killer, victim:Name(), SCORECOUNTS.KILL, NOTICETYPES.KILL, col)
    end
end)

--RegisterPerk( "Pyromancer", "pyro", 32, "Small chance to ignite enemies you shoot at. Small chance to explode enemies who are already ignited." )