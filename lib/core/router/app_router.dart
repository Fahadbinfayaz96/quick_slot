import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/screens/user_selection_screen.dart';
import '../../features/venue/cubit/slot_cubit.dart';
import '../../features/venue/screens/venue_list_screen.dart';
import '../../features/venue/screens/venue_detail_screen.dart';
import '../../features/booking/cubit/booking_cubit.dart';
import '../../features/booking/cubit/booking_list_cubit.dart';
import '../../features/booking/screens/my_booking_screen.dart';

import '../../models/venue_model.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'user_selection',
        builder: (context, state) => const UserSelectionScreen(),
      ),
      GoRoute(
        path: '/venues',
        name: 'venues',
        builder: (context, state) => const VenueListScreen(),
      ),
      GoRoute(
        path: '/venues/detail/:venueId',
        name: 'venue_detail',
        builder: (context, state) {
          final venue = state.extra as VenueModel;
          return MultiBlocProvider(
            providers: [
              BlocProvider.value(value: context.read<SlotCubit>()),
              BlocProvider.value(value: context.read<BookingCubit>()),
            ],
            child: VenueDetailScreen(venue: venue),
          );
        },
      ),
      GoRoute(
        path: '/my-bookings',
        name: 'my_bookings',
        builder: (context, state) => MultiBlocProvider(
          providers: [BlocProvider(create: (_) => BookingListCubit())],
          child: const MyBookingsScreen(),
        ),
      ),
    ],
  );
}
