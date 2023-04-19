// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: unnecessary_lambdas
// ignore_for_file: lines_longer_than_80_chars
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:flutter_note_app/data/data_source/note_db_helper.dart' as _i4;
import 'package:flutter_note_app/data/repository/note_repository_impl.dart'
    as _i6;
import 'package:flutter_note_app/di/app_module.dart' as _i15;
import 'package:flutter_note_app/domain/repository/note_repository.dart' as _i5;
import 'package:flutter_note_app/domain/use_case/add_note_use_case.dart' as _i9;
import 'package:flutter_note_app/domain/use_case/delete_note_use_case.dart'
    as _i10;
import 'package:flutter_note_app/domain/use_case/get_note_use_case.dart'
    as _i11;
import 'package:flutter_note_app/domain/use_case/get_notes_use_case.dart'
    as _i12;
import 'package:flutter_note_app/domain/use_case/update_note_use_case.dart'
    as _i7;
import 'package:flutter_note_app/domain/use_case/use_cases.dart' as _i13;
import 'package:flutter_note_app/presentation/add_edit_note/add_edit_note_view_model.dart'
    as _i8;
import 'package:flutter_note_app/presentation/notes/notes_view_model.dart'
    as _i14;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:sqflite/sqflite.dart' as _i3;

extension GetItInjectableX on _i1.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i1.GetIt> init({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final appModule = _$AppModule();
    await gh.singletonAsync<_i3.Database>(
      () => appModule.db,
      preResolve: true,
    );
    gh.lazySingleton<_i4.NoteDbHelper>(
        () => _i4.NoteDbHelper(gh<_i3.Database>()));
    gh.lazySingleton<_i5.NoteRepository>(
        () => _i6.NoteRepositoryImpl(gh<_i4.NoteDbHelper>()));
    gh.singleton<_i7.UpdateNoteUseCase>(
        _i7.UpdateNoteUseCase(gh<_i5.NoteRepository>()));
    gh.factory<_i8.AddEditNoteViewModel>(
        () => _i8.AddEditNoteViewModel(gh<_i5.NoteRepository>()));
    gh.singleton<_i9.AddNoteUseCase>(
        _i9.AddNoteUseCase(gh<_i5.NoteRepository>()));
    gh.singleton<_i10.DeleteNoteUseCase>(
        _i10.DeleteNoteUseCase(gh<_i5.NoteRepository>()));
    gh.singleton<_i11.GetNoteUseCase>(
        _i11.GetNoteUseCase(gh<_i5.NoteRepository>()));
    gh.singleton<_i12.GetNotesUseCase>(
        _i12.GetNotesUseCase(gh<_i5.NoteRepository>()));
    gh.singleton<_i13.UseCases>(_i13.UseCases(
      addNote: gh<_i9.AddNoteUseCase>(),
      deleteNote: gh<_i10.DeleteNoteUseCase>(),
      getNote: gh<_i11.GetNoteUseCase>(),
      getNotes: gh<_i12.GetNotesUseCase>(),
      updateNote: gh<_i7.UpdateNoteUseCase>(),
    ));
    gh.factory<_i14.NotesViewModel>(
        () => _i14.NotesViewModel(gh<_i13.UseCases>()));
    return this;
  }
}

class _$AppModule extends _i15.AppModule {}
