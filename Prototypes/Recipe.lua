--We load differently depending on whether or not the mod Industrial Revolution 2 (IR2) is also enabled:
if mods[ "IndustrialRevolution" ] and data.raw[ "item-subgroup" ][ "ir2-module-reversed" ] then
	--This is the version that's loaded only if IR2 is enabled:
	--We have both "program this module" recipes & "deprogram this module" recipes.
	--The localization file calls them "format" which means to prepare a storage medium (such as a disk) to receive data.
	--In the context of IR2 that means to erase the module from the computer, returning it to a blank-slate state to be used again.
	--However, since most of the numbers are the same for each tier, we'll generate them with a simple algorithm:
	for i = 1, 3 do
		--The long suffix is "1", "2", or "3":
		local longSuffix = string.format( "%d", i )
		--The short suffix is "", "-2", or "-3":
		local shortSuffix = ""
		if i > 1 then
			shortSuffix = string.format( "-%d", i )
		end
		local associatedInserterModuleItem = data.raw.module[ "Q-InserterModule:inserter-module"..shortSuffix ]
		--Create 2 recipes per tier of module:
		data:extend({
			{
				type = "recipe",
				name = "Q-InserterModule+ir2:program-inserter-module"..shortSuffix,
				enabled = false,
				energy_required = data.raw.recipe[ "program-productivity-module"..shortSuffix ].energy_required,
				ingredients = {{ "computer-mk"..longSuffix, 1 }},
				result = "Q-InserterModule:inserter-module"..shortSuffix,
				--The following are the stats that IR2 uses so I just copied them
				hide_from_stats = true,
				always_show_products = true,
				localised_name = { "recipe-name.program-module", { "item-name.Q-InserterModule:inserter-module"..shortSuffix }},
				order = name,
				IR_tech_rebuild_ignore = true, --I don't know what this does but it's in the IR2 code so I'll just leave it
			},
			{
				type = "recipe",
				name = "Q-InserterModule+ir2:deprogram-inserter-module"..shortSuffix,
				enabled = false,
				energy_required = data.raw.recipe[ "deprogram-productivity-module"..shortSuffix ].energy_required,
				ingredients = {{ "Q-InserterModule:inserter-module"..shortSuffix, 1 }},
				result = "computer-mk"..longSuffix,
				--The following are the stats that IR2 uses so I just copied them
				icons =
				{
					{ icon = associatedInserterModuleItem.icon, icon_size = associatedInserterModuleItem.icon_size },
					{ icon = "__IndustrialRevolution__/graphics/icons/64/deprogram.png", icon_size = 64, scale = 0.25, shift = { -8, 8 }},
				},
				energy_required = data.raw.recipe[ "deprogram-productivity-module"..shortSuffix ].energy_required,
				subgroup = "ir2-module-reversed",
				hide_from_stats = true,
				allow_as_intermediate = false,
				allow_intermediates = false,
				always_show_products = true,
				localised_name = { "recipe-name.deprogram-module", { "item-name.Q-InserterModule:inserter-module"..shortSuffix }},
				order = name,
				IR_tech_rebuild_ignore = true --I don't know what this does but it's in the IR2 code so I'll just leave it
			},
		})
	end
else
	--This is the version that's loaded normally, if IR2 isn't enabled.
	--This version follows the pattern of vanilla Factorio, with only minor differences.
	data:extend({
	{
		type = "recipe",
		name = "Q-InserterModule:inserter-module",
		enabled = false,
		energy_required = 15,
		ingredients = 
		{
			{ "electronic-circuit", 5 },
			{ "advanced-circuit", 5 }
		},
		result = "Q-InserterModule:inserter-module"
	},
	{
		type = "recipe",
		name = "Q-InserterModule:inserter-module-2",
		enabled = false,
		energy_required = 30,
		ingredients = 
		{
			{ "Q-InserterModule:inserter-module", 2 },
			{ "advanced-circuit", 5 },
			{ "processing-unit", 5 }
		},
		result = "Q-InserterModule:inserter-module-2"
	},
	{
		type = "recipe",
		name = "Q-InserterModule:inserter-module-3",
		enabled = false,
		energy_required = 60,
		ingredients = 
		{
			{ "Q-InserterModule:inserter-module-2", 2 },
			{ "effectivity-module-2", 1 },
			{ "processing-unit", 5 }
		},
		result = "Q-InserterModule:inserter-module-3"
	}
	})
end