local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")

local player = Players.LocalPlayer


if not player then 
	return 
end


if not player.Character then 
	player.CharacterAdded:Wait()
end

local fkcube = Instance.new("Part")
fkcube.Name = "fakecube"
fkcube.Size = Vector3.new(1,1,1)
fkcube.Anchored = false
fkcube.CanCollide = false
fkcube.Transparency = 0.5

local parthandle = fkcube:Clone()

local tptool = Instance.new("Tool")
tptool.Parent = player:WaitForChild("Backpack")
tptool.Name = "TeleportCube"
tptool.CanBeDropped = false

parthandle.Name = "Handle" 
parthandle.Parent = tptool

fkcube:Destroy() 


local mousebean: Part?
local b1Connection: RBXScriptConnection?
local b2Connection: RBXScriptConnection?

tptool.Equipped:Connect(function()
	local mouse = player:GetMouse()
	if not mouse then return end

	mousebean = Instance.new("Part")
	if not mousebean then return end

	mousebean.Name = "MouseBean"
	mousebean.Parent = workspace
	mousebean.Anchored = true
	mousebean.CanCollide = false
	mousebean.CanTouch = false
	mousebean.Transparency = 0.5

	mouse.TargetFilter = mousebean 

	local endmouse = Vector3.new()

	local function tpPlayer()
		local character = player.Character
		if character and character:FindFirstChild("HumanoidRootPart") then
			character.HumanoidRootPart.CFrame = CFrame.new(endmouse + Vector3.new(0, 3, 0))
		end
	end

	b1Connection = mouse.Button1Down:Connect(tpPlayer)
	b2Connection = mouse.Button2Down:Connect(tpPlayer)

	while tptool.Parent == player.Character do
		local handle = tptool:FindFirstChild("Handle")
		if handle and handle:IsA("BasePart") then
			local startPos = handle.Position
			local mouse_xyz = mouse.Hit.Position
			endmouse = mouse_xyz
			local distance = (startPos - endmouse).Magnitude 
			mousebean.CFrame = CFrame.lookAt(startPos, endmouse) * CFrame.new(0, 0, -distance/2) 
			mousebean.Size = Vector3.new(1, 1, distance)
		end
		task.wait(0.1)
	end
end)

tptool.Unequipped:Connect(function()
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
end)
