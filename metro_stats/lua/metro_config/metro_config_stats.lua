MConf = MConf or {}
MConf.StatsVersion = 1.3

MConf.StatsCommandOpenMenu = "!stats" -- command to open the menu
MConf.StatsCommandDeleteAllData = "!statsDeleteAll" -- WARNING: Will delete ALL data from the Stats addon, usable only by superadmins

MConf.StatsCommandOpenAdminMenuRanksAllowed = { -- Ranks allowed to give points via the command "metroStatsGive <steamid64> <character ID> <number of points>"
	["superadmin"] = true,
	["admin"] = true,
	["mod"] = true,
}

MConf.StatsBasePoints = 3 -- Base points for each players
MConf.StatsMaxLevel = 10 -- Maximum level per stats for normal people
MConf.StatsVIPLevelAugmentation = 5 -- VIP Will get 5 levels more than normal people
MConf.StatsVIPGroups = { -- Groups considered as VIP
	["superadmin"] = true,
	["admin"] = true,
	["vip"] = true,
}


MConf.StatsDisabledTeams = { -- Theses DARKRP Teams won't be affected by the stats levels
	["Admin"] = true,
	["Monster"] = true,
	["Angry monster"] = true,
}



--[[ Strength part ]]
MConf.StatsStrengthAugmentationPerLevel = 5 -- Will increase the base damage for the selected weapons by 5% per level
MConf.StatsStrengthWeapons = { -- Weapons affected
	["weapon_crowbar"] = true,
	["weapon_stunstick"] = true,
	["weapon_fists"] = true,
}


--[[ Perception part ]]
MConf.StatsPerceptionAugmentationPerLevel = 10 -- Will increase base armor by 10 per level (limit to 255)


--[[ Endurance part ]]
MConf.StatsEnduranceAugmentationPerLevel = 10 -- Will increase base HP by 10 per level


--[[ Charisma part ]]
-- Charisma would decrease sale prices by 2.5% each time


--[[ Intelligence part ]]
-- No effect for the moment


--[[ Agility part ]]
MConf.StatsAgilityAugmentationPerLevel = 5 -- Will increase speed by +5% per level


--[[ Luck part ]]
MConf.StatsLuckAugmentationPerLevel = 5 -- Will increase your salary by 5% per level