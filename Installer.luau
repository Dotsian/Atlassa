local Selection = game:GetService("Selection")
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Files = {
    "Cache.luau",
    "Network.luau",
    "Registry.luau",
    "Types.luau",
    "UI.luau",
    "Utils.luau"
}

local BasePath = CreateFile("init.luau", "Atlassa", ReplicatedStorage)

function FetchFile(Path: string): string?
	local URL = "https://raw.githubusercontent.com/Dotsian/Atlassa/main/src/"..Path

	local Success, Result = pcall(function()
		return HttpService:GetAsync(URL)
	end)

	if not Success then
		warn("[Installer]: Failed to fetch contents for "..Path, Result)
		return nil
	end

	return Result
end

function CreateFile(Path: string, Name: string?, Parent: any?): ModuleScript
    local Source = FetchFile(Path)

    local Module = Instance.new("ModuleScript")
    Module.Name = Name or string.split(Path, ".")[1]
    Module.Source = Source
    Module.Parent = Parent or BasePath

    return Module
end

for _, InstallFile in Files do
    CreateFile(InstallFile)

	print("[Installer]: Installed "..InstallFile.."!")
end

Selection:Set({BasePath})

print("[Installer]: Installation complete!")
