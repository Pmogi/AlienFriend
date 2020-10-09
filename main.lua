-- Lib
local Timer = require("lib/timer")

-- Modules, game states
local Game = require("src/states/game")
local Menu = require("src/states/menu")

local gameState
local PlayGame = 1
local PlayMenu = 0

function love.load()
end

function love.draw( )
end

function love.update( dt )
    Timer.update(dt)
end

function startGame()
    Game.new()
end