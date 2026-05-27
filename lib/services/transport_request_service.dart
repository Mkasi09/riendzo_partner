import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riendzo_partner/models/partner_trip.dart';
import 'package:riendzo_partner/services/transport_fare_calculator.dart';

class TransportRequestService {
  TransportRequestService({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  Stream<List<PartnerTrip>> watchPendingRequests() {
    return _firestore
        .collection('transport_requests')
        .where('status', isEqualTo: 'pending')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => _tripFromDocument(doc))
              .whereType<PartnerTrip>()
              .toList(),
        );
  }

  Future<void> acceptRequest(PartnerTrip trip) async {
    final requestId = trip.transportRequestId;
    final driver = FirebaseAuth.instance.currentUser;
    if (requestId == null) return;

    await _firestore.collection('transport_requests').doc(requestId).update({
      'status': 'accepted',
      'acceptedBy': driver?.uid,
      'acceptedByName': driver?.displayName ?? driver?.email,
      'acceptedAt': FieldValue.serverTimestamp(),
    });

    final tripId = trip.tripId;
    if (tripId != null && tripId.isNotEmpty) {
      await _firestore.collection('trips').doc(tripId).update({
        'transport.status': 'accepted',
        'transport.driverId': driver?.uid,
        'transport.driverName': driver?.displayName ?? driver?.email,
      });
    }
  }

  Future<void> declineRequest(PartnerTrip trip) async {
    final requestId = trip.transportRequestId;
    final driver = FirebaseAuth.instance.currentUser;
    if (requestId == null) return;

    await _firestore.collection('transport_requests').doc(requestId).update({
      'declinedBy': FieldValue.arrayUnion([driver?.uid ?? 'unknown-driver']),
      'lastDeclinedAt': FieldValue.serverTimestamp(),
    });
  }

  PartnerTrip? _tripFromDocument(
    QueryDocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data();
    final pickup = (data['pickup'] ?? '').toString();
    final dropoff = (data['dropoff'] ?? data['destination'] ?? '').toString();
    if (pickup.isEmpty || dropoff.isEmpty) return null;
    final distanceKm = (data['distanceKm'] as num?)?.toDouble() ?? 18;
    final durationMinutes = (data['durationMinutes'] as num?)?.toInt() ?? 35;
    final transportType = (data['transportType'] ?? 'Standard').toString();
    final fare =
        (data['estimatedFare'] as num?)?.toDouble() ??
        TransportFareCalculator.estimateFare(
          transportType: transportType,
          distanceKm: distanceKm,
          durationMinutes: durationMinutes,
        );

    return PartnerTrip(
      transportRequestId: doc.id,
      tripId: data['tripId'] as String?,
      userId: data['userId'] as String?,
      id: doc.id.length > 6 ? doc.id.substring(0, 6).toUpperCase() : doc.id,
      riderName: (data['riderName'] ?? 'Riendzo traveler').toString(),
      tripName: (data['tripName'] ?? 'Riendzo trip').toString(),
      pickup: pickup,
      dropoff: dropoff,
      pickupEta: 8,
      tripDuration: durationMinutes,
      distanceKm: distanceKm,
      fare: fare,
      rating: 4.8,
      passengers: (data['passengers'] as num?)?.toInt() ?? 1,
      transportType: transportType,
      note: (data['note'] ?? '').toString(),
    );
  }
}
