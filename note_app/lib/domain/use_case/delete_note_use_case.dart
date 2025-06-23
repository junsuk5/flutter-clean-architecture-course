import 'package:flutter_note_app/domain/model/note.dart';
import 'package:flutter_note_app/domain/repository/note_repository.dart';

class DeleteNoteUseCase {
  final NoteRepository _repository;

  DeleteNoteUseCase(this._repository);

  Future<void> call(Note note) async {
    await _repository.deleteNote(note);
  }
}
