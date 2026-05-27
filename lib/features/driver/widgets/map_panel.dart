import 'package:flutter/material.dart';
import 'package:riendzo_partner/features/driver/widgets/route_map_painter.dart';
import 'package:riendzo_partner/models/partner_trip.dart';

class MapPanel extends StatelessWidget {
  const MapPanel({
    super.key,
    required this.activeTrip,
    required this.nextRequest,
  });

  final PartnerTrip? activeTrip;
  final PartnerTrip? nextRequest;

  @override
  Widget build(BuildContext context) {
    final trip = activeTrip ?? nextRequest;
    final title = activeTrip == null
        ? 'Nearby trip route'
        : _statusTitle(activeTrip!.status);

    return Container(
      height: 310,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 22,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          CustomPaint(painter: RouteMapPainter(hasTrip: trip != null)),
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Row(
              children: [
                Expanded(
                  child: _MapBadge(
                    icon: Icons.near_me,
                    title: title,
                    value: trip == null
                        ? 'Waiting for Riendzo bookings'
                        : '${trip.distanceKm.toStringAsFixed(1)} km',
                  ),
                ),
                const SizedBox(width: 10),
                const _CircleMapButton(icon: Icons.my_location),
              ],
            ),
          ),
          if (trip != null)
            Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: _RouteSummary(trip: trip),
            ),
        ],
      ),
    );
  }

  String _statusTitle(TripStatus status) {
    return switch (status) {
      TripStatus.accepted => 'Drive to pickup',
      TripStatus.pickupArrived => 'Rider pickup',
      TripStatus.inProgress => 'Navigate to dropoff',
      TripStatus.requested => 'Incoming request',
      TripStatus.completed => 'Trip completed',
    };
  }
}

class _MapBadge extends StatelessWidget {
  const _MapBadge({
    required this.icon,
    required this.title,
    required this.value,
  });

  final IconData icon;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF416FDF), size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    color: Color(0xFF6B7280),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CircleMapButton extends StatelessWidget {
  const _CircleMapButton({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Icon(icon, color: const Color(0xFF172033)),
    );
  }
}

class _RouteSummary extends StatelessWidget {
  const _RouteSummary({required this.trip});

  final PartnerTrip trip;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          _RoutePoint(
            color: const Color(0xFF12A87E),
            label: 'Pickup',
            value: trip.pickup,
          ),
          const Padding(
            padding: EdgeInsets.only(left: 9),
            child: Align(
              alignment: Alignment.centerLeft,
              child: SizedBox(height: 18, child: VerticalDivider(width: 1)),
            ),
          ),
          _RoutePoint(
            color: const Color(0xFFEF4444),
            label: 'Dropoff',
            value: trip.dropoff,
          ),
        ],
      ),
    );
  }
}

class _RoutePoint extends StatelessWidget {
  const _RoutePoint({
    required this.color,
    required this.label,
    required this.value,
  });

  final Color color;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 18,
          height: 18,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 10),
        Text(
          '$label: ',
          style: const TextStyle(color: Color(0xFF6B7280), fontSize: 12),
        ),
        Expanded(
          child: Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
      ],
    );
  }
}
