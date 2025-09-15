--!strict

local Cache = {}
Cache.__index = Cache

------------------------------------------------------------------------------------------------------------------------

local PACKAGES = script.Parent.Parent

------------------------------------------------------------------------------------------------------------------------

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Janitor = require(PACKAGES.Janitor)

local ConnectionsTable = require(script.Parent.Registry)
local Types = require(script.Parent.Types)

------------------------------------------------------------------------------------------------------------------------

type self = {
	Connections: any,
	Object: GuiObject?,
	IsComponent: boolean,
	Janitor: Janitor.Janitor,
	ExternalConnections: { RBXScriptConnection }
}

export type Cache = typeof(setmetatable({} :: self, Cache))

------------------------------------------------------------------------------------------------------------------------

function Cache.new(Connections: Types.Connections, Object: GuiObject?): Cache
	local self = setmetatable({} :: self, Cache)

	self.Object = Object
	self.IsComponent = self.Object ~= nil

	local NewConnections = {}

	for Key, Connection in Connections do
		if Key == "Render" then
			task.spawn(Connection)
			continue
		end

		if not self.IsComponent or typeof(Key) == "RBXScriptSignal" or not self.Object then
			NewConnections[Key] = Connection
			continue
		end

		local FetchedKey = ConnectionsTable.Component[Key]

		if not FetchedKey then
			continue
		end
		
		local ClassNames = FetchedKey[2] :: { string }

		if table.find(ClassNames, self.Object.ClassName) == nil then
			continue
		end
		
		local SafeObject = self.Object :: any

		local Event: RBXScriptSignal = SafeObject[FetchedKey[1]]

		NewConnections[Event] = Connection
	end

	self.Janitor = Janitor.new()

	self.Connections = NewConnections
	self.ExternalConnections = {}

	if self.IsComponent and self.Object then
		self.Janitor:Add(
			self.Object.Destroying:Once(function()
				self:Destroy()
			end),
			"Disconnect"
		)
	end

	return self
end

------------------------------------------------------------------------------------------------------------------------

function Cache.Init(self: Cache)
	for Key, Connection in self.Connections do
		local Event: RBXScriptSignal? = Key

		if ConnectionsTable.Global[Key] then
			Event = ConnectionsTable.Global[Key]
		end

		if not Event then
			warn(Key .. " is not a valid connection")
			continue
		end

		self.Janitor:Add(Event:Connect(Connection), "Disconnect")
	end
end

function Cache.AddExternal(self: Cache, Event: RBXScriptSignal, Callback: (any) -> any)
	local NewConnection = Event:Connect(Callback)

	table.insert(self.ExternalConnections, NewConnection)

	self.Janitor:Add(NewConnection, "Disconnect", #self.ExternalConnections)
end

function Cache.ClearExternal(self: Cache, Event: RBXScriptSignal)
	local ConnectionIndex = table.find(self.ExternalConnections, Event)

	if ConnectionIndex == nil then
		warn("No RBXScriptSignal found when attempting to call `ClearExternal`")
		return
	end

	self.Janitor:Remove(#self.ExternalConnections)
end

function Cache.Destroy(self: Cache)
	self.Janitor:Add(self)
	self:Clear()
end

function Cache.Clear(self: Cache)
	self.Janitor:Cleanup()
end

------------------------------------------------------------------------------------------------------------------------

return Cache
