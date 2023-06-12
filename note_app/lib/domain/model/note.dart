import 'package:freezed_annotation/freezed_annotation.dart';

part 'note.freezed.dart';

part 'note.g.dart';

@freezed
class Note with _$Note {
  factory Note({
    required String title,
    required String content,
    required int color,
    required int timestamp,
    int? id,
  }) = _Note;

  factory Note.fromJson(Map<String, dynamic> json) => _$NoteFromJson(json);
}