part of '../main.dart';

class FirebasePartnerService {
  FirebasePartnerService(this.store);
  final PartnerStore store;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _requests;
  FirebaseFirestore get db => FirebaseFirestore.instance;
  User get driver => FirebaseAuth.instance.currentUser!;

  void start() {
    store.setLoading();
    _requests = db
        .collection('transport_requests')
        .where('status', isEqualTo: 'pending')
        .snapshots()
        .listen((snapshot) {
          final requests =
              snapshot.docs
                  .where((doc) {
                    final declined = doc.data()['declinedBy'];
                    return declined is! List || !declined.contains(driver.uid);
                  })
                  .map(_fromDocument)
                  .whereType<TripRequest>()
                  .toList()
                ..sort((a, b) => a.time.compareTo(b.time));
          store.replacePending(requests);
        }, onError: store.setError);
  }

  TripRequest? _fromDocument(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    if (data == null) return null;
    final pickup = (data['pickup'] as String? ?? '').trim();
    final dropoff = (data['dropoff'] as String? ?? '').trim();
    if (pickup.isEmpty || dropoff.isEmpty) return null;
    final pickupAt = data['pickupAt'];
    return TripRequest(
      id: doc.id,
      tripId: data['tripId'] as String?,
      rider: _text(data['riderName'], 'Riendzo traveller'),
      rating: _number(data['riderRating'], 5),
      pickup: pickup,
      dropoff: dropoff,
      time: pickupAt is Timestamp
          ? _formatPickup(pickupAt.toDate())
          : _text(
              data['pickupTime'],
              _text(data['tripStartDate'], 'Scheduled'),
            ),
      duration: '${_number(data['durationMinutes'], 0).round()} min',
      distance: '${_number(data['distanceKm'], 0).toStringAsFixed(1)} km',
      vehicle: _text(data['transportType'], 'Standard'),
      people: _number(data['passengers'], 1).round(),
      fare: _number(data['estimatedFare'], 0).round(),
      note: _text(data['note'], 'No traveller note'),
      pickupPoint: _point(
        data['pickupCoordinates'] ?? data['pickupLocation'],
        const LatLng(-26.1452, 28.0449),
      ),
      dropoffPoint: _point(
        data['dropoffCoordinates'] ?? data['dropoffLocation'],
        const LatLng(-26.2041, 28.0473),
      ),
    );
  }

  Future<void> accept(TripRequest trip) async {
    final requestRef = db.collection('transport_requests').doc(trip.id);
    await db.runTransaction((transaction) async {
      final snapshot = await transaction.get(requestRef);
      if (!snapshot.exists || snapshot.data()?['status'] != 'pending') {
        throw StateError(
          'This request was already accepted by another driver.',
        );
      }
      final driverName =
          driver.displayName ?? driver.email ?? 'Riendzo partner';
      transaction.update(requestRef, {
        'status': 'accepted',
        'acceptedBy': driver.uid,
        'driverId': driver.uid,
        'driverName': driverName,
        'acceptedAt': FieldValue.serverTimestamp(),
      });
      if (trip.tripId != null && trip.tripId!.isNotEmpty) {
        transaction.update(db.collection('trips').doc(trip.tripId), {
          'transport.status': 'accepted',
          'transport.driverId': driver.uid,
          'transport.driverName': driverName,
          'transport.requestId': trip.id,
        });
      }
    });
  }

  Future<void> decline(TripRequest trip) =>
      db.collection('transport_requests').doc(trip.id).update({
        'declinedBy': FieldValue.arrayUnion([driver.uid]),
        'lastDeclinedAt': FieldValue.serverTimestamp(),
      });

  Future<void> updateStage(TripRequest trip, String stage) async {
    final status = stage == 'arrived' ? 'pickupArrived' : stage;
    final batch = db.batch();
    batch.update(db.collection('transport_requests').doc(trip.id), {
      'status': status,
      'updatedAt': FieldValue.serverTimestamp(),
      if (status == 'completed') 'completedAt': FieldValue.serverTimestamp(),
    });
    if (trip.tripId != null && trip.tripId!.isNotEmpty) {
      batch.update(db.collection('trips').doc(trip.tripId), {
        'transport.status': status,
      });
    }
    await batch.commit();
  }

  void dispose() => _requests?.cancel();

  static String _text(Object? value, String fallback) {
    final text = value?.toString().trim() ?? '';
    return text.isEmpty ? fallback : text;
  }

  static double _number(Object? value, double fallback) =>
      value is num ? value.toDouble() : double.tryParse('$value') ?? fallback;
  static LatLng _point(Object? value, LatLng fallback) {
    if (value is GeoPoint) return LatLng(value.latitude, value.longitude);
    if (value is Map) {
      final lat = _number(value['latitude'] ?? value['lat'], double.nan);
      final lng = _number(value['longitude'] ?? value['lng'], double.nan);
      if (!lat.isNaN && !lng.isNaN) return LatLng(lat, lng);
    }
    return fallback;
  }

  static String _formatPickup(DateTime value) {
    final local = value.toLocal();
    final now = DateTime.now();
    final day =
        local.year == now.year &&
            local.month == now.month &&
            local.day == now.day
        ? 'Today'
        : '${local.day.toString().padLeft(2, '0')}/${local.month.toString().padLeft(2, '0')}';
    return '$day · ${local.hour.toString().padLeft(2, '0')}:${local.minute.toString().padLeft(2, '0')}';
  }
}
