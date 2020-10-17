local Resource = require("src/systems/resource")

local Environment = {}

local maxValue = 100

local heat = 10
local humidity = 10
local gravity = 10

-- x is a positive or negative value
function Environment.modifyHeat(x)
    heat = heat + x
end

function Environment.modifyHumidity(x)
    humidity = humidity + x
end

function Environment.modifyGravity(x)
    gravity = gravity + x
end

function Environment.returnEnvStats()
    return heat, humidity, gravity
end

return Environment