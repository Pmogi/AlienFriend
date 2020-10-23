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

local particleHeart = Assets.getAsset("heart")
local particleEffect -- set in slime:new()

function Slime:new(x, y, type)
    self.id = "Slime"
    self.x = x or 300
    self.y = y or 300

    self.happiness = 10
    self.hunger = 0
    self.growth = 0
    
    self.xScale = 1
    self.yScale = 1

    -- select which image of thes slime to draw
    self.spriteSelection = 1
    self.img = slimeSprites[self.spriteSelection]

    -- Blinking logic
    self.blinkTime = 4 -- every 5 seconds randomly decide to blink
    self.blinkTimeStep = 0.1 -- every .1 second iterate through a frame of the blink
    self.blink = false
    
    -- Variables for random emoting to player
    self.emote = false
    self.emoteTime = 9
    self.emoteHappy = false
    self.emoteSad = false
    self.emoteMiddle = false

    -- What the slime likes depends on it's type
    self.type = type
    
    -- Timer value on petting slime
    self.canPet = true

    -- gravity liking or disliking is randomly set
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
    
    -- Randomly decide to blink or emote every 5 seconds 
    Timer.every(self.blinkTime,
        function()
            
            if (self.blink == false) then
                local blink = math.random( 0, 1)
                local emote = math.random( 0, 1)
                if (blink == 1) then self.blink = true end
                if (emote == 1) then self.emote = true end
            end
        end)
    -- end of blink logic

    -- Choose the emote based on happiness value
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


    -- set up particle system
    particleEffect = love.graphics.newParticleSystem(particleHeart, 20)
    particleEffect:setParticleLifetime(0.9)
    particleEffect:setEmissionRate(8)
    particleEffect:setSizes(1)
    particleEffect:setRotation(0, math.pi/4)
    particleEffect:setPosition(self.x, self.y-10)
    particleEffect:setSpeed(100, 100)
    particleEffect:setDirection(-math.pi/2)
    particleEffect:setSpread(math.pi/8)
    particleEffect:pause()

    particleEffect:setColors(255, 255, 255, 200,  255, 0, 0, 150,   0, 0, 0 ,0) -- fade out over time
    
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
    self:checkPet()
    particleEffect:update(dt)
 
end

-- linear function for increasing hunger over time
function Slime:incHunger(dt) 
    self.hunger = math.min(self.hunger + dt/2, 100)
    self.hunger = math.max(self.hunger + dt/5, 0)

end

function Slime:incScale()
    self.growth = (self.happiness/100)-0.3
end

function Slime:feed()
    self.hunger = self.hunger - 5
end


-- increment the happiness of the slime based on hunger, type, and environment
function Slime:incHappiness(dt)
    -- Cubic function that increases or decreases happiness evening out at 50
    self.happiness = self.happiness - (((self.hunger - 50)^3/5000)*dt)/300
    self.happiness = math.min(self.happiness, 100)
    self.happiness = math.max(self.happiness, 0)
    
    local heat, humidity, gravity = Environment.returnEnvStats()

    -- inc or dec happiness based on environment, type and randomness in gravity
    if (self.type == "Water") then
        self.happiness = self.happiness + (-heat*0.2 + humidity*0.05 + self.likesGravity*0.2)*dt/30
    
    elseif(self.type == "Fire") then
        self.happiness = self.happiness + (heat*0.05 - humidity*0.2 + self.likesGravity*0.2)*dt/30
    end
end


-- return stats for drawing text
function Slime:returnStats()
    return self.happiness, self.hunger, self.growth
end


function Slime:draw()
    love.graphics.draw(particleEffect)
    
    -- shadow
    love.graphics.setColor(0.5, 0.5, 0.5)
    love.graphics.ellipse("fill", self.x, self.y+25, 25*5*self.growth, 5)

    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(self.img, self.x, self.y, 0, (self.xScale + self.growth), (self.yScale + self.growth), self.img:getWidth()/2, self.img:getHeight()/2)
    
    
    -- check if an emote is to be drawn
    if (self.emoteSad == true) then
        love.graphics.draw(Assets.getAsset("sadEmote"), self.x+40, self.y-40)
    
    elseif(self.emoteMiddle == true) then
        love.graphics.draw(Assets.getAsset("middleEmote"), self.x+40, self.y-40)    
        self:emitHeart()
    
    elseif (self.emoteHappy == true) then  
        love.graphics.draw(Assets.getAsset("happyEmote"), self.x+40, self.y-40)
        self:emitHeart()
    end


    

    -- love.graphics.rectangle("line", self.x-self.img:getWidth()/2, self.y-self.img:getHeight()/2, self.img:getWidth(), self.img:getHeight())


    
end


-- check and initiate particle drawing
function Slime:emitHeart()
    particleEffect:setPosition(self.x, self.y)
    particleEffect:start()
    Timer.after(1, function() particleEffect:pause() end)

end

-- essential feature of petting slime
function Slime:checkPet()
    
    local xPos =  love.mouse.getX()
    local yPos =  love.mouse.getY()

    local slimeX = self.x-self.img:getWidth()/2
    local slimeY = self.y-self.img:getHeight()/2

        -- check if cursor is between slime area
    if (xPos > slimeX and xPos < slimeX+self.img:getWidth() and
            yPos > slimeY and yPos < slimeY + self.img:getHeight()) then
            
        if (self.canPet and love.mouse.isDown(1)) then
            --emit heart
            self.happiness = self.happiness + 0.5
            self.canPet = false -- limit the petting
            Timer.after(3, function() self.canPet = true end) -- reset after 3 seconds
            self:emitHeart()
        end        
    end
end

return Slime