import 'package:flutter/material.dart';
import 'package:riendzo_partner/features/driver/widgets/active_trip_card.dart';
import 'package:riendzo_partner/features/driver/widgets/driver_header.dart';
import 'package:riendzo_partner/features/driver/widgets/idle_card.dart';
import 'package:riendzo_partner/features/driver/widgets/map_panel.dart';
import 'package:riendzo_partner/features/driver/widgets/trip_request_card.dart';
import 'package:riendzo_partner/features/driver/widgets/trip_summary_widgets.dart';
import 'package:riendzo_partner/models/partner_trip.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({
    super.key,
    required this.isOnline,
    required this.activeTrip,
    required this.requests,
    required this.onOnlineChanged,
    required this.onAccept,
    required this.onDecline,
    required this.onAdvanceTrip,
  });

  final bool isOnline;
  final PartnerTrip? activeTrip;
  final List<PartnerTrip> requests;
  final ValueChanged<bool> onOnlineChanged;
  final ValueChanged<PartnerTrip> onAccept;
  final ValueChanged<PartnerTrip> onDecline;
  final VoidCallback onAdvanceTrip;

  @override
  Widget build(BuildContext context) {
    final nextRequest = isOnline && activeTrip == null && requests.isNotEmpty
        ? requests.first
        : null;

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 12),
            child: DriverHeader(
              isOnline: isOnline,
              onOnlineChanged: onOnlineChanged,
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: MapPanel(activeTrip: activeTrip, nextRequest: nextRequest),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: activeTrip != null
                  ? ActiveTripCard(
                      key: ValueKey(activeTrip!.status),
                      trip: activeTrip!,
                      onAdvance: onAdvanceTrip,
                    )
                  : nextRequest != null
                  ? TripRequestCard(
                      key: ValueKey(nextRequest.id),
                      trip: nextRequest,
                      onAccept: () => onAccept(nextRequest),
                      onDecline: () => onDecline(nextRequest),
                    )
                  : IdleCard(isOnline: isOnline, queuedTrips: requests.length),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
            child: Row(
              children: [
                Expanded(
                  child: StatTile(
                    label: 'Requests',
                    value: '${requests.length}',
                    icon: Icons.inbox,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: StatTile(
                    label: 'Active',
                    value: activeTrip == null ? '0' : '1',
                    icon: Icons.navigation,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: StatTile(
                    label: 'Rating',
                    value: '4.92',
                    icon: Icons.star,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
