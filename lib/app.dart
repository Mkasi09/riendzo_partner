import 'package:flutter/material.dart';
import 'package:riendzo_partner/features/auth/auth_gate.dart';
import 'package:riendzo_partner/theme/app_theme.dart';

class RiendzoPartnerApp extends StatelessWidget {
  const RiendzoPartnerApp({super.key, this.home});

  final Widget? home;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Riendzo Partner',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: home ?? const AuthGate(),
    );
  }
}
