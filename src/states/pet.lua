-- Modules
local Slime = require("src/entities/slime")
local Assets = require("src/assets")
local Resource = require("src/systems/resource")
local Environment = require("src/systems/environment")

-- Library
local suit = require("lib/suit")
local Timer = require("lib/timer")



local Pet = {}

local slime = Slime(300, 500, "Water")

function Pet.new()

end

function Pet.draw()
    love.graphics.draw(Assets.getAsset("ocean"), 20, -50, 0)

    love.graphics.rectangle("fill", 0, love.graphics.getHeight()-50, love.graphics.getWidth(), 50)

    local happy, hungry, growth = slime:returnStats()
    local heat, humidity, gravity = Environment.returnEnvStats()

    love.graphics.print( "Happiness: " ..  happy .. 
                         "\nHunger: " .. hungry ..
                        '\nGrowth: ' .. growth)

    local rescString = string.format( "Credits: %d Antimatter: %d AC Units: %d Slime Feed: %d ",  Resource.returnResource())    
    local envString  = string.format( "%2.2f C, %2.2f Absolute Humidity, %2.2f N", heat*2.6, humidity/10, gravity/10)
    love.graphics.print(rescString, 300)
    love.graphics.print(envString, 300, 20)
    
    slime:draw()

    suit.draw()
end

function GUI()
    if suit.Button("Feed", 100,100, 50, 50).hit then
        toastMessage("Butts", 100, 150, 300, 30)
    end
end

function toastMessage(msg, x, y, w, h)
    assert(type(msg) == "string", "Toast message recieved not a string")
    Timer.during(2, function() suit.Label(msg, {color = {1, 1, 1}}, x, y) end)
    
end

function Pet.update(dt)
    GUI()
    
    
    slime:update(dt) 
end

return Pet