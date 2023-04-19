import 'package:flutter/material.dart';
import 'package:flutter_note_app/presentation/notes/components/order_section.dart';
import 'package:flutter_note_app/presentation/notes/notes_event.dart';
import 'package:flutter_note_app/presentation/notes/notes_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'components/note_item.dart';

class NotesScreen extends ConsumerWidget {
  const NotesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(notesViewModel);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Your note',
          style: TextStyle(fontSize: 30),
        ),
        actions: [
          IconButton(
            onPressed: () {
              ref
                  .read(notesViewModel.notifier)
                  .onEvent(const NotesEvent.toggleOrderSection());
            },
            icon: const Icon(Icons.sort),
          ),
        ],
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          bool? isSaved = await context.push('/add_edit_note');

          if (isSaved != null && isSaved) {
            ref
                .read(notesViewModel.notifier)
                .onEvent(const NotesEvent.loadNotes());
          }
        },
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: state.isOrderSectionVisible
                  ? OrderSection(
                      noteOrder: state.noteOrder,
                      onOrderChanged: (noteOrder) {
                        ref
                            .read(notesViewModel.notifier)
                            .onEvent(NotesEvent.changeOrder(noteOrder));
                      },
                    )
                  : Container(),
            ),
            ...state.notes
                .map(
                  (note) => GestureDetector(
                    onTap: () async {
                      bool? isSaved =
                          await context.push('/add_edit_note/${note.id}');

                      if (isSaved != null && isSaved) {
                        ref
                            .read(notesViewModel.notifier)
                            .onEvent(const NotesEvent.loadNotes());
                      }
                    },
                    child: NoteItem(
                      note: note,
                      onDeleteTap: () {
                        ref
                            .read(notesViewModel.notifier)
                            .onEvent(NotesEvent.deleteNote(note));

                        final snackBar = SnackBar(
                          content: const Text('노트가 삭제되었습니다'),
                          action: SnackBarAction(
                            label: '취소',
                            onPressed: () {
                              ref
                                  .read(notesViewModel.notifier)
                                  .onEvent(const NotesEvent.restoreNote());
                            },
                          ),
                        );

                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      },
                    ),
                  ),
                )
                .toList(),
          ],
        ),
      ),
    );
  }
}
