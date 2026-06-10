import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_slot/core/api/api_service.dart';
import 'package:quick_slot/models/venue_model.dart';
import 'venue_state.dart';

class VenueCubit extends Cubit<VenueState> {
  final ApiService _apiService = ApiService();

  VenueCubit() : super(VenueInitial());

  Future<void> loadVenues() async {
    try {
      emit(VenueLoading());

      final venuesData = await _apiService.getVenues();
      final venues = venuesData.map((e) => VenueModel.fromJson(e)).toList();

      emit(VenueLoaded(venues));
    } catch (e) {
      emit(VenueError(e.toString()));
    }
  }

  void refresh() {
    loadVenues();
  }
}
