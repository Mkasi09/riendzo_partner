# Riendzo Partner

Driver-facing Flutter app connected to the same Firebase project as the Riendzo traveller app in `C:\Users\steam\Documents\ChatGPT\Riendzo`.

## Backend connection

- Firebase project: `riendzo`
- Authentication: Firebase email/password
- Live requests: Firestore `transport_requests` where `status == pending`
- Linked traveller trips: Firestore `trips/{tripId}`
- Accepting uses a Firestore transaction to prevent double assignment
- Declines are stored per driver in `declinedBy`
- Lifecycle changes update both the request and linked trip transport status

Create a driver account in the Partner app or sign in with an existing Firebase Authentication account. A debug-only local store remains available to widget tests through `RiendzoApp(firebaseEnabled: false)`.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
