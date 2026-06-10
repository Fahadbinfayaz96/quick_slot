import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/api/api_client.dart';
import 'boking_state.dart';

class BookingCubit extends Cubit<BookingState> {
  BookingCubit() : super(BookingInitial());

  Future<void> createBooking({
    required String userId,
    required String venueId,
    required String bookingDate,
    required String slotTime,
  }) async {
    try {
      emit(BookingLoading());

      await ApiClient.dio.post(
        '/bookings',
        data: {
          'venueId': venueId,
          'bookingDate': bookingDate,
          'slotTime': slotTime,
        },
        options: Options(headers: {'X-User-Id': userId}),
      );

      emit(BookingSuccess());
    } on DioException catch (e) {
      if (e.response?.statusCode == 409) {
        emit(BookingConflict('Slot already booked'));

        return;
      }

      emit(BookingError('Booking failed'));
    }
  }
}
