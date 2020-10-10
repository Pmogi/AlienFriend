-- Libraries
local Object = require("lib/classic")
local Timer = require("lib/timer")

-- Modules
local Assets = require("src/assets")

local Player = Object:extend()

local time = 0

function Player:new()
    self.id = "Player"

end

function Player:__toString()
    return self.x .. ", " .. self.y .. ', ' .. self.angle
end

function Player:update(dt)
    
end

-- Used in World module to determine if this entity should be removed from the list of entities
function Player:isAlive()
    return self.alive
end


return Player