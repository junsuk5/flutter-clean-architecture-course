import 'package:flutter/material.dart';
import 'package:flutter_note_app/di/provider_setup.dart';
import 'package:flutter_note_app/domain/repository/note_repository.dart';
import 'package:flutter_note_app/domain/use_case/use_cases.dart';
import 'package:flutter_note_app/presentation/add_edit_note/add_edit_note_screen.dart';
import 'package:flutter_note_app/presentation/notes/notes_screen.dart';
import 'package:flutter_note_app/presentation/notes/notes_view_model.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'presentation/add_edit_note/add_edit_note_view_model.dart';

final GoRouter router = GoRouter(
  initialLocation: '/notes',
  routes: <RouteBase>[
    GoRoute(
      path: '/notes',
      builder: (BuildContext context, GoRouterState state) {
        return ChangeNotifierProvider.value(
          value: NotesViewModel(getIt<UseCases>()),
          child: const NotesScreen(),
        );
      },
    ),
    GoRoute(
      path: '/add_edit_note',
      builder: (BuildContext context, GoRouterState state) {
        return ChangeNotifierProvider(
          create: (_) => AddEditNoteViewModel(getIt<NoteRepository>()),
          child: const AddEditNoteScreen(),
        );
      },
    ),
    GoRoute(
      path: '/add_edit_note/:noteId',
      builder: (BuildContext context, GoRouterState state) {
        return ChangeNotifierProvider(
          create: (_) => AddEditNoteViewModel(getIt<NoteRepository>()),
          child: AddEditNoteScreen(
            noteId: int.tryParse(state.params['noteId'] ?? ''),
          ),
        );
      },
    ),
  ],
);
