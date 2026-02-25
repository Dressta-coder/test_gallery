import 'dart:ui';

import '../../../domain/repositories/gallery_repository.dart';
import 'details_state.dart';

class DetailsBloc {
  final GalleryRepository _repository;
  final VoidCallback onStateChanged;
  final int photoId;

  DetailsState _state = DetailsState();

  DetailsState get state => _state;

  DetailsBloc({
    required GalleryRepository repository,
    required this.photoId,
    required this.onStateChanged,
  }) : _repository = repository;

  Future<void> loadDetails() async {
    _updateState(
      state.copyWith(status: DetailsStatus.loading, errorMessage: null),
    );
    try {
      final item = await _repository.getPhotoDetails(photoId);
      _updateState(state.copyWith(status: DetailsStatus.loaded, item: item));
    } catch (e) {
      _updateState(
        state.copyWith(status: DetailsStatus.error, errorMessage: e.toString()),
      );
    }
  }

  void _updateState(DetailsState newState) {
    _state = newState;
    onStateChanged();
  }
}
