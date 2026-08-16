import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:habotconnect_lsa_verification/app/modules/lsa_profile_verification/bindings/lsa_profile_verification_binding.dart';
import 'package:habotconnect_lsa_verification/app/modules/lsa_profile_verification/views/lsa_profile_verification_view.dart';
import 'package:habotconnect_lsa_verification/app/theme/app_theme.dart';

void main() {
  setUp(() {
    Get.testMode = true;
    LSAProfileVerificationBinding(useMockBackend: true).dependencies();
  });

  tearDown(Get.reset);

  testWidgets('renders all primary form fields and the submit button', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      GetMaterialApp(
        theme: AppTheme.light,
        home: const LSAProfileVerificationView(),
      ),
    );

    expect(find.text('LSA Profile Verification'), findsOneWidget);
    expect(find.text('Full Name *'), findsOneWidget);
    expect(find.text('Email *'), findsOneWidget);
    expect(find.text('Predecessor ID *'), findsOneWidget);
    expect(find.text('Submit for Verification'), findsOneWidget);
  });

  testWidgets('submitting an empty form shows validation errors, not a '
      'network call', (WidgetTester tester) async {
    await tester.pumpWidget(
      GetMaterialApp(
        theme: AppTheme.light,
        home: const LSAProfileVerificationView(),
      ),
    );

    await tester.tap(find.text('Submit for Verification'));
    await tester.pumpAndSettle();

    expect(find.text('Full Name is required'), findsOneWidget);
  });
}
