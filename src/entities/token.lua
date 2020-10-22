-- Libraries
local Object = require("lib/classic")

-- Modules
local Assets = require("src/assets")


local token = Object:extend()



function token:new(creator, index, x, y, type)
    self.creator = creator
    self.index = index
    self.x = x 
    self.y = y
    self.w = 50
    self.h = 50
    self.speed = 0
    self.gravity = 0.01
    self.gravity_max = 0

    if type == "AC" then
        self.gravity_max = 0.1
        self.img = Assets.getAsset("token1") end
    if type == "Antimatter" then
        self.gravity_max = 0.1
        self.img = Assets.getAsset("token2") end
    if type == "Food" then
        self.gravity_max = 0.1
        self.img = Assets.getAsset("token3") end
    return self
end

function token:draw()
    --print(self.x .. " | " .. self.y)
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(self.img, self.x, self.y)
    
end

function token:update(dt)
    --print(self.y .. "  |  " .. self.creator:getDestructionPoint())
    if self.y > self.creator:getDestructionPoint() then
        --print("boundary destruction")
        self.creator:destroy(self.index)
        return
    end

    local xPos =  love.mouse.getX()
    local yPos =  love.mouse.getY()
    if ( xPos > self.x and xPos < self.x+self.w and
            yPos > self.y and yPos < self.y + self.h ) then
        if love.mouse.isDown(1) then
            --print("mouse destruction")
            self.creator:destroy(self.index)
            return
        end
    end

    self.speed = math.min(self.speed + self.gravity, self.gravity_max)
    self.y = self.y + self.speed
    
end

return token