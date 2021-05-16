local SpriteRenderer = require "Engine.SpriteRenderer"
local Vector = require "Engine.Vector"
local Class = require "Libs.Class"
local Queue = require "Libs.Queue"
local SceneManager = require "Engine.SceneManager"

local Frog = Class()

function Frog:init(pos, size, scale, map)
    self.actions = Queue.new()
    self.map = map

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
            size.x / 2, -size.y,
            size.x, 0
        }),
        left = love.math.newBezierCurve({
            0, 0,
            -(size.x / 2), -size.y,
            -size.x, 0
        }),
        up = love.math.newBezierCurve({
            0, 0,
            0, -(size.y * 2),
            0, -size.y
        }),
        down = love.math.newBezierCurve({
            0, 0,
            0, -size.y,
            0, size.y
        })
    }

    self.pos = {
        right = Vector(1, 0),
        left = Vector(-1, 0),
        up = Vector(0, -1),
        down = Vector(0, 1)
    }

    self.gridPos = Vector(1, 1)

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
        if self.direction == "left" then
            self.renderer.flipX = true
        elseif self.direction == "right" then
            self.renderer.flipX = false
        end
        
        self.renderer:playAnimation("Jump", function ()
            self.renderer.currentAnimation = nil
            self.position = self.position + Vector(self.directions[self.direction]:evaluate(1))
            self.gridPos = self.gridPos + self.pos[self.direction]
            self.direction = nil

            ok = false

            if self.gridPos.y > 0 and self.gridPos.y <= #self.map then
                if self.gridPos.x > 0 and self.gridPos.x <= #self.map[self.gridPos.y] then
                    if self.map[self.gridPos.y][self.gridPos.x] == 1 then
                        ok = true
                    end
                end
            end

            if not ok then
                self.renderer:playAnimation("Dies", function()
                    SceneManager.load("Scenes/Game")
                end)
            end
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