-- made my PRIV
-- nigga you tryna edit this??
-- Wellll i cant stop yah so GO CRAZY🙏🙏🙏🙏

game.StarterGui:SetCore(
	"SendNotification",
	{
		Title = "SHAZAM!",
		Text = "Nigga you tryna hack?",
	}
)
wait(1)
game.StarterGui:SetCore(
	"SendNotification",
	{
		Title = "SHAZAM!",
		Text = "This is PRIV!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!",
	}
)
wait(1)
game.StarterGui:SetCore(
	"SendNotification",
	{
		Title = "SHAZAM!",
		Text = "Confing your account",
	}
)
wait(1)
game.StarterGui:SetCore(
	"SendNotification",
	{
		Title = ">:)>:)>:)>:)>:)>:)>:)>:)>:)>:)>:)>:)",
		Text = ">:)>:)>:)>:)>:)>:)>:)>:)>:)>:)>:)",
	}
)
wait(0.5)
game.StarterGui:SetCore(
	"SendNotification",
	{
		Title = "SHAZAM!",
		Text = "GO Crazy🙏",
	}
)

for i = 1, 10 do
    game.StarterGui:SetCore(
	    "SendNotification",
	  {
		  Title = "SHAZAM!",
		  Text = "AIMBOT!?!?!?!?",
	  }
  )
end
 
 
local player = game.Players.LocalPlayer
local camera = game.Workspace.CurrentCamera
local runService = game:GetService("RunService")
local userInputService = game:GetService("UserInputService")
 
local aimSpeed = 0.1 -- Adjust this value for responsiveness
local isAimAssistEnabled = false
local predictionFactor = 5.4 -- Adjust this value for prediction accuracy
local currentTarget = nil
local smoothingFactor = 0
 
local function predictTargetPosition(target, deltaTime)
    local targetPosition = target.UpperTorso.Position
    local targetVelocity = target:FindFirstChild("Humanoid") and target.HumanoidRootPart.Velocity or Vector3.new()
 
    local predictedPosition = targetPosition + targetVelocity * predictionFactor * deltaTime
    return predictedPosition
end
 
local function aimAtTarget()
    if currentTarget and currentTarget.Parent then
        local predictedPosition = predictTargetPosition(currentTarget, runService.RenderStepped:Wait())
        local lookVector = (predictedPosition - camera.CFrame.Position).Unit
    
        local smoothedLookVector = (1 - smoothingFactor) * lookVector + smoothingFactor * (camera.CFrame.LookVector)
 
        local newCFrame = CFrame.new(camera.CFrame.Position, camera.CFrame.Position + aimSpeed * smoothedLookVector)
        camera.CFrame = newCFrame
    else
        currentTarget = nil
        isAimAssistEnabled = false
    end
end
 
local function findClosestPlayerToMouse()
    local mousePos = userInputService:GetMouseLocation()
    local closestPlayer = nil
    local shortestDistance = math.huge
 
    for _, object in pairs(game.Players:GetPlayers()) do
        if object ~= player and object.Character and object.Character:FindFirstChild("Humanoid") and object.Character:FindFirstChild("UpperTorso") then
            local targetScreenPos, onScreen = camera:WorldToScreenPoint(object.Character.UpperTorso.Position)
 
            if onScreen then
                local distance = (Vector2.new(targetScreenPos.X, targetScreenPos.Y) - mousePos).Magnitude
 
                if distance < shortestDistance then
                    closestPlayer = object.Character
                    shortestDistance = distance
                end
            end
        end
    end
 
    return closestPlayer
end
 
local function onKeyPress(input, gameProcessedEvent)
    if not gameProcessedEvent then
        if input.KeyCode == Enum.KeyCode.V then
            isAimAssistEnabled = not isAimAssistEnabled
            if isAimAssistEnabled then
                currentTarget = findClosestPlayerToMouse()
            else
                currentTarget = nil
            end
            print("AimBot toggled:", isAimAssistEnabled)
        end
    end
end
 
local function onCharacterAdded(character)
    character:WaitForChild("Humanoid").Died:Connect(function()
        if currentTarget == character then
            currentTarget = nil
        end
    end)
end
 
userInputService.InputBegan:Connect(function(input, gameProcessedEvent)
    onKeyPress(input, gameProcessedEvent)
end)
 
player.CharacterAdded:Connect(onCharacterAdded)
 
runService.RenderStepped:Connect(function(deltaTime)
    if isAimAssistEnabled then
        aimAtTarget()
    end
end)
