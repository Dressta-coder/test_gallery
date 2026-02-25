import '../entities/media_item.dart';

abstract class GalleryRepository {
  String? get accessToken;

  Future<List<MediaItem>> getImages(String sort, int offset, int limit);

  Future<MediaItem> getPhotoDetails(int id);
}
