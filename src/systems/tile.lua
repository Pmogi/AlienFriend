local Tile = {}

-- A table
local tileTable = {}
local size

-- Initilize a table representing an NxN tiled system
function Tile.initTile(n)
    size = n
    for i=1, (size*size) do 
        table.insert(tileTable, {["occupied"] = false})
    end
end

-- return the table corrisponding to the coordiantes
function Tile.rowMajor(i, j) 
    return ((i * size) + j) + 1
end

    -- return the status of a tile
function Tile.getTile(i, j)
    return tileTable[Tile.rowMajor(i, j)]
end

-- Set the status of a tile
function Tile.setTile(i, j, id)
    
    -- if id is given, then set occupied
    if (id) then
        local tile = Tile.getTile(i, j)
        tile["id"] = id
        tile["occupied"] = true
    
    -- if not given, clear tile
    else
        tileTable[Tile.rowMajor(i, j)]["occupied"] = false
        tileTable[Tile.rowMajor(i, j)]["id"] = nil
        
    end
end

function Tile.getRandomFreeTile()
    local i = math.random( 1, 9 )
    local j = math.random( 1, 9 )
    while Tile.getTile(i, j)["occupied"] == true do

        i = math.random( 1, 9 )
        j = math.random( 1, 9 )
    end
        return i, j
end

-- clear all all tiles with given id
function Tile.clearID(id)
    for i, tile in ipairs(tileTable) do

        if (tile["occupied"] == true) then
            if (tile["id"] == id) then
                tile["occupied"] = false
                tile["id"] = nil
            end
        end
    end
end


return Tile