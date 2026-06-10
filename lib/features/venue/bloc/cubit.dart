import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_slot/features/venue/bloc/state.dart';

import '../../../core/api/api_client.dart';
import '../../../models/venue_model.dart';

class VenueCubit extends Cubit<VenueState> {
  VenueCubit() : super(VenueInitial());

  Future<void> loadVenues() async {
    try {
      emit(VenueLoading());

      final response = await ApiClient.dio.get('/venues');

      final venues = (response.data as List)
          .map((e) => VenueModel.fromJson(e))
          .toList();

      emit(VenueLoaded(venues));
    } catch (e) {
      emit(VenueError(e.toString()));
    }
  }
}
