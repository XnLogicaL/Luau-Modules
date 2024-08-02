--[[

    Orbit (Part of Luau-Modules)

    License: MIT
    Author: @XnLogicaL (@CE0_OfTrolling)

    A function that provides easy accessibility to "orbit math"

    Usage:

    ```lua
    local theta = 90 -- angle in degrees
    local radius = 1 -- radius in studs
    local origin = Vector3.zero

    local pos = orbit(origin, radius, theta)
    ```

    This returns an exact position on a circles circumfrance using the angle theta and radius, originating from `origin`.

]]

local function orbit(origin: Vector3, radius: number, theta: number)
    return origin + Vector3.new(
        radius * math.cos(math.rad(theta)), 0,
        radius * math.sin(math.rad(theta))
    )
end

return orbit