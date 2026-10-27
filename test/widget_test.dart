import 'package:flutter_test/flutter_test.dart';
import 'package:demotuan2/main.dart';

void main() {
  testWidgets('Khởi chạy ứng dụng và hiển thị thanh tiêu đề Demo MVVM', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.text('Demo MVVM - REST API'), findsOneWidget);
  });
}
