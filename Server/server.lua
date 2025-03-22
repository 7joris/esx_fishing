-- ESX
local ESX = nil

TriggerEvent(Config.ESXEvent, function(obj) ESX = obj end)

-- Vérifier si le joueur a un item spécifique
ESX.RegisterServerCallback('fishing:hasItem', function(source, cb, item)
    local xPlayer = ESX.GetPlayerFromId(source)
    local itemCount = xPlayer.getInventoryItem(item).count
    
    cb(itemCount > 0)
end)

-- Récupérer l'inventaire du joueur
ESX.RegisterServerCallback('fishing:getInventory', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local items = xPlayer.inventory
    
    cb({items = items})
end)

-- Supprimer un hameçon lorsqu'il est utilisé
RegisterServerEvent('fishing:removeBait')
AddEventHandler('fishing:removeBait', function(baitItem)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem(baitItem, 1)
end)

-- Fonction pour attraper un poisson
RegisterServerEvent('fishing:catchFish')
AddEventHandler('fishing:catchFish', function(isIllegalZone)
    local xPlayer = ESX.GetPlayerFromId(source)
    local fishList = isIllegalZone and Config.Fishes.Illegal or Config.Fishes.Legal
    local totalChance = 0
    
    -- Calculer la chance totale
    for _, fish in ipairs(fishList) do
        totalChance = totalChance + fish.chance
    end
    
    -- Générer un nombre aléatoire entre 0 et la chance totale
    local randomChance = math.random(0, totalChance)
    local currentChance = 0
    local catchedFish = nil
    
    -- Déterminer quel poisson a été pêché
    for _, fish in ipairs(fishList) do
        currentChance = currentChance + fish.chance
        if randomChance <= currentChance then
            catchedFish = fish
            break
        end
    end
    
    -- 15% de chance de ne rien attraper
    local nothingChance = math.random(1, 100)
    if nothingChance <= 15 then
        TriggerClientEvent('fishing:fishCaught', source, nil, nil)
        return
    end
    
    -- Vérifier si le joueur a assez de place dans son inventaire
    if catchedFish then
        local canCarry = xPlayer.canCarryItem(catchedFish.item, 1)
        
        if canCarry then
            -- Générer un poids aléatoire pour le poisson
            local fishWeight = math.random(catchedFish.weight.min * 100, catchedFish.weight.max * 100) / 100
            
            -- Ajouter le poisson à l'inventaire du joueur
            xPlayer.addInventoryItem(catchedFish.item, 1)
            
            -- Notifier le joueur
            TriggerClientEvent('fishing:fishCaught', source, catchedFish.name, fishWeight)
        else
            TriggerClientEvent('fishing:inventoryFull', source)
            TriggerClientEvent('fishing:fishCaught', source, nil, nil)
        end
    end
end)

-- Fonction pour vendre un poisson spécifique
RegisterServerEvent('fishing:sellFish')
AddEventHandler('fishing:sellFish', function(fishItem, fishPrice, isIllegal)
    local xPlayer = ESX.GetPlayerFromId(source)
    local fishCount = xPlayer.getInventoryItem(fishItem).count
    
    if fishCount > 0 then
        -- Déterminer le nom du poisson
        local fishName = nil
        local fishList = Config.Fishes.Legal
        
        for _, fish in ipairs(fishList) do
            if fish.item == fishItem then
                fishName = fish.name
                break
            end
        end
        
        if not fishName then
            fishList = Config.Fishes.Illegal
            for _, fish in ipairs(fishList) do
                if fish.item == fishItem then
                    fishName = fish.name
                    break
                end
            end
        end
        
        -- Calculer le montant total
        local amount = fishCount * fishPrice
        
        -- Supprimer le poisson et ajouter l'argent
        xPlayer.removeInventoryItem(fishItem, fishCount)
        xPlayer.addMoney(amount)
        
        -- Notifier le joueur
        TriggerClientEvent('fishing:fishSold', source, amount, fishCount, fishName)
        
        -- Log (optionnel)
        if Config.Debug then
            print(string.format("[FISHING] %s a vendu %d %s pour $%d", GetPlayerName(source), fishCount, fishName, amount))
        end
    else
        TriggerClientEvent('fishing:fishSold', source, 0, 0, nil)
    end
end)

-- Fonction pour vendre tous les poissons
RegisterServerEvent('fishing:sellAllFish')
AddEventHandler('fishing:sellAllFish', function(isIllegal)
    local xPlayer = ESX.GetPlayerFromId(source)
    local totalAmount = 0
    local soldItems = 0
    
    -- Vendre tous les poissons légaux
    for _, fish in ipairs(Config.Fishes.Legal) do
        local fishCount = xPlayer.getInventoryItem(fish.item).count
        
        if fishCount > 0 then
            -- Calculer le prix (réduit si vendu au receleur)
            local price = fish.price
            if isIllegal then
                price = math.floor(price * 0.7)  -- 70% du prix normal
            end
            
            local amount = fishCount * price
            
            -- Supprimer le poisson et compter l'argent
            xPlayer.removeInventoryItem(fish.item, fishCount)
            totalAmount = totalAmount + amount
            soldItems = soldItems + fishCount
        end
    end
    
    -- Vendre tous les poissons illégaux (uniquement au receleur)
    if isIllegal then
        for _, fish in ipairs(Config.Fishes.Illegal) do
            local fishCount = xPlayer.getInventoryItem(fish.item).count
            
            if fishCount > 0 then
                local amount = fishCount * fish.price
                
                -- Supprimer le poisson et compter l'argent
                xPlayer.removeInventoryItem(fish.item, fishCount)
                totalAmount = totalAmount + amount
                soldItems = soldItems + fishCount
            end
        end
    end
    
    -- Ajouter l'argent total
    if totalAmount > 0 then
        xPlayer.addAccountMoney('cash', totalAmount)
    end
    
    -- Notifier le joueur
    TriggerClientEvent('fishing:fishSold', source, totalAmount, soldItems, nil)
    
    -- Log (optionnel)
    if Config.Debug and totalAmount > 0 then
        print(string.format("[FISHING] %s a vendu %d poissons pour $%d", GetPlayerName(source), soldItems, totalAmount))
    end
end)

-- Command pour donner les items de pêche (pour les tests)
RegisterCommand('giverequiredfish', function(source, args, rawCommand)
    if source == 0 then return end -- Bloquer la console
    
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getGroup() == 'fondateur' then
        xPlayer.addInventoryItem(Config.Items.FishingRod, 1)
        xPlayer.addInventoryItem(Config.Items.NormalBait, 20)
        xPlayer.addInventoryItem(Config.Items.IllegalBait, 10)
        
        TriggerClientEvent('esx:showNotification', source, 'Vous avez reçu les items de pêche.')
    else
        TriggerClientEvent('esx:showNotification', source, 'Vous n\'êtes pas autorisé à utiliser cette commande.')
    end
end, false)

-- Commande pour donner des poissons pour tester la vente (pour les tests)
RegisterCommand('givetestfish', function(source, args, rawCommand)
    if source == 0 then return end -- Bloquer la console
    
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getGroup() == 'fondateur' then
        -- Donner quelques poissons légaux
        for _, fish in ipairs(Config.Fishes.Legal) do
            xPlayer.addInventoryItem(fish.item, 3)
        end
        
        -- Donner quelques poissons illégaux
        for _, fish in ipairs(Config.Fishes.Illegal) do
            xPlayer.addInventoryItem(fish.item, 2)
        end
        
        TriggerClientEvent('esx:showNotification', source, 'Vous avez reçu des poissons pour tester la vente.')
    else
        TriggerClientEvent('esx:showNotification', source, 'Vous n\'êtes pas autorisé à utiliser cette commande.')
    end
end, false)