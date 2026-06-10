import 'package:dio/dio.dart';
import 'package:quick_slot/core/api/endpoints.dart';
import 'api_client.dart';

class ApiService {
  final Dio _dio = ApiClient.instance;

  T _handleError<T>(DioException e, String customMessage) {
    if (e.response?.statusCode == 409) {
      throw 'Conflict: Resource already exists';
    }
    throw '$customMessage: ${e.message}';
  }

  // Users
  Future<List<dynamic>> getUsers() async {
    try {
      final response = await _dio.get(ApiEndpoints.users);
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e, 'Failed to load users');
    }
  }

  // Venues
  Future<List<dynamic>> getVenues() async {
    try {
      final response = await _dio.get(ApiEndpoints.venues);
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e, 'Failed to load venues');
    }
  }

  // Bookings
  Future<void> createBooking({
    required String userId,
    required String venueId,
    required String bookingDate,
    required String slotTime,
  }) async {
    try {
      await _dio.post(
        ApiEndpoints.bookings,
        data: {
          'venueId': venueId,
          'bookingDate': bookingDate,
          'slotTime': slotTime,
        },
        options: Options(headers: {'X-User-Id': userId}),
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 409) {
        throw 'Slot already booked';
      }
      throw 'Booking failed: ${e.message}';
    }
  }

  Future<List<dynamic>> getUserBookings(String userId) async {
    try {
      final response = await _dio.get(ApiEndpoints.userBookings(userId));
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e, 'Failed to load bookings');
    }
  }

  Future<void> cancelBooking(String bookingId, String userId) async {
    try {
      await _dio.delete(
        ApiEndpoints.singleBooking(bookingId),
        options: Options(headers: {'X-User-Id': userId}),
      );
    } on DioException catch (e) {
      throw _handleError(e, 'Failed to cancel booking');
    }
  }

  Future<List<dynamic>> getSlots(String venueId, String date) async {
    try {
      final response = await _dio.get(
        '/venues/$venueId/slots',
        queryParameters: {'date': date},
      );
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e, 'Failed to load slots');
    }
  }
}
