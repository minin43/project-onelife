curAmt = -1

net.Start( "RequestMoney" )
net.SendToServer()

net.Receive( "RequestMoneyCallback", function()
	curAmt = tonumber( net.ReadString() )
end )

net.Receive( "SendMoneyUpdate", function()
	curAmt = tonumber( net.ReadString() )
end )

timer.Create( "money", 10, 0, function()
	if curAmt == -1 then
		net.Start( "RequestMoney" )
		net.SendToServer()
		
		net.Receive( "RequestMoneyCallback", function()
			curAmt = tonumber( net.ReadString() )
		end )
	end
end )