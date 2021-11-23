import 'package:flutter_test/flutter_test.dart';
import 'package:image_search/data/data_source/result.dart';
import 'package:image_search/domain/repository/photo_api_repository.dart';
import 'package:image_search/domain/model/photo.dart';
import 'package:image_search/presentation/home/home_view_model.dart';

void main() {
  test('Stream이 잘 동작해야 한다', () async {
    final viewModel = HomeViewModel(FakePhotoApiRepository());

    await viewModel.fetch('apple');

    final List<Photo> result = fakeJson.map((e) => Photo.fromJson(e)).toList();

    expect(viewModel.photos, result);
  });
}

class FakePhotoApiRepository extends PhotoApiRepository {
  @override
  Future<Result<List<Photo>>> fetch(String query) async {
    Future.delayed(const Duration(milliseconds: 500));

    return Result.success(fakeJson.map((e) => Photo.fromJson(e)).toList());
  }
}

List<Map<String, dynamic>> fakeJson = [
  {
    "id": 410311,
    "pageURL":
        "https://pixabay.com/photos/iphone-hand-screen-smartphone-apps-410311/",
    "type": "photo",
    "tags": "iphone, hand, screen",
    "previewURL":
        "https://cdn.pixabay.com/photo/2014/08/05/10/27/iphone-410311_150.jpg",
    "previewWidth": 150,
    "previewHeight": 99,
    "webformatURL":
        "https://pixabay.com/get/ga40944969ab1ca0cb5e5e2a753382c5ef38aa9b1bdf195f44a6e8c7def03f5b2ce08c74211f5bd254565642907f5e7b5_640.jpg",
    "webformatWidth": 640,
    "webformatHeight": 426,
    "largeImageURL":
        "https://pixabay.com/get/gac97151d90f6f74f39ba9a6013d97a3e0c8b3b2673356bef20a65b9a253d439913d8d3566a6e8485773b9aea90170c38a538a3582b0a2af3e51efe53ebc8885b_1280.jpg",
    "imageWidth": 1920,
    "imageHeight": 1280,
    "imageSize": 416413,
    "views": 441374,
    "downloads": 213676,
    "collections": 2913,
    "likes": 573,
    "comments": 146,
    "user_id": 264599,
    "user": "JESHOOTS-com",
    "userImageURL":
        "https://cdn.pixabay.com/user/2014/06/08/15-27-10-248_250x250.jpg"
  },
  {
    "id": 620817,
    "pageURL":
        "https://pixabay.com/photos/office-notes-notepad-entrepreneur-620817/",
    "type": "photo",
    "tags": "office, notes, notepad",
    "previewURL":
        "https://cdn.pixabay.com/photo/2015/02/02/11/08/office-620817_150.jpg",
    "previewWidth": 150,
    "previewHeight": 99,
    "webformatURL":
        "https://pixabay.com/get/g5dce019c1f10360baae95dd11b0a474f4a88609aa453b6fb63eb21af5ced9f66512d0eecdb37d13d65aece68c04ac30f_640.jpg",
    "webformatWidth": 640,
    "webformatHeight": 425,
    "largeImageURL":
        "https://pixabay.com/get/g288340ffe42c24238450b87b53b341663b8a4d5a34cd29ddfe5bfb2ea8ebad94f954e901100c4cd89e7e821fb78c1262034505ae2109e88ecf14df55589fddb1_1280.jpg",
    "imageWidth": 4288,
    "imageHeight": 2848,
    "imageSize": 2800224,
    "views": 631369,
    "downloads": 269069,
    "collections": 3062,
    "likes": 1062,
    "comments": 242,
    "user_id": 663163,
    "user": "Firmbee",
    "userImageURL":
        "https://cdn.pixabay.com/user/2020/11/25/09-38-28-431_250x250.png"
  },
];
