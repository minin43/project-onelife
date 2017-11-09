print("cl_init initialization...")
include("shared.lua")
include("hud.lua")
include("cl_scoreboard.lua")
include("cl_lvl.lua")
include("cl_menu.lua")
include("cl_money.lua")
include("cl_flags.lua")
--include("cl_feed.lua")
include("cl_customspawns.lua")
include("cl_leaderboards.lua")
include("cl_menu_setup.lua")
include("cl_menu_NEW.lua")

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
		if not file.Exists("onelife/personalinfo/lastloadout" .. counter .. ".txt", "DATA") then
			file.Write("onelife/personalinfo/lastloadout" .. counter .. ".txt", util.TableToJSON({}))
		end
	end
    if not file.Exists("onelife/personalinfo/weaponpresets.txt", "DATA") then
		file.Write("onelife/personalinfo/weaponpresets.txt", util.TableToJSON({}))
	end
end)