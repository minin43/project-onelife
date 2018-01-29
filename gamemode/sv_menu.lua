--//This file is strictly for handling net messages sent to/from cl_menu.lua

util.AddNetworkString("SendRoleToServer")
util.AddNetworkString("RequestEntData")
util.AddNetworkString("RequestEntDataCallback")
util.AddNetworkString("RequestAvailableWeapons")
util.AddNetworkString("RequestAvailableWeaponsCallback")
util.AddNetworkString("RequestAvailableAttachments")
util.AddNetworkString("RequestAvailableAttachmentsCallbackprimaries")
util.AddNetworkString("RequestAvailableAttachmentsCallbacksecondaries")
util.AddNetworkString("RequestAvailableAttachmentsCallbackequipment")
util.AddNetworkString("VerifyLoadout")
util.AddNetworkString("RequestPurchasedWeapons")
util.AddNetworkString("RequestPurchasedWeaponsCallback")
util.AddNetworkString("")
util.AddNetworkString("")
util.AddNetworkString("")
util.AddNetworkString("")
util.AddNetworkString("")
util.AddNetworkString("")
util.AddNetworkString("")

--[[function GM:SortTeamRoles(ply, len)
    if not IsValid(ply) then return end
    local tableToSend = {}
    for k, v in pairs(player.GetAll()) do
        if ply:Team() == v:Team() and ply != v then
            tableToSend[#tableToSend + 1] = {Nick = v:Nick(), Role = v.Role or "None"}
        end
    end
    
    net.Start("RequestTeamRolesCallback")
        net.WriteTable(tableToSend)
    net.Send(ply)
end
net.Receive("RequestTeamRoles", GM.SortTeamRoles)

function GM:SortEnemyRoles(ply, len)
    if not IsValid(ply) then return end
    local tableToSend = {}
    for k, v in pairs(player.GetAll()) do
        if ply:Team() != v:Team() and v:Team() != 0 then
            tableToSend[v.Role] = tableToSend[v.Role] or 0
            tableToSend[v.Role] = tableToSend[v.Role] + 1
        end
    end
    
    net.Start("RequestEnemyRolesCallback")
        net.WriteTable(tableToSend)
    net.Send(ply)
end
net.Receive("RequestEnemyRoles", GM.SortEnemyRoles)]]

net.Receive("SendRoleToServer", function(ply, len)
    ply.Role = tonumber(net.ReadString())
    localTeam = ply:Team()
    for k, v in pairs(player.GetAll()) do
        if v != ply then
            if v:Team() == localTeam then
                GM:SortTeamRoles(0, ply)
            else
                GM:SortEnemyRoles(0, ply)
            end
        end
    end
end)

net.Receive("RequestEntData", function(len, ply)
    --print("SERVER RECEIVED RequestEntData")
    local weaponClass = net.ReadString()
    local neededInfo = net.ReadTable()
    local tableToSend = {}
    --print(weaponClass, neededInfo, weapons.GetStored(weaponClass).projectileClass)
    
    local spawnedEnt = ents.Create(weapons.GetStored(weaponClass).projectileClass)
    for k, v in pairs(neededInfo) do
        --print(k, v, "\n") if istable(v) then PrintTable(v) end
        --print("info to save:", v[1], spawnedEnt[v[1]])
        if not v[5] then
            tableToSend[v[1]] = spawnedEnt[v[1]]
        end
    end
    
    net.Start("RequestEntDataCallback")
        net.WriteTable(tableToSend)
    net.Send(ply)
end)

net.Receive("RequestAvailableWeapons", function(len, ply)
    local plyRole = net.ReadInt(5)
    local availableWeaponsTable = {}

    --Add default weapons
    for k, v in pairs(GAMEMODE.menuWeaponInfo) do
        availableWeaponsTable[k] = {}
        for k2, v2 in pairs(v) do
            if v2[3] == ply:Team() or v2[3] == 0 then
                if table.KeyFromValue(GAMEMODE.weaponTypes, v2[2]) > 12 or (table.KeyFromValue(GAMEMODE.weaponTypes, v2[2]) < 12 and GAMEMODE.Roles[plyRole].roleDescriptionExpanded[table.KeyFromValue(GAMEMODE.weaponTypes, v2[2])][2] == "Full") then
                    availableWeaponsTable[k][#availableWeaponsTable[k] + 1] = {class = k2, type = v2[2]}
                end
            end
        end
    end

    --Add specific weapons here, structured in such a way that team 3 produces both sets
    if plyRole == 7 then
        if ply:Team() != 1 then
            availableWeaponsTable.primaries[#availableWeaponsTable.primaries + 1] = {class = "cw_kk_ins2_m4a1", type = GAMEMODE.menuWeaponInfo.primaries["cw_kk_ins2_m4a1"][2]}
            availableWeaponsTable.primaries[#availableWeaponsTable.primaries + 1] = {class = "cw_kk_ins2_ump45", type = GAMEMODE.menuWeaponInfo.primaries["cw_kk_ins2_ump45"][2]}
            availableWeaponsTable.primaries[#availableWeaponsTable.primaries + 1] = {class = "cw_kk_ins2_m590", type = GAMEMODE.menuWeaponInfo.primaries["cw_kk_ins2_m590"][2]}
        end
        if ply:Team() != 2 then
            availableWeaponsTable.primaries[#availableWeaponsTable.primaries + 1] = {class = "cw_kk_ins2_ak74", type = GAMEMODE.menuWeaponInfo.primaries["cw_kk_ins2_ak74"][2]}
            availableWeaponsTable.primaries[#availableWeaponsTable.primaries + 1] = {class = "cw_kk_ins2_mp40", type = GAMEMODE.menuWeaponInfo.primaries["cw_kk_ins2_mp40"][2]}
            availableWeaponsTable.primaries[#availableWeaponsTable.primaries + 1] = {class = "cw_kk_ins2_toz", type = GAMEMODE.menuWeaponInfo.primaries["cw_kk_ins2_toz"][2]}
        end
    end

    --Add additional unlocked weapons here

    --Sort the weapons
    for k, v in pairs(availableWeaponsTable) do
        table.sort(v, function(a, b) return table.KeyFromValue(GAMEMODE.weaponTypes, a.type) > table.KeyFromValue(GAMEMODE.weaponTypes, b.type) end) --This sorts based on weapon's role
        --table.sort(v, ) --This sorts based on weapon's name, can this be done alongside the role as well???
    end

    net.Start("RequestAvailableWeaponsCallback")
        net.WriteTable(availableWeaponsTable)
    net.Send(ply)
end)

net.Receive("RequestAvailableAttachments", function(len, ply)
    local wep = net.ReadString()
    local wepType = net.ReadString()
    local tab = util.JSONToTable(file.Read( "onelife/users/attachmentunlocks_" .. id( ply:SteamID() ) .. ".txt", "DATA"))

    tab[2][wep] = tab[2][wep] or {}
    local toSend = tab[2][wep]

    net.Start("RequestAvailableAttachmentsCallback" .. wepType)
        net.WriteTable(tab[2][wep])
    net.Send(ply)
end)

net.Receive("RequestPurchasedWeapons", function(len, ply)
    local tab = util.JSONToTable(file.Read( "onelife/users/weaponunlocks_" .. id( ply:SteamID() ) .. ".txt", "DATA"))
    net.Start("RequestPurchasedWeaponsCallback")
        net.WriteTable(tab[2])
    net.Send(ply)
end)

net.Receive("VerifyLoadout", function(len, ply)
    local newLoadout = net.ReadTable()
    local oldLoadout = ply.currentLoadout or {} --done as a local var for redundancy
    if newLoadout == oldLoadout then return end --If the loadout is the exact same, no point in re-applying it

    ply.currentLoadout = {}
    print("\nVERIFICATION of the new loadout being sent:", ply, ply.currentLoadout, newLoadout)
    PrintTable(newLoadout)
    for k, v in pairs(newLoadout) do
        ply.currentLoadout[k] = v
    end
    print("Current version of ply.currentLoadout:")
    PrintTable(ply.currentLoadout)
    GAMEMODE:ApplyLoadout(ply)
end)