local Object = require("lib/classic")
local BallFactory = require("src/entities/ballFactory")
local Token = require("src/entities/token")
local Resource = require("src/systems/resource")
local tokenmaker = Object:extend()


local tokens = {}
local index = 0.0
local increment = 0.01
local detractment = 0.02
local playfield = {}
playfield.x = 0
playfield.y = 0
playfield.w = 720
playfield.h = 720
local screen_width, screen_height = 720, 720

function tokenmaker:new()
    self.id = "tokenmaker"
    self:Initialize()

end

function tokenmaker:Initialize()
    tokens.types = {"a","b","c"}
    for a,b in pairs(tokens.types) do tokens[b] = {} end
    for a,b in pairs(tokens.types) do tokens[b].quad = {} end
    for a,b in pairs(tokens.types)  do tokens[b].odds = {} end
    for a,b in pairs(tokens.types)  do tokens[b].variance = {} end
    for a,b in pairs(tokens.types) do tokens[b].name = "" end
    local a, b, c = "a", "b", "c"
    tokens[a].name = "AC"
    tokens[b].name = "Food"
    tokens[c].name = "Antimatter"
    tokens[a].quad = {  0.2,  0.04, 0, 0,  0 }
    tokens[b].quad = {  2.0,  4.0, 0, 0,  0 }
    tokens[c].quad = {  2.0,  4.0, 0, 0,  0 }
    tokens[a].odds = {  1.0,  1.0,  1.0 }
    tokens[b].odds = {  1.0,  1.0,  1.0 }
    tokens[c].odds = {  1.0,  1.0,  1.0 }
    tokens[a].variance = {  0.2,  0.2,  0.2 }
    tokens[b].variance = {  0.2,  0.2,  0.2 }
    tokens[c].variance = {  0.2,  0.2,  0.2 }
    tokens.clock = { 0.0, 0.0, 0.0 }
    tokens.tokens = {}
    tokens.counter = 0

end

function tokenmaker:update(dt)

    for a,b in pairs(tokens.types) do
        if tokens.clock[a] <= 0 then
            -- set q and r (sum of quadrinomial timings * trinomial variance)
            local q = ( (tokens[b].quad[1]) + (tokens[b].quad[2] * index) + (tokens[b].quad[3] * math.pow(index,2))
                      + (tokens[b].quad[4] * math.pow(index,3)) + (tokens[b].quad[5] * math.pow(index,4)) )
            local r = math.random(1 - tokens[b].variance[1], 1 + tokens[b].variance[1]) , math.random(math.pow(1 - tokens[b].variance[3],3),math.pow(1 + tokens[b].variance[3],3)) , math.random(math.pow(1 - tokens[b].variance[3],3),math.pow(1 + tokens[b].variance[3],3))
            tokens.clock[a] = q * r
            -- spawn token
            tokens.counter = tokens.counter + 1
            tokens.tokens[tokens.counter] = Token:new( self, tokens.counter, math.random(playfield.w)+playfield.x  ,  playfield.y  ,  tokens[b].name )
            
        else
        tokens.clock[a] = tokens.clock[a] - detractment
        end
    end

    for a,b in pairs(tokens.tokens) do
        b:update(dt)
    end

    index = index + increment
end

function tokenmaker:draw()
    for a,b in pairs(tokens.tokens) do
        b:draw()
    end
end

function tokenmaker:destroy(id)
    print("!!!!!!!!!")
    tokens.tokens[id] = nil
end

function tokenmaker:getDestructionPoint()
    return playfield.h
end

return tokenmaker