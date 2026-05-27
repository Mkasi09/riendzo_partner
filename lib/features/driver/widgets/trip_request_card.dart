import 'package:flutter/material.dart';
import 'package:riendzo_partner/features/driver/widgets/trip_summary_widgets.dart';
import 'package:riendzo_partner/models/partner_trip.dart';
import 'package:riendzo_partner/widgets/panel.dart';
import 'package:riendzo_partner/widgets/pill.dart';

class TripRequestCard extends StatelessWidget {
  const TripRequestCard({
    super.key,
    required this.trip,
    required this.onAccept,
    required this.onDecline,
  });

  final PartnerTrip trip;
  final VoidCallback onAccept;
  final VoidCallback onDecline;

  @override
  Widget build(BuildContext context) {
    return Panel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.notifications_active, color: Color(0xFF416FDF)),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Incoming transport request',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                ),
              ),
              Pill(
                text: '${trip.pickupEta} min',
                color: const Color(0xFFEFF6FF),
                textColor: const Color(0xFF416FDF),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TripIdentity(trip: trip),
          const SizedBox(height: 16),
          MetricsRow(trip: trip),
          const SizedBox(height: 16),
          Text(
            trip.note,
            style: const TextStyle(color: Color(0xFF4B5563), height: 1.35),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onDecline,
                  icon: const Icon(Icons.close),
                  label: const Text('Decline'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton.icon(
                  onPressed: onAccept,
                  icon: const Icon(Icons.check),
                  label: const Text('Accept'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
