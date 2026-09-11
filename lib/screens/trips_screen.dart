part of '../main.dart';

class TripsScreen extends StatelessWidget {
  const TripsScreen({super.key, required this.store, required this.refresh});
  final PartnerStore store;
  final void Function([int?]) refresh;
  @override
  Widget build(BuildContext context) => SafeArea(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const PageHeader('Trip requests', 'Live requests near Johannesburg'),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: StatusPill('AVAILABLE NOW'),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: store.loading
              ? const Center(child: CircularProgressIndicator())
              : store.error != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.cloud_off_outlined,
                          size: 48,
                          color: muted,
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Could not load requests',
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          store.error!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: muted),
                        ),
                      ],
                    ),
                  ),
                )
              : store.pending.isEmpty
              ? const Center(child: EmptyTrips())
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                  itemCount: store.pending.length,
                  separatorBuilder: (_, index) => const SizedBox(height: 12),
                  itemBuilder: (_, index) => TripCard(
                    trip: store.pending[index],
                    onTap: () => showTripSheet(
                      context,
                      store.pending[index],
                      store,
                      refresh,
                    ),
                  ),
                ),
        ),
      ],
    ),
  );
}
