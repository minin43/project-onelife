print( "sv_moneyhandler initialization..." )
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

function GM:GetMoney( ply )
	if not ply:GetPData( "pol_money" ) then
		ply:SetPData( "pol_money", "0" )
	end
	
	return tonumber( ply:GetPData( "pol_money" ) )
end

function GM:AddMoney( ply, amt )
	if ply and IsValid( ply ) then
		local group = ply:GetNWString( "usergroup" )
		local mult = 1
		if amt > 0 then
			for k, v in next, GM.lvl.VIPGroups do
				if v[ 1 ] == group then
					mult = v[ 2 ]
				end
			end
		end
		ply:SetPData( "pol_money", self.GetMoney( ply ) + ( amt * mult) )
		self.SendUpdate( ply )
	end
end

function GM:SetMoney( ply, num )
	ply:SetPData( "pol_money", num )
	self.SendUpdate( ply )
end

function GM:SendUpdate( ply )
	net.Start( "SendMoneyUpdate" )
		net.WriteString( self.GetMoney( ply ) )
	net.Send( ply )
end

hook.Add( "PlayerSpawn", "tdm_initialspawn", function( ply )
	net.Start( "SendInitialMoney" )
		net.WriteString( GM:GetMoney( ply ) )
	net.Send( ply )
end )

net.Receive( "RequestMoney", function( len, ply )
	local num = GM:GetMoney( ply )
	
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
	
	local newfile = util.TableToJSON( original ) --{ original[ 1 ], currentattachments } )
	file.Write( "onelife/users/" .. id( ply:SteamID() ) .. ".txt", newfile )

	price = -price
	GM:AddMoney( ply, price )

	timer.Simple( 0.1, function()
		local cur = GM:GetMoney( ply )
		net.Start( "BuyAttachmentCallback" )
			net.WriteString( tostring( cur ) )
		net.Send( ply )
	end )
end )