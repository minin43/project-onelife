util.AddNetworkString( "SendUpdate" )
util.AddNetworkString( "RequestLevel" )
util.AddNetworkString( "RequestLevelCallback" )

lvl = {}

lvl.levels = {}
	
lvl.exp = 500

lvl.VIPGroups = { --This is a multiplier, adjust accordingly
	{ "vip", 1.10 },
	{ "vip+", 1.20 }
	--anything else?
}

for i = 1, 8 do
	lvl.levels[ i ] = i * lvl.exp
end

for i = 9, 16 do
	lvl.levels[ i ] = i * lvl.exp * lvl.exp
end

lvl.maxlevel = #lvl.levels
lvl.maxlevelexp = lvl.levels[ lvl.maxlevel ]
	
function lvl.GetLevel( ply )
	return tonumber( ply:GetPData( "level" ) )
end
	
function lvl.GetEXP( ply )
	return tonumber( ply:GetPData( "exp" ) )
end

--I would delete this but it's useful for making an "experience bar"
function lvl.GetAmountForLevel( num )
	return lvl.levels[ num ]
end
	
function lvl.SendUpdate( ply )
	local curlvl = lvl.GetLevel( ply )
	local curexp = lvl.GetEXP( ply )
	local nextexp = lvl.GetAmountForLevel( curlvl )
	net.Start( "SendUpdate" )
		net.WriteString( tostring( curlvl ) )
		net.WriteString( tostring( curexp ) )
		net.WriteString( tostring( nextexp ) )
	net.Send( ply )
end

function lvl.SetLevel( ply, num )
	ply:SetPData( "level", tostring( num ) )
	ply:SetPData( "exp", "0" )
	ply:SetNWString( "level", tostring( num ) )
end

function lvl.SetEXP( ply, num )
	ply:SetPData( "exp", tostring( num ) )
end
	
function lvl.AddEXP( ply, num )
	local group = ply:GetUserGroup()
	local exp = lvl.GetEXP( ply )
	local mult = 1
	for k, v in next, lvl.VIPGroups do
		if v[ 1 ] == group then
			mult = v[ 2 ]
		end
	end
	lvl.SetEXP( ply, ( ( num * mult ) + exp ) )
	lvl.CheckLvlUp( ply )
	ply:SetNWString( "level", lvl.GetLevel( ply ) ) --Is this needed?
end

function lvl.CheckLvlUp( ply )
	local exp = lvl.GetEXP( ply )
	local level = lvl.GetLevel( ply )
	if exp > lvl.levels[ level ] then
		lvl.SetEXP( ply, ( exp - lvl.levels[ level ] ) )
		lvl.SetLevel( ply, ( level + 1 ) )
		hook.Run( "LevelUp", ply, level + 1 )
		if lvl.GetEXP( ply ) > lvl.levels[ lvl.GetLevel( ply ) ] then
			lvl.CheckLvlUp( ply )
		end
	end
end

net.Receive( "RequestLevel", function( len, ply )
	local level = lvl.GetLevel( ply ) or 1
	net.Start( "RequestLevelCallback" )
		net.WriteString( tostring( level ) )
	net.Send( ply )
end )


hook.Add( "PlayerInitialSpawn", "lvl.SendInitialLevel", function( ply )
	timer.Simple( 5, function()
		if not ply:GetPData( "level" ) then
			lvl.SetLevel( ply, 1 )
			lvl.SetEXP( ply, 0 )
		end
		
		lvl.SendUpdate( ply )
		ply:SetNWString( "level", lvl.GetLevel( ply ) )
	end )
end )
	
hook.Add( "LevelUp", "OnLevelUp", function( ply, newlv )
	local color_green = Color( 102, 255, 51 )
	local color_white = Color( 255, 255, 255 )

	if lvl.GetLevel( ply ) >= #roles then
		ULib.tsayColor( nil, true, color_green, ply:Nick(), color_white, " leveled up to ", color_green, "Level " .. tostring( newlv ), color_white, "." )
		for k, v in next, player.GetAll() do
			--v:ChatPrint( tostring( ply:Nick() ) .. " leveled up to level " .. tostring( newlv ) )
			v:SendLua([[surface.PlaySound( "ui/UX_InGame_Unlock_Promotion_Wave.mp3" )]])
		end
	else
		--ply:ChatPrint( "You leveled up to level " .. tostring( newlv ) )
		ULib.tsayColor( ply, true, color_green, "You ", color_white, "leveled up to ", color_green, "Level " .. tostring( newlv ), color_white, "." )
		ply:SendLua([[surface.PlaySound( "ui/UI_Awards_Basic_wav.mp3" )]])
	end
end )
	
concommand.Add( "lvl_refresh", function( ply )
	lvl.SendUpdate( ply )
end )
	
concommand.Add( "lvl_debug_reset", function( ply )
	if ply:IsValid() and not ply:IsSuperAdmin() then 
		return 
	end
	
	for k, v in next, player.GetAll() do
		v:RemovePData( "level" )
		v:RemovePData( "exp" )
		lvl.SetLevel( v, 1 )
		lvl.SetEXP( v, 0 )
		lvl.SendUpdate( v )		
	end
end )