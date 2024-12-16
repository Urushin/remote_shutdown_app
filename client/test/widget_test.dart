import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remote_shutdown_app/main.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

// Générez les mocks avec : flutter pub run build_runner build
@GenerateNiceMocks([MockSpec<http.Client>()])
import 'widget_test.mocks.dart';

void main() {
  testWidgets('Affiche les boutons et les messages correctement', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const RemoteShutdownApp());

    // Vérifie que les éléments principaux sont présents.
    expect(find.text("Contrôle d'Arrêt PC"), findsOneWidget);
    expect(find.text("Éteindre Maintenant"), findsOneWidget);
    expect(find.text("Éteindre dans 10 Minutes"), findsOneWidget);

    // Vérifie que les boutons sont cliquables sans erreur.
    final buttonShutdownNow = find.text("Éteindre Maintenant");
    final buttonShutdownDelay = find.text("Éteindre dans 10 Minutes");

    // Simuler un tap sur "Éteindre Maintenant".
    await tester.tap(buttonShutdownNow);
    await tester.pumpAndSettle();

    // Simuler un tap sur "Éteindre dans 10 Minutes".
    await tester.tap(buttonShutdownDelay);
    await tester.pumpAndSettle();
  });
}