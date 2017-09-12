util.AddNetworkString( "AskWeaponStats" )
util.AddNetworkString( "AskWeaponStatsCallback" )
util.AddNetworkString( "AskGlobalKStats" )
util.AddNetworkString( "AskGlobalKStatsCallback" )
util.AddNetworkString( "AskGlobalDStats" )
util.AddNetworkString( "AskGlobalDStatsCallback" )	
util.AddNetworkString( "AskKDRStats" )
util.AddNetworkString( "AskKDRStatsCallback" )
util.AddNetworkString( "AskFlagStats" )
util.AddNetworkString( "AskFlagStatsCallback" )
util.AddNetworkString( "AskTimeStats" )
util.AddNetworkString( "AskTimeStatsCallback" )
util.AddNetworkString( "AskLevelStats" )
util.AddNetworkString( "AskLevelStatsCallback" )
util.AddNetworkString( "AskMoneyStats" )
util.AddNetworkString( "AskMoneyStatsCallback" )
util.AddNetworkString( "AskAStats" )
util.AddNetworkString( "AskAStatsCallback" )
util.AddNetworkString( "AskLongestHS" )
util.AddNetworkString( "AskLongestHSCallback" )

function table.Cut( tab, num ) -- why isnt this already a thing
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
end

timer.Create( "tdm_timerecord", 60, 0, function()
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

hook.Add( "PlayerDeath", "GlobalKills", function( vic, _, att )
	if vic and att and IsValid( vic ) and IsValid( att ) and vic ~= NULL and att ~= NULL and att:IsPlayer() then
		if vic and vic ~= NULL then
			if not vic:GetPData( "g_deaths" ) then
				vic:SetPData( "g_deaths", "1" )
			else
				local num = tonumber( vic:GetPData( "g_deaths" ) )
				vic:SetPData( "g_deaths", tostring( num + 1 ) )
			end
		end
		if att and att ~= NULL then
			if not att:GetPData( "g_kills" ) then
				att:SetPData( "g_kills", "1" )
			else
				local num = tonumber( att:GetPData( "g_kills" ) )
				att:SetPData( "g_kills", tostring( num + 1 ) )
			end			
		end
	end
end )

hook.Add( "tdm_FlagCaptured", "tdm_recordflagcaps", function( team, flag, plys )
	for k, v in next, plys do
		if not v:GetPData( "g_flags" ) then
			v:SetPData( "g_flags", "1" )
		else
			local num = tonumber( v:GetPData( "g_flags" ) )
			v:SetPData( "g_flags", tostring( num + 1 ) )
		end
	end
end )

net.Receive( "AskGlobalKStats", function( len, ply )
	local f = file.Find( "tdm/users/*.txt", "DATA" ) 
	local lv = {}
	for k, v in next, f do
		if v == "BOT.txt" then
			continue
		end
		local id = string.upper( string.gsub( v:sub( 1, -5 ), "x", ":" ) )
		local name
		for k, v in next, player.GetAll() do
			if v:SteamID() == id then
				name = v:Name()
				local num = util.GetPData( id, "g_kills" )
				if num then
					table.insert( lv, { name, id, num } )
				end
			end
		end
		if not name then
			local fil = util.JSONToTable( file.Read( "tdm/users/" .. v, "DATA" ) )
			name = fil[ 1 ]
			if name == " " then
				name = "[Not known yet, new file structure]"
			end
			local num
			if util.GetPData( id, "g_kills"	) then
				num = util.GetPData( id, "g_kills" )
				table.insert( lv, { name, id, num } )
			end
		end
	end
	table.sort( lv, function( a, b ) return tonumber( a[ 3 ] ) > tonumber( b[ 3 ] ) end )
	net.Start( "AskGlobalKStatsCallback" )
		net.WriteTable( table.Cut( lv, 200 ) )
	net.Send( ply )
end )

net.Receive( "AskGlobalDStats", function( len, ply )
	local f = file.Find( "tdm/users/*.txt", "DATA" ) 
	local lv = {}
	for k, v in next, f do
		if v == "BOT.txt" then
			continue
		end
		local id = string.upper( string.gsub( v:sub( 1, -5 ), "x", ":" ) )
		local name
		for k, v in next, player.GetAll() do
			if v:SteamID() == id then
				name = v:Name()
				local num = util.GetPData( id, "g_deaths" )
				if num then
					table.insert( lv, { name, id, num } )
				end
			end
		end
		if not name then
			local fil = util.JSONToTable( file.Read( "tdm/users/" .. v, "DATA" ) )
			name = fil[ 1 ]
			if name == " " then
				name = "[Not known yet, new file structure]"
			end
			local num
			if util.GetPData( id, "g_deaths" ) then
				num = util.GetPData( id, "g_deaths" )
				table.insert( lv, { name, id, num } )
			end
		end
	end
	table.sort( lv, function( a, b ) return tonumber( a[ 3 ] ) > tonumber( b[ 3 ] ) end )
	net.Start( "AskGlobalDStatsCallback" )
		net.WriteTable( table.Cut( lv, 200 ) )
	net.Send( ply )
end )	

net.Receive( "AskWeaponStats", function( len, ply )
	local wep = net.ReadString()
	local f = file.Find( "tdm/users/*.txt", "DATA" )
	local lv = {}
	for k, v in next, f do
		if v == "BOT.txt" then
			continue
		end
		local id = string.upper( string.gsub( v:sub( 1, -5 ), "x", ":" ) )
		local name
		for k, v in next, player.GetAll() do
			if v:SteamID() == id then
				name = v:Name()
				local num = util.GetPData( id, wep )
				if num then
					table.insert( lv, { name, id, num } )
				end
			end
		end
		if not name then
			local fil = util.JSONToTable( file.Read( "tdm/users/" .. v, "DATA" ) )
			name = fil[ 1 ]
			if name == " " then
				name = "[Not known yet, new file structure]"
			end
			local num
			if util.GetPData( id, wep ) then
				num = util.GetPData( id, wep )
				table.insert( lv, { name, id, num } )
			end
		end
	end
	table.sort( lv, function( a, b ) return tonumber( a[ 3 ] ) > tonumber( b[ 3 ] ) end )
	net.Start( "AskWeaponStatsCallback" )
		net.WriteTable( table.Cut( lv, 200 ) )
	net.Send( ply )
end )

net.Receive( "AskKDRStats", function( len, ply )
	local f = file.Find( "tdm/users/*.txt", "DATA" ) 
	local lv = {}
	for k, v in next, f do
		if v == "BOT.txt" then
			continue
		end
		local id = string.upper( string.gsub( v:sub( 1, -5 ), "x", ":" ) )
		local name
		for k, v in next, player.GetAll() do
			if v:SteamID() == id then
				name = v:Name()
				if util.GetPData( id, "g_kills" ) and util.GetPData( id, "g_deaths" ) then
					local kills = util.GetPData( id, "g_kills" )
					local deaths = util.GetPData( id, "g_deaths" )
					if kills and deaths then
						local ratio = tonumber( kills ) / tonumber( deaths )
						ratio = math.Round( tonumber( ratio ), 3 )
						if ratio then
							table.insert( lv, { name, id, ratio } )
						end
					end
				end
			end
		end
		if not name then
			local fil = util.JSONToTable( file.Read( "tdm/users/" .. v, "DATA" ) )
			name = fil[ 1 ]
			if name == " " then
				name = "[Not known yet, new file structure]"
			end
			if util.GetPData( id, "g_kills" ) and util.GetPData( id, "g_deaths" ) then
				local kills = util.GetPData( id, "g_kills" )
				local deaths = util.GetPData( id, "g_deaths" )
				if kills and deaths then
					local ratio = tonumber( kills ) / tonumber( deaths )
					ratio = math.Round( tonumber( ratio ), 3 )
					if ratio then
						table.insert( lv, { name, id, ratio } )
					end
				end
			end
		end
	end
	table.sort( lv, function( a, b ) return a[ 3 ] > b[ 3 ] end )
	net.Start( "AskKDRStatsCallback" )
		net.WriteTable( table.Cut( lv, 200 ) )
	net.Send( ply )
end )

net.Receive( "AskFlagStats", function( len, ply )
	local f = file.Find( "tdm/users/*.txt", "DATA" ) 
	local lv = {}
	for k, v in next, f do
		if v == "BOT.txt" then
			continue
		end
		local id = string.upper( string.gsub( v:sub( 1, -5 ), "x", ":" ) )
		local name
		for k, v in next, player.GetAll() do
			if v:SteamID() == id then
				name = v:Name()
				local num = util.GetPData( id, "g_flags" )
				if num then
					table.insert( lv, { name, id, num } )
				end
			end
		end
		if not name then
			local fil = util.JSONToTable( file.Read( "tdm/users/" .. v, "DATA" ) )
			name = fil[ 1 ]
			if name == " " then
				name = "[Not known yet, new file structure]"
			end
			local num
			if util.GetPData( id, "g_flags" ) then
				num = util.GetPData( id, "g_flags" )
				table.insert( lv, { name, id, num } )
			end
		end
	end
	table.sort( lv, function( a, b ) return tonumber( a[ 3 ] ) > tonumber( b[ 3 ] ) end )
	net.Start( "AskFlagStatsCallback" )
		net.WriteTable( table.Cut( lv, 200 ) )
	net.Send( ply )
end )

net.Receive( "AskTimeStats", function( len, ply )
	local f = file.Find( "tdm/users/*.txt", "DATA" ) 
	local lv = {}
	for k, v in next, f do
		if v == "BOT.txt" then
			continue
		end
		local id = string.upper( string.gsub( v:sub( 1, -5 ), "x", ":" ) )
		local name
		for k, v in next, player.GetAll() do
			if v:SteamID() == id then
				name = v:Name()
				local num = util.GetPData( id, "g_time" )
				if num then
					table.insert( lv, { name, id, num } )
				end
			end
		end
		if not name then
			local fil = util.JSONToTable( file.Read( "tdm/users/" .. v, "DATA" ) )
			name = fil[ 1 ]
			if name == " " then
				name = "[Not known yet, new file structure]"
			end
			local num
			if util.GetPData( id, "g_time" ) then
				num = util.GetPData( id, "g_time" )
				table.insert( lv, { name, id, num } )
			end
		end
	end
	table.sort( lv, function( a, b ) return tonumber( a[ 3 ] ) > tonumber( b[ 3 ] ) end )
	net.Start( "AskTimeStatsCallback" )
		net.WriteTable( table.Cut( lv, 200 ) )
	net.Send( ply )
end )

net.Receive( "AskMoneyStats", function( len, ply )
	local f = file.Find( "tdm/users/*.txt", "DATA" ) 
	local lv = {}
	for k, v in next, f do
		if v == "BOT.txt" then
			continue
		end
		local id = string.upper( string.gsub( v:sub( 1, -5 ), "x", ":" ) )
		local name
		for k, v in next, player.GetAll() do
			if v:SteamID() == id then
				name = v:Name()
				local num = util.GetPData( id, "tdm_money" )
				if num then
					table.insert( lv, { name, id, num } )
				end
			end
		end
		if not name then
			local fil = util.JSONToTable( file.Read( "tdm/users/" .. v, "DATA" ) )
			name = fil[ 1 ]
			if name == " " then
				name = "[Not known yet, new file structure]"
			end
			local num
			if util.GetPData( id, "tdm_money" ) then
				num = util.GetPData( id, "tdm_money" )
				table.insert( lv, { name, id, num } )
			end
		end
	end
	table.sort( lv, function( a, b ) return tonumber( a[ 3 ] ) > tonumber( b[ 3 ] ) end )
	net.Start( "AskMoneyStatsCallback" )
		net.WriteTable( table.Cut( lv, 200 ) )
	net.Send( ply )
end )

net.Receive( "AskLevelStats", function( len, ply )
	local f = file.Find( "tdm/users/*.txt", "DATA" ) 
	local lv = {}	
	for k, v in next, f do
		if v == "BOT.txt" then
			continue
		end
		local id = string.upper( string.gsub( v:sub( 1, -5 ), "x", ":" ) )
		local name
		for k, v in next, player.GetAll() do
			if v:SteamID() == id then
				name = v:Name()
				local num = util.GetPData( id, "level" )
				if num then
					table.insert( lv, { name, id, num } )
				end
			end
		end
		if not name then
			local fil = util.JSONToTable( file.Read( "tdm/users/" .. v, "DATA" ) )
			name = fil[ 1 ]
			if name == " " then
				name = "[Not known yet, new file structure]"
			end
			local num
			if util.GetPData( id, "level" ) then
				num = util.GetPData( id, "level" )
				table.insert( lv, { name, id, num } )
			end
		end
	end
	table.sort( lv, function( a, b ) return tonumber( a[ 3 ] ) > tonumber( b[ 3 ] ) end )
	net.Start( "AskLevelStatsCallback" )
		net.WriteTable( table.Cut( lv, 200 ) )
	net.Send( ply )	
end )	

net.Receive( "AskAStats", function( len, ply )
	local f = file.Find( "tdm/users/*.txt", "DATA" ) 
	local lv = {}
	for k, v in next, f do
		if v == "BOT.txt" then
			continue
		end
		local id = string.upper( string.gsub( v:sub( 1, -5 ), "x", ":" ) )
		local name
		for k, v in next, player.GetAll() do
			if v:SteamID() == id then
				name = v:Name()
				local num = util.GetPData( id, "g_assists" )
				if num then
					table.insert( lv, { name, id, num } )
				end
			end
		end
		if not name then
			local fil = util.JSONToTable( file.Read( "tdm/users/" .. v, "DATA" ) )
			name = fil[ 1 ]
			if name == " " then
				name = "[Not known yet, new file structure]"
			end
			local num
			if util.GetPData( id, "g_assists" ) then
				num = util.GetPData( id, "g_assists" )
				table.insert( lv, { name, id, num } )
			end
		end
	end
	table.sort( lv, function( a, b ) return tonumber( a[ 3 ] ) > tonumber( b[ 3 ] ) end )
	net.Start( "AskAStatsCallback" )
		net.WriteTable( table.Cut( lv, 200 ) )
	net.Send( ply )
end )

net.Receive( "AskLongestHS", function( len, ply )
	local f = file.Find( "tdm/users/*.txt", "DATA" ) 
	local lv = {}
	for k, v in next, f do
		if v == "BOT.txt" then
			continue
		end
		local id = string.upper( string.gsub( v:sub( 1, -5 ), "x", ":" ) )
		local name
		for k, v in next, player.GetAll() do
			if v:SteamID() == id then
				name = v:Name()
				local num = util.GetPData( id, "g_headshot" )
				if num then
					table.insert( lv, { name, id, num } )
				end
			end
		end
		if not name then
			local fil = util.JSONToTable( file.Read( "tdm/users/" .. v, "DATA" ) )
			name = fil[ 1 ]
			if name == " " then
				name = "[Not known yet, new file structure]"
			end
			local num
			if util.GetPData( id, "g_headshot" ) then
				num = util.GetPData( id, "g_headshot" )
				table.insert( lv, { name, id, num } )
			end
		end
	end
	table.sort( lv, function( a, b ) return tonumber( a[ 3 ] ) > tonumber( b[ 3 ] ) end )
	net.Start( "AskLongestHSCallback" )
		net.WriteTable( table.Cut( lv, 200 ) )
	net.Send( ply )
end )
