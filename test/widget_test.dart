import 'package:flutter_test/flutter_test.dart';
import 'package:demotuan2/main.dart';

void main() {
  testWidgets('Khởi chạy ứng dụng và hiển thị thanh tiêu đề Post Reader Mini', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Kiểm tra AppBar xuất hiện
    expect(find.text('Post Reader Mini (MVVM)'), findsOneWidget);
  });
}
