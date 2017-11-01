--//This file is strictly for handling net messages sent to/from cl_menu.lua

util.AddNetworkString("RequestTeamRoles")
util.AddNetworkString("RequestTeamRolesCallback")
util.AddNetworkString("RequestEnemyRoles")
util.AddNetworkString("RequestEnemyRolesCallback")
util.AddNetworkString("SendRoleToServer")
util.AddNetworkString("RequestEntData")
util.AddNetworkString("RequestEntDataCallback")
util.AddNetworkString("")
util.AddNetworkString("")
util.AddNetworkString("")
util.AddNetworkString("")
util.AddNetworkString("")
util.AddNetworkString("")
util.AddNetworkString("")

function GM:SortTeamRoles(ply, len)
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
net.Receive("RequestEnemyRoles", GM.SortEnemyRoles)

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
    print("SERVER RECEIVED RequestEntData")
    local weaponClass = net.ReadString()
    local neededInfo = net.ReadTable()
    local tableToSend = {}
    print(weaponClass, neededInfo, weapons.GetStored(weaponClass).projectileClass)
    
    local spawnedEnt = ents.Create(weapons.GetStored(weaponClass).projectileClass)
    for k, v in pairs(neededInfo) do
        print(k, v, "\n") if istable(v) then PrintTable(v) end
        print("info to save:", v[1], spawnedEnt[v[1]])
        if not v[5] then
            tableToSend[v[1]] = spawnedEnt[v[1]]
        end
    end
    
    net.Start("RequestEntDataCallback")
        net.WriteTable(tableToSend)
    net.Send(ply)
end)