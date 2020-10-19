-- library
local Timer = require("lib/timer")
local Suit  = require("lib/suit")


local Menu = {}
local menuActive

function Menu.new()
    menuActive = true
end

function Menu.update(dt)
    if Suit.Button("Start Game", love.graphics.getWidth()/2-50, love.graphics.getHeight()/1.25, 100, 50).hit then
        return true -- transition to slimePlay state
    end

end

function Menu.draw()
    Suit.draw()
end


return Menu