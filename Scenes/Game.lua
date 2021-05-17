local Frog = require "Frog"
local Tilemap = require "Engine.Tilemap"
local SpriteRenderer = require "Engine.SpriteRenderer"
local Vector = require "Engine.Vector"

local Panel = require "Engine.Panel"

local TextInput = require "Engine.TextInput"
local Compiler = require "Compiler"

require "Libs.tableUtil"

chunk = love.filesystem.load("save.lua")

if chunk then
    chunk()
else
    save = {
        level = 1
    }
end

local Level = require("Levels.Level" .. save.level)

local tilesheet = SpriteRenderer({
    image = "Assets/Tilesheet.png",
    width = 36,
    height = 36
}, nil, Vector(0, 20), nil, 5)

local tilemap = Tilemap(tilesheet, Vector(32, 16), Vector(3, 3))

local frog = Frog(Vector(600, 200 + 15 * 5), Vector(32 + 3, 16 + 3), 5, Level.map)

local font = love.graphics.newFont("Assets/Fonts/PressStart2P.ttf", 14)

love.graphics.setFont(font)

love.keyboard.setKeyRepeat(true)

textbox = TextInput(Vector(5 * 3, (16 * 10) + (5 * 3)), 6 * 20 * 3)

function love.update(dt)
    frog:update(dt)
    textbox:step(dt)
end

function love.textinput(t)
    textbox:textinput(t)
end

local c = Compiler({
    left = function ()
        frog:move("left")
    end,
    right = function ()
        frog:move("right")
    end,
    down = function ()
        frog:move("down")
    end,
    up = function ()
        frog:move("up")
    end
})

function love.keypressed(key)
    if key == "f4" then
        c:run(textbox.text)
    end
    textbox:keypressed(key)
end

local task = Panel("Assets/btn.png", {
    right = 5,
    left = 5,
    top = 5,
    down = 5
}, Vector(20, 5))

local panel = Panel("Assets/btn.png", {
    right = 5,
    left = 5,
    top = 5,
    down = 5
}, Vector(20, 20))

task:generate()
panel:generate()

function love.draw()
    task:draw(Vector(0, 0), 0, Vector(3, 3))
    tilemap:draw(Level.map, Vector(600, 200))
    frog:draw()
    tilemap:draw(Level.decor, Vector(600, 200))
    panel:draw(Vector(0, 16 * 10), 0, Vector(3, 3))
    textbox:draw()
    love.graphics.printf(Level.description, 5 * 3, 5 * 3, 6 * 20 * 3)
end