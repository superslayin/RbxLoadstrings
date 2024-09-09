print("TEST")

-- Declare the necessary variables and services
Players = game.Players
localPlayer = Players.LocalPlayer
VirtualInputManager = game:GetService("VirtualInputManager")

-- Function to get the coordinates of a button
function getButtonCoords(button)
    local position = button.AbsolutePosition
    local size = button.AbsoluteSize
    -- Get the x and y coordinates of the button's center
    local x = position.X + size.X / 2
    local y = position.Y + size.Y / 2
    return x, y
end

-- Function to simulate a mouse click at the given coordinates
function simulateMouseClick(x, y)
    local mouseButton1 = Enum.UserInputType.MouseButton1.Value  -- Get the integer value for MouseButton1

    -- Simulate mouse button down
    VirtualInputManager:SendMouseButtonEvent(x, y, mouseButton1, true, nil, 1)
    
    -- Wait briefly to simulate the click duration
    task.wait(0.1)
    
    -- Simulate mouse button up
    VirtualInputManager:SendMouseButtonEvent(x, y, mouseButton1, false, nil, 1)
end

-- Start the process by making QuestApp.Board visible
localPlayer.PlayerGui.QuestApp.Board.Visible = true

-- Check if BattlePassApp.Body is NOT visible or doesn't have more than 21 children
if not localPlayer.PlayerGui.BattlePassApp.Body.Visible or #localPlayer.PlayerGui.BattlePassApp.Body.InnerBody.ScrollingFrame:GetChildren() <= 21 then
    -- Get the BattlePassButton in the QuestApp and simulate a click on it
    local button = localPlayer.PlayerGui.QuestApp.Board.Header.Top.BattlePassButton
    local x, y = getButtonCoords(button)
    simulateMouseClick(x, y)

else
    -- If BattlePassApp.Body is visible, search through the children in ScrollingFrame
    localPlayer.PlayerGui.BattlePassApp.Body.Visible = true
    local scrollingFrame = localPlayer.PlayerGui.BattlePassApp.Body.InnerBody.ScrollingFrame

    -- Iterate over the frames named as numbers from 1 to 21
    for _, child in pairs(scrollingFrame:GetChildren()) do
        -- Check if the frame has a ButtonFrame with a ClaimButton
        if child:IsA("Frame") and tonumber(child.Name) and tonumber(child.Name) <= 21 then
            local buttonFrame = child:FindFirstChild("ButtonFrame")
            if buttonFrame then
                local claimButton = buttonFrame:FindFirstChild("ClaimButton", true)
                if claimButton and claimButton:IsA("ImageButton") then
                    -- Simulate a click on the ClaimButton
                    local x, y = getButtonCoords(claimButton)
                    simulateMouseClick(x, y)
                end
            end
        end
    end
end
