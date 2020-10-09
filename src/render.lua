local Assets = require("src/assets")
local Score = require("src/systems/score") -- for drawing score

local Render = {}

function Render.draw(World)
    -- base grass background
    love.graphics.draw(Assets.getAsset("grassBG"),
                       Assets.getAsset("grassBgQuad"),
                       0,0,0,1,1)

    World.draw()
    drawWall()
end

function drawWall() 
    local img = Assets.getAsset("wall")
    
    -- right wall
    for i=1,10 do 
        love.graphics.draw(Assets.getAsset("wall"),
            (64 * 10) +32,
            (64 * i)  +32,
            0,
            1,
            1,
            img:getWidth()/2,
            img:getHeight()/2 )
    end


    -- bottom wall
    for i=1,10 do 
        love.graphics.draw(Assets.getAsset("wall"),
            (64 * i)  +32,
            (64 * 10) +32,
            math.pi/2,
            1,
            1,
            img:getWidth()/2,
            img:getHeight()/2 )
    end
    
    for i=1,10 do 
        love.graphics.draw(Assets.getAsset("wall"),
            (64 * 0) +32,
            (64 * i) +32,
            math.pi,
            1,
            1,
            img:getWidth()/2,
            img:getHeight()/2 )
    end
    
    for i=1,10 do 
        love.graphics.draw(Assets.getAsset("wall"),
            (64 * i) +32,
            (64 * 0) +32,
            math.pi*(3/2),
            1,
            1,
            img:getWidth()/2,
            img:getHeight()/2 )
    end

    love.graphics.draw(Assets.getAsset("wall"),
             32,
            32,
            math.pi*(3/2),
            1,
            1,
            img:getWidth()/2,
            img:getHeight()/2 )

    

end

function drawGrid() 
    for i=1, 9 do 
        love.graphics.line(0, i*64, love.graphics.getWidth(), i*64)
        love.graphics.line(i*64, 0, i*64, love.graphics.getHeight())
    end
end

function Render.drawScore()
    love.graphics.setFont(Assets.getAsset("font"))
    
    local score, hiScore, multi, multiCount = Score.getScores()
    local scoreString = string.format("Score %d\nHiScore %d\nMultiplier %d %d", score, hiScore, multi, multiCount)

    love.graphics.print(scoreString, 0, 0, 0, 1.5, 1.5)
end

function Render.menu()
    love.graphics.setFont(Assets.getAsset("font"))
    love.graphics.print("Worm off the String", love.graphics.getWidth()/2-55, love.graphics.getHeight()/2-125, 0 , 1.25, 1.25)

    love.graphics.print("Move with the arrow keys", love.graphics.getWidth()/2-50, love.graphics.getHeight()/2-105)
    love.graphics.print("If ya crash your worm press E to start a new game", love.graphics.getWidth()/2-125, love.graphics.getHeight()/2-85)
    love.graphics.print("Press W to start the game", love.graphics.getWidth()/2-50, love.graphics.getHeight()/2-65)
    love.graphics.print("Press Esc to exit the game", love.graphics.getWidth()/2-50, love.graphics.getHeight()/2-45)

    drawWall()
end

return Render