local Slime = require("src/entities/slime")

local Pet = {}

local slime = Slime()

function Pet.new()

end

function Pet.draw()
    local happy, hungry, growth = slime:returnStats()
    love.graphics.print( "Happiness: " ..  happy .. 
                         "\nHunger: " .. hungry ..
                        '\nGrowth: ' .. growth)
    slime:draw(growth)
end

function Pet.update(dt)
    slime:update(dt)
    
end

return Pet