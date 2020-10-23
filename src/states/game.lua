-- Libraries
local Timer = require("lib/timer")

local Slime = require("src/entities/slime")
local Assets = require("src/assets")
local Resource = require("src/systems/resource")
local Environment = require("src/systems/environment")
local TokenMaker = require("src/entities/tokenmaker")


local Game = {}
-- Modules
local gameBoard
local tokenMaker

function Game.new()
    Resource.init()
    tokenMaker = TokenMaker()
end

function Game.draw()
    love.graphics.draw(Assets.getAsset("gridBG"), 0,0,0,720/800,720/600)
    tokenMaker:draw()

    --local happy, hungry, growth = Slime:returnStats()
    local heat, humidity, gravity = Environment.returnEnvStats()

    -- local statString = string.format("Happiness: %2.2f,   Hunger: %2.2f,    Growth: %2.2f", happy, hungry, growth)
    local rescString = string.format( "Credits: %d     Antimatter: %d     AC Units: %d    Slime Feed: %d ",  Resource.returnResource())    
    local envString  = string.format( "%2.2f°C     %2.2f%% Humidity      %2.2f N", heat*2.6, humidity/10, gravity/10)

    -- love.graphics.print(statString, 300, love.graphics.getHeight()-45)
    love.graphics.print(envString, 300, love.graphics.getHeight()-30)
    love.graphics.print(rescString, 300, love.graphics.getHeight()-18)
end

function Game.update(dt)
    tokenMaker:update(dt)

end


return Game