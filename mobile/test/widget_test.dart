import 'package:flutter_test/flutter_test.dart';
import 'package:fashionhub_mobile/main.dart';

void main() {
  testWidgets('FashionHub app can be created', (WidgetTester tester) async {
    await tester.pumpWidget(const FashionHubApp());
    await tester.pump();

    expect(find.byType(FashionHubApp), findsOneWidget);
  });
}