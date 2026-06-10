sealed class BookingState {}

class BookingInitial extends BookingState {}

class BookingLoading extends BookingState {}

class BookingSuccess extends BookingState {}

class BookingConflict extends BookingState {
  final String message;

  BookingConflict(this.message);
}

class BookingError extends BookingState {
  final String message;

  BookingError(this.message);
}
