--Purely utility function to concatenate 2 arrays but keep the VALUES unique:
--Returns a new table.
function concatenate_arrays_with_no_duplicates( arr1, arr2 )
	local retVal = table.deepcopy( arr1 )
	for _, v in pairs( arr2 ) do
		--Insert v into retVal unless v is already in retVal somewhere:
		local isDuplicate = false
		for _, w in pairs( retVal ) do
			if v == w then
				isDuplicate = true
			end
		end
		if not isDuplicate then
			table.insert( retVal, v )
		end
	end
	return retVal
end

--This function takes in a recipe data table & extracts its results.
function extract_products_from_recipe_data( recipeData )
	local retVal = {}
	if type( recipeData ) == "table" then
		if type( recipeData.result ) == "string" then
			table.insert( retVal, recipeData.result )
		end
		if type( recipeData.results ) == "table" then
			for _, v in pairs( recipeData.results ) do
				if type( v[ 1 ]) == "string" then
					table.insert( retVal, v[ 1 ])
				end
				if type( v.name ) == "string" then
					table.insert( retVal, v.name )
				end
			end
		end
	--Else, recipeData might be nil.  That's okay.
	end
	return retVal
end

--This function takes in a recipePrototype & returns all products of that recipe.
--If the recipe has no difficulty settings, returns all products.
--If the recipe has difficulty settings, returns the set union of all products across all difficulty settings.
--Returns a table formatted as an array; may return an empty table.
function extract_products_from_recipe_prototype( recipePrototype )
	--This is a 3-way concatenation.
	return concatenate_arrays_with_no_duplicates( extract_products_from_recipe_data( recipePrototype ),
			concatenate_arrays_with_no_duplicates( extract_products_from_recipe_data( recipePrototype.normal ),
				extract_products_from_recipe_data( recipePrototype.expensive )))
end

if settings.startup[ "Q-InserterModule:dynamic-recipe-whitelist" ].value == true then
	--We must dynamically generate a table that lists all recipes that make inserter items.
	--First, we list all inserter items:
	local allInserterItems = {}

	for itemName, itemPrototype in pairs( data.raw.item ) do
		--An item is considered to be an inserter item if its place_result is the name of an existing inserter prototype.
		if type( itemPrototype.place_result ) == "string" then
			if type( data.raw.inserter[ itemPrototype.place_result ]) == "table" then
				--The entries in allInserterItems are indexed by name because that will be convenient later:
				allInserterItems[ itemName ] = itemName
			end
		end
	end

	--Then, we list all inserter recipes:
	local allInserterRecipes = {}

	for recipeName, recipePrototype in pairs( data.raw.recipe ) do
		--Assume this is an inserter recipe for now:
		local isInserterRecipe = true
		local recipeProducts = extract_products_from_recipe_prototype( recipePrototype )

		if #recipeProducts < 1 then
			--Recipe must have at least 1 product to be eligible!
			isInserterRecipe = false
		else
			--Iterate through all products of this recipe:
			for _, itemName in pairs( recipeProducts ) do
				--A recipe is considered to be an inserter recipe if it has at least 1 product & its products are all inserter items.
				if allInserterItems[ itemName ] == nil then
					--This is an item that is NOT an inserter item, so this is NOT an inserter recipe!
					isInserterRecipe = false
					break
				end
			end
		end

		--By now we have determined for sure if this is an inserter recipe or not.
		if isInserterRecipe then
			table.insert( allInserterRecipes, recipeName )
		end
	end
	
	--Then we set all inserter modules' limitations to be that:
	data.raw.module[ "Q-InserterModule:inserter-module" ].limitation = allInserterRecipes
	data.raw.module[ "Q-InserterModule:inserter-module-2" ].limitation = allInserterRecipes
	data.raw.module[ "Q-InserterModule:inserter-module-3" ].limitation = allInserterRecipes
end


--16 February 2023--I can confirm this works with the Industrial Revolution 2 mod.