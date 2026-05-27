import 'package:flutter/material.dart';
import 'package:riendzo_partner/features/auth/login_screen.dart';
import 'package:riendzo_partner/features/driver/driver_home_screen.dart';
import 'package:riendzo_partner/services/auth_service.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key, AuthService? authService})
    : _authService = authService;

  final AuthService? _authService;

  @override
  Widget build(BuildContext context) {
    final authService = _authService ?? AuthService();

    return StreamBuilder(
      stream: authService.authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasData) {
          return const DriverHomeScreen();
        }

        return LoginScreen(authService: authService);
      },
    );
  }
}
