-- ESX shared object
local ESX = nil
local PlayerData = {}
local isInZone = false
local currentZone = nil
local isFishing = false
local isPedInVehicle = false
local fishingRod = nil
local blips = {}
local sellersNPCs = {}

-- Menu variables
local RMenu = {}
local sellMenu = false

-- Fonction pour initialiser le framework ESX
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent(Config.ESXEvent, function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
    
    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end
    
    PlayerData = ESX.GetPlayerData()
    
    -- Chargement des blips et des PNJ
    createBlips()
    createSellerNPCs()
end)

-- Mise à jour des données du joueur quand elles changent
RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    PlayerData.job = job
end)

-- Fonction pour créer les blips sur la carte
function createBlips()
    -- Création des blips pour les zones de pêche
    for _, zone in ipairs(Config.FishingZones) do
        local blip = AddBlipForRadius(zone.coords, zone.radius)
        SetBlipColour(blip, zone.color)
        SetBlipAlpha(blip, 128)
        
        local markerBlip = AddBlipForCoord(zone.coords)
        SetBlipSprite(markerBlip, zone.sprite)
        SetBlipDisplay(markerBlip, zone.display)
        SetBlipScale(markerBlip, zone.scale)
        SetBlipColour(markerBlip, zone.color)
        SetBlipAsShortRange(markerBlip, zone.shortRange)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Zone de pêche" .. (zone.illegal and " (Illégale)" or ""))
        EndTextCommandSetBlipName(markerBlip)
        
        table.insert(blips, {blip = blip, markerBlip = markerBlip})
    end
    
    -- Création des blips pour les vendeurs
    local legalBlip = AddBlipForCoord(Config.Sellers.Legal.coords)
    SetBlipSprite(legalBlip, Config.Sellers.Legal.blip.sprite)
    SetBlipDisplay(legalBlip, Config.Sellers.Legal.blip.display)
    SetBlipScale(legalBlip, Config.Sellers.Legal.blip.scale)
    SetBlipColour(legalBlip, Config.Sellers.Legal.blip.color)
    SetBlipAsShortRange(legalBlip, Config.Sellers.Legal.blip.shortRange)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(Config.Sellers.Legal.blip.name)
    EndTextCommandSetBlipName(legalBlip)
    
    local illegalBlip = AddBlipForCoord(Config.Sellers.Illegal.coords)
    SetBlipSprite(illegalBlip, Config.Sellers.Illegal.blip.sprite)
    SetBlipDisplay(illegalBlip, Config.Sellers.Illegal.blip.display)
    SetBlipScale(illegalBlip, Config.Sellers.Illegal.blip.scale)
    SetBlipColour(illegalBlip, Config.Sellers.Illegal.blip.color)
    SetBlipAsShortRange(illegalBlip, Config.Sellers.Illegal.blip.shortRange)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(Config.Sellers.Illegal.blip.name)
    EndTextCommandSetBlipName(illegalBlip)
    
    table.insert(blips, {blip = legalBlip})
    table.insert(blips, {blip = illegalBlip})
end

-- Fonction pour créer les PNJ vendeurs
function createSellerNPCs()
    -- Vendeur légal
    RequestModel(GetHashKey(Config.Sellers.Legal.model))
    while not HasModelLoaded(GetHashKey(Config.Sellers.Legal.model)) do
        Citizen.Wait(1)
    end
    
    local legalNPC = CreatePed(4, GetHashKey(Config.Sellers.Legal.model), Config.Sellers.Legal.coords, Config.Sellers.Legal.heading, false, true)
    SetEntityAsMissionEntity(legalNPC, true, true)
    SetBlockingOfNonTemporaryEvents(legalNPC, true)
    FreezeEntityPosition(legalNPC, true)
    SetEntityInvincible(legalNPC, true)
    
    -- Vendeur illégal
    RequestModel(GetHashKey(Config.Sellers.Illegal.model))
    while not HasModelLoaded(GetHashKey(Config.Sellers.Illegal.model)) do
        Citizen.Wait(1)
    end
    
    local illegalNPC = CreatePed(4, GetHashKey(Config.Sellers.Illegal.model), Config.Sellers.Illegal.coords, Config.Sellers.Illegal.heading, false, true)
    SetEntityAsMissionEntity(illegalNPC, true, true)
    SetBlockingOfNonTemporaryEvents(illegalNPC, true)
    FreezeEntityPosition(illegalNPC, true)
    SetEntityInvincible(illegalNPC, true)
    
    table.insert(sellersNPCs, {npc = legalNPC})
    table.insert(sellersNPCs, {npc = illegalNPC})
end

-- Vérification si le joueur est dans une zone de pêche
function isPlayerInFishingZone()
    local playerCoords = GetEntityCoords(PlayerPedId())
    local inZone = false
    local currentZoneData = nil
    
    for _, zone in ipairs(Config.FishingZones) do
        local distance = #(playerCoords - zone.coords)
        if distance <= zone.radius then
            inZone = true
            currentZoneData = zone
            break
        end
    end
    
    return inZone, currentZoneData
end

-- Fonction pour vérifier si le joueur est près d'un vendeur
function isNearSeller()
    local playerCoords = GetEntityCoords(PlayerPedId())
    local legalDistance = #(playerCoords - Config.Sellers.Legal.coords)
    local illegalDistance = #(playerCoords - Config.Sellers.Illegal.coords)
    
    if legalDistance <= 3.0 then
        return true, "legal"
    elseif illegalDistance <= 3.0 then
        return true, "illegal"
    else
        return false, nil
    end
end

-- Fonction pour afficher une notification
function showNotification(text)
    SetNotificationTextEntry('STRING')
    AddTextComponentString(text)
    DrawNotification(false, true)
end

-- Fonction pour démarrer l'animation de pêche
function startFishingAnimation()
    local playerPed = PlayerPedId()
    
    -- Charger l'animation
    RequestAnimDict(Config.Animations.Dict)
    while not HasAnimDictLoaded(Config.Animations.Dict) do
        Citizen.Wait(100)
    end
    
    -- Créer la canne à pêche
    local propHash = GetHashKey(Config.Animations.Prop.Model)
    RequestModel(propHash)
    while not HasModelLoaded(propHash) do
        Citizen.Wait(100)
    end
    
    -- Attacher la canne à pêche au joueur
    local playerCoords = GetEntityCoords(playerPed)
    fishingRod = CreateObject(propHash, playerCoords.x, playerCoords.y, playerCoords.z + 0.2, true, true, true)
    AttachEntityToEntity(fishingRod, playerPed, GetPedBoneIndex(playerPed, Config.Animations.Prop.Bone), 
        Config.Animations.Prop.Offset.x, Config.Animations.Prop.Offset.y, Config.Animations.Prop.Offset.z, 
        Config.Animations.Prop.Rotation.x, Config.Animations.Prop.Rotation.y, Config.Animations.Prop.Rotation.z, 
        true, true, false, true, 1, true)
    
    -- Lancer l'animation
    TaskPlayAnim(playerPed, Config.Animations.Dict, Config.Animations.Anim, 8.0, -8.0, -1, 49, 0, false, false, false)
end

-- Fonction pour arrêter l'animation de pêche
function stopFishingAnimation()
    local playerPed = PlayerPedId()
    
    -- Supprimer la canne à pêche
    if fishingRod ~= nil then
        DetachEntity(fishingRod, true, true)
        DeleteEntity(fishingRod)
        fishingRod = nil
    end
    
    -- Arrêter l'animation
    ClearPedTasks(playerPed)
end

-- Fonction pour démarrer la pêche
function startFishing(isIllegalZone)
    local playerPed = PlayerPedId()
    local hasItem = false
    local hasBait = false
    local hasIllegalBait = false

    -- Vérifier si le joueur a une canne à pêche
    ESX.TriggerServerCallback('fishing:hasItem', function(result)
        hasItem = result
        
        -- Vérifier si le joueur a un hameçon
        ESX.TriggerServerCallback('fishing:hasItem', function(result)
            hasBait = result
            
            -- Vérifier si le joueur a un hameçon illégal (pour les zones illégales)
            if isIllegalZone then
                ESX.TriggerServerCallback('fishing:hasItem', function(result)
                    hasIllegalBait = result
                    
                    if not hasItem then
                        showNotification(Config.Notifications.no_rod)
                    elseif isIllegalZone and not hasIllegalBait then
                        showNotification(Config.Notifications.no_illegal_bait)
                    elseif not isIllegalZone and not hasBait then
                        showNotification(Config.Notifications.no_bait)
                    else
                        if not isFishing then
                            isFishing = true
                            showNotification(Config.Notifications.started)
                            
                            startFishingAnimation()
                            
                            -- Supprimer un hameçon
                            if isIllegalZone then
                                TriggerServerEvent('fishing:removeBait', Config.Items.IllegalBait)
                            else
                                TriggerServerEvent('fishing:removeBait', Config.Items.NormalBait)
                            end
                            
                            -- Temps d'attente aléatoire avant d'attraper un poisson
                            local catchTime = math.random(Config.Animations.Duration.Min, Config.Animations.Duration.Max)
                            Citizen.Wait(catchTime)
                            
                            -- Vérifier si le joueur est toujours en train de pêcher après le temps d'attente
                            if isFishing then
                                -- Attraper un poisson
                                TriggerServerEvent('fishing:catchFish', isIllegalZone)
                                
                                stopFishingAnimation()
                                isFishing = false
                            end
                        end
                    end
                end, Config.Items.IllegalBait)
            else
                if not hasItem then
                    showNotification(Config.Notifications.no_rod)
                elseif not hasBait then
                    showNotification(Config.Notifications.no_bait)
                else
                    if not isFishing then
                        isFishing = true
                        showNotification(Config.Notifications.started)
                        
                        startFishingAnimation()
                        
                        -- Supprimer un hameçon
                        TriggerServerEvent('fishing:removeBait', Config.Items.NormalBait)
                        
                        -- Temps d'attente aléatoire avant d'attraper un poisson
                        local catchTime = math.random(Config.Animations.Duration.Min, Config.Animations.Duration.Max)
                        Citizen.Wait(catchTime)
                        
                        -- Vérifier si le joueur est toujours en train de pêcher après le temps d'attente
                        if isFishing then
                            -- Attraper un poisson
                            TriggerServerEvent('fishing:catchFish', isIllegalZone)
                            
                            stopFishingAnimation()
                            isFishing = false
                        end
                    end
                end
            end
        end, Config.Items.NormalBait)
    end, Config.Items.FishingRod)
end

-- Événement pour arrêter la pêche
RegisterNetEvent('fishing:stopFishing')
AddEventHandler('fishing:stopFishing', function()
    if isFishing then
        stopFishingAnimation()
        isFishing = false
    end
end)

-- Notification quand un poisson est attrapé
RegisterNetEvent('fishing:fishCaught')
AddEventHandler('fishing:fishCaught', function(fishName, fishWeight)
    if fishName ~= nil then
        showNotification(string.format(Config.Notifications.catch, fishName, fishWeight))
    else
        showNotification(Config.Notifications.nothing)
    end
end)

-- Notification quand des poissons sont vendus
RegisterNetEvent('fishing:fishSold')
AddEventHandler('fishing:fishSold', function(amount, count, fishName)
    if count > 0 then
        if fishName then
            showNotification(string.format(Config.Notifications.sold_item, count, fishName, amount))
        else
            showNotification(string.format(Config.Notifications.sold_all, amount))
        end
    else
        showNotification(Config.Notifications.no_fish)
    end
end)

-- Notification quand l'inventaire est plein
RegisterNetEvent('fishing:inventoryFull')
AddEventHandler('fishing:inventoryFull', function()
    showNotification(Config.Notifications.inventory_full)
end)

-- Fonction pour initialiser le menu RageUI (OPTIMISÉE)
function initSellMenu(sellerType)
    local menuOpen = false
    local playerInventory = nil
    local inventoryTimestamp = 0
    local inventoryCooldown = 2000 -- 2 secondes entre chaque rafraîchissement
    
    RMenu = {
        Main = RageUI.CreateMenu(Config.Menu.Title, Config.Menu.Subtitle)
    }
    
    RMenu.Main:DisplayGlare(true)
    RMenu.Main:SetRectangleBanner(Config.Menu.Color.r, Config.Menu.Color.g, Config.Menu.Color.b, Config.Menu.Color.a)
    
    -- Récupération initiale de l'inventaire
    ESX.TriggerServerCallback('fishing:getInventory', function(inventory)
        playerInventory = inventory
        inventoryTimestamp = GetGameTimer()
        menuOpen = true
        RageUI.Visible(RMenu.Main, true)
        
        -- Thread pour le menu
        Citizen.CreateThread(function()
            while menuOpen do
                Citizen.Wait(0)
                
                RageUI.IsVisible(RMenu.Main, function()
                    -- Option pour vendre tous les poissons
                    RageUI.Button("Vendre tous les poissons", "Vendre tous vos poissons d'un coup", {}, true, {
                        onSelected = function()
                            if sellerType == "legal" then
                                TriggerServerEvent('fishing:sellAllFish', false)
                            else
                                TriggerServerEvent('fishing:sellAllFish', true)
                            end
                            -- Fermer le menu après avoir vendu pour éviter les spam
                            menuOpen = false
                            RageUI.CloseAll()
                        end
                    })
                    
                    -- Séparateur
                    RageUI.Separator("↓ Vendre les poissons individuellement ↓")
                    
                    -- Utiliser l'inventaire stocké au lieu de faire un appel serveur à chaque frame
                    if playerInventory then
                        local hasFish = false
                        
                        -- Affichage des poissons légaux
                        if sellerType == "legal" then
                            for _, fish in ipairs(Config.Fishes.Legal) do
                                for i=1, #playerInventory.items, 1 do
                                    if playerInventory.items[i].name == fish.item then
                                        if playerInventory.items[i].count > 0 then
                                            hasFish = true
                                            RageUI.Button(fish.name .. " (" .. playerInventory.items[i].count .. ")", "Prix: $" .. fish.price .. " chacun", {}, true, {
                                                onSelected = function()
                                                    TriggerServerEvent('fishing:sellFish', fish.item, fish.price, false)
                                                    -- Rafraîchir l'inventaire immédiatement après la vente
                                                    refreshInventory()
                                                end
                                            })
                                        end
                                    end
                                end
                            end
                        end
                        
                        -- Affichage des poissons illégaux
                        if sellerType == "illegal" then
                            for _, fish in ipairs(Config.Fishes.Illegal) do
                                for i=1, #playerInventory.items, 1 do
                                    if playerInventory.items[i].name == fish.item then
                                        if playerInventory.items[i].count > 0 then
                                            hasFish = true
                                            RageUI.Button(fish.name .. " (" .. playerInventory.items[i].count .. ")", "Prix: $" .. fish.price .. " chacun", {}, true, {
                                                onSelected = function()
                                                    TriggerServerEvent('fishing:sellFish', fish.item, fish.price, true)
                                                    -- Rafraîchir l'inventaire immédiatement après la vente
                                                    refreshInventory()
                                                end
                                            })
                                        end
                                    end
                                end
                            end
                            
                            -- Affichage des poissons légaux chez le vendeur illégal (avec réduction)
                            for _, fish in ipairs(Config.Fishes.Legal) do
                                for i=1, #playerInventory.items, 1 do
                                    if playerInventory.items[i].name == fish.item then
                                        if playerInventory.items[i].count > 0 then
                                            hasFish = true
                                            local reducedPrice = math.floor(fish.price * 0.7)  -- 70% du prix normal
                                            RageUI.Button(fish.name .. " (" .. playerInventory.items[i].count .. ")", "Prix: $" .. reducedPrice .. " chacun", {}, true, {
                                                onSelected = function()
                                                    TriggerServerEvent('fishing:sellFish', fish.item, reducedPrice, true)
                                                    -- Rafraîchir l'inventaire immédiatement après la vente
                                                    refreshInventory()
                                                end
                                            })
                                        end
                                    end
                                end
                            end
                        end
                        
                        if not hasFish then
                            RageUI.Button("Aucun poisson à vendre", nil, {}, true, {})
                        end
                    else
                        RageUI.Button("Chargement de l'inventaire...", nil, {}, true, {})
                    end
                end)
                
                -- Vérifier si le menu est fermé
                if not RageUI.Visible(RMenu.Main) then
                    menuOpen = false
                    break
                end
                
                -- Rafraîchir l'inventaire périodiquement avec un cooldown
                local currentTime = GetGameTimer()
                if currentTime - inventoryTimestamp > inventoryCooldown then
                    refreshInventory()
                end
            end
        end)
    end)
    
    -- Fonction locale pour rafraîchir l'inventaire
    function refreshInventory()
        ESX.TriggerServerCallback('fishing:getInventory', function(inventory)
            playerInventory = inventory
            inventoryTimestamp = GetGameTimer()
        end)
    end
    
    sellMenu = menuOpen
    return menuOpen
end

-- Thread principal
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(15)
        
        -- Vérifier si le joueur est dans une zone de pêche
        local inZone, zoneData = isPlayerInFishingZone()
        isInZone = inZone
        currentZone = zoneData
        
        -- Vérifier si le joueur est dans un véhicule
        isPedInVehicle = IsPedInAnyVehicle(PlayerPedId(), false)
        
        local isNear, sellerType = isNearSeller()
        
        -- Afficher le texte d'aide pour la pêche
        if isInZone and not isPedInVehicle and not isFishing then
            local text = "Appuyez sur ~INPUT_CONTEXT~ pour commencer à pêcher"
            if currentZone.illegal then
                text = text .. " (Hameçon illégal requis)"
            end
            ESX.ShowHelpNotification(text)
            
            -- Démarrer la pêche
            if IsControlJustReleased(0, 38) then  -- E key
                if isInZone then
                    startFishing(currentZone.illegal)
                else
                    showNotification(Config.Notifications.not_in_zone)
                end
            end
        end
        
        -- Afficher le texte d'aide pour vendre des poissons
        if isNear and not isPedInVehicle then
            ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour vendre vos poissons")
            
            -- Ouvrir le menu de vente
            if IsControlJustReleased(0, 38) then  -- E key
                if not sellMenu then  -- Vérifier que le menu n'est pas déjà ouvert
                    sellMenu = initSellMenu(sellerType)
                end
            end
        end
        
        -- Fermer le menu quand le joueur s'éloigne
        if sellMenu and not isNear then
            sellMenu = false
            RageUI.CloseAll()
        end
        
        -- Arrêter la pêche si le joueur sort de la zone ou monte dans un véhicule
        if isFishing and (not isInZone or isPedInVehicle) then
            stopFishingAnimation()
            isFishing = false
            showNotification("Pêche interrompue")
        end
    end
end)

-- Thread optimisé pour les vérifications moins fréquentes
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(500)
        
        -- Vérifier si la touche pour arrêter la pêche est pressée
        if isFishing and IsControlJustReleased(0, 73) then  -- X key
            stopFishingAnimation()
            isFishing = false
            showNotification("Pêche interrompue")
        end
    end
end)

-- Nettoyer les ressources au déchargement du script
AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        -- Supprimer les blips
        for _, blipData in ipairs(blips) do
            if blipData.blip ~= nil then
                RemoveBlip(blipData.blip)
            end
            if blipData.markerBlip ~= nil then
                RemoveBlip(blipData.markerBlip)
            end
        end
        
        -- Supprimer les PNJ
        for _, npcData in ipairs(sellersNPCs) do
            if npcData.npc ~= nil then
                DeleteEntity(npcData.npc)
            end
        end
        
        -- Arrêter l'animation et supprimer la canne à pêche
        if isFishing then
            stopFishingAnimation()
        end
        
        -- Fermer les menus
        if sellMenu then
            sellMenu = false
            RageUI.CloseAll()
        end
    end
end)