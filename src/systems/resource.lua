-- local Environment = require("src/environment")

local Resource = {}

local rTable = {}
local credits



function Resource.init()
    rTable[1] = 0 -- Antimatter
    rTable[2] = 0 -- AC Unit
    rTable[3] = 0 -- Slime Feed
    credits = 100 -- Credits for pachinko
end

function Resource.addResource(x) 
    local randomResource = math.random(1, 3)
    print(randomResource)
    rTable[randomResource] = rTable[randomResource] + x
end

function Resource.addCredits(x)
    credits = credits + x 
end

function Resource.removeResource(resource, x)
    assert(type(resource) == "string", "Resource: key given isn't a string") --resource needs to be a string key
    rTable[resource] = rTable[resource] - x
end

-- for printing resource
function Resource.returnResource()
    return credits, rTable[1], rTable[2], rTable[3]
end

return Resource