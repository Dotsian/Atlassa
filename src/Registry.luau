local Connections = {}
local RunService = game:GetService("RunService")

------------------------------------------------------------------------------------------------------------------------

Connections.Global = {
	UpdateFrame = RunService.Heartbeat,
}

Connections.Component = {
	Clicked = { "Activated", {
		"TextButton",
		"ImageButton",
	} },

	HoverStart = { "MouseEnter", {
		"TextButton",
		"ImageButton",
	} },

	HoverEnd = { "MouseLeave", {
		"TextButton",
		"ImageButton",
	} },
}

------------------------------------------------------------------------------------------------------------------------

return Connections :: {
	Global: { [string]: RBXScriptSignal },
	Component: { [string]: { string | { string } } }
}
