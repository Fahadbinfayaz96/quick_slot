import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_theme.dart';
import '../../../models/venue_model.dart';
import '../../../widgets/empty_state_widget.dart';
import '../../../widgets/error_widget.dart';
import '../../../widgets/loading_widget.dart';
import '../../auth/cubit/auth_cubit.dart';
import '../../booking/cubit/boking_state.dart';
import '../../booking/cubit/booking_cubit.dart';
import '../cubit/slot_cubit.dart';
import '../cubit/slot_state.dart';

class VenueDetailScreen extends StatefulWidget {
  final VenueModel venue;

  const VenueDetailScreen({super.key, required this.venue});

  @override
  State<VenueDetailScreen> createState() => _VenueDetailScreenState();
}

class _VenueDetailScreenState extends State<VenueDetailScreen> {
  late DateTime selectedDate;
  bool isBooking = false;

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.now();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadSlots();
    });
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
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppTheme.primaryColor,
              onPrimary: Colors.white,
              onSurface: Colors.black87,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked == null) return;

    setState(() {
      selectedDate = picked;
    });

    _loadSlots();
  }

  void _showBookingDialog(String slotTime) {
    final bookingCubit = context.read<BookingCubit>();
    final authCubit = context.read<AuthCubit>();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text('Confirm Booking'),
          content: Text('Book slot $slotTime?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext);

                final user = authCubit.currentUser;
                if (user == null) return;

                setState(() => isBooking = true);

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
  Widget build(BuildContext context) {
    return BlocListener<BookingCubit, BookingState>(
      listener: (context, state) {
        setState(() => isBooking = false);

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
        body: Stack(
          children: [
            CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 280,
                  pinned: true,
                  leading: Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () {
                        if (context.canPop()) {
                          context.pop();
                        }
                      },
                    ),
                  ),
                  flexibleSpace: FlexibleSpaceBar(
                    background: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            AppTheme.primaryColor,
                            AppTheme.secondaryColor,
                          ],
                        ),
                      ),
                      child: Center(
                        child: Text(
                          widget.venue.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      widget.venue.location,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),

                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: ElevatedButton(
                      onPressed: _pickDate,
                      child: Text(
                        DateFormat('dd MMM yyyy').format(selectedDate),
                      ),
                    ),
                  ),
                ),

                BlocBuilder<SlotCubit, SlotState>(
                  builder: (context, state) {
                    if (state is SlotLoading) {
                      return const SliverFillRemaining(child: LoadingWidget());
                    }

                    if (state is SlotError) {
                      return SliverFillRemaining(
                        child: ErrorDisplayWidget(
                          message: state.message,
                          onRetry: _loadSlots,
                        ),
                      );
                    }

                    if (state is SlotLoaded) {
                      if (state.slots.isEmpty) {
                        return const SliverFillRemaining(
                          child: EmptyStateWidget(
                            title: 'No Slots Available',
                            message: 'Try another date',
                            icon: Icons.access_time,
                          ),
                        );
                      }

                      return SliverPadding(
                        padding: const EdgeInsets.all(16),
                        sliver: SliverGrid(
                          delegate: SliverChildBuilderDelegate((
                            context,
                            index,
                          ) {
                            final slot = state.slots[index];

                            return InkWell(
                              onTap: slot.available && !isBooking
                                  ? () => _showBookingDialog(slot.time)
                                  : null,
                              child: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: slot.available
                                      ? Colors.green
                                      : Colors.red,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  slot.time,
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            );
                          }, childCount: state.slots.length),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                              ),
                        ),
                      );
                    }

                    return const SliverToBoxAdapter(child: SizedBox());
                  },
                ),
              ],
            ),

            if (isBooking)
              Container(
                color: Colors.black.withOpacity(0.5),
                child: const Center(child: CircularProgressIndicator()),
              ),
          ],
        ),
      ),
    );
  }
}
