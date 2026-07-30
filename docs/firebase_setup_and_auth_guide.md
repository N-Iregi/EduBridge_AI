# EduBridge AI - Firebase Setup & Google Authentication Guide

This document provides complete instructions for Person 4 (Amazing) and Person 5 (Neville) to finalize Firebase Console setup, team access, and Google Authentication.

---

## 1. Why the Project Was Not Visible in Firebase Console

The Firebase CLI query (`firebase projects:list`) confirmed that **no project named `edubridge-ai` had been created yet** in the Firebase Console. 

Until Person 4 creates the shared project in the console and invites the team, neither `flutterfire configure` nor the Firebase Console will display the project.

---

## 2. Step-by-Step Instructions for Person 4 (Amazing)

### Step 2.1: Create the Shared Firebase Project
1. Open [Firebase Console](https://console.firebase.google.com/).
2. Click **Add project** (or **Create a project**).
3. Name the project `edubridge-ai` (or `edubridge-ai-dev`).
4. (Optional) Enable Google Analytics if desired, then click **Create project**.

### Step 2.2: Invite Group Members (Fixes Team Access Issue)
1. In Firebase Console, click the **Settings Gear** (top left) -> **Project settings**.
2. Go to the **Users and permissions** tab.
3. Click **Add member**.
4. Enter Neville's email and all group members' emails.
5. Select **Owner** or **Editor** role for each member and click **Add member**.
> *Now Neville and all team members will immediately see `edubridge-ai` when logging into Firebase Console or running `flutterfire configure`.*

### Step 2.3: Enable Authentication Providers
1. Go to **Build -> Authentication** in the left menu and click **Get started**.
2. Under the **Sign-in method** tab:
   - Click **Email/Password** -> Enable **Email/Password** -> Save.
   - Click **Google** -> Enable **Google** -> Set Project support email -> Save.

### Step 2.4: Enable Firestore Database & Deploy Security Rules
1. Go to **Build -> Firestore Database** -> Click **Create database**.
2. Select your preferred location (e.g. `nam5 / us-central` or `europe-west`).
3. From your local repository terminal, deploy the pre-written rules from `firestore.rules`:
   ```bash
   firebase deploy --only firestore:rules
   ```

### Step 2.5: Register Platform Credentials for Google Sign-In
- **Android SHA-1 Fingerprint**:
  1. In terminal, navigate to `android` directory and run:
     ```bash
     ./gradlew signingReport
     ```
     *(Or run: `keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android`)*
  2. Copy the `SHA1` fingerprint output (e.g. `AA:BB:CC:...`).
  3. Go to Firebase Console -> **Project Settings** -> **General** tab -> Under your Android app section, click **Add fingerprint** and paste the SHA-1 value.

- **iOS Reversed Client ID**:
  1. Download `GoogleService-Info.plist` from Project Settings -> iOS App.
  2. Place `GoogleService-Info.plist` in `ios/Runner/`.
  3. Open `GoogleService-Info.plist` and copy the `<string>` value of `REVERSED_CLIENT_ID` (e.g. `com.googleusercontent.apps.123456789-abcdef`).
  4. Add the following URL scheme to `ios/Runner/Info.plist`:
     ```xml
     <key>CFBundleURLTypes</key>
     <array>
       <dict>
         <key>CFBundleTypeRole</key>
         <string>Editor</string>
         <key>CFBundleURLSchemes</key>
         <array>
           <string>YOUR_REVERSED_CLIENT_ID</string>
         </array>
       </dict>
     </array>
     ```

### Step 2.6: Link Flutter App via FlutterFire CLI
Run the following commands in the root of the Flutter project (`c:\EduBridge_AI`):
```bash
dart pub global activate flutterfire_cli
flutterfire configure
```
- When prompted, select the existing `edubridge-ai` project.
- Select `android`, `ios`, and `web`.
- This automatically creates `lib/firebase_options.dart` and links app configurations.

---

## 3. Google Sign-In & Auth Architecture Summary

The Google Auth feature has been implemented following Clean Architecture:

- **Dependencies Added (`pubspec.yaml`)**:
  - `firebase_auth: ^6.5.6`
  - `google_sign_in: ^6.2.2`

- **Domain Layer (`lib/features/auth/domain/repositories/auth_repository.dart`)**:
  - Abstract interface `AuthRepository` defining:
    - `signInWithGoogle()`
    - `signInWithEmailAndPassword()`
    - `signUpWithEmailAndPassword()`
    - `sendPasswordResetEmail()`
    - `sendEmailVerification()`
    - `signOut()`
    - `authStateChanges` stream
    - `currentUser` getter

- **Data Layer (`lib/features/auth/data/repositories/firebase_auth_repository.dart`)**:
  - `FirebaseAuthRepository` implementing `AuthRepository`.
  - Performs Google OAuth credential exchange (`GoogleSignIn().signIn()` -> `GoogleAuthProvider.credential(...)` -> `FirebaseAuth.instance.signInWithCredential(...)`).
  - Automatically provisions or checks the Firestore user record in `users` collection matching the ERD schema (`id`, `email`, `fullName`, `role`, `bio`, `profilePictureUrl`, `createdAt`, `updatedAt`).

- **Usage Example for Person 5 (Neville)**:
  ```dart
  final authRepository = FirebaseAuthRepository();

  // Trigger Google Sign-In
  final user = await authRepository.signInWithGoogle();
  if (user != null) {
    print('Signed in as ${user.fullName} (${user.email})');
  }
  ```
