# Projet MIAGEDv1.3

Réalisé dans le cadre du Master 2 Intense (2021-2022) par François Hardy
Le MVP est 100 % fonctionnel et a été réalisé comme indiqué.
Le code suit une architecture et ai commenté.

# Fonctionnalités supplémentaires

De manière générale, une attention a été appliquée sur la gestion des erreurs et en cas de manque d'informations sur les profils ou des vêtements.

## Les différentes pages

### Page de connexion

- Design
    - Des cadres pour le login/mot de passe
    - Un chargement avant d'afficher la page, une fois que l'utilisateur a cliqué sur "Se connecter"
    - Les images sur chaque produits
    - Un bouton bleu

- Fonctionnalités
    - Le bouton "Mot de passe oublié", qui n'est pas développé, affiche seulement une pop-up
    - Une vérification de ce que l'utilisateur a entré (limitation de caractères)
    - Une pop-up indiquant si les identifiants sont incorrects
    - Un bouton fonctionnel permettant de créer son compte

### Page d'inscription

- Design
    - Des cadres pour les différents champs
    - Un bouton bleu
  
- Fonctionnalités
    - Vérification de la longueur des données entrées

### Page d'achat

- Design
    - Utilisation de photos
    - Cadres avec ombres, 2 par ligne
  
- Fonctionnalités
    - Une gestion des informations manquantes dans les produits (voir le produit "Echarpe")
    - Un bouton d'action, permettant d'ajouter un vetement (implementation manquante : ajout en base)

### Page du panier

- Design
  - Cadres avec ombres, 1 par ligne
  
- Fonctionnalités
  - Panier automatiquement actualisé et gestion d'erreur de chargement en affichant un bouton pour actualiser
  - Si deux personnes sont connectées sur le même compte, actualisation possible en tirant vers le bas

### Page du profil

- Design
  - Cadres dynamiques
  
- Fonctionnalités
  - Gestion des erreurs
  - Affichage d'un message d'actualisation
  - Calendrier pour la date