local Frog = require "Frog"
local Tilemap = require "Engine.Tilemap"
local SpriteRenderer = require "Engine.SpriteRenderer"
local Vector = require "Engine.Vector"

local Panel = require "Panel"

local TextInput = require "TextInput"
local Compiler = require "Compiler"

local Level1 = require "Levels.Level1"

local WaterLily = SpriteRenderer({
    image = "Assets/WaterLily.png",
    width = 32,
    height = 15
}, nil, nil, nil, 5)

local tilemap = Tilemap(WaterLily)

local frog = Frog(Vector(700, 250 + 15 * 5), 5)

local font = love.graphics.newFont("Assets/Fonts/PressStart2P.ttf")

love.graphics.setFont(font)

love.keyboard.setKeyRepeat(true)

textbox = TextInput(Vector(5 * 3, 5 * 3), 6 * 20 * 3)

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

local panel = Panel("Assets/btn.png", {
    right = 5,
    left = 5,
    top = 5,
    down = 5
}, Vector(20, 30))

panel:generate()

function love.draw()
    tilemap:draw(Level1.map, Vector(700, 250))
    frog:draw()
    textbox:draw()
    panel:draw()
end