--[[ include ]]
include("metro_config/metro_config_stats.lua")
AddCSLuaFile("metro_config/metro_config_stats.lua")


--[[ Create Font ]]
surface.CreateFont( "FalloutFont30", {
	font = "Overseer",
	size = 30,
})

surface.CreateFont( "FalloutFont40", {
	font = "Overseer",
	size = 40,
})

--[[ Var Creation ]]
local S, P, E, C, I, A, L, FreePoints -- Level wich will be sended




--[[ Custom Functions ]]
local function playerMaxLevel()
	if MConf.StatsVIPGroups[LocalPlayer():GetUserGroup()] then -- if user is considered as VIP
		return (MConf.StatsMaxLevel+MConf.StatsVIPLevelAugmentation)
	else -- if he's considered as normal user
		return MConf.StatsMaxLevel
	end
end


local function increasePoints(statType)
	if statType == "S" then
		if FreePoints - 1 >= 0 and S + 1 <= playerMaxLevel() then
			S = S + 1
			FreePoints = FreePoints - 1
		end
	elseif statType == "P" then
		if FreePoints - 1 >= 0 and P + 1 <= playerMaxLevel() then
			P = P + 1
			FreePoints = FreePoints - 1
		end
	elseif statType == "E" then
		if FreePoints - 1 >= 0 and E + 1 <= playerMaxLevel() then
			E = E + 1
			FreePoints = FreePoints - 1
		end
	elseif statType == "C" then
		if FreePoints - 1 >= 0 and C + 1 <= playerMaxLevel() then
			C = C + 1
			FreePoints = FreePoints - 1
		end
	elseif statType == "I" then
		if FreePoints - 1 >= 0 and I + 1 <= playerMaxLevel() then
			I = I + 1
			FreePoints = FreePoints - 1
		end
	elseif statType == "A" then
		if FreePoints - 1 >= 0 and A + 1 <= playerMaxLevel() then
			A = A + 1
			FreePoints = FreePoints - 1
		end
	elseif statType == "L" then
		if FreePoints - 1 >= 0 and L + 1 <= playerMaxLevel() then
			L = L + 1
			FreePoints = FreePoints - 1
		end
	end
end


local function decreasePoints(statType)
	if statType == "S" then
		if S - 1 >= 0 then
			S = S - 1
			FreePoints = FreePoints + 1
		end
	elseif statType == "P" then
		if P - 1 >= 0 then
			P = P - 1
			FreePoints = FreePoints + 1
		end
	elseif statType == "E" then
		if E - 1 >= 0 then
			E = E - 1
			FreePoints = FreePoints + 1
		end
	elseif statType == "C" then
		if C - 1 >= 0 then
			C = C - 1
			FreePoints = FreePoints + 1
		end
	elseif statType == "I" then
		if I - 1 >= 0 then
			I = I - 1
			FreePoints = FreePoints + 1
		end
	elseif statType == "A" then
		if A - 1 >= 0 then
			A = A - 1
			FreePoints = FreePoints + 1
		end
	elseif statType == "L" then
		if L - 1 >= 0 then
			L = L - 1
			FreePoints = FreePoints + 1
		end
	end
end



local function openMainMenu(Strength, Perception, Endurance, Charisma, Intelligence, Agility, Luck, AvailablePoints)
	S = Strength
	P = Perception
	E = Endurance
	C = Charisma
	I = Intelligence
	A = Agility
	L = Luck
	FreePoints = AvailablePoints

	gui.EnableScreenClicker( true )  -- enable mouse

	local mainPanel = vgui.Create( "DFrame" )
	mainPanel:SetSize( ScrW()/1.8, ScrH()/1.8 )
	mainPanel:Center()
	mainPanel:ShowCloseButton( false )
	mainPanel:SetDraggable(false)
	mainPanel:SetTitle( "" )
	function mainPanel:Paint( w, h )
	    draw.RoundedBox( 2, 0, 0, w, h, Color( 4, 4, 4 ) )
	    draw.SimpleText( "CHARACTER", "FalloutFont30", w/2.18, h/128, Color(16, 193, 20), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)

	    surface.SetDrawColor(16,193,20)
    	surface.DrawRect(w/128, h/16, w/1.015, 2) -- big line

    	draw.SimpleText( "SPECIAL", "FalloutFont30", w/32, h/14, Color(16, 193, 20))


    	-- S
    	draw.SimpleText( "Strength", "FalloutFont30", w/32, h/3.98, Color(16, 193, 20))

    	GNLib.DrawTriangle( w/2.4, h/3.6, 15, Color(16,193,20), 3 )
    	if S < 10 then
    		draw.SimpleText( S, "FalloutFont30", w/2.2, h/3.98, Color(16, 193, 20))
    	else
    		draw.SimpleText( S, "FalloutFont30", w/2.22, h/3.98, Color(16, 193, 20))
    	end
    	GNLib.DrawTriangle( w/2, h/3.6, 15, Color(16,193,20), 1 )

    	-- P
    	draw.SimpleText( "Perception", "FalloutFont30", w/32, h/3.25, Color(16, 193, 20))

    	GNLib.DrawTriangle( w/2.4, h/3, 15, Color(16,193,20), 3 )
    	if P < 10 then
    		draw.SimpleText( P, "FalloutFont30", w/2.2, h/3.25, Color(16, 193, 20))
    	else
    		draw.SimpleText( P, "FalloutFont30", w/2.22, h/3.25, Color(16, 193, 20))
    	end
    	GNLib.DrawTriangle( w/2, h/3, 15, Color(16,193,20), 1 )

    	-- E
    	draw.SimpleText( "Endurance", "FalloutFont30", w/32, h/2.8, Color(16, 193, 20))

    	GNLib.DrawTriangle( w/2.4, h/2.6, 15, Color(16,193,20), 3 )
    	if E < 10 then
    		draw.SimpleText( E, "FalloutFont30", w/2.2, h/2.8, Color(16, 193, 20))
    	else
    		draw.SimpleText( E, "FalloutFont30", w/2.22, h/2.8, Color(16, 193, 20))
    	end
    	GNLib.DrawTriangle( w/2, h/2.6, 15, Color(16,193,20), 1 )

    	-- C
    	draw.SimpleText( "Charisma", "FalloutFont30", w/32, h/2.43, Color(16, 193, 20))

    	GNLib.DrawTriangle( w/2.4, h/2.28, 15, Color(16,193,20), 3 )
    	if C < 10 then
    		draw.SimpleText( C, "FalloutFont30", w/2.2, h/2.43, Color(16, 193, 20))
    	else
    		draw.SimpleText( C, "FalloutFont30", w/2.22, h/2.43, Color(16, 193, 20))
    	end
    	GNLib.DrawTriangle( w/2, h/2.28, 15, Color(16,193,20), 1 )

    	-- I
    	draw.SimpleText( "Intelligence", "FalloutFont30", w/32, h/2.12, Color(16, 193, 20))

    	GNLib.DrawTriangle( w/2.4, h/2, 15, Color(16,193,20), 3 )
    	if I < 10 then
    		draw.SimpleText( I, "FalloutFont30", w/2.2, h/2.12, Color(16, 193, 20))
    	else
    		draw.SimpleText( I, "FalloutFont30", w/2.22, h/2.12, Color(16, 193, 20))
    	end
    	GNLib.DrawTriangle( w/2, h/2, 15, Color(16,193,20), 1 )

    	-- A
    	draw.SimpleText( "Agility", "FalloutFont30", w/32, h/1.9, Color(16, 193, 20))

    	GNLib.DrawTriangle( w/2.4, h/1.8, 15, Color(16,193,20), 3 )
    	if A < 10 then
    		draw.SimpleText( A, "FalloutFont30", w/2.2, h/1.9, Color(16, 193, 20))
    	else
    		draw.SimpleText( A, "FalloutFont30", w/2.22, h/1.9, Color(16, 193, 20))
    	end
    	GNLib.DrawTriangle( w/2, h/1.8, 15, Color(16,193,20), 1 )

    	-- L
    	draw.SimpleText( "Luck", "FalloutFont30", w/32, h/1.7, Color(16, 193, 20))

    	GNLib.DrawTriangle( w/2.4, h/1.625, 15, Color(16,193,20), 3 )
    	if L < 10 then
    		draw.SimpleText( L, "FalloutFont30", w/2.2, h/1.7, Color(16, 193, 20))
    	else
    		draw.SimpleText( L, "FalloutFont30", w/2.22, h/1.7, Color(16, 193, 20))
    	end
    	GNLib.DrawTriangle( w/2, h/1.625, 15, Color(16,193,20), 1 )



    	draw.SimpleText( FreePoints, "FalloutFont40", w/32, h/1.4, Color(16, 193, 20))
    	draw.SimpleText( "points remaining", "FalloutFont30", w/15, h/1.395, Color(16, 193, 20))
	end


	local resetButton = vgui.Create( "DButton", mainPanel )
	resetButton:SetText( "RESET" )
	resetButton:CenterHorizontal(0.4)
	resetButton:CenterVertical(0.73)
	resetButton:SetSize( 80, 50 )
	resetButton.DoClick = function()
		FreePoints = S + P + E + C + I + A + L + FreePoints
		S,P,E,C,I,A,L = 0,0,0,0,0,0,0
	end
	function resetButton:Paint( w, h )
	    surface.SetDrawColor(255,193,20)
    	surface.DrawRect(w, h, w, h)
	end

	local applyButton = vgui.Create( "DButton", mainPanel )
	applyButton:SetText( "APPLY" )
	applyButton:CenterHorizontal(0.5)
	applyButton:CenterVertical(0.73)
	applyButton:SetSize( 80, 50 )
	applyButton.DoClick = function()
		local specialTable = {}
		table.insert(specialTable, S)
		table.insert(specialTable, P)
		table.insert(specialTable, E)
		table.insert(specialTable, C)
		table.insert(specialTable, I)
		table.insert(specialTable, A)
		table.insert(specialTable, L)
		table.insert(specialTable, FreePoints)

		net.Start("Metro::StatsOrderToServer")
			net.WriteString("applyChange")
			net.WriteTable(specialTable)
		net.SendToServer()

		mainPanel:Remove()
		gui.EnableScreenClicker( false )  -- disable mouse
	end
	function applyButton:Paint( w, h )
	    surface.SetDrawColor(255,193,20)
    	surface.DrawRect(w, h, w, h)
	end

	local healthButton = vgui.Create( "DButton", mainPanel )
	healthButton:SetText( "HP "..LocalPlayer():Health().." / "..LocalPlayer():GetMaxHealth() )
	healthButton:CenterHorizontal(0.057)
	healthButton:CenterVertical(0.9)
	healthButton:SetSize( 330, 50 )
	healthButton.DoClick = function()
		mainPanel:Remove()
		gui.EnableScreenClicker( false )  -- disable mouse
	end
	-- function healthButton:Paint( w, h )
	--     surface.SetDrawColor(255,193,20)
 --    	surface.DrawRect(w, h, w, h)
	-- end

	-- THIS ONE COMES SOON....
	-- local inventoryPodsButton = vgui.Create( "DButton", mainPanel )
	-- inventoryPodsButton:SetText("")
	-- inventoryPodsButton:CenterHorizontal(0.378)
	-- inventoryPodsButton:CenterVertical(0.9)
	-- inventoryPodsButton:SetSize( 330, 50 )
	-- inventoryPodsButton.DoClick = function()
	-- 	mainPanel:Remove()
	-- 	gui.EnableScreenClicker( false )  -- disable mouse
	-- end
	-- function inventoryPodsButton:Paint( w, h )
	--     	surface.SetDrawColor(255,193,20)
 	--    	surface.DrawRect(w, h, w, h)
	-- end

	local armorButton = vgui.Create( "DButton", mainPanel )
	armorButton:SetText( "Armor "..LocalPlayer():Armor().." / "..P*MConf.StatsPerceptionAugmentationPerLevel )
	armorButton:CenterHorizontal(0.7)
	armorButton:CenterVertical(0.9)
	armorButton:SetSize( 330, 50 )
	armorButton.DoClick = function()
		mainPanel:Remove()
		gui.EnableScreenClicker( false )  -- disable mouse
	end
	function armorButton:Paint( w, h )
	    surface.SetDrawColor(255,193,20)
    	surface.DrawRect(w, h, w, h)
	end


	local falloutImg = vgui.Create("DImage", mainPanel)
	falloutImg:SetSize(200, 246)
	falloutImg:CenterHorizontal(0.75)
	falloutImg:CenterVertical(0.5)
	falloutImg:SetImage("deadman/metro_stats_fallout_pic.png")




	--[[ Invisibles buttons on the triangles ]]

	local sLeftButton = vgui.Create( "DButton", mainPanel )
	sLeftButton:SetText("")
	sLeftButton:CenterHorizontal(0.435)
	sLeftButton:CenterVertical(0.27)
	sLeftButton:SetSize( 25, 25 )
	sLeftButton.DoClick = function()
		decreasePoints("S")
	end
	function sLeftButton:Paint() end
	local sRightButton = vgui.Create( "DButton", mainPanel )
	sRightButton:SetText("")
	sRightButton:CenterHorizontal(0.52)
	sRightButton:CenterVertical(0.27)
	sRightButton:SetSize( 25, 25 )
	sRightButton.DoClick = function()
		increasePoints("S")
	end
	function sRightButton:Paint() end

	local pLeftButton = vgui.Create( "DButton", mainPanel )
	pLeftButton:SetText("")
	pLeftButton:CenterHorizontal(0.435)
	pLeftButton:CenterVertical(0.325)
	pLeftButton:SetSize( 25, 25 )
	pLeftButton.DoClick = function()
		decreasePoints("P")
	end
	function pLeftButton:Paint() end
	local pRightButton = vgui.Create( "DButton", mainPanel )
	pRightButton:SetText("")
	pRightButton:CenterHorizontal(0.52)
	pRightButton:CenterVertical(0.325)
	pRightButton:SetSize( 25, 25 )
	pRightButton.DoClick = function()
		increasePoints("P")
	end
	function pRightButton:Paint() end

	local eLeftButton = vgui.Create( "DButton", mainPanel )
	eLeftButton:SetText("")
	eLeftButton:CenterHorizontal(0.435)
	eLeftButton:CenterVertical(0.38)
	eLeftButton:SetSize( 25, 25 )
	eLeftButton.DoClick = function()
		decreasePoints("E")
	end
	function eLeftButton:Paint() end
	local eRightButton = vgui.Create( "DButton", mainPanel )
	eRightButton:SetText("")
	eRightButton:CenterHorizontal(0.52)
	eRightButton:CenterVertical(0.38)
	eRightButton:SetSize( 25, 25 )
	eRightButton.DoClick = function()
		increasePoints("E")
	end
	function eRightButton:Paint() end

	local cLeftButton = vgui.Create( "DButton", mainPanel )
	cLeftButton:SetText("")
	cLeftButton:CenterHorizontal(0.435)
	cLeftButton:CenterVertical(0.44)
	cLeftButton:SetSize( 25, 25 )
	cLeftButton.DoClick = function()
		decreasePoints("C")
	end
	function cLeftButton:Paint() end
	local cRightButton = vgui.Create( "DButton", mainPanel )
	cRightButton:SetText("")
	cRightButton:CenterHorizontal(0.52)
	cRightButton:CenterVertical(0.44)
	cRightButton:SetSize( 25, 25 )
	cRightButton.DoClick = function()
		increasePoints("C")
	end
	function cRightButton:Paint() end

	local iLeftButton = vgui.Create( "DButton", mainPanel )
	iLeftButton:SetText("")
	iLeftButton:CenterHorizontal(0.435)
	iLeftButton:CenterVertical(0.50)
	iLeftButton:SetSize( 25, 25 )
	iLeftButton.DoClick = function()
		decreasePoints("I")
	end
	function iLeftButton:Paint() end
	local iRightButton = vgui.Create( "DButton", mainPanel )
	iRightButton:SetText("")
	iRightButton:CenterHorizontal(0.52)
	iRightButton:CenterVertical(0.50)
	iRightButton:SetSize( 25, 25 )
	iRightButton.DoClick = function()
		increasePoints("I")
	end
	function iRightButton:Paint() end

	local aLeftButton = vgui.Create( "DButton", mainPanel )
	aLeftButton:SetText("")
	aLeftButton:CenterHorizontal(0.435)
	aLeftButton:CenterVertical(0.56)
	aLeftButton:SetSize( 25, 25 )
	aLeftButton.DoClick = function()
		decreasePoints("A")
	end
	function aLeftButton:Paint() end
	local aRightButton = vgui.Create( "DButton", mainPanel )
	aRightButton:SetText("")
	aRightButton:CenterHorizontal(0.52)
	aRightButton:CenterVertical(0.56)
	aRightButton:SetSize( 25, 25 )
	aRightButton.DoClick = function()
		increasePoints("A")
	end
	function aRightButton:Paint() end

	local lLeftButton = vgui.Create( "DButton", mainPanel )
	lLeftButton:SetText("")
	lLeftButton:CenterHorizontal(0.435)
	lLeftButton:CenterVertical(0.62)
	lLeftButton:SetSize( 25, 25 )
	lLeftButton.DoClick = function()
		decreasePoints("L")
	end
	function lLeftButton:Paint() end
	local lRightButton = vgui.Create( "DButton", mainPanel )
	lRightButton:SetText("")
	lRightButton:CenterHorizontal(0.52)
	lRightButton:CenterVertical(0.62)
	lRightButton:SetSize( 25, 25 )
	lRightButton.DoClick = function()
		increasePoints("L")
	end
	function lRightButton:Paint() end

end





--[[ Net receiving ]]

net.Receive("Metro::StatsOrderToPlayer", function()
	local order = net.ReadString()
	if order == "openMainMenu" then
		local pTable = net.ReadTable()
		openMainMenu(tonumber(pTable["StatsStrength"]), tonumber(pTable["StatsPerception"]), tonumber(pTable["StatsEndurance"]), tonumber(pTable["StatsCharisma"]), tonumber(pTable["StatsIntelligence"]), tonumber(pTable["StatsAgility"]), tonumber(pTable["StatsLuck"]), tonumber(pTable["StatsPointsLeft"]))
	end
end)