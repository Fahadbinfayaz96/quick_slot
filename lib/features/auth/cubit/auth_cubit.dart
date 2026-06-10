import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/api/api_client.dart';
import '../../../models/user_model.dart';

import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  UserModel? currentUser;

  Future<void> loadUsers() async {
    try {
      emit(AuthLoading());

      final response = await ApiClient.dio.get('/users');

      final users = (response.data as List)
          .map((e) => UserModel.fromJson(e))
          .toList();

      emit(AuthLoaded(users));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  void selectUser(UserModel user) {
    currentUser = user;

    emit(AuthSelected(user));
  }
}
