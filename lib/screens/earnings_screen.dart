part of '../main.dart';

class EarningsScreen extends StatelessWidget {
  const EarningsScreen({super.key});
  @override
  Widget build(BuildContext context) => SafeArea(
    child: ListView(
      children: [
        const PageHeader('Earnings', 'Your performance this week'),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(23),
                decoration: BoxDecoration(
                  color: navy,
                  borderRadius: BorderRadius.circular(26),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'THIS WEEK',
                      style: TextStyle(
                        color: mint,
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'R 6,480.00',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 35,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Text(
                      '+12.4% from last week',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              const Row(
                children: [
                  Expanded(
                    child: StatCard(
                      Icons.account_balance_wallet_outlined,
                      'R 5,920',
                      'Next payout',
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: StatCard(
                      Icons.savings_outlined,
                      'R 560',
                      'Tips earned',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Align(
                alignment: Alignment.centerLeft,
                child: SectionTitle('Recent activity'),
              ),
              const SizedBox(height: 10),
              ...const [
                ('Rosebank → Soweto', 'R 286'),
                ('Sandton → Melrose Arch', 'R 148'),
                ('O.R. Tambo → Pretoria', 'R 524'),
              ].map(
                (item) => Card(
                  elevation: 0,
                  child: ListTile(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (_) =>
                            TripReceiptScreen(route: item.$1, amount: item.$2),
                      ),
                    ),
                    leading: const CircleAvatar(
                      backgroundColor: Color(0xffe8eee8),
                      child: Icon(Icons.check, color: navy),
                    ),
                    title: Text(
                      item.$1,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    subtitle: const Text('Completed trip'),
                    trailing: Text(
                      item.$2,
                      style: const TextStyle(fontWeight: FontWeight.w900),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
