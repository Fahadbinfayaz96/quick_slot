import '../../../models/slot_model.dart';

sealed class SlotState {}

class SlotInitial extends SlotState {}

class SlotLoading extends SlotState {}

class SlotLoaded extends SlotState {
  final List<SlotModel> slots;

  SlotLoaded(this.slots);
}

class SlotError extends SlotState {
  final String message;

  SlotError(this.message);
}
