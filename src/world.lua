local Tile = require("src/systems/tile")

local World = {}
local entityList = {}


function World.new()
    Tile.initTile(11)
end

-- Add new entity to entity list
function World.addEntity(entity)
    assert(entity, "World::addEntity : No entity passed in.")
    
    -- I really hate that I have to do this, if I planned the tile system better I wouldn't have to do this
    if (entity.id == "Tank") then
        entity:setTile(Tile) -- use tank's method for setting random tile
    end

    table.insert(entityList, entity)
end


-- Updates each entity based on their update function
function World.update(dt)
    
    for i, entity in ipairs(entityList) do 

        -- Check if the entity is active, o.w. remove from table
        if (entity:isAlive()) then
            entity:update(dt, Tile)
        else 
            table.remove(entityList, i)
        end
    end
end


-- Draw function for the entities, to be used in renderer module
function World.draw()
    for i, entity in pairs(entityList) do
        entity:draw()
    end

end


return World