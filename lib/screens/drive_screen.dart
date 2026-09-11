part of '../main.dart';

class DriveScreen extends StatelessWidget {
  const DriveScreen({super.key, required this.store, required this.refresh});
  final PartnerStore store;
  final void Function([int?]) refresh;
  @override
  Widget build(BuildContext context) => SafeArea(
    child: ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Row(
          children: [
            const BrandLogo(dark: true),
            const SizedBox(width: 10),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Good afternoon,',
                  style: TextStyle(color: muted, fontSize: 12),
                ),
                Text(
                  'Kagiso',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
                ),
              ],
            ),
            const Spacer(),
            const StatusPill('● ONLINE'),
          ],
        ),
        const SizedBox(height: 28),
        if (store.active == null)
          ..._idle(context)
        else
          ActiveTrip(store: store, refresh: refresh),
      ],
    ),
  );
  List<Widget> _idle(BuildContext context) => [
    Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: navy,
        borderRadius: BorderRadius.circular(26),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.radar, color: mint),
              Spacer(),
              Text(
                'READY TO DRIVE',
                style: TextStyle(
                  color: mint,
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          const Text(
            'You’re all set.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 27,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            '${store.pending.length} trip requests are waiting nearby.',
            style: const TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 18),
          PrimaryButton(
            label: 'View trip requests',
            light: true,
            onPressed: () => refresh(1),
          ),
        ],
      ),
    ),
    const SizedBox(height: 24),
    const SectionTitle('Next request'),
    const SizedBox(height: 10),
    if (store.pending.isNotEmpty)
      TripCard(
        trip: store.pending.first,
        onTap: () =>
            showTripSheet(context, store.pending.first, store, refresh),
      )
    else
      const EmptyTrips(),
    const SizedBox(height: 24),
    const SectionTitle('Today at a glance'),
    const SizedBox(height: 10),
    const Row(
      children: [
        Expanded(child: StatCard(Icons.route, '6', 'Trips')),
        SizedBox(width: 8),
        Expanded(
          child: StatCard(Icons.payments_outlined, 'R 1,840', 'Earnings'),
        ),
        SizedBox(width: 8),
        Expanded(child: StatCard(Icons.star_outline, '4.92', 'Rating')),
      ],
    ),
  ];
}

class ActiveTrip extends StatelessWidget {
  const ActiveTrip({super.key, required this.store, required this.refresh});
  final PartnerStore store;
  final VoidCallback refresh;
  @override
  Widget build(BuildContext context) {
    final trip = store.active!,
        progress = store.stage == TripStage.inProgress,
        arrived = store.stage == TripStage.arrived;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const SectionTitle('Active trip'),
            const Spacer(),
            StatusPill(
              progress
                  ? 'IN PROGRESS'
                  : arrived
                  ? 'AT PICKUP'
                  : 'ACCEPTED',
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: navy,
            borderRadius: BorderRadius.circular(26),
          ),
          child: Column(
            children: [
              SizedBox(
                height: 190,
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(26),
                  ),
                  child: TripMap(trip: trip),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    RouteRow(
                      Icons.radio_button_checked,
                      mint,
                      'PICKUP',
                      trip.pickup,
                      dark: true,
                    ),
                    const Divider(color: Colors.white24, height: 24),
                    RouteRow(
                      Icons.location_on,
                      Colors.white,
                      'DROP-OFF',
                      trip.dropoff,
                      dark: true,
                    ),
                    const SizedBox(height: 15),
                    Text(
                      '${trip.duration}  ·  ${trip.distance}  ·  R ${trip.fare}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (_) =>
                        NavigationScreen(trip: trip, toDropoff: progress),
                  ),
                ),
                icon: const Icon(Icons.navigation_outlined),
                label: const Text('Navigate'),
                style: OutlinedButton.styleFrom(minimumSize: const Size(0, 55)),
              ),
            ),
            const SizedBox(width: 9),
            Expanded(
              child: PrimaryButton(
                label: progress
                    ? 'Complete trip'
                    : arrived
                    ? 'Start trip'
                    : 'I’ve arrived',
                onPressed: () {
                  store.advance();
                  refresh();
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Card(
          elevation: 0,
          child: ListTile(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute<void>(builder: (_) => RiderScreen(trip: trip)),
            ),
            leading: CircleAvatar(child: Text(trip.rider[0])),
            title: Text(
              trip.rider,
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
            subtitle: Text('★ ${trip.rating} · ${trip.people} passengers'),
            trailing: const Icon(Icons.call_outlined),
          ),
        ),
      ],
    );
  }
}

class TripMap extends StatelessWidget {
  const TripMap({super.key, required this.trip});
  final TripRequest trip;
  @override
  Widget build(BuildContext context) {
    final points = [trip.pickupPoint, trip.dropoffPoint];
    final center = LatLng(
      (points[0].latitude + points[1].latitude) / 2,
      (points[0].longitude + points[1].longitude) / 2,
    );
    return FlutterMap(
      options: MapOptions(initialCenter: center, initialZoom: 10.2),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.riendzo.riendzo_partner',
        ),
        PolylineLayer(
          polylines: [
            Polyline(points: points, strokeWidth: 5, color: navy),
            Polyline(points: points, strokeWidth: 2, color: mint),
          ],
        ),
        MarkerLayer(
          markers: [
            Marker(
              point: trip.pickupPoint,
              width: 40,
              height: 40,
              child: const CircleAvatar(
                backgroundColor: navy,
                child: Icon(Icons.person_pin_circle, color: mint),
              ),
            ),
            Marker(
              point: trip.dropoffPoint,
              width: 40,
              height: 40,
              child: const CircleAvatar(
                backgroundColor: Colors.deepOrange,
                child: Icon(Icons.flag, color: Colors.white),
              ),
            ),
          ],
        ),
        RichAttributionWidget(
          attributions: [
            TextSourceAttribution(
              'OpenStreetMap contributors',
              onTap: () => launchUrl(
                Uri.parse('https://www.openstreetmap.org/copyright'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
