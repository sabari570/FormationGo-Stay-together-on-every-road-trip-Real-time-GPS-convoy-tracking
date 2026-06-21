# Firebase Setup Guide for FormationGo

Complete these steps once before running the app with cloud sync.

## 1. Create Firebase project

1. Go to https://console.firebase.google.com/
2. **Add project** → name it `formation-go`
3. Create the project

## 2. Register Android app

1. Project overview → **Add app** → Android
2. Package name: `com.example.formation_go`
3. Download `google-services.json`
4. Place at: `android/app/google-services.json`

## 3. Register iOS app (optional)

1. Add iOS app in Firebase console
2. Bundle ID from Xcode (e.g. `com.example.formationGo`)
3. Download `GoogleService-Info.plist` → `ios/Runner/GoogleService-Info.plist`

## 4. Enable Firestore

1. **Build → Firestore Database** → Create database
2. Start in **test mode** for development
3. Pick a nearby region

## 5. Enable Anonymous Authentication (required)

Firestore rules require a signed-in user. Without this step you will see `PERMISSION_DENIED` on writes.

1. **Build → Authentication** → Get started
2. **Sign-in method → Anonymous** → **Enable** → Save

## 6. Deploy Firestore security rules (required)

The default "test mode" rules expire after 30 days. Deploy the project rules:

1. Firebase Console → **Firestore Database** → **Rules**
2. Paste the contents of `firestore.rules` from this project
3. Click **Publish**

Or with Firebase CLI:

```bash
firebase deploy --only firestore:rules
```

## 7. Generate Flutter Firebase config

```bash
dart pub global activate flutterfire_cli
flutterfire configure
```

Select your project and platforms. This replaces `lib/firebase_options.dart` with real values.

## 8. Run the app

```bash
flutter pub get
flutter run
```

Verify: console shows `Firebase: anonymous sign-in OK (...)` and creating a journey adds a doc under `journeys` in Firestore.

## 9. Create composite index (when prompted)

If join-by-passcode fails, Firebase Console will show a link to create an index on:
- Collection: `journeys`
- Fields: `passCode` (Ascending), `status` (Ascending)
