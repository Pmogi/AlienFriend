local Resource = require("src/systems/resource")

local Environment = {}

local maxValue = 100

local heat = 50
local humidity = 50
local gravity = 50


-- x is a positive or negative value
function Environment.modifyHeat(x)
    heat = heat + x
end

function Environment.modifyHumidity(x)
    humidity = humidity + x
end

-- pass in the slime and modify it's behavior based on the environment
function Environment.environmentToSlime(slime)

end

function Environment.returnEnvStats()
    return heat, humidity, gravity
end

return Environment