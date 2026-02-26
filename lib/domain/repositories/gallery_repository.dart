import 'package:flutter/material.dart';

import '../entities/media_item.dart';

abstract class GalleryRepository {
  Future<List<MediaItem>> getImages(String sort, int offset, int limit);

  Future<MediaItem> getPhotoDetails(int id);

  ImageProvider getImageProvider(String url);
}
