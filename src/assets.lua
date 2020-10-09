local Assets = {}

local assets = {}


-- Worm Tiles
assets["wBody"] = love.graphics.newImage('assets/wormBody.png')
assets["wBend"] = love.graphics.newImage('assets/wormBend.png')
assets["wHead1"] = love.graphics.newImage('assets/wormHead1.png')
assets["wHead2"] = love.graphics.newImage('assets/wormHead2.png')
assets["wTail"] = love.graphics.newImage('assets/wormTail.png')

-- Tank Tile and parachute
assets["tank1"] = love.graphics.newImage('assets/tank.png')
assets["parachute"] = love.graphics.newImage('assets/parachute.png')

-- background
assets["grassBG"] = love.graphics.newImage('assets/grass.png')
assets["grassBG"]:setWrap("repeat", "repeat")

assets["wall"] = love.graphics.newImage('assets/wall.png')

-- wraps around the whole screen, later make it so it's only the playing field
assets["grassBgQuad"] = love.graphics.newQuad(0, 0,
                        love.graphics.getWidth(), love.graphics.getHeight(),
                        64, 64)


-- audio!
assets['music'] = love.audio.newSource('assets/worm.ogg', 'stream')
assets['music']:setLooping(true)

assets['nom'] = love.audio.newSource('assets/NOM.ogg', 'static')
assets['nom2'] = love.audio.newSource('assets/NOM2.ogg', 'static')

-- font
assets['font'] = love.graphics.newFont("assets/ARCADECLASSIC.TTF")



function Assets.getAsset(key)
    return assets[key]
end

return Assets