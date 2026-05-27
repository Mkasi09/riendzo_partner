import 'package:flutter/material.dart';
import 'package:riendzo_partner/widgets/panel.dart';

class AuthScaffold extends StatelessWidget {
  const AuthScaffold({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 460),
              child: Panel(padding: const EdgeInsets.all(22), child: child),
            ),
          ),
        ),
      ),
    );
  }
}
