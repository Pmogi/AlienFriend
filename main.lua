-- Lib
local Timer = require("lib/timer")

-- Modules, game states
local Game = require("src/states/game")
local Menu = require("src/states/menu")
local Board = require("src/gameboard")


local gameState
local PlayGame = 1
local PlayMenu = 0
local gravityFactor = 1 -- increase or decrease gravity with this variable

local world
local objects = {}



function love.load()
    startGame()
end

function love.draw()
    Game.draw()
end

function love.update(dt)
    Timer.update(dt)
    Game.update(dt)

end

function startGame()
    Game.new()
end