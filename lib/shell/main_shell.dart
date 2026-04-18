import 'package:flutter/material.dart';

import '../screens/awards_tab_screen.dart';
import '../screens/games_tab_screen.dart';
import '../screens/settings_tab_screen.dart';
import '../widgets/gummy_bottom_nav.dart';
import '../widgets/gummy_top_bar.dart';

/// Bottom tabs + shared clay header (points + avatar wired via [GummyTopBar]).
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  GummyTab _tab = GummyTab.games;

  String get _title {
    switch (_tab) {
      case GummyTab.games:
        return 'Choose a Game';
      case GummyTab.awards:
        return 'My Awards';
      case GummyTab.settings:
        return 'Settings';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      extendBody: true,
      body: Column(
        children: [
          GummyTopBar(title: _title),
          Expanded(
            child: IndexedStack(
              index: _tab.index,
              children: const [
                GamesTabScreen(),
                AwardsTabScreen(),
                SettingsTabScreen(),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: GummyBottomNav(
        current: _tab,
        onSelect: (t) => setState(() => _tab = t),
      ),
    );
  }
}
