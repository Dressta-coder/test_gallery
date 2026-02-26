import 'package:flutter/material.dart';

import '../../domain/entities/media_item.dart';
import '../../domain/repositories/gallery_repository.dart';
import '../api/gallery_api.dart';

class GalleryRepositoryImpl implements GalleryRepository {
  final GalleryApi _api;

  GalleryRepositoryImpl(this._api);

  @override
  Future<List<MediaItem>> getImages(String sort, int offset, int limit) {
    return _api.fetchImages(sort: sort, offset: offset, limit: limit);
  }

  @override
  Future<MediaItem> getPhotoDetails(int id) {
    return _api.getPhotoDetails(id);
  }

  @override
  ImageProvider getImageProvider(String url) {
    return _api.getNetworkImage(url);
  }
}
