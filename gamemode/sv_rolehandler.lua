local roleplayermodels = {
    [ 1 ] = {
        "",
        "",
        "",
        "",
        "",
        "",
        "",
        ""
    },
    [ 2 ] = {
        "",
        "",
        "",
        "",
        "",
        "",
        "",
        ""
    },
    [ 3 ] = {
        "",
        "",
        "",
        "",
        "",
        "",
        "",
        ""
    }
}

function SetArmor( ply, type )
    local armorspeed = {
    --//[ armor type ] = { walkspeed = 140, runspeed = 260, jumpstrength = 170 }
        [ "light" ] = { 140, 280, 190 },
        [ "standard" ] = { 140, 260, 170 },
        [ "heavy" ] = { 140, 245, 170 },
        [ "superheavy" ] = { 120, 235, 150 }
    }
    if ply and armorspeed[ type ] then
        ply:SetWalkSpeed( armorspeed[ type ][ 1 ] )
        ply:SetRunSpeed( armorspeed[ type ][ 2 ] )
        ply:SetJumpPower( armorspeed[ type ][ 3 ] )
        ply.Armor = type
    end
end

hook.Add( "PlayerSpawn", "Militant/Rifleman", function( ply )
    timer.Simple( 0.1, function()
        local myrole = CheckRole( ply )
        if myrole == 1 then
            ply.class = role[ myrole ][ ply:Team() ]
            --[[ply:SetWalkSpeed( ply:GetWalkSpeed() * 1 )
	        ply:SetRunSpeed ( ply:GetrunSpeed() * 1 )
            ply:SetJumpPower( ply:GetJumpPower() * 1 )]]
    
            --ply:SetModel( roleplayermodels[ ply:Team() ][ myrole ] )
    
            ply:SetMaxHealth( 100 )
            ply:SetHealth( 100 )
        end
    end )
end )

hook.Add( "PlayerSpawn", "Scout/Recon", function( ply )
    timer.Simple( 0.1, function()
        local myrole = CheckRole( ply )
        if myrole == 2 then
            ply.class = role[ myrole ][ ply:Team() ]
            --[[ply:SetWalkSpeed( ply:GetWalkSpeed() * 1 )
	        ply:SetRunSpeed ( ply:GetrunSpeed() * 1 )
            ply:SetJumpPower( ply:GetJumpPower() * 1 )]]
    
            --ply:SetModel( roleplayermodels[ ply:Team() ][ myrole ] )
    
            ply:SetMaxHealth( 100 )
            ply:SetHealth( 100 )
        end
    end )
end )

hook.Add( "PlayerSpawn", "Gunner/Support", function( ply )
    timer.Simple( 0.1, function()
        local myrole = CheckRole( ply )
        if myrole == 3 then
            ply.class = role[ myrole ][ ply:Team() ]
            --[[ply:SetWalkSpeed( ply:GetWalkSpeed() * 1 )
	        ply:SetRunSpeed ( ply:GetrunSpeed() * 1 )
            ply:SetJumpPower( ply:GetJumpPower() * 1 )]]
    
            --ply:SetModel( roleplayermodels[ ply:Team() ][ myrole ] )
    
            ply:SetMaxHealth( 100 )
            ply:SetHealth( 100 )
        end
    end )
end )

hook.Add( "PlayerSpawn", "DM/Sharpshooter", function( ply )
    timer.Simple( 0.1, function()
        local myrole = CheckRole( ply )
        if myrole == 4 then
            ply.class = role[ myrole ][ ply:Team() ]
            --[[ply:SetWalkSpeed( ply:GetWalkSpeed() * 1 )
	        ply:SetRunSpeed ( ply:GetrunSpeed() * 1 )
            ply:SetJumpPower( ply:GetJumpPower() * 1 )]]
    
            --ply:SetModel( roleplayermodels[ ply:Team() ][ myrole ] )
    
            ply:SetMaxHealth( 100 )
            ply:SetHealth( 100 )
        end
    end )
end )

hook.Add( "PlayerSpawn", "Striker/Demolitions", function( ply )
    timer.Simple( 0.1, function()
        local myrole = CheckRole( ply )
        if myrole == 5 then
            ply.class = role[ myrole ][ ply:Team() ]
            --[[ply:SetWalkSpeed( ply:GetWalkSpeed() * 1 )
	        ply:SetRunSpeed ( ply:GetrunSpeed() * 1 )
            ply:SetJumpPower( ply:GetJumpPower() * 1 )]]
    
            --ply:SetModel( roleplayermodels[ ply:Team() ][ myrole ] )
    
            ply:SetMaxHealth( 100 )
            ply:SetHealth( 100 )
        end
    end )
end )

hook.Add( "PlayerSpawn", "Sniper", function( ply )
    timer.Simple( 0.1, function()
        local myrole = CheckRole( ply )
        if myrole == 6 then
            ply.class = role[ myrole ][ ply:Team() ]
            --[[ply:SetWalkSpeed( ply:GetWalkSpeed() * 1 )
	        ply:SetRunSpeed ( ply:GetrunSpeed() * 1 )
            ply:SetJumpPower( ply:GetJumpPower() * 1 )]]
    
            --ply:SetModel( roleplayermodels[ ply:Team() ][ myrole ] )
    
            ply:SetMaxHealth( 100 )
            ply:SetHealth( 100 )
        end
    end )
end )

hook.Add( "PlayerSpawn", "Sapper/Breacher", function( ply )
    timer.Simple( 0.1, function()
        local myrole = CheckRole( ply )
        if myrole == 7 then
            ply.class = role[ myrole ][ ply:Team() ]
            --[[ply:SetWalkSpeed( ply:GetWalkSpeed() * 1 )
	        ply:SetRunSpeed ( ply:GetrunSpeed() * 1 )
            ply:SetJumpPower( ply:GetJumpPower() * 1 )]]
    
            --ply:SetModel( roleplayermodels[ ply:Team() ][ myrole ] )
    
            ply:SetMaxHealth( 100 )
            ply:SetHealth( 100 )
        end
    end )
end )

hook.Add( "PlayerSpawn", "Expert/Specialist", function( ply )
    timer.Simple( 0.1, function()
        local myrole = CheckRole( ply )
        if myrole == 8 then
            ply.class = role[ myrole ][ ply:Team() ]
            --[[ply:SetWalkSpeed( ply:GetWalkSpeed() * 1 )
	        ply:SetRunSpeed ( ply:GetrunSpeed() * 1 )
            ply:SetJumpPower( ply:GetJumpPower() * 1 )]]
    
            --ply:SetModel( roleplayermodels[ ply:Team() ][ myrole ] )
    
            ply:SetMaxHealth( 100 )
            ply:SetHealth( 100 )
        end
    end )
end )