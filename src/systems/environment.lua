local Environment = {}

local maxValue = 100

local heat = 50
local humidity = 50
local gravity = 50


-- x is a positive or negative value
local Environment.modifyHeat(x)
    heat = heat + x
end

local Environment.modifyHumidity(x)
    heat = heat + x
end

-- pass in the slime and modify it's behavior based on the environment
local Environment.environmentToSlime(slime)

end

local Environment.returnEnvStats()
    return heat, humidity, gravity
end

return Environment