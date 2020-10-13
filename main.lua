-- Lib
local Timer = require("lib/timer")

-- Modules, game states
local Menu = require("src/states/menu")
local Game = require("src/states/game")
local Pet  = require("src/states/pet")

-- local Board = require("src/gameboard")


local gameState
local PlayGame = 0
local PlayMenu = 1
local SlimeScreen = 2
local canSwitch

local gravityFactor = 1 -- increase or decrease gravity with this variable

local world
local objects = {}


function love.load()
    Game.new()
    Pet.new()
    gameState = SlimeScreen
    canSwitch = true

end

function love.draw()
    
    if (gameState == PlayGame) then
    
        Game.draw()
    
    elseif (gameState == SlimeScreen) then

        Pet.draw()

    end
end

function love.update(dt)
    Timer.update(dt)

    -- Switch states
    if (love.keyboard.isDown("space") and canSwitch) then
        switchState()
    end

    if (gameState == PlayGame) then
        Game.update(dt)
    
    elseif (gameState == SlimeScreen) then
        Pet.update(dt)
    end
end

function switchState() 
    canSwitch = false
    Timer.after(1, function() canSwitch = true end)
    
    if (gameState == PlayGame) then
        gameState = SlimeScreen
    
    elseif (gameState == SlimeScreen) then
        gameState = PlayGame
    end
end

