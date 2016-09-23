
--OLD LAYOUT: { <weapon name>, <class>, <unlock level>, <world model>, <cost>, { <damage>, <accuracy>, <rate of fire> } }  
--NEW LAYOUT: { <weapon name>, <class>, <world model>, team#, { roles by level } }

primaries = {
	--[[{ "AK-74", 		"cw_ak74", 		0, 	"models/weapons/w_rif_ak47.mdl", 		0, 	{ 0, 0, 0} },
	{ "AR-15", 		"cw_ar15", 		0, 	"models/weapons/w_rif_m4a1.mdl", 		0, 	{ 0, 0, 0} },
	{ "G3A3", 		"cw_g3a3", 		0, 	"models/weapons/w_snip_g3sg1.mdl", 		0, 	{ 0, 0, 0} },
	{ "L115", 		"cw_l115", 		0, 	"models/weapons/w_cstm_l96.mdl", 		0, 	{ 0, 0, 0} },
	{ "MP5", 		"cw_mp5", 		0, 	"models/weapons/w_smg_mp5.mdl", 		0, 	{ 0, 0, 0} },
	{ "G36C", 		"cw_g36c", 		0, 	"models/weapons/cw20_g36c.mdl", 		0, 	{ 0, 0, 0} },
	{ "M3 Super 90","cw_m3super90", 0, 	"models/weapons/w_cstm_m3super90.mdl", 	0, 	{ 0, 0, 0} },
	{ "M14", 		"cw_m14", 		0, 	"models/weapons/w_cstm_m14.mdl", 		0, 	{ 0, 0, 0} },
	{ "SCAR-H", 	"cw_scarh", 	0, 	"models/cw2/rifles/w_scarh.mdl", 		0, 	{ 0, 0, 0} },
	{ "UMP .45", 	"cw_ump45", 	0, "models/weapons/w_smg_ump45.mdl", 		0, 	{ 0, 0, 0} },
	{ "VSS", 		"cw_vss", 		0, "models/cw2/rifles/w_vss.mdl", 			0, 	{ 0, 0, 0} }]]
}


secondaries = {
	--[[{ "M1911",			"cw_m1911",		0,	"models/weapons/cw_pist_m1911.mdl",		0,   { 0, 0, 0 } },
	{ "Deagle",			"cw_deagle",	0,	"models/weapons/w_pist_deagle.mdl",		0,   { 0, 0, 0 } },
	{ "MR96",			"cw_mr96",		0,	"models/weapons/w_357.mdl",				0,   { 0, 0, 0 } },
	{ "Five Seven",		"cw_fiveseven",	0,	"models/weapons/w_pist_fiveseven.mdl",	0,   { 0, 0, 0 } },
	{ "MAC-11",			"cw_mac11",		0,	"models/weapons/w_cst_mac11.mdl",		0,   { 0, 0, 0 } },
	{ "Makarov",		"cw_makarov",	0,	"models/cw2/pistols/w_makarov.mdl",		0,   { 0, 0, 0 } },
	{ "P99",			"cw_p99",		0,	"models/weapons/w_pist_p228.mdl",		0,   { 0, 0, 0 } }]]
}

equipment = {
	{ "F1 Frag", 	"", "", 1, { 2, 5, 7, 8 } },
	{ "M67 Frag", 	"", "", 2, { 2, 5, 7, 8 } },
	{ "M18 Smoke", 	"", "", 3, { 1, 2, 3, 4, 7, 8 } },
	{ "M84 Flash", 	"", "", 3, { 1, 2, 3, 7, 8 } },
	{ "C4", 		"", "", 2, { 7 } },
	{ "IED", 		"", "", 1, { 7 } },
	{ "AT-4", 		"", "", 2, { 5 } },
	{ "RPG-7", 		"", "", 1, { 5 } },
	{ "GP35", 		"", "", 3, { 7 } },
	{ "P2A1", 		"", "", 3, { 1, 2, 3, 4, 5, 6, 7, 8 } } --This is the flare gun, for night maps, I guess...
}

--// { "Blue Team Name", "Red Team Name", levelrequired, "Role Description" }
--// Refer to this for future descriptions: http://insurgency.wikia.com/wiki/Insurgency
roles = {
	{ "Rifleman", 				"Militant", 	1, "Standard fighter, gets access to most weapon types but no frag grenade." },
	{ "Reconnaissance", 		"Scout", 		2, "Lightly armored but fast-moving fighter, gets access to all short-range weaponry and all grenades." },
	{ "Support", 				"Gunner", 		3, "Supportive fighter, gets access to LMGs and some long-distance DMRs, but no frag grenades." },
	{ "Designated Marksman", 	"Sharpshooter", 4, "Lightly armored supportive fighter, gets access to all DMRs but no flash/frag grenades." },
	{ "Demolitions", 			"Striker", 		5, "Heavily armored fighter, gets access to all launchers but no smoke/flash grenade." },
	{ "Sniper", 				"Sniper", 		6, "Lightly armored supportive fighter, gets access to all sniper rifles but no grenades." },
	{ "Breacher", 				"Sapper", 		7, "Medium armored supportive fighter, gets access to all throwable and remotely detonated explosives." },
	{ "Specialist", 			"Expert", 		8, "Medium armored fighter, gets access to extra, unique weapons for proving themselves in battle." }
}

function SetSpecialties()

end