-- Libraries
local Object = require("lib/classic")
local Timer = require("lib/timer")
local Environment = require("src/systems/environment")

-- Modules
local Assets = require("src/assets")

local Slime = Object:extend()

-- A list of sprites that if iterated through has a blinking slime
local slimeSprites = {
    Assets.getAsset("rSlime0"),
    Assets.getAsset("rSlime1"),
    Assets.getAsset("rSlime2"),
    Assets.getAsset("rSlime3"),
    Assets.getAsset("rSlime4"),
    Assets.getAsset("rSlime3"),
    Assets.getAsset("rSlime2"),
    Assets.getAsset("rSlime1"), 
    Assets.getAsset("rSlime0")
}



function Slime:new(x, y, type)
    self.id = "Slime"
    self.x = x or 300
    self.y = y or 300

    self.happiness = 10
    self.hunger = 0
    self.growth = 0
    
    self.xScale = 1
    self.yScale = 1

    self.spriteSelection = 1
    self.img = slimeSprites[self.spriteSelection]
    self.blinkTime = 4 -- every 5 seconds randomly decide to blink
    self.blinkTimeStep = 0.1 -- every .1 second iterate through a frame
    self.blink = false
    
    -- Variables for random emoting to player
    self.emote = false
    self.emoteTime = 9
    self.emoteHappy = false
    self.emoteSad = false
    self.emoteMiddle = false

    -- What the slime likes depends on it's type
    self.type = type
    

    self.likesGravity = nil
    self:assignLikes()

    
    -- Blink logic with timers
    Timer.every(self.blinkTimeStep, 
                    function() 
                    
                    if (self.blink == true) then
                        self.spriteSelection = (self.spriteSelection + 1) % 9
                        
                        -- reset the blink state and return to staring sprite
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
                local emote = math.random( 0, 1)
                if (blink == 1) then self.blink = true end
                if (blink == 1) then self.emote = true end
            end
        end)
    -- end of blink logic


    Timer.every(self.emoteTime, 
    function ()
        if (self.emote == true) then
            if (self.happiness > 30) then
                self.emoteHappy = true
        
            elseif (25 <self.happiness and 55 > self.happiness) then
                self.emoteMiddle = true
            else 
                self.emoteSad = true
            end
            Timer.after(2, function() self.emoteHappy = false self.emoteSad = false self.emoteMiddle = false self.emote = false end)
        end
    end
    )
end

-- called to assign likes according to type
function Slime:assignLikes()
    local likeCheck = math.random(0, 1)

    if (likeCheck == 1) then
        self.likesGravity = 1
    else
        self.likesGravity = 0
    end
end

function Slime:update(dt)
    self:incHunger(dt)
    self:incHappiness(dt)
    self:incScale()
 
end

-- linear function for increasing hunger over time
function Slime:incHunger(dt) 
    self.hunger = math.min(self.hunger + dt/5, 100)
    self.hunger = math.max(self.hunger + dt/5, 0)

end

function Slime:incScale()
    self.growth = (self.happiness/100)- 0.2
end

function Slime:feed()
    self.hunger = self.hunger - 50
end

function Slime:incHappiness(dt)
    -- Cubic function that increases or decreases happiness evening out at 50
    self.happiness = self.happiness - (((self.hunger - 50)^3/5000)*dt)/100
    self.happiness = math.min(self.happiness, 100)
    self.happiness = math.max(self.happiness, 0)
    
    local heat, humidity, gravity = Environment.returnEnvStats()

    -- inc or dec happiness based on environment, type and randomness in gravity
    if (self.type == "Water") then
        self.happiness = self.happiness + (-heat*0.4 + humidity*0.4 + self.likesGravity*0.2)*dt/20
    
    elseif(self.type == "Fire") then
        self.happiness = self.happiness + (heat*0.4 - humidity*0.4 + self.likesGravity*0.2)*dt/20
    end
end

function Slime:returnStats()
    return self.happiness, self.hunger, self.growth
end

function Slime:draw()
    
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(self.img, self.x, self.y, 0, (self.xScale + self.growth), (self.yScale + self.growth), self.img:getWidth()/2, self.img:getHeight()/2)
    
    -- check if an emote is to be drawn
    if (self.emoteSad == true) then
        love.graphics.draw(Assets.getAsset("sadEmote"), self.x+40, self.y-40)
    
    elseif(self.emoteMiddle == true) then
        love.graphics.draw(Assets.getAsset("middleEmote"), self.x+40, self.y-40)    
    
    elseif (self.emoteHappy == true) then  
        love.graphics.draw(Assets.getAsset("happyEmote"), self.x+40, self.y-40)
    end

end



return Slime