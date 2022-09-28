// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:sqflite/sqflite.dart' as _i4;

import '../data/data_source/note_db_helper.dart' as _i3;
import '../data/repository/note_repository_impl.dart' as _i6;
import '../domain/repository/note_repository.dart' as _i5;
import '../domain/use_case/add_note_use_case.dart' as _i9;
import '../domain/use_case/delete_note_use_case.dart' as _i10;
import '../domain/use_case/get_note_use_case.dart' as _i11;
import '../domain/use_case/get_notes_use_case.dart' as _i12;
import '../domain/use_case/update_note_use_case.dart' as _i7;
import '../domain/use_case/use_cases.dart' as _i13;
import '../presentation/add_edit_note/add_edit_note_view_model.dart' as _i8;
import '../presentation/notes/notes_view_model.dart'
    as _i14; // ignore_for_file: unnecessary_lambdas

// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
_i1.GetIt $initGetIt(
  _i1.GetIt get, {
  String? environment,
  _i2.EnvironmentFilter? environmentFilter,
}) {
  final gh = _i2.GetItHelper(
    get,
    environment,
    environmentFilter,
  );
  gh.singleton<_i3.NoteDbHelper>(_i3.NoteDbHelper(get<_i4.Database>()));
  gh.singleton<_i5.NoteRepository>(
      _i6.NoteRepositoryImpl(get<_i3.NoteDbHelper>()));
  gh.singleton<_i7.UpdateNoteUseCase>(
      _i7.UpdateNoteUseCase(get<_i5.NoteRepository>()));
  gh.factory<_i8.AddEditNoteViewModel>(
      () => _i8.AddEditNoteViewModel(get<_i5.NoteRepository>()));
  gh.singleton<_i9.AddNoteUseCase>(
      _i9.AddNoteUseCase(get<_i5.NoteRepository>()));
  gh.singleton<_i10.DeleteNoteUseCase>(
      _i10.DeleteNoteUseCase(get<_i5.NoteRepository>()));
  gh.singleton<_i11.GetNoteUseCase>(
      _i11.GetNoteUseCase(get<_i5.NoteRepository>()));
  gh.singleton<_i12.GetNotesUseCase>(
      _i12.GetNotesUseCase(get<_i5.NoteRepository>()));
  gh.singleton<_i13.UseCases>(_i13.UseCases(
    addNote: get<_i9.AddNoteUseCase>(),
    deleteNote: get<_i10.DeleteNoteUseCase>(),
    getNote: get<_i11.GetNoteUseCase>(),
    getNotes: get<_i12.GetNotesUseCase>(),
    updateNote: get<_i7.UpdateNoteUseCase>(),
  ));
  gh.factory<_i14.NotesViewModel>(
      () => _i14.NotesViewModel(get<_i13.UseCases>()));
  return get;
}
