/// Model đại diện cho đối tượng bài viết (Post)
/// Chịu trách nhiệm lưu trữ cấu trúc dữ liệu và chuyển đổi JSON (parse JSON)
/// Hoàn toàn độc lập với Flutter UI Widgets.
class PostModel {
  final int id;
  final int userId;
  final String title;
  final String body;

  const PostModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
  });

  /// Parse dữ liệu từ JSON Map sang đối tượng PostModel
  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'] as int? ?? 0,
      userId: json['userId'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      body: json['body'] as String? ?? '',
    );
  }

  /// Chuyển đối tượng PostModel ngược lại định dạng JSON Map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'body': body,
    };
  }

  @override
  String toString() {
    return 'PostModel(id: $id, userId: $userId, title: $title)';
  }
}
