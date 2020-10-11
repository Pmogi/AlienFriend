local Assets = {}

local assets = {}

-- Slime, and blink frames
assets["slime0"] = love.graphics.newImage("assets/slime/slime0000.png")
assets["slime1"] = love.graphics.newImage("assets/slime/slime0001.png")
assets["slime2"] = love.graphics.newImage("assets/slime/slime0002.png")
assets["slime3"] = love.graphics.newImage("assets/slime/slime0003.png")
assets["slime4"] = love.graphics.newImage("assets/slime/slime0004.png")

assets["happyEmote"] = love.graphics.newImage("Assets/speechBubbleHeart1.png")
assets["sadEmote"] = love.graphics.newImage("Assets/speechBubbleUnhappy1.png")

-- BG Slime
assets["gridBG"] = love.graphics.newImage("assets/grid_bg.png")
assets["ocean"] = love.graphics.newImage("assets/Ocean.png")

function Assets.getAsset(key)
    return assets[key]
end

return Assets