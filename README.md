# EduBridge AI

A mobile application built with Flutter and Firebase, connecting underserved African students to scholarships, AI-assisted mentorship, career guidance, and a peer community — all in one platform.

## Features

- **Authentication** — Email/password and Google Sign-In, with email verification and password reset
- **Scholarship Discovery** — Browse, filter by category, view details, and apply to scholarships
- **AI Mentor Chat** — Conversational guidance with the ability to save useful advice
- **Career Pathways** — Explore career paths and related skills
- **CV Builder** — Select a template, edit your details, and export
- **Essay Assistant** — Draft essays, get AI review feedback, and save drafts
- **Deadline Tracker** — Track scholarship deadlines with a days-remaining view
- **Community Forum** — Post, comment, and like within a peer community
- **Profile & Settings** — Manage account details and app preferences (theme, notifications, language, biometric login)

## Tech Stack

- **Frontend:** Flutter (Dart)
- **State Management:** BLoC / Cubit (`flutter_bloc`)
- **Backend:** Firebase Authentication, Cloud Firestore
- **Architecture:** Clean architecture (presentation / domain / data layers per feature)

## Getting Started

### Prerequisites

- Flutter SDK (stable channel)
- A Firebase project with Authentication and Firestore enabled
- Android Studio or Xcode (for running on an emulator/simulator), or a physical device with USB debugging enabled

### Setup

1. **Clone the repository**
   git clone https://github.com/N-Iregi/EduBridge_AI.git
cd EduBridge_AI


2. **Install dependencies**

flutter pub get


3. **Firebase configuration**
   This project already includes `lib/firebase_options.dart` and `android/app/google-services.json` configured for the project's Firebase instance. If setting up a new Firebase project instead, run:

flutterfire configure

   and select your own Firebase project when prompted.

4. **Run the app**

flutter run

   Select a connected Android device or emulator when prompted. (Note: web/Chrome builds are not fully configured for Firebase and are not supported for this project.)

### Running Tests

flutter test


To generate a coverage report:

flutter test --coverage


### Code Quality

flutter analyze
dart format .


## Project Structure

lib/
├── core/ # Shared services, theming, validators
├── features/
│ ├── auth/ # Login, signup, password reset, AuthBloc
│ ├── scholarship/ # Scholarship discovery, bookmarks
│ ├── application/ # Scholarship applications
│ ├── mentorship/ # AI Mentor Chat
│ ├── career/ # Career Pathways
│ ├── cv_builder/ # CV Builder
│ ├── essay_assistant/ # Essay Assistant
│ ├── deadline_tracker/ # Deadline Tracker
│ ├── community/ # Community Forum
│ ├── notification/ # In-app notifications
│ ├── profile/ # User profile
│ └── home/ # Navigation hub
└── main.dart


Each feature follows a `presentation / domain / data` layered structure, keeping UI, business logic, and data access separated.

## Screenshots

[Insert screenshots of key screens here — Home, Scholarship Discovery, AI Mentor Chat, Community Forum, etc.]
## Known Limitations

- AI Mentor Chat and Essay Assistant return placeholder responses rather than real AI-generated content; a live AI backend integration is planned.
- Career Pathways, CV Builder, and Deadline Tracker use in-app state rather than Firestore, pending dedicated backend models.
- Deadline Tracker does not yet trigger real push or local notifications.
- Community Forum's like feature does not track per-user likes, so a post could currently be liked more than once by the same user.
- Only email verification is implemented as an additional auth safeguard; OTP was not implemented.

