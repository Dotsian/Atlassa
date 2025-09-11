--!strict

local UI = {}

local Cache = require(script.Parent.Cache)
local Utils = require(script.Parent.Utils)

------------------------------------------------------------------------------------------------------------------------

--[[
Clones an object and applies properties to it.

<strong>Object</strong>:			The object you want to clone.
<strong>Properties</strong>:		The properties you want to apply to the object.
]]
function UI.Template(Object: GuiObject, Properties: { [string]: any }?): GuiObject
	local Clone = Object:Clone()

	Utils.ApplyProperties(Clone, Properties)

	return Clone
end

function UI.Mount(...)
	local Args = { ... }
	local IsComponent = typeof(Args[1]) == "Instance" or typeof(Args[1]) == "string"

	local Object = if IsComponent then Args[1] else nil
	local Connections = Args[if IsComponent then 2 else 1]

	if typeof(Object) == "string" then
		Object = Instance.new(Object)
	end

	local NewCache = Cache.new(Connections, Object)

	NewCache:Init()

	return NewCache
end

------------------------------------------------------------------------------------------------------------------------

return UI
