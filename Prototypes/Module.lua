--This function returns a list containing the names of inserter recipes that the Inserter Module can improve:
--The vanilla inserters have always been supported.
--Bob's express inserters from his boblogistics mod are supported beginning in version 1.1.1 of InserterModule.
function insertermodulelimitation()
	local allowedInserters =
	{
		"burner-inserter",
		"inserter",
		"long-handed-inserter",
		"fast-inserter",
		"filter-inserter",
		"stack-inserter",
		"stack-filter-inserter"
	}
	if bobmods and bobmods.logistics then
		table.insert( allowedInserters, "express-inserter" )
		table.insert( allowedInserters, "express-filter-inserter" )
		table.insert( allowedInserters, "express-stack-inserter" )
		table.insert( allowedInserters, "express-stack-filter-inserter" )
	end
	return allowedInserters
end

data:extend({
{ type = "module-category", name = "inserter" },
{
	type = "module",
	name = "inserter-module",
	icon = "__InserterModule__/Graphics/inserter-module.png",
	icon_size = 32,
	subgroup = "module",
	category = "inserter",
	tier = 1,
	order = "d[inserter]-a[inserter-module]",
	stack_size = 50,
	default_request_amount = 10,
	effect = { productivity = { bonus = 0.04 }, consumption = { bonus = 0.3 }, pollution = { bonus = 0.8 }},
	limitation = insertermodulelimitation(),
	limitation_message_key = "inserter-module-limitation"
},
{
	type = "module",
	name = "inserter-module-2",
	icon = "__InserterModule__/Graphics/inserter-module-2.png",
	icon_size = 32,
	subgroup = "module",
	category = "inserter",
	tier = 2,
	order = "d[inserter]-b[inserter-module-2]",
	stack_size = 50,
	default_request_amount = 10,
	effect = { productivity = { bonus = 0.07 }, consumption = { bonus = 0.5 }, pollution = { bonus = 0.4 }},
	limitation = insertermodulelimitation(),
	limitation_message_key = "inserter-module-limitation"
},
{
	type = "module",
	name = "inserter-module-3",
	icon = "__InserterModule__/Graphics/inserter-module-3.png",
	icon_size = 32,
	subgroup = "module",
	category = "inserter",
	tier = 3,
	order = "d[inserter]-c[inserter-module-3]",
	stack_size = 50,
	default_request_amount = 10,
	effect = { productivity = { bonus = 0.13 }, consumption = { bonus = 0.8 }},
	limitation = insertermodulelimitation(),
	limitation_message_key = "inserter-module-limitation"
}
})

--Below is a table for the inserter modules:
--Tier|       Effects      |           Math--efficiency           |
--Tier|Prod.|Consump.|Poll.|Consump. per 1 prod.|Poll. per 1 prod.|
--  1 | +4% |  +30%  |+80% |      7.5000        |     20.0000     |
--  2 | +7% |  +50%  |+40% |      7.1428        |      5.7142     |
--  3 |+13% |  +80%  |  0% |      6.1538        |      0.0000     |