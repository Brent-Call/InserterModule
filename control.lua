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
	--We will iterate through the sparse array, global.trackedEntities.
	--However, we will only iterate through 1 element per tick.
	--This line of code does the following:
	--If global.keyToProcess is a key in the table global.trackedEntities, it fetches the next key-value pair & stores the key
	--in global.keyToProcess & the value in entity.  However, if it reaches the end of the table, then it returns nil instead.
	--If global.keyToProcess is nil (as it would be upon, say, loading an old save) then it fetches the first key-value pair instead.
	--The fact keyToProcess is stored in the global table means that this persists through multiple ticks & even through save/load.
	global.keyToProcess, entity = next( global.trackedEntities, global.keyToProcess )

	--So now we have a key-value pair, but it's not guaranteed that it's valid!
	--That's because if we fell off the end of the sparse array then global.keyToProcess will be nil.
	--The table global.trackedEntities also contains another key, the string "length".  The associated value is the number of
	--entities in the sparse array.
	--On top of all that, it's possible that the entity in question has become invalid since last iteration.
	--The solution is to only process entity if global.keyToProcess is the registration number of some entity.
	if type( global.keyToProcess ) == "number" then
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
	--The above code iterates through the table EVERY TICK except it only processes 1 element per tick.
	--So, at the start of the game we do nothing since the only pair in global.trackedEntities is "length" = 0.
	--But as the player builds their factory, we iterate through again slower & slower & slower because the length of that table
	--keeps on growing.  We also skip a tick whenever we reach the end of the array, but since the game runs at 60 ticks per second
	--missing a few ticks here & there is inconsequential.  We also have undefined behavior if entities are added partway into
	--an iteration--not that an error is caused, but we don't know if we'll process that entity this cycle or next cycle.
	--That doesn't matter!  I don't know what this technique is officially called, but I choose to call it "fuzzy iteration"--
	--where my goal is to iterate through the entire sparse array but if I miss a few elements here & there it's no big deal
	--because they will be processed on the next iteration.
	--This means that in a megabase it could potentially be a minute before any given entity is processed, but by that time
	--the scale of the game has increased, so getting extra productivity from a few illegally placed Inserter Modules
	--is miniscule compared to how much the factory produces overall.
end )