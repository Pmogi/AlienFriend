-- Libraries
local Object = require("lib/classic")
local Timer = require("lib/timer")

-- Modules
local Assets = require("src/assets")

local Slime = Object:extend()

-- A list of sprites that if iterated through has a blinking slime
local slimeSprites = {
    Assets.getAsset("slime0"),
    Assets.getAsset("slime1"),
    Assets.getAsset("slime2"),
    Assets.getAsset("slime3"),
    Assets.getAsset("slime4"),
    Assets.getAsset("slime3"),
    Assets.getAsset("slime2"),
    Assets.getAsset("slime1"),
    Assets.getAsset("slime0")
}


function Slime:new(x, y)
    self.id = "Slime"
    self.x = x or 300
    self.y = y or 300

    self.happiness = 0.5
    self.hunger = 0
    self.growth = 0.1
    
    self.type = "Water"
    
    self.xScale = 1
    self.yScale = 1

    self.spriteSelection = 1
    self.img = slimeSprites[self.spriteSelection]
    self.blinkTime = 5 -- every 5 seconds randomly decide to blink
    self.blinkTimeStep = 0.1 -- every .1 second iterate through a frame
    self.blink = true
    
    -- Blink logic with timers
    Timer.every(self.blinkTimeStep, 
                    function() 
                    
                    if (self.blink == true) then
                        self.spriteSelection = (self.spriteSelection + 1) % 9
                        if self.spriteSelection == 0 then
                            self.spriteSelection = 1
                            self.blink = false
                        end
        
                        self.img = slimeSprites[self.spriteSelection]
                    end
                end
    )
    
    -- Randomly decide to blink every 5 seconds 
    Timer.every(self.blinkTime,
        function()
            
            if (self.blink == false) then
                local blink = math.random( 0, 1)
                if (blink == 1) then self.blink = true end
            end
        end) 

    -- end of blink logic
end

function Slime:update(dt)
    self:incHunger(dt) 

end

-- function for increasing hunger over time
function Slime:incHunger(dt) 
    self.hunger = self.hunger + dt/10
end

function Slime:modifyHappiness()

end

function Slime:returnStats()
    return self.happiness, self.hunger, self.growth
end

function Slime:draw(growth)
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(self.img, self.x, self.y, 0, (self.xScale + self.growth), (self.yScale + self.growth), self.img:getWidth()/2, self.img:getHeight()/2)
end



return Slime