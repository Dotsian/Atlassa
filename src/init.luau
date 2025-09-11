-- Replace the path of `PACKAGES` to the path where your packages are located.
-- You will also have to adjust the path in the following scripts:

-- `Cache`
-- `Network`

local PACKAGES = game.ReplicatedStorage.Packages

------------------------------------------------------------------------------------------------------------------------

local PackageError = false
local Types = require(script.Types)

if not PACKAGES:FindFirstChild("Janitor") then
	warn("Missing Janitor package for Atlassa, you can install it here: https://github.com/howmanysmall/Janitor")
	PackageError = true
end

if not PACKAGES:FindFirstChild("Signal") then
	warn("Missing Signal package for Atlassa, you can install it here: https://github.com/stravant/goodsignal")
	PackageError = true
end

if PackageError then
	error("One or more dependencies are missing for Atlassa")
end

------------------------------------------------------------------------------------------------------------------------

export type Connections = Types.Connections

return {
	Network = require(script.Network),
	UI = require(script.UI),
}
