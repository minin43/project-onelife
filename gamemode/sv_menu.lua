--//This file is strictly for handling net messages sent to/from cl_menu.lua

util.AddNetworkString("RequestTeamRoles")
util.AddNetworkString("RequestTeamRolesCallback")
util.AddNetworkString("RequestEnemyRoles")
util.AddNetworkString("RequestEnemyRolesCallback")
util.AddNetworkString("SendRoleToServer")
util.AddNetworkString("")

function GM:SortTeamRoles(len, ply)
    local tableToSend
    for k, v in pairs(player.GetAll()) do
        if ply.Team() == v.Team() then
            tableToSend[#tableToSend + 1] = {Nick = v.Nick(), Role = v.Role}
        end
    end
    
    net.Start("RequestTeamRolesCallback")
        net.WriteTable(tableToSend)
    net.Send(ply)
end
net.Receive("RequestTeamRoles", GM:SortTeamRoles())

function GM:SortEnemyRoles(len, ply)
    local tableToSend
    for k, v in pairs(player.GetAll()) do
        if ply.Team() != v.Team() and v.Team() != 0 then
            tableToSend[v.Role] = tableToSend[v.Role] or 0
            tableToSend[v.Role] = tableToSend[v.Role] + 1
        end
    end
    
    net.Start("RequestEnemyRolesCallback")
        net.WriteTable(tableToSend)
    net.Send(ply)
end
net.Receive("RequestEnemyRoles", GM:SortEnemyRoles())

net.Receive("SendRoleToServer", function(len, ply)
    ply.Role = tonumber(net.ReadString())
    for k, v in pairs(player.GetAll()) do

    end
end)