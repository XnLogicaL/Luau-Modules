--[[

    Team (Part of Luau-Modules)

    License: MIT
    Author: @XnLogicaL (@CE0_OfTrolling)

    An expansion to Roblox `Team` instance.

    Usage:

    ```lua
    local myTeam = Team.new("myTeam", BrickColor.Red())
    ```

    Create a new team with the constructor and pass in arguments that describe the teams identity

    ```lua
    myTeam:AddPlayer(me)
    myTeam:RemovePlayer(me)

    myTeam:GetPlayers() -- {}
    ```

    Add or remove a player to you team with their respective functions

    ```lua
    myTeam:RegisterCanDamage(otherTeam, true)
    myTeam:CanDamage(otherTeam) -- true
    ```

    Register relations with other teams and query it back

]]

local Players = game:GetService("Players")
local Teams = game:GetService("Teams")

local Team = {}
Team.__index = Team

function Team:GetPlayers()
    return self._players
end

function Team:AddPlayer(player: Player)
    table.insert(self._players, player)
end

function Team:IsPlayerMember(player: Player)
    return table.find(self._players, player) ~= nil
end

function Team:RemovePlayer(player: Player)
    table.remove(
        self._players,
        table.find(
            self._players,
            player, 1
        )
    )
end

function Team:RegisterCanDamage(otherTeam: any, canDamage: boolean)
    self._relations[otherTeam] = canDamage
end

function Team:CanDamage(otherTeam: any)
    return self._relations[otherTeam] or self._is_agressive
end

function Team:__init()
    Players.PlayerRemoving:Connect(function(player)
        if self:IsPlayerMember(player) then
            self:RemovePlayer(player)
        end
    end)

    self.__init = nil
end

function Team:Destroy()
    for _, player in self:GetPlayers() do
        self:RemovePlayer(player)
    end

    self._team:Destroy()

    table.clear(self)
    setmetatable(self, nil)
end

local exports = {}
exports.__index = exports

function exports.new(teamName: string, teamColor: BrickColor?, isAgressive: boolean?)
    local teamInstance = Instance.new("Team")
    teamInstance.Name = teamName
    teamInstance.TeamColor = teamColor or BrickColor.random()
    teamInstance.Parent = Teams

    local self = setmetatable({}, Team)

    self._team = teamInstance
    self._is_agressive = isAgressive or false
    self._players = {}
    self._relations = {}

    self:__init()

    return self
end

return exports