import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sales_master/main.dart';

void main() {
  testWidgets('Sales Master app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const SalesMasterApp());

    // Verify that the app starts with Dashboard screen
    expect(find.text('Dashboard'), findsOneWidget);
    
    // Verify bottom navigation exists
    expect(find.text('Customers'), findsOneWidget);
    expect(find.text('Orders'), findsOneWidget);
  });
}
