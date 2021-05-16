local SpriteRenderer = require "Engine.SpriteRenderer"
local Vector = require "Engine.Vector"
local Class = require "Libs.Class"
local Queue = require "Libs.Queue"

local Frog = Class()

function Frog:init(pos, scale)
    self.actions = Queue.new()

    self.renderer = SpriteRenderer({
        image = "Assets/Frog.png",
        width = 91,
        height = 91
    }, pos, Vector(0, -80), nil, scale)
    self.position = self.renderer.position
    self.renderer:createAnimation("Croak", {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14}, 1)
    self.renderer:createAnimation("Jump", {15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30}, 1)
    self.renderer:createAnimation("Dies", {31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43}, 1)

    self.directions = {
        right = love.math.newBezierCurve({
            0, 0,
            16, -15,
            32, 0
        }),
        left = love.math.newBezierCurve({
            0, 0,
            -16, -15,
            -32, 0
        }),
        up = love.math.newBezierCurve({
            0, 0,
            0, -30,
            0, -15
        }),
        down = love.math.newBezierCurve({
            0, 0,
            0, -15,
            0, 15
        })
    }

    for _, dir in pairs(self.directions) do
        dir:scale(scale)
    end
end

function Frog:move(dir)
    Queue.pushleft(self.actions, dir)
end

function Frog:update(dt)
    if not self.direction and not Queue.empty(self.actions) then
        self.direction = Queue.popright(self.actions)
    end

    if not self.renderer.currentAnimation and self.directions[self.direction] then
        self.renderer:playAnimation("Jump", function ()
            self.renderer.currentAnimation = nil
            self.position = self.position + Vector(self.directions[self.direction]:evaluate(1))
            self.direction = nil
        end)
    end

    if self.directions[self.direction] then
        self.renderer.position = self.position + Vector(self.directions[self.direction]:evaluate(self.renderer.currentAnimation.currentTime / self.renderer.currentAnimation.duration))
    end

    self.renderer:update(dt)
end

function Frog:draw()
    self.renderer:draw()
end

return Frog