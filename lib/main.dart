import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:untitled/data/api/gallery_api.dart';
import 'package:untitled/data/repositories/gallery_repository_impl.dart';
import 'package:untitled/domain/repositories/gallery_repository.dart';
import 'package:untitled/presentation/pages/details_page.dart';
import 'package:untitled/presentation/pages/main_page.dart';
import 'package:untitled/presentation/theme/app_colors.dart';
import 'package:untitled/presentation/theme/app_text_styles.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  final dio = Dio();
  final galleryApi = await GalleryApi.create(dio);
  final galleryRepository = GalleryRepositoryImpl(galleryApi);

  runApp(MyApp(galleryRepository: galleryRepository));
}

class MyApp extends StatelessWidget {
  final GalleryRepository galleryRepository;

  const MyApp({super.key, required this.galleryRepository});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: galleryRepository,
      child: MaterialApp(
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
        ),
        initialRoute: '/',
        routes: {
          '/': (ctx) => MainPage(),
          DetailsPage.routeName: (ctx) => DetailsPage(),
        },
      ),
    );
  }
}
