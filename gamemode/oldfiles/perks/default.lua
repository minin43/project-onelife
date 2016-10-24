hook.Add( "PlayerSpawn", "Brainstorm", function( ply )
    timer.Simple( 0.1, function()
        if CheckPerk( ply ) != "brainstorm" or CheckPerk( ply ) != "murk" or CheckPerk( ply ) != "leech" 
        or CheckPerk( ply ) != "lifeline" or CheckPerk( ply ) != "magician" or CheckPerk( ply ) != "illumin" or CheckPerk( ply ) != "vulture" then
            ply.class = "None" --So when a player kills you when you aren't using a perk, it doesn't phreak out
        end
    end )
end )