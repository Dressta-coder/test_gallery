import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class OfflineWidget extends StatelessWidget {
  final VoidCallback onRetry;
  const OfflineWidget({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.wifi_off, size: 80, color: AppColors.textSecondary),
          SizedBox(height: 16),
          Text('Нет подключения к интернету', style: AppTextStyles.bodyLarge),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: onRetry,
            child: Text('Повторить'),
          ),
        ],
      ),
    );
  }
}
