import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:untitled/presentation/pages/details_page.dart';
import 'package:untitled/presentation/pages/main_page.dart';
import 'package:untitled/presentation/theme/app_colors.dart';
import 'package:untitled/presentation/theme/app_text_styles.dart';

Future<void> main() async {
  // Загружаем переменные окружения
  await dotenv.load(fileName: ".env");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gallery Test',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppColors.detailsBlue,
        scaffoldBackgroundColor: AppColors.background,
        fontFamily: 'Roboto',
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.background,
          elevation: 0,
          titleTextStyle: AppTextStyles.tabBar,
          iconTheme: IconThemeData(color: AppColors.detailsBlue),
        ),
        textTheme: TextTheme(
          headlineSmall: AppTextStyles.headline,
          bodyLarge: AppTextStyles.bodyLarge,
          bodyMedium: AppTextStyles.bodySmall,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.detailsBlue,
            foregroundColor: Colors.white,
            textStyle: AppTextStyles.tabBar.copyWith(color: Colors.white),
          ),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (ctx) => MainPage(),
        DetailsPage.routeName: (ctx) => DetailsPage(),
      },
    );
  }
}
