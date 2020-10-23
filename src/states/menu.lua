-- library
local Timer = require("lib/timer")
local Suit  = require("lib/suit")
local Assets = require("src/assets")

local Menu = {}
local menuActive
local img = {}

function Menu.new()
    menuActive = true
    img[1] = Assets.getAsset("gridBG")
    img[2] = Assets.getAsset("menuTitle")
    img[3] = Assets.getAsset("menuSubtitle")
    menutimer = Timer.new()
    mmt = {pos = {x = 72, y = -200}}
    mmst = {pos = {x = 82, y = 900}}
    Timer.tween(2,mmt, {pos = {y = 250}}, 'out-in-bounce')
    Timer.tween(4,mmst, {pos = {y = 370}}, 'out-in-bounce')
end

function Menu.update(dt)
    -- transition to slimePlay state
    if Suit.Button("Start Game", love.graphics.getWidth()/2-50, love.graphics.getHeight()/1.25, 100, 50).hit then
        return true 
    end
end

function Menu.draw()
    love.graphics.draw(img[1],0,0,0,720/800,720/600)
    love.graphics.draw(img[2], mmt.pos.x, mmt.pos.y,0,0.9,0.9)
    love.graphics.draw(img[3], mmst.pos.x, mmst.pos.y,0,0.8,0.8)
    Suit.draw()
end


return Menu