-- Replace the path of `PACKAGES` to the path where your packages are located.
-- You will also have to adjust the path in the following scripts:

-- `Cache`
-- `Network`
-- `Manager`

local PACKAGES = script.Parent

------------------------------------------------------------------------------------------------------------------------

local PACKAGES_REQUIRED = {
	Janitor = "https://github.com/howmanysmall/Janitor",
	Signal = "https://github.com/stravant/goodsignal",
}

local VERSION = "1.2.0"

------------------------------------------------------------------------------------------------------------------------

local LogDump = {}
local Types = require(script.Types)

local function CheckForPackage(Package: string, Link: string)
	local Retrieved = PACKAGES:FindFirstChild(Package)

	if Retrieved and Retrieved:IsA("ModuleScript") then
		return
	end
	
	table.insert(LogDump, "Missing " .. Package .. " package for Atlassa, you can install it here: " .. Link)
end

for Package, Link in PACKAGES_REQUIRED do
	CheckForPackage(Package, Link)
end

if #LogDump > 0 then
	for _, Log in LogDump do
		warn(Log)
	end
	
	error("One or more dependencies are missing for Atlassa")
end

------------------------------------------------------------------------------------------------------------------------

export type Connections = Types.Connections

return {
	Network = require(script.Network),
	UI = require(script.UI),
	Manager = require(script.Manager),
	
	_VERSION = VERSION,
}
