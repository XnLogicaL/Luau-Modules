--[[

    Thread (Part of Luau-Modules)

    License: MIT
    Author: @XnLogicaL (@CE0_OfTrolling)

    A simple object-oriented implementation of luau threads.

    Usage:

    ```lua
    local thread = Thread.new(function(args)
        stuff = otherStuff
    end, someArgs...)

    thread:Start()
    thread:Status()
    thread:Cancel()
    ```

]]

local Thread = {}
Thread.__index = Thread

function Thread:Cancel()
    coroutine.close(self._thread)

    self._thread = nil
    self._args = nil

    table.clear(self)
    setmetatable(self, nil)
end

function Thread:Start()
    coroutine.resume(
        self._thread,
        table.unpack(self._args)
    )
end

function Thread:Status()
    return coroutine.status(self._thread)
end

local exports = {}
exports.__index = exports

function exports.new<T...>(auto_start: boolean, func: (T...) -> (), ...: T...)
    local self = setmetatable({}, Thread)

    self._thread = coroutine.create(func)
    self._args = table.pack(...)

    if auto_start then
        self:Start()
    end

    return self
end

return Thread
