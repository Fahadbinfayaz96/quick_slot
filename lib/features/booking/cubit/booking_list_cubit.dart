import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_slot/core/api/api_service.dart';
import 'package:quick_slot/models/booking_model.dart';
import 'booking_list_state.dart';

class BookingListCubit extends Cubit<BookingListState> {
  final ApiService _apiService = ApiService();

  BookingListCubit() : super(BookingListLoading());

  Future<void> loadBookings(String userId) async {
    if (userId.isEmpty) {
      emit(BookingListError('User ID is required'));
      return;
    }

    try {
      emit(BookingListLoading());

      final bookingsData = await _apiService.getUserBookings(userId);
      final bookings = bookingsData
          .map((e) => BookingModel.fromJson(e))
          .toList();

      emit(BookingListLoaded(bookings));
    } catch (e) {
      emit(BookingListError(e.toString()));
    }
  }

  Future<void> cancelBooking(String bookingId, String userId) async {
    if (bookingId.isEmpty || userId.isEmpty) {
      emit(BookingListError('Invalid booking or user'));
      return;
    }

    try {
      await _apiService.cancelBooking(bookingId, userId);
      await loadBookings(userId);
    } catch (e) {
      emit(BookingListError(e.toString()));
    }
  }
}
