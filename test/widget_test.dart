import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:riendzo_partner/app.dart';
import 'package:riendzo_partner/features/driver/driver_home_screen.dart';

void main() {
  testWidgets('driver can accept an incoming Riendzo trip', (tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    await tester.pumpWidget(
      const RiendzoPartnerApp(home: DriverHomeScreen(useRemoteRequests: false)),
    );

    expect(find.text('Riendzo Partner'), findsOneWidget);
    expect(find.text('Incoming transport request'), findsOneWidget);

    await tester.drag(find.byType(CustomScrollView), const Offset(0, -420));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Accept'));
    await tester.pumpAndSettle();

    expect(find.text('Accepted: head to pickup'), findsOneWidget);
    expect(find.text('Mark arrived at pickup'), findsOneWidget);
  });
}
