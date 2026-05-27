import 'package:flutter/material.dart';
import 'package:riendzo_partner/widgets/panel.dart';

class IdleCard extends StatelessWidget {
  const IdleCard({
    super.key,
    required this.isOnline,
    required this.queuedTrips,
  });

  final bool isOnline;
  final int queuedTrips;

  @override
  Widget build(BuildContext context) {
    return Panel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            isOnline ? Icons.radar : Icons.pause_circle,
            color: isOnline ? const Color(0xFF12A87E) : const Color(0xFF6B7280),
            size: 32,
          ),
          const SizedBox(height: 12),
          Text(
            isOnline
                ? 'Listening for Riendzo transport bookings'
                : 'You are offline',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 6),
          Text(
            isOnline
                ? queuedTrips == 0
                      ? 'New requests will appear here when travelers add transport to their trip.'
                      : 'You have $queuedTrips queued requests. Open Trips to review them.'
                : 'Go online when you are ready to receive driver requests.',
            style: const TextStyle(color: Color(0xFF6B7280), height: 1.35),
          ),
        ],
      ),
    );
  }
}
