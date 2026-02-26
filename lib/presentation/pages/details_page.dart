import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:untitled/domain/repositories/gallery_repository.dart';

import '../bloc/details/details_bloc.dart';
import '../bloc/details/details_state.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class DetailsPage extends StatefulWidget {
  static const String routeName = '/details';

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  DetailsBloc? _bloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_bloc == null) {
      final photoId = ModalRoute.of(context)!.settings.arguments as int;
      _bloc = DetailsBloc(
        repository: context.read<GalleryRepository>(),
        photoId: photoId,
        onStateChanged: () {
          if (mounted) setState(() {});
        },
      );
      _bloc!.loadDetails();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_bloc == null || _bloc!.state.status == DetailsStatus.loading) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: CircularProgressIndicator(color: AppColors.textSecondary),
        ),
      );
    }

    final state = _bloc!.state;

    if (state.status == DetailsStatus.error) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: Center(child: Text('Ошибка: ${state.errorMessage}')),
      );
    }

    final item = state.item!;
    final formattedDate = item.dateCreated != null
        ? DateFormat('dd.MM.yyyy').format(item.dateCreated!)
        : '';

    final imageProvider = context.read<GalleryRepository>().getImageProvider(
      item.imageUrl,
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Row(
                  children: [
                    Icon(
                      Icons.arrow_back_ios,
                      color: AppColors.detailsBlue,
                      size: 18,
                    ),
                    SizedBox(width: 4),
                    Text('Back', style: AppTextStyles.detailsButton),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 250,
              width: double.infinity,
              child: InteractiveViewer(
                trackpadScrollCausesScale: true,
                minScale: 1.0,
                maxScale: 4.0,
                child: Image(image: imageProvider, fit: BoxFit.cover),
              ),
            ),
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.title, style: AppTextStyles.headline),
                  SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(item.userName, style: AppTextStyles.bodySmall),
                      Text(formattedDate, style: AppTextStyles.bodySmall),
                    ],
                  ),
                  SizedBox(height: 16),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  item.description.isNotEmpty
                      ? item.description
                      : 'Нет описания',
                  style: AppTextStyles.bodyLarge,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
