hook.Add( "PlayerSpawn", "Illumin", function( ply )
timer.Simple( 0.1, function()
if CheckPerk( ply ) == "illumin" then
	ply.class = "Illumin"
    ply:SetWalkSpeed( 210 ) --default is 180, swiftness' was 215
	ply:SetRunSpeed ( 350 ) --default is 300, swiftness' was 350
    ply:SetJumpPower( 200 ) --default is 170
    
    --[[if (ply:Team() == 1) then
		ply:SetModel()
	elseif (ply:Team() == 2) then
		ply:SetModel()
	end]] --Unique playermodel goes here
    
    ply:SetMaxHealth( 70 )
    ply:SetHealth( 70 )
    end
end )
end )

RegisterPerk( "Illumin", "illumin", 1, "Move speed, sprint speed, and jump height increased by 17%, but start with less health." )