# Ứng dụng Demo MVVM — Đọc dữ liệu từ REST API

Dự án mẫu thực hiện chính xác các yêu cầu:
1. **Cấu trúc chuẩn MVVM**: Tách biệt rõ 4 thư mục: `models/`, `services/`, `viewmodels/`, `views/`.
2. **Xử lý 3 trạng thái giao diện**:
   - **Đang tải (Loading)**: Vòng quay tải trang (`CircularProgressIndicator`).
   - **Báo lỗi & Thử lại (Error & Retry)**: Thông báo lỗi kèm nút **Thử lại**.
   - **Thành công (Success)**: Danh sách bài viết hiển thị trên `ListView`.
3. **Chứng minh View thuần khiết (Decoupled View)**:
   - Tầng View **hoàn toàn không** chứa `http`, `dart:convert`, hay `jsonDecode`.
   - View chỉ quan sát trạng thái `ViewStatus` từ ViewModel thông qua `ListenableBuilder`.

---

## Cấu trúc thư mục

```
lib/
├── models/
│   └── post_model.dart          # Định nghĩa PostModel & parse JSON
├── services/
│   └── post_service.dart        # Đóng gói gọi REST API (http.get & jsonDecode)
├── viewmodels/
│   └── post_view_model.dart     # Quản lý 3 trạng thái (loading, success, error) & ChangeNotifier
├── views/
│   └── post_view.dart           # Giao diện phản hồi 3 trạng thái bằng ListenableBuilder
└── main.dart                    # Điểm khởi chạy ứng dụng
```
