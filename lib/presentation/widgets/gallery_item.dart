import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/media_item.dart';
import '../theme/app_colors.dart';

class GalleryItem extends StatelessWidget {
  final MediaItem item;
  final String? authToken;

  const GalleryItem({required this.item, this.authToken});

  @override
  Widget build(BuildContext context) {
    final headers = authToken != null
        ? {'Authorization': 'Bearer $authToken'}
        : null;

    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: CachedNetworkImage(
        imageUrl: item.imageUrl,
        httpHeaders: headers,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        placeholder: (context, url) => Center(
          child: CircularProgressIndicator(
            color: AppColors.textSecondary,
            value: null,
          ),
        ),
        errorWidget: (context, url, error) {
          print("Ошибка загрузки изображения: $error");
          return Icon(Icons.error, color: AppColors.error);
        },
      ),
    );
  }
}
