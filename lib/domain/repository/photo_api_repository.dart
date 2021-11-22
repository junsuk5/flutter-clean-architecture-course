
import 'package:image_search/domain/model/photo.dart';

abstract class PhotoApiRepository {
  Future<List<Photo>> fetch(String query);
}