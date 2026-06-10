import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../cubit/cubit.dart';
import '../cubit/state.dart';

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
              context.push('/my-bookings');
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
                      context.push('/venues/detail/${venue.id}', extra: venue);
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
