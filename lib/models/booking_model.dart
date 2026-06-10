class BookingModel {
  final String id;
  final String bookingDate;
  final String slotTime;
  final String venueName;

  const BookingModel({
    required this.id,
    required this.bookingDate,
    required this.slotTime,
    required this.venueName,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['_id'],
      bookingDate: json['bookingDate'],
      slotTime: json['slotTime'],
      venueName: json['venueId']['name'],
    );
  }
}
