class ApiEndpoints {
  // Base URLs - easily switch environments
  static const String dev = 'https://quickslot-5.onrender.com/';
  static const String prod = 'https://api.yourdomain.com';
  static const String staging = 'https://staging-api.yourdomain.com';

  static String get baseUrl => dev;

  // Endpoints
  static const String users = '/users';
  static const String venues = '/venues';
  static const String bookings = '/bookings';

  static String userBookings(String userId) => '/users/$userId/bookings';
  static String singleBooking(String bookingId) => '/bookings/$bookingId';
}
