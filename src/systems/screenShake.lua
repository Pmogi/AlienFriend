-- Module to encapsulate shaking the game field
-- Adapted from https://love2d.org/forums/viewtopic.php?t=81637

local ScreenShake = {}

local t, shakeDuration, shakeMagnitude = 0, -1, 0

-- initiates a screenShake
function ScreenShake.startShake(duration, magnitude) 
    t, shakeDuration, shakeMagnitude = 0, duration or 0.15, magnitude or 1.5
end

-- a timer method for updating duration
function ScreenShake.update(dt)
    if t < shakeDuration then 
        t = t + dt
    end
end

function ScreenShake.draw()
    if t < shakeDuration then
        local dx = love.math.random(-shakeMagnitude, shakeMagnitude)
        local dy = love.math.random(-shakeMagnitude, shakeMagnitude)

        -- shift screen by dx, dy this love.draw call
        love.graphics.translate(dx, dy)
    end
end

-- during a love.draw call, the translation may want to return to 0, 0
function ScreenShake.resetTranslation()
    love.graphics.translate(0, 0)
end 

return ScreenShake

