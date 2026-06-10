class SlotModel {
  final String time;
  final bool available;

  SlotModel({required this.time, required this.available});

  factory SlotModel.fromJson(Map<String, dynamic> json) {
    return SlotModel(time: json['time'], available: json['available']);
  }
}
