--If Industrial Revolution 2 is enabled, then we merge the Inserter Module into the IR2 Modules techs:
if mods[ "IndustrialRevolution" ] and data.raw.technology[ "ir2-modules-1" ] then
	--There are 3 tiers of module technology, but they are symmetric so we can program in a loop:
	for i = 1, 3 do
		--The long suffix is "1", "2", or "3":
		local longSuffix = string.format( "%d", i )
		--The short suffix is "", "-2", or "-3":
		local shortSuffix = ""
		if i > 1 then
			shortSuffix = string.format( "-%d", i )
		end
		--Delete the technologies defined by this mod:
		data.raw.technology[ "Q-InserterModule:inserter-module"..shortSuffix ] = nil

		--Add to the effects of the technologies in the IR2 mod:
		table.insert( data.raw.technology[ "ir2-modules-"..longSuffix ].effects,
			{ type = "unlock-recipe", recipe = "Q-InserterModule+ir2:program-inserter-module"..shortSuffix })
		table.insert( data.raw.technology[ "ir2-modules-"..longSuffix ].effects,
			{ type = "unlock-recipe", recipe = "Q-InserterModule+ir2:deprogram-inserter-module"..shortSuffix })
	end
end