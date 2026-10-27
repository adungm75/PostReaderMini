import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import '../../core/constants/api_constants.dart';
import '../../core/errors/app_exception.dart';
import '../models/post_model.dart';

/// Interface định nghĩa hợp đồng cho PostService
/// Giúp code phân tách rõ ràng, dễ bảo trì và dễ viết Unit Test với Mock
abstract class PostService {
  Future<List<PostModel>> fetchPosts();
  Future<PostModel> fetchPostDetail(int id);
}

/// Hiện thực Network Service gọi REST API sử dụng package `http`
/// Hoàn toàn độc lập, không phụ thuộc vào bất kỳ Widget hay BuildContext nào.
class PostServiceImpl implements PostService {
  final http.Client _client;

  PostServiceImpl({http.Client? client}) : _client = client ?? http.Client();

  @override
  Future<List<PostModel>> fetchPosts() async {
    final uri = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.postsEndpoint}');

    try {
      final response = await _client
          .get(uri)
          .timeout(ApiConstants.timeoutDuration);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body) as List<dynamic>;
        return data
            .map((item) => PostModel.fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        throw ServerException(
          'Không thể tải danh sách bài viết. Mã lỗi: ${response.statusCode}',
          response.statusCode,
        );
      }
    } on SocketException {
      throw NetworkException();
    } on TimeoutException {
      throw TimeoutExceptionCustom();
    } on AppException {
      rethrow;
    } catch (e) {
      throw AppException('Đã có lỗi không xác định xảy ra: $e');
    }
  }

  @override
  Future<PostModel> fetchPostDetail(int id) async {
    final uri = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.postsEndpoint}/$id');

    try {
      final response = await _client
          .get(uri)
          .timeout(ApiConstants.timeoutDuration);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body) as Map<String, dynamic>;
        return PostModel.fromJson(data);
      } else {
        throw ServerException(
          'Không thể tải chi tiết bài viết #$id',
          response.statusCode,
        );
      }
    } on SocketException {
      throw NetworkException();
    } on TimeoutException {
      throw TimeoutExceptionCustom();
    } on AppException {
      rethrow;
    } catch (e) {
      throw AppException('Đã có lỗi không xác định xảy ra: $e');
    }
  }
}
