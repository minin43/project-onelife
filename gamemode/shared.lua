print( "shared initialization..." )
GM.Name = "Project: OneLife"
GM.Author = "Logan"
GM.Email = "lobsterlogan43@yahoo.com"
GM.Website = "egncommunity.com"

local redTeamName, BlueTeamName
if SERVER then

	util.AddNetworkString( "AskTeams" )
	util.AddNetworkString( "AskTeamsCallback" )

	possibleteams = {
		{ "Task Force 141", "US Army Rangers", "Navy Seals" },
		{ "Spetsnaz", "Militia", "OpFor" }
	}

	redTeamName = table.Random( possibleteams[ 2 ] )
	BlueTeamName = table.Random( possibleteams[ 1 ] )

	team.SetUp( 1, redTeamName, Color( 255, 0, 0 ) )
	team.SetUp( 2, BlueTeamName, Color( 0, 0, 255 ) )
	team.SetUp( 3, "Solo", Color( 0, 255, 0 ) )

	net.Receive( "AskTeams", function( len, ply )
		net.Start( "AskTeamsCallback" )
			net.WriteString( redTeamName )
			net.WriteString( BlueTeamName )
		net.Send( ply )
	end )

	local maps = {
		[ "gm_devruins" ] = 748863203,
		[ "de_secretcamp" ] = 296555359,
		[ "de_keystone_beta" ] = 508986899,
		[ "de_crash" ] = 671482026,
		[ "ttt_bf3_scrapmetal" ] = 228105814
	}

	for k, v in pairs( maps ) do
		if game.GetMap() == k then
			resource.AddWorkshop( v )
		end
	end
    
	resource.AddWorkshop( "349050451" ) --CW2.0 Base
	resource.AddWorkshop( "729950952" ) --Hand fix
	resource.AddWorkshop( "657241323" ) --KK's INS2 pack
	resource.AddWorkshop( "793616016" ) --My Server files
	resource.AddWorkshop( "176238701" ) --PMs
	resource.AddWorkshop( "805735515" )
	resource.AddWorkshop( "805601312" )
	resource.AddWorkshop( "805591562" )
	resource.AddWorkshop( "804726861" )
	resource.AddWorkshop( "804725707" )
	resource.AddWorkshop( "804724618" )
	--resource.AddWorkshop( "639078265" ) --UT3/Insurgency Sounds
	--resource.AddWorkshop( "575652408" ) --Player Expression Mod
	
end

--[[team.SetUp( 1, redTeamName, Color( 255, 0, 0 ) )
team.SetUp( 2, BlueTeamName, Color( 0, 0, 255 ) )
team.SetUp( 3, "Solo", Color( 0, 255, 0 ) )]]

print( "Team 1: ", team.GetName( 1 ) )
print( "Team 2: ", team.GetName( 2 ) )
print( "Team 3: ", team.GetName( 3 ) )

function GM:Initialize()
	self.BaseClass.Initialize( self )
end

local _PLY = FindMetaTable( "Player" )

function _PLY:Score()
	return self:GetNWInt( "tdm_score" )
end

if CLIENT then
	net.Start( "AskTeams" )
	net.SendToServer()
	net.Receive( "AskTeamsCallback", function()
		team.SetUp( 1, net.ReadString(), Color( 255, 0, 0 ) )
		team.SetUp( 2, net.ReadString(), Color( 0, 0, 255 ) )
		team.SetUp( 3, "Solo", Color( 0, 255, 0 ) )
	end )
end