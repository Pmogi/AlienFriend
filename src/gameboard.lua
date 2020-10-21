local Object = require("lib/classic")
local Ball = require("src/entities/ball")
local Token = require("src/entities/token")
local Resource = require("src/systems/resource")

local gameboard = Object:extend()
local physics
local drawOrder = {}
local _meter                = 32
local _gravity_constant     = 9.81
local _gravity_factor_x     = 0
local _gravity_factor_y     = 1
local objects = {} -- physics to hold all our physical objects
--local objectLog = {}

local tokeninfo = {}
tokeninfo.types = { "AC", "antimatter", "food", "credits"}
tokeninfo.odds = {0.333, 0.333, 0.334, 0.0}
tokeninfo.maxs = {10, 1, 10, 10}
tokeninfo.nextID = 0

local drawcycle = 0


local physics = love.physics.newWorld(  _meter * _gravity_constant * _gravity_factor_x
                , _meter * _gravity_constant * _gravity_factor_y
                , true)

function gameboard:getPhysics()
    return physics
end

function gameboard:new()
    self.id = "gameboard"
    self:setupEnumerations()
    
    love.graphics.setBackgroundColor({0.41, 0.53, 0.97})
    love.window.setMode(720, 720) -- set the window dimensions to 650 by 650
    love.physics.setMeter(_meter)

    physics:setCallbacks(beginContact, endContact, preSolve, postSolve)

    --objects["ballTest"] =  Ball(400, 100, 10, 0.50, 1, physics)

    --gameboard:addSimpleRectangle("0_rectangle","static",{0,0,0,1},0,360,2,720,0,false,0,1,1,1,0)
    --gameboard:addSimpleRectangle("1_rectangle","static",{0,0,0,1},718,360,2,720,0,false,0,1,1,1,0)
    --gameboard:addSimpleRectangle("2_rectangle","static",{0,0,0,1},360,718,720,2,0,false,0,1,1,1,0)
    --gameboard:addShape("27_spokes","kinematic",gb_shapes["shape_spokes"],{0.184,0.482,0.51,1},360,260,290,30,204,3,1,3,0.8,true,0,2,false,0,0,0,0,45,nil,0.5,physics)
    --gameboard:addSimpleRectangle("77_rectangle","static",{0.235,0.243,0.608,1},126,666,120,20,90,true,0,0.8,2,0.5,0)
    gameboard:addSimpleRectangle("80_rectangle","static",{0.235,0.243,0.608,1},270,666,120,20,90,true,0,0.8,2,0.5,0)
    --gameboard:addSimpleRectangle("81_rectangle","static",{0.235,0.243,0.608,1},414,666,120,20,90,true,0,0.8,2,0.5,0)
    --gameboard:addSimpleRectangle("83_rectangle","static",{0.235,0.243,0.608,1},558,666,120,20,90,true,0,0.8,2,0.5,0)

end

function gameboard:addSpawner(myName, x, y)

end

function gameboard:addToken(myName, x, y)
    odds = {}
    odds.flag = false
    odds.selected = 1
    odds.vals = {}
    odds.vals[1] = 0
    for t=2,#tokeninfo.odds,1 do
        odds.vals[t] = tokeninfo.odds[(t-1)] + odds.vals[(t-1)]
    end
    random = math.random()
    for i=#odds.vals,1,-1 do
        if random > odds.vals[i] and not odds.flag then
            odds.selected = i
            odds.flag = true
        end  
    end
    odds.count = math.ceil(math.pow(math.random(),3)*tokeninfo.maxs[odds.selected])
    print("[TOKEN] Count = " .. odds.count .. " | Type = " .. tokeninfo.types[odds.selected])
    if odds.count == 1 then
        objects[(tokeninfo.nextID .. "_token")] = Token(x, y, tokeninfo.types[odds.selected], physics)
        tokeninfo.nextID = tokeninfo.nextID + 1
    else
        for i=1,odds.count,1 do
            objects[tokeninfo.nextID .. "_token"] = Token(x+math.random(-10,10), y+math.random(-10,10), tokeninfo.types[odds.selected], physics)
            tokeninfo.nextID = tokeninfo.nextID + 1
        end
    end
end

function gameboard:addSimpleCircle      (myName, behavior, color, x, y, radius, restitution, density, friction, depth)
    self:addShape(myName, behavior, gb_shapes["shape_circle"], color, x, y, 0, 0, radius, 0, 0, 0, restitution, 0, 0, density, 0, 0, nil, 0, depth, 0, {}, friction, physics)
    print("New circle radius = " .. radius)
end

function gameboard:addSimpleRectangle   (myName, behavior, color, x, y, width, height, angle, rounded, rotation, restitution, density, friction, depth)
    self:addShape(myName, behavior, gb_shapes["shape_rectangle"], color, x, y, width, height, 0, 0, 0, rotation, restitution, rounded, 0, density, 0, 0, nil, 0, depth, angle, {}, friction, physics)
end

function gameboard:addSimpleSpokes      (myName, behavior, color, x, y, width, height, rounded, count, angle, rotation, restitution, density, friction, depth)
    self:addShape(myName, behavior, gb_shapes["shape_spokes"], color, x, y, width, height, 0, 0, count, rotation, restitution, rounded, 0, density, 0, 0, nil, 0, depth, angle, {}, friction, physics)
end

function gameboard:addSimpleRegular     (myName, behavior, color, x, y, radius, sides, angle, rotation, restitution, density, depth, friction)
    self:addShape(myName, behavior, gb_shapes["shape_regular"], color, x, y, 0, 0, radius, sides, 0, rotation, restitution, 0, 0, density, 0, 0, nil, 0, depth, angle, {}, friction, physics)
end

function gameboard:addSimpleSlope       (myName, behavior, color, x, y, width, radius, count, angle, rotation, restitution, density, friction, depth)
    self:addShape(myName, behavior, gb_shapes["shape_slope"], color, x, y, width, 0, radius, 0, count, rotation, restitution, 0, 0, density, 0, 0, nil, 0, depth, angle, 0, friction, physics)
end

function gameboard:addSimpleCup       (myName, behavior, color, x, y, width, radius, count, angle, rotation, restitution, density, friction, depth, gap_width)
    if angle > 90 and angle < 270 then
        self:addShape(myName.."_1", behavior, gb_shapes["shape_slope"], color, x-(gap_width/2)-((width*math.cos(math.rad(angle)))/2), y, width, 0, radius, 0, count, rotation, restitution, 0, 0, density, 0, 0, nil, 0, depth, angle, 0, friction, physics)
        self:addShape(myName.."_2", behavior, gb_shapes["shape_slope"], color, x+(gap_width/2)+((width*math.cos(math.rad(angle)))/2), y, width, 0, radius, 0, count, rotation, restitution, 0, 0, density, 0, 0, nil, 0, depth, angle+90, 0, friction, physics)
    else
        self:addShape(myName.."_1", behavior, gb_shapes["shape_slope"], color, x+(gap_width/2)+((width*math.cos(math.rad(angle)))/2), y, width, 0, radius, 0, count, rotation, restitution, 0, 0, density, 0, 0, nil, 0, depth, angle, 0, friction, physics) -- needs slight adjustment
        self:addShape(myName.."_2", behavior, gb_shapes["shape_slope"], color, x-(gap_width/2)-((width*math.cos(math.rad(angle)))/2), y, width, 0, radius, 0, count, rotation, restitution, 0, 0, density, 0, 0, nil, 0, depth, angle-90, 0, friction, physics) -- needs slight adjustment
    end
        
        
end

function gameboard.draw()
    for key,value in pairs(objects) do
        print(drawcycle .. " || " .. key)
        love.graphics.setColor(objects[key].colors)
        if objects[key].shape:getType() == "polygon" then
            love.graphics.polygon("fill", objects[key].body:getWorldPoints(objects[key].shape:getPoints()))
        elseif(not (value.img == nil)) then -- if it has an img, then draw using the object's draw method
            objects[key]:draw()
        elseif objects[key].shape:getType() == "circle" then
            love.graphics.circle("fill", objects[key].body:getX(), objects[key].body:getY(), objects[key].shape:getRadius())
            print("draw circle radius = " .. value.shape:getRadius())
            print("Printing Circle: [X] " .. value.body:getX() .. " | [Y] " .. value.body:getY())
        end
    end
end

function gameboard.update(dt)
    drawcycle = drawcycle+1
    -- iterate through the bodies and delete any bodies whose's alive status is false
    for key,obj in pairs(objects) do
        if obj.fixture:getUserData().alive == false then
            print("OBJECT DESTROY")
            obj.fixture:destroy()
            obj.body:destroy()
            obj = nil
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
            objects[myName].fixture:setFriction(friction)
            objects[myName].fixture:setRestitution(restitution)
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
            width, height, radius,
            sides, count, rotation,
            restitution, rounded, rounding_factor,
            density, magnetic, magnetic_strength,
            stroke, stroke_width, depth,
            ((360/count)*(i-1)), vertices, friction,
            myPhysics)
        end
        if true then goto continue end
    elseif (shape == gb_shapes["shape_cup"]) then
        -- UNDER CONSTRUCTION
    elseif (shape == gb_shapes["shape_slope"]) then
        local dx = math.cos(math.rad(angle))
        local dy = math.sin(math.rad(angle))
        local pos = {}
        if count == 1 then
            table.insert(pos, 0)
        else
            table.insert(pos, 0 - (width/2))
            for i=2, count-1, 1 do
                table.insert(pos,(width/-2) + ((i-1)/(count-1) * width))
            end
            table.insert(pos,width/2)
        end
        for a,b in pairs(pos) do
            --print(x .. " | " .. dx .. " | " .. b)
            self:addShape((myName .. "_" .. a), behavior, gb_shapes["shape_circle"], color,
            x+(dx*b), y+(dy*b),
            width, height, radius, sides, count, rotation, restitution, rounded, rounding_factor, density, magnetic, magnetic_strength, stroke, stroke_width, depth, angle, vertices, friction, myPhysics)
        end
        return
    end
    --print("myname = " .. myName)
    objects[myName].fixture:setUserData({id = myName, alive = true, shape = true})
    print(objects[myName].fixture:getUserData().id)
    objects[myName].fixture:setFilterData(1,2,-1)
    objects[myName].colors       = color
    objects[myName].depth        = depth
    objects[myName].stroke       = stroke
    objects[myName].stroke_width = stroke_width
    
    ::continue::
    table.sort(objects, function(a,b) return a[depth] < b[depth] end)-- sort the table to update the draw order
end

function gameboard.setupEnumerations()
    gb_shapes = 
    {
         shape_circle       = 1     --DONE
        ,shape_cup          = 2     --DONE
        ,shape_rectangle    = 3     --DONE
        ,shape_regular      = 4     --DONE
        ,shape_polygon      = 5     --DONE
        ,shape_spokes       = 6     --DONE
        ,shape_slope        = 7     --DONE

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

function gameboard.getColors()
    return gb_colors
end

-- Callback functions for handling colissions between fixtures ------------------

-- a and b are different colliding fixtures, coll is the "contact object"
function beginContact(a, b, coll)
    ad = a:getUserData()
    bd = b:getUserData()
    if a.shape or b.shape then
        --print(a.id)
        return 0
    end
    if (ad.id == "Ball" and bd.id == "Token") then
       b:setUserData({alive = false}) 
       --print("butt")
       Resource.addResource(1)
    elseif(bd.id == "Ball" and ad.id == "Token") then
        a:setUserData({alive = false})
        Resource.addResource(1)
        --print("butt")
    end
end
 
function endContact(a, b, coll)
 
end
 
function preSolve(a, b, coll)
 
end
 
function postSolve(a, b, coll, normalimpulse, tangentimpulse)
 
end


----------------------------------------------------------------------------------
return gameboard
