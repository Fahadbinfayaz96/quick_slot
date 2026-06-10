class VenueModel {
  final String id;
  final String name;
  final String sportType;
  final String location;

  VenueModel({
    required this.id,
    required this.name,
    required this.sportType,
    required this.location,
  });

  factory VenueModel.fromJson(Map<String, dynamic> json) {
    return VenueModel(
      id: json['_id'],
      name: json['name'],
      sportType: json['sportType'],
      location: json['location'],
    );
  }
}
