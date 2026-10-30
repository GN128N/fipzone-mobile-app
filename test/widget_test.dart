import 'package:flutter_test/flutter_test.dart';
import 'package:fipzonee_mobile/main.dart';

void main() {
  testWidgets('opens the FIP Zone E onboarding flow', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const FipApp());
    await tester.pump(const Duration(seconds: 2));
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('Global Polo\nCommunity'), findsOneWidget);
    expect(find.text('Get started  →'), findsNothing);
  });
}
