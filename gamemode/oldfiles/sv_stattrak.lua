util.AddNetworkString( "UpdateStatTrak" )
util.AddNetworkString( "SendInitialStatTrak" )

st = {}

st.attachments = {}

if ( CustomizableWeaponry.registeredAttachments ) then
	for k, v in ipairs( CustomizableWeaponry.registeredAttachments ) do
		table.insert( st.attachments, v.name )
	end
end

wep_att = {}

--wep_att[ "weapon_name" ] =   primary attachment	secondary attachment	tertiary attachment		etc

wep_att[ "cw_ak74" ] = {
	{ "md_kobra", 10 },
	{ "md_pbs1", 20 },
	{ "md_eotech", 30 },
	{ "bg_ak74_rpkbarrel", 40 },
	{ "md_aimpoint", 50 },
	{ "bg_ak74_ubarrel", 50 },
	{ "md_schmidt_shortdot", 60 },
	{ "md_foregrip", 70 },
	{ "md_pso1", 80 },
	{ "bg_ak74rpkmag", 90 },
	{ "bg_ak74foldablestock", 100 },
	{ "bg_ak74heavystock", 110 },
	{ "am_magnum", 120 },
	{ "am_matchgrade", 130 }
}
wep_att[ "cw_ar15" ] = {
	{ "md_microt1", 10 },
	{ "md_saker", 20 },
	{ "md_eotech", 30 },
	{ "bg_magpulhandguard", 40 },
	{ "md_aimpoint", 50 },
	{ "bg_longbarrel", 50 },
	{ "md_schmidt_shortdot", 60 },
	{ "bg_ris", 70 },
	{ "md_acog", 80 },
	{ "bg_longris", 90 },
	{ "md_foregrip", 100 },
	{ "md_m203", 110 },
	{ "bg_ar1560rndmag", 120 },
	{ "bg_ar15sturdystock", 130 },
	{ "bg_ar15heavystock", 140 },
	{ "md_anpeq15", 150 },
	{ "am_magnum", 160 },
	{ "am_matchgrade", 170 }
}
wep_att[ "cw_deagle" ] = {
	{ "md_microt1", 10 },
	{ "md_saker", 20 },
	{ "md_eotech", 30 },
	{ "bg_deagle_compensator", 40 },
	{ "md_acog", 50 },
	{ "bg_deagle_extendedbarrel", 50 },
	{ "am_magnum", 60 },
	{ "am_matchgrade", 70 }
}
wep_att[ "cw_g3a3" ] = {
	{ "md_microt1", 10 },
	{ "md_saker", 20 },
	{ "md_eotech", 30 },
	{ "md_foregrip", 40 },
	{ "md_aimpoint", 50 },
	{ "md_m203", 50 },
	{ "md_schmidt_shortdot", 60 },
	{ "bg_bipod", 70 },
	{ "md_acog", 80 },
	{ "bg_sg1scope", 90 },
	{ "am_magnum", 100 },
	{ "am_matchgrade", 110 }
}
wep_att[ "cw_mp5" ] = {
	{ "md_microt1", 10 },
	{ "md_tundra9mm", 20 },
	{ "md_eotech", 30 },
	{ "bg_mp5_kbarrel", 40 },
	{ "md_aimpoint", 50 },
	{ "bg_mp5_sdbarrel", 50 },
	{ "md_schmidt_shortdot", 60 },
	{ "bg_mp530rndmag", 70 },
	{ "md_acog", 80 },
	{ "bg_retractablestock", 90 },
	{ "bg_nostock", 100 },
	{ "am_magnum", 110 },
	{ "am_matchgrade", 120 }
}
wep_att[ "cw_mr96" ] = {
	{ "bg_regularbarrel", 10 },
	{ "bg_longbarrelmr96", 20 },
	{ "am_matchgrade", 30 }
}
wep_att[ "cw_fiveseven" ] = {
	{ "md_microt1", 10 },
	{ "md_saker", 20 },
	{ "md_insight_x2", 30 },
	{ "am_magnum", 40 },
	{ "am_matchgrade", 50 }
}
wep_att[ "cw_g36c" ] = {
	{ "md_microt1", 10 },
	{ "md_saker", 20 },
	{ "md_eotech", 30 },
	{ "md_foregrip", 40 },
	{ "md_schmidt_shortdot", 50 },
	{ "md_anpeq15", 50 },
	{ "md_acog", 60 },
	{ "am_magnum", 70 },
	{ "am_matchgrade", 80 }
}
wep_att[ "cw_m3super90" ] = {
	{ "md_microt1", 10 },
	{ "md_eotech", 20 },
	{ "md_aimpoint", 30 },
	{ "md_acog", 40 },
	{ "am_slugrounds", 50 },
	{ "am_flechetterounds", 50 }
}
wep_att[ "cw_m14" ] = {
	{ "md_nightforce_nxs", 00 },
	{ "md_microt1", 10 },
	{ "md_eotech", 20 },
	{ "md_saker", 30 },
	{ "md_aimpoint", 40 },
	{ "md_schmidt_shortdot", 50 },
	{ "md_anpeq15", 50 },
	{ "md_acog", 60 },
	{ "am_magnum", 70 },
	{ "am_matchgrade", 80 }
}
wep_att[ "cw_m1911" ] = {
	{ "md_rmr", 10 },
	{ "md_cobram2", 20 },
	{ "md_insight_x2", 30 },
	{ "am_magnum", 40 },
	{ "am_matchgrade", 50 }
}
wep_att[ "cw_mac11" ] = {
	{ "md_microt1", 10 },
	{ "md_tundra9mm", 20 },
	{ "md_eotech", 30 },
	{ "bg_mac11_extended_barrel", 40 },
	{ "bg_mac11_unfolded_stock", 50 },
	{ "am_magnum", 50 },
	{ "am_matchgrade", 60 }
}
wep_att[ "cw_makarov" ] = {
	{ "bg_makarov_pb6p9", 10 },
	{ "bg_makarov_pm_suppressor", 20 },
	{ "bg_makarov_pb_suppressor", 30 },
	{ "bg_makarov_extmag", 40 },
	{ "am_sp7", 50 }
}
wep_att[ "cw_p99" ] = {
	{ "md_microt1", 10 },
	{ "md_tundra9mm", 20 },
	{ "md_insight_x2", 30 },
	{ "am_magnum", 40 },
	{ "am_matchgrade", 50 }
}
wep_att[ "cw_scarh" ] = {
	{ "md_microt1", 10 },
	{ "md_saker", 20 },
	{ "md_eotech", 30 },
	{ "md_anpeq15", 40 },
	{ "md_aimpoint", 50 },
	{ "md_foregrip", 50 },
	{ "md_schmidt_shortdot", 60 },
	{ "md_m203", 70 },
	{ "md_acog", 80 },
	{ "am_magnum", 90 },
	{ "am_matchgrade", 100 }
}
wep_att[ "cw_ump45" ] = {
	{ "md_microt1", 10 },
	{ "md_eotech", 20 },
	{ "md_saker", 30 },
	{ "md_aimpoint", 40 },
	{ "md_schmidt_shortdot", 50 },
	{ "md_anpeq15", 50 },
	{ "md_acog", 60 },
	{ "am_magnum", 70 },
	{ "am_matchgrade", 80 }
}
wep_att[ "cw_vss" ] = {
	{ "md_kobra", 10 },
	{ "bg_asval_20rnd", 20 },
	{ "md_eotech", 30 },
	{ "bg_asval_30rnd", 40 },
	{ "md_aimpoint", 50 },
	{ "bg_asval", 50 },
	{ "md_schmidt_shortdot", 60 },
	{ "bg_sr3m", 70 },
	{ "md_pso1", 80 },
	{ "bg_vss_foldable_stock", 90 },
	{ "md_pbs1", 100 },
	{ "md_foregrip", 110 },
	{ "am_magnum", 120 },
	{ "am_matchgrade", 130 }
}

function GetStatTrak( ply, wep )
	if not ply:GetPData( wep ) then
		return 0
	end
	
	return tonumber( ply:GetPData( wep ) )
end

hook.Add( "PlayerDeath", "ST_PlayerDeath", function( ply, _, att )
	if ply and ply:IsValid() and att and att:IsValid() and att ~= ply and att ~= NULL and ply ~= NULL and att:IsPlayer() then
		if att ~= NULL and att:Alive() then			
			local wep = att:GetActiveWeapon()
			
			if wep and wep ~= NULL then
				wep = wep:GetClass()
			elseif wep == nil or wep == NULL then
				return
			end
		
			if wep and att:GetActiveWeapon():IsValid() and att:GetActiveWeapon() ~= NULL then
				local cantrack = false
				
				if st[ att ] then
					for k, v in next, st[ att ] do
						if wep == v:GetClass() then
							cantrack = true
						end
					end
				end
		
				if cantrack == true then
					if not att:GetPData( wep ) then
						att:SetPData( wep, 1 )
					elseif wep == "cw_kk_hk416" then
						if GetStatTrak( att, "cw_kk_hk416" ) < GetStatTrak( att, "cw_hk416" ) then
							local num = att:GetPData( "cw_hk416" )
							att:SetPData( wep, num + 1 )
						else
							local num = att:GetPData( wep )
							att:SetPData( wep, num + 1 )
						end
					elseif wep == "cw_kk_xm8" then
						if GetStatTrak( att, "cw_kk_xm8" ) < GetStatTrak( att, "cw_xm8_kk" ) then
							local num = att:GetPData( "cw_xm8_kk" )
							att:SetPData( wep, num + 1 )
						else
							local num = att:GetPData( wep )
							att:SetPData( wep, num + 1 )
						end
					else
						local num = att:GetPData( wep )
						att:SetPData( wep, num + 1 )
					end
					
					net.Start( "UpdateStatTrak" )
						net.WriteString( wep )
						net.WriteString( tostring( att:GetPData( wep ) ) )
					net.Send( att )
				end
			end
			
			local num = GetStatTrak( att, wep )
			local togive = {}
			
			for q, w in next, wep_att do
				if q == wep then
					for a, s in next, w do
						if num == s[ 2 ] then
							table.insert( togive, s[ 1 ] )
						end
					end
				end
			end
			if next(togive) ~= nil then CustomizableWeaponry.giveAttachments( att, togive ) end
		end
	end
end )

hook.Add( "PlayerSpawn", "ST_PlayerSpawn", function( ply )
	timer.Simple( 0.5, function()
        if ply == nil then return end -- fixed by cobalt 1/30/16
		local weps = ply:GetWeapons()
		st[ ply ] = weps
		
		local tab = {}
		
		for k, v in next, weps do
			local x = v:GetClass()
			
			if ply:GetPData( x ) then
				table.insert( tab, { x, ply:GetPData( x ) } )
			else
				table.insert( tab, { x, 0 } )
			end
		end
		
		net.Start( "SendInitialStatTrak" )
			net.WriteTable( tab )
			net.WriteTable( wep_att )
		net.Send( ply )
		
		local togive = {}
		
		for k, v in next, weps do
			local num = GetStatTrak( ply, v:GetClass() )
			
			for q, w in next, wep_att do
				if q == v:GetClass() then
					for a, s in next, w do
						if num >= s[ 2 ] then
							table.insert( togive, s[ 1 ] )
						end
					end
				end
			end
		end
		CustomizableWeaponry.giveAttachments( ply, togive, true )
	end )
end )

local updatePrevent = 0
hook.Add( "Think", "UpdateSTWeps", function()
	if CurTime() > updatePrevent then
			updatePrevent = CurTime() + 4
		for k, v in next, player.GetAll() do
			if st[ v ] ~= v:GetWeapons() then
				st[ v ] = v:GetWeapons()
			end
		end
	end
end )
