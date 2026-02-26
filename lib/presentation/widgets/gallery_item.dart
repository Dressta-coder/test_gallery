import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/domain/repositories/gallery_repository.dart';

import '../../domain/entities/media_item.dart';
import '../theme/app_colors.dart';

class GalleryItem extends StatelessWidget {
  final MediaItem item;

  const GalleryItem({required this.item});

  @override
  Widget build(BuildContext context) {
    final imageProvider = context.read<GalleryRepository>().getImageProvider(
      item.imageUrl,
    );

    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: Image(
        image: imageProvider,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
          if (wasSynchronouslyLoaded) return child;
          return AnimatedOpacity(
            child: child,
            opacity: frame == null ? 0 : 1,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        },
        errorBuilder: (context, error, stackTrace) {
          print("Ошибка загрузки изображения: $error");
          return Icon(Icons.error, color: AppColors.error);
        },
      ),
    );
  }
}
