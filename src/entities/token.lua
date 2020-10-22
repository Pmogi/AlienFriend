-- Libraries
local Object = require("lib/classic")

-- Modules
local Assets = require("src/assets")
local Resource = require("src/systems/resource")

local token = Object:extend()



function token:new(creator, index, x, y, type)
    self.creator = creator
    self.index = index
    self.type = type
    self.x = x 
    self.y = y
    self.w = 80
    self.h = 80
    self.speed = math.random(5, 10 )
    self.gravity = 0.18
    self.gravity_max = 0
    self.status = true


    if type == "AC" then
        self.gravity_max = 8
        self.img = Assets.getAsset("token1") end
    if type == "Antimatter" then
        self.gravity_max = 8
        self.img = Assets.getAsset("token2") end
    if type == "Food" then
        self.gravity_max = 8
        self.img = Assets.getAsset("token3") end
    return self
end

function token:draw()
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(self.img, self.x, self.y)
    
end

function token:update(dt)

    if self.y > self.creator:getDestructionPoint() then
        self.creator:destroy(self.index)
        return 0
    end

    local xPos =  love.mouse.getX()
    local yPos =  love.mouse.getY()
    if ( xPos > (self.x-(self.img:getWidth()/2))) and (xPos < (self.x+self.w-(self.img:getWidth()/2))) and
            (yPos > self.y-(self.img:getHeight()/2)) and (yPos < self.y + self.h - (self.img:getHeight()/2)) then
        if love.mouse.isDown(1) then
            Resource.addResourceByType(self.type)
            self.status = false
            return
        end
    end

    if (self.y > 600) then
        self.status = false
        return
    end

    self.speed = math.min(self.speed + self.gravity, self.gravity_max)
    self.y = self.y + self.speed
end

function token:getY()
    return self.y
end

function token:getType()
    return self.type
end

function token:getStatus() 
    return self.status
end

function token:getID()
    return self.index
end

return token