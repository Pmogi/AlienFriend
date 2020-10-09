-- Libraries
local Timer = require("lib/timer")

-- Modules
local Assets = require("src/assets")
local World = require("src/world")
local Player = require("src/entities/player")
local Render = require("src/render")
local Tank = require("src/entities/tank")
local ScreenShake = require("src/systems/screenShake")
local Score = require("src/systems/score")
local Tile = require("src/systems/tile")


local Game = {}

local player = Player()
-- local tank = Tank(3, 3)

-- Used for timing the creation of test worms
local newWorm = true

-- for a fade-in effect when starting the game
local musicVolume = 0
local music


function Game.new()
    -- create player entity for World to start the game
    World.new()
    Score.initScore()

    music = Assets.getAsset("music")
    love.audio.setVolume(0.25)
    love.audio.play(music)
 
    -- add the player
    World.addEntity(player)

    Timer.every(3, function() World.addEntity(Tank()) end)

end 

function Game.draw()
    
    ScreenShake.draw()
    Render.draw(World)    
    ScreenShake.resetTranslation()
    Render.drawScore()

end

function Game.update(dt)
    World.update(dt)
    ScreenShake.update(dt)
    Score.checkHighScore()
    Score.decMultiplier(dt)

    -- end game
    if (love.keyboard.isDown('escape')) then
        love.event.quit()
    end

    -- test for extending worm function
    if (love.keyboard.isDown('w') and newWorm == true) then
        player:addToWorm()
        newWorm = false
        Timer.after(1, function() newWorm = true end)
    end

    
    -- for making a new worm for the player if they died
    if (love.keyboard.isDown('e') and newWorm == true) then
        player = Player()
        World.addEntity(player)
        newWorm = false
        Timer.after(1, function() newWorm = true end)
        Score.resetScore()
        Tile.clearID("Tank") -- clear the board
    end

end

return Game