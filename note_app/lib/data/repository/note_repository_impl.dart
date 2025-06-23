import 'package:flutter_note_app/data/data_source/note_db_helper.dart';
import 'package:flutter_note_app/domain/model/note.dart';
import 'package:flutter_note_app/domain/repository/note_repository.dart';

class NoteRepositoryImpl implements NoteRepository {
  final NoteDbHelper _db;

  NoteRepositoryImpl(this._db);

  @override
  Future<void> deleteNote(Note note) async {
    await _db.deleteNote(note);
  }

  @override
  Future<Note?> getNoteById(int id) async {
    return await _db.getNoteById(id);
  }

  @override
  Future<List<Note>> getNotes() async {
    return await _db.getNotes();
  }

  @override
  Future<void> insertNote(Note note) async {
    await _db.insertNote(note);
  }

  @override
  Future<void> updateNote(Note note) async {
    await _db.updateNote(note);
  }
}
