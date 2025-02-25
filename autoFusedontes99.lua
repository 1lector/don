_G.autoFuse = true -- Включает/выключает автоматическое слияние. Solara контролирует это значение.

local PET_TO_FUSE = "Pastel Goat" -- Имя питомца для слияния

local FUSE_AMOUNT = 3 -- Количество питомцев для слияния (минимум 3)

local IS_SHINY = false -- Укажите, является ли питомец Shiny (true/false)

local PET_TYPE = 0 -- 0: Normal, 1: Golden, 2: Rainbow

-- Получаем сервисы и библиотеки

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Library = ReplicatedStorage:WaitForChild("Library")

local LocalPlayer = game:GetService("Players").LocalPlayer

local Network = ReplicatedStorage:WaitForChild("Network")

local pets = require(Library).Save.Get().Inventory.Pet

local petId = nil

for id, petData in pairs(pets) do

    if petData["id"] == PET_TO_FUSE and tonumber(petData["pt"]) == PET_TYPE and petData["sh"] == IS_SHINY then

        petId = id

        print("Нашел подходящего питомца с ID:", petId)

        break

    end

end

if not petId then

    print("Питомец не найден! Проверьте конфигурацию.")

    _G.autoFuse = false -- Останавливаем скрипт, чтобы не было ошибок

    return

end

-- Функция телепортации к FuseMachine.  Поиск сначала Map, затем Map2.

local function teleportToFuseMachine()

 local mapName = game:GetService("Workspace"):FindFirstChild("Map") and "Map" or game:GetService("Workspace"):FindFirstChild("Map2") and "Map2"

    if mapName == "Map" then

      local zonePath = game:GetService("Workspace").Map["28 | Shanty Town"]

     LocalPlayer.Character.HumanoidRootPart.CFrame = zonePath.INTERACT.Machines.FuseMachine.PadGlow.CFrame

    elseif mapName == "Map2" then

     local zonePath = game:GetService("Workspace").Map2["100 | Tech Spawn"]

     LocalPlayer.Character.HumanoidRootPart.CFrame = zonePath.INTERACT.Machines.SuperMachine.PadGlow.CFrame

    end

end

teleportToFuseMachine()

-- Основной цикл слияния

while _G.autoFuse and petId do -- Добавлена проверка petId

    Network.FuseMachine_Activate:InvokeServer({[petId] = FUSE_AMOUNT})

    task.wait(0.5) -- Небольшая задержка

end

print("Автоматическое слияние завершено или остановлено.")

