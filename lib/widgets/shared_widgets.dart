part of '../main.dart';

class BrandLogo extends StatelessWidget {
  const BrandLogo({super.key, this.dark = false});
  final bool dark;
  @override
  Widget build(BuildContext context) => Container(
    width: 40,
    height: 40,
    decoration: BoxDecoration(
      color: dark ? navy : mint,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Icon(Icons.route, color: dark ? mint : navy),
  );
}

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.loading = false,
    this.light = false,
  });
  final String label;
  final VoidCallback? onPressed;
  final bool loading, light;
  @override
  Widget build(BuildContext context) => FilledButton(
    onPressed: onPressed,
    style: FilledButton.styleFrom(
      backgroundColor: light ? mint : navy,
      foregroundColor: light ? navy : Colors.white,
      minimumSize: const Size(double.infinity, 55),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    child: loading
        ? const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Colors.white,
            ),
          )
        : Text(label, style: const TextStyle(fontWeight: FontWeight.w800)),
  );
}

class PageHeader extends StatelessWidget {
  const PageHeader(this.title, this.subtitle, {super.key});
  final String title, subtitle;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(20, 20, 20, 22),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900),
        ),
        Text(subtitle, style: const TextStyle(color: muted)),
      ],
    ),
  );
}

class SectionTitle extends StatelessWidget {
  const SectionTitle(this.text, {super.key});
  final String text;
  @override
  Widget build(BuildContext context) => Text(
    text,
    style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w900),
  );
}

class StatusPill extends StatelessWidget {
  const StatusPill(this.text, {super.key});
  final String text;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    decoration: BoxDecoration(
      color: const Color(0xffe8f3d1),
      borderRadius: BorderRadius.circular(30),
    ),
    child: Text(
      text,
      style: const TextStyle(
        color: navy,
        fontSize: 10,
        fontWeight: FontWeight.w900,
      ),
    ),
  );
}

class StatCard extends StatelessWidget {
  const StatCard(this.icon, this.value, this.label, {super.key});
  final IconData icon;
  final String value, label;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(13),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(17),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: muted),
        const SizedBox(height: 10),
        FittedBox(
          child: Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
          ),
        ),
        Text(label, style: const TextStyle(color: muted, fontSize: 10)),
      ],
    ),
  );
}

class RouteRow extends StatelessWidget {
  const RouteRow(
    this.icon,
    this.color,
    this.label,
    this.place, {
    super.key,
    this.dark = false,
  });
  final IconData icon;
  final Color color;
  final String label, place;
  final bool dark;
  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Icon(icon, color: color, size: 21),
      const SizedBox(width: 11),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                color: dark ? Colors.white54 : muted,
                fontSize: 9,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              place,
              style: TextStyle(
                color: dark ? Colors.white : navy,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

class TripCard extends StatelessWidget {
  const TripCard({super.key, required this.trip, required this.onTap});
  final TripRequest trip;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Material(
    color: Colors.white,
    borderRadius: BorderRadius.circular(21),
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(21),
      child: Padding(
        padding: const EdgeInsets.all(17),
        child: Column(
          children: [
            Row(
              children: [
                StatusPill(trip.vehicle.toUpperCase()),
                const Spacer(),
                Text(
                  'R ${trip.fare}',
                  style: const TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            RouteRow(
              Icons.radio_button_checked,
              navy,
              trip.time.toUpperCase(),
              trip.pickup,
            ),
            const SizedBox(height: 13),
            RouteRow(
              Icons.location_on,
              Colors.deepOrangeAccent,
              '${trip.duration} · ${trip.distance}',
              trip.dropoff,
            ),
            const Divider(height: 25),
            Row(
              children: [
                CircleAvatar(radius: 14, child: Text(trip.rider[0])),
                const SizedBox(width: 8),
                Text(
                  trip.rider,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(width: 6),
                Text('★ ${trip.rating}', style: const TextStyle(color: muted)),
                const Spacer(),
                const Icon(Icons.chevron_right),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

class EmptyTrips extends StatelessWidget {
  const EmptyTrips({super.key});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(30),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
    ),
    child: const Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.check_circle_outline, size: 38, color: muted),
        SizedBox(height: 9),
        Text(
          'You’re all caught up',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        Text(
          'New requests appear automatically.',
          style: TextStyle(color: muted),
        ),
      ],
    ),
  );
}

void showTripSheet(
  BuildContext context,
  TripRequest trip,
  PartnerStore store,
  void Function([int?]) refresh,
) => showModalBottomSheet<void>(
  context: context,
  isScrollControlled: true,
  backgroundColor: cream,
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
  ),
  builder: (context) => DraggableScrollableSheet(
    expand: false,
    initialChildSize: .78,
    maxChildSize: .9,
    builder: (_, controller) => ListView(
      controller: controller,
      padding: const EdgeInsets.all(20),
      children: [
        Center(child: Container(width: 40, height: 5, color: Colors.black12)),
        const SizedBox(height: 22),
        Row(
          children: [
            StatusPill(trip.vehicle.toUpperCase()),
            const Spacer(),
            Text(
              trip.id,
              style: const TextStyle(color: muted, fontWeight: FontWeight.w700),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          '${trip.pickup} to ${trip.dropoff}',
          style: const TextStyle(fontSize: 23, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 6),
        Text(
          '${trip.time} · ${trip.people} passengers',
          style: const TextStyle(color: muted),
        ),
        const SizedBox(height: 18),
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              RouteRow(Icons.radio_button_checked, navy, 'PICKUP', trip.pickup),
              const Divider(height: 25),
              RouteRow(
                Icons.location_on,
                Colors.deepOrangeAccent,
                'DROP-OFF',
                trip.dropoff,
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: StatCard(Icons.schedule, trip.duration, 'Drive time'),
            ),
            const SizedBox(width: 8),
            Expanded(child: StatCard(Icons.route, trip.distance, 'Distance')),
            const SizedBox(width: 8),
            Expanded(
              child: StatCard(
                Icons.payments_outlined,
                'R ${trip.fare}',
                'Your fare',
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Card(
          elevation: 0,
          child: ListTile(
            leading: const Icon(Icons.sticky_note_2_outlined),
            title: const Text(
              'Traveller note',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            subtitle: Text(trip.note),
          ),
        ),
        const SizedBox(height: 18),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  store.decline(trip);
                  Navigator.pop(context);
                  refresh();
                },
                style: OutlinedButton.styleFrom(minimumSize: const Size(0, 55)),
                child: const Text('Decline'),
              ),
            ),
            const SizedBox(width: 9),
            Expanded(
              flex: 2,
              child: PrimaryButton(
                label: 'Accept · R ${trip.fare}',
                onPressed: () {
                  store.accept(trip);
                  Navigator.pop(context);
                  refresh(0);
                },
              ),
            ),
          ],
        ),
      ],
    ),
  ),
);
