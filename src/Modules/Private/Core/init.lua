local Core = {}
Core.Shared = {}
Core.Out = {
	__index = function(_, key: string)
		return Core.Out[key]
	end,
}

function Core:GetController(Controller)
	return Core.Out.Controllers[Controller]
end

function Core:GetService(Service)
	return Core.Out.Services[Service] or game:GetService(Service)
end

for _, possiblyModule in ipairs(script:GetChildren()) do
	if possiblyModule:IsA("ModuleScript") and possiblyModule ~= script then
		Core[possiblyModule.Name] = require(possiblyModule)
	end
end

Core.Out = setmetatable({}, Core.Out)
return Core