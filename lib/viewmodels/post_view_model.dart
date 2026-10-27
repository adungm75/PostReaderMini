import 'package:flutter/foundation.dart';

import '../core/state/view_state.dart';
import '../data/models/post_model.dart';
import '../data/services/post_service.dart';

/// ViewModel quản lý trạng thái và logic nghiệp vụ cho màn hình Post List
///
/// Vai trò trong MVVM & UDF:
/// 1. Tiếp nhận sự kiện/yêu cầu từ View (ví dụ: `fetchPosts`, `refreshPosts`).
/// 2. Điều phối tầng Network Service để lấy dữ liệu.
/// 3. Cập nhật trạng thái nội bộ (`_state`, `_posts`, `_errorMessage`).
/// 4. Phát tín hiệu qua `notifyListeners()` để View (thông qua `ListenableBuilder`) tự động rebuild.
class PostViewModel extends ChangeNotifier {
  final PostService _postService;

  PostViewModel({PostService? postService})
      : _postService = postService ?? PostServiceImpl();

  // --- Các biến trạng thái nội bộ (State) ---
  ViewState _state = ViewState.initial;
  List<PostModel> _posts = [];
  String? _errorMessage;

  // --- Getters cung cấp cho View (Read-only) ---
  ViewState get state => _state;
  List<PostModel> get posts => List.unmodifiable(_posts);
  String? get errorMessage => _errorMessage;

  bool get isLoading => _state == ViewState.loading;
  bool get isLoaded => _state == ViewState.loaded;
  bool get hasError => _state == ViewState.error;

  /// Phương thức xử lý luồng lấy danh sách bài viết
  ///
  /// Luồng UDF diễn ra tại đây:
  /// - Bước 1: Chuyển state sang `loading` -> `notifyListeners()` -> View hiển thị Spinner.
  /// - Bước 2: Gọi tầng Network Service để lấy dữ liệu.
  /// - Bước 3: Nếu thành công, gán `_posts`, chuyển state sang `loaded` -> `notifyListeners()` -> View render ListView.
  /// - Bước 4: Nếu thất bại, bắt lỗi, gán `_errorMessage`, chuyển state sang `error` -> `notifyListeners()` -> View render màn hình lỗi + nút Retry.
  Future<void> fetchPosts({bool isRefresh = false}) async {
    // Nếu đang refresh thì không cần reset danh sách để tránh nhấp nháy UI
    if (!isRefresh) {
      _state = ViewState.loading;
      _errorMessage = null;
      notifyListeners();
    }

    try {
      final fetchedPosts = await _postService.fetchPosts();
      _posts = fetchedPosts;
      _state = ViewState.loaded;
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
      _state = ViewState.error;
    } finally {
      notifyListeners();
    }
  }
}
