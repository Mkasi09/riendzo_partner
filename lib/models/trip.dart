part of '../main.dart';

enum TripStage { accepted, arrived, inProgress }

class TripRequest {
  const TripRequest({
    required this.id,
    required this.rider,
    required this.rating,
    required this.pickup,
    required this.dropoff,
    required this.time,
    required this.duration,
    required this.distance,
    required this.vehicle,
    required this.people,
    required this.fare,
    required this.note,
    required this.pickupPoint,
    required this.dropoffPoint,
    this.tripId,
  });
  final String id,
      rider,
      pickup,
      dropoff,
      time,
      duration,
      distance,
      vehicle,
      note;
  final double rating;
  final int people, fare;
  final LatLng pickupPoint, dropoffPoint;
  final String? tripId;
}

class PartnerStore extends ChangeNotifier {
  PartnerStore.demo() : connected = false {
    pending.addAll(_demoTrips);
  }
  PartnerStore.connected() : connected = true {
    _firebase = FirebasePartnerService(this);
    _firebase!.start();
  }
  final bool connected;
  FirebasePartnerService? _firebase;
  final pending = <TripRequest>[];
  TripRequest? active;
  TripStage stage = TripStage.accepted;
  bool loading = false;
  String? error;

  void replacePending(List<TripRequest> requests) {
    pending
      ..clear()
      ..addAll(requests);
    loading = false;
    error = null;
    notifyListeners();
  }

  void setLoading() {
    loading = true;
    notifyListeners();
  }

  void setError(Object value) {
    loading = false;
    error = value.toString();
    notifyListeners();
  }

  Future<void> accept(TripRequest trip) async {
    if (active != null) return;
    pending.remove(trip);
    active = trip;
    stage = TripStage.accepted;
    notifyListeners();
    try {
      await _firebase?.accept(trip);
    } catch (e) {
      active = null;
      pending.add(trip);
      setError(e);
    }
  }

  Future<void> decline(TripRequest trip) async {
    pending.remove(trip);
    notifyListeners();
    try {
      await _firebase?.decline(trip);
    } catch (e) {
      pending.add(trip);
      setError(e);
    }
  }

  Future<void> advance() async {
    final trip = active;
    if (trip == null) return;
    if (stage == TripStage.accepted) {
      stage = TripStage.arrived;
    } else if (stage == TripStage.arrived) {
      stage = TripStage.inProgress;
    } else {
      active = null;
      stage = TripStage.accepted;
    }
    notifyListeners();
    await _firebase?.updateStage(
      trip,
      active == null ? 'completed' : stage.name,
    );
  }

  @override
  void dispose() {
    _firebase?.dispose();
    super.dispose();
  }
}

const _demoTrips = <TripRequest>[
  TripRequest(
    id: 'RZ-4812',
    rider: 'Naledi M.',
    rating: 4.9,
    pickup: 'Rosebank Gautrain Station',
    dropoff: 'Vilakazi Street, Orlando West',
    time: 'Today · 14:30',
    duration: '34 min',
    distance: '23.8 km',
    vehicle: 'Comfort',
    people: 2,
    fare: 286,
    note: 'Two small suitcases. Meet at the north entrance.',
    pickupPoint: LatLng(-26.1452, 28.0449),
    dropoffPoint: LatLng(-26.2381, 27.9088),
  ),
  TripRequest(
    id: 'RZ-4835',
    rider: 'Thabo K.',
    rating: 4.8,
    pickup: 'O.R. Tambo International Airport',
    dropoff: 'Sandton City, Sandton',
    time: 'Today · 16:15',
    duration: '31 min',
    distance: '29.4 km',
    vehicle: 'XL',
    people: 4,
    fare: 412,
    note: 'Flight SA204. Please wait at arrivals.',
    pickupPoint: LatLng(-26.1367, 28.2411),
    dropoffPoint: LatLng(-26.1076, 28.0567),
  ),
  TripRequest(
    id: 'RZ-4861',
    rider: 'Amelia P.',
    rating: 5,
    pickup: 'The Catalyst Hotel, Sandton',
    dropoff: 'Maropeng Visitor Centre',
    time: 'Tomorrow · 08:00',
    duration: '58 min',
    distance: '58.2 km',
    vehicle: 'Comfort',
    people: 2,
    fare: 648,
    note: 'Day trip with one backpack each.',
    pickupPoint: LatLng(-26.1043, 28.061),
    dropoffPoint: LatLng(-25.9678, 27.662),
  ),
];
