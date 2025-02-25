_G.autoFuse = true -- Включает/выключает автоматическое слияние.

local PET_TO_FUSE = "Pastel Goat" -- Имя питомца для слияния

local FUSE_AMOUNT = 3 -- Количество питомцев для слияния

local IS_SHINY = false -- Является ли питомец Shiny

local PET_TYPE = 0 -- 0: Normal, 1: Golden, 2: Rainbow

local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Network = ReplicatedStorage:WaitForChild("Network")

local pets = require(ReplicatedStorage.Library).Save.Get().Inventory.Pet

local petId = nil

for id, petData in pairs(pets) do

    if petData.id == PET_TO_FUSE and petData.pt == PET_TYPE and petData.sh == IS_SHINY then

        petId = id

        print("Питомец найден: ", petId)

        break

    end

end

if not petId then

    print("Питомец не найден!")

    _G.autoFuse = false

    return

end

local function teleportToFuseMachine()

    local machine = workspace:FindFirstChild("Map") or workspace:FindFirstChild("Map2")

    if machine then

        local fuseMachine = machine:FindFirstChild("28 | Shanty Town") or machine:FindFirstChild("100 | Tech Spawn")

        if fuseMachine then

            LocalPlayer.Character:MoveTo(fuseMachine.INTERACT.Machines.FuseMachine.PadGlow.Position)

        end

    end

end

teleportToFuseMachine()

while _G.autoFuse and petId do

    Network.FuseMachine_Activate:InvokeServer({[petId] = FUSE_AMOUNT})

    task.wait(0.5)

end

print("Слияние завершено.")
