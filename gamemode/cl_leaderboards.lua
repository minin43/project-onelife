function OpenLeaderboards()
	main = vgui.Create( "DFrame" )
	main:SetSize( 700, 500 )
	main:SetTitle( "" )
	main:SetVisible( true )
	main:SetDraggable( false )
	main:ShowCloseButton( true )
	main:MakePopup()
	main:Center()	
	main.btnMaxim:Hide()
	main.btnMinim:Hide() 
	main.btnClose:Hide()
	
	main.Paint = function()
		surface.SetDrawColor( 50, 50, 50, 135 )
		surface.DrawOutlinedRect( 0, 0, main:GetWide(), main:GetTall() )
		surface.SetDrawColor( 0, 0, 0, 240 )
		surface.DrawRect( 1, 1, main:GetWide() - 2, main:GetTall() - 2 )
		surface.SetFont( "topmenu" )
		surface.SetTextPos( main:GetWide() / 2 - surface.GetTextSize( "Leaderboards" ) / 2, 5 ) 
		surface.SetTextColor( 255, 255, 255, 255 )
		surface.DrawText( "Leaderboards" )
	end
	
	local close = vgui.Create( "DButton", main )
	close:SetPos( main:GetWide() - 50, 0 )
	close:SetSize( 44, 22 )
	close:SetText( "" )
	
	local colorv = Color( 150, 150, 150, 250 )
	function PaintClose()
		if not main then return end
		surface.SetDrawColor( colorv )
		surface.DrawRect( 1, 1, close:GetWide() - 2, close:GetTall() - 2 )	
		surface.SetFont( "asdf" )
		surface.SetTextColor( 255, 255, 255, 255 )
		surface.SetTextPos( 19, 1 ) 
		surface.DrawText( "x" )
		return true
	end
	close.Paint = PaintClose
	
	close.OnCursorEntered = function()
		colorv = Color( 195, 75, 0, 250 )
		PaintClose()
	end
	
	close.OnCursorExited = function()
		colorv = Color( 150, 150, 150, 250 )
		PaintClose()
	end
	
	close.OnMousePressed = function()
		colorv = Color( 170, 0, 0, 250 )
		PaintClose()
	end
	
	close.OnMouseReleased = function()
		main:Close()
	end
	
	main.OnClose = function()
		main:Remove()
		if main then
			main = nil
		end
	end
	
	local char = vgui.Create( "DLabel", main )
	char:SetPos( main:GetWide() - 72, 5 )
	char:SetFont( "Marlett" )
	char:SetColor( Color( 255, 255, 255, 200 ) )
	char:SetText( "1" )
	char:SizeToContents()
	
	local char2 = vgui.Create( "DLabel", main )
	char2:SetPos( main:GetWide() - 95, 5 )
	char2:SetFont( "Marlett" )
	char2:SetColor( Color( 255, 255, 255, 200 ) )
	char2:SetText( "0" )
	char2:SizeToContents()
	
	local inside = vgui.Create( "DPanel", main )
	inside:SetPos( 7, 27 )
	inside:SetSize( main:GetWide() - 14, main:GetTall() - 34 )
	inside.Paint = function()
		surface.SetDrawColor( 50, 50, 50, 105 )
		surface.DrawOutlinedRect( 0, 0, inside:GetWide(), inside:GetTall() )
		surface.SetDrawColor( 255, 255, 255, 250 )
		surface.DrawRect( 1, 1, inside:GetWide() - 2, inside:GetTall() - 2 )
	end
	local tree = vgui.Create( "DTree", inside )
	tree:SetPos( 5, 5 )
	tree:SetSize( 190, 455 )
	
	local list = vgui.Create( "DListView", inside )
	list:SetPos( 201, 5 )
	list:SetSize( 480, 455 )
	list:SetHeaderHeight( 25 )
	list:SetDataHeight( 30 )
	list:SetMultiSelect( false )
	list:AddColumn( "##" .. string.rep( " ", 15 ) ):SetFixedWidth( 82 )
	list:AddColumn( "Player" .. string.rep( " ", 50 ) ):SetFixedWidth( 250 )
	list:AddColumn( "Value" .. string.rep( " ", 25 ) ):SetFixedWidth( 148 )
	list.OnRowSelected = function( _, _, row )
		row:SetSelected( false )
	end
	
	for i = 1, #list.Columns do
		list.Columns[ i ].Header:SetFont( "asdf" )
		list.Columns[ i ].Header:SetTextColor( Color( 255, 255, 255, 255 ) )
		list.Columns[ i ].Header.Paint = function()
			surface.SetDrawColor( 0, 0, 0, 240 )
			surface.DrawRect( 0, 0, list.Columns[ i ]:GetSize() )
		end		
	end
	
	local function AddPlayer( name, steamid, value )
		local row = list:AddLine( tostring( #list:GetLines() + 1 ), name, value, steamid )
		local av = vgui.Create( "AvatarImage", row )
		av:SetPos( 50, 2 )
		av:SetSize( 26, 26 )
		av:SetSteamID( util.SteamIDTo64( row.Columns[ 4 ]:GetText() ) )
		for i = 1, #row.Columns do
			row.Columns[ i ]:SetFont( "asdf2" )
		end		
	end

	local badsweps = {
		"fas2_ammobox",
		"fas2_ifak",
		"fas2_base_shotgun",
		"fas2_base"
	}
	
	local goodsweps = {
	}
	
	local function disable()
		tree:SetDisabled( true )
		close.OnMouseReleased = function()
		end
	end
	
	local function enable()
		tree:SetDisabled( false )
		close.OnMouseReleased = function()
			main:Close()
		end
	end	
	
	local kills = tree:AddNode( "Kills" )
	kills:SetIcon( "icon16/bomb.png" )
	kills.DoClick = function()
		list:Clear()
		list:AddLine( "Loading..." )
		disable()
		net.Start( "AskGlobalKStats" )
		net.SendToServer()
		net.Receive( "AskGlobalKStatsCallback", function()
			local tab = net.ReadTable()
			list:Clear()
			if tab and #tab > 0 then
				for k, v in next, tab do
					AddPlayer( v[ 1 ], v[ 2 ], tostring( v[ 3 ] ) )
				end
			end
			enable()
		end )
	end
	
	for k, v in next, weapons.GetList() do
		if ( string.find( v.ClassName, "fas2" ) and not table.HasValue( badsweps, v.ClassName ) ) then
			local wep = kills:AddNode( v.PrintName )
			wep.class = v.ClassName
			wep:SetIcon( "icon16/gun.png" )
			wep.DoClick = function()
				list:Clear()
				list:AddLine( "Loading..." )	
				disable()
				net.Start( "AskWeaponStats" )
					net.WriteString( wep.class )
				net.SendToServer()
				net.Receive( "AskWeaponStatsCallback", function()
					local tab = net.ReadTable()
					list:Clear()						
					if tab and #tab > 0 then
						for k, v in next, tab do
							AddPlayer( v[ 1 ], v[ 2 ], tostring( v[ 3 ] ) )
						end
					end
					enable()
				end )
			end
		end
	end
	for k, v in next, goodsweps do
		local wep = kills:AddNode( v )
		wep.class = v
		wep:SetIcon( "icon16/gun.png" )
		wep.DoClick = function()
			list:Clear()
			list:AddLine( "Loading..." )
			disable()
			net.Start( "AskWeaponStats" )
				net.WriteString( wep.class )
			net.SendToServer()
			net.Receive( "AskWeaponStatsCallback", function()
				list:Clear()
				local tab = net.ReadTable()
				for k, v in next, tab do
					AddPlayer( v[ 1 ], v[ 2 ], tostring( v[ 3 ] ) )
				end
				enable()
			end )
		end			
	end
	local deaths = tree:AddNode( "Deaths" )
	deaths:SetIcon( "icon16/cancel.png" )
	deaths.DoClick = function()
		list:Clear()
		list:AddLine( "Loading..." )	
		disable()
		net.Start( "AskGlobalDStats" )
		net.SendToServer()
		net.Receive( "AskGlobalDStatsCallback", function()
			local tab = net.ReadTable()
			list:Clear()
			if tab and #tab > 0 then
				for k, v in next, tab do
					AddPlayer( v[ 1 ], v[ 2 ], tostring( v[ 3 ] ) )
				end
			end
			enable()
		end )
	end		
	
	local kdr = tree:AddNode( "Kill/Death Ratio" )
	kdr:SetIcon( "icon16/chart_line.png" )
	kdr.DoClick = function()
		list:Clear()
		list:AddLine( "Loading..." )	
		disable()
		net.Start( "AskKDRStats" )
		net.SendToServer()
		net.Receive( "AskKDRStatsCallback", function()
			local tab = net.ReadTable()
			list:Clear()
			if tab and #tab > 0 then
				for k, v in next, tab do
					AddPlayer( v[ 1 ], v[ 2 ], tostring( math.Round( tonumber( v[ 3 ] ), 3 ) ) )
				end
			end
			enable()
		end )
	end			
	
	local assists = tree:AddNode( "Assists" )
	assists:SetIcon( "icon16/user_add.png" )
	assists.DoClick = function()
		list:Clear()
		list:AddLine( "Loading..." )	
		disable()
		net.Start( "AskAStats" )
		net.SendToServer()
		net.Receive( "AskAStatsCallback", function()
			local tab = net.ReadTable()
			list:Clear()
			if tab and #tab > 0 then
				for k, v in next, tab do
					AddPlayer( v[ 1 ], v[ 2 ], tostring( v[ 3 ] ) )
				end
			end
			enable()
		end )
	end		
	
	local flags = tree:AddNode( "Flag Captures" )
	flags:SetIcon( "icon16/flag_blue.png" )
	flags.DoClick = function()
		list:Clear()
		list:AddLine( "Loading..." )
		disable()
		net.Start( "AskFlagStats" )
		net.SendToServer()
		net.Receive( "AskFlagStatsCallback", function()
			local tab = net.ReadTable()
			list:Clear()
			if tab and #tab > 0 then
				for k, v in next, tab do
					AddPlayer( v[ 1 ], v[ 2 ], tostring( v[ 3 ] ) )
				end
			end
			enable()
		end )
	end		
	
	local time = tree:AddNode( "Time Played" )
	time:SetIcon( "icon16/time.png" )
	time.DoClick = function()
		list:Clear()
		list:AddLine( "Loading..." )	
		disable()
		net.Start( "AskTimeStats" )
		net.SendToServer()
		net.Receive( "AskTimeStatsCallback", function()
			local tab = net.ReadTable()
			list:Clear()
			if tab and #tab > 0 then
				for k, v in next, tab do
					if tonumber( v[ 3 ] ) > 60 then
						v[ 3 ] = math.Round( v[ 3 ] / 60, 2 ) .. " hours"
					else
						v[ 3 ] = v[ 3 ] .. " minutes"
					end
				end
				for k, v in next, tab do
					AddPlayer( v[ 1 ], v[ 2 ], tostring( v[ 3 ] ) )
				end
			end
			enable()
		end )
	end		
	
	local level = tree:AddNode( "Level" )
	level:SetIcon( "icon16/chart_bar.png" )
	level.DoClick = function()
		list:Clear()
		list:AddLine( "Loading..." )
		disable()
		net.Start( "AskLevelStats" )
		net.SendToServer()
		net.Receive( "AskLevelStatsCallback", function()
			local tab = net.ReadTable()
			list:Clear()
			if tab and #tab > 0 then
				for k, v in next, tab do
					AddPlayer( v[ 1 ], v[ 2 ], tostring( v[ 3 ] ) )
				end
			end
			enable()
		end )
	end					
	
	local money = tree:AddNode( "Money" )
	money:SetIcon( "icon16/money.png" )
	money.DoClick = function()
		list:Clear()
		list:AddLine( "Loading..." )	
		disable()
		net.Start( "AskMoneyStats" )
		net.SendToServer()
		net.Receive( "AskMoneyStatsCallback", function()
			local tab = net.ReadTable()
			list:Clear()
			if tab and #tab > 0 then
				for k, v in next, tab do
					AddPlayer( v[ 1 ], v[ 2 ], tostring( v[ 3 ] ) )
				end
			end
			enable()
		end )
	end				
	
	local long = tree:AddNode( "Longest Headshot" )
	long:SetIcon( "icon16/zoom.png" )
	long.DoClick = function()
		list:Clear()
		list:AddLine( "Loading..." )
		disable()
		net.Start( "AskLongestHS" )
		net.SendToServer()
		net.Receive( "AskLongestHSCallback", function()
			local tab = net.ReadTable()
			list:Clear()
			if tab and #tab > 0 then
				for k, v in next, tab do
					AddPlayer( v[ 1 ], v[ 2 ], tostring( v[ 3 ] ) )
				end
			end
			enable()
		end )
	end		
	
end
--concommand.Add( "tdm_leaderboards", OpenLeaderboards )