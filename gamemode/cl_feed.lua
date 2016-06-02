surface.CreateFont("Feed", { 
    font = "Exo 2",
    size = 24, 
    antialias = 1 
})

surface.CreateFont("FeedBlur", { 
    font = "Exo 2",
    size = 24, 
    blursize = 3, 
    antialias = 1 
})

surface.CreateFont("FeedSm", { 
    font = "Exo 2", 
    size = 18,  
    antialias = 1 
})

surface.CreateFont("FeedSmBlur", { 
    font = "Exo 2", 
    size = 18, 
    blursize = 3, 
    antialias = 1 
})

surface.CreateFont("FeedCount", { 
    font = "Exo 2", 
    size = 25, 
    antialias = 1 
})

surface.CreateFont("FeedCountBlur", { 
    font = "Exo 2", 
    size = 25, 
    blursize = 3, 
    antialias = 1 
})

surface.CreateFont( "UT3", { font = "Unreal Tournament", size = 125, antialias = false, shadow = false, outline = true } )
surface.CreateFont( "UT3-Back", { font = "Unreal Tournament", size = 128, antialias = false, shadow = false, outline = true } )

NOTICETYPES = {
    KILL = 1,
    FLAG = 2,
    EXTRA = 4,
    ROUND = 8,
    SPECIAL = 16
}

Feed = {}
    
local Feed = {}
local Score = 0
local Disp = 0
local defaultY = ScrH() - ScrH() / 3
timer.Create("ScoreTimer", 5, 0, function()
    Score = 0
end)
net.Receive("KillFeed", function()
    local str = net.ReadString()
    local nScore = net.ReadInt(16)
    local nType = net.ReadInt(16)
    local col = net.ReadColor()
    
    table.insert(Feed, 1, { 
        dispText = "",
        time = CurTime(), 
        text = str, 
        yPos = defaultY, 
        color = col, 
        type = nType, 
        score = nScore,
    })
    Score = Score + nScore
    timer.Start("ScoreTimer")
end)

hook.Add("Think", "Feed", function()
    for k, v in next, Feed do
        if CurTime() - v.time > 4 then
            Feed[k].dispText = Feed[k].dispText:sub(1, -2)
            if Feed[k].dispText == "" then
                table.remove(Feed, k)
            end
        else
            if v.dispText ~= v.text then
                local len = v.dispText:len()
                if len < v.text:len() then
                    Feed[k].dispText = string.sub(v.text, 1, len + 1)
                end
            end
        end
    end
end)

hook.Add("HUDPaint", "DrawCenterFeed", function()
local test = false
    for k, v in next, Feed do
        if v.type == NOTICETYPES.SPECIAL then
            draw.NoTexture()
            draw.DrawText( v.dispText, "UT3-Back", ScrW() * 0.5, ScrH() * 0.25, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER )
	        draw.DrawText( v.dispText, "UT3", ScrW() * 0.5, ScrH() * 0.25, Color( 255, 0, 0, 255 ), TEXT_ALIGN_CENTER )
        end
        local y = defaultY + ((k - 1) * 20)
        if v.yPos ~= y then
            local num = table.getn(Feed)
            if v.yPos > y then
                Feed[k].yPos = math.Approach(v.yPos, y, math.min(3, num))
            else
                Feed[k].yPos= math.Approach(v.yPos, y, num)
            end
        end
        
        local col = Color(v.color.r, v.color.b, v.color.g, 255)
        local colbg = Color(0, 0, 0, 255)
        
        local font = "Feed"
        local fontbg = "FeedBlur"
        if v.type == NOTICETYPES.EXTRA then
            font = "FeedSm"
            fontbg = "FeedSmBlur"
        end
        
        draw.SimpleText(v.dispText, fontbg, ScrW() / 2 - 40, v.yPos, colbg, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
        draw.SimpleText(v.dispText, font, ScrW() / 2 - 40, v.yPos, col, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
        
        draw.SimpleText(v.score, fontbg, ScrW() / 2, v.yPos, Color(0, 0, 0, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
        draw.SimpleText(v.score, font, ScrW() / 2, v.yPos, Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER) 
    end
    if Disp ~= Score then
        if Score ~= 0 then
            Disp = math.Approach(Disp, Score, 4)
        else
            Disp = math.Approach(Disp, Score, 8)
        end
    end
    if Disp > 0 then
        local cColor = Color(255, 255, 255, 255)
        local cColorBg = Color(0, 0, 0, 255)
        multi = ""
        curMultiplier = GetGlobalInt("ctdm_global_xp_multiplier")
        if curMultiplier > 1 then
            multi = " (x" .. tostring(curMultiplier) .. ")"
        end
        draw.SimpleText(tostring(Disp) .. multi, "FeedCountBlur", ScrW() / 2 + 20, defaultY - 1, cColorBg, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)		
        draw.SimpleText(tostring(Disp) .. multi, "FeedCount", ScrW() / 2 + 20, defaultY - 1, cColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)		
   end
end)
