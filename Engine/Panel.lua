local Class = require "Libs.Class"

local Panel = Class()

function Panel:init(path, border, size)
  self.image = love.graphics.newImage(path)
  self.width, self.height = self.image:getDimensions()
  self.batch = love.graphics.newSpriteBatch(self.image, self.width * self.height)
  self.border = border
  self.size = size
end

function Panel:generate()
  self.batch:clear()
  -- top left
  tl = love.graphics.newQuad(
    0, 0,
    self.border.left, self.border.top,
    self.image:getDimensions()
  )

  -- top right
  tr = love.graphics.newQuad(
    self.width - self.border.right, 0,
    self.border.right, self.border.top,
    self.image:getDimensions()
  )

  -- down left
  dl = love.graphics.newQuad(
    0, self.height - self.border.down,
    self.border.left, self.border.down,
    self.image:getDimensions()
  )

  -- down right
  dr = love.graphics.newQuad(
    self.width - self.border.right, self.height - self.border.down,
    self.border.right, self.border.down,
    self.image:getDimensions()
  )

  -- center top left
  ctl = love.graphics.newQuad(
    0, self.border.top,
    self.border.left, self.height - self.border.top - self.border.down,
    self.image:getDimensions()
  )

  -- center top right
  ctr = love.graphics.newQuad(
    self.border.right, 0,
    self.width - self.border.left - self.border.right, self.border.top,
    self.image:getDimensions()
  )

  -- center down left
  cdl = love.graphics.newQuad(
    self.border.left, self.height - self.border.down,
    self.width - self.border.left - self.border.right, self.border.down,
    self.image:getDimensions()
  )

  -- center down right
  cdr = love.graphics.newQuad(
    self.width - self.border.right, self.border.top,
    self.border.right, self.height - self.border.top - self.border.down,
    self.image:getDimensions()
  )

  self.batch:add(tl, 0, 0)
  self.batch:add(tr, 11 + (6 * self.size.x), 0)
  self.batch:add(dl, 0, 11 + (6 * self.size.y))
  self.batch:add(dr, 11 + (6 * self.size.x), 11 + (6 * self.size.y))

  for x = 0, self.size.x do
    self.batch:add(ctr, 5 + (x * 6), 0)
    self.batch:add(cdl, 5 + (x * 6), 11 + (6 * self.size.y))
  end

  for y = 0, self.size.y do
    self.batch:add(ctl, 0, 5 + (y * 6))
    self.batch:add(cdr, 11 + (6 * self.size.x), 5 + (y * 6))
  end

  self.batch:flush()
end

function Panel:draw()
  love.graphics.draw(self.batch, 0, 0, 0, 3)
end

return Panel