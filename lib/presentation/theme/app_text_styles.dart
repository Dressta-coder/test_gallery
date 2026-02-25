import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTextStyles {
  // Название картинки на экране деталей
  static final TextStyle headline = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 22,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
  );

  // Имя автора и дата
  static final TextStyle bodySmall = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  // Основной текст, описание
  static final TextStyle bodyLarge = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
  );

  // Стиль для табов
  static final TextStyle tabBar = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 18,
    fontWeight: FontWeight.w400,
  );

  // Стиль для кнопок Back/Edit
  static final TextStyle detailsButton = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 17,
    color: AppColors.detailsBlue,
  );
}
