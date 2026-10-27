/// Model biểu diễn cấu trúc dữ liệu bài viết
/// Chịu trách nhiệm lưu trữ dữ liệu và chuyển đổi từ JSON
class PostModel {
  final int id;
  final String title;
  final String body;

  PostModel({
    required this.id,
    required this.title,
    required this.body,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      body: json['body'] as String? ?? '',
    );
  }
}
