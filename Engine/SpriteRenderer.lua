local Class = require "Libs.Class"
local Vector = require "Engine.Vector"
local Animation = require "Engine.Animation"

local SpriteRenderer = Class()

function SpriteRenderer:init(imageData, position, pivot, rotation, scale)
    if type(imageData) == "string" then
        self.texture = love.graphics.newImage(imageData)

        self.width, self.height = self.texture:getDimensions()
    else
        self.texture = love.graphics.newImage(imageData.image)
        self.sprites = self:split(imageData.width, imageData.height)
        
        self.width = imageData.width
        self.height = imageData.height
    end

    self.position = position or Vector()
    self.pivot = pivot or Vector()

    self.rotation = rotation or 0
    self.scale = scale or 1

    self.animations = {}
end

function SpriteRenderer:split(width, height)
    sprites = {}
    for y = 0, self.texture:getHeight() - height, height do
        for x = 0, self.texture:getWidth() - width, width do
            table.insert(
                sprites,
                love.graphics.newQuad(x, y, width, height, self.texture:getDimensions())
            )
        end
    end
    return sprites
end

function SpriteRenderer:createAnimation(name, frames, duration)
    self.animations[name] = Animation(frames, duration or 1)
end

function SpriteRenderer:playAnimation(name, callback)
    self.currentAnimation = self.animations[name]
    self.currentAnimation.currentTime = 0
    if callback then
        self.currentAnimation.onEnd = callback
    end
end

function SpriteRenderer:update(dt)
    if self.currentAnimation then
        self.currentAnimation:update(dt)
    end
end

function SpriteRenderer:draw(spriteNumber, x, y)
    if self.currentAnimation then
        spriteNumber = self.currentAnimation:getFrame()
    end

    if self.sprites then
        love.graphics.draw(
            self.texture, self.sprites[spriteNumber or 1],
            (x or self.position.x) - (self.width * self.scale / 2) + self.pivot.x,
            (y or self.position.y) - (self.height * self.scale / 2) + self.pivot.y,
            self.rotation, self.scale
        )
    else
        love.graphics.draw(
            self.texture,
            (x or self.position.x) - (self.width * self.scale / 2) + self.pivot.x,
            (y or self.position.y) - (self.height * self.scale / 2) + self.pivot.y,
            self.rotation, self.scale
        )
    end
end

return SpriteRenderer