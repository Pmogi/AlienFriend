local Object = require("lib/classic")
local World = require("src/world")

local Ball = require("src/entities/ball")

local GameBoard = {}

local objects = {} -- physics to hold all our physical objects

local _meter                = 32
local _gravity_constant     = 9.81
local _gravity_factor_x     = 0
local _gravity_factor_y     = 1

local physics = love.physics.newWorld(  _meter * _gravity_constant * _gravity_factor_x
                , _meter * _gravity_constant * _gravity_factor_y
                , true)

-- test creating a ball with ball module
 

function GameBoard.new()
    love.physics.setMeter(_meter)

    objects.ballTest =  Ball(100, 400, 10, 0.5, physics)
    objects.ballTest2 = Ball(300, 400, 10, 0.5, physics)

    print(objects.ballTest)
    print(objects.ballTest2)
    
    -- let's create the ground
    objects.ground = {}
    objects.ground.body = love.physics.newBody(physics, 650/2, 650-50/2)
    
    objects.ground.shape = love.physics.newRectangleShape(650, 50)
   
    objects.ground.fixture = love.physics.newFixture(objects.ground.body,
                                                     objects.ground.shape)

    -- initial graphics setup
    -- set the background color to a nice blue
    love.graphics.setBackgroundColor(0.41, 0.53, 0.97)
    love.window.setMode(650, 650) -- set the window dimensions to 650 by 650


    
end

function GameBoard.draw()
      -- set the drawing color to green for the ground
  love.graphics.setColor(0.28, 0.63, 0.05)
  -- draw a "filled in" polygon using the ground's coordinates
  love.graphics.polygon("fill", objects.ground.body:getWorldPoints(
                           objects.ground.shape:getPoints()))

  objects.ballTest:draw()
  objects.ballTest2:draw()


end


function GameBoard.update(dt)
    physics:update(dt)
end

return GameBoard