function love.conf(t)
    t.identity = nil
    t.console = false
    t.window.title = "Game"
    t.window.icon = nil
    t.window.width = 704    
    t.window.height = 704
    
    t.modules.audio = true
    t.modules.event = true
    t.modules.graphics = true
    t.modules.image = true
    t.modules.joystick = false
    t.modules.keyboard = true
    t.modules.math = true
    t.modules.mouse = true
    t.modules.physics = true
    t.modules.sound = true
    t.modules.system = true
    t.modules.timer = true
    t.modules.window = true
end