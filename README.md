# bloc_chatapp
A Flutter + Bloc chat application using Firebase, built as one of my first learning projects.

## Overview
Bloc Chat App is a mobile chat application built with Flutter that uses Firebase for authentication and real-time one-to-one messaging. It is structured as a feature-based, Bloc-driven app to practice clean state management and modular architecture. This project was created while I was learning Flutter and Bloc, so it focuses on core chat flows and UI patterns rather than production-level features.

## Key Features
- Email/password authentication with user profiles (username & avatar).
- Real-time one-to-one chat using Cloud Firestore.
- Chat list with last message preview, timestamp, and simple unread indicator.
- User search and starting new conversations from the chat list screen.
- Typing indicator in active chats and emoji picker in the message input.
- Edit and delete individual messages, with per-day date separators and “(düzenlendi)” label.
- Delete entire conversations via swipe-to-delete on the chat list.

## Tech Stack
- **Language**: Dart
- **Framework**: Flutter
- **State Management**: `bloc`, `flutter_bloc`, `equatable`
- **Backend**: Firebase Authentication, Cloud Firestore, Firebase Storage
- **UI / UX**: `mesh_gradient`, `emoji_picker_flutter`
- **Media / Files**: `image_picker`

## Architecture / Folder Structure
The app uses a feature-first structure: each feature (auth, chat list, chat, profile) has its own module with Bloc + UI. The data layer is separated into entities, models, and repositories for Firebase integration.

```text
lib/
  main.dart                 # Firebase init + runApp
  app.dart                  # Root MaterialApp

  commons/
    app_colors.dart
    app_styles.dart
    widgets/
      submit_button_widget.dart

  data/
    entitites/
      chat_entity.dart
      message_entity.dart
      user_entity.dart
    models/
      chat_model.dart
      message_model.dart
      user_model.dart
    repositories/
      chat/
        firebase_chat_repository.dart
      user/
        firebase_user_repository.dart
      chat_repository.dart
      user_repository.dart

  modules/
    auth_module/
      bloc/
      ui/
        auth/
          welcome_view.dart          # Sign in / sign up tabs
    chat_list_module/
      bloc/
      ui/
        chat_list_page_view.dart
        widgets/
          chat_list_widget.dart
          search_bar_widget.dart
    chat_module/
      bloc/
        listen_message/
        send_message/
        typing_indicator/
      ui/
        chat_page.dart
        widgets/
          message_list_widget.dart
          message_input_widget.dart
          message_bubble_widget.dart
    profile_module/
      bloc/
      ui/
        profile_page_view.dart
        widgets/
          ...
```

## Screenshots
Add screenshots under a folder like `assets/screenshots/` and reference them here, for example:

```markdown
![Auth Screen](assets/screenshots/auth.png)
![Chat List](assets/screenshots/chat_list.png)
![Chat Screen](assets/screenshots/chat_screen.png)
```

## Setup & Run

### Prerequisites
- Flutter SDK installed (`flutter --version`).
- A Firebase project (Firestore, Authentication, Storage enabled).
- Android/iOS setup for Flutter (emulator or real device).

### Install
```bash
flutter pub get
```

### Run (dev)
```bash
flutter run
```

### Build (release)
```bash
# Android
flutter build apk

# iOS (from macOS with Xcode)
flutter build ios
```

## Configuration
This project uses Firebase services:

- Add the platform-specific Firebase config files:
  - `android/app/google-services.json`
  - `ios/Runner/GoogleService-Info.plist`
- Ensure Firebase Authentication, Firestore, and Storage are enabled in the Firebase console.
- No `.env` or custom config files are used; configuration is done via the standard Firebase setup and `Firebase.initializeApp()` in `main.dart`.

## Roadmap
- Add message reactions (emoji reactions per message).
- Add read receipts and more advanced unread counters.
- Add group chats and richer profile settings (bio, status, etc.).

## License
No license specified.
