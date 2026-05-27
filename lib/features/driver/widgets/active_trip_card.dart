import 'package:flutter/material.dart';
import 'package:riendzo_partner/features/driver/widgets/trip_summary_widgets.dart';
import 'package:riendzo_partner/models/partner_trip.dart';
import 'package:riendzo_partner/widgets/panel.dart';
import 'package:riendzo_partner/widgets/pill.dart';

class ActiveTripCard extends StatelessWidget {
  const ActiveTripCard({
    super.key,
    required this.trip,
    required this.onAdvance,
  });

  final PartnerTrip trip;
  final VoidCallback onAdvance;

  @override
  Widget build(BuildContext context) {
    return Panel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(_statusIcon, color: const Color(0xFF12A87E)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _statusText,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Pill(
                text: trip.id,
                color: const Color(0xFFECFDF5),
                textColor: const Color(0xFF0F9F6E),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TripIdentity(trip: trip),
          const SizedBox(height: 16),
          MetricsRow(trip: trip),
          const SizedBox(height: 18),
          FilledButton.icon(
            onPressed: onAdvance,
            icon: Icon(_buttonIcon),
            label: Text(_buttonText),
          ),
        ],
      ),
    );
  }

  IconData get _statusIcon {
    return switch (trip.status) {
      TripStatus.accepted => Icons.route,
      TripStatus.pickupArrived => Icons.person_pin_circle,
      TripStatus.inProgress => Icons.navigation,
      TripStatus.requested => Icons.local_taxi,
      TripStatus.completed => Icons.done_all,
    };
  }

  IconData get _buttonIcon {
    return switch (trip.status) {
      TripStatus.accepted => Icons.location_on,
      TripStatus.pickupArrived => Icons.play_arrow,
      TripStatus.inProgress => Icons.flag,
      TripStatus.requested => Icons.check,
      TripStatus.completed => Icons.done,
    };
  }

  String get _statusText {
    return switch (trip.status) {
      TripStatus.accepted => 'Accepted: head to pickup',
      TripStatus.pickupArrived => 'Arrived: confirm rider pickup',
      TripStatus.inProgress => 'Trip in progress',
      TripStatus.requested => 'Trip requested',
      TripStatus.completed => 'Trip completed',
    };
  }

  String get _buttonText {
    return switch (trip.status) {
      TripStatus.accepted => 'Mark arrived at pickup',
      TripStatus.pickupArrived => 'Start trip',
      TripStatus.inProgress => 'Complete trip',
      TripStatus.requested => 'Accept trip',
      TripStatus.completed => 'Done',
    };
  }
}
