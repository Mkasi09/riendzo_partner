enum TripStatus { requested, accepted, pickupArrived, inProgress, completed }

class PartnerTrip {
  const PartnerTrip({
    required this.id,
    required this.riderName,
    required this.tripName,
    required this.pickup,
    required this.dropoff,
    required this.pickupEta,
    required this.tripDuration,
    required this.distanceKm,
    required this.fare,
    required this.rating,
    required this.passengers,
    required this.transportType,
    required this.note,
    this.transportRequestId,
    this.tripId,
    this.userId,
    this.status = TripStatus.requested,
  });

  final String? transportRequestId;
  final String? tripId;
  final String? userId;
  final String id;
  final String riderName;
  final String tripName;
  final String pickup;
  final String dropoff;
  final int pickupEta;
  final int tripDuration;
  final double distanceKm;
  final double fare;
  final double rating;
  final int passengers;
  final String transportType;
  final String note;
  final TripStatus status;

  PartnerTrip copyWith({TripStatus? status}) {
    return PartnerTrip(
      id: id,
      riderName: riderName,
      tripName: tripName,
      pickup: pickup,
      dropoff: dropoff,
      pickupEta: pickupEta,
      tripDuration: tripDuration,
      distanceKm: distanceKm,
      fare: fare,
      rating: rating,
      passengers: passengers,
      transportType: transportType,
      note: note,
      transportRequestId: transportRequestId,
      tripId: tripId,
      userId: userId,
      status: status ?? this.status,
    );
  }
}
