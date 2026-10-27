import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/post_model.dart';

/// Network Service: Đóng gói tác vụ gọi REST API
/// Hoàn toàn độc lập, không phụ thuộc vào Widget hay BuildContext
class PostService {
  static const String _url = String.fromEnvironment(
    'API_URL',
    defaultValue: 'https://jsonplaceholder.typicode.com/posts',
  );

  Future<List<PostModel>> fetchPosts() async {
    final response = await http.get(Uri.parse(_url));

    if (response.statusCode == 200) {
      // Giải mã JSON thô tại tầng Service
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => PostModel.fromJson(json)).toList();
    } else {
      throw Exception('Lỗi kết nối máy chủ: ${response.statusCode}');
    }
  }
}
