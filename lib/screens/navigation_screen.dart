part of '../main.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({
    super.key,
    required this.trip,
    required this.toDropoff,
  });
  final TripRequest trip;
  final bool toDropoff;
  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  final map = MapController();
  StreamSubscription<Position>? subscription;
  Position? position;
  List<LatLng> route = [];
  bool loading = true;
  String? notice;
  LatLng get destination =>
      widget.toDropoff ? widget.trip.dropoffPoint : widget.trip.pickupPoint;
  String get destinationName =>
      widget.toDropoff ? widget.trip.dropoff : widget.trip.pickup;
  @override
  void initState() {
    super.initState();
    start();
  }

  Future<void> start() async {
    try {
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        notice = 'Location access is off. Showing the planned route.';
        await loadRoute(widget.trip.pickupPoint);
        return;
      }
      final first = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 12),
        ),
      );
      if (!mounted) return;
      setState(() => position = first);
      await loadRoute(LatLng(first.latitude, first.longitude));
      subscription =
          Geolocator.getPositionStream(
            locationSettings: const LocationSettings(
              accuracy: LocationAccuracy.high,
              distanceFilter: 10,
            ),
          ).listen((update) {
            if (!mounted) return;
            setState(() => position = update);
            map.move(LatLng(update.latitude, update.longitude), 16);
          });
    } catch (_) {
      notice = 'Live GPS is unavailable. Showing the planned route.';
      await loadRoute(widget.trip.pickupPoint);
    }
  }

  Future<void> loadRoute(LatLng start) async {
    try {
      final uri = Uri.parse(
        'https://router.project-osrm.org/route/v1/driving/${start.longitude},${start.latitude};${destination.longitude},${destination.latitude}?overview=full&geometries=geojson&steps=true',
      );
      final response = await http.get(uri).timeout(const Duration(seconds: 12));
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final coordinates =
          ((data['routes'] as List).first
                  as Map<String, dynamic>)['geometry']['coordinates']
              as List;
      route = coordinates
          .map(
            (point) => LatLng((point as List)[1] as double, point[0] as double),
          )
          .toList();
    } catch (_) {
      route = [start, destination];
      notice ??= 'Route service unavailable. Showing a direct route.';
    }
    if (mounted) setState(() => loading = false);
  }

  @override
  void dispose() {
    subscription?.cancel();
    map.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final current = position == null
        ? widget.trip.pickupPoint
        : LatLng(position!.latitude, position!.longitude);
    final metres = Geolocator.distanceBetween(
      current.latitude,
      current.longitude,
      destination.latitude,
      destination.longitude,
    );
    final distance = metres >= 1000
        ? '${(metres / 1000).toStringAsFixed(1)} km'
        : '${metres.round()} m';
    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            mapController: map,
            options: MapOptions(initialCenter: current, initialZoom: 14),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.riendzo.riendzo_partner',
              ),
              if (route.isNotEmpty)
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: route,
                      strokeWidth: 8,
                      color: Colors.white,
                    ),
                    Polyline(points: route, strokeWidth: 5, color: navy),
                  ],
                ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: current,
                    width: 50,
                    height: 50,
                    child: const DriverMarker(),
                  ),
                  Marker(
                    point: destination,
                    width: 46,
                    height: 46,
                    child: const CircleAvatar(
                      backgroundColor: navy,
                      child: Icon(Icons.flag, color: mint),
                    ),
                  ),
                ],
              ),
              RichAttributionWidget(
                attributions: [
                  TextSourceAttribution(
                    'OpenStreetMap contributors',
                    onTap: () => launchUrl(
                      Uri.parse('https://www.openstreetmap.org/copyright'),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Material(
                    color: Colors.white,
                    shape: const CircleBorder(),
                    elevation: 3,
                    child: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Material(
                      color: navy,
                      borderRadius: BorderRadius.circular(18),
                      elevation: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            const Icon(Icons.straight, color: mint, size: 32),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.toDropoff
                                        ? 'Continue to drop-off'
                                        : 'Continue to pickup',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w900,
                                      fontSize: 17,
                                    ),
                                  ),
                                  Text(
                                    destinationName,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: Colors.white70,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 20,
            child: SafeArea(
              top: false,
              child: Material(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
                elevation: 8,
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (notice != null) ...[
                        Text(
                          notice!,
                          style: const TextStyle(color: muted, fontSize: 12),
                        ),
                        const SizedBox(height: 10),
                      ],
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  loading ? 'Finding route…' : distance,
                                  style: const TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                Text(
                                  widget.toDropoff
                                      ? 'to drop-off'
                                      : 'to pickup',
                                  style: const TextStyle(color: muted),
                                ),
                              ],
                            ),
                          ),
                          if (loading)
                            const CircularProgressIndicator()
                          else
                            IconButton.filled(
                              onPressed: () => map.move(current, 16),
                              icon: const Icon(Icons.my_location),
                            ),
                        ],
                      ),
                      const Divider(height: 22),
                      Row(
                        children: [
                          const Icon(Icons.volume_up_outlined),
                          const SizedBox(width: 9),
                          const Expanded(
                            child: Text(
                              'Voice guidance on',
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                          ),
                          Text(
                            widget.trip.duration,
                            style: const TextStyle(fontWeight: FontWeight.w900),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DriverMarker extends StatelessWidget {
  const DriverMarker({super.key});
  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      color: Colors.white,
      shape: BoxShape.circle,
      border: Border.all(color: navy, width: 3),
      boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 8)],
    ),
    child: const Icon(Icons.navigation, color: navy, size: 29),
  );
}
