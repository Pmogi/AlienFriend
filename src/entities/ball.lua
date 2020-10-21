-- Modules

-- libraries
local Object = require("lib/classic")

-- Module variables
local _ballCount = 0

-- Ball object returns a rigid body ball to be used in the pachinko game
local Ball = Object:extend()

function Ball:new(x, y, density, restitution, friction, world)
    self.x = x 
    self.y = y
    self.density = density
    self.restitution = restitution
    self.friction = friction

    -- physics, body, shape, fixture
    self.body = love.physics.newBody(world, self.x, self.y, "dynamic")
    self.shape = love.physics.newCircleShape(10) -- radius of 10 pixels
    self.fixture = love.physics.newFixture(self.body, self.shape, self.density) -- 
    --self.fixture:setGroupIndex(-2)
    
    self.depth = -1
    self.colors = {0.5, 0.5, 0.5}
    
    -- The "bounce factor"
    self.fixture:setRestitution(self.restitution)
    
    self.id = "Ball"

    self.fixture:setUserData({id = self.id, alive = true})
end

function Ball:draw()
    love.graphics.setColor(0.68, 0.77, 0.91)
    love.graphics.circle("fill", self.body:getX(), self.body:getY(), self.shape:getRadius())
end

-- Check the 'alive' state of the ball
function Ball:getAlive()
    return self.alive
end

-- if the ball is to be destroyed, set to false
function Ball:setAlive(status)
    assert(type(status) == "boolean", "Ball:SetAlive expects a boolean value")
    self.alive = status
end

function Ball:destroy()
   self.b:destroy() -- destorys the body and fixture of the ball
end

function incBallCount()
    _ballCount = _ballCount + 1
end

return Ball