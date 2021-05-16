local Class = require "Libs.Class"
local Vector = require "Engine.Vector"

local Tilemap = Class()

function Tilemap:init(sr, size, indent)
    self.sr = sr
    self.size = size or Vector()
    self.indent = indent or Vector()
end

function Tilemap:draw(map, offset)
    o = offset or Vector()

    for i = 1, #map do 
        for j = 1, #map[i] do 
            if map[i][j] ~= 0 then 
                local x = (j - 1) * (self.size.x * self.sr.scale) + (j - 1) * (self.indent.x * self.sr.scale)
                local y = (i - 1) * (self.size.y * self.sr.scale) + (i - 1) * (self.indent.y * self.sr.scale)

                self.sr:draw(map[i][j], x + o.x, y + o.y)
            end
        end
    end
end

return Tilemap