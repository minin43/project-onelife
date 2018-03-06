print( "sv_lvlhandler initialization..." )
util.AddNetworkString( "SendUpdate" )
util.AddNetworkString( "RequestLevel" )
util.AddNetworkString( "RequestLevelCallback" )

GM.lvl = {}
GM.lvl.levels = {}
GM.lvl.exp = 500

GM.lvl.VIPGroups = { --This is a point-earning multiplier, adjust accordingly
	{ "vip", 1.10 },
	{ "vip+", 1.20 }
	--anything else?
}

for i = 1, 8 do
	GM.lvl.levels[ i ] = i * GM.lvl.exp
end

for i = 9, 16 do
	GM.lvl.levels[ i ] = i * GM.lvl.exp * GM.lvl.exp
end

GM.lvl.maxlevel = #GM.lvl.levels
GM.lvl.maxlevelexp = GM.lvl.levels[ GM.lvl.maxlevel ]
	
function GM.lvl:GetLevel( ply )
	return tonumber( ply:GetPData( "level" ) )
end
	
function GM.lvl:GetEXP( ply )
	return tonumber( ply:GetPData( "exp" ) )
end

--I would delete this but it's useful for making an "experience bar"
function GM.lvl:GetAmountForLevel( num )
	return self.levels[ num ]
end
	
function GM.lvl:SendUpdate( ply )
	local curlvl = self:GetLevel( ply )
	local curexp = self:GetEXP( ply )
	local nextexp = self:GetAmountForLevel( curlvl )
	net.Start( "SendUpdate" )
		net.WriteString( tostring( curlvl ) )
		net.WriteString( tostring( curexp ) )
		net.WriteString( tostring( nextexp ) )
	net.Send( ply )
end

function GM.lvl:SetLevel( ply, num )
	ply:SetPData( "level", tostring( num ) )
	ply:SetPData( "exp", "0" )
	ply:SetNWString( "level", tostring( num ) )
end

function GM.lvl:SetEXP( ply, num )
	ply:SetPData( "exp", tostring( num ) )
end
	
function GM.lvl:AddEXP( ply, num )
	local group = ply:GetUserGroup()
	local exp = self:GetEXP( ply )
	local mult = 1
	for k, v in next, self.VIPGroups do
		if v[ 1 ] == group then
			mult = v[ 2 ]
		end
	end
	self:SetEXP( ply, ( ( num * mult ) + exp ) )
	self:CheckLvlUp( ply )
	ply:SetNWString( "level", self:GetLevel( ply ) ) --Is this needed?
end

function GM.lvl:CheckLvlUp( ply )
	local exp = self:GetEXP( ply )
	local level = self:GetLevel( ply )
	if exp > self.levels[ level ] then
		self:SetEXP( ply, ( exp - self.levels[ level ] ) )
		self:SetLevel( ply, ( level + 1 ) )
		hook.Run( "LevelUp", ply, level + 1 )
		if self:GetEXP( ply ) > self.levels[ self:GetLevel( ply ) ] then
			self:CheckLvlUp( ply )
		end
	end
end

net.Receive( "RequestLevel", function( len, ply )
	local level = GAMEMODE.lvl:GetLevel( ply ) or 1
	net.Start( "RequestLevelCallback" )
		net.WriteString( tostring( level ) )
	net.Send( ply )
end )

hook.Add( "PlayerInitialSpawn", "lvl.SendInitialLevel", function( ply )
	timer.Simple( 5, function()
		if not ply:GetPData( "level" ) then
			GAMEMODE.lvl:SetLevel( ply, 1 )
			GAMEMODE.lvl:SetEXP( ply, 0 )
		end
		
		GAMEMODE.lvl:SendUpdate( ply )
		ply:SetNWString( "level", GAMEMODE.lvl:GetLevel( ply ) )
	end )
end )

hook.Add( "LevelUp", "OnLevelUp", function( ply, newlv )
	local color_green = Color( 102, 255, 51 )
	local color_white = Color( 255, 255, 255 )

	if GAMEMODE.lvl:GetLevel( ply ) >= #GAMEMODE.Roles then
		ULib.tsayColor( nil, true, color_green, ply:Nick(), color_white, " leveled up to ", color_green, "Level " .. tostring( newlv ), color_white, "." )
		for k, v in next, player.GetAll() do
			v:ChatPrint( tostring( ply:Nick() ) .. " leveled up to level " .. tostring( newlv ) )
			v:SendLua([[surface.PlaySound( "misc/levelup.wav" )]])
		end
	else
		ply:ChatPrint( "You leveled up to level " .. tostring( newlv ) )
		ULib.tsayColor( ply, true, color_green, "You ", color_white, "leveled up to ", color_green, "Level " .. tostring( newlv ), color_white, "." )
		ply:SendLua([[surface.PlaySound( "misc/levelup.wav" )]])
	end
end )

concommand.Add( "lvl_refresh", function( ply )
	GAMEMODE.lvl:SendUpdate( ply )
end )

concommand.Add( "lvl_debug_global_reset", function( ply )
	if ply:IsValid() and not ply:IsSuperAdmin() then 
		return 
	end
	
	for k, v in next, player.GetAll() do
		v:RemovePData( "level" )
		v:RemovePData( "exp" )
		GAMEMODE.lvl:SetLevel( v, 1 )
		GAMEMODE.lvl:SetEXP( v, 0 )
		GAMEMODE.lvl:SendUpdate( v )
	end
end )