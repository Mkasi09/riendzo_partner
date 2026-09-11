// DetailScaffold intentionally presents its primary content before its footer action.
// ignore_for_file: sort_child_properties_last
part of '../main.dart';

class DetailScaffold extends StatelessWidget {
  const DetailScaffold({
    super.key,
    required this.title,
    required this.child,
    this.action,
  });
  final String title;
  final Widget child;
  final Widget? action;
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w900)),
      backgroundColor: cream,
    ),
    body: SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          child,
          if (action != null) ...[const SizedBox(height: 20), action!],
        ],
      ),
    ),
  );
}

class PersonalInformationScreen extends StatelessWidget {
  const PersonalInformationScreen({super.key});
  @override
  Widget build(BuildContext context) => DetailScaffold(
    title: 'Personal information',
    child: Column(
      children: [
        const CircleAvatar(
          radius: 42,
          backgroundColor: navy,
          child: Text(
            'KM',
            style: TextStyle(
              color: mint,
              fontSize: 24,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        const SizedBox(height: 24),
        const TextField(
          decoration: InputDecoration(labelText: 'Full name'),
          controller: null,
        ),
        const SizedBox(height: 12),
        const TextField(
          decoration: InputDecoration(labelText: 'Email address'),
          controller: null,
        ),
        const SizedBox(height: 12),
        const TextField(
          decoration: InputDecoration(labelText: 'Mobile number'),
          controller: null,
        ),
      ],
    ),
    action: PrimaryButton(
      label: 'Save changes',
      onPressed: () => _saved(context, 'Personal information updated'),
    ),
  );
}

class VehicleScreen extends StatelessWidget {
  const VehicleScreen({super.key});
  @override
  Widget build(BuildContext context) => DetailScaffold(
    title: 'Vehicle',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 150,
          width: double.infinity,
          decoration: BoxDecoration(
            color: navy,
            borderRadius: BorderRadius.circular(24),
          ),
          child: const Icon(Icons.directions_car, color: mint, size: 88),
        ),
        const SizedBox(height: 20),
        const _InfoPanel(
          title: 'Toyota Corolla',
          rows: [
            ('Registration', 'GP 42 KM GP'),
            ('Colour', 'Pearl white'),
            ('Category', 'Comfort'),
            ('Model year', '2022'),
          ],
        ),
      ],
    ),
    action: PrimaryButton(
      label: 'Update vehicle details',
      onPressed: () => _saved(context, 'Vehicle details submitted for review'),
    ),
  );
}

class DocumentsScreen extends StatelessWidget {
  const DocumentsScreen({super.key});
  @override
  Widget build(BuildContext context) => DetailScaffold(
    title: 'Documents',
    child: Column(
      children: const [
        _DocumentTile('Driver’s licence', 'Valid until 18 Jun 2028', true),
        _DocumentTile('Vehicle registration', 'Verified', true),
        _DocumentTile('Insurance', 'Expires in 42 days', true),
        _DocumentTile('Roadworthy certificate', 'Action required', false),
      ],
    ),
    action: PrimaryButton(
      label: 'Upload a document',
      onPressed: () => _saved(context, 'Document picker opened'),
    ),
  );
}

class SafetyScreen extends StatelessWidget {
  const SafetyScreen({super.key});
  @override
  Widget build(BuildContext context) => DetailScaffold(
    title: 'Safety centre',
    child: Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: navy,
            borderRadius: BorderRadius.circular(24),
          ),
          child: const Column(
            children: [
              Icon(Icons.shield, color: mint, size: 54),
              SizedBox(height: 10),
              Text(
                'You’re protected on every trip',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 21,
                  fontWeight: FontWeight.w900,
                ),
              ),
              SizedBox(height: 6),
              Text(
                'Safety tools are available while you drive.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        _ActionTile(
          Icons.sos,
          'Emergency assistance',
          'Contact local emergency services',
          () => _saved(context, 'Emergency assistance information opened'),
        ),
        _ActionTile(
          Icons.share_location_outlined,
          'Share my trip',
          'Share a live trip link',
          () => _saved(context, 'Secure trip link copied'),
        ),
        _ActionTile(
          Icons.report_outlined,
          'Report an incident',
          'Tell Riendzo’s safety team',
          () => _saved(context, 'Incident report opened'),
        ),
      ],
    ),
  );
}

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});
  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  bool trips = true, earnings = true, news = false;
  @override
  Widget build(BuildContext context) => DetailScaffold(
    title: 'Notifications',
    child: Column(
      children: [
        SwitchListTile(
          value: trips,
          onChanged: (v) => setState(() => trips = v),
          title: const Text('Trip requests'),
          subtitle: const Text('Nearby trip alerts'),
        ),
        SwitchListTile(
          value: earnings,
          onChanged: (v) => setState(() => earnings = v),
          title: const Text('Earnings and payouts'),
        ),
        SwitchListTile(
          value: news,
          onChanged: (v) => setState(() => news = v),
          title: const Text('Product news'),
        ),
      ],
    ),
  );
}

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});
  @override
  Widget build(BuildContext context) => DetailScaffold(
    title: 'Help & support',
    child: Column(
      children: [
        const TextField(
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.search),
            hintText: 'Search help articles',
          ),
        ),
        const SizedBox(height: 16),
        _ActionTile(
          Icons.chat_bubble_outline,
          'Chat with support',
          'Typical reply in under 5 minutes',
          () => _saved(context, 'Support chat started'),
        ),
        _ActionTile(
          Icons.call_outlined,
          'Call partner support',
          'Available 24 hours',
          () => _saved(context, 'Calling partner support…'),
        ),
        _ActionTile(
          Icons.question_answer_outlined,
          'Frequently asked questions',
          'Payments, trips and account',
          () => _saved(context, 'Help articles opened'),
        ),
      ],
    ),
  );
}

class AppSettingsScreen extends StatefulWidget {
  const AppSettingsScreen({super.key});
  @override
  State<AppSettingsScreen> createState() => _AppSettingsScreenState();
}

class _AppSettingsScreenState extends State<AppSettingsScreen> {
  bool darkMap = false, voice = true;
  @override
  Widget build(BuildContext context) => DetailScaffold(
    title: 'App settings',
    child: Column(
      children: [
        SwitchListTile(
          value: voice,
          onChanged: (v) => setState(() => voice = v),
          title: const Text('Voice navigation'),
        ),
        SwitchListTile(
          value: darkMap,
          onChanged: (v) => setState(() => darkMap = v),
          title: const Text('Dark map at night'),
        ),
        ListTile(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (_) => const OptionScreen(
                title: 'Language',
                options: ['English', 'isiZulu', 'Sesotho', 'Afrikaans'],
              ),
            ),
          ),
          title: const Text('Language'),
          subtitle: const Text('English'),
          trailing: const Icon(Icons.chevron_right),
        ),
        ListTile(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (_) => const OptionScreen(
                title: 'Distance units',
                options: ['Kilometres', 'Miles'],
              ),
            ),
          ),
          title: const Text('Distance units'),
          subtitle: const Text('Kilometres'),
          trailing: const Icon(Icons.chevron_right),
        ),
      ],
    ),
  );
}

class RiderScreen extends StatelessWidget {
  const RiderScreen({super.key, required this.trip});
  final TripRequest trip;
  @override
  Widget build(BuildContext context) => DetailScaffold(
    title: 'Traveller',
    child: Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: navy,
          child: Text(
            trip.rider[0],
            style: const TextStyle(
              color: mint,
              fontSize: 26,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          trip.rider,
          style: const TextStyle(fontSize: 23, fontWeight: FontWeight.w900),
        ),
        Text(
          '★ ${trip.rating} · ${trip.people} passengers',
          style: const TextStyle(color: muted),
        ),
        const SizedBox(height: 22),
        _InfoPanel(
          title: 'Trip contact',
          rows: [
            ('Pickup', trip.pickup),
            ('Drop-off', trip.dropoff),
            ('Request', trip.id),
          ],
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: PrimaryButton(
                label: 'Call',
                onPressed: () => _saved(context, 'Calling ${trip.rider}…'),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: PrimaryButton(
                label: 'Message',
                light: true,
                onPressed: () => _saved(context, 'Message composer opened'),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

class TripReceiptScreen extends StatelessWidget {
  const TripReceiptScreen({
    super.key,
    required this.route,
    required this.amount,
  });
  final String route, amount;
  @override
  Widget build(BuildContext context) => DetailScaffold(
    title: 'Trip receipt',
    child: Column(
      children: [
        const CircleAvatar(
          radius: 34,
          backgroundColor: Color(0xffe8f3d1),
          child: Icon(Icons.check, color: navy, size: 34),
        ),
        const SizedBox(height: 12),
        const Text(
          'Trip completed',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
        ),
        const Text('Today · Riendzo Comfort', style: TextStyle(color: muted)),
        const SizedBox(height: 24),
        _InfoPanel(
          title: route,
          rows: [
            ('Trip fare', amount),
            ('Riendzo service fee', 'Included'),
            ('Payout status', 'Scheduled'),
          ],
        ),
        const SizedBox(height: 18),
        Text(
          amount,
          style: const TextStyle(fontSize: 34, fontWeight: FontWeight.w900),
        ),
        const Text('Total earnings', style: TextStyle(color: muted)),
      ],
    ),
    action: PrimaryButton(
      label: 'Download receipt',
      onPressed: () => _saved(context, 'Receipt downloaded'),
    ),
  );
}

class _InfoPanel extends StatelessWidget {
  const _InfoPanel({required this.title, required this.rows});
  final String title;
  final List<(String, String)> rows;
  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 12),
        ...rows.map(
          (row) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 7),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(row.$1, style: const TextStyle(color: muted)),
                ),
                Flexible(
                  child: Text(
                    row.$2,
                    textAlign: TextAlign.right,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

class _DocumentTile extends StatelessWidget {
  const _DocumentTile(this.title, this.subtitle, this.valid);
  final String title, subtitle;
  final bool valid;
  @override
  Widget build(BuildContext context) => Card(
    elevation: 0,
    child: ListTile(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute<void>(
          builder: (_) => DocumentDetailScreen(
            title: title,
            status: subtitle,
            valid: valid,
          ),
        ),
      ),
      leading: CircleAvatar(
        backgroundColor: valid
            ? const Color(0xffe8f3d1)
            : const Color(0xffffe5df),
        child: Icon(
          valid ? Icons.check : Icons.priority_high,
          color: valid ? navy : Colors.deepOrange,
        ),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
    ),
  );
}

class OptionScreen extends StatefulWidget {
  const OptionScreen({super.key, required this.title, required this.options});
  final String title;
  final List<String> options;
  @override
  State<OptionScreen> createState() => _OptionScreenState();
}

class _OptionScreenState extends State<OptionScreen> {
  int selected = 0;
  @override
  Widget build(BuildContext context) => DetailScaffold(
    title: widget.title,
    child: RadioGroup<int>(
      groupValue: selected,
      onChanged: (value) => setState(() => selected = value ?? selected),
      child: Column(
        children: List.generate(
          widget.options.length,
          (index) => RadioListTile<int>(
            value: index,
            title: Text(widget.options[index]),
          ),
        ),
      ),
    ),
    action: PrimaryButton(
      label: 'Apply',
      onPressed: () => Navigator.pop(context),
    ),
  );
}

class DocumentDetailScreen extends StatelessWidget {
  const DocumentDetailScreen({
    super.key,
    required this.title,
    required this.status,
    required this.valid,
  });
  final String title, status;
  final bool valid;
  @override
  Widget build(BuildContext context) => DetailScaffold(
    title: title,
    child: Column(
      children: [
        CircleAvatar(
          radius: 42,
          backgroundColor: valid
              ? const Color(0xffe8f3d1)
              : const Color(0xffffe5df),
          child: Icon(
            valid ? Icons.verified : Icons.warning_amber,
            color: valid ? navy : Colors.deepOrange,
            size: 40,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          status,
          style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 8),
        const Text(
          'Your document is stored securely and reviewed by the Riendzo partner team.',
          textAlign: TextAlign.center,
          style: TextStyle(color: muted),
        ),
      ],
    ),
    action: PrimaryButton(
      label: valid ? 'Replace document' : 'Upload document',
      onPressed: () => _saved(context, 'Document picker opened'),
    ),
  );
}

class _ActionTile extends StatelessWidget {
  const _ActionTile(this.icon, this.title, this.subtitle, this.onTap);
  final IconData icon;
  final String title, subtitle;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Card(
    elevation: 0,
    child: ListTile(
      onTap: onTap,
      leading: Icon(icon, color: navy),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
    ),
  );
}

void _saved(BuildContext context, String message) => ScaffoldMessenger.of(
  context,
).showSnackBar(SnackBar(content: Text(message)));
