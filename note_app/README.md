# Note App - Freezed 3.0 및 Dart 3 패턴 매칭 마이그레이션

## 📋 변경 사항 개요

이 프로젝트는 **Freezed 2.x**에서 **Freezed 3.0**으로 마이그레이션하고, **Dart 3의 패턴 매칭** 기능을 적용하여 코드의 안전성과 가독성을 향상시켰습니다.

## 🔄 주요 변경 사항

### 1. 의존성 업데이트

```diff
# pubspec.yaml
dependencies:
-  freezed_annotation: ^2.2.0
+  freezed_annotation: ^3.0.0

dev_dependencies:
-  freezed: ^2.3.5  
+  freezed: ^3.0.0
```

### 2. Union Types를 Sealed Classes로 변경

#### OrderType 변경사항
```diff
# lib/domain/util/order_type.dart
@freezed
- abstract class OrderType with _$OrderType {
+ sealed class OrderType with _$OrderType {
  const factory OrderType.ascending() = Ascending;
  const factory OrderType.descending() = Descending;
}
```

#### NoteOrder 변경사항
```diff
# lib/domain/util/note_order.dart
@freezed
- abstract class NoteOrder with _$NoteOrder {
+ sealed class NoteOrder with _$NoteOrder {
  const factory NoteOrder.title(OrderType orderType) = NoteOrderTitle;
  const factory NoteOrder.date(OrderType orderType) = NoteOrderDate;
  const factory NoteOrder.color(OrderType orderType) = NoteOrderColor;
}
```

#### Event Classes 변경사항
```diff
# lib/presentation/notes/notes_event.dart
@freezed
- abstract class NotesEvent with _$NotesEvent {
+ sealed class NotesEvent with _$NotesEvent {
  const factory NotesEvent.loadNotes() = LoadNotes;
  const factory NotesEvent.deleteNote(Note note) = DeleteNote;
  const factory NotesEvent.restoreNote() = RestoreNote;
  const factory NotesEvent.changeOrder(NoteOrder noteOrder) = ChangeOrder;
  const factory NotesEvent.toggleOrderSection() = ToggleOrderSection;
}
```

```diff
# lib/presentation/add_edit_note/add_edit_note_event.dart
@freezed
- abstract class AddEditNoteEvent with _$AddEditNoteEvent {
+ sealed class AddEditNoteEvent with _$AddEditNoteEvent {
  const factory AddEditNoteEvent.changeColor(int color) = ChangeColor;
  const factory AddEditNoteEvent.saveNote(int? id, String title, String content) = SaveNote;
}
```

```diff
# lib/presentation/add_edit_note/add_edit_note_ui_event.dart
@freezed
- abstract class AddEditNoteUiEvent with _$AddEditNoteUiEvent {
+ sealed class AddEditNoteUiEvent with _$AddEditNoteUiEvent {
- const factory AddEditNoteUiEvent.saveNote() = SaveNote;
+ const factory AddEditNoteUiEvent.savedNote() = SavedNote;
  const factory AddEditNoteUiEvent.showSnackBar(String message) = ShowSnackBar;
}
```

### 3. .when() 메소드를 Switch 패턴 매칭으로 변경

#### GetNotesUseCase에서의 변경
```diff
# lib/domain/use_case/get_notes_use_case.dart
+ import 'package:flutter_note_app/domain/util/order_type.dart';

- noteOrder.when(
-   title: (orderType) {
-     orderType.when(
-       ascending: () {
-         notes.sort((a, b) => a.title.compareTo(b.title));
-       },
-       descending: () {
-         notes.sort((a, b) => -a.title.compareTo(b.title));
-       },
-     );
-   },
-   date: (orderType) {
-     orderType.when(
-       ascending: () {
-         notes.sort((a, b) => a.timestamp.compareTo(b.timestamp));
-       },
-       descending: () {
-         notes.sort((a, b) => -a.timestamp.compareTo(b.timestamp));
-       },
-     );
-   },
-   color: (orderType) {
-     orderType.when(
-       ascending: () {
-         notes.sort((a, b) => a.color.compareTo(b.color));
-       },
-       descending: () {
-         notes.sort((a, b) => -a.color.compareTo(b.color));
-       },
-     );
-   },
- );

+ switch (noteOrder) {
+   case NoteOrderTitle(:final orderType):
+     switch (orderType) {
+       case Ascending():
+         notes.sort((a, b) => a.title.compareTo(b.title));
+       case Descending():
+         notes.sort((a, b) => -a.title.compareTo(b.title));
+     }
+   case NoteOrderDate(:final orderType):
+     switch (orderType) {
+       case Ascending():
+         notes.sort((a, b) => a.timestamp.compareTo(b.timestamp));
+       case Descending():
+         notes.sort((a, b) => -a.timestamp.compareTo(b.timestamp));
+     }
+   case NoteOrderColor(:final orderType):
+     switch (orderType) {
+       case Ascending():
+         notes.sort((a, b) => a.color.compareTo(b.color));
+       case Descending():
+         notes.sort((a, b) => -a.color.compareTo(b.color));
+     }
+ }
```

#### NotesViewModel에서의 변경
```diff
# lib/presentation/notes/notes_view_model.dart
void onEvent(NotesEvent event) {
- event.when(
-   loadNotes: _loadNotes,
-   deleteNote: _deleteNote,
-   restoreNote: _restoreNote,
-   changeOrder: (NoteOrder noteOrder) {
-     _state = state.copyWith(noteOrder: noteOrder);
-     _loadNotes();
-   },
-   toggleOrderSection: () {
-     _state = state.copyWith(
-       isOrderSectionVisible: !state.isOrderSectionVisible,
-     );
-     notifyListeners();
-   },
- );

+ switch (event) {
+   case LoadNotes():
+     _loadNotes();
+   case DeleteNote(:final note):
+     _deleteNote(note);
+   case RestoreNote():
+     _restoreNote();
+   case ChangeOrder(:final noteOrder):
+     _state = state.copyWith(noteOrder: noteOrder);
+     _loadNotes();
+   case ToggleOrderSection():
+     _state = state.copyWith(
+       isOrderSectionVisible: !state.isOrderSectionVisible,
+     );
+     notifyListeners();
+ }
}
```

#### AddEditNoteViewModel에서의 변경
```diff
# lib/presentation/add_edit_note/add_edit_note_view_model.dart
void onEvent(AddEditNoteEvent event) {
- event.when(
-   changeColor: _changColor,
-   saveNote: _saveNote,
- );

+ switch (event) {
+   case ChangeColor(:final color):
+     _changColor(color);
+   case SaveNote(:final id, :final title, :final content):
+     _saveNote(id, title, content);
+ }
}

- _eventController.add(const AddEditNoteUiEvent.showSnackBar('제목이나 내용이 비어 있습니다'));
- _eventController.add(const AddEditNoteUiEvent.saveNote());
+ _eventController.add(const AddEditNoteUiEvent.showSnackBar('제목이나 내용이 비어 있습니다'));
+ _eventController.add(const AddEditNoteUiEvent.savedNote());
```

#### AddEditNoteScreen에서의 변경
```diff
# lib/presentation/add_edit_note/add_edit_note_screen.dart
_streamSubscription = viewModel.eventStream.listen((event) {
- event.when(
-   saveNote: () {
-     Navigator.pop(context, true);
-   },
-   showSnackBar: (String message) {
-     final snackBar = SnackBar(content: Text(message));
-     ScaffoldMessenger.of(context).showSnackBar(snackBar);
-   },
- );

+ switch (event) {
+   case SavedNote():
+     Navigator.pop(context, true);
+   case ShowSnackBar(:final message):
+     final snackBar = SnackBar(content: Text(message));
+     ScaffoldMessenger.of(context).showSnackBar(snackBar);
+ }
});
```

## 🎯 마이그레이션의 장점

### 1. **컴파일 타임 안전성 향상**
- Sealed classes를 사용하여 모든 케이스가 처리되었는지 컴파일 타임에 검증
- 새로운 variant 추가 시 누락된 케이스를 컴파일러가 감지

### 2. **코드 가독성 향상**
- Switch 패턴 매칭으로 더 직관적인 코드 작성
- Destructuring을 통해 데이터 접근이 더 명확해짐

### 3. **성능 향상**
- Switch 표현식이 .when() 메소드보다 더 효율적
- 패턴 매칭이 런타임 오버헤드를 줄임

### 4. **이름 충돌 해결**
- `SaveNote` 클래스명 중복을 `SavedNote`로 변경하여 완전히 해결
- 별칭(alias) 사용 없이도 깔끔한 코드 구조 유지
- 더 명확한 의미 전달 (`saveNote` → `savedNote`)

## 🔧 마이그레이션 후 실행 방법

1. **의존성 업데이트**
   ```bash
   flutter pub get
   ```

2. **코드 생성**
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

3. **분석 및 테스트**
   ```bash
   flutter analyze
   flutter test
   ```

4. **앱 실행**
   ```bash
   flutter run
   ```

## 📚 Dart 3 패턴 매칭 문법 정리

### 기본 패턴 매칭
```dart
switch (value) {
  case Pattern1():
    // 처리 로직
  case Pattern2():
    // 처리 로직
}
```

### Destructuring 패턴
```dart
switch (event) {
  case DeleteNote(:final note):
    // note 변수에 직접 접근 가능
  case ChangeOrder(:final noteOrder):
    // noteOrder 변수에 직접 접근 가능
}
```

### 중첩 패턴 매칭
```dart
switch (noteOrder) {
  case NoteOrderTitle(:final orderType):
    switch (orderType) {
      case Ascending():
        // 처리 로직
      case Descending():
        // 처리 로직
    }
}
```

### Named Parameter Destructuring
```dart
switch (event) {
  case SaveNote(:final id, :final title, :final content):
    // id, title, content 변수에 직접 접근 가능
}
```

## 📝 마이그레이션 체크리스트

- [x] **의존성 업데이트**: `freezed` 및 `freezed_annotation` 3.0으로 업데이트
- [x] **Union Types 변경**: `abstract class` → `sealed class`
  - [x] `OrderType`
  - [x] `NoteOrder` 
  - [x] `NotesEvent`
  - [x] `AddEditNoteEvent`
  - [x] `AddEditNoteUiEvent`
- [x] **패턴 매칭 적용**: `.when()` → `switch` 문
  - [x] `GetNotesUseCase`
  - [x] `NotesViewModel`
  - [x] `AddEditNoteViewModel`
  - [x] `AddEditNoteScreen`
- [x] **이름 충돌 해결**: `SaveNote` → `SavedNote` 변경
- [x] **코드 생성**: `build_runner` 실행

## 🚨 주의사항

1. **코드 생성 필수**: sealed class 변경 후 반드시 `build_runner` 실행
2. **이름 충돌 해결**: 
   - `SaveNote` 중복 시 `SavedNote`로 변경하여 의미 구분
   - 클래스명 변경으로 별칭 사용 불필요
3. **모든 케이스 처리**: sealed class 사용 시 모든 케이스를 처리해야 함
4. **기존 .when() 코드**: 점진적으로 switch 패턴 매칭으로 변경 권장
5. **Dart 3 필수**: 패턴 매칭 기능을 위해 Dart 3.0 이상 필요

## 📖 참고 자료

- [Dart 3 Pattern Matching](https://dart.dev/language/patterns)
- [Freezed 3.0 Documentation](https://pub.dev/packages/freezed)
- [Sealed Classes in Dart](https://dart.dev/language/class-modifiers#sealed)
- [Switch Expressions](https://dart.dev/language/branches#switch-expressions)

