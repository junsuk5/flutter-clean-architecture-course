import 'package:flutter_note_app/domain/model/note.dart';
import 'package:flutter_note_app/domain/repository/note_repository.dart';

class AddNoteUseCase {
  final NoteRepository _repository;

  AddNoteUseCase(this._repository);

  Future<void> call(Note note) async {
    await _repository.insertNote(note);
  }
}
