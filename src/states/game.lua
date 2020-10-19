-- Libraries
local Timer = require("lib/timer")

local GameBoard = require("src/gameboard")
local Boardmaker = require("src/boardmaker")
local Resource = require("src/systems/resource")


local Game = {}
-- Modules
local gameBoard

function Game.new()
    Resource.init()
    gameBoard = GameBoard()
    -- boardMaker = Boardmaker(720,720,gameBoard)
end

function Game.draw()
    gameBoard.draw()
end

function Game.update(dt)
    gameBoard.update(dt)
end


return Game