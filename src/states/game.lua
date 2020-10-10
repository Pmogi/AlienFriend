-- Libraries
local Timer = require("lib/timer")
local GameBoard = require("src/gameboard")

local Game = {}
-- Modules
local gameBoard

function Game.new()
    gameBoard = GameBoard()
end 

function Game.draw()
    gameBoard.draw()
end

function Game.update(dt)
    gameBoard.update(dt)
end


return Game