GM.Name = "Project: OneLife"
GM.Author = "Logan"
GM.Email = "lobsterlogan43@yahoo.com"
GM.Website = "egncommunity.com"

possibleteams = {
	{ "Task Force 141", "U.S. Army Rangers", "Marines" },
	{ "Spetsnaz", "Militia", "OpFor" }--, "Any more?" }
}

team.SetUp( 1, "Team " .. table.Random( possibleteams[ 2 ] ), Color( 255, 0, 0 ) )
team.SetUp( 2, "Team " .. table.Random( possibleteams[ 1 ] ), Color( 0, 0, 255 ) )
team.SetUp( 3, "Solo", Color( 0, 255, 0 ) )

if SERVER then
    
	resource.AddWorkshop( "349050451" ) --CW2.0 Base
	resource.AddWorkshop( "492765756" ) --Weapon attach Fix
	
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