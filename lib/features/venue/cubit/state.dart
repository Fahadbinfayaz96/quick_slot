import '../../../models/venue_model.dart';

sealed class VenueState {}

class VenueInitial extends VenueState {}

class VenueLoading extends VenueState {}

class VenueLoaded extends VenueState {
  final List<VenueModel> venues;

  VenueLoaded(this.venues);
}

class VenueError extends VenueState {
  final String message;

  VenueError(this.message);
}
