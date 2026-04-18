import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

/// Keeps the **native** splash screen visible until startup work finishes.
///
/// Pair with [FlutterNativeSplash.preserve] in `main()`. Call
/// [FlutterNativeSplash.remove] here after a minimum display time so the OS
/// splash does not disappear before Flutter is ready (avoids a blank/white gap).
class AppStartupGate extends StatefulWidget {
  const AppStartupGate({super.key, required this.child});

  final Widget child;

  /// Ensures the branded splash is visible long enough to read on fast devices.
  static const Duration minimumNativeSplash = Duration(milliseconds: 450);

  @override
  State<AppStartupGate> createState() => _AppStartupGateState();
}

class _AppStartupGateState extends State<AppStartupGate> {
  Timer? _splashTimer;

  @override
  void initState() {
    super.initState();
    _splashTimer = Timer(AppStartupGate.minimumNativeSplash, () {
      if (!mounted) return;
      FlutterNativeSplash.remove();
    });
  }

  @override
  void dispose() {
    _splashTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
