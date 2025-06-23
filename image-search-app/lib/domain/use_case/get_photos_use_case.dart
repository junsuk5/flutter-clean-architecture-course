import 'dart:math';

import 'package:image_search/data/data_source/result.dart';
import 'package:image_search/domain/model/photo.dart';
import 'package:image_search/domain/repository/photo_api_repository.dart';

class GetPhotosUseCase {
  // 캡슐화
  final PhotoApiRepository _repository;

  GetPhotosUseCase(this._repository);

  Future<Result<List<Photo>>> call(String query) async {
    final result = await _repository.fetch(query);

    return switch (result) {
      // Success(:final data) => Result.success(data.sublist(0, min(3, data.length))),
      // Error(:final e) => Result.error(e),
      // 위 코드와 아래 코드는 동일함. 편한거 쓰면 됨
      //
      Success<List<Photo>>() => Result.success(
        result.data.sublist(0, min(3, result.data.length)),
      ),
      Error<List<Photo>>() => Result.error(result.e),
    };
  }
}
