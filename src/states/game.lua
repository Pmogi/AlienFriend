-- Libraries
local Timer = require("lib/timer")
local GameBoard = require("src/gameboard")
local Boardmaker = require("src/boardmaker")

local Game = {}
-- Modules
local gameBoard

function Game.new()
    gameBoard = GameBoard()
    --boardMaker = Boardmaker(720,720,gameBoard)
end

function Game.draw()
    gameBoard.draw()
end

function Game.update(dt)
    gameBoard.update(dt)
    --boardMaker.update(dt)
end


return Game