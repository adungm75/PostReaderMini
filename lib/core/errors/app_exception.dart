/// Lớp ngoại lệ cơ sở cho toàn ứng dụng
class AppException implements Exception {
  final String message;
  final String? prefix;

  AppException(this.message, [this.prefix]);

  @override
  String toString() {
    return prefix != null ? '$prefix: $message' : message;
  }
}

/// Ngoại lệ mất kết nối internet hoặc không thể kết nối tới máy chủ
class NetworkException extends AppException {
  NetworkException([String message = 'Không thể kết nối Internet. Vui lòng kiểm tra lại mạng.'])
      : super(message, 'Lỗi mạng');
}

/// Ngoại lệ phản hồi lỗi từ server (4xx, 5xx)
class ServerException extends AppException {
  final int? statusCode;

  ServerException([String message = 'Máy chủ phản hồi lỗi', this.statusCode])
      : super(message, 'Lỗi máy chủ ($statusCode)');
}

/// Ngoại lệ hết thời gian chờ yêu cầu
class TimeoutExceptionCustom extends AppException {
  TimeoutExceptionCustom([String message = 'Quá thời gian kết nối đến máy chủ.'])
      : super(message, 'Timeout');
}
