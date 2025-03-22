Config = {}

-- Configuration globale
Config.Debug = false  -- Activer/désactiver le mode debug
Config.Framework = 'ESX'  -- Framework utilisé (ESX uniquement pour l'instant)
Config.ESXEvent = "esx:getSharedObject"  -- Événement ESX pour obtenir l'objet partagé
Config.Locale = 'fr'  -- Langue par défaut

-- Configuration des items
Config.Items = {
    FishingRod = 'fishingrod',  -- Item unique
    NormalBait = 'fishing_bait',  -- Consommable
    IllegalBait = 'illegal_bait',  -- Consommable
}

-- Configuration des animations
Config.Animations = {
    Dict = "amb@world_human_stand_fishing@idle_a",
    Anim = "idle_c",
    Prop = {
        Model = "prop_fishing_rod_01",
        Bone = 60309,
        Offset = vector3(0.0, 0.0, 0.0),
        Rotation = vector3(0.0, 0.0, 0.0)
    },
    Duration = {
        Min = 5000,  -- Durée minimale pour attraper un poisson (en ms)
        Max = 15000  -- Durée maximale pour attraper un poisson (en ms)
    }
}

-- Configuration des zones de pêche
Config.FishingZones = {
    {
        name = "Alamo Sea",
        coords = vector3(1301.73, 4217.38, 33.91),
        radius = 120.0,
        color = 3,  -- Couleur du blip (bleu)
        sprite = 68,  -- Sprite du blip (poisson)
        scale = 0.8,  -- Échelle du blip
        display = 4,  -- Type d'affichage du blip
        shortRange = true,  -- Blip visible seulement à courte distance
        illegal = false  -- Zone légale
    },
    {
        name = "Cassidy Creek",
        coords = vector3(712.68, 4170.11, 40.52),
        radius = 80.0,
        color = 3,
        sprite = 68,
        scale = 0.8,
        display = 4,
        shortRange = true,
        illegal = false
    },
    {
        name = "El Gordo Lighthouse",
        coords = vector3(3866.46, 4463.92, 2.72),
        radius = 100.0,
        color = 3,
        sprite = 68,
        scale = 0.8,
        display = 4,
        shortRange = true,
        illegal = false
    },
    {
        name = "Eaux Profondes",
        coords = vector3(4435.87, 4829.44, 0.34),
        radius = 150.0,
        color = 1,  -- Rouge pour zone illégale
        sprite = 68,
        scale = 0.8,
        display = 4,
        shortRange = true,
        illegal = true  -- Zone illégale
    }
}

-- Configuration des poissons
Config.Fishes = {
    Legal = {
        {name = "Perche", item = "fish_1", chance = 25, price = 45, weight = {min = 0.5, max = 2.5}},
        {name = "Truite", item = "fish_2", chance = 20, price = 55, weight = {min = 1.0, max = 3.0}},
        {name = "Brochet", item = "fish_3", chance = 15, price = 75, weight = {min = 2.0, max = 7.0}},
        {name = "Achigan", item = "fish_4", chance = 15, price = 65, weight = {min = 1.0, max = 4.0}},
        {name = "Carpe", item = "fish_5", chance = 10, price = 85, weight = {min = 3.0, max = 10.0}},
        {name = "Anguille", item = "fish_6", chance = 10, price = 90, weight = {min = 0.5, max = 2.0}},
        {name = "Saumon", item = "fish_7", chance = 3, price = 120, weight = {min = 4.0, max = 8.0}},
        {name = "Esturgeon", item = "fish_8", chance = 2, price = 180, weight = {min = 5.0, max = 15.0}},
    },
    Illegal = {
        {name = "Requin-marteau", item = "illegal_fish_1", chance = 70, price = 350, weight = {min = 20.0, max = 40.0}},
        {name = "Napoléon", item = "illegal_fish_2", chance = 30, price = 450, weight = {min = 5.0, max = 15.0}},
    }
}

-- Configuration des vendeurs
Config.Sellers = {
    Legal = {
        coords = vector3(-1037.588745, -1397.167236, 4.553191),
        heading = 71.11415100097656,
        model = "s_m_m_dockwork_01",
        blip = {
            sprite = 356,  -- Sprite du blip (magasin)
            color = 3,  -- Couleur du blip (bleu)
            scale = 0.8,  -- Échelle du blip
            display = 4,  -- Type d'affichage du blip
            shortRange = true,  -- Blip visible seulement à courte distance
            name = "Vendeur de poissons"  -- Nom du blip
        }
    },
    Illegal = {
        coords = vector3(598.469116, 2785.985107, 41.191921),
        heading = 358.8505554199219,
        model = "g_m_y_lost_01",
        blip = {
            sprite = 356,  -- Sprite du blip (magasin)
            color = 1,  -- Couleur du blip (rouge)
            scale = 0.8,  -- Échelle du blip
            display = 4,  -- Type d'affichage du blip
            shortRange = true,  -- Blip visible seulement à courte distance
            name = "Receleur de poissons rares"  -- Nom du blip
        }
    }
}

-- Configuration des menus
Config.Menu = {
    Title = "Pêche",
    Subtitle = "Système de pêche",
    Color = {r = 0, g = 0, b = 0, a = 0}
}

-- Configuration des notifications
Config.Notifications = {
    started = "Vous avez commencé à pêcher...",
    no_rod = "Vous n'avez pas de canne à pêche!",
    no_bait = "Vous n'avez pas d'hameçon!",
    no_illegal_bait = "Vous n'avez pas d'hameçon illégal!",
    not_in_zone = "Vous n'êtes pas dans une zone de pêche!",
    illegal_zone = "Cette zone de pêche nécessite un hameçon illégal!",
    catch = "Vous avez attrapé un(e) %s de %.2f kg!",
    nothing = "Vous n'avez rien attrapé cette fois-ci...",
    sold_all = "Vous avez vendu tous vos poissons pour $%s!",
    sold_item = "Vous avez vendu %sx %s pour $%s!",
    no_fish = "Vous n'avez pas de poisson à vendre!",
    inventory_full = "Votre inventaire est plein!"
}
