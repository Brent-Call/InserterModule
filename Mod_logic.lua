-----------------------------
--     LOCAL CONSTANTS     --
-----------------------------
--The name of the module category prototype associated with Inserter Modules:
local INSERTER_MODULE_CATEGORY = "Q-InserterModule:inserter"
--This is the table of search parameters when initializing the tracking table on an existing savefile.
--We add ALL entities that are of type "mining-drill", "beacon", "lab", or "furnace".
--These types of entities are chosen because they support modules but don't have crafting recipes (except furnace), so
--according to the game engine rules module limitations are ignored in such machines.  (Furnaces are a special case.)
--The special case with furnaces is that sometimes they have crafting recipes, sometimes they don't, & they only check
--for the module limitation if they have crafting recipes.
local SEARCH_PARAMETERS = { type = { "mining-drill", "beacon", "lab", "furnace" }}

-------------------------------------------
--     FUNCTIONS GOVERNING MOD LOGIC     --
-------------------------------------------
--Checks to see if a type of item is a module in the INSERTER_MOUDLE_CATEGORY category.
--@param itemName	A string containing the name of an item prototype.
--@return			true if the type of item is a module & that module is from the INSERTER_MODULE_CATEGORY category.
--				false otherwise
--				false if itemName is nil or if it is not the name of a legal item prototype.
function get_is_a_type_of_inserter_module( itemName )
	if not itemName then
		return false
	end
	local itemPrototype = game.item_prototypes[ itemName ]
	if itemPrototype and itemPrototype.valid and itemPrototype.category == INSERTER_MODULE_CATEGORY then
		return true
	end
	--Else:
	return false
end

--Checks an entity to determine if that entity has an Inserter Module inside of it.
--If an Inserter Module is found, removes it, putting it as an item on the ground.
--Only checks the entity's module inventory, meaning if there is for example a chest
--or a crafting machine set to craft said modules, that doesn't count.
--Note that this function removes an Inserter Module from ANY entity, even an entity that is meant to have one of those
--modules inside of it!
--@param entity	A LuaEntity object.  Doesn't need to be valid or even non-nil.
--@return			The number of Inserter Modules removed from the entity or 0 if none were removed.
function remove_inserter_modules_from_entity( entity )
	if not entity or not entity.valid then
		return 0
	end
	local moduleInventory = entity.get_module_inventory()
	--moduleInventory will be nil if the entity doesn't support modules:
	if not moduleInventory then
		return 0
	end
	--Else, there is a module inventory, so now iterate through each item inside it.
	--Also keep track of the number of modules removed.
	local countModulesRemoved = 0;
	for itemName, amountInInventory in pairs( moduleInventory.get_contents()) do
		if get_is_a_type_of_inserter_module( itemName ) then
			--Inserter Module detected!  Attempt to remove it, but be careful so as to not duplicate items.
			local numItemsRemoved = moduleInventory.remove({ name = itemName, count = amountInInventory })
			if numItemsRemoved > 0 then
				local surface = entity.surface
				--Search paramters are:
				--	Find a place to put an "item-on-ground", begin the search at the center of the entity's position,
				--	infinitely large search radius, search positions in increments of 0.1, & don't snap to grid.
				local where = surface.find_non_colliding_position( "item-on-ground", entity.position, 0, 0.1, false )
				surface.create_entity({ name = "item-on-ground", position = where,
						force = entity.force, stack = { name = itemName, count = numItemsRemoved }})
				countModulesRemoved = countModulesRemoved + numItemsRemoved
			end
		end
	end
	return countModulesRemoved
end

-----------------------------------------------------------------------
--     FUNCTIONS FOR MANAGING THIS MOD'S INTERNAL TRACKING TABLE     --
-----------------------------------------------------------------------
--Adds an entity to the list of entities being tracked by this mod:
--@param entity	The LuaEntity object corresponding to the entity we'll track.
--				If we are already tracking that LuaEntity, does nothing.
--@return			nil
function begin_tracking( entity )
	--Get a unique registration number from the global script object:
	--What's cool is that registration persists through save/load cycles & registration is global among all mods:
	local regNumber = script.register_on_entity_destroyed( entity )
	if global.trackedEntities[ regNumber ] == nil then
		global.trackedEntities[ regNumber ] = entity
		global.trackedEntities.length = global.trackedEntities.length + 1
	end
end

--Removes an entity from the list that's tracked internally.
--@param  regNumber		The registration number of any LuaEntity that was destroyed (for any reason).
--					If this doesn't correspond with an entry in our table, we ignore that.
--@return				nil
function stop_tracking( regNumber )
	if global.trackedEntities[ regNumber ] ~= nil then
		global.trackedEntities[ regNumber ] = nil
		global.trackedEntities.length = global.trackedEntities.length - 1
	end
end

--Creates a table to track all types of entities we care about.
--Exists mainly for backwards compatibility, but also serves to initialize the tracking table at the beginning of the game.
--If the tracking table already exists when this function is called, the entire table is discarded & remade from scratch.
function create_tracking_table()
	global.trackedEntities = { length = 0 }

	--Now, search the ENTIRE game for all entities that *could* have an Inserter Module illegally inserted into them:
	for _, surface in pairs( game.surfaces ) do
		for _, entity in pairs( surface.find_entities_filtered( SEARCH_PARAMETERS )) do
			begin_tracking( entity )
		end
	end
end