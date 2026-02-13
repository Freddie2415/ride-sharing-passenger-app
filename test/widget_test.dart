import 'package:flutter_test/flutter_test.dart';
import 'package:passenger/app/app.dart';

void main() {
  testWidgets('App should start', (WidgetTester tester) async {
    await tester.pumpWidget(const PassengerApp());
    await tester.pump();

    // Verify that app starts with splash screen
    expect(find.text('Intercity'), findsOneWidget);
    expect(find.text('Rideshare'), findsOneWidget);
  });
}
