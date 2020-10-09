-- Lib
local Timer = require("lib/timer")

-- Modules, game states
local Game = require("src/states/game")
local Menu = require("src/states/menu")

local gameState
local PlayGame = 1
local PlayMenu = 0

function love.load()
    math.randomseed(os.time())
    Menu.new()
    gameState = PlayMenu
    

end

function love.draw( )
    if (gameState == PlayMenu) then
        Menu.draw()
    else
        Game.draw()
    end
end

function love.update( dt )
    Timer.update(dt)

    if (gameState == PlayMenu) then
        -- check for update from player on menu
        Menu.update(dt)

        if (Menu.returnMenuActivity() == false) then
            gameState = PlayGame
            startGame()
        end

    -- if it's not in the menu it's the game
    else 
        Game.update(dt) 
    end
end

function startGame()
    Game.new()
    gameState = PlayGame
end