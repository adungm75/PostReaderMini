import 'package:flutter/material.dart';

import '../data/models/post_model.dart';

/// Màn hình Đọc chi tiết bài viết (Post Detail)
class PostDetailView extends StatelessWidget {
  final PostModel post;

  const PostDetailView({
    super.key,
    required this.post,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bài viết #${post.id}'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Metadata chips (ID & UserID)
            Row(
              children: [
                Chip(
                  avatar: const Icon(Icons.tag_rounded, size: 16),
                  label: Text('Post ID: ${post.id}'),
                  backgroundColor: Colors.indigo.shade50,
                  side: BorderSide.none,
                ),
                const SizedBox(width: 8),
                Chip(
                  avatar: const Icon(Icons.person_outline_rounded, size: 16),
                  label: Text('Tác giả ID: ${post.userId}'),
                  backgroundColor: Colors.amber.shade50,
                  side: BorderSide.none,
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Tiêu đề
            Text(
              post.title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                height: 1.3,
              ),
            ),
            const Divider(height: 32),
            // Nội dung bài viết
            Text(
              post.body,
              style: const TextStyle(
                fontSize: 16,
                height: 1.6,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
