import 'package:flutter_test/flutter_test.dart';
import 'package:smart_bk_care/core/di/injection.dart';
import 'package:smart_bk_care/main.dart';

void main() {
  testWidgets('Smart BK Care App Bootstrap smoke test', (WidgetTester tester) async {
    await initDependencies();
    await tester.pumpWidget(const SmartBkCareApp());
    await tester.pump(const Duration(milliseconds: 500));

    // Verifikasi bahwa aplikasi berhasil dirender dan menampilkan judul
    expect(find.text('SMART BK CARE'), findsWidgets);
  });
}
