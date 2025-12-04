local player = game.Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

-- === CONFIGURATION ===
local warpToMinePosition = CFrame.new(100, 50, 100) -- UPDATE THESE COORDS
local autoFarm = true 

-- === MAIN LOOP ===
task.spawn(function()
    while task.wait(1) do -- Runs every 1 second (Prevents spamming)
        
        -- 1. SAFE CHARACTER CHECK (Fixes "Script didn't run")
        local char = player.Character or player.CharacterAdded:Wait()
        local HRP = char:FindFirstChild("HumanoidRootPart")

        if autoFarm and HRP then
            
            -- === PART A: DIALOGUE SELECTOR ===
            -- We wrap this in pcall so it never crashes the script
            pcall(function()
                -- This fires "Yes" once per second. It won't spam 100x a second anymore.
                -- Make sure this Remote path is correct for your game!
                ReplicatedStorage.Remotes.SelectChoice:FireServer("Yes, I've done it.")
            end)

            -- === PART B: CRAFTING & WARP ===
            -- This part assumes you want to craft and then IMMEDIATELY leave
            -- If you only want this to happen when you are actually near the crafter,
            -- you might need to add a distance check.
            
            pcall(function()
                -- 1. Fire Craft
                ReplicatedStorage.Remotes.Craft:FireServer("ItemName")
                
                -- 2. Wait a tiny bit for craft to register
                task.wait(0.5) 
                
                -- 3. FORCE WARP TO MINE
                -- This will teleport you back every time the loop runs and tries to craft
                -- Note: If you are already at the mine, this just keeps you there.
                HRP.CFrame = warpToMinePosition
            end)
            
        end
    end
end)

print("Script Loaded: Fixed version running.")
