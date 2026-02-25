import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../domain/entities/media_item.dart';

class GalleryApi {
  final Dio _dio;
  static const String baseUrl = 'https://gallery.prod2.webant.ru';
  String? _accessToken;

  String? get accessToken => _accessToken;

  GalleryApi(this._dio);

  Future<void> _authenticate() async {
    if (_accessToken != null) return;
    try {
      final response = await _dio.post(
        '$baseUrl/token',
        data: {
          "grant_type": "password",
          "username": dotenv.env['AUTH_USERNAME']!,
          "password": dotenv.env['AUTH_PASSWORD']!,
          "client_id": dotenv.env['CLIENT_ID']!,
          "client_secret": dotenv.env['CLIENT_SECRET']!,
        },
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );
      _accessToken = response.data['access_token'];
    } catch (e) {
      throw Exception('Ошибка авторизации: $e');
    }
  }

  Future<List<MediaItem>> fetchImages({
    required String sort,
    required int offset,
    required int limit,
  }) async {
    await _authenticate();

    try {
      final page = (offset / limit).floor() + 1;
      final response = await _dio.get(
        '$baseUrl/photos',
        queryParameters: {
          'new': sort == 'new',
          'popular': sort == 'popular',
          'page': page,
          'itemsPerPage': limit,
        },
        options: Options(headers: {'Authorization': 'Bearer $_accessToken'}),
      );
      final List data = response.data['hydra:member'];
      return data.map((json) => MediaItem.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Ошибка загрузки картинок: $e');
    }
  }

  Future<MediaItem> getPhotoDetails(int id) async {
    await _authenticate();
    try {
      final response = await _dio.get(
        '$baseUrl/photos/$id',
        options: Options(headers: {'Authorization': 'Bearer $_accessToken'}),
      );
      return MediaItem.fromJson(response.data);
    } catch (e) {
      throw Exception('Ошибка загрузки деталей фото: $e');
    }
  }
}
