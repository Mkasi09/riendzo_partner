part of '../main.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.store, required this.onSignOut});
  final PartnerStore store;
  final VoidCallback onSignOut;
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int tab = 0;
  @override
  void initState() {
    super.initState();
    widget.store.addListener(_storeChanged);
  }

  void _storeChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    widget.store.removeListener(_storeChanged);
    super.dispose();
  }

  void refresh([int? next]) => setState(() {
    if (next != null) tab = next;
  });
  @override
  Widget build(BuildContext context) {
    final pages = [
      DriveScreen(store: widget.store, refresh: refresh),
      TripsScreen(store: widget.store, refresh: refresh),
      const EarningsScreen(),
      ProfileScreen(onSignOut: widget.onSignOut),
    ];
    return Scaffold(
      body: IndexedStack(index: tab, children: pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: tab,
        onDestinationSelected: (value) => setState(() => tab = value),
        indicatorColor: mint,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.near_me_outlined),
            selectedIcon: Icon(Icons.near_me),
            label: 'Drive',
          ),
          NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            label: 'Trips',
          ),
          NavigationDestination(
            icon: Icon(Icons.account_balance_wallet_outlined),
            label: 'Earnings',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
