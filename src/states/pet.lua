-- Modules
local Slime = require("src/entities/slime")
local Assets = require("src/assets")
local Resource = require("src/systems/resource")
local Environment = require("src/systems/environment")

-- Library
local suit = require("lib/suit")
local Timer = require("lib/timer")

local colorToast = {normal = { fg = {0, 0, 0}}}


local Pet = {}

local slime = Slime(300, 550, "Water")

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
    
    --Draw the slime
    slime:draw()
    
    -- draws the gui
    suit.draw()
end

function GUI()
    local am, ac, food = Resource.returnResource()
    
    if suit.Button("Feed", 100, love.graphics.getHeight()-50, 50, 50).hit then
        if (food > 0) then
            toastMessage("-1 Slime Food", 100, love.graphics.getHeight()-75, 300, 30)
            slime.feed()
        else
            toastMessage("No food D:", 100, love.graphics.getHeight()-75, 300, 30)
        end
    end

    
    -- Heat Buttons
    if suit.Button("Heat +", 150, love.graphics.getHeight()-50, 50, 25).hit then
        if (ac > 0) then
            Environment.modifyHeat(10)
        else
            toastMessage("No AC D:", 150, love.graphics.getHeight()-75, 300, 30)
        end
    end

    if suit.Button("Heat -", 150, love.graphics.getHeight()-25, 50, 25).hit then
        if (ac > 0) then
            Environment.modifyHeat(-10)
        else
            toastMessage("No AC D:", 150, love.graphics.getHeight()-75, 300, 30)
        end
    end
    
    
    -- Humidity Buttons
    if suit.Button("Humidty +", 200, love.graphics.getHeight()-50, 75, 25).hit then
        if (ac > 0) then
            Environment.modifyHumidity(10)
        else
            toastMessage("No AC D:", 200, love.graphics.getHeight()-75, 300, 30)
        end
    end

    if suit.Button("Humidity -", 200, love.graphics.getHeight()-25, 75, 25).hit then
        if (ac > 0) then
            Environment.modifyHumidity(-10)
        else
            toastMessage("No AC D:", 200, love.graphics.getHeight()-75, 300, 30)
        end
    end

    
    -- Gravity Buttons
    if suit.Button("Gravity +", 275, love.graphics.getHeight()-50, 75, 25).hit then
        if (ac > 0) then
            Environment.modifyGravity(10)
        else
            toastMessage("No Antimatter D:", 275, love.graphics.getHeight()-75, 300, 30)
        end
    end

    if suit.Button("Gravity -", 275, love.graphics.getHeight()-25, 75, 25).hit then
        if (ac > 0) then
            Environment.modifyGravity(-10)
        else
            toastMessage("No Antimatter D:", 275, love.graphics.getHeight()-75, 300, 30)
        end
    end


end

function toastMessage(msg, x, y, w, h)
    assert(type(msg) == "string", "Toast message recieved not a string")
    Timer.during(2, function() suit.Label(msg, {color = colorToast}, x, y) end)
end

function Pet.update(dt)
    GUI()
    
    
    slime:update(dt) 
end

return Pet