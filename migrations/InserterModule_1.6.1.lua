--If the player was using Industrial Revolution 2 & had modules researched but not Inserter Modules, do this:
for _, force in pairs( game.forces ) do
	force.reset_technology_effects()
end