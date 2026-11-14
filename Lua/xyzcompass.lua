local Players = game:GetService("Players")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local human = character:WaitForChild("HumanoidRootPart")

player.CharacterAdded:Connect(function(newCharacter)
	character = newCharacter
	human = newCharacter:WaitForChild("HumanoidRootPart")
end)

local xyzcompass = Instance.new("ScreenGui")
xyzcompass.Name = "xyzcompass"
xyzcompass.ResetOnSpawn = false
xyzcompass.Parent = player:WaitForChild("PlayerGui")

local compass_frame = Instance.new("Frame")
compass_frame.Name = "compassbackground"
compass_frame.Size = UDim2.fromOffset(350, 135)
compass_frame.Position = UDim2.fromOffset(20, 20)
compass_frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
compass_frame.Parent = xyzcompass

local dragger = Instance.new("UIDragDetector")
dragger.Parent = compass_frame

local compass_print = Instance.new("TextLabel")
compass_print.Size = UDim2.fromOffset(310, 50)
compass_print.BackgroundColor3 = Color3.fromRGB(250, 250, 250)
compass_print.Position = UDim2.fromOffset(20, 12)
compass_print.TextSize = 16
compass_print.Parent = compass_frame

local compass_tp = Instance.new("TextBox")
compass_tp.Size = UDim2.fromOffset(310, 50)
compass_tp.BackgroundColor3 = Color3.fromRGB(250, 250, 250)
compass_tp.Position = UDim2.fromOffset(20, 72)
compass_tp.PlaceholderText = "Enter X, Y, Z to teleport..."
compass_tp.Text = ""
compass_tp.TextSize = 16
compass_tp.Parent = compass_frame

compass_tp.FocusLost:Connect(function(enterPressed)
	if not enterPressed or compass_tp.Text == "" then
		return
	end

	local parts = string.split(compass_tp.Text, ",")

	if #parts == 3 then
		local x = tonumber(parts[1])
		local y = tonumber(parts[2])
		local z = tonumber(parts[3])

		if x and y and z and human then
			human.CFrame = CFrame.new(x, y, z)
			compass_tp.Text = ""
		end
	end
end)

while true do
	if human then
		local pxyz = human.Position
		compass_print.Text = string.format("X: %.3f  Y: %.3f  Z: %.3f", pxyz.X, pxyz.Y, pxyz.Z)
	end
	task.wait(0.1)
end
