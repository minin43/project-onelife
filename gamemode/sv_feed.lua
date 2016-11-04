print( "sv_feed initialization..." )
util.AddNetworkString("KillFeed")

SetGlobalInt("ctdm_global_xp_multiplier", 1)
NOTICETYPES = {
    KILL = 1,
    FLAG = 2,
    EXTRA = 4,
    ROUND = 8,
    SPECIAL = 16
}

SCORECOUNTS = {
    KILL = 100,
    HEADSHOT = 50,
    LONGSHOT = 25,
    FIRSTBLOOD = 50,
    DENIED = 100,
    
    DOUBLE_KILL = 50,
    MULTI_KILL = 100,
    MEGA_KILL = 150,
    ULTRA_KILL = 200,
    UNREAL_KILL_MULTIPLIER = 50,
	
	KILLSTREAK5 = 100,
    KILLSTREAK6 = 200,
    KILLSTREAK7 = 300,
    KILLSTREAK8 = 400,
    KILLSTREAK9 = 500,
    KILLSTREAK10 = 1000,
    KILLSTREAK15 = 1500,
    KILLSTREAK20 = 2000,
    KILLSTREAK30 = 3000,
    
    LOW_HEALTH = 50,
    FLAG_ATT_DEF = 50,
    AFTERLIFE = 200,
    END_GAME = 100,
    
    FLAG_CAPTURED = 300,
    FLAG_NEUTRALIZED = 200,
    FLAG_SAVED = 50,
    
    ROUND_WON = 500,
    ROUND_LOST = 100,
    ROUND_TIED = 250
}

function AddNotice(ply, text, score, type, color, suppressrewards)
    if !color then color = Color(255, 255, 255, 255) end
    if !suppressrewards then suppressrewards = false end
    score = score * GetGlobalInt("ctdm_global_xp_multiplier")
    net.Start("KillFeed")
        net.WriteString(text)
        net.WriteInt(score, 16) -- short type
        net.WriteInt(type, 16)
        net.WriteColor(color)
    net.Send(ply)
    if suppressrewards then return end
    AddRewards(ply, score)
end

function AddRewards(ply, score)
    lvl.AddEXP(ply, score)
    AddMoney(ply, score)
    ply:AddScore(score)
end

hook.Add("PlayerDeath", "AddNotices", function(vic, inf, att)

    --Standard validity checker
    if !att:IsPlayer() || !att:IsValid() || !vic:IsValid() --[[|| att == vic]] || att:GetActiveWeapon() == NULL || att:GetActiveWeapon() == NULL then
        return
    end
    
    --Standard kill notice
    local col = Color(255, 0, 83)
    AddNotice(att, vic:Name(), 100, NOTICETYPES.KILL, col)
    
    -- Marksman bonus
    shotDistance = math.Round(att:GetPos():Distance(vic:GetPos()) / 39) -- Converts to meters
    if vic:LastHitGroup() == HITGROUP_HEAD then
        AddNotice(att, "HEADSHOT", SCORECOUNTS.HEADSHOT, NOTICETYPES.EXTRA)
    end
    
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
	
end)

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

--[[util.AddNetworkString( "KillFeed" )

NOTICETYPES = {
    KILL = "kill",
    OBJ = "objective",
    RND = "round",
    MOD = "modifier",
    LOGAN = "logan"
}

SCORECOUNTS = {
    KILL = 20,
    HEADSHOT = 10,
    
    ROUND_WON = 10,
    ROUND_LOST = 5,
    ROUND_TIED = 5

    GAME_WON = 100,
    GAME_TIED = 50,
    GAME_LOST = 25
}

function AddNotice( ply, text, score, type )
    --//ply is player getting the points, text is the text client shows in the box, score is the point amount ply receives, type is the modifier to text
    net.Start( "KillFeed" )
        net.WriteString( text )
        net.WriteString( tostring( score ) )
        net.WriteString( type )
    net.Send( ply )
    AddRewards( ply, score )
end

function AddRewards( ply, score )
    lvl.AddEXP( ply, score )
    AddMoney( ply, score )
    ply:AddScore( score )
end

hook.Add( "PlayerDeath", "AddNotices", function( vic, inf, att )

    --Standard validity checker
    if !att:IsPlayer() || !att:IsValid() || !vic:IsValid() || att:GetActiveWeapon() == NULL || att:GetActiveWeapon() == NULL then
        return
    end
    
    --Standard kill notice
    AddNotice( att, vic:Name(), SCORECOUNTS.KILL, NOTICETYPES.KILL )
    
    -- Headshot bonus
    if vic:LastHitGroup() == HITGROUP_HEAD then
        AddNotice( att, "HEADSHOT", SCORECOUNTS.HEADSHOT, NOTICETYPES.MOD )
    end
	
end )]]