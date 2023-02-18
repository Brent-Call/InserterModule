require "util"
require "__InserterModule__/Mod_logic"

-----------------------------
--     LOCAL CONSTANTS     --
-----------------------------
--This is a filter for subscribing to certain types of events, usually "entity was created" events for the
--four types of entities that we care about.
local SHARED_FILTER = {{ filter = "type", type = "mining-drill" }, { filter = "type", type = "beacon"  },
				   { filter = "type", type = "lab" },          { filter = "type", type = "furnace" }}

-------------------------------------------------------------------------
--     EVENT HANDLERS SPECIFICALLY FOR UPDATING THE TRACKING TABLE     --
-------------------------------------------------------------------------

--Setup tracking table when a new game is created or this mod is added to a save for the first time:
script.on_init( function()
	create_tracking_table()
end )

--Called when a player builds an entity:
script.on_event( defines.events.on_built_entity, function( event )
	begin_tracking( event.created_entity )
end, SHARED_FILTER )

--Called when the map editor clones an area onto another area:
script.on_event( defines.events.on_entity_cloned, function( event )
	begin_tracking( event.destination )
end, SHARED_FILTER )

--Called when a Construction Robot builds an entity:
script.on_event( defines.events.on_robot_built_entity, function( event )
	begin_tracking( event.created_entity )
end, SHARED_FILTER )

--Called when a piece of Lua code builds an entity & allows other mods to know about it:
script.on_event( defines.events.script_raised_built, function( event )
	begin_tracking( event.entity )
end, SHARED_FILTER )

--Called when an entity is destroyed for any reason.
--This is not the only place we keep track of whether entities are valid or not;
--we will also remove invalid entries as we come across them when iterating through global.trackedEntities
script.on_event( defines.events.on_entity_destroyed, function( event )
	stop_tracking( event.registration_number )
end )

-------------------------------------------------------------------------------------------------------------
--     EVERY FEW TICKS, QUICKLY CHECK ALL TRACKED ENTITIES TO REMOVE ILLEGALLY PLACED INSERTER MODULES     --
-------------------------------------------------------------------------------------------------------------

--Instead of iterating through the entire table at once every N ticks, we process 1 element per tick until we reach
--the end of the table, then start over again.
script.on_event( defines.events.on_tick, function( event )
	for i = 1, settings.global[ "Q-InserterModule:updates-per-tick" ].value do
		single_step_update_tracked_entities()
		if global.keyToProcess == nil then
			--This is to prevent us from iterating through the table multiple
			--times per tick when it's small & the setting is at a high value.
			break
		end
	end
end )