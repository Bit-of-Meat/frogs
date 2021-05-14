local Class = require "Engine.Class"

Compiler = Class()

function Compiler:init(env)
    self.env = env or {}
end

function Compiler:run(code)
    local cmd = loadstring(code or "")
    setfenv(cmd, self.env)

    cmd()
end

return Compiler