import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/media_item_details_args.dart';

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
  MediaItemDetailsArgs? _args;
  final _transformationController = TransformationController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_args == null) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args != null && args is MediaItemDetailsArgs) {
        _args = args;
        _bloc = DetailsBloc(
          repository: args.repository,
          photoId: _args!.item.id,
          onStateChanged: () {
            if (mounted) setState(() {});
          },
        );
        _bloc!.loadDetails();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_args == null ||
        _bloc == null ||
        _bloc!.state.status == DetailsStatus.loading) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: CircularProgressIndicator(color: AppColors.textSecondary),
        ),
      );
    }

    final state = _bloc!.state;
    final authToken = _args!.authToken;

    if (state.status == DetailsStatus.error) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: Center(child: Text('Ошибка: ${state.errorMessage}')),
      );
    }

    final item = state.item!;
    final headers = authToken != null
        ? {'Authorization': 'Bearer $authToken'}
        : null;

    final formattedDate = item.dateCreated != null
        ? DateFormat('dd.MM.yyyy').format(item.dateCreated!)
        : '';

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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
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
                ],
              ),
            ),
            SizedBox(
              height: 250,
              width: double.infinity,
              child: InteractiveViewer(
                transformationController: _transformationController,
                trackpadScrollCausesScale: true,
                minScale: 1.0,
                maxScale: 4.0,
                child: CachedNetworkImage(
                  imageUrl: item.imageUrl,
                  httpHeaders: headers,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Center(
                    child: CircularProgressIndicator(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  errorWidget: (context, url, error) =>
                      Icon(Icons.error, color: AppColors.error),
                ),
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

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }
}
