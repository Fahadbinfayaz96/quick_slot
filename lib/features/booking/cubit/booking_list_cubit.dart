import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/api/api_client.dart';
import '../../../models/booking_model.dart';

import 'booking_list_state.dart';

class BookingListCubit extends Cubit<BookingListState> {
  BookingListCubit() : super(BookingListLoading());

  Future<void> loadBookings(String userId) async {
    try {
      emit(BookingListLoading());

      final response = await ApiClient.dio.get('/users/$userId/bookings');

      final bookings = (response.data as List)
          .map((e) => BookingModel.fromJson(e))
          .toList();

      emit(BookingListLoaded(bookings));
    } catch (e) {
      emit(BookingListError(e.toString()));
    }
  }

  Future<void> cancelBooking(String bookingId, String userId) async {
    await ApiClient.dio.delete(
      '/bookings/$bookingId',
      options: Options(headers: {'X-User-Id': userId}),
    );

    await loadBookings(userId);
  }
}
