import 'package:freezed_annotation/freezed_annotation.dart';

part 'add_edit_note_ui_event.freezed.dart';

@freezed
abstract class AddEditNoteUiEvent with _$AddEditNoteUiEvent {
  const factory AddEditNoteUiEvent.saveNote() = SaveNote;
  const factory AddEditNoteUiEvent.showSnackBar(String message) = ShowSnackBar;
}

