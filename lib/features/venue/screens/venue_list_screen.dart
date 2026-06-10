import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../booking/cubit/booking_cubit.dart';
import '../../booking/cubit/booking_list_cubit.dart';
import '../../booking/screens/my_booking_screen.dart';
import '../bloc/cubit.dart';
import '../bloc/slot_cubit.dart';
import '../bloc/state.dart';
import 'venue_detail_screen.dart';

class VenueListScreen extends StatefulWidget {
  const VenueListScreen({super.key});

  @override
  State<VenueListScreen> createState() => _VenueListScreenState();
}

class _VenueListScreenState extends State<VenueListScreen> {
  @override
  void initState() {
    super.initState();

    context.read<VenueCubit>().loadVenues();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Venues'),
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BlocProvider(
                    create: (_) => BookingListCubit(),
                    child: const MyBookingsScreen(),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<VenueCubit, VenueState>(
        builder: (context, state) {
          if (state is VenueLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is VenueError) {
            return Center(child: Text(state.message));
          }

          if (state is VenueLoaded) {
            if (state.venues.isEmpty) {
              return const Center(child: Text('No venues found'));
            }

            return ListView.builder(
              itemCount: state.venues.length,
              itemBuilder: (context, index) {
                final venue = state.venues[index];

                return Card(
                  margin: const EdgeInsets.all(12),
                  child: ListTile(
                    title: Text(venue.name),
                    subtitle: Text('${venue.sportType} • ${venue.location}'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => MultiBlocProvider(
                            providers: [
                              BlocProvider(create: (_) => SlotCubit()),
                              BlocProvider(create: (_) => BookingCubit()),
                            ],
                            child: VenueDetailScreen(venue: venue),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}
