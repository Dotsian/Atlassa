# Atlassa - SSA UI Library - [BETA]

![Atlassa Banner](https://raw.githubusercontent.com/Dotsian/Atlassa/refs/heads/main/Assets/Banner.png)

## What is Atlassa

The Atlassa package is designed to make UI functionality using a single script architecture easy while preventing memory leaks using connections.

## Installation

You can run this command in Roblox Studio to install the Atlassa package into `ReplicatedStorage`.

```luau
loadstring(game:GetService("HttpService"):GetAsync("https://raw.githubusercontent.com/Dotsian/Atlassa/main/Installer.luau"))()
```

## Creating a UI state manager

A UI state manager is a script that loads all UI states. Here is an example of a basic UI state manager.

<details>

<summary>UI state manager template</summary>

```luau
local Players = game:GetService("Players")

local Player = Players.LocalPlayer

local ActiveStates = {}

function LoadStates()
    local FailedToLoad = {}

    for _, State in Player.PlayerGui:WaitForChild("States"):GetChildren() do
        if not State:IsA("ModuleScript") then
            continue
        end

        local Success, Result = pcall(function()
            return require(State)
        end)

        if not Success then
            table.insert(FailedToLoad, State.Name)
            continue
        end

        table.insert(ActiveStates, Result)
    end

    if FailedToLoad == {} then
        return
    end

    for _, State in FailedToLoad do
        warn(`Failed to load '{State}' UI state`)
    end
end

function ClearStates()
    for _, State in ActiveStates do
        if not State or not State["Destroy"] then
            continue
        end

        State:Destroy()
    end
end

Player.CharacterAdded:Connect(LoadStates)
Player.CharacterRemoving:Connect(ClearStates)

LoadStates()
```

</details>

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

## UI Network

UI networking is a way to establish client-to-client communication in your UI states or components.

You can listen for a new signal using the `Network:Signal` method.

```luau
Atlassa.Network:Signal("Testing", function(Message: string)
    print("Signal recieved!")
    print(Message)
end)
```

You can then fire this signal from any module or local script by using the `Network:WaitThenCall` method.

```luau
Atlassa.Network:WaitThenCall("Testing", "Message passed!")
```
