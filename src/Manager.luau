--!strict

local Manager = {}
Manager.__index = Manager

------------------------------------------------------------------------------------------------------------------------

local PACKAGES = script.Parent.Parent

------------------------------------------------------------------------------------------------------------------------

local Janitor = require(PACKAGES.Janitor)

------------------------------------------------------------------------------------------------------------------------

type self = {
	FailedStates: { string },
	Janitor: Janitor.Janitor,
}
	
export type Manager = typeof(setmetatable({} :: self, Manager))

------------------------------------------------------------------------------------------------------------------------

function Manager.new(): Manager
	local self = setmetatable({} :: self, Manager)

	self.Janitor = Janitor.new()
	
	self.FailedStates = {}

	return self
end

------------------------------------------------------------------------------------------------------------------------

--[[
Loads a table of UI states stored in module scripts.

<strong>States</strong>:			A table of states you want to load.
]]
function Manager.Load(self: Manager, States: {Instance}): boolean
	self.FailedStates = {}
	
	for _, State in States do
		local Success, Result = pcall(function()
			return require(State) :: any
		end)
		
		if not Success then
			table.insert(self.FailedStates, State.Name)
			continue
		end
		
		self.Janitor:Add(State, "Destroy")
	end
	
	if self.FailedStates == {} then
		return true
	end

	for _, State in self.FailedStates do
		warn(`Failed to load '{State}' UI state`)
	end
	
	return false
end

--[[
Destroys all states that were loaded using this manager.
]]
function Manager.Unload(self: Manager)
	self.Janitor:Cleanup()
end

--[[
Destroys the manager and all states that were loaded using it.
]]
function Manager.Destroy(self: Manager)
	self.Janitor:Add(self)
	self:Unload()
end

------------------------------------------------------------------------------------------------------------------------

return Manager
