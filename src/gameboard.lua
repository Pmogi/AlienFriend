local Object = require("lib/classic")
local World = require("src/world")
local Ball = require("src/entities/ball")

local gameboard = Object:extend()
local physics
local objects = {} -- physics to hold all our physical objects
--local objectLog = {}
local drawOrder = {}

local _meter                = 32
local _gravity_constant     = 9.81
local _gravity_factor_x     = 0
local _gravity_factor_y     = 1

local physics = love.physics.newWorld(  _meter * _gravity_constant * _gravity_factor_x
                , _meter * _gravity_constant * _gravity_factor_y
                , true)
 

function gameboard:new()

    self.id = "gameboard"
    self:setupEnumerations()
    
    love.graphics.setBackgroundColor({0.41, 0.53, 0.97})
    love.window.setMode(650, 650) -- set the window dimensions to 650 by 650
    
    love.physics.setMeter(_meter)

    -- objects["ballTest"] =  Ball(100, 400, 10, 0.5, physics)
    --objects.ballTest2 = Ball(300, 400, 10, 0.5, physics)
    

    self:addShape(  "test", gb_behaviors["behavior_static"], gb_shapes["shape_rectangle"],
                    gb_colors["color_maroon"], 300, 300,
                    500, 100, -1,
                    -1, 1, 0,
                    0.5, true, 1,
                    1 , false, 0,
                    false, 0, 100,
                    physics )


end

function gameboard.draw()
    for key,value in pairs(objects) do
        love.graphics.setColor(objects[key].colors)
        if objects[key].shape:getType() == "polygon" then
            love.graphics.polygon("fill", objects[key].body:getWorldPoints(objects[key].shape:getPoints()))
        elseif objects[key].shape:getType() == "circle" then
            love.graphics.circle("fill", objects[key].body:getX(), objects[key].body:getY(), objects[key].shape:getRadius())
        end
    end
end

function gameboard.update(dt)
    physics:update(dt)
end

function gameboard:addShape(
                            myName,         behavior,           shape,               
                            color,          x,                  y,          
                            width,          height,             radius,
                            sides,          count,              rotation,
                            restitution,    rounded,            rounding_factor,
                            density,        magnetic,           magnetic_strength,         
                            stroke,         stroke_width,       depth,
                            myPhysics )
    local _1flag = false -- helps mediate the keys of objects that are split into multiple parts
    if (shape == gb_shapes["shape_rectangle"]) then
        if rounded then
            objects[myName .. "_1"] = {}
            objects[myName .. "_1"].body = love.physics.newBody(myPhysics, x, y, behavior)
            objects[myName .. "_1"].shape = love.physics.newRectangleShape(math.abs(width-height), height)
            objects[myName .. "_1"].fixture = love.physics.newFixture(objects[myName .. "_1"].body, objects[myName .. "_1"].shape, density)
            
            self:addShape(  (myName .. "_2"), behavior, gb_shapes["shape_circle"],
                            color, (x-math.abs(width-height)/2), y,
                            width, height, (height/2),
                            sides, count, rotation,
                            restitution, rounded, rounding_factor,
                            density, magnetic, magnetic_strength,
                            stroke, stroke_width, depth,
                            myPhysics )
            self:addShape(  (myName .. "_3"), behavior, gb_shapes["shape_circle"],
                            color, (x+math.abs(width-height)/2), y,
                            width, height, (height/2),
                            sides, count, rotation,
                            restitution, rounded, rounding_factor,
                            density, magnetic, magnetic_strength,
                            stroke, stroke_width, depth,
                            myPhysics )
            myName = (myName .. "_1")
        else
            objects[myName] = {}
            objects[myName].body = love.physics.newBody(myPhysics, x, y, behavior)
            objects[myName].shape = love.physics.newRectangleShape(width, height)
            objects[myName].fixture = love.physics.newFixture(objects[myName].body, objects[myName].shape, density)
        end
    elseif (shape == gb_shapes["shape_circle"]) then
        objects[myName] = {}
        objects[myName].body = love.physics.newBody(myPhysics, x, y, behavior)
        objects[myName].shape = love.physics.newCircleShape(radius)
        objects[myName].fixture = love.physics.newFixture(objects[myName].body, objects[myName].shape, density)
    end
    objects[myName].colors  = color
    objects[myName].depth   = depth
    
    -- sort the table to update the draw order
    table.sort(objects, function(a,b) return a[depth] < b[depth] end)

    --objectLog[myName] = {_myName = myName, _behavior = behavior, _shape = shape, _color = color, _x = x, _y = y, _width = width, _height = height, _radius = radius, _sides = sides, _count = count, _rotation = rotation, _restitution = restitution, _rounded = rounded, _rounding_factor = rounding_factor, _density = density, _magnetic = magnetic, _magnetic_strengh = magnetic_strength, _stroke = stroke, _stroke_width = stroke_width, _depth = depth, _myPhysics = myPhysics}
end

function gameboard.setupEnumerations()

    gb_shapes = 
    {
         shape_circle       = 1
        ,shape_cup          = 2
        ,shape_concave      = 3
        ,shape_convex       = 4
        ,shape_edge         = 5
        ,shape_polygon      = 6
        ,shape_rectangle    = 7
        ,shape_regular      = 8
        ,shape_polygon      = 9
        ,shape_spokes       = 10
    }

    gb_behaviors = 
    {
         behavior_static      = "static"
        ,behavior_kinematic   = "kinematic"
        ,behavior_dynamic     = "dynamic"
    }

    gb_colors = 
    {
        color_maroon = {0.5, 0, 0, 1}
    }

end

return gameboard

