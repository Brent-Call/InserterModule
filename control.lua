require "util"
require "__InserterModule__/Mod_logic"

-----------------------------
--     LOCAL CONSTANTS     --
-----------------------------
--A LocalisedString containing the message that's displayed when you try to insert an Inserter Module
--into a type of machine that does not allow Inserter Modules:
local LIMITATION_ERROR_MESSAGE = { "item-limitation.Q-InserterModule:inserter-module-limitation" }
--This is a filter for subscribing to certain types of events, usually "entity was created" events for the
--four types of entities that we care about.
local SHARED_FILTER = {{ filter = "type", type = "mining-drill" }, { filter = "type", type = "beacon"  },
				   { filter = "type", type = "lab" },          { filter = "type", type = "furnace" }}
--How many ticks in between updates.
local UPDATE_INTERVAL = 30

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

-------------------------------------------------------------------------------------------
--     EVERY FEW TICKS, QUICKLY CHECK ALL TRACKED ENTITIES TO REMOVE ILLEGAL MODULES     --
-------------------------------------------------------------------------------------------

script.on_nth_tick( UPDATE_INTERVAL, function( event )
	for key, entity in pairs( global.trackedEntities ) do
		--One of the keys is "length", so skip that!  Only go with numerical keys, because the values are LuaEntities:
		if type( key ) == "number" then
			if entity.valid then
				local modulesRemoved = remove_inserter_modules_from_entity( entity )
				if modulesRemoved > 0 then
					entity.force.print( LIMITATION_ERROR_MESSAGE )
				end
			else
				--This table entry is invalid!  Remove it from the list as it's just garbage now.
				--Removing something from a table while iterating is safe, it turns out.
				stop_tracking( key )
			end
		end
	end
end )