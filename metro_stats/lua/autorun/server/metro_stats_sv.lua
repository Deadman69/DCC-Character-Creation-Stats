


--[[ include ]]
include("metro_config/metro_config_stats.lua")
AddCSLuaFile("metro_config/metro_config_stats.lua")


--[[ defining net messages ]]
util.AddNetworkString("Metro::StatsOrderToPlayer")
util.AddNetworkString("Metro::StatsOrderToServer")


if not sql.TableExists( "MetroStatsCharacters" ) then
	sql.Query([[
		CREATE TABLE MetroStatsCharacters(
		  	StatsSteamID  		VARCHAR(20)		NOT NULL,									-- CharacterOwner SteamID64
		  	StatsCharID   		INTEGER 		NOT NULL,									-- Character ID
		  	StatsPointsLeft		INTEGER			DEFAULT ']]..MConf.StatsBasePoints..[[',	-- Free Points Remaining
		  	StatsStrength		INTEGER			DEFAULT 0,									-- Level of Strength					
		  	StatsPerception		INTEGER			DEFAULT 0,									-- Level of Perception
		  	StatsEndurance		INTEGER			DEFAULT 0,									-- Level of Endurance
		  	StatsCharisma		INTEGER			DEFAULT 0,									-- Level of Charisma
		  	StatsIntelligence	INTEGER			DEFAULT 0,									-- Level of Intelligence
		  	StatsAgility		INTEGER			DEFAULT 0,									-- Level of Agility
		  	StatsLuck			INTEGER			DEFAULT 0,									-- Level of Luck

		  	PRIMARY KEY(StatsSteamID, StatsCharID),

		  	FOREIGN KEY(StatsSteamID, StatsCharID) REFERENCES MetroCharacters(CharacterOwner, CharacterID)
		)
	]])
end


--[[ Custom Functions ]]
local function playerMaxLevel(ply)
	if MConf.StatsVIPGroups[ply:GetUserGroup()] then -- if user is considered as VIP
		return (MConf.StatsMaxLevel+MConf.StatsVIPLevelAugmentation)
	else -- if he's considered as normal user
		return MConf.StatsMaxLevel
	end
end


--[[ Hooks ]]
hook.Add( "PlayerSay", "Metro::StatsHook::PlayerSay", function( ply, text )
	local playerInput = string.Explode( " ", text )
	if playerInput[1] == MConf.StatsCommandOpenMenu then
		local query = sql.Query([[
			SELECT StatsStrength, StatsPerception, StatsEndurance, StatsCharisma, StatsIntelligence, StatsAgility, StatsLuck, StatsPointsLeft
			FROM MetroStatsCharacters
			WHERE StatsSteamID = ']]..ply:SteamID64()..[[' AND StatsCharID = ']]..ply:GetNWInt("Metro::CharacterID")..[['
		]])

		net.Start("Metro::StatsOrderToPlayer")
			net.WriteString("openMainMenu")
			net.WriteTable(query[1])
		net.Send(ply)

		return ""
	elseif playerInput[1] == MConf.StatsCommandDeleteAllData then
		if ply:IsSuperAdmin() then
			GNLib.AutoTranslate( MConf.LanguageType, "Everything from the whitelist will be deleted in 3 seconds, and will be followed with a server restart", function(callback) MMNotification(ply, callback, 2, 3) end )

			if sql.TableExists( "MetroStatsCharacters" ) then
				sql.Query([[
					PRAGMA foreign_keys = OFF; 				-- Disable foreign keys constraint
					DROP TABLE MetroStatsCharacters;		-- Drop table
					PRAGMA foreign_keys = ON;				-- Enable foreign keys
				]])
			end

			timer.Simple(3, function()
				game.ConsoleCommand("changelevel "..game.GetMap().."\n")
			end)

		else
			GNLib.AutoTranslate( MConf.LanguageType, "You don't have access to this command !", function(callback) MMNotification(ply, callback, 1, 3) end )
		end

		return ""
	end
end)

hook.Add( "PlayerSpawn", "Metro::StatsHook::PlayerSpawn", function(ply)
	if not MConf.BlacklistTeams[team.GetName(ply:Team())] then
		timer.Simple(0.1, function()
			if ply:GetNWInt("Metro::CharacterID") then -- if player have choose a character
				local query = sql.Query([[
					SELECT StatsStrength, StatsPerception, StatsEndurance, StatsCharisma, StatsIntelligence, StatsAgility, StatsLuck, StatsPointsLeft
					FROM MetroStatsCharacters
					WHERE StatsSteamID = ']]..ply:SteamID64()..[[' AND StatsCharID = ']]..ply:GetNWInt("Metro::CharacterID")..[['
				]])

				if query == nil then -- if character has not been already registered
					sql.Query([[
						INSERT INTO MetroStatsCharacters(StatsSteamID, StatsCharID)
						VALUES(']]..ply:SteamID64()..[[', ']]..ply:GetNWInt("Metro::CharacterID")..[[')
					]])
					ply.MetroStatsStrength = 0
					ply.MetroStatsPerception = 0
					ply.MetroStatsEndurance = 0
					ply.MetroStatsCharisma = 0
					ply.MetroStatsIntelligence = 0
					ply.MetroStatsAgility = 0
					ply.MetroStatsLuck = 0
				else -- if character has been registered
					-- Strength
					ply.MetroStatsStrength = query[1]["StatsStrength"]

					-- Perception
					local calcul = ply:Armor() + MConf.StatsPerceptionAugmentationPerLevel * query[1]["StatsPerception"]
					ply:SetArmor(calcul)
					ply.MetroStatsPerception = query[1]["StatsPerception"]

					-- Endurance
					calcul = ply:Health() + MConf.StatsEnduranceAugmentationPerLevel * query[1]["StatsEndurance"]
					ply:SetHealth(calcul)
					ply:SetMaxHealth(calcul)
					ply.MetroStatsEndurance = query[1]["StatsEndurance"]

					-- Charisma
					ply.MetroStatsCharisma = query[1]["StatsCharisma"]

					-- Intelligence
					ply.MetroStatsIntelligence = query[1]["StatsIntelligence"]

					-- Agility
					local runSpeed = ply:GetRunSpeed()
					calcul = runSpeed + (runSpeed/100*MConf.StatsAgilityAugmentationPerLevel) * query[1]["StatsAgility"]
					ply:SetRunSpeed(calcul)
					ply.MetroStatsAgility = query[1]["StatsAgility"]

					-- Luck
					ply.MetroStatsLuck = query[1]["StatsLuck"]
				end
			end
		end)
	end
end)

hook.Add( "EntityTakeDamage", "Metro::StatsHook::EntityTakeDamage", function( target, dmginfo )
	local attacker = dmginfo:GetAttacker()
	if target:IsPlayer() and attacker:IsPlayer() and not MConf.StatsDisabledTeams[team.GetName(target:Name())] then
		local actualSwepString = string.Explode("[", tostring(attacker:GetActiveWeapon()))[3] -- keep only "weapon_crossbow]"
	 	actualSwepString = string.Replace(actualSwepString, "]", "" ) -- removing the "]"

		if MConf.StatsStrengthWeapons[actualSwepString] then
			if attacker.MetroStatsStrength ~= nil then
				local damage = dmginfo:GetDamage()
				local calcul = damage + (damage/100*MConf.StatsStrengthAugmentationPerLevel) * attacker.MetroStatsStrength
				dmginfo:SetDamage( calcul )
			end
		end
	end
end)

hook.Add( "playerGetSalary", "Metro::StatsHook::playerGetSalary", function( ply, amount )
	if not MConf.StatsDisabledTeams[team.GetName(ply:Name())] and tonumber(ply.MetroStatsLuck) > 0 then
		local calcul = amount + (amount/100*MConf.StatsLuckAugmentationPerLevel) * tonumber(ply.MetroStatsLuck)
		return false, "", calcul
	end
end)


--[[ Net receiving ]]

net.Receive("Metro::StatsOrderToServer", function(len, ply)
	local request = net.ReadString()
	if request == "applyChange" then
		local specialTable = net.ReadTable() -- SPECIAL + FreePoints
		local query = sql.Query([[
			SELECT StatsStrength, StatsPerception, StatsEndurance, StatsCharisma, StatsIntelligence, StatsAgility, StatsLuck, StatsPointsLeft
			FROM MetroStatsCharacters
			WHERE StatsSteamID = ']]..ply:SteamID64()..[[' AND StatsCharID = ']]..ply:GetNWInt("Metro::CharacterID")..[['
		]])
		-- We store all the points the player have before he change
		local totalPointsBeforeChange = query[1]["StatsStrength"] + query[1]["StatsPerception"] + query[1]["StatsEndurance"] + query[1]["StatsCharisma"] + query[1]["StatsIntelligence"] + query[1]["StatsAgility"] + query[1]["StatsLuck"] + query[1]["StatsPointsLeft"]

		local totalPointsReceived = 0
		for _, pts in pairs(specialTable) do
			totalPointsReceived = totalPointsReceived + pts
		end

		if totalPointsReceived == totalPointsBeforeChange then -- Everything is normal

			if specialTable[1] > playerMaxLevel(ply) then -- if level is superior as it should
				specialTable[8] = specialTable[1] - playerMaxLevel(ply) -- ajusting by re-giving points to FreePoints
				specialTable[1] = playerMaxLevel(ply) -- defining level
			end
			if specialTable[2] > playerMaxLevel(ply) then -- if level is superior as it should
				specialTable[8] = specialTable[2] - playerMaxLevel(ply) -- ajusting by re-giving points to FreePoints
				specialTable[2] = playerMaxLevel(ply) -- defining level
			end
			if specialTable[3] > playerMaxLevel(ply) then -- if level is superior as it should
				specialTable[8] = specialTable[3] - playerMaxLevel(ply) -- ajusting by re-giving points to FreePoints
				specialTable[3] = playerMaxLevel(ply) -- defining level
			end
			if specialTable[4] > playerMaxLevel(ply) then -- if level is superior as it should
				specialTable[8] = specialTable[4] - playerMaxLevel(ply) -- ajusting by re-giving points to FreePoints
				specialTable[4] = playerMaxLevel(ply) -- defining level
			end
			if specialTable[5] > playerMaxLevel(ply) then -- if level is superior as it should
				specialTable[8] = specialTable[5] - playerMaxLevel(ply) -- ajusting by re-giving points to FreePoints
				specialTable[5] = playerMaxLevel(ply) -- defining level
			end
			if specialTable[6] > playerMaxLevel(ply) then -- if level is superior as it should
				specialTable[8] = specialTable[6] - playerMaxLevel(ply) -- ajusting by re-giving points to FreePoints
				specialTable[6] = playerMaxLevel(ply) -- defining level
			end
			if specialTable[7] > playerMaxLevel(ply) then -- if level is superior as it should
				specialTable[8] = specialTable[7] - playerMaxLevel(ply) -- ajusting by re-giving points to FreePoints
				specialTable[7] = playerMaxLevel(ply) -- defining level
			end

			sql.Query([[
				UPDATE MetroStatsCharacters
				SET StatsStrength = ']]..specialTable[1]..[[',
					StatsPerception = ']]..specialTable[2]..[[',
					StatsEndurance = ']]..specialTable[3]..[[',
					StatsCharisma = ']]..specialTable[4]..[[',
					StatsIntelligence = ']]..specialTable[5]..[[',
					StatsAgility = ']]..specialTable[6]..[[',
					StatsLuck = ']]..specialTable[7]..[[',
					StatsPointsLeft = ']]..specialTable[8]..[['	
				WHERE StatsSteamID = ']]..ply:SteamID64()..[[' AND StatsCharID = ']]..ply:GetNWInt("Metro::CharacterID")..[['
			]])

			GNLib.AutoTranslate( MConf.LanguageType, "Your stats have been applied. But you will need to respawn to apply them !", function(callback) MMNotification(ply, callback, 2, 5) end )
		else -- player send more points than he have
			GNLib.AutoTranslate( MConf.LanguageType, "You don't have enough points !", function(callback) MMNotification(ply, callback, 1, 3) end )
		end
	end
end)


--[[ con command ]]
concommand.Add("metroStatsGive", function( ply, cmd, args )
    if ply:IsPlayer() then
    	if MConf.StatsCommandOpenAdminMenuRanksAllowed[ply:GetUserGroup()] then
	    	if not args[1] or not args[2] or not args[3] then -- if no args was supplied
	    		GNLib.AutoTranslate( MConf.LanguageType, "You have to specify the steamid 64, the character ID and the number of points !", function(callback) MMNotification(ply, callback, 1, 3) end )
	    	else
	    		if isnumber(tonumber(args[2])) then
	    			if isnumber(tonumber(args[3])) then
			    		-- Running a query to find the player
			    		local query = sql.Query("SELECT StatsSteamID, StatsCharID, StatsPointsLeft FROM MetroStatsCharacters WHERE StatsSteamID = '"..args[1].."' AND StatsCharID = '"..args[2].."'")
			    		if query ~= nil then -- player finded
			    			sql.Query("UPDATE MetroStatsCharacters SET StatsPointsLeft = '"..query[1]["StatsPointsLeft"]+args[3].."' WHERE StatsSteamID = '"..args[1].."' AND StatsCharID = '"..args[2].."'")
			    			GNLib.AutoTranslate( MConf.LanguageType, "The player have received his points !", function(callback) MMNotification(ply, callback, 2, 3) end )
			    		else -- player not finded
			    			GNLib.AutoTranslate( MConf.LanguageType, "The character for the supplied SteamID hasn't been found !", function(callback) MMNotification(ply, callback, 1, 3) end )
			    		end
			    	else
			    		GNLib.AutoTranslate( MConf.LanguageType, "Please specify a number for the amount to give !", function(callback) MMNotification(ply, callback, 1, 3) end )
			    	end
		    	else
		    		GNLib.AutoTranslate( MConf.LanguageType, "Please specify a number for the character ID !", function(callback) MMNotification(ply, callback, 1, 3) end )
		    	end
	    	end
	    else
	    	GNLib.AutoTranslate( MConf.LanguageType, "You don't have access to this command !", function(callback) MMNotification(ply, callback, 1, 3) end )
	    end
    else -- if it's the server console
    	if not args[1] or not args[2] or not args[3] then -- if no args was supplied
    		print("Metro Stats - You have to specify the steamid 64, the character ID and the number of points !")
    	else
    		if isnumber(tonumber(args[2])) then
    			if isnumber(tonumber(args[3])) then
		    		-- Running a query to find the player
		    		local query = sql.Query("SELECT StatsSteamID, StatsCharID, StatsPointsLeft FROM MetroStatsCharacters WHERE StatsSteamID = '"..args[1].."' AND StatsCharID = '"..args[2].."'")
		    		if query ~= nil then -- player finded
		    			sql.Query("UPDATE MetroStatsCharacters SET StatsPointsLeft = '"..query[1]["StatsPointsLeft"]+args[3].."' WHERE StatsSteamID = '"..args[1].."' AND StatsCharID = '"..args[2].."'")
		    			print("Metro Stats - The player have received his points !")
		    		else -- player not finded
		    			print("Metro Stats - The character for the supplied SteamID hasn't been found !")
		    		end
		    	else
		    		print("Metro Stats - Please specify a number for the amount to give !")
		    	end
	    	else
	    		print("Metro Stats - Please specify a number for the character ID !")
	    	end
    	end
    end
end)