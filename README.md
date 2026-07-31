# EduBridge AI

A mobile application built with Flutter and Firebase, connecting underserved African students to scholarships, AI-assisted mentorship, career guidance, and a peer community — all in one platform.

## Features

- **Authentication** — Email/password and Google Sign-In, with email verification and password reset
- **Scholarship Discovery** — Browse, filter by category, view details, apply, bookmark for later, and track application status/notes
- **AI Mentor Chat** — Conversational guidance with the ability to save useful advice, plus booking real sessions with registered mentors
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
<img width="436" height="896" alt="WhatsApp Image 2026-07-31 at 10 55 37 PM" src="https://github.com/user-attachments/assets/72a7f985-124e-4134-96c7-daae470084bf" />
<img width="434" height="894" alt="WhatsApp Image 2026-07-31 at 10 55 36 PM (1)" src="https://github.com/user-attachments/assets/932fbefe-12e1-4dbc-8ec5-8eeae41d09ec" />
<img width="436" height="899" alt="WhatsApp Image 2026-07-31 at 10 55 36 PM" src="https://github.com/user-attachments/assets/5c7d1bae-bb5b-4fff-a0ca-534ede9beebf" />
<img width="426" height="898" alt="WhatsApp Image 2026-07-31 at 10 55 35 PM" src="https://github.com/user-attachments/assets/841f417d-a105-460c-a218-18cf4563c7b6" />






## Known Limitations

- AI Mentor Chat and Essay Assistant return placeholder responses rather than real AI-generated content; a live AI backend integration is planned. Booking an actual mentor (separate from the placeholder chat) is real — see "My Mentor Sessions" below.
- Career Pathways and CV Builder use in-app state rather than Firestore, pending dedicated backend models.
- Deadline Tracker, scholarship bookmarks, scholarship applications, and mentorship session bookings are all backed by Firestore with full create/read/update/delete, but none yet trigger real push or local notifications.
- Mentor session booking requires at least one user with `role == 'mentor'` to exist in Firestore — there's no mentor sign-up flow or admin console yet, so the mentor list is empty until one is added manually.
- Profile screen displays the signed-in user's details but has no edit/save flow yet.
- Community Forum's like feature does not track per-user likes, so a post could currently be liked more than once by the same user.
- Only email verification is implemented as an additional auth safeguard; OTP was not implemented.

