import '../../../models/user_model.dart';

sealed class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthLoaded extends AuthState {
  final List<UserModel> users;

  AuthLoaded(this.users);
}

class AuthSelected extends AuthState {
  final UserModel user;

  AuthSelected(this.user);
}

class AuthError extends AuthState {
  final String message;

  AuthError(this.message);
}
