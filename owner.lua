local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

local TARGETS = {
	["Teo2Li5"] = true,
	["Teo2Li4"] = true,
}

local CLEAN_TEXT = "AlphaScriptss (OWNER)"
local RICH_TEXT = "<font color=\"rgb(255,255,255)\">AlphaScriptss </font><font color=\"rgb(255,215,0)\">(OWNER)</font>"

RunService.RenderStepped:Connect(function()

	for _, player in ipairs(Players:GetPlayers()) do
		if TARGETS[player.Name] then
			pcall(function()
				player.DisplayName = CLEAN_TEXT
			end)
			
			local char = player.Character
			if char then
				local humanoid = char:FindFirstChildOfClass("Humanoid")
				if humanoid then
					humanoid.DisplayName = CLEAN_TEXT
				end
				
				for _, descendant in ipairs(char:GetDescendants()) do
					if descendant:IsA("TextLabel") or descendant:IsA("TextBox") then
						if descendant.Text:find(player.Name) or descendant.Text:find("AlphaScriptss") or descendant.Text == "" then
							descendant.RichText = true
							descendant.Text = RICH_TEXT
						end
					end
				end
			end
		end
	end

	local uiContainers = {lp:WaitForChild("PlayerGui"), CoreGui}
	for _, root in ipairs(uiContainers) do
		pcall(function()
			for _, textLabel in ipairs(root:GetDescendants()) do
				if textLabel:IsA("TextLabel") then
					if textLabel.Text == "Teo2Li5" or textLabel.Text == "Teo2Li4" then
						textLabel.RichText = true
						textLabel.Text = RICH_TEXT
					end
				end
			end
		end)
	end
end)
