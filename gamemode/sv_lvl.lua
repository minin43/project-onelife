util.AddNetworkString( "SendUpdate" )

local color_red = Color( 255, 0, 0 )
local color_blue = Color( 0, 0, 255 )
local color_green = Color( 102, 255, 51 )
local color_white = Color( 255, 255, 255 )

lvl = {}

lvl.levels = {}
	
lvl.expmul = 300

lvl.VIPGroups = {
	{ "vip", .10 },
	{ "vip+", .25 },
	{ "ultravip", .25 },
	{ "coowner", .5 },
	{ "owner", .5 },
	{ "creator", .5 }
}
	
for i = 1, 100 do
	lvl.levels[ i ] = i * lvl.expmul
end

-- "prestige"
for i = 101, 200 do
	lvl.levels[ i ] = 30000 * ( ( i - 100 ) ^ 2 )
end

lvl.maxlevel = #lvl.levels
lvl.maxlevelexp = lvl.levels[ lvl.maxlevel ]
	
function lvl.GetLevel( ply )
	return tonumber( ply:GetPData( "level" ) )
end
	
function lvl.GetEXP( ply )
	return tonumber( ply:GetPData( "exp" ) )
end
	
function lvl.GetAmountForLevel( num )
	return lvl.levels[ num ]
end
	
function lvl.GetNeededEXP( ply )
	local l = lvl.GetLevel( ply )
	local num = lvl.GetAmountForLevel( l )
	local cur = lvl.GetEXP( ply )
	return num - cur
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
	
function lvl.LevelUp( ply, diff )
	if lvl.GetLevel( ply ) + 1 > lvl.maxlevel then
		if lvl.GetEXP( ply ) ~= lvl.maxlevelexp then
			lvl.SetEXP( ply, lvl.maxlevelexp )
			lvl.SendUpdate( ply )
		end
		
		return
	end
	
	if diff then
		local cur = lvl.GetLevel( ply )
		local d = diff + lvl.GetEXP( ply )
		
		for i = cur, lvl.maxlevel do
			if lvl.levels[ i ] - d <= 0 then
				if d - lvl.levels[ i ] - lvl.levels[ i + 1 ] >= 0 then
					hook.Run( "lvl.OnLevelUp", ply, lvl.GetLevel( ply ) + 1 )
				end
				d = ( d - lvl.levels[ i ] )
				lvl.SetLevel( ply, lvl.GetLevel( ply ) + 1 )
			else
				hook.Run( "lvl.OnLevelUp", ply, i )
				lvl.SetLevel( ply, i )
				lvl.SetEXP( ply, d )
				break
			end
		end
		
		lvl.SendUpdate( ply )
	else
		hook.Run( "lvl.OnLevelUp", ply, lvl.GetLevel( ply ) + 1 )
		lvl.SetLevel( ply, lvl.GetLevel( ply ) + 1 )
		lvl.SendUpdate( ply )
	end
	ply:SetNWString( "level", lvl.GetLevel( ply ) )
end
	
function lvl.AddEXP( ply, num )
	local group = ply:GetUserGroup()
	for k, v in next, lvl.VIPGroups do
		if v[ 1 ] == group then
			if ( GetConVarNumber( "tdm_xpmulti" ) == 0 ) then
				num = num + ( num * v[ 2 ] )
			else
				num = num + ( num * ( tonumber( GetConVarNumber( "tdm_xpmulti" ) ) + v[ 2 ] ) )
			end
		end
	end
	local n = lvl.GetNeededEXP( ply )
	local c = lvl.GetEXP( ply )
	if n > num then
		lvl.SetEXP( ply, ( num + c ) )
		lvl.SendUpdate( ply )
	elseif num > n then
		local diff = num
		lvl.LevelUp( ply, diff )		
	elseif num == n then
		lvl.LevelUp( ply )		
	end
end
	
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
	
hook.Add( "lvl.OnLevelUp", "lvl.OnLevelUp", function( ply, newlv )
	if lvl.GetLevel( ply ) >= 100 then
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

util.AddNetworkString( "GetLevel" )
util.AddNetworkString( "GetLevelCallback" )