# Post Reader Mini — Demo Flutter MVVM & Unidirectional Data Flow (UDF)

Ứng dụng demo chuẩn mực triển khai kiến trúc **MVVM** và **Quản lý trạng thái tách biệt** theo 4 nội dung cốt lõi:

---

## 1. Cấu trúc kiến trúc MVVM
Dự án được phân chia thành các lớp với ranh giới trách nhiệm rõ ràng:

- **Model (`lib/data/models/post_model.dart`)**:
  - Chịu trách nhiệm định nghĩa thực thể dữ liệu `PostModel` (id, userId, title, body).
  - Đóng gói các hàm parse dữ liệu `fromJson` và `toJson`.
  - Hoàn toàn độc lập với Flutter UI Widgets.

- **View (`lib/views/`)**:
  - `post_list_view.dart`: Màn hình danh sách bài viết.
  - `post_detail_view.dart`: Màn hình đọc chi tiết bài viết.
  - `widgets/`: Các widget nhỏ, tái sử dụng (`post_card_widget.dart`, `error_view_widget.dart`).
  - View chỉ có nhiệm vụ vẽ giao diện dựa trên trạng thái (State) và gửi hành động người dùng về ViewModel. Tuyệt đối không chứa logic gọi HTTP hay biến đổi dữ liệu.

- **ViewModel (`lib/viewmodels/post_view_model.dart`)**:
  - Kế thừa `ChangeNotifier`.
  - Quản lý trạng thái giao diện thông qua `ViewState` (`initial`, `loading`, `loaded`, `error`).
  - Tiếp nhận hành động từ View, điều phối tầng Service để lấy dữ liệu, sau đó phát tín hiệu qua `notifyListeners()`.

---

## 2. Luồng dữ liệu một chiều (Unidirectional Data Flow - UDF)

```
[User Action] (Mở màn hình / Kéo làm mới / Bấm Thử lại)
      │
      ▼
[View] (PostListView)
      │ Gọi hàm fetchPosts()
      ▼
[ViewModel] (PostViewModel)
      │ 1. Đổi state = loading & gọi notifyListeners()
      │ 2. Yêu cầu lấy dữ liệu
      ▼
[Network Service] (PostServiceImpl)
      │ Gọi REST API qua HTTP Client
      ▼
[API Server] (JSONPlaceholder)
      │ Trả về JSON String
      ▼
[Model] (PostModel.fromJson)
      │ Parse thành List<PostModel>
      ▼
[ViewModel] (PostViewModel)
      │ Cập nhật state = loaded hoặc error & gọi notifyListeners()
      ▼
[ListenableBuilder in View]
      │ Tự động rebuild UI theo trạng thái mới (Spinner / Danh sách / Lỗi)
      ▼
[Người dùng nhìn thấy giao diện cập nhật]
```

---

## 3. Tách biệt tầng dịch vụ mạng (Network Service)
- **`lib/data/services/post_service.dart`**:
  - Khai báo interface `PostService` và lớp triển khai `PostServiceImpl`.
  - Sử dụng package `http` gọi REST API từ `https://jsonplaceholder.typicode.com/posts`.
  - Tách biệt hoàn toàn, không import `material.dart` hay bất kỳ Widget nào.
  - Xử lý và chuyển đổi các lỗi kỹ thuật (`SocketException`, `TimeoutException`, HTTP Status code) thành các ngoại lệ có ý nghĩa nghiệp vụ (`NetworkException`, `ServerException`).

---

## 4. Cơ chế liên kết View – ViewModel qua `ChangeNotifier` / `ListenableBuilder`
- Không cần cài thêm thư viện bên ngoài, dự án tận dụng cơ chế phản ứng sẵn có trong Flutter SDK:
  - `PostViewModel` kế thừa **`ChangeNotifier`** và gọi `notifyListeners()` mỗi khi trạng thái thay đổi.
  - `PostListView` sử dụng **`ListenableBuilder`** lắng nghe trực tiếp `listenable: _viewModel`.
  - Khi có thông báo thay đổi, `ListenableBuilder` chỉ rebuild phần widget tương ứng với `_viewModel.state` mà không cần gọi `setState()` thủ công.

---

## 5. Hướng dẫn chạy và kiểm thử

### Chạy ứng dụng:
```bash
flutter run
```

### Chạy kiểm thử đơn vị (Unit Test kiểm tra MVVM & UDF):
```bash
flutter test
```
