local Object = require("lib/classic")
local World = require("src/world")
local Ball = require("src/entities/ball")
local Token = require("src/entities/token")
local Gameboard = require("src/gameboard")
local boardmaker = Object:extend()

local map = {}
local identifiers = 1
local width, height = 0, 0
local p = {} -- parameter array 
local ball = 10
local climate = "hot"
local ids = {}

function boardmaker:new(_width, _height, physics)
    width, height = _width, _height
    self:buildParameters()
    self:buildMap()
end

function boardmaker:generateRandomFeatures()

end



function boardmaker:generatePiece(shape, x, y)
    local   behavior, color, radius, restitution,
            density, friction, depth, gap, name
            width, height, angle, sides, count, profile
    name = (shape .. "_" .. tostring(popID(shape)))
    behavior = selectBehavior(shape)
    color = selectFromOdds(p.climate[climate])
    profile = selectFromOdds(p.profile.list)
    density = p.profile[profile].density
    restitution = p.profile[profile].restitution
    friction = p.profile[profile].friction

    if p.shape[shape] then
        if p.shape[shape].radius then
            if p.shape[shape].radius.min and p.shape[shape].radius.max then
                radius = math.random(p.shape[shape].radius.min, p.shape[shape].radius.max)
            else radius = 0 end
        else radius = 0 end
        if p.shape[shape].width then
            if p.shape[shape].width.min and p.shape[shape].width.max then
                width = math.random(p.shape[shape].width.min, p.shape[shape].width.max)
            else width = 0 end
        else width = 0 end
        if p.shape[shape].height then
                if p.shape[shape].height.min and p.shape[shape].height.max then
                height = math.random(p.shape[shape].height.min, p.shape[shape].height.max)
            else height = 0 end
        else height = 0 end
        if p.shape[shape].rotation then
                if p.shape[shape].rotation.min and p.shape[shape].rotation.max then
                rotation = math.random(p.shape[shape].rotation.min, p.shape[shape].rotation.max)
            else rotation = 0 end
        else rotation = 0 end
        if p.shape[shape].sides then
                if p.shape[shape].sides.min and p.shape[shape].sides.max then
                sides = math.random(p.shape[shape].sides.min, p.shape[shape].sides.max)
            else sides = 0 end
        else sides = 0 end
        if p.shape[shape].count then
                if p.shape[shape].count.min and p.shape[shape].count.max then
                count = math.random(p.shape[shape].count.min, p.shape[shape].count.max)
            else count = 0 end
        else count = 0 end
        if p.standard_depth then
            depth = p.standard_depth
        else depth = 100 end
        if p.shape[shape].angle then
            angle = selectFromOdds(p.shape[shape].angle)
        else angle = 0 end
        if p.shape[shape].gap then
            if p.shape[shape].gap.min and p.shape[shape].gap.max then
                gap = math.random(p.shape[shape].gap.min, p.shape[shape].gap.max)
            else gap = ball*2+2
        else gap = ball*2+2
    else return

    local margin = p.shape.margin
    if shape == "circle" then
        gameboard:addSimpleCircle(name, behavior, color, x, y, radius, restitution, density, friction, depth)
        self:setMap(x-radius-margin,y-radius-margin,x+radius+margin,y+radius+margin)
    elseif shape == "rectangle" then
        gameboard:addSimpleRectangle(name, behavior, color, x, y, width, height, angle, rounded, rotation, restitution, density, friction, depth)
        self:setMap(x-(width/2)-margin,y-(height/2)-margin,x+(width/2)+margin,y+(height/2)+margin)
    elseif shape == "spokes" then
        gameboard:addSimpleSpokes(name, behavior, color, x, y, width, height, rounded, count, angle, rotation, restitution, density, friction, depth)
        self:setMap(x-radius-margin,y-radius-margin,x+radius+margin,y+radius+margin)
    elseif shape == "regular" then
        gameboard:addSimpleRegular(name, behavior, color, x, y, radius, sides, angle, rotation, restitution, density, depth, friction)
        self:setMap(x-radius-margin,y-radius-margin,x+radius+margin,y+radius+margin)
    elseif shape == "slope" then
        gameboard:addSimpleSlope(name, behavior, color, x, y, width, radius, count, angle, rotation, restitution, density, friction, depth)
        
    elseif shape == "cup" then
        gameboard:addSimpleCup(name, behavior, color, x, y, width, radius, count, angle, rotation, restitution, density, friction, depth, gap)
    end
        
end

function boardmaker:buildParameters()
    p.shape.margins = 10

    p.climate = {}
    p.climate.list = {"hot","cold"}
    p.climate.hot = {0.2, {1,0,0,1}, 0.8, {0.7,0.1,0.1,1}}  --these are incomplete right now
    p.climate.cold = {0.2, {0,0,1,1}, 0.8, {0.1,0.1,0.7,1}} --these are incomplete right now
    for a,b in pairs(p.climate.list) do
        p.climate[b] = self:normalizeProbabilities(p.climate[b]) -- in theory this will work
    end

    p.behavior = {}
    p.behavior.list = {"static","kinematic","dynamic"}
    p.behavior.circle       = {1.00,0.00,0.00}
    p.behavior.rectangle    = {0.50,0.50,0.00}
    p.behavior.spokes       = {0.25,0.75,0.00}
    p.behavior.regular      = {0.33,0.67,0.00}
    p.behavior.slope        = {0.92,0.08,0.00}
    p.behavior.cup          = {0.98,0.02,0.00}
    for a,b in pairs(p.behavior) do
        b[1] = b[1]/(b[1]+b[2]+b[3])
        b[2] = b[2]/(b[1]+b[2]+b[3])
        b[3] = b[3]/(b[1]+b[2]+b[3])
    end

    p.colors = {}
    p.colors.list = Gameboard.getColors()
    for a,b in pairs(p.colors.list) do
        b = {b, 1/#p.colors.list}
    end

    p.x = {}
    p.x.margin = {}
    p.x.margin.min, p.x.margin.max = 8, 16
    p.y = {}
    p.y.margin = {}
    p.y.margin.top, p.y.margin.bottom = {},{}
    p.y.margin.top.min, p.y.margin.top.max       = 30, 40
    p.y.margin.bottom.min, p.y.margin.bottom.max = 30, 40
    p.y.slots = {}
    p.y.slots.width, p.y.slots.height = {},{}
    p.y.slots.width.min, p.y.slots.width.max    = 40, 60
    p.y.slots.height.min, p.y.slots.height.max  = 50, 50

    p.shape = {}
    p.shape.list = {"circle", "rectangle", "spokes", "regular", "slope", "cup"}
    p.shape.circle, p.shape.rectangle, p.shape.spokes, 
        p.shape.regular, p.shape.slope, p.shape.cup = {},{},{},{},{},{}

    p.shape.circle.radius = {}
    p.shape.circle.radius.min, p.shape.circle.radius.max = 10, 25

    p.shape.rectangle.roundChance = 0.50
    p.shape.rectangle.width, p.shape.rectangle.height = {},{}
    p.shape.rectangle.width.min, p.shape.rectangle.width.max = 80, 20
    p.shape.rectangle.height.min, p.shape.rectangle.height.max = 10, 30
    p.shape.rectangle.rotation = {}
    p.shape.rectangle.rotation.min, p.shape.rectangle.rotation.max = 1, 5
    p.shape.rectangle.angle = { { 0.10 , { 00 , 00 } }  ,
                                { 0.40 , { 10 , 30 } }  ,
                                { 0.30 , { 35 , 45 } }  ,
                                { 0.15 , { 50 , 60 } }  ,
                                { 0.05 , { 80 , 90 } }  }


    p.shape.regular.radius, p.shape.regular.sides = {},{}
    p.shape.regular.radius.min, p.shape.regular.radius.max = 15, 60
    p.shape.regular.sides.min, p.shape.regular.sides.max = 3, 8
    p.shape.regular.rotation = {}
    p.shape.regular.rotation.min, p.shape.regular.rotation.max = 1, 5
    p.shape.regular.angle = {   { 0.10 , { 00 , 00 } }  ,
                                { 0.40 , { 10 , 30 } }  ,
                                { 0.30 , { 35 , 45 } }  ,
                                { 0.15 , { 50 , 60 } }  ,
                                { 0.05 , { 80 , 90 } }  }

    p.shape.spokes.width, p.shape.spokes.height,
        p.shape.spokes.radius, p.shape.spokes.count = {},{},{},{}
    p.shape.spokes.width.maximumRadiusRatio = 0.667
    p.shape.spokes.width.min, p.shape.spokes.width.max = 100, 250
    p.shape.spokes.height.min, p.shape.spokes.height.max = 28, 35
    p.shape.spokes.radius.min, p.shape.spokes.radius.max = 40, 80
    p.shape.spokes.count.min, p.shape.spokes.count.max = 2, 6
    p.shape.spokes.rotation = {}
    p.shape.spokes.rotation.min, p.shape.spokes.rotation.max = 1, 5
    p.shape.spokes.angle = {    { 0.10 , { 00 , 00 } }  ,
                                { 0.40 , { 10 , 30 } }  ,
                                { 0.30 , { 35 , 45 } }  ,
                                { 0.15 , { 50 , 60 } }  ,
                                { 0.05 , { 80 , 90 } }  }

    p.shape.slope.width, p.shape.slope.radius, p.shape.slope.count = {},{},{}
    p.shape.slope.minimumGap = 5
    p.shape.slope.width.min, p.shape.slope.width.max = 50, 250
    p.shape.slope.radius.min, p.shape.slope.radius.max = 10, 20
    p.shape.slope.count.min, p.shape.slope.count.max = nil, nil -- to be calculated on the fly
    p.shape.slope.rotation = {}
    p.shape.slope.rotation.min, p.shape.rotation.slope.max = 1, 5
    p.shape.slope.angle = {     { 0.10 , { 00 , 00 } }  ,
                                { 0.40 , { 10 , 30 } }  ,
                                { 0.30 , { 35 , 45 } }  ,
                                { 0.15 , { 50 , 60 } }  ,
                                { 0.05 , { 80 , 90 } }  }

    p.shape.cup.width, p.shape.cup.radius,
        p.shape.cup.count, p.shape.cup.gap = {},{},{},{}
    p.shape.cup.width.min, p.shape.cup.width.max = 30, 90
    p.shape.cup.radius.min, p.shape.cup.radius.max = 5, 20
    p.shape.cup.count.min, p.shape.cup.count.max = nil, nil -- to be calculated on the fly
    p.shape.cup.gap.min, p.shape.cup.gap.max = ball*2+2
    p.shape.cup.rotation = {}
    p.shape.cup.rotation.min, p.shape.cup.rotation.max = 1, 5
    p.shape.cup.angle = {   { 0.10 , { 00 , 00 } }  ,
                            { 0.40 , { 10 , 30 } }  ,
                            { 0.30 , { 35 , 45 } }  ,
                            { 0.15 , { 50 , 60 } }  ,
                            { 0.05 , { 80 , 90 } }  }

    
    p.shape.rectangle.angle = self:normalizeProbabilities(p.shape.rectangle.angle)
    p.shape.regular.angle = self:normalizeProbabilities(p.shape.rectangle.angle)
    p.shape.spokes.angle = self:normalizeProbabilities(p.shape.rectangle.angle)
    p.shape.slope.angle = self:normalizeProbabilities(p.shape.rectangle.angle)
    p.shape.cup.angle = self:normalizeProbabilities(p.shape.rectangle.angle)

    p.profile = {}
    p.profile.attributes = { "density", "restitution", "friction" }
    p.profile.list = {  {1.00, "normal"}     , 
                        {1.00, "bouncy"}     , 
                        {1.00, "hardrough"}  ,
                        {1.00, "dampening"}  ,
                        {1.00, "bouncyplus"} ,
                        {1.00, "stopper" }

    p.profile.list = normalizeProbabilities(p.profile.list)
    for a,b in pairs(p.profile.list) do
        profile[b[2]] = {}
    end
    
    p.profile.  normal      .   density     = 1
    p.profile.  bouncy      .   density     = 2
    p.profile.  dampening   .   density     = 2.5
    p.profile.  hardrough   .   density     = 1.5
    p.profile.  bouncyplus  .   density     = 3
    p.profile.  stopper     .   density     = 1
    p.profile.  normal      .   restitution = 0.3
    p.profile.  bouncy      .   restitution = 0.5
    p.profile.  dampening   .   restitution = 0.15
    p.profile.  hardrough   .   restitution = 0.08
    p.profile.  bouncyplus  .   restitution = 0.8
    p.profile.  stopper     .   restitution = 0
    p.profile.  normal      .   friction    = 0.25
    p.profile.  bouncy      .   friction    = 0.2
    p.profile.  dampening   .   friction    = 0.8
    p.profile.  hardrough   .   friction    = 2
    p.profile.  bouncyplus  .   friction    = 1
    p.profile.  stopper     .   friction    = 100000

    p.standard_depth = 100


end

function selectBehavior(shape)
    local odds_table, sum = {} , 0
    for a,b in pairs(b.behavior[shape]) do
        odds_table[a] = b+sum
        sum = sum+b
    end
    local r, flag, selection = math.random(), false, 1
    for a,b in pairs(odds_table) do
        if flag == false and b > r then
            flag = true
            selection = a
        end
    end
    return p.behavior.list[selection]
end

function selectFromOdds(probabilities_table)
    local odds_table, sum = {} , 0
    for a,b in pairs(probabilities_table) do
        odds_table[a] = b[1]+sum
        sum = sum+b[1]
    end
    local r, flag, selection = math.random(), false, 1
    for a,b in pairs(odds_table) do
        if flag == false and b[1] > r then
            flag = true
            selection = a
        end
    end
    return (probabilities_table[selection])[2]
end

function checkMap(x,y)
    return map[(x*width)+y+1]
end

function setMap(x,y)
    map[(x*width)+y+1] = true
end

function setMap(x1,y1,x2,y2)
    for x=x1,x2,1 do
        for y=y1,y2,1 do
            map[(x*width)+y+1] = true
        end
    end
end

function buildMap()
    for i=1, (width*height)+1, 1 do
        map[i] = false
    end
end

function setBallRadius(radius)
    ball = radius
end

function normalizeProbabilities(probabilities)
    local sum = 0
    for a,b in pairs(probabilities) do
        sum = sum + b[1]
    end
    for a,b in pairs(probabilities) do
        probabilities[a] = { (b[1] * 1/sum) , { (b[2])[1], (b[2])[1] } }
    end
    return probabilities
end

function setClimate(new_climate)
    climate = new_climate
    local flag = false
    for a,b in pairs(p.climate.list) do
        if climate = b then
            return climate
        end
    end
    return p.climate.list[1] -- set to the first climate in the list if this function fails
end

function getClimate()
    return climate
end

function buildIDs()
    for a,b in pairs(p.shapes.list) do
        ids[b] = 0
    end
end

function popID(shape)
    if ids[shape] then
        ids[shape] = ids[shape] + 1
        return (ids[shape]-1)
    else return 0 end
end

return boardmaker