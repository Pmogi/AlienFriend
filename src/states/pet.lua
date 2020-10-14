local Slime = require("src/entities/slime")
local Assets = require("src/assets")

local Pet = {}

local slime = Slime(300, 500)

function Pet.new()

end

function Pet.draw()
    love.graphics.draw(Assets.getAsset("ocean"), 20, -50, 0)

    love.graphics.rectangle("fill", 0, love.graphics.getHeight()-50, love.graphics.getWidth(), 50)

    local happy, hungry, growth = slime:returnStats()

    love.graphics.print( "Happiness: " ..  happy .. 
                         "\nHunger: " .. hungry ..
                        '\nGrowth: ' .. growth)
    slime:draw()
end

function Pet.update(dt)
    slime:update(dt)
    
end

return Pet