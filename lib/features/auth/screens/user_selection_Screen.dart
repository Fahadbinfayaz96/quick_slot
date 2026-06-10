import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../venue/bloc/cubit.dart';
import '../../venue/screens/venue_list_screen.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';

class UserSelectionScreen extends StatefulWidget {
  const UserSelectionScreen({super.key});

  @override
  State<UserSelectionScreen> createState() => _UserSelectionScreenState();
}

class _UserSelectionScreenState extends State<UserSelectionScreen> {
  @override
  void initState() {
    super.initState();

    context.read<AuthCubit>().loadUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('QuickSlot')),
      body: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          if (state is AuthLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is AuthError) {
            return Center(child: Text(state.message));
          }

          if (state is AuthLoaded) {
            return ListView.builder(
              itemCount: state.users.length,
              itemBuilder: (context, index) {
                final user = state.users[index];

                return ListTile(
                  title: Text(user.name),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    context.read<AuthCubit>().selectUser(user);

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BlocProvider(
                          create: (_) => VenueCubit(),
                          child: const VenueListScreen(),
                        ),
                      ),
                    );
                  },
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
