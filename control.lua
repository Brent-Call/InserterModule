require "util"

--This constant determines the search area radius for illegally placed Inserter Modules:
local SEARCH_AREA = 24

local limitationErrorMessage = { "item-limitation.inserter-module-limitation" }

local searchBox =
{
	left_top = { nil, nil },
	right_bottom = { nil, nil }
}
--Changing searchBox should automatically change the area:
local searchFilters = { type = nil, area = searchBox }

--This function returns true if the entity has an Inserter Module in it:
local function has_ins_module( ent )
	local inventory = ent.get_module_inventory()
	
	--Return false if there is no inventory
	if not inventory then
		return fase
	end
	--Else, there is a module inventory, so test its size:
	--If its size is 0, then obviously an Inserter Module cannot fit in it!
	--Return false if that inventory has size 0:
	if #inventory == 0 then
		return false
	end
	
	local getCount = inventory.get_item_count
	--Else, the module inventory supports modules.
	--Now check if the inventory contains an Inserter Module (of any tier):
	if getCount( "inserter-module"   ) +
	   getCount( "inserter-module-2" ) +
	   getCount( "inserter-module-3" ) > 0 then
		return true
	end
	
	--Else, the module inventory supports modules but has no inserter modules:
	return false
end

local removeTable1 = { name = "inserter-module", count = nil }
local removeTable2 = { name = "inserter-module-2", count = nil }
local removeTable3 = { name = "inserter-module-3", count = nil }

--This function removes all Inserter Modules and puts it into the player's inventory:
local function remove_ins_module( moduleInventory, player )
	--Hopefully this makes things run faster
	local insert = player.insert
	local getCount = moduleInventory.get_item_count
	local remove = moduleInventory.remove
	
	if getCount( "inserter-module" ) > 0 then
		removeTable1.count = remove( "inserter-module" )
		insert( removeTable1 )
	end
	if getCount( "inserter-module-2" ) > 0 then
		removeTable2.count = remove( "inserter-module-2" )
		insert( removeTable2 )
	end
	if getCount( "inserter-module-3" ) > 0 then
		removeTable3.count = remove( "inserter-module-3" )
		insert( removeTable3 )
	end
end

--This function removes all Inserter Modules from entities close to the requested player:
local function search_and_remove_illegals( targetType, player )
	local entitiesWithInserterModule = 0
	
	--This function returns an array of LuaEntity close to the player:
	--Pass it the type of entity to search for.
	local function nearby_entities( t )
		local pos = player.position
		searchBox.left_top[ 1 ] = pos.x - SEARCH_AREA
		searchBox.left_top[ 2 ] = pos.y - SEARCH_AREA
		searchBox.right_bottom[ 1 ] = pos.x + SEARCH_AREA
		searchBox.right_bottom[ 2 ] = pos.y + SEARCH_AREA
		
		searchFilters.type = t
		
		return player.surface.find_entities_filtered( searchFilters )
	end

	--Remove Inserter Modules from the target type of entity:
	for _, ent in pairs( nearby_entities( targetType )) do
		if ent ~= nil then
			if has_ins_module( ent ) then
				entitiesWithInserterModule = entitiesWithInserterModule + 1
				remove_ins_module( ent.get_module_inventory(), player )
			end
		end
	end
	
	--If the player tried to place an Inserter Module in a place where it doesn't belong, generate an error!
	if entitiesWithInserterModule > 0 then
		player.print( limitationErrorMessage )
	end
end

--We've deined all these functions; now we simply need to call them:
script.on_event( defines.events.on_tick, function( event )
	--Every tick we check to see if an Inserter Module is placed illegally:
	--If it is, remove it & generate an error:
	--Use this to stagger the checking:
	local toCheck = event.tick % 4
	local player = game.players[ 1 ]
	
	if toCheck == 0 then
		search_and_remove_illegals( "mining-drill", player )
	elseif toCheck == 1 then
		search_and_remove_illegals( "beacon", player )
	elseif toCheck == 2 then
		search_and_remove_illegals( "lab", player )
	elseif toCheck == 3 then
		search_and_remove_illegals( "furnace", player )
	end
end )