util.AddNetworkString( "SendFlags" )
util.AddNetworkString( "FlagCapped" )
	
flags = flags or {}

-- Pasting this in console gets everyone's current location: lua_run for k, v in pairs(player.GetAll()) do print(v, v:GetPos())end

flags[ "gm_construct" ] = {
	{ "L", Vector( -2402, -1560, -143 ), 300, 0 },
	{ "O", Vector( -2250, -2786, 256 ), 400, 0 },
	{ "G", Vector( -845, 564, -160 ), 200, 0 },
	{ "A", Vector( -4531, 5393, -95 ), 400, 0 },
	{ "N", Vector( 1399, -1659, -143 ), 300, 0 },
	{ "!", Vector( 773, 4239, -31 ), 50, 0 }
}
tab = {}

for k, v in next, player.GetAll() do
	tab[ v ] = 0
end
hook.Add( "PlayerSpawn", "SetNilValue", function( ply )
	tab[ ply ] = 0
	umsg.Start( "UpdateNumber", ply )
		umsg.String( "69" )
	umsg.End()		
end )

local curmap
if not flags[ game.GetMap() ] then
	return
else
	curmap = flags[ game.GetMap() ]
end

local status = {}
for k, v in next, curmap do
	status[ v[ 1 ] ] = 0
end

local function updateNumber( a, num )
	local allplys = {}
	for t, y in next, player.GetAll() do
		if tab[ y ] == a then
			table.insert( allplys, y )
		end
	end
	for k, v in next, allplys do
		umsg.Start( "UpdateNumber", v )
			umsg.String( tostring( num ) )
		umsg.End()
	end
	net.Start( "SendFlags" )
		net.WriteTable( curmap )
		net.WriteTable( status )
	net.Broadcast()
end

--prepare yourself
timer.Create( "CapFlags", 1, 0, function()
	for k, v in next, curmap do
		for kk, vv in next, player.GetAll() do
			if tab[ vv ] == v[ 1 ] then
				if vv:Team() == 1 then --red team
					if v[ 4 ] + 1 < 10 and v[ 4 ] + 1 ~= 0 then
						v[ 4 ] = v[ 4 ] + 1
						updateNumber( v[ 1 ], v[ 4 ] )
					elseif v[ 4 ] + 1 > 10 then
						v[ 4 ] = 10
						updateNumber( v[ 1 ], v[ 4 ] )					
					elseif v[ 4 ] + 1 == 10 then
						if status[ v[ 1 ] ] == 0 then
							v[ 4 ] = 10
							local allplys = {}
							for t, y in next, player.GetAll() do
								if tab[ y ] == v[ 1 ] and y:Team() == 1 then
									table.insert( allplys, y )
								end
							end
							hook.Run( "tdm_FlagCaptured", 1, v, allplys )
							updateNumber( v[ 1 ], v[ 4 ] )	
							status[ v[ 1 ] ] = 1
						elseif status[ v[ 1 ] ] == 1 then
							v[ 4 ] = 10
							local allplys = {}
							for t, y in next, player.GetAll() do
								if tab[ y ] == v[ 1 ] and y:Team() == 1 then
									table.insert( allplys, y )
								end
							end
							hook.Run( "tdm_FlagSaved", 1, v, allplys )
							updateNumber( v[ 1 ], v[ 4 ] )			
						end
					elseif v[ 4 ] + 1 == 0 then
						if status[ v[ 1 ] ] ~= 0 then
							v[ 4 ] = v[ 4 ] + 1
							local allplys = {}
							for t, y in next, player.GetAll() do
								if tab[ y ] == v[ 1 ] and y:Team() == 1 then
									table.insert( allplys, y )
								end
							end
							hook.Run( "tdm_FlagNeutral", 1, v, allplys )
							updateNumber( v[ 1 ], v[ 4 ] )
							status[ v[ 1 ] ] = 0
						elseif status[ v[ 1 ] ] == 0 then
							v[ 4 ] = v[ 4 ] + 1
							updateNumber( v[ 1 ], v[ 4 ] )
						end
					end
				elseif vv:Team() == 2 then --blue team
					if v[ 4 ] - 1 > -10 and v[ 4 ] - 1 ~= 0 then
						v[ 4 ] = v[ 4 ] - 1
						updateNumber( v[ 1 ], v[ 4 ] )					
					elseif v[ 4 ] - 1 < -10 then
						v[ 4 ] = -10
						updateNumber( v[ 1 ], v[ 4 ] )						
					elseif v[ 4 ] - 1 == -10 then
						if status[ v[ 1 ] ] == 0 then
							v[ 4 ] = -10
							local allplys = {}
							for t, y in next, player.GetAll() do
								if tab[ y ] == v[ 1 ] and y:Team() == 2 then
									table.insert( allplys, y )
								end
							end
							hook.Run( "tdm_FlagCaptured", 2, v, allplys )	
							updateNumber( v[ 1 ], v[ 4 ] )		
							status[ v[ 1 ] ] = -1
						elseif status[ v[ 1 ] ] == -1 then
							v[ 4 ] = -10
							local allplys = {}
							for t, y in next, player.GetAll() do
								if tab[ y ] == v[ 1 ] and y:Team() == 2 then
									table.insert( allplys, y )
								end
							end
							hook.Run( "tdm_FlagSaved", 1, v, allplys )
							updateNumber( v[ 1 ], v[ 4 ] )	
						end
					elseif v[ 4 ] - 1 == 0 then
						if status[ v[ 1 ] ] ~= 0 then
							v[ 4 ] = v[ 4 ] - 1
							local allplys = {}
							for t, y in next, player.GetAll() do
								if tab[ y ] == v[ 1 ] and y:Team() == 2 then
									table.insert( allplys, y )
								end
							end
							hook.Run( "tdm_FlagNeutral", 2, v, allplys )
							updateNumber( v[ 1 ], v[ 4 ] )	
							status[ v[ 1 ] ] = 0
						elseif status[ v[ 1 ] ] == 0 then
							v[ 4 ] = v[ 4 ] - 1
							updateNumber( v[ 1 ], v[ 4 ] )
						end
					end
				end
			end
		end
	end
end )

hook.Add( "Think", "tdm_checkpos", function()
	for k, v in next, curmap do
		for q, w in next, player.GetAll() do
			if w:GetPos():Distance( v[ 2 ] ) <= v[ 3 ] then
				if w:Alive() then
					if not w.spawning then
						if tab[ w ] ~= v[ 1 ] then
							tab[ w ] = v[ 1 ]
							hook.Run( "tdm_FlagCapStart", w, tab[ w ] )
							umsg.Start( "UpdateNumber", w )
								umsg.String( tostring( v[ 4 ] ) )
							umsg.End()		
						end
					end
				else
					if tab[ w ] == v[ 1 ] then
						hook.Run( "tdm_FlagCapEnd", w, tab[ w ] )
						tab[ w ] = 0
						umsg.Start( "UpdateNumber", w )
							umsg.String( "69" )
						umsg.End()
					end
				end					
			elseif w:GetPos():Distance( v[ 2 ] ) > v[ 3 ] then
				if tab[ w ] == v[ 1 ] then
					hook.Run( "tdm_FlagCapEnd", w, tab[ w ] )
					tab[ w ] = 0
					umsg.Start( "UpdateNumber", w )
						umsg.String( "69" )
					umsg.End()
				end
			end
		end
	end
end )

hook.Add( "PlayerSpawn", "SendFlags", function( ply )
	net.Start( "SendFlags" )
		net.WriteTable( curmap )
		net.WriteTable( status )
	net.Send( ply )
end )

/*hook.Add( "tdm_FlagCaptured", "tdm_flagcapped", function( t, flag, plys )
	net.Start( "SendFlags" )
		net.WriteTable( curmap )
		net.WriteTable( status )
	net.Broadcast()
	for k, v in next, plys do --If friendlies capture a point
		if (v:Team() == 1) then
		if (flag[ 1 ] == "A") then
				v:SendLua([[surface.PlaySound( "pointscaptured2/capturedalpha"..math.random(1, 3)..".ogg" )]])
			elseif (flag[ 1 ] == "B") then
				v:SendLua([[surface.PlaySound( "pointscaptured2/capturedbravo"..math.random(1, 3)..".ogg" )]])
			elseif (flag[ 1 ] == "C") then
				v:SendLua([[surface.PlaySound( "pointscaptured2/capturedcharlie"..math.random(1, 3)..".ogg" )]])
			elseif (flag[ 1 ] == "D") then
				v:SendLua([[surface.PlaySound( "pointscaptured2/captureddelta"..math.random(1, 3)..".ogg" )]])
			elseif (flag[ 1 ] == "E") then
				v:SendLua([[surface.PlaySound( "pointscaptured2/capturedecho"..math.random(1, 3)..".ogg" )]])
			elseif (flag[ 1 ] == "F") then
				v:SendLua([[surface.PlaySound( "pointscaptured2/capturedfoxtrot"..math.random(1, 3)..".ogg" )]])
			elseif (flag[ 1 ] == "G") then
				v:SendLua([[surface.PlaySound( "pointscaptured2/capturedgolf"..math.random(1, 3)..".ogg" )]])
			elseif (flag[ 1 ] == "H") then
				v:SendLua([[surface.PlaySound( "pointscaptured2/capturedhotel"..math.random(1, 3)..".ogg" )]])
			elseif (flag[ 1 ] == "I") then
				v:SendLua([[surface.PlaySound( "pointscaptured2/capturedindia"..math.random(1, 3)..".ogg" )]])
			elseif (flag[ 1 ] == "J") then
				v:SendLua([[surface.PlaySound( "pointscaptured2/capturedjuliet"..math.random(1, 3)..".ogg" )]])
			end
		elseif (v:Team() == 2) then
		if (flag[ 1 ] == "A") then
				v:SendLua([[surface.PlaySound( "pointscaptured/capturedalpha"..math.random(1, 3)..".ogg" )]])
			elseif (flag[ 1 ] == "B") then
				v:SendLua([[surface.PlaySound( "pointscaptured/capturedbravo"..math.random(1, 3)..".ogg" )]])
			elseif (flag[ 1 ] == "C") then
				v:SendLua([[surface.PlaySound( "pointscaptured/capturedcharlie"..math.random(1, 3)..".ogg" )]])
			elseif (flag[ 1 ] == "D") then
				v:SendLua([[surface.PlaySound( "pointscaptured/captureddelta"..math.random(1, 3)..".ogg" )]])
			elseif (flag[ 1 ] == "E") then
				v:SendLua([[surface.PlaySound( "pointscaptured/capturedecho"..math.random(1, 3)..".ogg" )]])
			elseif (flag[ 1 ] == "F") then
				v:SendLua([[surface.PlaySound( "pointscaptured/capturedfoxtrot"..math.random(1, 3)..".ogg" )]])
			elseif (flag[ 1 ] == "G") then
				v:SendLua([[surface.PlaySound( "pointscaptured/capturedgolf"..math.random(1, 3)..".ogg" )]])
			elseif (flag[ 1 ] == "H") then
				v:SendLua([[surface.PlaySound( "pointscaptured/capturedhotel"..math.random(1, 3)..".ogg" )]])
			elseif (flag[ 1 ] == "I") then
				v:SendLua([[surface.PlaySound( "pointscaptured/capturedindia"..math.random(1, 3)..".ogg" )]])
			elseif (flag[ 1 ] == "J") then
				v:SendLua([[surface.PlaySound( "pointscaptured/capturedjuliet"..math.random(1, 3)..".ogg" )]])
			end
		end
		AddNotice(v, "FLAG CAPTURED", SCORECOUNTS.FLAG_CAPTURED, NOTICETYPES.FLAG)
		AddRewards(v, SCORECOUNTS.FLAG_CAPTURED)
		hook.Run( "MatchHistory_Capture", v )
		umsg.Start( "friendlyflagcaptured", v )
			umsg.String( flag[ 1 ] )
		umsg.End()
	end
	for k, v in next, player.GetAll() do
		if v:Team() ~= t and v:Team() ~= 0 then
			if (v:Team() == 1) then
			if (flag[ 1 ] == "A") then
				v:SendLua([[surface.PlaySound( "pointscaptured2/lostalpha"..math.random(1, 3)..".ogg" )]])
			elseif (flag[ 1 ] == "B") then
				v:SendLua([[surface.PlaySound( "pointscaptured2/lostbravo"..math.random(1, 3)..".ogg" )]])
			elseif (flag[ 1 ] == "C") then
				v:SendLua([[surface.PlaySound( "pointscaptured2/lostcharlie"..math.random(1, 3)..".ogg" )]])
			elseif (flag[ 1 ] == "D") then
				v:SendLua([[surface.PlaySound( "pointscaptured2/lostdelta"..math.random(1, 3)..".ogg" )]])
			elseif (flag[ 1 ] == "E") then
				v:SendLua([[surface.PlaySound( "pointscaptured2/lostecho"..math.random(1, 3)..".ogg" )]])
			elseif (flag[ 1 ] == "F") then
				v:SendLua([[surface.PlaySound( "pointscaptured2/lostfoxtrot"..math.random(1, 3)..".ogg" )]])
			elseif (flag[ 1 ] == "G") then
				v:SendLua([[surface.PlaySound( "pointscaptured2/lostgolf"..math.random(1, 3)..".ogg" )]])
			elseif (flag[ 1 ] == "H") then
				v:SendLua([[surface.PlaySound( "pointscaptured2/losthotel"..math.random(1, 3)..".ogg" )]])
			elseif (flag[ 1 ] == "I") then
				v:SendLua([[surface.PlaySound( "pointscaptured2/lostindia"..math.random(1, 3)..".ogg" )]])
			elseif (flag[ 1 ] == "J") then
				v:SendLua([[surface.PlaySound( "pointscaptured2/lostjuliet"..math.random(1, 3)..".ogg" )]])
			end
		elseif (v:Team() == 2) then
			if (flag[ 1 ] == "A") then
				v:SendLua([[surface.PlaySound( "pointscaptured/lostalpha"..math.random(1, 3)..".ogg" )]])
			elseif (flag[ 1 ] == "B") then
				v:SendLua([[surface.PlaySound( "pointscaptured/lostbravo"..math.random(1, 3)..".ogg" )]])
			elseif (flag[ 1 ] == "C") then
				v:SendLua([[surface.PlaySound( "pointscaptured/lostcharlie"..math.random(1, 3)..".ogg" )]])
			elseif (flag[ 1 ] == "D") then
				v:SendLua([[surface.PlaySound( "pointscaptured/lostdelta"..math.random(1, 3)..".ogg" )]])
			elseif (flag[ 1 ] == "E") then
				v:SendLua([[surface.PlaySound( "pointscaptured/lostecho"..math.random(1, 3)..".ogg" )]])
			elseif (flag[ 1 ] == "F") then
				v:SendLua([[surface.PlaySound( "pointscaptured/lostfoxtrot"..math.random(1, 3)..".ogg" )]])
			elseif (flag[ 1 ] == "G") then
				v:SendLua([[surface.PlaySound( "pointscaptured/lostgolf"..math.random(1, 3)..".ogg" )]])
			elseif (flag[ 1 ] == "H") then
				v:SendLua([[surface.PlaySound( "pointscaptured/losthotel"..math.random(1, 3)..".ogg" )]])
			elseif (flag[ 1 ] == "I") then
				v:SendLua([[surface.PlaySound( "pointscaptured/lostindia"..math.random(1, 3)..".ogg" )]])
			elseif (flag[ 1 ] == "J") then
				v:SendLua([[surface.PlaySound( "pointscaptured/lostjuliet"..math.random(1, 3)..".ogg" )]])
			end
		end
			umsg.Start( "enemyflagcaptured", v )
				umsg.String( flag[ 1 ] )
			umsg.End()		
		end		
	end
end )*/

hook.Add( "tdm_FlagNeutral", "tdm_flagneutral", function( t, flag, plys )
	for k, v in next, plys do
        AddNotice(v, "FLAG NEUTRALIZED", SCORECOUNTS.FLAG_NEUTRALIZED, NOTICETYPES.FLAG)
		AddRewards(v, SCORECOUNTS.FLAG_NEUTRALIZED)
		hook.Run( "MatchHistory_Neutral", v )
	end
	net.Start( "SendFlags" )
		net.WriteTable( curmap )
		net.WriteTable( status )
	net.Broadcast()		
end )

hook.Add( "tdm_FlagSaved", "tdm_flagsaved", function( t, flag, plys )
	for k, v in next, plys do
        AddNotice(v, "FLAG SAVED", SCORECOUNTS.FLAG_SAVED, NOTICETYPES.FLAG)
		AddRewards(v, SCORECOUNTS.FLAG_SAVED)
	end		
	net.Start( "SendFlags" )
		net.WriteTable( curmap )
		net.WriteTable( status )
	net.Broadcast()		
end )

timer.Create( "FlagRewards", 10, 0, function()
	local numFlags = #flags[ game.GetMap() ]
	if numFlags == 0 then
		return
	end
	local redFlags = 0
	local blueFlags = 0
	local neutralFlags = 0
	for k, v in next, flags[ game.GetMap() ] do
		if status[ v[ 1 ] ] == 1 then
			redFlags = redFlags + 1
		elseif status[ v[ 1 ] ] == -1 then
			blueFlags = blueFlags + 1
		elseif status[ v[ 1 ] ] == 0 then
			neutralFlags = neutralFlags + 1
		end
	end
	if redFlags > blueFlags and redFlags > numFlags / 2 then
		SetGlobalInt( "control", 1 )
	elseif blueFlags > redFlags and blueFlags > numFlags / 2 then
		SetGlobalInt( "control", 2 )
	else
		SetGlobalInt( "control", 0 )
	end
	if redFlags == numFlags then
		SetGlobalInt( "allcontrol", 1 )
	elseif blueFlags == numFlags then
		SetGlobalInt( "allcontrol", 2 )
	else
		SetGlobalInt( "allcontrol", 0 )
	end
	
	if GetGlobalInt( "control" ) == 1 then
		if GetGlobalInt( "allcontrol" ) == 1 then
			for k, v in next, player.GetAll() do
				if v:Team() == 1 then
					AddMoney( v, 20 )
					lvl.AddEXP( v, 20 )
					v:AddScore( 20 )
				end
			end
		else
			for k, v in next, player.GetAll() do
				if v:Team() == 1 then
					AddMoney( v, 10 )
					lvl.AddEXP( v, 10 )
					v:AddScore( 10 )
				end
			end
		end
	elseif GetGlobalInt( "control" ) == 2 then
		if GetGlobalInt( "allcontrol" ) == 2 then
			for k, v in next, player.GetAll() do
				if v:Team() == 2 then
					AddMoney( v, 20 )
					lvl.AddEXP( v, 20 )
					v:AddScore( 20 )
				end
			end
		else
			for k, v in next, player.GetAll() do
				if v:Team() == 2 then
					AddMoney( v, 10 )
					lvl.AddEXP( v, 10 )
					v:AddScore( 10 )
				end
			end
		end
	end
	
end )

timer.Create( "FixFlags", 5, 0, function()
	net.Start( "SendFlags" )
		net.WriteTable( curmap )
		net.WriteTable( status )
	net.Broadcast()	
end )

local capture = capture or {}
for k, v in next, curmap do
	capture[ v[ 1 ] ] = {}
end

util.AddNetworkString( "BroadcastCaptures" )
function BroadcastCaptures()
	net.Start( "BroadcastCaptures" )
		net.WriteTable( capture )
	net.Broadcast()
end

hook.Add( "tdm_FlagCapStart", "tdm_startcap", function( ply, name )
	if not table.HasValue( capture[ name ], ply ) then
		table.insert( capture[ name ], ply )
		BroadcastCaptures()
	end
end )

hook.Add( "tdm_FlagCapEnd", "tdm_stopcap", function( ply, name )
	local key = table.KeyFromValue( capture[ name ], ply )
	table.remove( capture[ name ], key )
	BroadcastCaptures()
end )

hook.Add( "Think", "SetFlagStatuses", function()
	for k, v in next, curmap do
		local n = v[ 1 ]
		if #capture[ n ] > 0 then
			local plys = capture[ n ]
			if status[ n ] ~= 0 then
				for k1, v1 in next, plys do
					if not ( v1 and IsValid( v1 ) and v1 ~= NULL ) then 
						continue 
					end
					if v1:Team() == 0 then
						continue
					end
					if ( status[ n ] == 1 and v1:Team() == 2 ) or ( status[ n ] == 2 and v1:Team() == 1 ) then
						if capture[ n ].capturing and capture[ n ].capturing ~= true and status[ n ] ~= 10 and status[ n ] ~= -10 then
							capture[ n ].capturing = true
							BroadcastCaptures()
						end
						break
					elseif status[ n ] == 0 then
						if capture[ n ].capturing and capture[ n ].capturing ~= true and status[ n ] ~= 10 and status[ n ] ~= -10 then
							capture[ n ].capturing = true
							BroadcastCaptures()
						end
						break	
					end
					if capture[ n ].capturing and capture[ n ].capturing ~= false then
						capture[ n ].capturing = false
						BroadcastCaptures()
					end
				end
			elseif status[ n ] == 0 then
				if #plys > 0 then
					if capture[ n ].capturing and capture[ n ].capturing ~= true then
						capture[ n ].capturing = true
						BroadcastCaptures()
					end	
				else
					if capture[ n ].capturing and capture[ n ].capturing ~= false then
						capture[ n ].capturing = false
						BroadcastCaptures()
					end		
				end
			end
		else
			if capture[ n ].capturing ~= false then
				capture[ n ].capturing = false
				BroadcastCaptures()
			end
		end
	end
end )
