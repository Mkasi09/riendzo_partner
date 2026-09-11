part of '../main.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key, required this.onSignOut});
  final VoidCallback onSignOut;
  static const items = [
    (Icons.badge_outlined, 'Personal information'),
    (Icons.directions_car_outlined, 'Vehicle · Toyota Corolla'),
    (Icons.description_outlined, 'Documents'),
    (Icons.shield_outlined, 'Safety centre'),
    (Icons.notifications_outlined, 'Notifications'),
    (Icons.help_outline, 'Help & support'),
    (Icons.settings_outlined, 'App settings'),
  ];
  @override
  Widget build(BuildContext context) => SafeArea(
    child: ListView(
      children: [
        const PageHeader('Partner profile', 'Account and driver settings'),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Card(
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: ListTile(
                    onTap: () => _open(context, 0),
                    leading: const CircleAvatar(
                      radius: 29,
                      backgroundColor: navy,
                      child: Text(
                        'KM',
                        style: TextStyle(
                          color: mint,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    title: const Text(
                      'Kagiso Molefe',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    subtitle: const Text('Partner since 2024 · ★ 4.92'),
                    trailing: const Icon(Icons.verified, color: Colors.green),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              ...items.map(
                (item) => Card(
                  elevation: 0,
                  margin: const EdgeInsets.only(bottom: 4),
                  child: ListTile(
                    onTap: () => _open(context, items.indexOf(item)),
                    leading: Icon(item.$1, color: navy),
                    title: Text(
                      item.$2,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    trailing: const Icon(Icons.chevron_right),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              OutlinedButton.icon(
                onPressed: onSignOut,
                icon: const Icon(Icons.logout),
                label: const Text('Sign out'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  minimumSize: const Size(double.infinity, 54),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );

  void _open(BuildContext context, int index) {
    final screens = <Widget>[
      const PersonalInformationScreen(),
      const VehicleScreen(),
      const DocumentsScreen(),
      const SafetyScreen(),
      const NotificationsScreen(),
      const HelpSupportScreen(),
      const AppSettingsScreen(),
    ];
    Navigator.push(
      context,
      MaterialPageRoute<void>(builder: (_) => screens[index]),
    );
  }
}
