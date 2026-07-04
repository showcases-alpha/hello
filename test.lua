function SendMessageEMBED(url, embed)
    local http = game:GetService("HttpService")
    local headers = {
        ["Content-Type"] = "application/json"
    }
    local data = {
        ["embeds"] = {
            {
                ["title"] = embed.title,
                ["description"] = embed.description,
                ["color"] = embed.color,
                ["fields"] = embed.fields,
                ["footer"] = {
                    ["text"] = embed.footer.text
                }
            }
        }
    }
    local body = http:JSONEncode(data)
    local response = request({
        Url = url,
        Method = "POST",
        Headers = headers,
        Body = body
    })
    print("Sent")
end

-- 1. Insert your webhook URL here
local url = "https://webhook.lewisakura.moe/api/webhooks/1522948960623526019/SxY2rJcm259_faMPMaWMMMNakiPDQpJ4i6_vcfoSeXiQga3H8ebfVt3Ssm10WePLCjMx"

-- 2. Gather player and server size numbers
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local username = player and player.Name or "Unknown User"
local displayName = player and player.DisplayName or "Unknown Display"

local currentPlayers = #Players:GetPlayers()
local maxPlayers = Players.MaxPlayers
local playerRatio = tostring(currentPlayers) .. "/" .. tostring(maxPlayers)

-- 3. Safely look up the Game/Place Name from Roblox
local MarketplaceService = game:GetService("MarketplaceService")
local placeId = tostring(game.PlaceId)
local gameName = "Unknown Game"

local success, result = pcall(function()
    return MarketplaceService:GetProductInfo(game.PlaceId)
end)

if success and result and result.Name then
    gameName = result.Name
end

-- 4. Gather the server identification data
local jobId = game.JobId

-- 5. Construct your custom link dynamically
local joinLink = "https://project-reverse.org/joiner?placeid=" .. placeId .. "&gameInstanceId=" .. jobId

-- Studio visual fallback
if jobId == "" then
    jobId = "Running in Studio (No JobId)"
    joinLink = "https://project-reverse.org/joiner?placeid=" .. placeId .. "&gameInstanceId=STUDIO_TEST"
end

-- 6. Construct the server info embed
local embed = {
    ["title"] = "📍 Server Logged",
    ["description"] = "Logged a Server",
    ["color"] = 10181046, -- Purple color
    ["fields"] = {
        {
            ["name"] = "👤 Player",
            ["value"] = "**Username:** `" .. username .. "`\n**Display Name:** `" .. displayName .. "`"
        },
        {
            ["name"] = "🎮 Game Name",
            ["value"] = "**" .. gameName .. "**"
        },
        {
            ["name"] = "👥 Server Size",
            ["value"] = "`" .. playerRatio .. "`"
        },
        {
            ["name"] = "🆔 Job ID",
            ["value"] = "`" .. jobId .. "`"
        },
        {
            ["name"] = "🔗 Quick Join Link",
            ["value"] = "[Click Here to Join Server](" .. joinLink .. ")"
        }
    },
    ["footer"] = {
        ["text"] = "Tuff's Web Joiner"
    }
}

-- 7. Send the information
SendMessageEMBED(url, embed)
