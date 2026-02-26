import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../domain/entities/media_item.dart';

class GalleryApi {
  final Dio _dio;
  String? _accessToken;

  GalleryApi._(this._dio);

  static Future<GalleryApi> create(Dio dio) async {
    final api = GalleryApi._(dio);
    await api._authenticate();
    return api;
  }

  Future<void> _authenticate() async {
    if (_accessToken != null) return;
    try {
      final response = await _dio.post(
        'https://gallery.prod2.webant.ru/token',
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
    try {
      final page = (offset / limit).floor() + 1;
      final response = await _dio.get(
        'https://gallery.prod2.webant.ru/photos',
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
    try {
      final response = await _dio.get(
        'https://gallery.prod2.webant.ru/photos/$id',
        options: Options(headers: {'Authorization': 'Bearer $_accessToken'}),
      );
      return MediaItem.fromJson(response.data);
    } catch (e) {
      throw Exception('Ошибка загрузки деталей фото: $e');
    }
  }

  ImageProvider getNetworkImage(String url) {
    return NetworkImage(
      url,
      headers: {'Authorization': 'Bearer $_accessToken'},
    );
  }
}
