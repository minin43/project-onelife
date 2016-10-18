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
	local parentwep = net.ReadString()
	local attachment = net.ReadString()
	--local attachmenttype = net.ReadString()
	local price = tonumber( net.ReadString() )

	local original = util.JSONToTable( file.Read( "onelife/users/" .. id( ply:SteamID() ) .. ".txt", "DATA" ) )
	if original[ 2 ][ parentwep ] then
		table.insert( original[ 2 ][ parentwep ], attachment )
	else
		original[ 2 ][ parentwep ] = { attachment }
	end
	PrintTable( original )

	--[[local parentweptable = original[ 2 ][ parentwep ] or { }
	print("pre-editted original")
	PrintTable( original )
	print("pre-editted parentweptable")
	PrintTable( parentweptable )

	table.insert( , attachment )
	print("parentweptable editted:")
	PrintTable( parentweptable )
	if original[ 2 ][ parentwep ] then 
		table.Empty( original[ 2 ][ parentwep ] )
		table.insert( original[ 2 ][ parentwep ], parentweptable )
	else
		original[ 2 ][ parentwep ] = parentweptable
	end

	print( "The editted table to be made into a JSON string" )
	PrintTable( original )]]
	local newfile = util.TableToJSON( original ) --{ original[ 1 ], currentattachments } )
	file.Write( "onelife/users/" .. id( ply:SteamID() ) .. ".txt", newfile )

	price = -price
	AddMoney( ply, price )

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