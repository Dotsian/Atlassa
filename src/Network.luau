--!strict

local Network = {}

------------------------------------------------------------------------------------------------------------------------

local PACKAGES = script.Parent.Parent

------------------------------------------------------------------------------------------------------------------------

local Signal = require(PACKAGES.Signal)

local Signals: { [string]: { Signal.Signal<> | Signal.Connection } } = {}

------------------------------------------------------------------------------------------------------------------------

--[[
Registers a new UI signal.

<strong>Name</strong>:			The name of the signal that will be registered.
<strong>Callback</strong>:		The callback that will be executed when the signal is fired.
]]
function Network:Signal(Name: string, Callback: (...any) -> ()): Signal.Signal<>
	if Signals[Name] then
		local Connection = Signals[Name][2] :: Signal.Connection
		Connection:Disconnect()
	end

	local Interceptor = Signal.new()
	local Connection = Interceptor:Connect(Callback)

	Signals[Name] = { Interceptor, Connection }

	return Interceptor
end

--[[
Waits for a UI signal then fires it.

<strong>Name</strong>:			The name of the UI signal to fire.
]]
function Network:Call(Name: string, ...)
	local StartTime = tick()
	local Warned = false

	while not Signals[Name] do
		if (tick() - StartTime) > 5 and not Warned then
			warn(`Infinite yield possible on '{script.Name}:Call("{Name}")'`)
			Warned = true
		end

		task.wait()
	end

	local Signal = Signals[Name][1] :: Signal.Signal<>
	Signal:Fire(...)
end

------------------------------------------------------------------------------------------------------------------------

return Network
