/// Enum định nghĩa các trạng thái giao diện trong mô hình MVVM & UDF
enum ViewState {
  /// Trạng thái khởi tạo ban đầu, chưa thực hiện hành động
  initial,

  /// Trạng thái đang tải dữ liệu (gọi API) -> UI hiển thị Loading Indicator
  loading,

  /// Trạng thái tải dữ liệu thành công -> UI hiển thị danh sách bài viết
  loaded,

  /// Trạng thái xảy ra lỗi (mất mạng, server error,...) -> UI hiển thị thông báo lỗi + nút Retry
  error,
}
