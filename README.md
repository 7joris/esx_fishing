# Script de Pêche pour FiveM avec ESX

## 📦 Installation

1. **Téléchargement et extraction**
    - Téléchargez les fichiers du script.
    - Extrayez le dossier dans votre répertoire `resources`.

2. **Base de Données**
    - Importez le fichier `install.sql` dans votre base de données MySQL.

3. **Configuration**
    - Ouvrez le fichier `config.lua` et personnalisez les options selon vos préférences (prix des items, zones de pêche, etc.).

4. **Démarrage du Script**
    - Ajoutez `ensure esx_fishing` dans votre `server.cfg`.

---

## ⚙️ Fonctionnalités

- **Items**
  - `fishing_rod` : Canne à pêche unique et non consommable.
  - `fishing_bait` : Hameçon consommable pour la pêche normale.
  - `illegal_bait` : Hameçon consommable pour pêcher des poissons rares et illégaux.

- **Système de Pêche**
  - 8 espèces de poissons à pêcher aléatoirement.
  - Possibilité de pêcher des poissons rares et illégaux avec un hameçon illégal.
  - Système d’attente aléatoire pour plus de réalisme.
  - Poids aléatoire pour chaque poissons. 

- **Zones de Pêche**
  - Blips visibles sur la carte pour les zones de pêche.
  - Seules ces zones permettent d'utiliser la canne à pêche.

- **Revente de Poissons**
  - Point de revente légal pour les poissons normaux.
  - Point de revente illégal pour les poissons rares et illégaux.
  - Menus interactifs avec RageUI.

---

## 🛠️ Configuration

Personnalisez les éléments suivants dans `config.lua` :

- **Zones de Pêche** : Coordonnées, tailles et blips.
- **Prix des Items** : Ajustez les prix des hameçons et des poissons.
- **Temps d’Attente** : Configurez la durée aléatoire pour attraper un poisson.
- **Probabilités** : Réglez les chances d’attraper des poissons rares.

---

## 🧑‍💻 Compatibilité

- Compatible avec la dernière version d’ESX.
- Optimisé pour assurer des performances maximales (0.01ms).

---

## 💡 Crédits

- Développé par Joris.
- Merci d’utiliser ce script et de contribuer à son amélioration.

---

## ⚠️ Support

Pour toute question ou problème, n’hésitez pas à me dm sur discord : 7joris.
