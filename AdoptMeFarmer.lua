local ReplicatedStorage = game:GetService("ReplicatedStorage")
local API = ReplicatedStorage:FindFirstChild("API")
if not API then warn("API folder not found") return end

local apiMasterTable = {} -- Master table from API folder
local customMasterTable = {
    -- Example custom entries
    {CustomName = "MyCustomName1", Type = "RemoteFunction", Length = 31, Arguments = {game.Players.voidhammer1}},
    {CustomName = "MyCustomName2", Type = "RemoteEvent", Length = 29, Arguments = {"exit_housing","MainDoor"}}
    -- Add more entries if needed
}

-- Build API master table
for _, child in pairs(API:GetChildren()) do
    if child:IsA("RemoteFunction") or child:IsA("RemoteEvent") then
        local remoteType = child:IsA("RemoteFunction") and "RemoteFunction" or "RemoteEvent"
        table.insert(apiMasterTable, {
            Name = child.Name,
            Type = remoteType,
            Length = #child.Name,
            Object = child
        })
    end
end

-- Function to process remote based on custom table
local function processRemote(customName)
    local customDetails = nil
    for _, entry in pairs(customMasterTable) do
        if entry.CustomName == customName then
            customDetails = entry
            break
        end
    end
    
    if not customDetails then
        print("Custom remote not found:", customName)
        return
    end
    
    -- Find matching remote objects in API master table
    for _, remote in pairs(apiMasterTable) do
        if remote.Type == customDetails.Type and remote.Length == customDetails.Length then
            local remoteObj = remote.Object
            if customDetails.Type == "RemoteFunction" and remoteObj:IsA("RemoteFunction") then
                print("Invoking RemoteFunction:", remoteObj.Name)
                local success, result = pcall(function() return remoteObj:InvokeServer(unpack(customDetails.Arguments)) end)
                print(success and "Success:" or "Error:", remoteObj.Name, result)
            elseif customDetails.Type == "RemoteEvent" and remoteObj:IsA("RemoteEvent") then
                print("Firing RemoteEvent:", remoteObj.Name)
                local success, result = pcall(function() return remoteObj:FireServer(unpack(customDetails.Arguments)) end)
                print(success and "Success:" or "Error:", remoteObj.Name, result)
            end
        end
    end
end

-- Example usage
local customName = "MyCustomName1" -- Replace with the custom name you're using
--processRemote(customName)
--wait(5)
customName = "MyCustomName2"
processRemote(customName)
