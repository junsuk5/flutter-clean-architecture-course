import 'package:flutter_note_app/domain/model/note.dart';
import 'package:flutter_note_app/domain/util/note_order.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'notes_state.freezed.dart';

@freezed
class NotesState with _$NotesState {
  factory NotesState({
    required List<Note> notes,
    required NoteOrder noteOrder,
    required bool isOrderSectionVisible,
  }) = _NotesState;
}