local Assets = {}

local assets = {}

-- Blue Slime
assets["slime0"] = love.graphics.newImage("assets/slime/slime0000.png")
assets["slime1"] = love.graphics.newImage("assets/slime/slime0001.png")
assets["slime2"] = love.graphics.newImage("assets/slime/slime0002.png")
assets["slime3"] = love.graphics.newImage("assets/slime/slime0003.png")
assets["slime4"] = love.graphics.newImage("assets/slime/slime0004.png")

-- Emotion Bubbles
assets["happyEmote"] = love.graphics.newImage("Assets/speechBubbleHeart1.png")
assets["sadEmote"] = love.graphics.newImage("Assets/speechBubbleUnhappy1.png")

assets["token"] = love.graphics.newImage("Assets/pickUpToken.png")

-- BG Slime
assets["gridBG"] = love.graphics.newImage("assets/grid_bg.png")
assets["ocean"] = love.graphics.newImage("assets/Ocean.png")

function Assets.getAsset(key)
    return assets[key]
end

return Assets