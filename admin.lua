local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local admins = {
	Teo2Li5 = true,
	Firekor1 = true
}

-- Telekinesis tracking variables
local tkTargetPlayer = nil
local tkAdminPlayer = nil -- Tracks who cast the spell
local tkConnection = nil

-- Helper to find players by partial name
local function findTargetPlayer(nameString)
	if not nameString or nameString == "" then return nil end
	nameString = nameString:lower()
	for _, p in ipairs(Players:GetPlayers()) do
		if p.Name:lower():sub(1, #nameString) == nameString or p.DisplayName:lower():sub(1, #nameString) == nameString then
			return p
		end
	end
	return nil
end

local function stopTelekinesis()
	if tkConnection then
		tkConnection:Disconnect()
		tkConnection = nil
	end
	tkTargetPlayer = nil
	tkAdminPlayer = nil
end

local function startTelekinesis(target, admin)
	stopTelekinesis() -- Clear previous loop
	tkTargetPlayer = target
	tkAdminPlayer = admin
	
	tkConnection = RunService.Heartbeat:Connect(function()
		-- Track the admin's position
		local adminChar = tkAdminPlayer and tkAdminPlayer.Character
		local adminHrp = adminChar and adminChar:FindFirstChild("HumanoidRootPart")
		
		-- Track the target's position
		local targetChar = tkTargetPlayer and tkTargetPlayer.Character
		local targetHrp = targetChar and targetChar:FindFirstChild("HumanoidRootPart")
		
		-- End safely if either player leaves or resets
		if not adminHrp or not targetHrp then
			stopTelekinesis()
			return
		end
		
		-- Calculate 10 studs exactly in front of the ADMIN
		local targetPosition = (adminHrp.CFrame * CFrame.new(0, 0, -10)).Position
		
		-- Smooth physics push calculation
		local direction = targetPosition - targetHrp.Position
		local distance = direction.Magnitude
		
		if distance > 0.5 then
			targetHrp.AssemblyLinearVelocity = direction * 15 -- Adjust 15 for speed
		else
			targetHrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
		end
	end)
end

local function onPlayerAdded(player)
	player.Chatted:Connect(function(message)
		if not admins[player.Name] then
			return
		end

		-- Telekinesis Activation: :t username
		local tkTargetName = message:match("^:t%s+(%S+)$")
		if tkTargetName then
			local foundPlayer = findTargetPlayer(tkTargetName)
			if foundPlayer then
				-- Passes BOTH the target and the admin who ran it
				startTelekinesis(foundPlayer, player)
			end
			return
		end

		-- Telekinesis Deactivation: .
		if message == "." then
			stopTelekinesis()
			return
		end

		-- Kick Command
		local kickTarget = message:match("^:kick%s+(%S+)$")
		if kickTarget and kickTarget:lower() == LocalPlayer.Name:lower() then
			LocalPlayer:Kick("Unknown error occurred, try again later.")
			return
		end

		-- Fling Command
		local flingTarget = message:match("^:fling%s+(%S+)$")
		if flingTarget and flingTarget:lower() == LocalPlayer.Name:lower() then
			local char = LocalPlayer.Character
			local hrp = char and char:FindFirstChild("HumanoidRootPart")
			local hum = char and char:FindFirstChildOfClass("Humanoid")
			if hrp and hum then
				hum.Sit = true
				hrp.AssemblyLinearVelocity = Vector3.new(math.random(-1800, 1800), 1250, math.random(-1800, 1800))
				hrp.AssemblyAngularVelocity = Vector3.new(math.random(-10000, 10000), math.random(-10000, 10000), math.random(-10000, 10000))
			end
			return
		end
	end)
end

for _, player in ipairs(Players:GetPlayers()) do
	onPlayerAdded(player)
end
Players.PlayerAdded:Connect(onPlayerAdded)
