import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:gummy_cloud/main.dart';
import 'package:gummy_cloud/screens/awards_tab_screen.dart';
import 'package:gummy_cloud/state/awards_catalog.dart';
import 'package:gummy_cloud/state/player_profile.dart';
import 'package:gummy_cloud/state/settings_controller.dart';
import 'package:gummy_cloud/widgets/gummy_bottom_nav.dart';

Future<void> pumpPastNativeSplash(WidgetTester tester) async {
  await tester.pump(const Duration(milliseconds: 500));
  await tester.pumpAndSettle();
}

Widget pumpApp({int initialPoints = 1250}) {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (_) => PlayerProfile(initialPoints: initialPoints),
      ),
      ChangeNotifierProvider(create: (_) => SettingsController()),
      ChangeNotifierProvider(create: (_) => AwardsCatalog()),
    ],
    child: const GummyCloudApp(),
  );
}

void main() {
  testWidgets('games tab shows hub copy and grid', (tester) async {
    await tester.pumpWidget(pumpApp(initialPoints: 1250));
    await pumpPastNativeSplash(tester);

    expect(find.text('Choose a Game'), findsOneWidget);
    expect(find.text('Which adventure will you join today?'), findsOneWidget);
    expect(find.text('Quiz'), findsOneWidget);
    expect(find.text('Puzzle'), findsOneWidget);
    expect(find.text('Matching Fun'), findsOneWidget);
    expect(find.text('Dino Adventure'), findsOneWidget);
    expect(find.text('1,250 pts'), findsOneWidget);
  });

  testWidgets('navigation: Awards tab shows progress and grid', (tester) async {
    await tester.pumpWidget(pumpApp());
    await pumpPastNativeSplash(tester);

    await tester.tap(find.text('Awards'));
    await tester.pumpAndSettle();

    expect(find.text('My Awards'), findsOneWidget);
    expect(find.text('Super Collector!'), findsOneWidget);
    expect(find.textContaining('unlocked 3 out of 10'), findsOneWidget);
    expect(find.text('30%'), findsOneWidget);
    expect(find.text('Star Matcher'), findsOneWidget);

    final awardsScroll = find.descendant(
      of: find.byType(AwardsTabScreen),
      matching: find.byType(CustomScrollView),
    );
    await tester.dragUntilVisible(
      find.text('Moon Explorer'),
      awardsScroll,
      const Offset(0, -80),
    );
    await tester.pumpAndSettle();
    expect(find.text('Moon Explorer'), findsOneWidget);

    await tester.dragUntilVisible(
      find.text('Grand Champion'),
      awardsScroll,
      const Offset(0, -80),
    );
    await tester.pumpAndSettle();
    expect(find.text('Grand Champion'), findsOneWidget);
  });

  testWidgets('points pill tap updates header on all tabs', (tester) async {
    await tester.pumpWidget(pumpApp(initialPoints: 100));
    await pumpPastNativeSplash(tester);

    expect(find.text('100 pts'), findsOneWidget);

    await tester.tap(find.text('100 pts'));
    await tester.pumpAndSettle();

    expect(find.text('110 pts'), findsOneWidget);

    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();

    expect(find.text('110 pts'), findsOneWidget);
  });

  testWidgets('settings tab shows profile and game vibes', (tester) async {
    await tester.pumpWidget(pumpApp());
    await pumpPastNativeSplash(tester);

    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();

    expect(find.text('Settings'), findsWidgets);
    expect(find.text('CloudHopper_99'), findsOneWidget);
    expect(find.text('Game Vibes'), findsOneWidget);
    expect(find.text('Sound Effects'), findsOneWidget);
    expect(find.text('Recent Games'), findsOneWidget);
    expect(find.text('Logout from Gummy Cloud'), findsOneWidget);
  });

  testWidgets('tap Puzzle shows coming soon with subtitle', (tester) async {
    await tester.pumpWidget(pumpApp());
    await pumpPastNativeSplash(tester);

    final puzzleTile = find.text('Puzzle');
    await tester.ensureVisible(puzzleTile);
    await tester.pumpAndSettle();
    await tester.tap(puzzleTile);
    await tester.pumpAndSettle();

    expect(find.text('Puzzle — coming soon'), findsOneWidget);
    expect(find.text('We\'re crafting something fun.'), findsOneWidget);
    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();

    expect(find.byType(GummyBottomNav), findsOneWidget);
  });

  testWidgets('tap Quiz opens timed quiz intro', (tester) async {
    await tester.pumpWidget(pumpApp());
    await pumpPastNativeSplash(tester);

    final quizTile = find.text('Quiz');
    await tester.ensureVisible(quizTile);
    await tester.pumpAndSettle();
    await tester.tap(quizTile);
    await tester.pumpAndSettle();

    expect(find.text('Your topic today'), findsOneWidget);
    expect(find.textContaining('questions · timed'), findsOneWidget);
    expect(find.text('Start'), findsOneWidget);
  });

  testWidgets('tap Matching Fun opens coming soon screen', (tester) async {
    await tester.pumpWidget(pumpApp());
    await pumpPastNativeSplash(tester);

    final matching = find.text('Matching Fun');
    await tester.ensureVisible(matching);
    await tester.pumpAndSettle();
    await tester.tap(matching);
    await tester.pumpAndSettle();

    expect(find.text('Matching Fun — coming soon'), findsOneWidget);
    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();

    expect(find.byType(GummyBottomNav), findsOneWidget);
  });
}
