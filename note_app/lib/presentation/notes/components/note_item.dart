import 'package:flutter/material.dart';
import 'package:flutter_note_app/domain/model/note.dart';
import 'package:flutter_note_app/ui/colors.dart';

class NoteItem extends StatelessWidget {
  final Note note;
  final Function? onDeleteTap;

  const NoteItem({
    Key? key,
    required this.note,
    this.onDeleteTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Color(note.color),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  note.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleLarge!.apply(
                    color: darkGray,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  note.content,
                  maxLines: 10,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium!.apply(
                    color: darkGray,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 8,
            right: 8,
            child: GestureDetector(
              onTap: () {
                onDeleteTap?.call();
              },
              child: const Icon(Icons.delete),
            ),
          ),
        ],
      ),
    );
  }
}
