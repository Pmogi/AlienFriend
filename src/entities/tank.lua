local Object = require("lib/classic")
local Timer = require("lib/timer")

local Assets = require("src/assets")


local Tank = Object:extend()

-- for direction of drawing rotation
local down = 2
local right = 1
local left = 3
local up = 0 

function Tank:new(x, y, Tile)
    self.id = "Tank"
    self.tileX = x
    self.tileY = y
    
    self.img = Assets.getAsset("tank1")
    self.going = math.random(0, 3)
    
    self.alive = true
    
    -- can get hurt
    self.hurt = false

    self.parachute = Assets.getAsset("parachute")
    self.parachuteScale = 1.5
    self.dropping = true
    Timer.tween(0.75, self, {parachuteScale = 0}, 'in-out-quad')
    Timer.after(0.75, function() self.hurt = true end )
end

-- Used when Entity is added to entity list in World module
function Tank:setTile(Tile)
    local x, y = Tile.getRandomFreeTile()
    
    self.tileX = x 
    self.tileY = y

    Tile.setTile(self.tileX, self.tileY, self.id)
end

function Tank:draw()
    local rotation 
    
    -- random direction of tank sprite
    if (self.going == up) then
        rotation = 0
    elseif (self.going == down) then
        rotation = math.pi
    elseif self.going == right  then
        rotation = math.pi/2
    elseif self.going == left then
        rotation = math.pi*3/2
    end

    -- tank
    love.graphics.draw(self.img,
            (64 * self.tileX) -32 + 64,
            (64 * self.tileY) -32 + 64,
            rotation,
            self.imgScale,
            self.imgScale,
            self.img:getWidth()/2,
            self.img:getHeight()/2 )


    -- parachute
    love.graphics.draw(self.parachute, 
        (64 * self.tileX) -32 + 64,
        (64 * self.tileY) -32 + 64,
        rotation,
        self.parachuteScale,
        self.parachuteScale,
        self.img:getWidth()/2,
        self.img:getHeight()/2 )

        -- top-down
    


    love.graphics.setColor(1, 1, 1)
    
   

end

-- if the tile has been removed and can be hurt, then kill tank
function Tank:update(dt, Tile)
    local tileState = Tile.getTile(self.tileX, self.tileY)

    if (tileState["occupied"] == false or tileState["id"] == "Player") then
       self.alive = false
    end
end


function Tank:isAlive()
    return self.alive
end

return Tank