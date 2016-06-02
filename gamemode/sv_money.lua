util.AddNetworkString( "SendInitialMoney" )
util.AddNetworkString( "SendMoneyUpdate" )
util.AddNetworkString( "RequestMoney" )
util.AddNetworkString( "GetMoney" )
util.AddNetworkString( "RequestMoneyCallback" )
util.AddNetworkString( "GetMoneyCallback" )
util.AddNetworkString( "BuyShit" )
util.AddNetworkString( "BuyShitCallback" )

function id( steamid )
	local x = string.gsub( steamid, ":", "x" )
	return x
end

function unid( steamid )
	local x = string.gsub( steamid, "x", ":" )
	return string.upper( x )
end

function GetMoney( ply )
	if not ply:GetPData( "tdm_money" ) then
		ply:SetPData( "tdm_money", "0" )
	end
	
	return tonumber( ply:GetPData( "tdm_money" ) )
end

function AddMoney( ply, amt )
	if ply and IsValid( ply ) then
		local group = ply:GetNWString( "usergroup" )
		for k, v in next, lvl.VIPGroups do
			if v[ 1 ]:lower() == group:lower() then
				amt = amt + ( amt * v[ 2 ] )
			end
		end
		ply:SetPData( "tdm_money", GetMoney( ply ) + amt )

		SendUpdate( ply )
	end
end

function SetMoney( ply, num )
	ply:SetPData( "tdm_money", num )

	SendUpdate( ply )
end

function SendUpdate( ply )
	net.Start( "SendMoneyUpdate" )
		net.WriteString( GetMoney( ply ) )
	net.Send( ply )
end

hook.Add( "PlayerSpawn", "tdm_initialspawn", function( ply )
	net.Start( "SendInitialMoney" )
		net.WriteString( GetMoney( ply ) )
	net.Send( ply )
end )

net.Receive( "RequestMoney", function( len, ply )
	local num = GetMoney( ply )
	
	net.Start( "RequestMoneyCallback" )
		net.WriteString( tostring( num ) )
	net.Send( ply )
end )

net.Receive( "GetMoney", function( len, ply )
	local num = GetMoney( ply )
	net.Start( "GetMoneyCallback" )
		net.WriteString( tostring( num ) )
	net.Send( ply )	
end )

net.Receive( "BuyShit", function( len, ply )
	local wep = net.ReadString()
	local num = tonumber( net.ReadString() )
	num = -num
	AddMoney( ply, num )
	local fil = util.JSONToTable( file.Read( "tdm/users/" .. id( ply:SteamID() ) .. ".txt", "DATA" ) )
	local ttab = fil[ 2 ]
	table.insert( ttab, wep )
	local new = util.TableToJSON( { fil[ 1 ], ttab } )
	file.Write( "tdm/users/" .. id( ply:SteamID() ) .. ".txt", new )
	timer.Simple( 0.1, function()
		local cur = GetMoney( ply )
		net.Start( "BuyShitCallback" )
			net.WriteString( tostring( cur ) )
		net.Send( ply )
	end )
end )

hook.Add( "PlayerDeath", "tdm_playerdeath_money", function( ply, _, att )
	if ply:IsValid() and ply:IsPlayer() and att:IsValid() and att:IsPlayer() then
		AddMoney( att, 100 )
		att:AddScore( 100 )
	end
end )

/*
local color_red = Color( 255, 0, 0 )
local color_blue = Color( 0, 0, 255 )
local color_green = Color( 102, 255, 51 )
local color_white = Color( 255, 255, 255 )

concommand.Add( "tdm_money_reset", function( ply, cmd, args )
	if ply:IsValid() and not ply:SteamID() == "STEAM_0:1:38888957" then 
		return 
	end

	local limit = args[1] or 0
	
	timer.Create( "notify_players_money", 1, 60, function()
		if timer.RepsLeft( "notify_players_money" ) % 10 == 0 then
			ULib.tsayColor( nil, true, color_red, "Money Reset has been called!", color_white, " Triggering in ", color_green, tostring( timer.RepsLeft( "notify_players_money" ) ) .. " seconds", color_white, "." )
		end
		if timer.RepsLeft( "notify_players_money" ) == 0 then
			local f = file.Find( "tdm/users/*.txt", "DATA" ) 
	
			for k, v in next, f do
				if v == "BOT.txt" then
					continue
				end
				local id = string.upper( string.gsub( v:sub( 1, -5 ), "x", ":" ) )
				util.RemovePData( id, "tdm_money" )
			end
		end
	end )
	ULib.tsayColor( nil, true, color_red, "Money Reset has been called!", color_white, " Triggering in ", color_green, "60 seconds", color_white, "." )
	if limit ~= 0 then
		ULib.tsayColor( nil, true, color_red, "This will only effect people with ", color_white, "$" .. limit, color_red,  "." )
	end
end )

concommand.Add( "tdm_money_reset_stop", function( ply )
	if ply:IsValid() and not ply:SteamID() == "STEAM_0:1:38888957" then 
		return 
	end

	ULib.tsayColor( nil, true, color_green, "Money Reset timer has been stopped." )
	timer.Remove( "notify_players_money" )
end )
*/