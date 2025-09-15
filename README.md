# Atlassa - SSA UI Library - v1.2.0

![Atlassa Banner](https://raw.githubusercontent.com/Dotsian/Atlassa/refs/heads/main/Assets/Banner.png)

## What is Atlassa

The Atlassa package is designed to make UI functionality using a single script architecture easy while preventing memory leaks using connections.

## Installation

You can run this command in Roblox Studio to install the Atlassa package into `ReplicatedStorage`.

```luau
loadstring(game:GetService("HttpService"):GetAsync("https://raw.githubusercontent.com/Dotsian/Atlassa/main/Installer.luau"))()
```

## UI Managers

A UI state manager loads, destroys, and handles all UI states. You can load all your UI states using the following code:

```luau
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Atlassa = require(ReplicatedStorage.Atlassa)

local Player = Players.LocalPlayer
local States = Player.PlayerGui:WaitForChild("States")

local Manager = Atlassa.Manager.new()

Player.CharacterAdded:Connect(function()
    States = Player.PlayerGui:WaitForChild("States")

    Manager:Load(States:GetChildren())
end)

Player.CharacterRemoving:Connect(function()
    Manager:Unload()
end)

Manager:Load(States:GetChildren())
```

This will load all UI states when the character is added and unload them when the character is removed. You can also destroy the manager using the `Manager:Destroy` method.

```luau
Manager:Destroy() -- Unloads all UI states and prevents this manager from ever being used again.
```

## UI States

A UI state is where your functionality will be stored per UI. First, create a new ModuleScript. Then, you can initiate the UI state by calling the `Mount` function.

```luau
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Atlassa = require(ReplicatedStorage.Atlassa)

return Atlassa.UI.Mount({
    UpdateFrame = function()
        print("This will fire every frame!")
    end,
})
```

This will print "This will fire every frame!" whenever the `RunService.Heartbeat` signal gets fired. This can be useful for updating UI every frame.

## UI Components

A UI component is a reusable UI object that extends off of a base Roblox UI object. You can create a UI component by using the `Mount` function. You can also specifically clone from a template, which is the recommended way to use components.

```luau
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Atlassa = require(ReplicatedStorage.Atlassa)

local ButtonTemplate = ExampleUI.TemplateButton

type Properties = {
    Name: string,
    Parent: Instance,
}

return function(Properties: Properties)
    local Button = UI.Template(ButtonTemplate, {
        Name = Properties.Name,
        Parent = Properties.Parent,

        Visible = true,

        ["Frame.TextLabel.Text"] = "You can edit this template's children from here!"
    })

    return Atlassa.UI.Mount(Button, {
        Clicked = function()
            print("This button was clicked!")
        end,

        UpdateFrame = function()
            print("This button is updating every frame!")
        end,
    })
end
```

You can use this component by simply requiring it from your UI state.

```luau
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Atlassa = require(ReplicatedStorage.Atlassa)

local NewButton = require(script.NewButton)

return Atlassa.UI.Mount({
    Render = function()
        NewButton({
            Name = "TestButton1",
            Parent = ExampleUI.Frame
        })

        NewButton({
            Name = "TestButton2",
            Parent = ExampleUI.Frame
        })
    end,

    UpdateFrame = function()
        print("This will fire every frame!")
    end,
})
```

## UI Networking

UI networking is a way to establish client-to-client communication in your UI states or components.

You can listen for a new signal using the `Network:Signal` method.

```luau
Atlassa.Network:Signal("Testing", function(Message: string)
    print("Signal recieved!")
    print(Message)
end)
```

You can then fire this signal from any module or local script by using the `Network:Call` method.

```luau
Atlassa.Network:Call("Testing", "Message passed!")
```
