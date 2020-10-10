local Object = require("lib/classic")

local Test = Object:extend()

function Test:new()
    self.x = 42
    self.y = 42
end

return Test