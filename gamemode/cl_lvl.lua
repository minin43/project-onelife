currentlvl = -1
currentexp = -1
nextlvlexp = -1

net.Receive( "SendUpdate", function()
	local lv = tonumber( net.ReadString() )
	local exp = tonumber( net.ReadString() )
	local nextlvl = tonumber( net.ReadString() )
	currentlvl = lv
	currentexp = exp
	nextlvlexp = nextlvl
end )	
--[[
local x, y, w, h = 35, ScrH() - 120, 200, 20

hook.Add( "HUDPaint", "lvl.DrawHud", function()
	if not LocalPlayer() then
		return
	end
	
	local exp = currentexp
	local nextexp = nextlvlexp
	local lvl = currentlvl
	
	if ( not exp or not nextexp or not lvl ) then 
		return 
	end
	
	if not LocalPlayer():Alive() then 
		return 
	end

	surface.SetDrawColor( 0, 0, 0, 220 )
	surface.DrawOutlinedRect( x, y, w, h )

	surface.SetDrawColor( 0, 200, 0, 175 )
		
	if currentlvl == -1 and currentexp == -1 and nextlvlexp == -1 then
		draw.DrawText( "Receiving...", "DermaDefault", x + w / 2, y - 20, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER )
		draw.DrawText( "Receiving...", "DermaDefault", x + w / 2, y + 1, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER )			
	else
		local percent = exp / nextexp
		percent = percent * 100
		percent = math.Round( percent )

		local w2 = w - 2
		w2 = w2 / 100
		w2 = w2 * percent
		
		surface.DrawRect( x + 1.2, y + 1.2, w2, h - 2 )
		draw.DrawText( "Level " .. lvl, "DermaDefault", x + w / 2, y - 20, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER )
		draw.DrawText( exp .. "/" .. nextexp .. " - " .. percent .. "%", "DermaDefault", x + w / 2, y + 1, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER )
	end

end )
]]
timer.Create( "Refresh", 5, 0, function()
	if currentlvl == -1 and currentexp == -1 and nextlvlexp == -1 then
		RunConsoleCommand( "lvl_refresh" )
	end
end )