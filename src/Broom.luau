--[[

    Broom (Part of Luau-Modules)

    License: MIT
    Author: @XnLogicaL (@CE0_OfTrolling)

    A cleanup module that is similar to Janitor/Trove/Maid, but with additional features.

    Usage:



]]

local function threadDestructor(thread)
    task.cancel(thread)
end

local function funcDestructor(func, ...)
    func(...)
end

local Broom = {}
Broom.__index = Broom

function Broom:GetCleanupFunction(object: any, func: (string | (any) -> ())?)
    if getmetatable(object) == Broom then
        return object.Cleanup
    end

    if typeof(object) == "table" then

        if typeof(func) == "function" then
            return func
        end

        return object[func]
            or object.Destroy
            or object.destroy
            or object.Remove
            or object.remove

    elseif typeof(object) == "Instance" then return object.Destroy
    elseif typeof(object) == "thread" then return threadDestructor
    elseif typeof(object) == "function" then return funcDestructor

    else
        return function(_object)
           warn(tostring(_object) .. " does not have a cleanup method!")
        end
    end
end

function Broom:AddItem<T>(object: T, cleanupFunc: (string | (T) -> ())?)
    table.insert(
        self._cleanup_objects,
        {
            _object = object;
            _destructor = self:GetCleanupFunction(object, cleanupFunc);
        }
    )
end

function Broom:AddItems(objects: {any})
    for _, object in objects do
        self:AddItem(object)
    end
end

function Broom:Cleanup()
    self.OnCleanup:Fire()

    for i, object in self._cleanup_objects do
        object._destructor(
            object._object
        )
        self._cleanup_objects[i] = nil
    end
end

function Broom:AwaitCleanup()
    self.OnCleanup.Event:Wait()
end

local exports = {}
exports.__index = exports

function exports.new(objects: {any}?)
    local self = setmetatable({}, Broom)

    self._cleanup_objects = objects or {}
    self.OnCleanup = Instance.new("BindableEvent")

    return self
end

return exports