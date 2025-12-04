local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local HRP = char:WaitForChild("HumanoidRootPart")

-- CONFIGURATION
local autoFarm = true -- Toggle this
local warpToMinePosition = CFrame.new(100, 50, 100) -- CHANGE THIS to your mine coordinates
local warpToCraftPosition = CFrame.new(0, 50, 0)    -- CHANGE THIS to your craft coordinates

-- Function to Warp
function TPToMine()
    if HRP then
        HRP.CFrame = warpToMinePosition
    end
end

function TPToCraft()
    if HRP then
        HRP.CFrame = warpToCraftPosition
    end
end

-- MAIN LOOP
task.spawn(function()
    while task.wait(0.5) do
        if autoFarm then
            -- 1. CHECK FOR DIALOGUE (Fixing the Spam)
            -- We look for the GUI first. Change "DialogueGui" to the real name in your Explorer.
            local dialogueGui = player.PlayerGui:FindFirstChild("DialogueGui") 
            
            -- Only press the button if the GUI is actually there AND visible
            if dialogueGui and dialogueGui.Enabled then 
                -- Fire the "Yes" choice
                -- REPLACE this event with your specific RemoteEvent path
                game:GetService("ReplicatedStorage").Remotes.SelectChoice:FireServer("Yes, I've done it.")
                print("Dialogue detected: Selected Yes.")
                task.wait(1) -- Wait a bit so we don't double-click instantly
            end

            -- 2. CHECK CRAFTING STATUS (Fixing the Warp)
            -- Example logic: If we are at the crafting station and inventory is empty/done
            local isCraftingOpen = player.PlayerGui:FindFirstChild("CraftingGui")
            
            if isCraftingOpen and isCraftingOpen.Enabled then
                -- Do the crafting
                game:GetService("ReplicatedStorage").Remotes.Craft:FireServer("ItemName")
                task.wait(2) -- Wait for craft time
                
                -- WARP BACK AFTER CRAFTING
                print("Crafting finished. Warping back to mine...")
                TPToMine()
            else
                -- If we aren't crafting and aren't in dialogue, ensure we are mining
                -- (Optional: Add logic here to warp to mine if not there)
            end
        end
    end
end)
