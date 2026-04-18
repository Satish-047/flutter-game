import 'package:flutter/foundation.dart';

import '../models/recent_game_entry.dart';

/// Mock settings / profile prefs — replace with persistence later.
class SettingsController extends ChangeNotifier {
  SettingsController() {
    _recentGames = List<RecentGameEntry>.unmodifiable(_seedRecent);
  }

  String displayName = 'CloudHopper_99';
  String levelSubtitle = 'Level 42 Dreamer';

  bool soundEffects = true;
  bool backgroundMusic = true;
  bool notifications = false;

  late final List<RecentGameEntry> _recentGames;
  List<RecentGameEntry> get recentGames => _recentGames;

  void setSoundEffects(bool v) {
    soundEffects = v;
    notifyListeners();
  }

  void setBackgroundMusic(bool v) {
    backgroundMusic = v;
    notifyListeners();
  }

  void setNotifications(bool v) {
    notifications = v;
    notifyListeners();
  }

  static const _seedRecent = <RecentGameEntry>[
    RecentGameEntry(
      id: 'gummy_pop',
      title: 'Gummy Pop Rush',
      scoreLabel: 'Score: 12,450',
      timeLabel: '2H AGO',
      thumbnailUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuAFSFXBUODD7HLagQPz5kk5lq-twSLn9IIT5GfcrQZRS0fylkA7cE5uCbfBCTnyHaxdL_7gkp7VCsAuRve4cVfpR5L4V-x7yzNU8PCD-IlzqPkJj5vNpTsCa9xBPve7OZnkgEAWEQli7OhL-WFd4YNik1Cn1leDHRSCFhhwisem6TM7-d_tkaGiZ73oLRQnOJSDb_UzWTXZFoQ1-3JwH6Qa2Q6-tE3bQ6awTf9lVolqw1xYqhtWKQE-V-jYYixRQyzvvRu6-IMFCoc',
      newBest: true,
    ),
    RecentGameEntry(
      id: 'cloud_jumper',
      title: 'Cloud Jumper Pro',
      scoreLabel: 'Score: 8,200',
      timeLabel: 'YESTERDAY',
      thumbnailUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuAjU63hyHZ8jPsHxnfA1GpKZOxq3XN2GiKv_3R_ltON9OMno07bYcrMOVwmv8_eEcmLUByGloE8PavmOpLRhFJmKPGEv3bouEqdlPp_S4razco_WTohRe0y8hc7P3ezpuKIfvyLB6wxCYN7nk8OPVjz_ZiS2LH4zLASeVWXT5hoKzi1E6enDLM4oTG9LoD5juhljvyFj7iqtC8WrDi5aSFyIALDCc-NMXESpnFjH0yyY4Hf3EfDbQ5gNln5Q5wBOy1X_t9omRdHESc',
    ),
  ];
}
