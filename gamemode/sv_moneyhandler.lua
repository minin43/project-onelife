util.AddNetworkString( "SendInitialMoney" )
util.AddNetworkString( "SendMoneyUpdate" )
util.AddNetworkString( "RequestMoney" )
util.AddNetworkString( "GetMoney" )
util.AddNetworkString( "RequestMoneyCallback" )
util.AddNetworkString( "GetMoneyCallback" )
util.AddNetworkString( "BuyAttachment" )
util.AddNetworkString( "BuyAttachmentCallback" )

function id( steamid )
	local x = string.gsub( steamid, ":", "x" )
	return x
end

function unid( steamid )
	local x = string.gsub( steamid, "x", ":" )
	return string.upper( x )
end

function GetMoney( ply )
	if not ply:GetPData( "pol_money" ) then
		ply:SetPData( "pol_money", "0" )
	end
	
	return tonumber( ply:GetPData( "pol_money" ) )
end

function AddMoney( ply, amt )
	if ply and IsValid( ply ) then
		local group = ply:GetNWString( "usergroup" )
		local mult = 1
		for k, v in next, lvl.VIPGroups do
			if v[ 1 ] == group then
				mult = v[ 2 ]
			end
		end
		ply:SetPData( "pol_money", GetMoney( ply ) + ( amt * mult) )
		SendUpdate( ply )
	end
end

function SetMoney( ply, num )
	ply:SetPData( "pol_money", num )
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

net.Receive( "BuyAttachment", function( len, ply )
	local attach = net.ReadString()
	local price = tonumber( net.ReadString() )
	price = -price
	AddMoney( ply, price )
	local tab = util.JSONToTable( file.Read( "onelife/users/" .. id( ply:SteamID() ) .. ".txt", "DATA" ) )
	local attachtab = tab[ 2 ]
	table.insert( attachtab, attach )
	local new = util.TableToJSON( { tab[ 1 ], attachtab } )
	file.Write( "onelife/users/" .. id( ply:SteamID() ) .. ".txt", new )
	timer.Simple( 0.1, function()
		local cur = GetMoney( ply )
		net.Start( "BuyAttachmentCallback" )
			net.WriteString( tostring( cur ) )
		net.Send( ply )
	end )
end )

--[[hook.Add( "PlayerDeath", "onelife_playerdeath_money", function( ply, _, att )
	if ply:IsValid() and ply:IsPlayer() and att:IsValid() and att:IsPlayer() then
		AddMoney( att, 100 )
		att:AddScore( 100 )
	end
end )]]