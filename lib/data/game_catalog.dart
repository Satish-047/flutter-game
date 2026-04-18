import 'package:flutter/material.dart';

import '../models/featured_challenge.dart';
import '../models/game_item.dart';

/// Single source of truth for hub order, ids, titles, and tile visuals.
///
/// Edit this list to change which games appear — avoid duplicating titles in widgets.
List<GameItem> buildDefaultGameItems(ColorScheme scheme) {
  return [
    GameItem(
      id: 'quiz',
      title: 'Quiz',
      placeholderIcon: Icons.quiz_rounded,
      tileBackground: scheme.primaryContainer,
    ),
    GameItem(
      id: 'puzzle',
      title: 'Puzzle',
      placeholderIcon: Icons.extension_rounded,
      tileBackground: scheme.surfaceContainerHigh,
      comingSoonSubtitle: 'We\'re crafting something fun.',
    ),
    GameItem(
      id: 'matching_fun',
      title: 'Matching Fun',
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuAuBqKk0yOiWDFcmyUXYULc5jXfG8J5_soZmjTbjTTPf57tkkO5kZdAmp-rKZgNu9FRiTl_lIQHfkx4cFz1yhRpAqt2hU5N8iNEUdtIDFZcWVflYwwK9R47JXENXK6qJeu1DJnyHb5mDkYym92EBCNZSWYwUet9ykVM-p36UYNHWoaAq8k1hsihfMhjonh1xm-LD6VrNM0yQ8Gj3KUH4THVA7taKj_sZEboehPyarx_dV_3ytz7gcsZRV2_iLyUSiG6exfIWZp_I7w',
      tileBackground: scheme.secondaryContainer,
      selected: true,
    ),
    GameItem(
      id: 'dino',
      title: 'Dino Adventure',
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuBTXJKys-OHxFIOOdMTj2L-9g2QQCydKo49CiaXa9fMvenYYUXAVU6Zwo1JWTUaIKO8OeEkqtImK_jAWRoY6cfHEY35drftXZV03I37Yn7OsDBJroDPw-RGuDtHhI2cNgC5waNJ0dcbdsTMzv30V516kO2aC0lZIi7yMUe86z5oAJfkTTi7xjt0TH1VX6N12Yjfmx8WVdmRJT5IshayxtBRq1HTDYL4OFURyauSXUIt17W5AglZMEXnekUso3I_LQyjCjlDNzCN9so',
      tileBackground: scheme.tertiaryContainer,
    ),
  ];
}

const FeaturedChallenge kDefaultFeaturedChallenge = FeaturedChallenge(
  title: 'New Challenge!',
  body: 'Win 500 bonus points in the next Gummy Cloud event.',
  ctaLabel: 'Play Now',
);
