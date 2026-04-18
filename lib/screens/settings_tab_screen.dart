import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/recent_game_entry.dart';
import '../state/settings_controller.dart';
import '../theme/clay_shadows.dart';
import '../theme/gummy_layout.dart';
import '../widgets/dashed_rounded_border.dart';

/// Settings tab body only — shell header + bottom nav live in [MainShell].
class SettingsTabScreen extends StatelessWidget {
  const SettingsTabScreen({super.key});

  static const _avatarUrl =
      'https://lh3.googleusercontent.com/aida-public/AB6AXuBM7yGD-bUfWcUNFiLmGrHMm5CnSmN-Gj7NGF78MFUvCWRXqG6M-1gVbrbVRLF_L0t6LNOUaoDKV-qxdNczgB1AcjFM-jHBaCYzhK7pEbKB5skvtBFCyuAD3rE-1rIGFpmqqR82AYZTaPW5SLMzLLN6lXk07Psq7JzuZXvIyJMyWRN8qazZ9B7BkIylPlNH030y9Sen7aYuQGt_iGeGNZeX10ZrSuLrSh_uBen0Lq69xOhktIK0SUz_5NG_1c9T7zKIZCZh51lq-Vw';

  void _snack(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        GummyLayout.pagePaddingH,
        GummyLayout.blockGap,
        GummyLayout.pagePaddingH,
        120,
      ),
      child: Consumer<SettingsController>(
        builder: (context, settings, _) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _ProfileBentoCard(
                avatarUrl: _avatarUrl,
                displayName: settings.displayName,
                levelSubtitle: settings.levelSubtitle,
                onChangeName: () => _snack(context, 'Change name — coming soon'),
                onStyleAvatar: () => _snack(context, 'Style avatar — coming soon'),
                onEditAvatar: () => _snack(context, 'Edit avatar — coming soon'),
              ),
              const SizedBox(height: GummyLayout.sectionGap),
              _GameVibesSection(
                soundOn: settings.soundEffects,
                musicOn: settings.backgroundMusic,
                notifyOn: settings.notifications,
                onSound: settings.setSoundEffects,
                onMusic: settings.setBackgroundMusic,
                onNotify: settings.setNotifications,
              ),
              const SizedBox(height: GummyLayout.sectionGap),
              _RecentGamesSection(entries: settings.recentGames),
              const SizedBox(height: GummyLayout.sectionGap),
              _DangerLogout(
                onLogout: () => _showLogoutConfirm(context),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _showLogoutConfirm(BuildContext context) async {
    final scheme = Theme.of(context).colorScheme;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(GummyLayout.clayRadiusMd),
        ),
        title: Text(
          'Log out?',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        content: Text(
          'You can sign in again anytime.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(
              backgroundColor: scheme.error,
              foregroundColor: scheme.onError,
            ),
            child: const Text('Log out'),
          ),
        ],
      ),
    );
    if (ok == true && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Logged out (demo — no auth)'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}

class _ProfileBentoCard extends StatelessWidget {
  const _ProfileBentoCard({
    required this.avatarUrl,
    required this.displayName,
    required this.levelSubtitle,
    required this.onChangeName,
    required this.onStyleAvatar,
    required this.onEditAvatar,
  });

  final String avatarUrl;
  final String displayName;
  final String levelSubtitle;
  final VoidCallback onChangeName;
  final VoidCallback onStyleAvatar;
  final VoidCallback onEditAvatar;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Transform.rotate(
      angle: 0.017,
      child: Container(
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: scheme.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(GummyLayout.clayRadiusMd),
          boxShadow: [
            ...ClayShadows.ambient(scheme.secondary, y: 12),
            BoxShadow(
              color: Colors.white.withValues(alpha: 0.5),
              offset: const Offset(4, 4),
              blurRadius: 6,
            ),
            BoxShadow(
              color: scheme.secondary.withValues(alpha: 0.05),
              offset: const Offset(-6, -6),
              blurRadius: 10,
            ),
          ],
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final wide = constraints.maxWidth > 420;
            final avatar = _AvatarStack(
              imageUrl: avatarUrl,
              onEdit: onEditAvatar,
            );
            final textBlock = Column(
              crossAxisAlignment:
                  wide ? CrossAxisAlignment.start : CrossAxisAlignment.center,
              children: [
                Text(
                  displayName,
                  textAlign: wide ? TextAlign.start : TextAlign.center,
                  style: textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  levelSubtitle,
                  textAlign: wide ? TextAlign.start : TextAlign.center,
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: scheme.secondary,
                  ),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  alignment: wide ? WrapAlignment.start : WrapAlignment.center,
                  children: [
                    FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: scheme.primaryContainer,
                        foregroundColor: scheme.onPrimaryContainer,
                      ),
                      onPressed: onChangeName,
                      child: const Text('Change Name'),
                    ),
                    FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: scheme.secondaryContainer,
                        foregroundColor: scheme.onSecondaryContainer,
                      ),
                      onPressed: onStyleAvatar,
                      child: const Text('Style Avatar'),
                    ),
                  ],
                ),
              ],
            );

            if (wide) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  avatar,
                  const SizedBox(width: 28),
                  Expanded(child: textBlock),
                ],
              );
            }
            return Column(
              children: [
                avatar,
                const SizedBox(height: 20),
                textBlock,
              ],
            );
          },
        ),
      ),
    );
  }
}

class _AvatarStack extends StatelessWidget {
  const _AvatarStack({
    required this.imageUrl,
    required this.onEdit,
  });

  final String imageUrl;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 128,
          height: 128,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: scheme.primaryContainer,
            boxShadow: [
              BoxShadow(
                color: Colors.white.withValues(alpha: 0.5),
                offset: const Offset(4, 4),
                blurRadius: 6,
              ),
              BoxShadow(
                color: scheme.primary.withValues(alpha: 0.12),
                offset: const Offset(-6, -6),
                blurRadius: 8,
              ),
            ],
          ),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.5),
                width: 6,
              ),
            ),
            child: ClipOval(
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => ColoredBox(
                  color: scheme.secondaryContainer,
                  child: Icon(
                    Icons.pets_rounded,
                    size: 56,
                    color: scheme.onSecondaryContainer,
                  ),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          right: -4,
          bottom: -4,
          child: Material(
            color: scheme.tertiary,
            shape: const CircleBorder(),
            elevation: 4,
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: onEdit,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Icon(Icons.edit_rounded, color: scheme.onTertiary, size: 22),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _GameVibesSection extends StatelessWidget {
  const _GameVibesSection({
    required this.soundOn,
    required this.musicOn,
    required this.notifyOn,
    required this.onSound,
    required this.onMusic,
    required this.onNotify,
  });

  final bool soundOn;
  final bool musicOn;
  final bool notifyOn;
  final ValueChanged<bool> onSound;
  final ValueChanged<bool> onMusic;
  final ValueChanged<bool> onNotify;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.tune_rounded, color: scheme.primary, size: 26),
            const SizedBox(width: 8),
            Text(
              'Game Vibes',
              style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _VibeToggleCard(
          icon: Icons.volume_up_rounded,
          iconBg: scheme.secondaryContainer,
          iconFg: scheme.secondary,
          title: 'Sound Effects',
          subtitle: 'Boings and Pops!',
          value: soundOn,
          onChanged: onSound,
        ),
        const SizedBox(height: 16),
        _VibeToggleCard(
          icon: Icons.music_note_rounded,
          iconBg: scheme.tertiaryContainer,
          iconFg: scheme.tertiary,
          title: 'Background Music',
          subtitle: 'Happy gummy tunes',
          value: musicOn,
          onChanged: onMusic,
        ),
        const SizedBox(height: 16),
        _VibeToggleCard(
          icon: Icons.notifications_rounded,
          iconBg: scheme.surfaceContainerHigh,
          iconFg: scheme.onSurfaceVariant,
          title: 'Notifications',
          subtitle: 'Friend invites & gifts',
          value: notifyOn,
          onChanged: onNotify,
        ),
      ],
    );
  }
}

class _VibeToggleCard extends StatelessWidget {
  const _VibeToggleCard({
    required this.icon,
    required this.iconBg,
    required this.iconFg,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final IconData icon;
  final Color iconBg;
  final Color iconFg;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(GummyLayout.clayRadiusMd),
        boxShadow: ClayShadows.ambient(scheme.secondary, y: 8),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: iconBg,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconFg, size: 26),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                ),
                Text(
                  subtitle,
                  style: textTheme.bodySmall?.copyWith(
                    color: scheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

class _RecentGamesSection extends StatelessWidget {
  const _RecentGamesSection({required this.entries});

  final List<RecentGameEntry> entries;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.history_rounded, color: scheme.tertiary, size: 26),
            const SizedBox(width: 8),
            Text(
              'Recent Games',
              style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ...entries.asMap().entries.map((e) {
          final i = e.key;
          final row = e.value;
          final tilt = i.isEven ? -0.017 : 0.017;
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Transform.rotate(
              angle: tilt,
              child: _RecentRow(entry: row),
            ),
          );
        }),
      ],
    );
  }
}

class _RecentRow extends StatelessWidget {
  const _RecentRow({required this.entry});

  final RecentGameEntry entry;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: scheme.surfaceContainer,
        borderRadius: BorderRadius.circular(GummyLayout.clayRadiusMd),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            offset: const Offset(4, 4),
            blurRadius: 8,
          ),
          BoxShadow(
            color: Colors.white.withValues(alpha: 0.8),
            offset: const Offset(-4, -4),
            blurRadius: 8,
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              width: 64,
              height: 64,
              child: Image.network(
                entry.thumbnailUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => ColoredBox(
                  color: scheme.surfaceContainerHighest,
                  child: Icon(Icons.videogame_asset_rounded, color: scheme.secondary),
                ),
              ),
            ),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.title,
                  style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 4),
                Text(
                  entry.scoreLabel,
                  style: textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: scheme.secondary,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                entry.timeLabel,
                style: textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: scheme.onSurfaceVariant,
                  letterSpacing: 0.5,
                ),
              ),
              if (entry.newBest) ...[
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: scheme.primaryContainer,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    'NEW BEST!',
                    style: textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.w900,
                      fontSize: 10,
                      color: scheme.onPrimaryContainer,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _DangerLogout extends StatelessWidget {
  const _DangerLogout({required this.onLogout});

  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return DashedRoundedBorder(
      color: scheme.error.withValues(alpha: 0.35),
      strokeWidth: 2,
      radius: GummyLayout.clayRadiusMd,
      dashLength: 8,
      gapLength: 6,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onLogout,
          borderRadius: BorderRadius.circular(GummyLayout.clayRadiusMd),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.logout_rounded, color: scheme.error),
                const SizedBox(width: 10),
                Text(
                  'Logout from Gummy Cloud',
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: scheme.error,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

