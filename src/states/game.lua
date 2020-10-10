-- Libraries
local Timer = require("lib/timer")
local GameBoard = require("src/gameboard")


-- Modules

local Game = {}

function Game.new()
    GameBoard.new()
end 

function Game.draw()
    GameBoard.draw()
end

function Game.update(dt)
    GameBoard.update(dt)
end


return Game