-- library
local Timer = require("lib/timer")


-- Module
local Render = require("src/render")

local Menu = {}
local menuActive

function Menu.new()
    menuActive = true
end

function Menu.update(dt)
    if (love.keyboard.isDown('escape')) then
        love.event.quit()
    end

    if (love.keyboard.isDown('w') and menuActive == true) then
        menuActive = false
    end
end

function Menu.returnMenuActivity()
    return menuActive
end

function Menu.draw()
    Render.menu()
end


return Menu