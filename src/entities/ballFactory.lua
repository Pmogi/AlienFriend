-- Libraries
local Object = require("lib/classic")
local Timer = require("lib/timer")


-- Modules
local Ball = require("src/entities/ball")

local BallFactory = Object:extend()

function BallFactory:new(x, y, objectsList, world)
    self.x = x 
    self.y = y
    self.w = 50
    self.h = 50
    
    self.canEmitBall = true
    self.world = world
    self.objectsList = objectsList

    print(self.world)

    self.depth = 100 -- low priority
end

function BallFactory:update(dt)
    -- check for click in area
    local xPos =  love.mouse.getX()
    local yPos =  love.mouse.getY()

    if (xPos > self.x and xPos < self.x+self.w and
            yPos > self.y and yPos < self.y + self.h) then
        
        if (self.canEmitBall and love.mouse.isDown(1)) then
            self.canEmitBall = false
            Timer.after(2, function() self.canEmitBall = true end)
            self:spawnBall()
        end
    end
end

function BallFactory:draw()
    love.graphics.setColor(0.5, 0.5, 0.5)
    love.graphics.rectangle("fill", self.x, self.y, self.w, self.h )
    love.graphics.setColor(1, 1, 1)


end

function BallFactory:spawnBall()
    table.insert(self.objectsList, Ball(self.x, self.y, 10, 0.50, 1,  self.world) )
end

return BallFactory