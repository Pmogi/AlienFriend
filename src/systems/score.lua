local Score = {}

local score, highScore

-- Used for a time-limited multiplier
local multiplier, multiplierCounter, multiplierTimeOut

function Score.initScore()
    score = 0
    highScore = 0
    multiplier = 1
    multiplierTimeOut = 2.8
    multiplierCounter = 0
end

function Score.addScore(x)
    score = score + (x*multiplier)
    incMultiplier()
end

function Score.getScores()
    return score, highScore, multiplier, multiplierCounter*100
end

function Score.resetScore()
    score = 0
    multiplier = 1
    multiplierCounter = 0

end

function Score.checkHighScore()
    if score > highScore then
        highScore = score
    end
end

-- if the player gets to the tank in time, inc the multiplier
function incMultiplier()
    multiplier = math.min(multiplier * 2, 32)
    multiplierCounter = 0
end

-- if the player can't get to the next tank in time, dec the multiplier
function Score.decMultiplier(dt)
    if (multiplierCounter >= multiplierTimeOut) then
        multiplier = math.max(1, multiplier / 2)
        multiplierCounter = 0
    else
        multiplierCounter = multiplierCounter + dt
    end

end

return Score