# Remote Shutdown App

## Description
**Remote Shutdown App** est un projet qui combine un serveur **Flask** pour exécuter des commandes d'arrêt à distance sur un PC, et une application mobile **Flutter** qui sert d'interface utilisateur. L'application permet à un utilisateur de :

- **Éteindre immédiatement** son PC.
- **Planifier un arrêt dans un délai spécifié** (par exemple, dans 10 minutes).

Le projet est composé de deux parties :
1. Un serveur **Flask** hébergé sur le PC pour recevoir les commandes d'arrêt.
2. Une application **Flutter** qui communique avec ce serveur.

L'application est entièrement **open-source**.

---

## Prérequis
### **Outils Nécessaires**
1. **Python 3.x** et **Flask** pour le serveur.
2. **Flutter SDK** pour l'application mobile.
3. **Android Studio** ou **VS Code** pour développer et exécuter l'application.
4. **Git** pour la gestion de version.
5. Un PC Windows (pour les commandes shutdown).
6. Un iPhone ou un émulateur iOS (pour tester l'application Flutter).

### **Commandes Préliminaires**
- Assure-toi que **Flask** est installé :
  ```bash
  pip install flask
  ```
- Installe **Flutter** :
  Suis les instructions d'installation sur [flutter.dev](https://flutter.dev).

- Vérifie que Flutter est installé :
  ```bash
  flutter doctor
  ```

---

## Arborescence du Projet
Voici la structure globale du projet :

```
SHUTDOWNPCWITHIPHONE/
├── client/                       # Application Flutter
│   ├── assets/                   # Images et icônes
│   │   └── shutdown_icon.png     # Icône personnalisée
│   ├── lib/                      # Code source Flutter
│   │   ├── main.dart             # Code principal de l'application
│   ├── test/                     # Tests unitaires Flutter
│   │   └── widget_test.dart      # Tests de l'interface
│   ├── pubspec.yaml              # Configuration Flutter
│   └── ...
│
└── server/                       # Serveur Flask
    └── app.py                    # Code principal du serveur
```

---

## Serveur Flask
### **Code Serveur Flask**
Le serveur Flask (écrit dans `app.py`) s'occupe de recevoir des requêtes HTTP pour éteindre le PC.

**Fonctionnalités** :
- **/shutdown-now** : Arrête immédiatement le PC.
- **/shutdown-delay?minutes=X** : Arrête le PC après X minutes.

### **Démarrage du Serveur**
1. Va dans le dossier `server/` :
   ```bash
   cd server
   ```
2. Lance le serveur Flask :
   ```bash
   python app.py
   ```
3. **Sortie attendue** :
   ```
   * Running on http://0.0.0.0:5000
   ```
4. Assure-toi que l'IP est utilisable sur ton réseau local (par exemple `192.168.0.92`).

---

## Application Flutter
### **Fonctionnement de l'Application**
L'application Flutter communique avec le serveur Flask via des requêtes HTTP GET.

### **Fonctions Principales**
1. **Bouton « Éteindre Maintenant »** : Envoie une requête au serveur pour arrêter le PC immédiatement.
2. **Bouton « Éteindre dans 10 Minutes »** : Envoie une requête avec un délai.
3. **Paramètres de connexion** : Configuration dynamique de l'adresse IP et du mot de passe.

### **Design Modernisé**
- **Gradient dans l'AppBar**.
- **Cartes avec bordures arrondies**.
- **Boutons avec icônes** et effets d'animation grâce à `flutter_animate`.

### **Fichier `pubspec.yaml`**
Ajoute les dépendances nécessaires :
```yaml
dependencies:
  flutter:
    sdk: flutter
  http: ^1.2.0
  flutter_animate: ^4.2.0

flutter:
  uses-material-design: true
  assets:
    - assets/shutdown_icon.png
```

---

## Instructions d'Installation
### **Serveur Flask**
1. Clone le projet :
   ```bash
   git clone <lien-github>
   ```
2. Installe Flask :
   ```bash
   pip install flask
   ```
3. Lance le serveur Flask :
   ```bash
   python server/app.py
   ```

### **Application Flutter**
1. Accède au dossier `client/` :
   ```bash
   cd client
   ```
2. Installe les dépendances Flutter :
   ```bash
   flutter pub get
   ```
3. Lance l'application :
   ```bash
   flutter run
   ```
4. Teste l'application sur ton téléphone (iOS ou Android).

---

## Exécution du Projet
1. **Lance le serveur Flask** sur ton PC Windows.
2. **Exécute l'application Flutter** sur ton téléphone.
3. Assure-toi que ton PC et ton téléphone sont connectés au même réseau local.
4. Appuie sur les boutons pour tester les fonctionnalités !

---

## Fonctionnalités
- Éteindre immédiatement le PC.
- Planifier l'arrêt avec un délai de 10 minutes.
- Configuration dynamique de l'IP et du mot de passe.
- Feedback visuel pour les commandes envoyées.

✅

