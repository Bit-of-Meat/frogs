local utf8 = require "utf8"
local Class = require "Engine.Class"
local Vector = require "Engine.Vector"

function utf8.sub(str, x, y)
	local x2, y2
	x2 = utf8.offset(str, x)
	if y then
		y2 = utf8.offset(str, y + 1)
		if y2 then
			y2 = y2 - 1
		end
	end
	return string.sub(str, x2, y2)
end

local TextInput = Class()

function TextInput:init(position, wrap)
	self.text = ""

	self.time = 0

	self.cursor = "|"
	self.cursorPosition = 0

	self.position = position

	self.wrap = wrap
end

function TextInput:step(k)
	self.time = self.time + k
	if self.time > 1 then
		if self.cursor == "|" then
			self.cursor = ""
		else
			self.cursor = "|"
		end
		self.time = 0
	end
end

function TextInput:textinput(t)
	self.text = utf8.sub(self.text, 1, self.cursorPosition) .. t .. utf8.sub(self.text, self.cursorPosition + 1)
	self.cursorPosition = self.cursorPosition + 1
end

function TextInput:keypressed(key)
	if key == "backspace" and self.cursorPosition > 0 then
		self.text = utf8.sub(self.text, 1, self.cursorPosition - 1) .. utf8.sub(self.text, self.cursorPosition + 1)
		self.cursorPosition = self.cursorPosition - 1

	elseif key == "left" then
		self.cursorPosition = math.max(0, self.cursorPosition - 1)

	elseif key == "right" then
		self.cursorPosition = math.min(self.text:len(), self.cursorPosition + 1)

	elseif key == "delete" and self.text:len() > self.cursorPosition then
		self.text = utf8.sub(self.text, 1, self.cursorPosition) .. utf8.sub(self.text, self.cursorPosition + 2)

	elseif key == "return" then
		self.text = utf8.sub(self.text, 1, self.cursorPosition) .. "\n" .. utf8.sub(self.text, self.cursorPosition + 1)
		self.cursorPosition = self.cursorPosition + 1
	end
end

function TextInput:draw()
	-- Рендер текста
	love.graphics.printf(self.text, self.position.x, self.position.y, self.wrap)

	font = love.graphics.getFont()

	_, wt = font:getWrap(self.text, self.wrap)

	print(wt[#wt])

	if wt[#wt] then
		lines = #wt - 1
	else
		lines = #wt
	end

	-- Рендер курсора
	love.graphics.printf(
		self.cursor,
		self.position.x + font:getWidth(utf8.sub(wt[#wt] or "", 1, self.cursorPosition)) - font:getWidth(self.cursor) / 2,
		self.position.y + font:getHeight() * lines,
		self.wrap
	)
end

return TextInput