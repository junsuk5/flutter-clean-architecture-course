import 'package:flutter_note_app/data/data_source/note_db_helper.dart';
import 'package:flutter_note_app/data/repository/note_repository_impl.dart';
import 'package:flutter_note_app/domain/repository/note_repository.dart';
import 'package:flutter_note_app/domain/use_case/add_note_use_case.dart';
import 'package:flutter_note_app/domain/use_case/delete_note_use_case.dart';
import 'package:flutter_note_app/domain/use_case/get_note_use_case.dart';
import 'package:flutter_note_app/domain/use_case/get_notes_use_case.dart';
import 'package:flutter_note_app/domain/use_case/update_note_use_case.dart';
import 'package:flutter_note_app/domain/use_case/use_cases.dart';
import 'package:flutter_note_app/presentation/add_edit_note/add_edit_note_view_model.dart';
import 'package:flutter_note_app/presentation/notes/notes_view_model.dart';
import 'package:get_it/get_it.dart';
import 'package:sqflite/sqflite.dart';

final getIt = GetIt.instance;

Future setupDi() async {
  Database database = await openDatabase(
    'notes_db',
    version: 1,
    onCreate: (db, version) async {
      await db.execute(
          'CREATE TABLE note (id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, content TEXT, color INTEGER, timestamp INTEGER)');
    },
  );

  getIt.registerSingleton<Database>(database);
  getIt.registerSingleton<NoteDbHelper>(NoteDbHelper(getIt.get<Database>()));
  getIt.registerSingleton<NoteRepository>(
      NoteRepositoryImpl(getIt.get<NoteDbHelper>()));
  getIt.registerSingleton<AddNoteUseCase>(
      AddNoteUseCase(getIt.get<NoteRepository>()));
  getIt.registerSingleton<DeleteNoteUseCase>(
      DeleteNoteUseCase(getIt.get<NoteRepository>()));
  getIt.registerSingleton<GetNoteUseCase>(
      GetNoteUseCase(getIt.get<NoteRepository>()));
  getIt.registerSingleton<GetNotesUseCase>(
      GetNotesUseCase(getIt.get<NoteRepository>()));
  getIt.registerSingleton<UpdateNoteUseCase>(
      UpdateNoteUseCase(getIt.get<NoteRepository>()));

  getIt.registerFactory(
    () => NotesViewModel(
      UseCases(
        addNote: getIt.get<AddNoteUseCase>(),
        deleteNote: getIt.get<DeleteNoteUseCase>(),
        getNote: getIt.get<GetNoteUseCase>(),
        getNotes: getIt.get<GetNotesUseCase>(),
        updateNote: getIt.get<UpdateNoteUseCase>(),
      ),
    ),
  );

  getIt
      .registerFactory(() => AddEditNoteViewModel(getIt.get<NoteRepository>()));
}
