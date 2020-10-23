-- Modules
local Slime = require("src/entities/slime")
local Assets = require("src/assets")
local Resource = require("src/systems/resource")
local Environment = require("src/systems/environment")

-- Library
local suit = require("lib/suit")
local Timer = require("lib/timer")

local activeScreen

-- used for coloring the text for the toast message method
local colorToast = {normal = { fg = {0, 0, 0}}}

local Pet = {}

local slime = Slime(300, 425, "Fire")

function Pet.new()
    
    -- randomly slide the slime around

    local move = math.random(-30, 30) + slime.x
    Timer.every(1.5, 
    function() 
        -- if going out of bounds to the right
        if (move > 609) then
            move = -100
        elseif (move < 97) then
            move = 100
        end
        Timer.tween(1, slime, {x = move}, 'in-out-quad')
    end)
    -- end of slime slide logic

end

function Pet.draw()
    love.graphics.draw(Assets.getAsset("bg"), 0, 0, 0)
    
    --Draw the slime
    slime:draw()

    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle("fill", 0, love.graphics.getHeight()-50, love.graphics.getWidth(), 50)
    love.graphics.setColor(1, 1, 1)
    

    local happy, hungry, growth = slime:returnStats()
    local heat, humidity, gravity = Environment.returnEnvStats()

    local statString = string.format("Happiness: %2.2f,   Hunger: %2.2f,    Growth: %2.2f", happy, hungry, growth)
    local rescString = string.format( "Credits: %d     Antimatter: %d     AC Units: %d    Slime Feed: %d ",  Resource.returnResource())    
    local envString  = string.format( "%2.2f°C     %2.2f%% Humidity      %2.2f N", heat*2.6, humidity/10, gravity/10)

    love.graphics.print(statString, 300, love.graphics.getHeight()-45)
    love.graphics.print(envString, 300, love.graphics.getHeight()-30)
    love.graphics.print(rescString, 300, love.graphics.getHeight()-18)
    
    -- draws the gui
    suit.draw()
end

function GUI()
    local credits, am, ac, food = Resource.returnResource()
    
    if suit.Button("Gain Resources", 0, love.graphics.getHeight()-100, 100, 50).hit then
        gameState = PlayGame
    end

    if suit.Button("Feed", 0, love.graphics.getHeight()-50, 50, 50).hit then
        if (food > 0) then
            toastMessage("-1 Slime Food", 0, love.graphics.getHeight()-75, 300, 30)
            slime:feed()
            Resource.removeResource("Food", 1)
            playGoodSound()
        else
            toastMessage("No food D:", 0, love.graphics.getHeight()-75, 300, 30)
            playBadSound()
        end
    end

    
    -- Heat Buttons
    if suit.Button("Heat +", 50, love.graphics.getHeight()-50, 50, 25).hit then
        if (ac > 0) then
            Environment.modifyHeat(10)
            Resource.removeResource("AC", 1)
            playGoodSound()
        else
            toastMessage("No AC D:", 50, love.graphics.getHeight()-75, 300, 30)
            playBadSound()
        end
    end

    if suit.Button("Heat -", 50, love.graphics.getHeight()-25, 50, 25).hit then
        if (ac > 0) then
            Environment.modifyHeat(-10)
            Resource.removeResource("AC", 1)
            playGoodSound()
        else
            toastMessage("No AC D:", 50, love.graphics.getHeight()-75, 300, 30)
            playBadSound()
        end
    end
    
    
    -- Humidity Buttons
    if suit.Button("Humidty +", 100, love.graphics.getHeight()-50, 75, 25).hit then
        if (ac > 0) then
            Environment.modifyHumidity(10)
            Resource.removeResource("AC", 1)
            playGoodSound()
        else
            toastMessage("No AC D:", 100, love.graphics.getHeight()-75, 300, 30)
            playBadSound()

        end
    end

    if suit.Button("Humidity -", 100, love.graphics.getHeight()-25, 75, 25).hit then
        if (ac > 0) then
            Environment.modifyHumidity(-10)
            Resource.removeResource("AC", 1)
            playGoodSound()
        else
            toastMessage("No AC D:", 100, love.graphics.getHeight()-75, 300, 30)
            playBadSound()

        end
    end

    

    
    -- Gravity Buttons
    if suit.Button("Gravity +", 175, love.graphics.getHeight()-50, 75, 25).hit then
        if (am > 0) then
            Environment.modifyGravity(10)
            Resource.removeResource("Antimatter", 1)
            playGoodSound()
        else
            toastMessage("No Antimatter D:", 175, love.graphics.getHeight()-75, 300, 30)
            playBadSound()

        end
    end

    if suit.Button("Gravity -", 175, love.graphics.getHeight()-25, 75, 25).hit then
        if (am > 0) then
            Environment.modifyGravity(-10)
            Resource.removeResource("Antimatter", 1)
            playGoodSound()
        else
            toastMessage("No Antimatter D:", 175, love.graphics.getHeight()-75, 300, 30)
            playBadSound()

        end
    end

end

-- Poops up a message for a second
function toastMessage(msg, x, y, w, h)
    assert(type(msg) == "string", "Toast message recieved not a string")
    Timer.during(0.5, function() suit.Label(msg, {color = colorToast}, x, y) end)
end

function Pet.update(dt)
    GUI()
    
    
    slime:update(dt) 
end

function playGoodSound()
    Assets.getAsset("goodSound"):play()
end

function playBadSound()
    Assets.getAsset("badSound"):play()
end
return Pet