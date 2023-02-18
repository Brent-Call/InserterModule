data:extend({
--Determines to which precision numbers in the AI Cores GUI will be displayed.
--Each player can change their individual setting at any time.
{
	type = "bool-setting",
	name = "Q-InserterModule:dynamic-recipe-whitelist",
	setting_type = "startup",
	default_value = false
},
{
	type = "int-setting",
	name = "Q-InserterModule:updates-per-tick",
	setting_type = "runtime-global",
	default_value = 3,
	minimum_value = 1,
	maximum_value = 1024
}
})