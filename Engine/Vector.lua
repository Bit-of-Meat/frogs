Class = require "Libs.Class"

Vector = Class()

function Vector:init(x, y)
    self.x = x or 0
    self.y = y or 0
end

function Vector:__add(vec)
    return Vector(self.x + vec.x, self.y + vec.y)
end

return Vector