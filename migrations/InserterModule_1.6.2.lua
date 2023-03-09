--If the player was using Industrial Revolution 2 & had modules researched but not Inserter Modules, do this:
if game.active_mods[ "IndustrialRevolution" ] and game.technology_prototypes[ "ir2-modules-1" ] then
	for _, force in pairs( game.forces ) do
		--There are 3 tiers of module technology, but they are symmetric so we can program in a loop:
		for i = 1, 3 do
			--The long suffix is "1", "2", or "3":
			local longSuffix = string.format( "%d", i )
			--The short suffix is "", "-2", or "-3":
			local shortSuffix = ""
			if i > 1 then
				shortSuffix = string.format( "-%d", i )
			end

			--If the technology is unlocked, unlock the recipes:
			if force.technologies[ "ir2-modules-"..longSuffix ].researched then
				force.recipes[ "Q-InserterModule+ir2:program-inserter-module"..shortSuffix ].enabled = true
				force.recipes[ "Q-InserterModule+ir2:deprogram-inserter-module"..shortSuffix ].enabled = true
			end
		end
	end
end