import 'package:flutter/material.dart';
import 'package:riendzo_partner/features/driver/widgets/idle_card.dart';
import 'package:riendzo_partner/features/driver/widgets/trip_request_card.dart';
import 'package:riendzo_partner/models/partner_trip.dart';

class RequestsView extends StatelessWidget {
  const RequestsView({
    super.key,
    required this.requests,
    required this.isOnline,
    required this.onAccept,
    required this.onDecline,
  });

  final List<PartnerTrip> requests;
  final bool isOnline;
  final ValueChanged<PartnerTrip> onAccept;
  final ValueChanged<PartnerTrip> onDecline;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text(
          'Trip Requests',
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 6),
        Text(
          isOnline
              ? 'Transport requests from travelers building trips in Riendzo.'
              : 'Go online to receive fresh requests.',
          style: const TextStyle(color: Color(0xFF6B7280)),
        ),
        const SizedBox(height: 18),
        if (requests.isEmpty)
          IdleCard(isOnline: isOnline, queuedTrips: 0)
        else
          for (final trip in requests) ...[
            TripRequestCard(
              trip: trip,
              onAccept: () => onAccept(trip),
              onDecline: () => onDecline(trip),
            ),
            const SizedBox(height: 14),
          ],
      ],
    );
  }
}
