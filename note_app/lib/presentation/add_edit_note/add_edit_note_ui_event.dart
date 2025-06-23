import 'package:freezed_annotation/freezed_annotation.dart';

part 'add_edit_note_ui_event.freezed.dart';

@freezed
sealed class AddEditNoteUiEvent with _$AddEditNoteUiEvent {
  const factory AddEditNoteUiEvent.savedNote() = SavedNote;
  const factory AddEditNoteUiEvent.showSnackBar(String message) = ShowSnackBar;
}
