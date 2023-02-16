--Technologies required to research the Inserter Module:
data:extend({
{
	type = "technology",
	name = "inserter-module",
	icon = "__InserterModule__/Graphics/inserter-module-technology.png",
	icon_size = 32,
	effects = {{ type = "unlock-recipe", recipe = "inserter-module" }},
	prerequisites = { "modules" },
	unit =
	{
		count = 50,
		ingredients =
		{
			{ "automation-science-pack", 1 },
			{ "logistic-science-pack", 1 },
		},
		time = 30
	},
	upgrade = true,
	order = "i-i-a"
},
{
	type = "technology",
	name = "inserter-module-2",
	icon = "__InserterModule__/Graphics/inserter-module-technology.png",
	icon_size = 32,
	effects = {{ type = "unlock-recipe", recipe = "inserter-module-2" }},
	prerequisites = { "inserter-module", "advanced-electronics-2" },
	unit =
	{
		count = 75,
		ingredients =
		{
			{ "automation-science-pack", 1 },
			{ "logistic-science-pack", 1 },
			{ "chemical-science-pack", 1 },
		},
		time = 30
	},
	upgrade = true,
	order = "i-i-b"
},
{
	type = "technology",
	name = "inserter-module-3",
	icon = "__InserterModule__/Graphics/inserter-module-technology.png",
	icon_size = 32,
	effects = {{ type = "unlock-recipe", recipe = "inserter-module-3" }},
	prerequisites = { "inserter-module-2", "effectivity-module-2", "production-science-pack" },
	unit =
	{
		count = 300,
		ingredients =
		{
			{ "automation-science-pack", 1 },
			{ "logistic-science-pack", 1 },
			{ "chemical-science-pack", 1 },
			{ "production-science-pack", 1 }
		},
		time = 60
	},
	upgrade = true,
	order = "i-i-c"
}
})