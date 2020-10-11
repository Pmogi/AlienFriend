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

local gravityFactor = 1 -- increase or decrease gravity with this variable

local world
local objects = {}


function love.load()
    Game.new()
    Pet.new()
    gameState = PlayGame

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
    Game.update(dt)
    Pet.update(dt)

end

