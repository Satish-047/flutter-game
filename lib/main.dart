import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';

import 'app_startup_gate.dart';
import 'shell/main_shell.dart';
import 'state/awards_catalog.dart';
import 'state/player_profile.dart';
import 'state/settings_controller.dart';
import 'theme/app_theme.dart';

void main() {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PlayerProfile()),
        ChangeNotifierProvider(create: (_) => SettingsController()),
        ChangeNotifierProvider(create: (_) => AwardsCatalog()),
      ],
      child: const GummyCloudApp(),
    ),
  );
}

class GummyCloudApp extends StatelessWidget {
  const GummyCloudApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gummy Cloud',
      debugShowCheckedModeBanner: false,
      theme: buildGummyCloudTheme(brightness: Brightness.light),
      darkTheme: buildGummyCloudTheme(brightness: Brightness.dark),
      themeMode: ThemeMode.light,
      home: const AppStartupGate(
        child: MainShell(),
      ),
    );
  }
}
