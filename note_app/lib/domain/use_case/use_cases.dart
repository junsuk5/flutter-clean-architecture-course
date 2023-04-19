import 'package:flutter_note_app/domain/use_case/add_note_use_case.dart';
import 'package:flutter_note_app/domain/use_case/delete_note_use_case.dart';
import 'package:flutter_note_app/domain/use_case/get_note_use_case.dart';
import 'package:flutter_note_app/domain/use_case/get_notes_use_case.dart';
import 'package:flutter_note_app/domain/use_case/update_note_use_case.dart';
import 'package:injectable/injectable.dart';

@singleton
class UseCases {
  final AddNoteUseCase addNote;
  final DeleteNoteUseCase deleteNote;
  final GetNoteUseCase getNote;
  final GetNotesUseCase getNotes;
  final UpdateNoteUseCase updateNote;

  UseCases({
    required this.addNote,
    required this.deleteNote,
    required this.getNote,
    required this.getNotes,
    required this.updateNote,
  });
}
