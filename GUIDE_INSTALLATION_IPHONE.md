# Guide d'Installation sur iPhone (Sans Mac)

## 📱 Options Disponibles

### Option 1 : AltStore (GRATUIT - Recommandé) ⭐

**AltStore** permet d'installer des applications iOS sans compte développeur Apple payant.

#### Prérequis :
- Un ordinateur Windows (vous en avez un ✅)
- iTunes installé (ou Apple Mobile Device Support)
- Votre iPhone connecté en USB

#### Étapes :

1. **Télécharger AltStore** :
   - Allez sur https://altstore.io
   - Téléchargez AltServer pour Windows
   - Installez AltServer

2. **Installer AltStore sur iPhone** :
   - Connectez votre iPhone à votre PC
   - Lancez AltServer
   - Cliquez sur l'icône AltServer dans la barre système
   - Sélectionnez "Install AltStore" → votre iPhone
   - Entrez votre Apple ID (gratuit)

3. **Installer l'IPA** :
   - Déclenchez le workflow "Build iOS App for Device" sur GitHub Actions
   - Téléchargez `AR3DScan.ipa` depuis les artefacts
   - Ouvrez le fichier avec AltStore (depuis votre iPhone)
   - Ou transférez via AirDrop/iCloud Drive

**Note** : L'app doit être resignée toutes les 7 jours via AltStore.

---

### Option 2 : TestFlight (Nécessite compte développeur - 99$/an)

Si vous avez un compte développeur Apple :

1. Utilisez GitHub Actions pour builder et uploader vers TestFlight
2. Installez TestFlight sur votre iPhone
3. Rejoignez la beta via le lien TestFlight

---

## 🚀 Étapes Détaillées avec AltStore

### 1. Sur votre PC Windows :

1. Téléchargez **AltServer** : https://altstore.io
2. Installez **iTunes** (ou Apple Mobile Device Support) : https://support.apple.com/downloads/itunes
3. Installez et lancez **AltServer**
4. Connectez votre iPhone en USB
5. Dans AltServer (icône système), cliquez → "Install AltStore" → sélectionnez votre iPhone
6. Entrez votre Apple ID (gratuit, pas besoin de compte développeur)

### 2. Sur votre iPhone :

1. Ouvrez **AltStore** (app installée)
2. Allez sur https://github.com/adaammmm3131/AR3DScan/actions
3. Déclenchez le workflow **"Build iOS App for Device"**
4. Attendez la fin de la compilation (5-10 min)
5. Téléchargez l'artefact **"AR3DScan-iOS-Device-IPA"**
6. Partagez le fichier `.ipa` vers AltStore
7. Installez l'application !

---

## ⚠️ Limitations

- **Sans compte développeur** : L'app expire après 7 jours (résignable via AltStore)
- **Avec compte développeur gratuit** : Limité à 3 apps maximum, expire après 7 jours
- **Avec compte développeur payant** : Pas d'expiration, jusqu'à 100 appareils

---

## 📝 Checklist Rapide

- [ ] Installer AltServer sur PC Windows
- [ ] Installer iTunes sur PC Windows
- [ ] Installer AltStore sur iPhone via AltServer
- [ ] Déclencher workflow "Build iOS App for Device" sur GitHub
- [ ] Télécharger l'IPA depuis GitHub Actions
- [ ] Installer l'IPA via AltStore sur iPhone
- [ ] Profiter de votre app ! 🎉

