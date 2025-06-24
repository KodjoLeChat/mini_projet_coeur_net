# Test technique – [Cœur-Net](https://www.coeur-net.fr/auth.html)

## Sujet initial (extrait)

Mettre en place une architecture microservices :

- **Une base de données Supabase**
- **Une API FastAPI en Python**
- **Un frontend (React, Flutter ou autre framework)**
- **Une interface d’administration (CRUD)**
  - Chaque utilisateur peut gérer **ses propres données**
  - L’administrateur peut gérer **toutes les données**
- **Une API permettant de générer un tenseur PyTorch aléatoire**
- **Une visualisation graphique du tenseur côté frontend**

**Utiliser les mécanismes intégrés à Supabase pour la gestion des comptes et de la sécurité** :

- **JWT**
- **OAuth2**

## Description

Ce projet est un **test technique** dans le cadre du processus de recrutement pour un poste d'**ingénieur logiciel** chez [**Cœur-Net**](https://www.coeur-net.fr/auth.html).  
Il consiste à créer une application web **full-stack** from scratch, composée de :

- Un frontend en **Flutter**
- Une API REST construite avec **FastAPI**
- Une base de données fournie par **Supabase**, utilisée à la fois pour le stockage et l’authentification (via JWT)

## Fonctionnalités

### Authentification

- Connexion et déconnexion sécurisées via Supabase Auth
- Utilisation des tokens **JWT** pour sécuriser les routes backend

### Vue Tensor

- Appel d'une API qui retourne un **tenseur PyTorch aléatoire (10 valeurs)**
- Affichage dynamique dans un **graphique interactif**

### Tâches

- Liste des tâches personnelles
- Liste de **toutes les tâches (admin uniquement)**
- **CRUD complet** sur les tâches :
  - Création
  - Modification (seulement ses tâches sauf pour admin)
  - Suppression (seulement ses tâches sauf pour admin)

### Profils

- Affichage de son propre profil
- Liste de **tous les profils (admin uniquement)**
- **CRUD complet sur les profils :**
  - Ajout d’un utilisateur (admin uniquement)
  - Modification de son propre profil (admin peut modifier tous)
  - Suppression d’un utilisateur (admin uniquement)

## Objectifs techniques

- Structurer une application modulaire en Flutter (state management via Riverpod)
- Concevoir une API REST sécurisée avec FastAPI (middlewares, JWT, rôle-based access)
- Exploiter les services intégrés de **Supabase** (auth, base de données, Row Level Security)
- Visualiser des données tensorielles dans Flutter avec des composants interactifs
- Créer une interface utilisateur claire, réactive et adaptée à chaque rôle

**[Voir une démo en vidéo](https://drive.google.com/file/d/1ZKNvu3q0Qv5Voe1aIdQmqwkHbQrO56ba/view?usp=sharing)**

**Application en ligne** : [https://coeur-net.web.app](https://coeur-net.web.app)

## Structure du projet

### Frontend (Flutter)

```
lib/
├── models/ # Modèles de données (User, Task, etc.)
├── notifiers/ # Notifiers pour Riverpod
├── providers/ # Providers pour gestion d'état
├── repositories/ # Logique de communication avec l’API
├── router/ # Routage et navigation
├── services/ # Services (auth, local storage…)
├── utils/ # Outils génériques
└── views/ # Vues et interfaces utilisateur
```

### Backend (FastAPI)

```
app/
├── api/ # Routes de l'API (tâches, utilisateurs, tensor…)
├── models/ # Schémas de données (Pydantic)
├── security/ # Middleware et vérification des JWT
├── services/ # Services métiers (auth, tâches…)
└── utils/ # Fonctions utilitaires
```

### Sécurité et authentification

L'authentification repose sur Supabase Auth avec support JWT.
L’API FastAPI utilise une validation via Authorization: Bearer <token> dans les headers pour chaque appel.

Des vérifications de rôles (admin ou user) sont effectuées sur toutes les routes pour limiter l’accès à certains endpoints (ex. suppression de profil ou de tâche).

## Installation

### Prérequis

- **Flutter ≥ 3.29.2** → [Installer Flutter](https://docs.flutter.dev/get-started/install)
- **Python ≥ 3.13.3** → [Installer Python](https://www.python.org/downloads/)
- **Supabase** (compte + projet configuré)

### Dépendances Flutter

(Déjà listées dans `pubspec.yaml`)

### Dépendances Python

Toutes les dépendances backend sont dans le fichier requirements.txt. Pour les installer :

pip install -r requirements.txt

## Déploiement

### Frontend Flutter – Firebase Hosting

Prérequis : compte Firebase, Firebase CLI installé

```bash
flutter build web --release
firebase login
firebase init hosting
# Sélectionner 'web/build' comme dossier
firebase deploy
```

### Backend FastAPI – Render.com

Prérequis : compte sur [https://render.com](https://render.com)

1. Créer un nouveau **Web Service** sur Render
2. Connecter le repo Git contenant le backend
3. Configuration recommandée :

```txt
Start command: uvicorn app.main:app --host 0.0.0.0 --port 10000
Build command: pip install -r requirements.txt
Environment: Python 3.11+
```

4. Ajouter les variables d’environnement nécessaires :
   - `SUPABASE_URL`
   - `SUPABASE_SERVICE_ROLE_KEY`
   - `JWT_SECRET_KEY` (pour FastAPI)
   - etc.

Accessible à une URL du type : `https://mini-projet-coeur-net.onrender.com`

---

## Installation locale (dev)

### Requis

- **Flutter >= 3.29.2**
- **Python >= 3.13.3**
- **Supabase** (compte + projet configuré)

### Flutter (frontend)

```bash
flutter pub get
flutter run -d chrome
```

### Python (backend)

```bash
python -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
uvicorn app.main:app --reload
```

## Auteur

- **Pérès ALLAÏSSEM (Kodjo le chat)** - [LinkedIn](https://www.linkedin.com/in/p%C3%A9r%C3%A8s-alla%C3%AFssem-755901217/)
