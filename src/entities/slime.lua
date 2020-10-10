-- Libraries
local Object = require("lib/classic")
local Timer = require("lib/timer")

-- Modules
local Assets = require("src/assets")

local Slime = Object:extend()

local time = 0

function Slime:new()
    self.id = "Slime"
    self.x = x or 300
    self.y = y or 300
    
    self.xScale = 1
    self.yScale = 1

    self.img = Assets.getAsset("slime0")
end

function Slime:update(dt)

end

function Slime:draw()
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(self.img, self.x, self.y, 0, self.xScale, self.yScale, self.img:getWidth()/2, self.img:getHeight()/2)
end

return Slime