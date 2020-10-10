-- Libraries
local Timer = require("lib/timer")
local Gameboard = require("src/gameboard")


-- Modules

local Game = {}

local Gameboard = Gameboard()

function Game.new()
    World.new()
    World.addEntity(gameboard)
end 

function Game.draw()

end

function Game.update(dt)

end


return Game