import 'package:flutter_note_app/data/data_source/note_db_helper.dart';
import 'package:flutter_note_app/data/repository/note_repository_impl.dart';
import 'package:flutter_note_app/domain/model/note.dart';
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
import 'package:injectable/injectable.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:sqflite/sqflite.dart';
import 'provider_setup.config.dart';

final getIt = GetIt.instance;

@InjectableInit()
Future<void> configureDependencies() async => await getIt.init();

// Future<void> setup() async {
//   Database database = await openDatabase(
//     'notes_db',
//     version: 1,
//     onCreate: (db, version) async {
//       await db.execute(
//           'CREATE TABLE note (id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, content TEXT, color INTEGER, timestamp INTEGER)');
//     },
//   );
//
//   getIt.registerSingleton<Database>(database);
//
//   getIt.registerSingleton<NoteDbHelper>(NoteDbHelper(getIt<Database>()));
//   getIt.registerSingleton<NoteRepository>(
//       NoteRepositoryImpl(getIt<NoteDbHelper>()));
//   getIt.registerSingleton<UseCases>(
//     UseCases(
//       addNote: AddNoteUseCase(getIt<NoteRepository>()),
//       deleteNote: DeleteNoteUseCase(getIt<NoteRepository>()),
//       getNote: GetNoteUseCase(getIt<NoteRepository>()),
//       getNotes: GetNotesUseCase(getIt<NoteRepository>()),
//       updateNote: UpdateNoteUseCase(getIt<NoteRepository>()),
//     ),
//   );
// }
