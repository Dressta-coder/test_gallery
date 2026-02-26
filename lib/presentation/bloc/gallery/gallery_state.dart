import '../../../domain/entities/media_item.dart';

enum GalleryStatus { initial, loading, loaded, error }

class GalleryState {
  final GalleryStatus status;
  final List<MediaItem> items;
  final bool hasReachedEnd;
  final String? errorMessage;

  GalleryState({
    this.status = GalleryStatus.initial,
    this.items = const [],
    this.hasReachedEnd = false,
    this.errorMessage,
  });

  GalleryState copyWith({
    GalleryStatus? status,
    List<MediaItem>? items,
    bool? hasReachedEnd,
    String? errorMessage,
  }) {
    return GalleryState(
      status: status ?? this.status,
      items: items ?? this.items,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
      errorMessage: errorMessage,
    );
  }
}
