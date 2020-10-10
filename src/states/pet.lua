local Slime = require("src/entities/slime")

local Pet = {}

local petStats = {
    Happy  = 50,
    Hungry = 0,
    Growth = 0
}

local slime = Slime()

function Pet.new()

end

function Pet.draw()
    slime:draw()
end

function Pet.update(dt)
    slime:update(dt)
end

return Pet