SetGlobalInt( "Unbalanced", 0 )
local teamPrevent = 0
hook.Add( "Think", "TeamBalance", function()
	if CurTime() > teamPrevent then
		teamPrevent = CurTime() + 4
		local amtB = #team.GetPlayers( 2 )
		local amtR = #team.GetPlayers( 1 )
		if amtB - amtR >= 3 then
			if GetGlobalInt( "Unbalanced" ) ~= 2 then
				SetGlobalInt( "Unbalanced", 2 )
			end
		elseif amtR - amtB >= 3 then
			if GetGlobalInt( "Unbalanced" ) ~= 1 then
				SetGlobalInt( "Unbalanced", 1 )
			end
		elseif amtB - amtR < 3 and amtR - amtB < 3 then
			if GetGlobalInt( "Unbalanced" ) ~= 0 then
				SetGlobalInt( "Unbalanced", 0 )
			end
		end
	end
end )

function team.GetSortedPlayers( tea )
	local tab = team.GetPlayers( tea )
	table.sort( tab, function( a, b ) return a:Frags() > b:Frags() end )
	return tab
end

timer.Create( "TeamBalance", 30, 0, function()
	if GetGlobalInt( "Unbalanced" ) > 0 then
		local more
		local less
		if GetGlobalInt( "Unbalanced" ) == 1 then
			more = 1
			less = 2
		elseif GetGlobalInt( "Unbalanced" ) == 2 then
			more = 2
			less = 1
		end
		local tmore = team.GetSortedPlayers( more )
		local tless = team.GetSortedPlayers( less )
		local diff = math.floor( ( #tmore - #tless ) / 2 )
		local temp = {}
		for i = 1, diff do
			local ply = tmore[ #tmore - ( i - 1 ) ]
			ply:ConCommand( "tdm_setteam " ..  less )
			table.insert( temp, ply:Nick() )
		end		
		local exp = table.concat( temp, ", " )
		ULib.tsayColor( nil, false, Color( 255, 255, 255 ), "Player(s) " .. exp .. " moved for team balance." )
	end
end )