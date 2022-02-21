chunk = love.filesystem.load("save.lua")

if chunk then
    chunk()
else
    save = {
        level = 1
    }
end

save.level = 1

success = love.filesystem.write("save.lua", table.show(save, "save"))
SceneManager.load("Scenes/Game")