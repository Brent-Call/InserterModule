data:extend({
{
	type = "recipe",
	name = "Q-InserterModule:inserter-module",
	--Normal recipe difficulty:
	normal =
	{
		enabled = false,
		energy_required = 15,
		ingredients = 
		{
			{ "electronic-circuit", 5 },
			{ "advanced-circuit", 5 }
		},
		result = "Q-InserterModule:inserter-module"
	},
	--Expensive recipe difficulty:
	expensive =
	{
		enabled = false,
		energy_required = 15,
		ingredients = 
		{
			{ "electronic-circuit", 10 },
			{ "advanced-circuit", 10 }
	    	},
		result = "Q-InserterModule:inserter-module"
	}
},
{
	type = "recipe",
	name = "Q-InserterModule:inserter-module-2",
	--Normal recipe difficulty:
	normal =
	{
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
	--Expensive recipe difficulty:
	expensive =
	{
		enabled = false,
		energy_required = 30,
		ingredients = 
		{
			{ "Q-InserterModule:inserter-module", 2 },
			{ "advanced-circuit", 10 },
			{ "processing-unit", 10 }
		},
		result = "Q-InserterModule:inserter-module-2"
	}
},
{
	type = "recipe",
	name = "Q-InserterModule:inserter-module-3",
	--Normal recipe difficulty:
	normal =
	{
		enabled = false,
		energy_required = 60,
		ingredients = 
		{
      		{ "Q-InserterModule:inserter-module-2", 2 },
      		{ "effectivity-module-2", 1 },
      		{ "processing-unit", 5 }
		},
		result = "Q-InserterModule:inserter-module-3"
	},
	--Expensive recipe difficulty:
	expensive =
	{
		enabled = false,
		energy_required = 60,
		ingredients = 
		{
			{ "Q-InserterModule:inserter-module-2", 2 },
			{ "effectivity-module-2", 1 },
			{ "processing-unit", 10 }
    		},
		result = "Q-InserterModule:inserter-module-3"
	}
}
})