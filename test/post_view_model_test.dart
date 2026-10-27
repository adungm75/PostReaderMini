import 'package:flutter_test/flutter_test.dart';
import 'package:demotuan2/models/post_model.dart';
import 'package:demotuan2/services/post_service.dart';
import 'package:demotuan2/viewmodels/post_view_model.dart';

class MockPostService implements PostService {
  final bool shouldFail;
  final List<PostModel> mockPosts;

  MockPostService({this.shouldFail = false, this.mockPosts = const []});

  @override
  Future<List<PostModel>> fetchPosts() async {
    if (shouldFail) {
      throw Exception('Lỗi mạng giả lập');
    }
    return mockPosts;
  }
}

void main() {
  group('Kiểm thử 3 trạng thái trong PostViewModel', () {
    test('1. Trạng thái Loading ban đầu khi fetchPosts() được gọi', () {
      final viewModel = PostViewModel(service: MockPostService());
      expect(viewModel.status, ViewStatus.loading);
      expect(viewModel.posts, isEmpty);
    });

    test('2. Trạng thái Success khi lấy dữ liệu thành công', () async {
      final samplePosts = [
        PostModel(id: 1, title: 'Tiêu đề 1', body: 'Nội dung 1'),
      ];
      final viewModel = PostViewModel(service: MockPostService(mockPosts: samplePosts));

      await viewModel.fetchPosts();

      expect(viewModel.status, ViewStatus.success);
      expect(viewModel.posts.length, 1);
      expect(viewModel.posts.first.title, 'Tiêu đề 1');
    });

    test('3. Trạng thái Error khi gặp lỗi mạng kèm thông báo lỗi', () async {
      final viewModel = PostViewModel(service: MockPostService(shouldFail: true));

      await viewModel.fetchPosts();

      expect(viewModel.status, ViewStatus.error);
      expect(viewModel.posts, isEmpty);
      expect(viewModel.errorMessage, isNotEmpty);
    });
  });
}
