-- Lib
local Timer = require("lib/timer")

-- Modules, game states
local Menu = require("src/states/menu")
local Game = require("src/states/game")
local Pet  = require("src/states/pet")
local Assets = require("src/assets")

-- local Board = require("src/gameboard")


local gameState
local PlayGame = 0
local PlayMenu = 1
local PlaySlime = 2

local canSwitch

local gravityFactor = 1 -- increase or decrease gravity with this variable

local world
local objects = {}


function love.load()
    Game.new()
    Pet.new()
    Menu.new()

    gameState = PlayMenu
    canSwitch = true
    math.randomseed(os.time())

    
    -- start playing the bg
    Assets.getAsset("bgm"):play()


end

function love.draw()
    
    if (gameState == PlayGame) then
    
        Game.draw()
    
    elseif (gameState == PlaySlime) then

        Pet.draw()
    
    elseif (gameState == PlayMenu) then
        
        Menu.draw()
    end
end

function love.update(dt)
    Timer.update(dt)

    -- Switch states
    if (love.keyboard.isDown("space") and canSwitch) then
        switchState()
    end

    if (gameState == PlayGame) then
       -- run Game.update, and if a state switch was requested, call switch method
        if Game.update(dt) then
            switchState()
       end

    elseif (gameState == PlayMenu) then
        local switch = Menu.update(dt)
        if switch == true then
            gameState = PlaySlime
        end
    end
    
    -- run Pet if not 
    if (gameState == PlaySlime or gameState == PlayGame) then
        -- run Game.update, and if a state switch was requested, call switch method
        if Pet.update(dt) then
            switchState()
        end
    end
    
end

function switchState() 
    canSwitch = false
    Timer.after(1, function() canSwitch = true end)
    
    if (gameState == PlayGame) then
        gameState = PlaySlime
    
    elseif (gameState == PlaySlime) then
        gameState = PlayGame
    end
end

