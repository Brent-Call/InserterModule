--This was old code for compatibility with Bobmodules.
--Instead of testing to see if it's still needed or providing any updates, I'll just leave it pretty much as-is.
local inserterModuleLimitation =
{
	"burner-inserter",
	"inserter",
	"long-handed-inserter",
	"fast-inserter",
	"filter-inserter",
	"stack-inserter",
	"stack-filter-inserter"
}

data.raw.module[ "Q-InserterModule:inserter-module" ].limitation = inserterModuleLimitation
data.raw.module[ "Q-InserterModule:inserter-module" ].limitation_message_key = "Q-InserterModule:inserter-module-limitation"

data.raw.module[ "Q-InserterModule:inserter-module-2" ].limitation = inserterModuleLimitation
data.raw.module[ "Q-InserterModule:inserter-module-2" ].limitation_message_key = "Q-InserterModule:inserter-module-limitation"

data.raw.module[ "Q-InserterModule:inserter-module-3" ].limitation = inserterModuleLimitation
data.raw.module[ "Q-InserterModule:inserter-module-3" ].limitation_message_key = "Q-InserterModule:inserter-module-limitation"