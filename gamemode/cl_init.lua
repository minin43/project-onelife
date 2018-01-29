print("cl_init initialization...")
include("shared.lua")
include("cl_hud.lua")
include("cl_scoreboard.lua")
include("cl_lvl.lua")
include("cl_money.lua")
include("cl_flags.lua")
--include("cl_feed.lua")
include("cl_customspawns.lua")
include("cl_leaderboards.lua")
include("cl_menu_setup.lua")
include("cl_menu.lua")
include("cl_hud_voting.lua")

include("sh_attachmenthandler.lua")
include("sh_loadoutmenu.lua")
include("sh_weaponstats.lua")
include("sh_rolehandler.lua")

function id( steamid )
	local x = string.gsub( steamid, ":", "x")
	return x
end

if not file.Exists("onelife", "DATA") then
	file.CreateDir("onelife")
end

if not file.Exists("onelife/personalinfo", "DATA") then
	file.CreateDir("onelife/personalinfo")
end

hook.Add("Initialize", "FileSystemCheck", function()
	for counter = 1, 8 do
		if not file.Exists("onelife/personalinfo/lastloadout1" .. counter .. ".txt", "DATA") then
			file.Write("onelife/personalinfo/lastloadout1" .. counter .. ".txt", util.TableToJSON({}))
		end
		if not file.Exists("onelife/personalinfo/lastloadout2" .. counter .. ".txt", "DATA") then
			file.Write("onelife/personalinfo/lastloadout2" .. counter .. ".txt", util.TableToJSON({}))
		end
		if not file.Exists("onelife/personalinfo/lastloadout3" .. counter .. ".txt", "DATA") then
			file.Write("onelife/personalinfo/lastloadout3" .. counter .. ".txt", util.TableToJSON({}))
		end
	end
    if not file.Exists("onelife/personalinfo/weaponpresets.txt", "DATA") then
		file.Write("onelife/personalinfo/weaponpresets.txt", util.TableToJSON({}))
	end
end)

--//Do any team-based shit here, this is ran any time the player changes teams
net.Receive("ValidateTeam", function()
	local teamNum = net.ReadInt(3)
	if teamNum == 1 then
		GAMEMODE.myTeam = GAMEMODE.redTeam
	elseif teamNum == 2 then
		GAMEMODE.myTeam = GAMEMODE.blueTeam
	else
		GAMEMODE.myTeam = GAMEMODE.soloTeam
	end
end)