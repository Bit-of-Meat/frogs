local Class = require "Libs.Class"

Compiler = Class()

function Compiler:init(env)
    self.env = env or {}
end

function Compiler:run(code)
    local cmd = loadstring(code or "")
    if cmd then
        setfenv(cmd, self.env)

        cmd()
    end
end

return Compiler