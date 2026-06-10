import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../auth/cubit/auth_cubit.dart';
import '../cubit/booking_list_cubit.dart';
import '../cubit/booking_list_state.dart';

class MyBookingsScreen extends StatefulWidget {
  const MyBookingsScreen({super.key});

  @override
  State<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends State<MyBookingsScreen> {
  @override
  void initState() {
    super.initState();
    final user = context.read<AuthCubit>().currentUser;
    if (user != null) {
      context.read<BookingListCubit>().loadBookings(user.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Bookings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: BlocBuilder<BookingListCubit, BookingListState>(
        builder: (context, state) {
          if (state is BookingListLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is BookingListError) {
            return Center(child: Text(state.message));
          }

          if (state is BookingListLoaded) {
            if (state.bookings.isEmpty) {
              return const Center(child: Text('No bookings found'));
            }

            return ListView.builder(
              itemCount: state.bookings.length,
              itemBuilder: (context, index) {
                final booking = state.bookings[index];

                return Card(
                  margin: const EdgeInsets.all(12),
                  child: ListTile(
                    title: Text(booking.venueName),
                    subtitle: Text(
                      '${booking.bookingDate} • ${booking.slotTime}',
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () async {
                        final user = context.read<AuthCubit>().currentUser;
                        if (user == null) return;

                        await context.read<BookingListCubit>().cancelBooking(
                          booking.id,
                          user.id,
                        );
                      },
                    ),
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
