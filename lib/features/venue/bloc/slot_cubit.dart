import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/api/api_client.dart';
import '../../../models/slot_model.dart';

import 'slot_state.dart';

class SlotCubit extends Cubit<SlotState> {
  SlotCubit() : super(SlotInitial());

  Future<void> loadSlots({
    required String venueId,
    required String date,
  }) async {
    try {
      emit(SlotLoading());

      final response = await ApiClient.dio.get(
        '/venues/$venueId/slots',
        queryParameters: {'date': date},
      );

      final slots = (response.data as List)
          .map((e) => SlotModel.fromJson(e))
          .toList();

      emit(SlotLoaded(slots));
    } catch (e) {
      emit(SlotError(e.toString()));
    }
  }
}
