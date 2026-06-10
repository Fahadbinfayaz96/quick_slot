import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_slot/core/api/api_service.dart';
import 'package:quick_slot/models/slot_model.dart';
import 'slot_state.dart';

class SlotCubit extends Cubit<SlotState> {
  final ApiService _apiService = ApiService();

  SlotCubit() : super(SlotInitial());

  Future<void> loadSlots({
    required String venueId,
    required String date,
  }) async {
    // Validation
    if (venueId.isEmpty || date.isEmpty) {
      emit(SlotError('Venue ID and date are required'));
      return;
    }

    try {
      emit(SlotLoading());

      final slotsData = await _apiService.getSlots(venueId, date);
      final slots = slotsData.map((e) => SlotModel.fromJson(e)).toList();

      emit(SlotLoaded(slots));
    } catch (e) {
      emit(SlotError(e.toString()));
    }
  }

  void reset() {
    emit(SlotInitial());
  }
}
