import 'package:flutter_test/flutter_test.dart';
import 'package:moneta/main.dart';

void main() {
  testWidgets('LoginPage smoke test', (WidgetTester tester) async {
    
    await tester.pumpWidget(const MyApp());
    await tester.pump();

    
    expect(find.text('Login'), findsWidgets);
    expect(find.text('Nama'), findsWidgets);
    expect(find.text('Password'), findsWidgets);
    expect(find.text('Keluar'), findsOneWidget);
    expect(find.text('Daftar'), findsOneWidget);
  });
}
