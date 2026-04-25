import 'package:devasthan/providers/streak_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/app_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  String _greeting() {
    final h = DateTime.now().hour;
    if (h < 5) return 'Jai Shri Ram 🌙';
    if (h < 12) return 'Suprabhat 🌅';
    if (h < 17) return 'Jai Mata Di ☀️';
    if (h < 20) return 'Shubh Sandhya 🌇';
    return 'Jai Shri Krishna 🌙';
  }

  String _dateString() {
    final now = DateTime.now();
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    const days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];
    return '${days[now.weekday - 1]}, ${now.day} ${months[now.month - 1]} ${now.year}';
  }

  static const _quotes = [
    (
      'You have the right to perform your actions, but never to the fruits of your actions.',
      'Bhagavad Gita 2.47'
    ),
    ('The soul is never born nor dies at any time.', 'Bhagavad Gita 2.20'),
    (
      'Whatever happened, happened for good. Whatever is happening, is happening for good.',
      'Bhagavad Gita'
    ),
    ('Treat others as you would want to be treated.', 'Mahabharata 12.113.8'),
    (
      'Even the wise are confused about what is action and what is inaction.',
      'Bhagavad Gita 4.16'
    ),
    (
      'Let go of what has passed. Have faith in what will come.',
      'Vedic Proverb'
    ),
    (
      'The mind is restless. But it can be trained through practice and detachment.',
      'Bhagavad Gita 6.35'
    ),
  ];

  static const _aartis = [
    ('Jai Ganesh Jai Ganesh Deva', 'Ganesha'),
    ('Om Jai Shiv Omkara', 'Shiva'),
    ('Om Jai Lakshmi Mata', 'Lakshmi'),
    ('Jai Hanuman Gyan Gun Sagar', 'Hanuman'),
    ('Achyutam Keshavam', 'Krishna'),
  ];

  @override
  Widget build(BuildContext context) {
    final appProvider = context.watch<AppProvider>();
    final theme = Theme.of(context);
    final day = DateTime.now().difference(DateTime(DateTime.now().year)).inDays;
    final quote = _quotes[day % _quotes.length];
    final aarti = _aartis[day % _aartis.length];

    return Scaffold(
      appBar: AppBar(
        title: const Text('🙏 Devasthan'),
        actions: [
          IconButton(
            icon: Icon(appProvider.isDark ? Icons.light_mode : Icons.dark_mode),
            onPressed: appProvider.toggleTheme,
          ),
        ],
      ),
      body: Column(
        children: [
          // ── Scrollable content ───────────────────────────────
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // ── Greeting ───────────────────────────────────
                Text(_greeting(),
                    style: theme.textTheme.headlineMedium
                        ?.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                Text(_dateString(),
                    style: theme.textTheme.bodyMedium
                        ?.copyWith(color: Colors.grey)),
                const SizedBox(height: 20),

                // ── Streak Card ────────────────────────────────
                _StreakCard(streak: context.watch<StreakProvider>().streak),
                const SizedBox(height: 16),

                // ── Daily Aarti Card ───────────────────────────
                _DailyAartiCard(title: aarti.$1, deity: aarti.$2),
                const SizedBox(height: 20),

                // ── Quick Actions ──────────────────────────────
                Text('Quick Actions',
                    style: theme.textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 12),
                _QuickActions(),
                const SizedBox(height: 20),

                // ── Daily Quote ────────────────────────────────
                _QuoteCard(quote: quote.$1, source: quote.$2),
                const SizedBox(height: 16),
              ],
            ),
          ),

          // ── AdMob Banner Placeholder ─────────────────────────
          _AdBanner(),
        ],
      ),
    );
  }
}

// ── Streak Card ────────────────────────────────────────────────

class _StreakCard extends StatelessWidget {
  final int streak;
  const _StreakCard({required this.streak});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.gold, AppColors.saffronLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: AppColors.gold.withOpacity(0.4),
              blurRadius: 12,
              offset: const Offset(0, 4)),
        ],
      ),
      child: Row(
        children: [
          const Text('🔥', style: TextStyle(fontSize: 40)),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${streak} Day${streak == 1 ? '' : 's'} Streak',
                style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.templeBlack),
              ),
              Text(
                streak == 0
                    ? 'Start your daily practice today!'
                    : 'Keep the devotion alive!',
                style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 13,
                    color: AppColors.templeBlack.withOpacity(0.65)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Daily Aarti Card ───────────────────────────────────────────

class _DailyAartiCard extends StatelessWidget {
  final String title;
  final String deity;
  const _DailyAartiCard({required this.title, required this.deity});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: InkWell(
        onTap: () => context.go('/aarti'),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                    color: AppColors.turmeric,
                    borderRadius: BorderRadius.circular(14)),
                child: const Center(
                    child: Text('🙏', style: TextStyle(fontSize: 28))),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.saffron.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text("✨ Today's Aarti",
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AppColors.saffron)),
                    ),
                    const SizedBox(height: 6),
                    Text(title,
                        style: theme.textTheme.titleSmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                    Text(deity,
                        style: theme.textTheme.bodySmall
                            ?.copyWith(color: Colors.grey)),
                  ],
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                    color: AppColors.saffron, shape: BoxShape.circle),
                child: IconButton(
                  icon:
                      const Icon(Icons.play_arrow_rounded, color: Colors.white),
                  onPressed: () => context.go('/aarti'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Quick Actions ──────────────────────────────────────────────

class _QuickActions extends StatelessWidget {
  static const _items = [
    _Action(emoji: '🛕', label: 'My Mandir', route: '/mandir'),
    _Action(emoji: '🎵', label: 'Aarti', route: '/aarti'),
    _Action(emoji: '⏰', label: 'Set Alarm', route: '/profile'),
    _Action(emoji: '👤', label: 'Profile', route: '/profile'),
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: _items
          .map((item) => Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: _ActionTile(item: item),
                ),
              ))
          .toList(),
    );
  }
}

class _Action {
  final String emoji;
  final String label;
  final String route;
  const _Action(
      {required this.emoji, required this.label, required this.route});
}

class _ActionTile extends StatelessWidget {
  final _Action item;
  const _ActionTile({required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: () => context.go(item.route),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: theme.cardTheme.color,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
                color: AppColors.saffron.withOpacity(0.08),
                blurRadius: 8,
                offset: const Offset(0, 2)),
          ],
        ),
        child: Column(
          children: [
            Text(item.emoji, style: const TextStyle(fontSize: 26)),
            const SizedBox(height: 6),
            Text(item.label,
                style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 11,
                    fontWeight: FontWeight.w500),
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

// ── Quote Card ─────────────────────────────────────────────────

class _QuoteCard extends StatelessWidget {
  final String quote;
  final String source;
  const _QuoteCard({required this.quote, required this.source});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.saffron.withOpacity(0.07),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.saffron.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('📖 Today\'s Wisdom',
              style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.saffron)),
          const SizedBox(height: 10),
          Text('"$quote"',
              style: theme.textTheme.bodyLarge
                  ?.copyWith(fontStyle: FontStyle.italic, height: 1.6)),
          const SizedBox(height: 8),
          Text('— $source',
              style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.saffron)),
        ],
      ),
    );
  }
}

// ── AdMob Banner Placeholder ───────────────────────────────────

class _AdBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 52,
      color: Colors.grey.shade200,
      child: const Center(
        child: Text('AD BANNER',
            style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12,
                color: Colors.grey,
                letterSpacing: 2)),
      ),
    );
  }
}
