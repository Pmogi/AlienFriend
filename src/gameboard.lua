local Object = require("lib/classic")
local World = require("src/world")
local Ball = require("src/entities/ball")
local Token = require("src/entities/token")

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

    objects["ballTest"] =  Ball(100, 100, 10, 0.50, 1, physics)
    objects["testToken"] = Token(250, 250, physics)
    -- objects.ballTest2   =  Ball(300, 400, 10, 0.5, physics)
    
    self:addShape(  "test", gb_behaviors["behavior_kinematic"], gb_shapes["shape_spokes"],
                    gb_colors["color_maroon"], 200, 300,
                    200, 30, -1,
                    -1, 3, 1,
                    0.50, true, 1,
                    1 , false, 0,
                    {0,0,0,1}, 2, 100,
                    0, {}, 10,
                    physics )

    self:addShape(  "test2", gb_behaviors["behavior_kinematic"], gb_shapes["shape_spokes"],
                    gb_colors["color_maroon"], 100, 100,
                    200, 30, -1,
                    -1, 3, 1,
                    0.50, true, 1,
                    1 , false, 0,
                    {0,0,0,1}, 2, 100,
                    0, {}, 10,
                    physics )
    
    self:addShape(  "test3", gb_behaviors["behavior_kinematic"], gb_shapes["shape_circle"],
                    gb_colors["color_maroon"], 500, 300,
                    400, 80, 20,
                    -1, 3, 1,
                    0.99, true, 1,
                    1 , false, 0,
                    {0,0,0,1}, 2, 100,
                    0, {}, 10,
                    physics )

    
    --self:addShape("test", gb_behaviors["behavior_static"], gb_shapes["shape_regular"], {1,0,0,1}, 100, 100, 1,1,100, 8, 1, 0, 1, false, 0, 1, false, 0, false, 0, 0, 180,{}, 0,physics)
end

function gameboard.draw()
    for key,value in pairs(objects) do
        love.graphics.setColor(objects[key].colors)
        if objects[key].shape:getType() == "polygon" then
            love.graphics.polygon("fill", objects[key].body:getWorldPoints(objects[key].shape:getPoints()))
        
        elseif(not (objects[key].img == nil)) then -- if it has an img, then draw using the object's draw method
            objects[key]:draw()

        elseif objects[key].shape:getType() == "circle" then
            if objects[key].stroke == nil then
                love.graphics.circle("fill", objects[key].body:getX(), objects[key].body:getY(), objects[key].shape:getRadius())
            else
                love.graphics.setColor(objects[key].stroke)
                love.graphics.circle("fill", objects[key].body:getX(), objects[key].body:getY(), objects[key].shape:getRadius())
                love.graphics.setColor(objects[key].colors)
                love.graphics.circle("fill", objects[key].body:getX(), objects[key].body:getY(), objects[key].shape:getRadius() - objects[key].stroke_width)
            end
        end
    end
end

function gameboard.update(dt)

    for key in pairs(objects) do 
        --if love.keyboard.isDown("f") and objects[key].shape:getType() == 'circle' then
        --    objects[key].fixture:setUserData({alive = false})
        --end
        if objects[key].fixture ~= nil then
            if objects[key].fixture:getUserData().alive == false then
                objects[key].fixture:destroy()
                objects[key].body:destroy()
                objects[key] = nil

            end
        end
    end


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
                            angle,          vertices,           friction,
                            myPhysics )
    local _1flag = false -- helps mediate the keys of objects that are split into multiple parts
    if (shape == gb_shapes["shape_rectangle"]) then
        if rounded then
            objects[myName .. "_1"] = {}
            objects[myName .. "_1"].body = love.physics.newBody(myPhysics, x, y, behavior)
                objects[myName .. "_1"].body:setAngularVelocity(rotation)
            objects[myName .. "_1"].shape = love.physics.newRectangleShape(0,0,math.abs(width-height), height, math.rad(angle))
            objects[myName .. "_1"].fixture = love.physics.newFixture(objects[myName .. "_1"].body, objects[myName .. "_1"].shape, density)
            objects[myName .. "_1"].fixture:setFriction(friction)
            objects[myName .. "_1"].fixture:setRestitution(restitution)

            -- Weld two circles together at the end of the rectangles to make 'rounded edges'
            self:addShape(  (myName .. "_2"), gb_behaviors["behavior_dynamic"], gb_shapes["shape_circle"],
                            color, (x - ((math.abs(width-height)/2) * math.cos(math.rad(angle)))), y - ((math.abs(width-height)/2) * math.sin(math.rad(angle))),
                            width, height, (height/2),
                            sides, count, rotation,
                            restitution, rounded, rounding_factor,
                            density, magnetic, magnetic_strength,
                            stroke, stroke_width, depth,
                            0, {}, friction,
                            myPhysics )

            self:addShape(  (myName .. "_3"), gb_behaviors["behavior_dynamic"], gb_shapes["shape_circle"],
                            color, (x + ((math.abs(width-height)/2) * math.cos(math.rad(angle)))), y + ((math.abs(width-height)/2) * math.sin(math.rad(angle))),
                            width, height, (height/2),
                            sides, count, rotation,
                            restitution, rounded, rounding_factor,
                            density, magnetic, magnetic_strength,
                            stroke, stroke_width, depth,
                            0, {}, friction,
                            myPhysics )

            -- Two joints for attaching the circle shapes
            local x2w, y2w = objects[myName .. "_2"].body:getWorldPoints(objects[myName .. "_2"].body:getX(), objects[myName .. "_2"].body:getY())
            local j2 = love.physics.newWeldJoint(objects[myName .. "_1"].body, objects[myName .. "_2"].body, x2w, y2w, false)
            local x3w, y3w = objects[myName .. "_3"].body:getWorldPoints(objects[myName .. "_3"].body:getX(), objects[myName .. "_2"].body:getY())
            local j3 = love.physics.newWeldJoint(objects[myName .. "_1"].body, objects[myName .. "_3"].body, x3w, y3w, false)

            myName = (myName .. "_1")

        else
            objects[myName] = {}
            objects[myName].body = love.physics.newBody(myPhysics, x, y, behavior)
            objects[myName].shape = love.physics.newRectangleShape(width, height)
            objects[myName].fixture = love.physics.newFixture(objects[myName].body, objects[myName].shape, density)
            objects[myName]:setFriction(friction)
            objects[myName]:setRestitution(friction)
        end
    elseif (shape == gb_shapes["shape_circle"]) then
        objects[myName] = {}
        objects[myName].body = love.physics.newBody(myPhysics, x, y, behavior)
        objects[myName].shape = love.physics.newCircleShape(radius)
        objects[myName].fixture = love.physics.newFixture(objects[myName].body, objects[myName].shape, density)
        objects[myName].fixture:setFriction(friction)
        objects[myName].fixture:setRestitution(restitution)

    
    elseif (shape == gb_shapes["shape_polygon"]) then
        objects[myName] = {}
        objects[myName].body = love.physics.newBody(myPhysics, x, y, behavior)
        objects[myName].shape = love.physics.newPolygonShape(vertices)
        objects[myName].fixture = love.physics.newFixture(objects[myName].body, objects[myName].shape, density)
        objects[myName].fixture:setFriction(friction)
        objects[myName].fixture:setRestitution(restitution)
        

    
    elseif (shape == gb_shapes["shape_regular"]) then
        local myVertices  = {}
        for i=0, sides-1, 1 do
            table.insert(myVertices, x+(math.sin(math.rad(((360/sides)*i)+angle))*radius))
            table.insert(myVertices, y+(math.cos(math.rad(((360/sides)*i)+angle))*radius))
        end

        self:addShape(myName, behavior, gb_shapes["shape_polygon"], color, x, y,  width, height, radius, sides, count, rotation, restitution, rounded, rounding_factor, density, magnetic, magnetic_strength, stroke, stroke_width, depth, angle, myVertices, friction, myPhysics)

    elseif (shape == gb_shapes["shape_spokes"]) then
        for i=1, count, 1 do
            self:addShape((myName .. "_" .. tostring(i)), behavior, gb_shapes["shape_rectangle"], 
            color, x, y,
            --x + ((math.abs(width-height)/2) * (math.cos(math.rad(((360/count)-1)*i)))),
            --y + ((math.abs(width-height)/2) * (math.sin(math.rad(((360/count)-1)*i)))),
            width, height, radius,
            sides, count, rotation,
            restitution, rounded, rounding_factor,
            density, magnetic, magnetic_strength,
            stroke, stroke_width, depth,
            ((360/count)*(i-1)), vertices, friction,
            myPhysics)
        end
        if true then goto continue end
    end
    
    objects[myName].fixture:setUserData({id = myName, alive = true})
    objects[myName].colors       = color
    objects[myName].depth        = depth
    objects[myName].stroke       = stroke
    objects[myName].stroke_width = stroke_width

    -- if objects[myName].stroke ~= nil and objects[myName].shape:getType() == 'polygon'  then
    --     print(objects[myName].body:getWorldPoints(objects[myName].shape:getPoints()))
    --     for c in tostring(objects[myName].body:getWorldPoints(objects[myName].shape:getPoints())) do
    --         print(i)
    --     end
    -- end

    ::continue::
    -- sort the table to update the draw order
    table.sort(objects, function(a,b) return a[depth] < b[depth] end)

    --objectLog[myName] = {_myName = myName, _behavior = behavior, _shape = shape, _color = color, _x = x, _y = y, _width = width, _height = height, _radius = radius, _sides = sides, _count = count, _rotation = rotation, _restitution = restitution, _rounded = rounded, _rounding_factor = rounding_factor, _density = density, _magnetic = magnetic, _magnetic_strengh = magnetic_strength, _stroke = stroke, _stroke_width = stroke_width, _depth = depth, _myPhysics = myPhysics}
end

function gameboard.setupEnumerations()

    gb_shapes = 
    {
         shape_circle       = 1     --DONE
        ,shape_cup          = 2     -- a series of pegs
        ,shape_rectangle    = 3     --DONE
        ,shape_regular      = 4     --DONE
        ,shape_polygon      = 5     --DONE
        ,shape_spokes       = 6     --DONE

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

function gameboard.shrinkPolygon(table)
    
end


return gameboard

