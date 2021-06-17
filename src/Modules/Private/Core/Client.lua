local Core = {}

for _, module in ipairs(script.Parent:GetChildren()) do
	if module:IsA("ModuleScript") and module ~= script then
		Core[module.Name] = require(module)
	end
end

return Core