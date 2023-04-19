import 'package:flutter_note_app/di/provider_setup.dart';
import 'package:flutter_note_app/domain/use_case/use_cases.dart';
import 'package:flutter_note_app/presentation/notes/notes_state.dart';
import 'package:flutter_note_app/presentation/notes/notes_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:injectable/injectable.dart';
import 'package:sqflite/sqflite.dart';

@module
abstract class AppModule {
  @preResolve
  @singleton
  Future<Database> get db async => await openDatabase(
        'notes_db',
        version: 1,
        onCreate: (db, version) async {
          await db.execute(
              'CREATE TABLE note (id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, content TEXT, color INTEGER, timestamp INTEGER)');
        },
      );

}
