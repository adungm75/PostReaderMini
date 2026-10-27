import 'package:flutter/material.dart';

import '../core/state/view_state.dart';
import '../viewmodels/post_view_model.dart';
import 'post_detail_view.dart';
import 'widgets/error_view_widget.dart';
import 'widgets/post_card_widget.dart';

/// Màn hình Danh sách bài viết (PostListView)
///
/// Thể hiện trọn vẹn:
/// 1. View trong kiến trúc MVVM: Chỉ đảm nhiệm hiển thị UI, không chứa logic mạng hay parse JSON.
/// 2. Cơ chế liên kết View - ViewModel: Sử dụng [ListenableBuilder] lắng nghe [PostViewModel] (ChangeNotifier).
/// 3. Luồng dữ liệu một chiều (UDF):
///    - Người dùng kéo làm mới hoặc bấm Thử lại -> gọi method của ViewModel.
///    - ViewModel xử lý và cập nhật State -> [ListenableBuilder] tự động rebuild UI tương ứng.
class PostListView extends StatefulWidget {
  const PostListView({super.key});

  @override
  State<PostListView> createState() => _PostListViewState();
}

class _PostListViewState extends State<PostListView> {
  late final PostViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    // Khởi tạo ViewModel
    _viewModel = PostViewModel();

    // Kích hoạt luồng UDF đầu tiên: Tải dữ liệu khi mở màn hình
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _viewModel.fetchPosts();
    });
  }

  @override
  void dispose() {
    // Dọn dẹp tài nguyên của ChangeNotifier khi widget bị huỷ
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post Reader Mini (MVVM)'),
        elevation: 0,
        actions: [
          // Nút reload thủ công minh họa tương tác người dùng (User Action)
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Tải lại',
            onPressed: () => _viewModel.fetchPosts(),
          ),
        ],
      ),
      // CƠ CHẾ LIÊN KẾT: ListenableBuilder lắng nghe thay đổi từ _viewModel
      body: ListenableBuilder(
        listenable: _viewModel,
        builder: (context, _) {
          switch (_viewModel.state) {
            case ViewState.initial:
            case ViewState.loading:
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text(
                      'Đang kết nối API & tải dữ liệu...',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              );

            case ViewState.error:
              // Trạng thái Lỗi: Hiển thị thông báo và nút Thử lại
              return ErrorViewWidget(
                message: _viewModel.errorMessage,
                onRetry: () => _viewModel.fetchPosts(),
              );

            case ViewState.loaded:
              if (_viewModel.posts.isEmpty) {
                return const Center(
                  child: Text('Không có bài viết nào.'),
                );
              }

              // Trạng thái Thành công: Hiển thị danh sách kèm Pull-to-refresh
              return RefreshIndicator(
                onRefresh: () => _viewModel.fetchPosts(isRefresh: true),
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: _viewModel.posts.length,
                  itemBuilder: (context, index) {
                    final post = _viewModel.posts[index];
                    return PostCardWidget(
                      post: post,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PostDetailView(post: post),
                          ),
                        );
                      },
                    );
                  },
                ),
              );
          }
        },
      ),
    );
  }
}
