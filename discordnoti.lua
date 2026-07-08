local StarterGui = game:GetService("StarterGui")

local copyFunction = setclipboard or toclipboard or set_clipboard or (Clipboard and Clipboard.set)

if not copyFunction then
    warn("Your executor does not support clipboard functions!")
end

local function notifyDiscord()

    local bindable = Instance.new("BindableFunction")

    bindable.OnInvoke = function(buttonClicked)

        if buttonClicked == "Copy Discord" and copyFunction then
            copyFunction("dsc.gg/alpha-scriptss")
        end
    end

    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = "Discord",
            Text = "Would you like to join our Discord?\ndsc.gg/alpha-scriptss",
            Duration = 10,
            Button1 = "Dismiss",
            Button2 = "Copy Discord",
            Callback = bindable
        })
    end)
end

notifyDiscord()

while true do
    task.wait(150) 
    notifyDiscord()
end
