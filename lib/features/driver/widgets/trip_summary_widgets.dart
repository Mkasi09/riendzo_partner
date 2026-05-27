import 'package:flutter/material.dart';
import 'package:riendzo_partner/models/partner_trip.dart';
import 'package:riendzo_partner/widgets/panel.dart';

class TripIdentity extends StatelessWidget {
  const TripIdentity({super.key, required this.trip});

  final PartnerTrip trip;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: const Color(0xFFEFF6FF),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              trip.riderName.substring(0, 1),
              style: const TextStyle(
                fontWeight: FontWeight.w900,
                color: Color(0xFF416FDF),
                fontSize: 18,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                trip.riderName,
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                ),
              ),
              Text(
                trip.tripName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Color(0xFF6B7280)),
              ),
            ],
          ),
        ),
        const Icon(Icons.star, color: Color(0xFFF59E0B), size: 18),
        Text(
          ' ${trip.rating}',
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}

class MetricsRow extends StatelessWidget {
  const MetricsRow({super.key, required this.trip});

  final PartnerTrip trip;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Metric(
            icon: Icons.schedule,
            label: 'Duration',
            value: '${trip.tripDuration}m',
          ),
        ),
        Expanded(
          child: Metric(
            icon: Icons.route,
            label: 'Distance',
            value: '${trip.distanceKm.toStringAsFixed(1)}km',
          ),
        ),
        Expanded(
          child: Metric(
            icon: Icons.payments,
            label: 'Fare',
            value: 'R${trip.fare.toStringAsFixed(0)}',
          ),
        ),
      ],
    );
  }
}

class Metric extends StatelessWidget {
  const Metric({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: const Color(0xFF416FDF)),
          const SizedBox(height: 7),
          Text(
            label,
            style: const TextStyle(fontSize: 11, color: Color(0xFF6B7280)),
          ),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }
}

class StatTile extends StatelessWidget {
  const StatTile({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Panel(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFF416FDF), size: 20),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 20),
          ),
          Text(
            label,
            style: const TextStyle(color: Color(0xFF6B7280), fontSize: 12),
          ),
        ],
      ),
    );
  }
}
