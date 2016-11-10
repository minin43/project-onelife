print( "shared initialization..." )
GM.Name = "Project: OneLife"
GM.Author = "Logan"
GM.Email = "lobsterlogan43@yahoo.com"
GM.Website = "egncommunity.com"

possibleteams = {
	{ "Task Force 141", "US Army Rangers", "Navy Seals" },
	{ "Spetsnaz", "Militia", "OpFor" }
}

team.SetUp( 1, table.Random( possibleteams[ 2 ] ), Color( 255, 0, 0 ) )
team.SetUp( 2, table.Random( possibleteams[ 1 ] ), Color( 0, 0, 255 ) )
team.SetUp( 3, "Solo", Color( 0, 255, 0 ) )

print( "Team 1: ", team.GetName( 1 ) )
print( "Team 2: ", team.GetName( 2 ) )
print( "Team 3: ", team.GetName( 3 ) )

if SERVER then

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
	--resource.AddWorkshop( "639078265" ) --UT3/Insurgency Sounds
	--resource.AddWorkshop( "575652408" ) --Player Expression Mod
	
end

function GM:Initialize()
	self.BaseClass.Initialize( self )
end

local _PLY = FindMetaTable( "Player" )

function _PLY:Score()
	return self:GetNWInt( "tdm_score" )
end