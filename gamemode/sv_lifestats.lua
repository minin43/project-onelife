print( "sv_lifestats initialization..." )
util.AddNetworkString( "RequestLifestats" )
util.AddNetworkString( "RequestLifestatsCallback" )

--[[function table.Cut( tab, num ) -- why isnt this already a thing
	assert( type( tab ) == "table", "Bad argument #1 to table.Cut: argument type must be a table" )
	assert( type( num ) == "number", "Bad argument #2 to table.Cut: argument type must be a number" )
	assert( math.Round( num ) == num, "Bad argument #2 to table.Cut: number must be whole" )
	local t_num = table.Count( tab )
	if t_num <= num then
		return tab
	end
	repeat
		local last = table.GetLastKey( tab )
		table.remove( tab, last )
	until table.Count( tab ) <= num
	return tab
end]]

timer.Create( "pol_timerecord", 60, 0, function()
	for k, v in next, player.GetAll() do
		if IsValid( v ) then
			if not v:GetPData( "g_time" ) then
				v:SetPData( "g_time", "1" )
			else
				local num = tonumber( v:GetPData( "g_time" ) )
				v:SetPData( "g_time", tostring( num + 1 ) )
			end
		end
	end
end )

hook.Add( "PlayerDeath", "GlobalKills", function( vic, wep, att )
	if vic and att and IsValid( vic ) and IsValid( att ) and vic != NULL and att != NULL and att:IsPlayer() then
		if vic and vic != NULL then
			if not vic:GetPData( "g_deaths" ) then
				vic:SetPData( "g_deaths", "1" )
			else
				local num = tonumber( vic:GetPData( "g_deaths" ) )
				vic:SetPData( "g_deaths", tostring( num + 1 ) )
			end
		end
		if att and att != NULL then
			if not att:GetPData( "g_kills" ) then
				att:SetPData( "g_kills", "1" )
			else
				local num = tonumber( att:GetPData( "g_kills" ) )
				att:SetPData( "g_kills", tostring( num + 1 ) )
			end			
		end
        if vic:LastHitGroup() == "HITGROUP_HEAD" then
            if not att:GetPData( "g_headshots" ) then
				att:SetPData( "g_headshots", "1" )
			else
				local num = tonumber( att:GetPData( "g_headshots" ) )
				att:SetPData( "g_headshots", tostring( num + 1 ) )
			end
        end
	end
end )


net.Receive( "RequestLifestats", function( len, ply )
    net.Start( "RequestLifestatsCallback" )
        net.WriteString( tostring( ply:GetPData( "g_time" ) ) ) --time
        net.WriteString( tostring( ply:GetPData( "g_kills" ) ) ) --kills
        net.WriteString( tostring( ply:GetPData( "g_deaths" ) ) ) --deaths
        net.WriteString( tostring( ply:GetPData( "g_headshots" ) ) ) --headshots    
	net.Send( ply )
end )