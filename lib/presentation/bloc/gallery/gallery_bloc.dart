import 'dart:ui';

import '../../../domain/entities/media_item.dart';
import '../../../domain/repositories/gallery_repository.dart';
import 'gallery_state.dart';

class GalleryBloc {
  final GalleryRepository _repository;
  final String _sort;
  final VoidCallback onStateChanged;

  GalleryState _state;
  int _currentOffset = 0;
  static const int _limit = 10;
  bool _isLoading = false;

  GalleryState get state => _state;

  GalleryBloc({
    required GalleryRepository repository,
    required String sort,
    required this.onStateChanged,
  }) : _repository = repository,
        _sort = sort,
        _state = GalleryState();

  Future<void> loadFirstPage() async {
    if (_isLoading) return;
    _isLoading = true;
    _currentOffset = 0;
    _updateState(
      state.copyWith(status: GalleryStatus.loading, errorMessage: null),
    );
    try {
      final items = await _repository.getImages(_sort, _currentOffset, _limit);
      _currentOffset = items.length;
      final hasReachedEnd = items.length < _limit;
      _updateState(
        state.copyWith(
          status: GalleryStatus.loaded,
          items: items,
          hasReachedEnd: hasReachedEnd,
        ),
      );
    } catch (e) {
      _updateState(
        state.copyWith(status: GalleryStatus.error, errorMessage: e.toString()),
      );
    } finally {
      _isLoading = false;
    }
  }

  Future<void> loadNextPage() async {
    if (_isLoading || state.hasReachedEnd) return;
    _isLoading = true;
    _updateState(state.copyWith(status: GalleryStatus.loading));
    try {
      final newItems = await _repository.getImages(
        _sort,
        _currentOffset,
        _limit,
      );
      _currentOffset += newItems.length;
      final hasReachedEnd = newItems.length < _limit;
      final allItems = List<MediaItem>.from(state.items)..addAll(newItems);
      _updateState(
        state.copyWith(
          status: GalleryStatus.loaded,
          items: allItems,
          hasReachedEnd: hasReachedEnd,
        ),
      );
    } catch (e) {
      _updateState(
        state.copyWith(status: GalleryStatus.error, errorMessage: e.toString()),
      );
    } finally {
      _isLoading = false;
    }
  }

  void _updateState(GalleryState newState) {
    _state = newState;
    onStateChanged();
  }

  void dispose() {
  }
}
