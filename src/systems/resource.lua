local Environment = require("environment")

local Resource = {}

local rTable = {}

function Resource.init()
    rTable["Antimatter"] = 0
    rTable["AC"] = 0
    rTable["SlimeFeed"] = 0
    rTable["Credits"] = 100
end

function Resource.addResource(resource, x) 
    assert(type(resource) == "string", "Resource: key given isn't a string") --resource needs to be a string key
    rTable[resource] = rTable[resource] + x
end

function Resource.removeResource(resource, x)
    assert(type(resource) == "string", "Resource: key given isn't a string") --resource needs to be a string key
    rTable[resource] = rTable[resource] - x
end


return Resource