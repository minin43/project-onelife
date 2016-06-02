hook.Add( "PlayerSpawn", "Leech", function( ply )
timer.Simple( 0.1, function()
if CheckPerk( ply ) == "leech" then
	ply.class = "Leech"
    ply:SetWalkSpeed( 190 ) --default is 180
	ply:SetRunSpeed ( 310 ) --default is 300
    ply:SetJumpPower( 160 ) --default is 170
    
    --[[if (ply:Team() == 1) then
		ply:SetModel()
	elseif (ply:Team() == 2) then
		ply:SetModel()
	end]] --Unique playermodel goes here
    
    ply:SetMaxHealth( 90 )
    ply:SetHealth( 90 )
    end
end )
end )

hook.Add( "PlayerDeath", "Leech", function( vic, inf, att )
	if CheckPerk( att ) == "leech" then
		if att:Alive() then
			att:SetHealth( att:Health() + ( ( 100 - att:Health() ) / 3 ) )
			ply.victimstaken = ply.victimstaken + 1
		end
	end
end )

function VampirismAssist( ply, value )
	if CheckPerk( ply ) == "leech" then
		if ply:Alive() then
			ply:SetHealth( ply:Health() + ( ( ( 100 - ply:Health() ) / 3 ) * value / 100 ) )
		end
	end
end

hook.Add( "PlayerHurt", "Leech", function( ply, att )
	if ply and IsValid( ply ) and ply ~= NULL and load[ ply ] ~= nil then
		if load[ ply ].perk and load[ ply ].perk == "leech" then
			if timer.Exists( "regen_" .. ply:SteamID() ) then
				timer.Stop( "regen_" .. ply:SteamID() )
				if timer.Exists( "delay_" .. ply:SteamID() ) then
					timer.Destroy( "delay_" .. ply:SteamID() )
				end
				timer.Create( "delay_" .. ply:SteamID(), 3, 1, function()
					timer.Start( "regen_" .. ply:SteamID() )
					timer.Destroy( "delay_" .. ply:SteamID() )
				end )
			else
				timer.Create( "delay_" .. ply:SteamID(), 3, 1, function()
					timer.Create( "regen_" .. ply:SteamID(), 0.2, 0, function()
						if ply:Alive() then
							local hp = ply:Health()
							if hp < 100 then
								ply:SetHealth( hp + 2 )
							end
						end
					end )
					timer.Destroy( "delay_" .. ply:SteamID() )
				end )
			end
		end
	end
end )

hook.Add( "PlayerDeath", "removeregen", function( ply )
	if timer.Exists( "regen_" .. ply:SteamID() ) then
		timer.Destroy( "regen_" .. ply:SteamID() )
	end
	if timer.Exists( "delay_" .. ply:SteamID() ) then
		timer.Destroy( "delay_" .. ply:SteamID() )
	end
end )

RegisterPerk( "Leech", "leech", 1, "Killing an enemy will restore 1/3 of your missing health, getting an assist will restore a % of 1/3 of your missing health. Auto-regenerate health after 3 seconds of not taking damage." )