Queue = {}
function Queue.new()
    return {first = 0, last = -1}
end

function Queue.pushleft (Queue, value)
    local first = Queue.first - 1
    Queue.first = first
    Queue[first] = value
end

function Queue.pushright (Queue, value)
    local last = Queue.last + 1
    Queue.last = last
    Queue[last] = value
end

function Queue.popleft (Queue)
    local first = Queue.first
    if first > Queue.last then error("Queue is empty") end
    local value = Queue[first]
    Queue[first] = nil
    Queue.first = first + 1
    return value
end

function Queue.popright (Queue)
    local last = Queue.last
    if Queue.first > last then error("Queue is empty") end
    local value = Queue[last]
    Queue[last] = nil
    Queue.last = last - 1
    return value
end

function Queue.empty(Queue)
    return Queue.first > Queue.last
end

return Queue