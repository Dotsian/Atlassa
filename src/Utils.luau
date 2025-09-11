--!strict

local Utils = {}

------------------------------------------------------------------------------------------------------------------------

function Utils.FromPath(Root: any, Path: string, EndBefore: number?): Instance?
	local CurrentFile = Root
	local SplitPath = string.split(Path, ".")

	for Index, Next in SplitPath do
		if EndBefore and Index == #SplitPath - EndBefore then
			break
		end

		CurrentFile = CurrentFile:FindFirstChild(Next)

		if CurrentFile then
			continue
		end

		warn("Invalid path " .. Path)

		return nil
	end

	return CurrentFile
end

function Utils.HasProperty(Object: Instance, Property: string): boolean
	local Success, _ = pcall(function()
		(Object :: any)[Property] = (Object :: any)[Property]
	end)

	return Success
end

function Utils.ApplyProperties(Clone: GuiObject, Properties: { [string]: any }?)
	if not Properties then
		return
	end

	for Key, Property in Properties do
		if string.find(Key, ".") == nil then
			(Clone :: any)[Key] = Property
			continue
		end

		task.spawn(function()
			local Path = Utils.FromPath(Clone, Key, 0)

			if not Path then
				return
			end

			local SplitPath = string.split(Key, "__")
			local Attribute = SplitPath[#SplitPath]

			if not Utils.HasProperty(Path, Attribute) then
				warn(`{Attribute} is not a valid property of {Path.ClassName} "{Path.Name}"`)
				return
			end

			(Path :: any)[Attribute] = Property
		end)
	end
end

------------------------------------------------------------------------------------------------------------------------

return Utils
