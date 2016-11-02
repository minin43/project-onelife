GM.Name = "Project: OneLife"
GM.Author = "Logan"
GM.Email = "lobsterlogan43@yahoo.com"
GM.Website = "egncommunity.com"

possibleteams = {
	--{ "Task Force 141", "US Army Rangers", "Navy Seals" },
	{ "Task Force 141" },
	{ "Spetsnaz", "Militia", "OpFor" }

}

team.SetUp( 1, table.Random( possibleteams[ 2 ] ), Color( 255, 0, 0 ) )
team.SetUp( 2, table.Random( possibleteams[ 1 ] ), Color( 0, 0, 255 ) )
team.SetUp( 3, "Solo", Color( 0, 255, 0 ) )

if SERVER then

	local maps = {
		[ "gm_devruins" ] = 748863203,
		[ "de_secretcamp" ] = 296555359,
		[ "de_keystone_beta" ] = 508986899,
		[ "de_crash" ] = 671482026
	}

	for k, v in pairs( maps ) do
		if game.GetMap() == k then
			resource.AddWorkshop( v )
		end
	end
    
	resource.AddWorkshop( "349050451" ) --CW2.0 Base
	resource.AddWorkshop( "748212309" ) --Hand fix
	resource.AddWorkshop( "657241323" ) --KK's INS2 pack
	--resource.AddWorkshop( "492765756" ) --Weapon attach Fix
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