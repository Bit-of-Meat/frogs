Class = require "Engine.Class"

Animation = Class()

function Animation:init(frames, duration)
    self.frames = frames
    self.duration = duration or 1
    self.currentTime = 0
    self.paused = false

    self.onEnd = function () end
end

function Animation:update(dt)
    if self.paused == false then 
        self.currentTime = self.currentTime + dt
    end

    if self.currentTime >= self.duration then
        self.currentTime = self.currentTime - self.duration
        self.onEnd()
    end
end

function Animation:getFrame()
    return self.frames[math.floor(self.currentTime / self.duration * #self.frames) + 1]
end

return Animation