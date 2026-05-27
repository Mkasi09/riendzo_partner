import 'package:flutter/material.dart';
import 'package:riendzo_partner/data/sample_trips.dart';
import 'package:riendzo_partner/features/driver/views/dashboard_view.dart';
import 'package:riendzo_partner/features/driver/views/earnings_view.dart';
import 'package:riendzo_partner/features/driver/views/profile_view.dart';
import 'package:riendzo_partner/features/driver/views/requests_view.dart';
import 'package:riendzo_partner/models/partner_trip.dart';
import 'package:riendzo_partner/services/auth_service.dart';
import 'package:riendzo_partner/services/transport_request_service.dart';

class DriverHomeScreen extends StatefulWidget {
  const DriverHomeScreen({
    super.key,
    AuthService? authService,
    TransportRequestService? transportRequestService,
    this.useRemoteRequests = true,
  }) : _authService = authService,
       _transportRequestService = transportRequestService;

  final AuthService? _authService;
  final TransportRequestService? _transportRequestService;
  final bool useRemoteRequests;

  @override
  State<DriverHomeScreen> createState() => _DriverHomeScreenState();
}

class _DriverHomeScreenState extends State<DriverHomeScreen> {
  bool _isOnline = true;
  int _selectedTab = 0;
  PartnerTrip? _activeTrip;
  final List<PartnerTrip> _requests = List.of(sampleTrips);
  final List<PartnerTrip> _completedTrips = [];

  AuthService get _authService => widget._authService ?? AuthService();
  TransportRequestService get _transportRequestService =>
      widget._transportRequestService ?? TransportRequestService();

  void _toggleOnline(bool value) {
    setState(() => _isOnline = value);
  }

  void _acceptTrip(PartnerTrip trip) {
    if (widget.useRemoteRequests && trip.transportRequestId != null) {
      _transportRequestService.acceptRequest(trip);
    }
    setState(() {
      _requests.removeWhere((request) => request.id == trip.id);
      _activeTrip = trip.copyWith(status: TripStatus.accepted);
      _selectedTab = 0;
    });
  }

  void _declineTrip(PartnerTrip trip) {
    if (widget.useRemoteRequests && trip.transportRequestId != null) {
      _transportRequestService.declineRequest(trip);
    }
    setState(() {
      _requests.removeWhere((request) => request.id == trip.id);
    });
  }

  void _advanceTrip() {
    final activeTrip = _activeTrip;
    if (activeTrip == null) return;

    setState(() {
      switch (activeTrip.status) {
        case TripStatus.accepted:
          _activeTrip = activeTrip.copyWith(status: TripStatus.pickupArrived);
        case TripStatus.pickupArrived:
          _activeTrip = activeTrip.copyWith(status: TripStatus.inProgress);
        case TripStatus.inProgress:
          _completedTrips.insert(
            0,
            activeTrip.copyWith(status: TripStatus.completed),
          );
          _activeTrip = null;
        case TripStatus.requested:
        case TripStatus.completed:
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.useRemoteRequests) {
      return StreamBuilder<List<PartnerTrip>>(
        stream: _transportRequestService.watchPendingRequests(),
        builder: (context, snapshot) {
          final remoteRequests = snapshot.data ?? _requests;
          return _buildScaffold(remoteRequests);
        },
      );
    }

    return _buildScaffold(_requests);
  }

  Widget _buildScaffold(List<PartnerTrip> requests) {
    final pages = [
      DashboardView(
        isOnline: _isOnline,
        activeTrip: _activeTrip,
        requests: requests,
        onOnlineChanged: _toggleOnline,
        onAccept: _acceptTrip,
        onDecline: _declineTrip,
        onAdvanceTrip: _advanceTrip,
      ),
      RequestsView(
        requests: requests,
        isOnline: _isOnline,
        onAccept: _acceptTrip,
        onDecline: _declineTrip,
      ),
      EarningsView(completedTrips: _completedTrips),
      ProfileView(onSignOut: () => _authService.signOut()),
    ];

    return Scaffold(
      body: SafeArea(child: pages[_selectedTab]),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedTab,
        onDestinationSelected: (index) => setState(() => _selectedTab = index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.map_outlined),
            selectedIcon: Icon(Icons.map),
            label: 'Drive',
          ),
          NavigationDestination(
            icon: Icon(Icons.local_taxi_outlined),
            selectedIcon: Icon(Icons.local_taxi),
            label: 'Trips',
          ),
          NavigationDestination(
            icon: Icon(Icons.payments_outlined),
            selectedIcon: Icon(Icons.payments),
            label: 'Earnings',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
