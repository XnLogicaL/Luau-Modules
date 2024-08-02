--[[

    Ptr (Part of Luau-Modules)

    License: MIT
    Author: @XnLogicaL (@CE0_OfTrolling)

    A VERY simple Luau pointer implementation

    Usage:

    Whenever you call a pointer object, you have 2 possibilites:

    if you provide a value, it will overwrite the current value and won't return
    otherwise, it will directly return it's current value.

]]

local function ptr(value: any?)
    local self = setmetatable({}, {
        __call = function(_self, v)
            if v then
                _self._value = v
            else
                return _self._value
            end
        end
    })

    self._value = value

    return table.freeze(self)
end

return ptr