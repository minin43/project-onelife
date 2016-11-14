print( "sv_feed initialization..." )

SCORECOUNTS = {
    KILL_KILL = 50,
    KILL_HEADSHOT = 20,
    KILL_LONGSHOT = 10,
    KILL_LOWLIFE = 10,
    
    ROUND_WON = 100,
    ROUND_LOST = 50,
    ROUND_TIED = 50

    GAME_WON = 200,
    GAME_TIED = 100,
    GAME_LOST = 100
}

function AddRewards( ply, score )
    lvl.AddEXP( ply, score )
    AddMoney( ply, score )
    ply:AddScore( score )
end

hook.Add( "PlayerDeath", "AddNotices", function( vic, inf, att )

    --//Standard validity checker
    if !att:IsPlayer() || !att:IsValid() || !vic:IsValid() || att:GetActiveWeapon() == NULL || att:GetActiveWeapon() == NULL then
        return
    end
    
    --//Standard kill
    AddRewards( att, SCORECOUNTS.KILL_KILL )
    
    --//Headshot bonus
    if vic:LastHitGroup() == HITGROUP_HEAD then
        AddRewards( att, SCORECOUNTS.KILL_HEADSHOT )
    end

    --//Long shot bonus
    local shotDistance = math.Round(att:GetPos():Distance(vic:GetPos()) / 39) -- Converts to meters
    if shotDistance > 50 then
        AddRewards( att, SCORECOUNTS.KILL_LONGSHOT )
    end

    --//Low life bonus
    if att:Health() <= 20 then
        AddRewards( att, SCORECOUNTS.KILL_LOWLIFE )
    end
	
end )

--[[
    -- Assist stuff
    if vic.PotentialAssist then
        local assist = vic.PotentialAssist
        if IsValid(assist[1]) and assist[1] ~= NULL then
            if assist[1] ~= att then
                AddNotice(assist[1], "ASSIST", assist[2], NOTICETYPES.KILL)
                if assist[1]:GetNWString("assists") == "" or not assist[1]:GetNWString("assists") then
                    assist[1]:SetNWString("assists", "1")
                else
                    assist[1]:SetNWString("assists", tostring(tonumber(assist[1]:GetNWString("assists")) + 1))
                end
                local ply = assist[1]
                local data = ply:GetPData("g_assists")
                if !data then
                    ply:SetPData("g_assists", "1")
                else
                    local num = tonumber(data)
                    ply:SetPData("g_assists", tostring(num + 1))
                end
            end
        end
    end
    vic.PotentialAssist = nil
    vic.dmg = nil
    
hook.Add("PlayerHurt", "CalculateAssists", function(victim, attacker, x, dmg)
	if victim and attacker and victim:IsPlayer() and attacker:IsPlayer() and victim ~= NULL and attacker ~= NULL then
		if not victim.dmg then
			victim.dmg = {}
		end
		if not victim.dmg[attacker] then
			victim.dmg[attacker] = dmg
		else
			victim.dmg[attacker] = victim.dmg[attacker] + dmg
		end
		if not victim.PotentialAssist then
			if victim.dmg[attacker] >= 50 then
				victim.PotentialAssist = { attacker, math.Round(victim.dmg[attacker]) }
			end
		end
	end
end)
]]