class BookingModel {
  final String id;
  final String bookingDate;
  final String slotTime;

  BookingModel({
    required this.id,
    required this.bookingDate,
    required this.slotTime,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['_id'],
      bookingDate: json['bookingDate'],
      slotTime: json['slotTime'],
    );
  }
}
