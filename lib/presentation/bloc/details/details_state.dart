import '../../../../domain/entities/media_item.dart';

enum DetailsStatus { initial, loading, loaded, error }

class DetailsState {
  final DetailsStatus status;
  final MediaItem? item;
  final String? errorMessage;

  DetailsState({
    this.status = DetailsStatus.initial,
    this.item,
    this.errorMessage,
  });

  DetailsState copyWith({
    DetailsStatus? status,
    MediaItem? item,
    String? errorMessage,
  }) {
    return DetailsState(
      status: status ?? this.status,
      item: item ?? this.item,
      errorMessage: errorMessage,
    );
  }
}
