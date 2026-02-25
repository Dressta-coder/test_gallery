import '../repositories/gallery_repository.dart';
import './media_item.dart';

class MediaItemDetailsArgs {
  final MediaItem item;
  final String? authToken;
  final GalleryRepository repository;

  MediaItemDetailsArgs({
    required this.item,
    this.authToken,
    required this.repository,
  });
}
