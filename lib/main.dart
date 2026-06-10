import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'features/auth/cubit/auth_cubit.dart';
import 'features/auth/screens/user_selection_screen.dart';

void main() {
  runApp(const QuickSlotApp());
}

class QuickSlotApp extends StatelessWidget {
  const QuickSlotApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider(create: (_) => AuthCubit())],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const UserSelectionScreen(),
      ),
    );
  }
}
