import 'package:flutter/material.dart';
import '../viewmodels/post_view_model.dart';

/// View: Tầng giao diện người dùng
/// CHỨNG MINH:
/// - Không import package 'http'
/// - Không import 'dart:convert'
/// - Không chứa bất kỳ dòng code gọi mạng hay giải mã JSON thô nào
/// - Chỉ lắng nghe và vẽ lại giao diện theo trạng thái từ ViewModel
class PostView extends StatefulWidget {
  const PostView({super.key});

  @override
  State<PostView> createState() => _PostViewState();
}

class _PostViewState extends State<PostView> {
  final PostViewModel _viewModel = PostViewModel();

  @override
  void initState() {
    super.initState();
    // Bắt đầu tải dữ liệu khi mở màn hình
    _viewModel.fetchPosts();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Demo MVVM - REST API'),
        centerTitle: true,
      ),
      // Lắng nghe ViewModel qua ListenableBuilder
      body: ListenableBuilder(
        listenable: _viewModel,
        builder: (context, _) {
          // Trạng thái 1: Đang tải (Loading)
          if (_viewModel.status == ViewStatus.loading) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 12),
                  Text('Đang tải dữ liệu...'),
                ],
              ),
            );
          }

          // Trạng thái 2: Báo lỗi kèm nút Thử lại (Error & Retry)
          if (_viewModel.status == ViewStatus.error) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, color: Colors.red, size: 48),
                    const SizedBox(height: 12),
                    Text(
                      _viewModel.errorMessage,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () => _viewModel.fetchPosts(),
                      icon: const Icon(Icons.refresh),
                      label: const Text('Thử lại'),
                    ),
                  ],
                ),
              ),
            );
          }

          // Trạng thái 3: Thành công (Success)
          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: _viewModel.posts.length,
            separatorBuilder: (_, _) => const Divider(),
            itemBuilder: (context, index) {
              final post = _viewModel.posts[index];
              return ListTile(
                leading: CircleAvatar(
                  child: Text('${post.id}'),
                ),
                title: Text(
                  post.title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(post.body),
              );
            },
          );
        },
      ),
    );
  }
}
