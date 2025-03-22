-- Outils
INSERT INTO `items` (`name`, `label`, `weight`, `rare`, `can_remove`) VALUES
('fishing_rod', 'Canne à pêche', 1, 0, 1);
('fishing_bait', 'Hameçon', 0.1, 0, 1);
('illegal_bait', 'Hameçon illégal', 0.1, 1, 1);

-- Legal
INSERT INTO `items` (`name`, `label`, `weight`, `rare`, `can_remove`) VALUES
('fish_1', 'Perche', 1.0, 0, 1),
('fish_2', 'Truite', 1.5, 0, 1),
('fish_3', 'Brochet', 3.0, 0, 1),
('fish_4', 'Achigan', 2.0, 0, 1),
('fish_5', 'Carpe', 4.0, 0, 1),
('fish_6', 'Anguille', 1.0, 0, 1),
('fish_7', 'Saumon', 5.0, 0, 1),
('fish_8', 'Esturgeon', 7.0, 0, 1);

-- Illegal 
INSERT INTO `items` (`name`, `label`, `weight`, `rare`, `can_remove`) VALUES
('illegal_fish_1', 'Requin-marteau', 15.0, 1, 1),
('illegal_fish_2', 'Napoléon', 10.0, 1, 1);