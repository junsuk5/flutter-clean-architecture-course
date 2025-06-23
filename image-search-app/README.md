# Flutter Clean Architecture - Freezed 3.0 업데이트 가이드

안녕하세요! 이 문서는 강의에서 사용하던 이미지 검색 앱을 Freezed 3.0으로 업데이트한 내용을 정리한 것입니다. 변경된 부분들을 자세히 설명드리니, 코드를 따라가시면서 이해해보시기 바랍니다.

## 🎯 왜 업데이트를 했을까요?

기존에 사용하던 Freezed 2.x에서 3.0으로 업데이트하면서 다음과 같은 장점들을 얻을 수 있습니다:

- **더 안전한 코드**: sealed 클래스로 패턴 매칭이 더 엄격해졌어요
- **성능 향상**: switch 문은 기본 Dart 문법이에요. when() 메서드는 제거 됐어요.
- **현대적인 문법**: Dart 3의 패턴 매칭(switch)을 활용할 수 있어요
- **더 깔끔한 코드**: 코드가 더 읽기 쉬워졌어요

## 📚 주요 변경 사항 설명

### 1. 의존성 업데이트

```yaml
# pubspec.yaml에서 변경된 부분
dev_dependencies:
  flutter_lints: ^6.0.0  # 기존 4.0.0에서 업데이트
```

**왜 업데이트했나요?**
- 최신 Flutter 린트 규칙을 사용하여 더 좋은 코드 품질을 유지하기 위해서입니다.

### 2. Freezed 클래스 선언 방식 변경

#### 🔍 **일반 데이터 클래스의 경우**

```dart
// ✅ 변경 후 (Photo, HomeState)
@freezed
abstract class Photo with _$Photo {
  factory Photo({
    required int id,
    required String tags,
    required String previewURL,
  }) = _Photo;
  
  factory Photo.fromJson(Map<String, dynamic> json) => _$PhotoFromJson(json);
}
```

**설명**: 일반적인 데이터를 담는 클래스에는 `abstract` 키워드를 붙입니다.

#### 🔍 **sealed 클래스의 경우**

```dart
// ✅ 변경 후 (Result, HomeUiEvent)
@freezed
sealed class Result<T> with _$Result<T> {
  const factory Result.success(T data) = Success;
  const factory Result.error(String e) = Error;
}
```

**설명**: 여러 가지 경우(성공/실패 등)를 나타내는 클래스에는 `sealed` 키워드를 사용합니다.


### 3. 패턴 매칭: when() → switch 문으로 변경

이 부분이 가장 큰 변화입니다! 기존의 `.when()` 메서드를 모두 switch 문으로 바꿨어요.

#### 🔍 **ViewModel에서의 변경**

```dart
// ❌ 기존 방식 (when 메서드)
result.when(
  success: (photos) {
    _state = state.copyWith(photos: photos);
    notifyListeners();
  },
  error: (message) {
    _eventController.add(HomeUiEvent.showSnackBar(message));
  },
);

// ✅ 새로운 방식 (switch 문)
switch (result) {
  case Success(:final data):
    _state = state.copyWith(photos: data);
    notifyListeners();
  case Error(:final e):
    _eventController.add(HomeUiEvent.showSnackBar(e));
}
```

**장점**:
- 더 빠른 성능
- 컴파일러가 모든 경우를 다뤘는지 더 엄격하게 검사
- Dart의 최신 패턴 매칭 문법 활용

#### 🔍 **UseCase에서의 변경**

```dart
// ❌ 기존 방식
return result.when(
  success: (photos) => Result.success(photos.sublist(0, min(3, photos.length))),
  error: (message) => Result.error(message),
);

// ✅ 새로운 방식 (switch 표현식)
return switch (result) {
  Success(:final data) => Result.success(data.sublist(0, min(3, data.length))),
  Error(:final e) => Result.error(e),
};
```

**설명**: 간단한 값 반환은 switch 표현식으로 한 줄에 처리할 수 있어요.

#### 🔍 **UI 이벤트 처리에서의 변경**

```dart
// ❌ 기존 방식
event.when(showSnackBar: (message) {
  final snackBar = SnackBar(content: Text(message));
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
});

// ✅ 새로운 방식
switch (event) {
  case ShowSnackBar(:final message):
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
```

### 4. 패턴 매칭 문법 이해하기

새로운 문법이 어려우실 수 있어서 자세히 설명드릴게요:

#### 🔍 **`:final` 문법**

```dart
// 이 두 코드는 같은 의미입니다
case Success(:final data):     // 짧은 문법
case Success(data: final data): // 긴 문법

// 즉, Success의 data 필드를 data 변수에 저장한다는 뜻
```

#### 🔍 **다양한 패턴 매칭 방식**

```dart
// 방법 1: 필드 이름 그대로 사용
case Success(:final data):

// 방법 2: 다른 이름으로 받기
case Success(data: final photos):

// 방법 3: 타입 명시하기 (더 명확함)
case Success<List<Photo>>():
  // result.data로 접근
```

### 5. 불필요한 import 정리

```dart
// ❌ 제거된 import들
import 'package:json_annotation/json_annotation.dart';

// ✅ 이유: freezed_annotation이 이미 포함하고 있어서 중복
```

## 🛠️ 개발 환경 설정

업데이트된 코드를 실행하려면:

```bash
# 1. 의존성 설치
flutter pub get

# 2. 코드 생성 (중요!)
flutter packages pub run build_runner build

# 3. 정적 분석 확인
flutter analyze

# 4. 앱 실행
flutter run
```

## 📁 변경된 파일들

### 데이터 모델
- `lib/domain/model/photo.dart` - abstract 키워드 추가
- `lib/presentation/home/home_state.dart` - abstract 키워드 추가

### 유니온 타입
- `lib/data/data_source/result.dart` - sealed 키워드로 변경
- `lib/presentation/home/home_ui_event.dart` - sealed 키워드로 변경

### 비즈니스 로직
- `lib/domain/use_case/get_photos_use_case.dart` - switch 표현식 사용
- `lib/data/repository/photo_api_repository_impl.dart` - switch 표현식 사용

### UI 레이어
- `lib/presentation/home/home_view_model.dart` - switch 문 사용
- `lib/presentation/home/home_screen.dart` - switch 문 사용, import 추가

## ⚠️ 주의사항

### 코드 생성을 잊지 마세요!
```bash
flutter packages pub run build_runner build
```
Freezed 클래스를 수정한 후에는 반드시 이 명령어를 실행해야 합니다.

### switch 문의 exhaustive 검사
sealed 클래스를 사용하면 컴파일러가 모든 경우를 처리했는지 검사합니다. 만약 케이스를 빠뜨리면 컴파일 에러가 발생해요.

### 패턴 매칭 문법 연습
새로운 문법이 익숙하지 않으실 수 있어요. 천천히 따라해보시면서 익혀보세요!

## 🎓 학습 포인트

이번 업데이트를 통해 다음을 배울 수 있습니다:

1. **Dart 3의 패턴 매칭**: 현대적인 Dart 문법
2. **sealed 클래스**: 타입 안전성 향상
3. **성능 최적화**: switch가 when()보다 빠른 이유
4. **코드 품질**: 최신 린트 규칙 적용

## 💡 추가 학습 자료

- [Dart 패턴 매칭 공식 문서](https://dart.dev/language/patterns)
- [Freezed 3.0 마이그레이션 가이드](https://pub.dev/packages/freezed)
- [sealed 클래스 이해하기](https://dart.dev/language/class-modifiers#sealed)

## 🤝 질문이 있으시다면

업데이트 과정에서 궁금한 점이나 에러가 발생하면 언제든 질문해주세요. 함께 해결해보겠습니다!

---

**마지막으로**: 이런 업데이트들은 Flutter/Dart 생태계가 계속 발전하고 있다는 증거입니다. 최신 기술을 따라가면서 더 좋은 앱을 만들어보세요! 🚀