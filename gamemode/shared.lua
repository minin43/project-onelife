GM.Name = "Project: OneLife"
GM.Author = "Logan"
GM.Email = "lobsterlogan43@yahoo.com"
GM.Website = "N/A"

team.SetUp( 1, "Red", Color( 255, 0, 0 ) )
team.SetUp( 2, "Blue", Color( 0, 0, 255 ) )
team.SetUp( 3, "Black", Color( 0, 0, 0 ) )

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