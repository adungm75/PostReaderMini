# Demo Kiến Trúc Flutter MVVM — Đọc Dữ Liệu Từ REST API

Ứng dụng demo triển khai chuẩn mực mô hình kiến trúc **MVVM (Model - View - ViewModel)** và **Luồng dữ liệu một chiều (Unidirectional Data Flow)** trong Flutter:
- **Tách biệt 4 thư mục rõ ràng**: `models/`, `services/`, `viewmodels/`, `views/`.
- **Phản hồi trực quan 3 trạng thái giao diện**: Đang tải (**Loading**), Thành công (**Success**) và Báo lỗi kèm nút Thử lại (**Error & Retry**).
- **Decoupled View**: Tầng View độc lập hoàn toàn, không chứa code gọi HTTP hay giải mã JSON thô; View chỉ lắng nghe trạng thái từ ViewModel thông qua `ListenableBuilder`.

---

## 1. Công Nghệ Sử Dụng

| Thành phần | Công nghệ / Thư viện | Vai trò |
| :--- | :--- | :--- |
| **Framework** | **Flutter SDK** (3.10+ / 3.x) | Xây dựng giao diện ứng dụng đa nền tảng |
| **Ngôn ngữ** | **Dart** (3.x) | Ngôn ngữ lập trình chính, hỗ trợ Null-safety |
| **Kiến trúc** | **MVVM** (Model - View - ViewModel) | Phân tách ranh giới dữ liệu, logic và giao diện |
| **Quản lý trạng thái** | **ChangeNotifier & ListenableBuilder** | Cơ chế phản ứng (Reactive) tích hợp sẵn trong Flutter SDK, không phụ thuộc thư viện bên ngoài |
| **Kết nối mạng (HTTP)** | **package:http (^1.x)** | Đóng gói tác vụ gửi yêu cầu REST API (`GET`) |
| **REST API Mock** | **JSONPlaceholder** | Nguồn dữ liệu giả lập chuẩn RESTful (`/posts`) |
| **Kiểm thử (Testing)** | **flutter_test** | Kiểm thử đơn vị (Unit Test) cho ViewModel và 3 trạng thái |

---

## 2. Yêu Cầu Hệ Thống

Để cài đặt và khởi chạy dự án, máy tính cần đáp ứng các yêu cầu sau:

- **Hệ điều hành**: Windows 10/11 (64-bit), macOS hoặc Linux.
- **Flutter SDK**: Phiên bản `>= 3.10.0` (khuyến nghị phiên bản Flutter Stable mới nhất).
- **Dart SDK**: Phiên bản `>= 3.0.0` (đi kèm sẵn trong Flutter SDK).
- **Môi trường phát triển (IDE)**:
  - Visual Studio Code (kèm Flutter & Dart extensions), hoặc
  - Android Studio / IntelliJ IDEA (kèm Flutter plugin).
- **Thiết bị chạy (Target Device)**:
  - Thiết bị Android/iOS thật (bật USB Debugging), hoặc
  - Trình giả lập (Android Emulator / iOS Simulator), hoặc
  - Trình duyệt Chrome / Ứng dụng Desktop Windows (hỗ trợ Flutter Desktop).

---

## 3. Hướng Dẫn Cài Đặt

### Bước 1: Mở thư mục dự án
Mở terminal (PowerShell, Command Prompt hoặc Terminal trong VS Code) và di chuyển vào thư mục dự án:
```bash
cd "D:\LuuCode\Dart\Tuan2\demotuan2"
```

### Bước 2: Kiểm tra môi trường Flutter
Kiểm tra đảm bảo Flutter SDK đã được cấu hình chính xác trên máy tính:
```bash
flutter doctor
```

### Bước 3: Cài đặt các gói phụ thuộc (Dependencies)
Tải các package cần thiết được khai báo trong `pubspec.yaml` (bao gồm `http`):
```bash
flutter pub get
```

---

## 4. Hướng Dẫn Cấu Hình Biến Môi Trường

Mặc định, ứng dụng đã được cấu hình trỏ thẳng tới REST API công khai của **JSONPlaceholder** (`https://jsonplaceholder.typicode.com/posts`) nên **có thể chạy ngay lập tức mà không bắt buộc phải cấu hình thêm**.

Nếu muốn tùy biến cấu hình URL của API Server theo từng môi trường (Development, Staging, Production), có thể thực hiện theo các cách sau:

### Cách 1: Sử dụng `--dart-define` khi chạy dòng lệnh (Khuyến nghị của Flutter)
Flutter hỗ trợ truyền biến môi trường trực tiếp lúc biên dịch thông qua cờ `--dart-define`:
```bash
# Chạy với URL API tùy chỉnh
flutter run --dart-define=API_URL=https://jsonplaceholder.typicode.com/posts
```

Khi đó trong mã nguồn ([`lib/services/post_service.dart`](lib/services/post_service.dart)), biến môi trường được đọc linh hoạt:
```dart
static const String _url = String.fromEnvironment(
  'API_URL',
  defaultValue: 'https://jsonplaceholder.typicode.com/posts',
);
```

### Cách 2: Cấu hình Launch Configuration trong VS Code
Nếu dùng Visual Studio Code, tạo hoặc chỉnh sửa file `.vscode/launch.json`:
```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "demotuan2 (Dev)",
      "request": "launch",
      "type": "dart",
      "args": [
        "--dart-define",
        "API_URL=https://jsonplaceholder.typicode.com/posts"
      ]
    }
  ]
}
```

---

## 5. Hướng Dẫn Khởi Chạy

### 5.1. Khởi chạy ứng dụng
1. Kiểm tra danh sách thiết bị đang kết nối:
   ```bash
   flutter devices
   ```

2. Khởi chạy ứng dụng trên thiết bị mặc định:
   ```bash
   flutter run
   ```

3. Khởi chạy trực tiếp trên trình duyệt Web (Chrome) hoặc Windows Desktop:
   ```bash
   # Chạy trên Google Chrome
   flutter run -d chrome

   # Chạy dạng ứng dụng Windows
   flutter run -d windows
   ```

---

## 6. Kiểm Thử & Kiểm Tra Chất Lượng Mã Nguồn

### 6.1. Kiểm tra tĩnh (Static Code Analysis)
Đảm bảo mã nguồn tuân thủ tiêu chuẩn code sạch (clean code) và không có cảnh báo:
```bash
flutter analyze
```

### 6.2. Chạy Kiểm Thử Đơn Vị (Unit Test)
Chạy bộ kiểm thử tự động kiểm chứng 3 trạng thái của ViewModel (`loading`, `success`, `error`):
```bash
flutter test
```

---

## 7. Cấu Trúc Mã Nguồn (MVVM)

```
lib/
├── models/
│   └── post_model.dart          # Định nghĩa cấu trúc dữ liệu & chuyển đổi từ JSON
├── services/
│   └── post_service.dart        # Đóng gói gọi REST API (http.get) & giải mã JSON thô
├── viewmodels/
│   └── post_view_model.dart     # Quản lý 3 trạng thái (loading, success, error) & ChangeNotifier
├── views/
│   └── post_view.dart           # Lắng nghe ViewModel qua ListenableBuilder để vẽ giao diện
└── main.dart                    # Khởi tạo MaterialApp và cấu hình Theme
```
