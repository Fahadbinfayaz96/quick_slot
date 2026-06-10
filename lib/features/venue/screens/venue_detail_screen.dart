import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../models/venue_model.dart';
import '../../auth/cubit/auth_cubit.dart';
import '../../booking/cubit/boking_state.dart';
import '../../booking/cubit/booking_cubit.dart';
import '../bloc/slot_cubit.dart';
import '../bloc/slot_state.dart';

class VenueDetailScreen extends StatefulWidget {
  final VenueModel venue;

  const VenueDetailScreen({super.key, required this.venue});

  @override
  State<VenueDetailScreen> createState() => _VenueDetailScreenState();
}

class _VenueDetailScreenState extends State<VenueDetailScreen> {
  late DateTime selectedDate;

  void _showBookingDialog(String slotTime) {
    final bookingCubit = context.read<BookingCubit>();
    final authCubit = context.read<AuthCubit>();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Confirm Booking'),
          content: Text('Book slot $slotTime ?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext);

                final user = authCubit.currentUser;

                if (user == null) return;

                bookingCubit.createBooking(
                  userId: user.id,
                  venueId: widget.venue.id,
                  bookingDate: DateFormat('yyyy-MM-dd').format(selectedDate),
                  slotTime: slotTime,
                );
              },
              child: const Text('Book'),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();

    selectedDate = DateTime.now();

    _loadSlots();
  }

  void _loadSlots() {
    context.read<SlotCubit>().loadSlots(
      venueId: widget.venue.id,
      date: DateFormat('yyyy-MM-dd').format(selectedDate),
    );
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );

    if (picked == null) return;

    setState(() {
      selectedDate = picked;
    });

    _loadSlots();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<BookingCubit, BookingState>(
      listener: (context, state) {
        if (state is BookingSuccess) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Booking successful')));

          _loadSlots();
        }

        if (state is BookingConflict) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));

          _loadSlots();
        }

        if (state is BookingError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: Scaffold(
        appBar: AppBar(title: Text(widget.venue.name)),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton.icon(
                onPressed: _pickDate,
                icon: const Icon(Icons.calendar_month),
                label: Text(DateFormat('dd MMM yyyy').format(selectedDate)),
              ),
            ),
            Expanded(
              child: BlocBuilder<SlotCubit, SlotState>(
                builder: (context, state) {
                  if (state is SlotLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is SlotError) {
                    return Center(child: Text(state.message));
                  }

                  if (state is SlotLoaded) {
                    if (state.slots.isEmpty) {
                      return const Center(child: Text('No slots found'));
                    }

                    return GridView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: state.slots.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 2,
                          ),
                      itemBuilder: (context, index) {
                        final slot = state.slots[index];

                        return InkWell(
                          onTap: slot.available
                              ? () {
                                  _showBookingDialog(slot.time);
                                }
                              : null,
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: slot.available ? Colors.green : Colors.red,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              slot.time,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }

                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
