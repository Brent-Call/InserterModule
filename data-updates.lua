--Due to Bobmodules changing the limitations of my Inserter Modules, I must change them back!
--Bob changes the limitation and the message key of the modules, so I will simply revert them to what they should be:
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

data.raw.module[ "inserter-module" ].limitation = inserterModuleLimitation
data.raw.module[ "inserter-module" ].limitation_message_key = "inserter-module-limitation"

data.raw.module[ "inserter-module-2" ].limitation = inserterModuleLimitation
data.raw.module[ "inserter-module-2" ].limitation_message_key = "inserter-module-limitation"

data.raw.module[ "inserter-module-3" ].limitation = inserterModuleLimitation
data.raw.module[ "inserter-module-3" ].limitation_message_key = "inserter-module-limitation"