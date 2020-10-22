-- Libraries
local Timer = require("lib/timer")

--local GameBoard = require("src/gameboard")
--local Boardmaker = require("src/boardmaker")
local Resource = require("src/systems/resource")
local TokenMaker = require("src/entities/tokenmaker")

local Game = {}
-- Modules
local gameBoard
local tokenMaker

function Game.new()
    Resource.init()
    tokenMaker = TokenMaker()
    --gameBoard = GameBoard()
    -- boardMaker = Boardmaker(720,720,gameBoard)
end

function Game.draw()
    tokenMaker:draw()
    --gameBoard.draw()
end

function Game.update(dt)
    tokenMaker:update(dt)
    --gameBoard.update(dt)
    --boardMaker.update(dt)
end


return Game