import 'package:flutter/material.dart';

import 'gummy_layout.dart';

/// Soft outer + inner “clay” depth (approximation of CSS clay-card / inset feel).
abstract final class ClayShadows {
  /// Floating card — ambient shadow tinted (not grey), per design doc.
  static List<BoxShadow> ambient(Color tint, {double y = 12}) {
    return [
      BoxShadow(
        color: tint.withValues(alpha: 0.08),
        blurRadius: 40,
        offset: Offset(0, y),
      ),
    ];
  }

  /// Inset “squish” using a top highlight + bottom shade.
  static BoxDecoration insetWell({
    required Color surface,
    BorderRadius? radius,
  }) {
    return BoxDecoration(
      color: surface,
      borderRadius: radius ?? BorderRadius.circular(GummyLayout.clayRadiusLg),
      boxShadow: [
        BoxShadow(
          color: Colors.white.withValues(alpha: 0.45),
          offset: const Offset(4, 4),
          blurRadius: 8,
          spreadRadius: -2,
        ),
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.08),
          offset: const Offset(-5, -5),
          blurRadius: 10,
          spreadRadius: -2,
        ),
      ],
    );
  }
}
