-- Libraries
local Object = require("lib/classic")
local Timer = require("lib/timer")

-- Modules
local Assets = require("src/assets")
local ScreenShake = require("src/systems/screenShake")
local Score = require("src/systems/score")


local Player = Object:extend()

-- table for particles (if I use them)
local p, pe
local pe = {}

-- constants for orientating the snake body
local down = 2
local right = 1
local left = 3
local up = 0

local time = 0

function Player:new()
    self.id = "Player"

    self.imgScale = 1
    self.hit = false -- will be used for death state animation, then go to alive = false
    self.alive = true -- if collision happens, set false, go to death state
    
    -- a table for storing the data for each segment
    self.body = {}
    self.length = 0
    
    -- store the move that will be used in the next update
    self.moveBuffer = nil

    -- initial worm
    self:addWormSegment(down,  5, 5)
    self:addWormSegment(down,  5, 4)
    self:addWormSegment(down,  5, 3)

end

function Player:__toString()
    return self.x .. ", " .. self.y .. ', ' .. self.angle
end

function Player:update(dt, Tile)
    
    if love.keyboard.isDown("right") and not (self.body[1].going == left) then
        self.moveBuffer = right
    elseif love.keyboard.isDown("down") and not (self.body[1].going == up) then
        self.moveBuffer = down
    elseif love.keyboard.isDown("up") and not (self.body[1].going == down) then
        self.moveBuffer = up
    elseif love.keyboard.isDown("left") and not (self.body[1].going == right) then
        self.moveBuffer = left
    end

    time = time + dt
    if (time > 0.2) then
        
        -- update the tile data structure
        self:updateTile(Tile)

        -- check next state for collission
        self:checkCollision(Tile) 

        -- move the worm
        self:moveWorm(Tile)
        
        time = 0
    end
end

-- iterate through the worm and update the position based on the 'going' direction
function Player:moveWorm()
    
    -- storing the prev segment
    local prevGoing
    local temp 

    for i, seg in ipairs(self.body) do
        -- if head, set prev going as it's own going
        if i == 1 then
            -- update with the move buffered from player input or current direction
            prevGoing = self.moveBuffer or seg.going
        end
            
        -- store the current segment's direction and use the casscated state
        temp = seg.going
        seg.going = prevGoing
            
        -- update the segment based on the new going direction
        if seg.going == down then
            seg.tileY = seg.tileY + 1
        
        elseif seg.going == up then
            seg.tileY = seg.tileY - 1
        
        elseif seg.going == right then
            seg.tileX = seg.tileX + 1
        
        elseif seg.going == left then
            seg.tileX = seg.tileX - 1
        else
            error("moveWork(): Undefined direction for worm segment " .. i)
        end
            
        -- casscade the current segment's state down to the next segment
        prevGoing = temp
    end
end

-- add a new segment to the tail end, also shake the screen and play a audio effect
function Player:addToWorm()
    local tail = self.body[self.length]
    
    if (tail.going == up) then
        self:addWormSegment(up, tail.tileX, tail.tileY + 1)
    
    elseif (tail.going == down) then
        self:addWormSegment(down, tail.tileX, tail.tileY - 1)

    elseif (tail.going == left) then
        self:addWormSegment(left, tail.tileX + 1, tail.tileY)

    elseif (tail.going == right) then
        self:addWormSegment(right, tail.tileX - 1, tail.tileY)
    else
        error("addToWorm(): Error with tail segment's going direction")
    end

    ScreenShake.startShake()
    local chooseNom = math.random( 0, 1 )
    
    -- randomly choose a nom sample to play
    if chooseNom == 1 then
        Assets.getAsset("nom"):play()
    else
        Assets.getAsset("nom2"):play()
    end
    
end

function Player:addWormSegment(direction, tileX, tileY) 
    table.insert(self.body,  { going = direction, tileX = tileX, tileY = tileY})
    self.length = self.length + 1
end

function Player:draw()
    self:drawSnake()
end

function Player:drawSnake()
    -- iterate through the body table of the snake
    for i, seg in ipairs(self.body) do 
        local type
        local img

        type, img = getBodyData(i, self)

        -- for storing the rotation of the segment
        local rotation

        -- find the orientation of the bend and it's rotation based on the segment in front and behind
        if (type == "bend") then
            -- get direction of bending segment
            local ahead =  self.body[i-1].going
            local current = self.body[i].going
            
            if ((ahead == right and current == up) or (ahead == down and current == left)) then
                rotation = math.pi/2
            elseif ((ahead == down and current == right) or (ahead == left and current == up)) then
                rotation = math.pi
            elseif ((ahead == right and current == down) or (ahead == up and current == left)) then
                rotation = 0
            elseif ((ahead == up and current == right) or (ahead == left and current == down)) then
                rotation = math.pi*3/2
            else
                 error("drawSnake(): Undefined bend state.\n Direction of current and ahead segment: " .. self.body[i].going .. ', ' .. self.body[i-1].going)
            end

            love.graphics.draw(img,
            (64 * seg.tileX) -32 +64,
            (64 * seg.tileY) -32 +64,
            rotation,
            self.imgScale,
            self.imgScale,
            img:getWidth()/2,
            img:getHeight()/2)
        
            -- the case for straight, head or tail
        else
            
            if (i == self.length) then
                seg.going = self.body[i-1].going
            end

            if seg.going == down then
                rotation = 2*math.pi 
            
            elseif seg.going == right then
                rotation = math.pi*3/2 
            
            elseif seg.going == up then
                rotation = math.pi 
            
            elseif seg.going == left then
                rotation = math.pi/2
            else
                error("drawSnake(): undefined 'going' direction for head, tail or straight segment")
            end

            love.graphics.draw(img,
            (64 * seg.tileX) -32 + 64,
            (64 * seg.tileY) -32 + 64,
            rotation,
            self.imgScale,
            self.imgScale,
            img:getWidth()/2,
            img:getHeight()/2 )
        end
    end
end

-- determine the img for the body segment and it's type
function getBodyData(i, self)
        local img
        local type
        
        -- if front of body or end of body or tail, use head or tail imgs
        if i == 1 then
            img = Assets.getAsset("wHead1")
            type = "head"
        else if i == self.length then
            img = Assets.getAsset("wTail")
            type = "tail"
        else
            -- if it's the body, is it straight or bent?
            body = true

            -- forward, segment and behind all same direction, it's straight
            if self.body[i].going == self.body[i-1].going then
                img = Assets.getAsset("wBody")
                type = "straight"
            else
                img = Assets.getAsset("wBend")
                type = "bend"
            end
        end  
    end
    return type, img
end

-- reset the tile table's representation of the player
function Player:updateTile(Tile)

    -- Check for collision with self
    self:checkForCycle(Tile)

    -- clear the player's represenation in the tile
    Tile.clearID("Player")

    -- check for a collision on the head's position
    self:checkHeadCollision(Tile)

    -- update the tile representation of the player
    for i, seg in ipairs(self.body) do 
        Tile.setTile(seg.tileX, seg.tileY, "Player")
    end
end

-- if head is in the same tile as a segment, player is ded
function Player:checkForCycle()
    local head
    
    for i, seg in ipairs(self.body) do 
        
        if i == 1 then
            head = seg    
        else
            if head.tileX == seg.tileX and head.tileY == seg.tileY then
                self.alive = false
            end
        end
    end
end

-- A function for handling the issue of overlapping tank and head in the same tile. Used for detecting the weird edge case when the collider isn't in the current going direction.
function Player:checkHeadCollision(Tile)
    local next = Tile.getTile(self.body[1].tileX, self.body[1].tileY)
    
    if next.occupied then
        if next.id == "Tank" then
            self:addToWorm()
            Score.addScore(100)
            
            -- clear the tile with the tank
            Tile.setTile(self.body[1].tileX, self.body[1].tileY)
        else
            self.alive = false
        end
    end
end

-- This function looks to the tile that the worm would move ahead to in the next update. Used for out of bounds deaths or collision with tanks
function Player:checkCollision(Tile)
    local head = self.body[1]
    local next

    -- Used for clearing a tile with a tank
    local nextX
    local nextY

    -- Look at the tile ahead
    if (head.going == up and head.tileY-1 > -1) then

        nextY = head.tileY-1
        nextX = head.tileX

        next = Tile.getTile(head.tileX, head.tileY-1)
    
    elseif (head.going == down and head.tileY+1 < 11) then
        
        nextY = head.tileY+1
        nextX = head.tileX
        
        next = Tile.getTile(head.tileX, head.tileY+1)
    
    elseif (head.going == left and head.tileX - 1 > -1) then 
        nextY = head.tileY
        nextX = head.tileX - 1
        
        next = Tile.getTile(head.tileX - 1, head.tileY)
    
    elseif (head.going == right and head.tileX + 1 < 11) then
        nextY = head.tileY
        nextX = head.tileX + 1

        next = Tile.getTile(head.tileX + 1, head.tileY)
    else
        next = nil
    end 
    
    -- if next isnt assigned, then the player is dead (outside the playing area)
    if next == nil then
        self.alive = false

    elseif next.occupied then

        if next.id == "Tank" then
            self:addToWorm()
            Score.addScore(100)
            
            -- clear the tile with the tank
            Tile.setTile(nextX, nextY)
        elseif next.id == "Player" then
            -- placeholder if statement for a nop, handled in cycleCheck function
        else
            self.alive = false
        end
    end
end

-- Used in World module to determine if this entity should be removed from the list of entities
function Player:isAlive()
    return self.alive
end

-- To be used for handling collissions for death animation
function Player:onHit()
    self.hit = true
end

-- Function to call when hit in collision
function Player:checkHit()
    if (self.hit == true) then
        self.alive = false
    end
end

return Player