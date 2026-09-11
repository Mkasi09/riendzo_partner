import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import 'firebase_options.dart';

part 'models/trip.dart';
part 'services/firebase_partner_service.dart';
part 'screens/auth_screen.dart';
part 'screens/home_screen.dart';
part 'screens/drive_screen.dart';
part 'screens/trips_screen.dart';
part 'screens/earnings_screen.dart';
part 'screens/profile_screen.dart';
part 'screens/detail_screens.dart';
part 'screens/navigation_screen.dart';
part 'widgets/shared_widgets.dart';

const navy = Color(0xff102c2b),
    mint = Color(0xffb8f34a),
    cream = Color(0xfff5f4ee),
    muted = Color(0xff687571);
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const RiendzoApp());
}

class RiendzoApp extends StatefulWidget {
  const RiendzoApp({super.key, this.firebaseEnabled = true});
  final bool firebaseEnabled;
  @override
  State<RiendzoApp> createState() => _RiendzoAppState();
}

class _RiendzoAppState extends State<RiendzoApp> {
  bool demoSignedIn = false;
  final demoStore = PartnerStore.demo();
  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Riendzo Partner',
    theme: ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: cream,
      colorScheme: ColorScheme.fromSeed(
        seedColor: navy,
        primary: navy,
        secondary: mint,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
    ),
    home: widget.firebaseEnabled
        ? const FirebaseAuthGate()
        : demoSignedIn
        ? HomeScreen(
            store: demoStore,
            onSignOut: () => setState(() => demoSignedIn = false),
          )
        : AuthScreen(onDone: () => setState(() => demoSignedIn = true)),
  );
}

class FirebaseAuthGate extends StatelessWidget {
  const FirebaseAuthGate({super.key});
  @override
  Widget build(BuildContext context) => StreamBuilder<User?>(
    stream: FirebaseAuth.instance.authStateChanges(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      }
      return snapshot.data == null ? const AuthScreen() : const ConnectedHome();
    },
  );
}

class ConnectedHome extends StatefulWidget {
  const ConnectedHome({super.key});
  @override
  State<ConnectedHome> createState() => _ConnectedHomeState();
}

class _ConnectedHomeState extends State<ConnectedHome> {
  late final PartnerStore store;
  @override
  void initState() {
    super.initState();
    store = PartnerStore.connected();
  }

  @override
  void dispose() {
    store.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => HomeScreen(
    store: store,
    onSignOut: () => FirebaseAuth.instance.signOut(),
  );
}
