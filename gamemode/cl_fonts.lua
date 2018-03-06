--  Create all fonts here   --

--//From cl_hud_voting.lua
surface.CreateFont("VoteDefault", {font = "BankGothic", size = 18})
surface.CreateFont("VoteDescription", {font = "BankGothic", size = 12})
surface.CreateFont("VoteTitle", {font = "BankGothic", size = 24})

--//From cl_menu.lua
surface.CreateFont("MW2Font", {
	font = "BankGothic",
	size = 18,
	weight = 500,
	antialias = true
})

surface.CreateFont("MW2FontSmall", {
	font = "BankGothic",
	size = 12,
	weight = 500,
	antialias = true
})

surface.CreateFont("MW2FontUnderlined", {
	font = "BankGothic",
	size = 18,
	weight = 500,
	antialias = true,
	underline = true
})

surface.CreateFont("MW2FontLarge", {
	font = "BankGothic",
	size = 30,
	weight = 500,
	antialias = true
})

--//Legacy fonts from CTDM
surface.CreateFont( "Exo 2 Small", {
	font = "Exo 2",
	size = 15,
	weight = 500
} )

surface.CreateFont( "Exo 2 Regular", {
	font = "Exo 2",
	size = 20,
	weight = 500
} )

surface.CreateFont( "Exo 2 Huge", {
	font = "Exo 2",
	size = 1000,
	weight = 1100
} )

surface.CreateFont( "Exo 2 Large", {
	font = "Exo 2",
	size = 30,
	weight = 500
} )

--//Legacy fonts from cl_leaderboards, an old Whuppo file
--[[surface.CreateFont( "asdf", {
	font = "Arial",
	size = 17,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true
} )
surface.CreateFont( "asdf2", {
	font = "Arial",
	size = 15,
	weight = 400,
	blursize = 0,
	scanlines = 0,
	antialias = true
} )]]