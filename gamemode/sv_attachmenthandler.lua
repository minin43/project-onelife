wep_att = { }

--wep_att[ classname ] = { attachmentname, price }
--//RedPrimaries
wep_att[ "cw_kk_ins2_ak74" ] = {
    { "", 10 },
}
wep_att[ "cw_kk_ins2_akm" ] = {
    { "", 10 },
}
wep_att[ "cw_kk_ins2_aks74u" ] = {
    { "", 10 },
}
wep_att[ "cw_kk_ins2_fnfal" ] = {
    { "", 10 },
}
wep_att[ "cw_kk_ins2_m1a1" ] = {
    { "", 10 },
}
wep_att[ "cw_kk_ins2_m1a1_para" ] = {
    { "", 10 },
}
wep_att[ "cw_kk_ins2_mosin" ] = {
    { "", 10 },
}
wep_att[ "cw_kk_ins2_mp40" ] = {
    { "", 10 },
}
wep_att[ "cw_kk_ins2_rpk" ] = {
    { "", 10 },
}
wep_att[ "cw_kk_ins2_sks" ] = {
    { "", 10 },
}
wep_att[ "cw_kk_ins2_sterling" ] = {
    { "", 10 },
}
wep_att[ "cw_kk_ins2_toz" ] = {
    { "", 10 },
}
--//BluePrimaries
wep_att[ "cw_kk_ins2_mini14" ] = { -- AC-556
    { "", 10 },
}
wep_att[ "cw_kk_ins2_galil" ] = {
    { "", 10 },
}
wep_att[ "cw_kk_ins2_cstm_galil_ace" ] = {
    { "", 10 },
}
wep_att[ "cw_kk_ins2_mp5k" ] = {
    { "", 10 },
}
wep_att[ "cw_kk_ins2_ump45" ] = {
    { "", 10 },
}
wep_att[ "cw_kk_ins2_l1a1" ] = {
    { "", 10 },
}
wep_att[ "cw_kk_ins2_m14" ] = {
    { "", 10 },
}
wep_att[ "cw_kk_ins2_m16a4" ] = {
    { "", 10 },
}
wep_att[ "cw_kk_ins2_m249" ] = {
    { "", 10 },
}
wep_att[ "cw_kk_ins2_m40a1" ] = {
    { "", 10 },
}
wep_att[ "cw_kk_ins2_m4a1" ] = {
    { "", 10 },
}
wep_att[ "cw_kk_ins2_m590" ] = {
    { "", 10 },
}
wep_att[ "cw_kk_ins2_mk18" ] = {
    { "", 10 },
}
--//RedSecondaries
wep_att[ "cw_kk_ins2_m1911" ] = {
    { "", 10 },
}
wep_att[ "cw_kk_ins2_makarov" ] = {
    { "", 10 },
}
--//BlueSecondaries
wep_att[ "cw_kk_ins2_m9" ] = {
    { "", 10 },
}
wep_att[ "cw_kk_ins2_m45" ] = {
    { "", 10 },
}
--//SharedSecondaries
wep_att[ "cw_kk_ins2_revolver" ] = {
    { "", 10 },
}

net.Receive( "RequestAttachments"), function( len, ply )
    local wep = net.ReadString()
    local i = id( ply:SteamID() )
	local fil = util.JSONToTable( file.Read( "onelife/users/" .. i .. ".txt", "DATA" ) )
    net.Start( "RequestAttachmentsCallback" )
        net.WriteTable( fil[ 2 ].wep ) --available attachments
        net.WriteTable( wep_att[wep] ) --all attachments & their price
    net.Send( ply )
end )