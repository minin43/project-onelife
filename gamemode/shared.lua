print( "shared initialization..." )
GM.Name = "Project: OneLife"
GM.Author = "Logan"
GM.Email = "lobsterlogan43@yahoo.com"
GM.Website = "egncommunity.com"
GM.Version = "09092017"
GM.redTeam = {
	teamNumber = 1,
	menuTeamColor = {r = 183, g = 28, b = 28},
	menuTeamColorLightAccent = {r = 240, g = 85, b = 69},
	menuTeamColorDarkAccent = {r = 20, g = 15, b = 15},
	menuTeamColorAccent = {r = 255, g = 255, b = 255}
}
GM.blueTeam = {
	teamNumber = 2,
	menuTeamColor = {r = 13, g = 71, b = 161},
	menuTeamColorLightAccent = {r = 84, g = 114, b = 211},
	menuTeamColorDarkAccent = {r = 15, g = 15, b = 20},
	menuTeamColorAccent = {r = 255, g = 255, b = 255}
}
GM.soloTeam = {
	teamNumber = 3,
	menuTeamColor = {r = 27, g = 94, b = 32},
	menuTeamColorLightAccent = {r = 76, g = 140, b = 74},
	menuTeamColorDarkAccent = {r = 15, g = 20, b = 15},
	menuTeamColorAccent = {r = 255, g = 255, b = 255}
}
GM.availableMaps = {
	{Name = "gm_devruins", ID = 748863203, Votes = 0},
	{Name = "de_secretcamp", ID = 296555359, Votes = 0},
	{Name = "de_keystone_beta", ID = 508986899, Votes = 0},
	{Name = "de_crash", ID = 671482026, Votes = 0},
	{Name = "ttt_bf3_scrapmetal", ID = 228105814, Votes = 0}
}

if SERVER then

	util.AddNetworkString( "AskTeams" )
	util.AddNetworkString( "AskTeamsCallback" )

	GM.possibleTeamNames = {
		{"Task Force 141", "US Army Rangers", "Navy Seals"},
		{"Spetsnaz", "OpFor"}--"Militia", "OpFor" }
	}
	GM.teamIcons = {
		["Task Force 141"] = Material("hud/icons/TF141_team_picture.jpg"),
		["US Army Rangers"] = Material("hud/icons/Rangers_team_picture.jpg"),
		["Navy Seals"] = Material("hud/icons/Seals_team_picture.jpg"),
		["Spetsnaz"] = Material("hud/icons/Spetsnaz_team_picture.jpg"),
		--["Militia"] = Material("hud/icons/"),
		["OpFor"] = Material("hud/icons/OpFor_team_picture2.jpg")
	}

	GM.redTeam.Name = table.Random( GM.possibleTeamNames[ 2 ] )
	GM.blueTeam.Name = table.Random( GM.possibleTeamNames[ 1 ] )

	team.SetUp( 1, GM.redTeam.Name, Color( 255, 0, 0 ) )
	team.SetUp( 2, GM.blueTeam.Name, Color( 0, 0, 255 ) )
	team.SetUp( 3, "Solo", Color( 0, 255, 0 ) )

	net.Receive( "AskTeams", function( len, ply )
		net.Start( "AskTeamsCallback" )
			net.WriteString( GAMEMODE.redTeam.Name )
			net.WriteString( GAMEMODE.blueTeam.Name )
		net.Send( ply )
	end )
	
	for k, v in pairs( GM.availableMaps ) do
		if game.GetMap() == v.Name then
			resource.AddWorkshop( tostring(v.ID) )
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

function GM:Initialize()
	self.BaseClass.Initialize( self )
end

if CLIENT then
	net.Start( "AskTeams" )
	net.SendToServer()
	net.Receive( "AskTeamsCallback", function()
		GAMEMODE.redTeam.Name = net.ReadString()
		GAMEMODE.blueTeam.Name = net.ReadString()
		team.SetUp( 1, GAMEMODE.redTeam.Name, Color( 255, 0, 0 ) )
		team.SetUp( 2, GAMEMODE.blueTeam.Name, Color( 0, 0, 255 ) )
		team.SetUp( 3, "Solo", Color( 0, 255, 0 ) )
	end )
end