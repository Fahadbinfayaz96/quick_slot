import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_slot/core/api/api_service.dart';

import 'boking_state.dart';

class BookingCubit extends Cubit<BookingState> {
  final ApiService _apiService = ApiService();

  BookingCubit() : super(BookingInitial());

  Future<void> createBooking({
    required String userId,
    required String venueId,
    required String bookingDate,
    required String slotTime,
  }) async {
    if (userId.isEmpty ||
        venueId.isEmpty ||
        bookingDate.isEmpty ||
        slotTime.isEmpty) {
      emit(BookingError('All fields are required'));
      return;
    }

    try {
      emit(BookingLoading());

      await _apiService.createBooking(
        userId: userId,
        venueId: venueId,
        bookingDate: bookingDate,
        slotTime: slotTime,
      );

      emit(BookingSuccess());
    } catch (e) {
      if (e.toString().contains('already booked')) {
        emit(BookingConflict(e.toString()));
      } else {
        emit(BookingError(e.toString()));
      }
    }
  }

  void reset() {
    emit(BookingInitial());
  }
}
