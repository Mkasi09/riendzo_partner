import 'package:flutter_test/flutter_test.dart';
import 'package:riendzo_partner/main.dart';

void main() {
  testWidgets('sign in opens driver dashboard', (t) async {
    await t.pumpWidget(const RiendzoApp(firebaseEnabled: false));
    expect(find.text('Welcome back.'), findsOneWidget);
    await t.tap(find.text('Sign in'));
    await t.pump(const Duration(milliseconds: 500));
    expect(find.text('Good afternoon,'), findsOneWidget);
    expect(find.text('View trip requests'), findsOneWidget);
  });

  testWidgets('profile actions open their destination screens', (t) async {
    await t.pumpWidget(const RiendzoApp(firebaseEnabled: false));
    await t.tap(find.text('Sign in'));
    await t.pump(const Duration(milliseconds: 500));
    await t.tap(find.text('Profile'));
    await t.pumpAndSettle();
    await t.tap(find.text('Documents'));
    await t.pumpAndSettle();
    expect(find.text('Driver’s licence'), findsOneWidget);
    expect(find.text('Upload a document'), findsOneWidget);
  });
}
