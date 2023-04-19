import 'package:flutter/material.dart';
import 'package:flutter_note_app/main.dart' as app;
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('end-to-end test', () {
    testWidgets('FloatingActionButton을 클릭하여 새 노트 추가', (widgetTester) async {
      app.main();
      await widgetTester.pumpAndSettle();

      // given
      final addNoteButtonFinder = find.byIcon(Icons.add);

      // when
      await widgetTester.tap(addNoteButtonFinder);
      await widgetTester.pumpAndSettle();

      // then
      expect(find.byType(TextField), findsNWidgets(2));
      expect(find.byType(FloatingActionButton), findsOneWidget);

      // given 2
      final titleTextFieldFinder = find.byKey(const Key('titleTextField'));
      final contentTextFieldFinder = find.byKey(const Key('contentTextField'));

      // when 2
      await widgetTester.enterText(titleTextFieldFinder, 'title');
      await widgetTester.enterText(contentTextFieldFinder, 'content');
      await widgetTester.tap(find.byType(FloatingActionButton));

      // then 2
      expect(find.text('title'), findsOneWidget);
      expect(find.text('content'), findsOneWidget);
    });
  });
}