local RunService = game:GetService("RunService")

if RunService:IsClient() then
	script.Server:Destroy()
	return require(script.Client)
else
	return require(script.Server)
end