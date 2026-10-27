import 'package:flutter_test/flutter_test.dart';
import 'package:demotuan2/core/state/view_state.dart';
import 'package:demotuan2/core/errors/app_exception.dart';
import 'package:demotuan2/data/models/post_model.dart';
import 'package:demotuan2/data/services/post_service.dart';
import 'package:demotuan2/viewmodels/post_view_model.dart';

/// Mock service để giả lập tầng Network Service trong kiểm thử đơn vị
class MockPostService implements PostService {
  final bool shouldFail;
  final List<PostModel> mockPosts;

  MockPostService({
    this.shouldFail = false,
    this.mockPosts = const [],
  });

  @override
  Future<List<PostModel>> fetchPosts() async {
    if (shouldFail) {
      throw NetworkException('Lỗi giả lập mất mạng');
    }
    return mockPosts;
  }

  @override
  Future<PostModel> fetchPostDetail(int id) async {
    if (shouldFail) {
      throw NetworkException('Lỗi giả lập');
    }
    return mockPosts.firstWhere((p) => p.id == id);
  }
}

void main() {
  group('Kiểm thử PostViewModel (MVVM & UDF)', () {
    test('Trạng thái ban đầu của ViewModel là ViewState.initial', () {
      final viewModel = PostViewModel(postService: MockPostService());
      expect(viewModel.state, ViewState.initial);
      expect(viewModel.posts, isEmpty);
      expect(viewModel.errorMessage, isNull);
    });

    test('UDF Thành công: Chuyển sang loading rồi loaded khi lấy dữ liệu thành công', () async {
      final samplePosts = [
        const PostModel(id: 1, userId: 1, title: 'Bài viết 1', body: 'Nội dung 1'),
        const PostModel(id: 2, userId: 1, title: 'Bài viết 2', body: 'Nội dung 2'),
      ];

      final mockService = MockPostService(mockPosts: samplePosts);
      final viewModel = PostViewModel(postService: mockService);

      // Kích hoạt User Action: fetchPosts()
      final future = viewModel.fetchPosts();

      // Kiểm tra trong lúc đang chạy: State là loading
      expect(viewModel.state, ViewState.loading);

      await future;

      // Kết quả sau khi Service trả dữ liệu: State là loaded
      expect(viewModel.state, ViewState.loaded);
      expect(viewModel.posts.length, 2);
      expect(viewModel.posts.first.title, 'Bài viết 1');
      expect(viewModel.errorMessage, isNull);
    });

    test('UDF Lỗi: Chuyển sang error và lưu errorMessage khi gọi service thất bại', () async {
      final mockService = MockPostService(shouldFail: true);
      final viewModel = PostViewModel(postService: mockService);

      await viewModel.fetchPosts();

      expect(viewModel.state, ViewState.error);
      expect(viewModel.posts, isEmpty);
      expect(viewModel.errorMessage, contains('Lỗi mạng'));
    });
  });
}
