-- Libraries
local Object = require("lib/classic")

-- Modules
local Assets = require("src/assets")


local Token = Object:extend()

local ResourceTypes = {
    "Antimatter",
    "Air Conditioning Unit",
    "Slime Feed"
}

function Token:new(x, y, world)
    self.x = x 
    self.y = y
    self.img = Assets.getAsset("token")

    -- physics, body, shape, fixture
    self.body = love.physics.newBody(world, self.x, self.y, "static")
    self.shape = love.physics.newCircleShape(10) -- radius of 10 pixels
    self.fixture = love.physics.newFixture(self.body, self.shape, self.density) -- 
    
    self.depth = -1
    self.colors = {1, 1, 1}

    self.resource
    
    self.id = "Token"

    self.fixture:setUserData({id = self.id, alive = true})
end

function Token:draw()
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(self.img, self.body:getX(), self.body:getY())
end

function Token:update(dt)

end

function Token:assignResource()


end

return Token