import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:riendzo_partner/app.dart';
import 'package:riendzo_partner/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const RiendzoPartnerApp());
}
