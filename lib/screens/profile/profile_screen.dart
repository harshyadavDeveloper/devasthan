import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/app_provider.dart';
import '../../providers/streak_provider.dart';
import '../../providers/alarm_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appProvider    = context.watch<AppProvider>();
    final streakProvider = context.watch<StreakProvider>();
    final alarmProvider  = context.watch<AlarmProvider>();
    final theme          = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Profile & Settings')),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [

                // ── Avatar ────────────────────────────────────
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 90, height: 90,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [AppColors.saffron, AppColors.gold],
                          ),
                          shape: BoxShape.circle,
                          boxShadow: [BoxShadow(color: AppColors.saffron.withOpacity(0.3), blurRadius: 16)],
                        ),
                        child: const Center(child: Text('🙏', style: TextStyle(fontSize: 40))),
                      ),
                      const SizedBox(height: 12),
                      Text('Devotee', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700)),
                      const SizedBox(height: 4),
                      Text('Your personal sacred space', style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey)),
                    ],
                  ),
                ),
                const SizedBox(height: 28),

                // ── Streak ────────────────────────────────────
                _SectionLabel('My Practice'),
                Card(
                  child: ListTile(
                    leading: const Text('🔥', style: TextStyle(fontSize: 26)),
                    title: const Text('Current Streak', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600)),
                    trailing: Text(
                      '${streakProvider.streak} days',
                      style: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w700, color: AppColors.saffron, fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                // ── Alarm ─────────────────────────────────────
                Card(
                  child: Column(
                    children: [
                      SwitchListTile(
                        secondary: const Text('⏰', style: TextStyle(fontSize: 26)),
                        title: const Text('Daily Aarti Alarm', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600)),
                        subtitle: Text(
                          alarmProvider.enabled ? 'Rings at ${alarmProvider.timeLabel}' : 'Tap to enable',
                          style: const TextStyle(fontFamily: 'Poppins'),
                        ),
                        value: alarmProvider.enabled,
                        activeColor: AppColors.saffron,
                        onChanged: alarmProvider.toggleAlarm,
                      ),
                      if (alarmProvider.enabled) ...[
                        const Divider(height: 0),
                        ListTile(
                          leading: const SizedBox(width: 26),
                          title: const Text('Change Time', style: TextStyle(fontFamily: 'Poppins')),
                          trailing: Text(
                            alarmProvider.timeLabel,
                            style: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600, color: AppColors.saffron),
                          ),
                          onTap: () async {
                            final picked = await showTimePicker(
                              context: context,
                              initialTime: alarmProvider.time,
                            );
                            if (picked != null) alarmProvider.setTime(picked);
                          },
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // ── Theme ─────────────────────────────────────
                _SectionLabel('Appearance'),
                Card(
                  child: SwitchListTile(
                    secondary: const Text('🌙', style: TextStyle(fontSize: 26)),
                    title: const Text('Temple Night Mode', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600)),
                    subtitle: const Text('Dark saffron theme', style: TextStyle(fontFamily: 'Poppins')),
                    value: appProvider.isDark,
                    activeColor: AppColors.saffron,
                    onChanged: (_) => appProvider.toggleTheme(),
                  ),
                ),
                const SizedBox(height: 24),

                // ── About ─────────────────────────────────────
                _SectionLabel('About'),
                Card(
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Text('🛕', style: TextStyle(fontSize: 26)),
                        title: const Text('Devasthan', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600)),
                        subtitle: const Text('Version 1.0.0', style: TextStyle(fontFamily: 'Poppins')),
                      ),
                      const Divider(height: 0),
                      ListTile(
                        leading: const Text('📖', style: TextStyle(fontSize: 26)),
                        title: const Text('Privacy Policy', style: TextStyle(fontFamily: 'Poppins')),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {},
                      ),
                      const Divider(height: 0),
                      ListTile(
                        leading: const Text('⭐', style: TextStyle(fontSize: 26)),
                        title: const Text('Rate on Play Store', style: TextStyle(fontFamily: 'Poppins')),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),

          // ── Ad Banner ──────────────────────────────────────
          _AdBanner(),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        text.toUpperCase(),
        style: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: AppColors.saffron,
          letterSpacing: 1.5,
        ),
      ),
    );
  }
}

class _AdBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 52,
      color: Colors.grey.shade200,
      child: const Center(
        child: Text('AD BANNER', style: TextStyle(fontFamily: 'Poppins', fontSize: 12, color: Colors.grey, letterSpacing: 2)),
      ),
    );
  }
}