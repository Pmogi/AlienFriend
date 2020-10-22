local Assets = {}

local assets = {}

-- Blue Slime
assets["slime0"] = love.graphics.newImage("assets/slime/slime0000.png")
assets["slime1"] = love.graphics.newImage("assets/slime/slime0001.png")
assets["slime2"] = love.graphics.newImage("assets/slime/slime0002.png")
assets["slime3"] = love.graphics.newImage("assets/slime/slime0003.png")
assets["slime4"] = love.graphics.newImage("assets/slime/slime0004.png")

-- Red Slime
assets["rSlime0"] = love.graphics.newImage("assets/fireSlime/fireSlime0000.png")
assets["rSlime1"] = love.graphics.newImage("assets/fireSlime/fireSlime0001.png")
assets["rSlime2"] = love.graphics.newImage("assets/fireSlime/fireSlime0002.png")
assets["rSlime3"] = love.graphics.newImage("assets/fireSlime/fireSlime0003.png")
assets["rSlime4"] = love.graphics.newImage("assets/fireSlime/fireSlime0004.png")

-- Emotion Bubbles
assets["happyEmote"] = love.graphics.newImage("Assets/speechBubbleHeart1.png")
assets["sadEmote"] = love.graphics.newImage("Assets/speechBubbleUnhappy1.png")
assets["middleEmote"] = love.graphics.newImage("Assets/speechBubbleMiddleMood0000.png")

-- Tokens
assets["token1"] = love.graphics.newImage("Assets/pickUpToken.png")
assets["token2"] = love.graphics.newImage("Assets/pickUpTokenAlt1.png")
assets["token3"] = love.graphics.newImage("Assets/pickUpTokenAlt2.png")

-- Heart for particle effects
assets["heart"] = love.graphics.newImage("Assets/Heart1.png")

-- BG Slime
-- assets["gridBG"] = love.graphics.newImage("assets/grid_bg.png")
-- assets["ocean"] = love.graphics.newImage("assets/OceanExtended.png")
assets["bg"] = love.graphics.newImage("assets/bg.png")

-- Audio
assets["goodSound"] = love.audio.newSource("Assets/audio/good.ogg", "static")
assets["badSound"]  = love.audio.newSource("Assets/audio/bad.ogg", "static")
assets["bgm"] = love.audio.newSource("Assets/audio/DOSY.ogg", "static")
assets["bgm"]:setVolume(0.3)
assets["bgm"]:setLooping(true)

function Assets.getAsset(key)
    return assets[key]
end


-- For loading the assets of the blue or red slime
function Assets.loadBlueSlime()

end

function Assets.loadRedSlime()

end

return Assets