# FIP Zone E Mobile App

Flutter mobile client for the FIP Zone E polo platform — the official app for the
polo community across Africa, the Middle East and Asia. Browses tournaments,
federations, players, clubs, live scores and results from the
[fipzone.com](https://fipzone.com) API.

## Stack

- Flutter / Dart (SDK ^3.7)
- Google Fonts (Playfair Display + Inter)
- `http` for the fipzone.com REST client
- Target platforms: Android, iOS, Web

## Run

```bash
flutter pub get
flutter run -d chrome --web-port 8765   # web
flutter run                             # connected device / emulator
```

The API base URL defaults to `https://fipzone.com` and is overridable at build
time:

```bash
flutter build apk --dart-define=FIP_API=https://staging.example.com
```

## Build for release

### Android (Play Store)

Produces an `.aab` (Android App Bundle):

```bash
flutter build appbundle --release
```

The output lands at `build/app/outputs/bundle/release/app-release.aab`.

The release build is signed via `android/key.properties`, which is **not**
committed. Create it from `android/key.properties.example`:

```powershell
keytool -genkey -v -keystore android\fipzonee-release.keystore `
  -alias fipzonee -keyalg RSA -keysize 2048 -validity 10000
copy android\key.properties.example android\key.properties
# edit android\key.properties with the keystore path and passwords
```

Without `key.properties` the release build falls back to debug signing so
`flutter run --release` still works locally — but Play Store will reject it.

### Web

```bash
flutter build web --release
```

Output in `build/web/`.

## Project structure

```
lib/
  main.dart     # all UI (pages, widgets, routes)
  api.dart      # HTTP client, model fetchers, ApiBuilder<T>
assets/images/  # Logo, hero, club, trophy photography
android/        # Android host app, signing config, manifest
ios/            # iOS host app
web/            # PWA manifest, favicon, index.html
```

## API endpoints the app consumes

- `GET /api/v1/tournaments` — list of tournaments (used by Tournaments page, Calendar)
- `GET /api/v1/federations` — list of national federations
- `GET /api/v1/live` — snapshot of live and scheduled-today matches
- `GET /api/v1/results` — final results
- `GET /api/v1/players`, `/clubs` — directory data

All public (no auth).
