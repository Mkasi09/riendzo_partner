import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:riendzo_partner/features/driver/widgets/trip_summary_widgets.dart';
import 'package:riendzo_partner/models/partner_trip.dart';
import 'package:riendzo_partner/widgets/panel.dart';

class EarningsView extends StatelessWidget {
  const EarningsView({super.key, required this.completedTrips});

  final List<PartnerTrip> completedTrips;

  @override
  Widget build(BuildContext context) {
    final completedTotal = completedTrips.fold<double>(
      0,
      (sum, trip) => sum + trip.fare,
    );
    final projectedTotal = completedTotal + 1180;

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text(
          'Earnings',
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 18),
        Panel(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Today',
                style: TextStyle(
                  color: Color(0xFF6B7280),
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'R${projectedTotal.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontSize: 38,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 10),
              LinearProgressIndicator(
                value: math.min(projectedTotal / 1800, 1),
                minHeight: 8,
                borderRadius: BorderRadius.circular(8),
              ),
              const SizedBox(height: 10),
              const Text(
                'Includes completed trips and sample projected bookings.',
                style: TextStyle(color: Color(0xFF6B7280)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        const Row(
          children: [
            Expanded(
              child: StatTile(
                label: 'Trips',
                value: '7',
                icon: Icons.local_taxi,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: StatTile(label: 'Hours', value: '5.4', icon: Icons.timer),
            ),
            SizedBox(width: 12),
            Expanded(
              child: StatTile(
                label: 'Tips',
                value: 'R96',
                icon: Icons.volunteer_activism,
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        const Text(
          'Recent completed trips',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 10),
        if (completedTrips.isEmpty)
          const Text(
            'Complete an active trip and it will show here.',
            style: TextStyle(color: Color(0xFF6B7280)),
          )
        else
          for (final trip in completedTrips)
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const CircleAvatar(child: Icon(Icons.done)),
              title: Text(trip.riderName),
              subtitle: Text(trip.dropoff),
              trailing: Text(
                'R${trip.fare.toStringAsFixed(0)}',
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
            ),
      ],
    );
  }
}
