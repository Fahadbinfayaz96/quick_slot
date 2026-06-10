import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_slot/core/api/api_client.dart';
import 'package:quick_slot/core/router/app_router.dart';
import 'package:quick_slot/core/theme/app_theme.dart';

import 'features/auth/cubit/auth_cubit.dart';
import 'features/booking/cubit/booking_cubit.dart';
import 'features/venue/cubit/slot_cubit.dart';
import 'features/venue/cubit/venue_cubit.dart';

void main() {
  ApiClient().init();
  runApp(const QuickSlotApp());
}

class QuickSlotApp extends StatelessWidget {
  const QuickSlotApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthCubit()),
        BlocProvider(create: (_) => VenueCubit()),
        BlocProvider(create: (_) => SlotCubit()),
        BlocProvider(create: (_) => BookingCubit()),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'QuickSlot',
        theme: AppTheme.lightTheme,
        routerConfig: AppRouter.router,
      ),
    );
  }
}
