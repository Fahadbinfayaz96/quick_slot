import '../../../models/booking_model.dart';

sealed class BookingListState {}

class BookingListLoading extends BookingListState {}

class BookingListLoaded extends BookingListState {
  final List<BookingModel> bookings;

  BookingListLoaded(this.bookings);
}

class BookingListError extends BookingListState {
  final String message;

  BookingListError(this.message);
}
