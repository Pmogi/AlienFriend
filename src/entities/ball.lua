-- Modules

-- libraries
local Object = require("lib/classic")

-- Module variables
local _ballCount = 0

-- Ball object returns a rigid body ball to be used in the pachinko game
local Ball = Object:extend()

function Ball:new(x, y, density, restitution, world)
    self.x = x 
    self.y = y
    self.density = density
    self.restitution = restitution

    -- physics, body, shape, fixture
    self.b = love.physics.newBody(world, self.x, self.y, "dynamic")
    self.s = love.physics.newCircleShape(10) -- radius of 10 pixels
    self.f = love.physics.newFixture(self.b, self.s, self.density) -- 
    
    -- The "bounce factor"
     self.f:setRestitution(self.restitution)
    
    local id = "Ball"
    -- self.f:setUserData(id)

    self.alive = true -- used to determine if the ball needs to be removed
end

function Ball:draw()
    love.graphics.setColor(0.68, 0.77, 0.91)
    love.graphics.circle("fill", self.b:getX(), self.b:getY(), self.s:getRadius())
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