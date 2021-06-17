local RunService = game:GetService("RunService")

if not game:GetService("RunService"):IsServer() then error("CloudCore_Server can be only loaded in server context!") end

local Modules = script.Parent.Modules
local Core = require(Modules.Private.Core)

local DEFINED_PREFIXES = {
	["Services"] = "service",
	["Controllers"] = "controller",
	["Utilities"] = "util"
}
local IGNORE_LIST = {
	Categories = {
		"Utilities"
	},
	Modules = {}
}
local preOut = {}
local _Wrappers = {}

local function ProcessCategories(Category: Folder)
	-- We always liked the idea of making stuff much intuitive for developers
	-- Simply letting them to place their modules, quote-unquote, are not anywhere intuitive, nor reliable
	-- Issues such as misplacing modules, may cause potential issues within the framework itself
	-- As a result, we have this function, which only allows the module with the corresponding prefix for that
	-- specific category, to be initialized and loaded.

	-- Apart from that, we know developers who use third-party modules, that are not orginally built
	-- for this framework, which as a result, loading them inside the framework, may poses actual threat to the code
	-- such as "C Stack Overflow", et cetera.

	if Category:IsA("Folder") and Category.Name ~= "Private" and DEFINED_PREFIXES[Category.Name] then
		local prefix = DEFINED_PREFIXES[Category.Name]
		preOut[Category.Name] = {}
		Core.Out[Category.Name] = setmetatable({}, {
			__index = function(_, key: string)
				return preOut[Category.Name][key]
			end,
		})

		-- TODO: Refactor this section of code
		-- Honestly, even if we ignore the third-party modules, what would be the point of placing the "Utility" folder
		-- which is bundled by default, when the framework does not even assign them at all!
		-- We know some third-party modules may have runtime code, so we avoided doing that, instead we linked the actual module
		-- object, rather than the data returned after requiring the module

		-- In the future, I'll probably add some indicators to let you know rather this module is ignored, or not.
		if table.find(IGNORE_LIST.Categories, Category.Name) then
			Core.warn("currently in an ignored category; " .. Category.Name)
			for _, possiblyModule in ipairs(Category:GetDescendants()) do
				if possiblyModule:IsA("ModuleScript") and string.match(possiblyModule.Name, ".%." .. prefix) then
					preOut[Category.Name][string.gsub(possiblyModule.Name, "%." .. prefix, "")] = possiblyModule
				else
					continue
				end
			end
		else
			for _, possiblyModule in ipairs(Category:GetDescendants()) do
				if possiblyModule:IsA("ModuleScript") and string.match(possiblyModule.Name, ".%." .. prefix) then
					preOut[Category.Name][string.gsub(possiblyModule.Name, "%." .. prefix, "")] = require(possiblyModule)
				else
					continue
				end
			end
		end
	end
end

local function CorrectErrors()
	-- Errors are great for debugging. not is not always necessary for the debugging stages, simple and minor
	-- mistakes, can be simply rectified with an automatic, flexible, reactive piece of code
	-- correcting the mistakes made by the developer at runtime, so they will not panic when the
	-- framework fails to compile
	if not IGNORE_LIST then
		IGNORE_LIST = {}
	end

	if not IGNORE_LIST.Categories then
		IGNORE_LIST.Categories = {}
	end

	if not IGNORE_LIST.Modules then
		IGNORE_LIST.Categories = {}
	end
end

local function Initialize()
	local cloudcoreRemoteFunction = Instance.new("RemoteFunction", script.Parent)
	CorrectErrors()
	for _, Category in ipairs(Modules:GetChildren()) do
		ProcessCategories(Category)
	end

	for _, folder in pairs(preOut) do
		for name, module in pairs(folder) do
			if typeof(module) == "table" then
				module.Core = Core
				module.__index = module
				module = setmetatable({}, module)
				if module.Initialize then
					module:Initialize()
				end
				folder[name] = module
			else
				continue
			end
		end
	end

	for folderName, folder in pairs(preOut) do
		for name, module in pairs(folder) do
			if typeof(module) == "table" and module.Start then
				module:Start()
			else
				continue
			end
			
			if folderName == "Services" then
				local serviceFunction = Instance.new("RemoteFunction", script.Parent._Wrappers)
				_Wrappers[name] = {}
				module.Client = module.Client or {}
				serviceFunction.Name = name
				
				serviceFunction.OnServerInvoke = function(Player, Index, ...)
					if _Wrappers[name][Index] == "member" then
						return module.Client[Index]
					else
						return module.Client[Index](Player, Index, ...)
					end
				end
				
				for index, value in pairs(module.Client) do
					_Wrappers[name][index] = type(value) == "function" and "function" or "member"
				end
			end
		end
	end
	
	cloudcoreRemoteFunction.Name = "CloudCore_Function"
	cloudcoreRemoteFunction.OnServerInvoke = function(Player, Type, ...)
		if Type == "GetWrappersInfo" then
			return _Wrappers
		end
	end
end

Initialize()
return {}