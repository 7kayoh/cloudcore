local RunService = game:GetService("RunService")

if not game:GetService("RunService"):IsServer() then error("CloudCore_Client can be only loaded in client context!") end

local Module = {}
local _Wrappers = script.Parent.CloudCore_Function:InvokeServer("GetWrappersInfo")

for serviceName, members in pairs(_Wrappers) do
	local serviceFunction = script.Parent._Wrappers:FindFirstChild(serviceName)
	Module[serviceName] = setmetatable({}, {
		__index = function(_, Index, ...)
			if members[Index] then
				if members[Index] == "function" then
					return function(...)
						serviceFunction:InvokeServer(Index, ...)
					end
				ekse
					return serviceFunction:InvokeServer(Index, ...)
				end
			end
		end
	})
end

function Module:GetService(Service)
	return Module[Service] or game:GetService(Service)
end

return Module