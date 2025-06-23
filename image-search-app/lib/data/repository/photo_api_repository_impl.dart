import 'package:image_search/data/data_source/pixabay_api.dart';
import 'package:image_search/data/data_source/result.dart';
import 'package:image_search/domain/model/photo.dart';
import 'package:image_search/domain/repository/photo_api_repository.dart';

class PhotoApiRepositoryImpl implements PhotoApiRepository {
  PixabayApi api;

  PhotoApiRepositoryImpl(this.api);

  @override
  Future<Result<List<Photo>>> fetch(String query) async {
    final Result<Iterable> result = await api.fetch(query);

    return switch (result) {
      Success(:final data) => Result.success(data.map((e) => Photo.fromJson(e)).toList()),
      Error(:final e) => Result.error(e),
    };
  }
}
