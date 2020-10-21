-- Libraries
local Object = require("lib/classic")

-- Modules
local Assets = require("src/assets")


local Token = Object:extend()



function Token:new(x, y, type, world)
    self.x = x 
    self.y = y
    if type == "AC" then self.img = Assets.getAsset("token1") end
    if type == "antimatter" then self.img = Assets.getAsset("token2") end
    if type == "food" then self.img = Assets.getAsset("token3") end

    -- physics, body, shape, fixture
    self.body = love.physics.newBody(world, self.x, self.y, "static")
    self.shape = love.physics.newCircleShape(15) -- radius of 10 pixels
    self.fixture = love.physics.newFixture(self.body, self.shape, self.density) -- 

    self.fixture:setSensor(true)
    
    self.depth = 1
    self.colors = {1, 1, 1}

    -- self.resource = self:assignResource()
    self.resourceAmount = 1
    
    self.id = "Token"

    self.fixture:setUserData({id = self.id, alive = true})
end

function Token:draw()
    love.graphics.draw(self.img, self.body:getX(), self.body:getY())
    love.graphics.setColor(1, 1, 1)
end

function Token:update(dt)
    self.y = self.y + 1
end


return Token