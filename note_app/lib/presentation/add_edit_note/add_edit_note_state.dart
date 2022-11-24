import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/model/note.dart';

part 'add_edit_note_state.freezed.dart';

@freezed
class AddEditNoteState<T> with _$AddEditNoteState<T> {
  const factory AddEditNoteState({
    required String title,
    required String content,
    required int color,
    required int timestamp,
    int? id,
  }) = _AddEditNoteState;
}
