local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
if not player then return end

local function giveTeleportTool(character)
	local existingBean = Workspace:FindFirstChild("MouseBean")
	if existingBean then
		existingBean:Destroy()
	end

	local parthandle = Instance.new("Part")
	parthandle.Name = "Handle"
	parthandle.Size = Vector3.new(1, 1, 1)
	parthandle.Anchored = false
	parthandle.CanCollide = false
	parthandle.Transparency = 0.5

	local tptool = Instance.new("Tool")
	tptool.Name = "TeleportCube"
	tptool.CanBeDropped = false
	parthandle.Parent = tptool
	
	local backpack = player:WaitForChild("Backpack")
	tptool.Parent = backpack

	local mousebean: Part?
	local b1Connection: RBXScriptConnection?
	local b2Connection: RBXScriptConnection?

	local function cleanup()
		if mousebean then
			mousebean:Destroy()
			mousebean = nil
		end
		if b1Connection then
			b1Connection:Disconnect()
			b1Connection = nil
		end
		if b2Connection then
			b2Connection:Disconnect()
			b2Connection = nil
		end
	end

	tptool.Equipped:Connect(function()
		local mouse = player:GetMouse()
		if not mouse then return end

		mousebean = Instance.new("Part")
		mousebean.Name = "MouseBean"
		mousebean.Parent = Workspace
		mousebean.Anchored = true
		mousebean.CanCollide = false
		mousebean.CanTouch = false
		mousebean.Transparency = 0.5

		mouse.TargetFilter = mousebean 

		local endmouse = Vector3.new()

		local function tpPlayer()
			local currentChar = player.Character
			if currentChar and currentChar:FindFirstChild("HumanoidRootPart") then
				currentChar.HumanoidRootPart.CFrame = CFrame.new(endmouse + Vector3.new(0, 3, 0))
			end
		end

		b1Connection = mouse.Button1Down:Connect(tpPlayer)
		b2Connection = mouse.Button2Down:Connect(tpPlayer)

		task.spawn(function()
			while tptool.Parent == player.Character and mousebean do
				local handle = tptool:FindFirstChild("Handle")
				if handle and handle:IsA("BasePart") then
					local startPos = handle.Position
					local mouse_xyz = mouse.Hit.Position
					endmouse = mouse_xyz
					local distance = (startPos - endmouse).Magnitude 
					mousebean.CFrame = CFrame.lookAt(startPos, endmouse) * CFrame.new(0, 0, -distance/2) 
					mousebean.Size = Vector3.new(1, 1, distance)
				end
				task.wait(0.03) 
			end
		end)
	end)

	tptool.Unequipped:Connect(cleanup)
	
	local humanoid = character:WaitForChild("Humanoid")
	humanoid.Died:Connect(cleanup)
end

if player.Character then
	giveTeleportTool(player.Character)
end

player.CharacterAdded:Connect(giveTeleportTool)
