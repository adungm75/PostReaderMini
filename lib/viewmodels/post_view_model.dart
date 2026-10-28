import 'package:flutter/foundation.dart';
import '../models/post_model.dart';
import '../services/post_service.dart';

/// 3 trạng thái giao diện theo đúng yêu cầu: Đang tải, Thành công, Báo lỗi
enum ViewStatus { loading, success, error }

/// ViewModel: Xử lý logic nghiệp vụ và quản lý trạng thái
class PostViewModel extends ChangeNotifier {
  final PostService _service;

  PostViewModel({PostService? service}) : _service = service ?? PostService();

  ViewStatus _status = ViewStatus.loading;
  List<PostModel> _posts = [];
  String _errorMessage = '';

  ViewStatus get status => _status;
  List<PostModel> get posts => _posts;
  String get errorMessage => _errorMessage;

  /// Tải dữ liệu từ tầng Service và cập nhật trạng thái
  Future<void> fetchPosts() async {
    // 1. Chuyển sang trạng thái Đang tải (Loading)
    _status = ViewStatus.loading;
    _errorMessage = '';
    notifyListeners();

    try {
      // 2. Gọi Service lấy dữ liệu
      _posts = await _service.fetchPosts();
      _status = ViewStatus.success; // Trạng thái Thành công (Success)
    } catch (e) {
      // 3. Trạng thái Báo lỗi (Error)
      _status = ViewStatus.error;
      _errorMessage = 'Lỗi kết nối: $e';
      debugPrint('PostViewModel Error: $e');
    } finally {
      // Phát tín hiệu để View cập nhật giao diện
      notifyListeners();
    }
  }
}
