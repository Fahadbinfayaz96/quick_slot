import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_slot/core/api/api_service.dart';
import 'package:quick_slot/models/user_model.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final ApiService _apiService = ApiService();

  UserModel? currentUser;

  AuthCubit() : super(AuthInitial());

  Future<void> loadUsers() async {
    try {
      emit(AuthLoading());
      final usersData = await _apiService.getUsers();
      final users = usersData.map((e) => UserModel.fromJson(e)).toList();
      emit(AuthLoaded(users));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  void selectUser(UserModel user) {
    currentUser = user;
    emit(AuthSelected(user));
  }

  void logout() {
    currentUser = null;
    emit(AuthInitial());
  }
}
