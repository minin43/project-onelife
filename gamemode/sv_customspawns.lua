print( "sv_customspawns initialization..." )
if not file.Exists( "onelife/spawns", "DATA" ) then
	file.CreateDir( "onelife/spawns" )
end

if not file.Exists( "onelife/spawns/" .. game.GetMap() .. ".txt", "DATA" ) then
	file.Write( "onelife/spawns/" .. game.GetMap() .. ".txt" )
end

util.AddNetworkString( "debug_showspawns" )

local curSpawns = {}
local nl = Vector( 0, 0, 0 )
local na = Angle( 0, 0, 0 )

function StartPlacement( ply )
	for k, v in next, player.GetAll() do
		if v:GetNWBool( "placing" ) then
			ply:ChatPrint( v:Nick() .. " is already using spawn placement mode." )
			return
		end
	end
	ply:GodEnable()
	ply.OldWeps = {}
	for k, v in next, ply:GetWeapons() do
		table.insert( ply.OldWeps, v:GetClass() )
	end
	ply:StripWeapons()
	ply:SetMoveType( MOVETYPE_NOCLIP )
	ply:ChatPrint( "You are now in spawn placement mode. To exit, press alt." )
	ply:SetNWBool( "placing", true )
end

function refreshspawns()
	local toApply = {}
	local fi = file.Read( "onelife/spawns/" .. game.GetMap() .. ".txt", "DATA" )
	local exp = string.Explode( "\n", fi )
	for k, v in next, exp do
		local toAdd = util.JSONToTable( v )
		table.insert( toApply, toAdd )
	end
	curSpawns = toApply
	--The curSpawns table holds all of the spawn point information, with the team being it's first part and the vectors being it's second and third, 
	--and the spawn's front direction it's fourth. This table is not yet team-specific and holds ALL team's spawn information.
	for k, v in next, player.GetAll() do
		if v:IsSuperAdmin() then
			if v:GetNWBool( "placing" ) == true then
				net.Start( "debug_showspawns" )
					net.WriteTable( curSpawns )
				net.Send( v )
			end
		end
	end
end

function StopPlacement( ply )
	if not ply:GetNWBool( "placing" ) then
		return
	end
	ply:GodDisable()
	ply:SetMoveType( MOVETYPE_WALK )
	for k, v in next, ply.OldWeps do
		ply:Give( v )
	end
	ply:ChatPrint( "Observer mode exited." )
	ply:SetNWBool( "placing", false )
	ply:SetNWVector( "firstpos", nl )
	ply:SetNWVector( "secondpos", nl )
	ply:SetNWVector( "forward", na )
	ply:SetNWInt( "pos_team", 0 )
	ply.selectteam = nil
	ply.confirming = false
end

function confirmpos( ply, point1, point2, t, direction )
	ply:ChatPrint( "Press ENTER to confirm these spawn positions, press BACKSPACE to cancel." )
	hook.Add( "PlayerButtonDown", "confirm", function( ply, key )
		if ply.confirming and ply:GetNWBool( "placing" ) then
			if key == KEY_ENTER then
				local fixdir = AngFix( direction )
				file.Append( "onelife/spawns/" .. game.GetMap() .. ".txt", util.TableToJSON( { t, point1, point2, fixdir } ) .. "\n" )
				ply:ChatPrint( "Spawn saved!" )
				refreshspawns()
				ply:SetNWVector( "firstpos", nl )
				ply:SetNWVector( "secondpos", nl )
				ply:SetNWVector( "forward", na )
				ply:SetNWInt( "pos_team", 0 )
				ply.selectteam = nil
				ply.confirming = false
				ply:SendLua( [[surface.PlaySound( "garrysmod/ui_click.wav" )]] )
			elseif key == KEY_BACKSPACE then
				ply:ChatPrint( "Canceled spawn creation. Saved points cleared." )
				ply:SetNWVector( "firstpos", nl )
				ply:SetNWVector( "secondpos", nl )
				ply:SetNWVector( "forward", na )
				ply:SetNWInt( "pos_team", 0 )
				ply.selectteam = nil
				ply.confirming = false
				ply:SendLua( [[surface.PlaySound( "garrysmod/ui_click.wav" )]] )
			end
		end
	end )
end

function AngFix( ang )
	if !isangle( ang ) then return Angle( 0, 0, 0 ) end
	local imp = ang.y
	if imp < 0 then imp = imp + 360 end
	if imp < 45 and imp >= 315 then
		return Angle( 0, 0, 0 )
	elseif imp >= 45 and imp < 135 then
		return Angle( 0, 90, 0 )
	elseif imp >= 135 and imp < 225 then
		return Angle( 0, 180, 0 )
	elseif imp >= 225 and imp < 315 then
		return Angle( 0, 270, 0 )
	else
		return Angle( 0, 0, 0 )
	end
end

hook.Add( "PlayerButtonDown", "placement", function( ply, key )
	if ( not ply.selectteam ) and ply:GetNWBool( "placing" ) then
		if key == MOUSE_LEFT then
			local pos = ply:GetEyeTrace().HitPos
			local dir = ply:GetAngles()
			print( ply, "'s current angle: ", dir )
			if ply:GetNWVector( "firstpos" ) == nl and ply:GetNWVector( "secondpos" ) == nl then
				if pos then
					ply:SetNWVector( "firstpos", pos )
					ply:SendLua( [[surface.PlaySound( "garrysmod/ui_click.wav" )]] )
				end
			elseif ply:GetNWVector( "firstpos" ) ~= nl and ply:GetNWVector( "secondpos" ) == nl then
				if pos then
					ply:SetNWVector( "secondpos", pos )
					ply:SendLua( [[surface.PlaySound( "garrysmod/ui_click.wav" )]] )
					ply:ChatPrint( "Left click in any direction to choose the spawn's front direction." )
				end
			elseif ply:GetNWVector( "firstpos" ) ~= nl and ply:GetNWVector( "secondpos" ) ~= nl then
				if dir then
					ply:ChatPrint( "Set direction angle: ", dir )
					ply:SetNWVector( "forward", dir )
					ply:SendLua( [[surface.PlaySound( "garrysmod/ui_click.wav" )]] )
					ply.selectteam = true
					ply:ChatPrint( "Press 1 for red team spawn, 2 for blue team spawn, or 3 for black team spawn." )
				end
			end
		elseif key == MOUSE_RIGHT then
			if ply:GetNWVector( "firstpos" ) ~= nl and ply:GetNWVector( "secondpos" ) == nl then
				ply:SetNWVector( "firstpos", nl )
				ply:ChatPrint( "Undone location" )
				ply:SendLua( [[surface.PlaySound( "garrysmod/ui_click.wav" )]] )
			elseif ply:GetNWVector( "firstpos" ) ~= nl and ply:GetNWVector( "secondpos" ) ~= nl then
				ply:SetNWVector( "secondpos", nl )
				ply:ChatPrint( "Undone location" )
				ply:SendLua( [[surface.PlaySound( "garrysmod/ui_click.wav" )]] )
			end
		elseif key == KEY_LALT then
			StopPlacement( ply )
			ply:SendLua( [[surface.PlaySound( "garrysmod/ui_click.wav" )]] )
		end
	elseif ply.selectteam and ply:GetNWBool( "placing" ) then
		if key == KEY_1 then
			local k = 1
			confirmpos( ply, ply:GetNWVector( "firstpos" ), ply:GetNWVector( "secondpos" ), 1, ply:GetNWVector( "forward" ) )
			ply.confirming = true
			ply:SendLua( [[surface.PlaySound( "garrysmod/ui_click.wav" )]] )
			ply.selectteam = nil
			ply:SetNWInt( "pos_team", 1 )
		elseif key == KEY_2 then
			local k = 2
			confirmpos( ply, ply:GetNWVector( "firstpos" ), ply:GetNWVector( "secondpos" ), 2, ply:GetNWVector( "forward" ) )
			ply.confirming = true
			ply:SendLua( [[surface.PlaySound( "garrysmod/ui_click.wav" )]] )
			ply.selectteam = nil
			ply:SetNWInt( "pos_team", 2 )
		elseif key == KEY_3 then
			local k = 3
			confirmpos( ply, ply:GetNWVector( "firstpos" ), ply:GetNWVector( "secondpos" ), 3, ply:GetNWVector( "forward" ) )
			ply.confirming = true
			ply:SendLua( [[surface.PlaySound( "garrysmod/ui_click.wav" )]] )
			ply.selectteam = nil
			ply:SetNWInt( "pos_team", 3 )
		elseif key == MOUSE_RIGHT then
			ply:SetNWVector( "forward", na )
			ply.selectteam = false
			ply:ChatPrint( "Undone front direction" )
			ply:SendLua( [[surface.PlaySound( "garrysmod/ui_click.wav" )]] )
		end
	end
end )

hook.Add( "PlayerSpawn", "OverrideSpawnLocations", function( ply )	
	local availablespawns = false
	--If curSpawns, the table holding all spawn locations, has a table of vectors with the table's first piece of information matching
	--A team's own number, make availablespawns true
	for k, v in next, curSpawns do
		if v[ 1 ] == ply:Team() then
			availablespawns = true
			break
		end
	end	
	--If availablespawns is true, we know the player's team has spawns, so go ahead and take all of that team's spawn area information
	--and give it to the tabspawns table. The format between the two tables remains the same
	if availablespawns == true then	
		local tabspawns = {}
		for k, v in next, curSpawns do
			if v[ 1 ] == ply:Team() then
				table.insert( tabspawns, v )
			end
		end	
		--Should tabspawns have more than 1 table in it (because there are multiple spawn positions), go ahead and choose one at random.
		--The new singular table is called tospawn
		local tospawn = table.Random( tabspawns )
		--Bounds 1 and 2 must be tospawn 2 and 3 because tospawn 1 is the team's number (which is 1, 2, or 3)
		--These bounds are the 2 vectors in the tospawn table
		local bound1 = tospawn[ 2 ]
		local bound2 = tospawn[ 3 ]
		local locationx = math.random( bound1.x, bound2.x )
		local locationy = math.random( bound1.y, bound2.y )
		local z = bound1.z + 5 
		local vec = Vector( locationx, locationy, z )
		local ang = tospawn[ 4 ]
		--Above, "vec", is the initial guess of "where should I spawn the player," and since the spawning is random, this guess may have to be overwritten.
		while true do
			local en = ents.FindInSphere( vec, 40 )
			local safe = true
			for k, v in next, en do
				if IsValid( v ) and v:IsPlayer() then
					safe = false
					locationx = math.random( bound1.x, bound2.x )
					locationy = math.random( bound1.y, bound2.y )
					vec = Vector( locationx, locationy, z )
					break
				end
			end
			if safe then
				ply:SetPos( vec )
				ply:SetEyeAngles( ang )
				break
			end
		end			
	end
end )

concommand.Add( "pol_placespawns", function( ply )
	if ply:Alive() and IsValid( ply ) then
		if ply:IsSuperAdmin() then
			StartPlacement( ply )
		end
	end
end )

hook.Add( "PlayerSpawn", "SendSpawns", function( ply )
	if ply:GetNWBool( "placing" ) then
		StopPlacement( ply )
	end
end )

refreshspawns()