import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/model/note.dart';

part 'add_edit_note_state.freezed.dart';

@freezed
class AddEditNoteState<T> with _$AddEditNoteState<T> {
  const factory AddEditNoteState({
    Note? note,
    required int color,
  }) = _AddEditNoteState;
}
