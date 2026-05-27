import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:riendzo_partner/widgets/panel.dart';
import 'package:riendzo_partner/widgets/pill.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key, required this.onSignOut});

  final VoidCallback onSignOut;

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final name = user?.displayName?.trim().isNotEmpty == true
        ? user!.displayName!
        : 'Partner Driver';

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text(
          'Driver Profile',
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 18),
        Panel(
          child: Row(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: const Color(0xFF172033),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.person, color: Colors.white, size: 34),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Text(
                      user?.email ?? 'Toyota Corolla Quest - GP 42 RN',
                      style: const TextStyle(color: Color(0xFF6B7280)),
                    ),
                    const SizedBox(height: 6),
                    const Pill(
                      text: 'Verified driver',
                      color: Color(0xFFECFDF5),
                      textColor: Color(0xFF0F9F6E),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        const _SettingsTile(
          icon: Icons.directions_car,
          title: 'Vehicle and documents',
          subtitle: 'License, roadworthy, insurance',
        ),
        const _SettingsTile(
          icon: Icons.account_balance_wallet,
          title: 'Payout details',
          subtitle: 'Bank account and payment history',
        ),
        const _SettingsTile(
          icon: Icons.support_agent,
          title: 'Support',
          subtitle: 'Help with bookings and rider issues',
        ),
        const _SettingsTile(
          icon: Icons.shield,
          title: 'Safety toolkit',
          subtitle: 'Emergency contacts and trip sharing',
        ),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: onSignOut,
          icon: const Icon(Icons.logout),
          label: const Text('Sign out'),
        ),
      ],
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Panel(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF416FDF)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Color(0xFF6B7280),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }
}
