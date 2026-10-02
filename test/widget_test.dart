import 'package:flutter_test/flutter_test.dart';
import 'package:aquaflow/main.dart';

void main() {
  testWidgets('AquaFlow app loads successfully', (WidgetTester tester) async {
    await tester.pumpWidget(const AquaFlowApp());

    expect(find.text('AquaFlow'), findsOneWidget);
    expect(find.text('GET STARTED'), findsOneWidget);
  });
}