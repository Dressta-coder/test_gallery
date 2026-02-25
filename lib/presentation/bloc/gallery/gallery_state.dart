import '../../../domain/entities/media_item.dart';

enum GalleryStatus { initial, loading, loaded, error }

class GalleryState {
  final GalleryStatus status;
  final List<MediaItem> items;
  final bool hasReachedEnd;
  final String? errorMessage;
  final String? authToken;

  GalleryState({
    this.status = GalleryStatus.initial,
    this.items = const [],
    this.hasReachedEnd = false,
    this.errorMessage,
    this.authToken,
  });

  GalleryState copyWith({
    GalleryStatus? status,
    List<MediaItem>? items,
    bool? hasReachedEnd,
    String? errorMessage,
    String? authToken,
  }) {
    return GalleryState(
      status: status ?? this.status,
      items: items ?? this.items,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
      errorMessage: errorMessage,
      authToken: authToken ?? this.authToken,
    );
  }
}
