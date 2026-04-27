import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/aarti_provider.dart';

class AartiScreen extends StatelessWidget {
  const AartiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AartiProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Aarti & Bhajans')),
      body: Column(
        children: [
          // ── Now Playing Card ─────────────────────────────────
          if (provider.current != null) _NowPlayingCard(),

          // ── Track List ───────────────────────────────────────
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: AartiProvider.catalog.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, i) {
                final track = AartiProvider.catalog[i];
                final isActive = provider.current?.id == track.id;
                return _TrackTile(track: track, isActive: isActive);
              },
            ),
          ),

          // ── Player Controls ──────────────────────────────────
          if (provider.current != null) _PlayerControls(),

          // ── Ad Banner ────────────────────────────────────────
          _AdBanner(),
        ],
      ),
    );
  }
}

// ── Now Playing Card ───────────────────────────────────────────

class _NowPlayingCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AartiProvider>();
    final track = provider.current!;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.saffron, AppColors.vermillion],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: AppColors.saffron.withOpacity(0.35),
              blurRadius: 16,
              offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(14)),
                child: const Center(
                    child: Text('🙏', style: TextStyle(fontSize: 28))),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      track.title,
                      style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.white),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      track.deity,
                      style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 12,
                          color: Colors.white70),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // ── Seek bar ────────────────────────────────────────
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 3,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
              activeTrackColor: Colors.white,
              inactiveTrackColor: Colors.white30,
              thumbColor: Colors.white,
              overlayColor: Colors.white24,
            ),
            child: Slider(
              value: provider.progress.clamp(0.0, 1.0),
              onChanged: provider.seekTo,
            ),
          ),

          // ── Time labels ─────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(provider.positionLabel,
                    style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 11,
                        color: Colors.white70)),
                Text(provider.durationLabel,
                    style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 11,
                        color: Colors.white70)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Track Tile ─────────────────────────────────────────────────

class _TrackTile extends StatelessWidget {
  final AartiTrack track;
  final bool isActive;
  const _TrackTile({required this.track, required this.isActive});

  @override
  Widget build(BuildContext context) {
    final provider = context.read<AartiProvider>();
    final theme = Theme.of(context);

    return Card(
      child: InkWell(
        onTap: () {
          if (isActive && provider.isPlaying) {
            provider.pause();
          } else if (isActive && !provider.isPlaying) {
            provider.resume();
          } else {
            provider.play(track);
          }
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              // ── Icon ─────────────────────────────────────────
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: isActive
                      ? AppColors.saffron.withOpacity(0.15)
                      : AppColors.turmeric,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: isActive && provider.isPlaying
                      ? const Icon(Icons.pause_rounded,
                          color: AppColors.saffron)
                      : const Text('🎵', style: TextStyle(fontSize: 22)),
                ),
              ),
              const SizedBox(width: 14),

              // ── Title ─────────────────────────────────────────
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      track.title,
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: isActive ? AppColors.saffron : null,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      track.deity,
                      style: theme.textTheme.bodySmall
                          ?.copyWith(color: Colors.grey),
                    ),
                  ],
                ),
              ),

              // ── Play/Pause icon ───────────────────────────────
              Icon(
                isActive && provider.isPlaying
                    ? Icons.pause_circle_outline_rounded
                    : Icons.play_circle_outline_rounded,
                color: isActive ? AppColors.saffron : Colors.grey,
                size: 28,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Player Controls ────────────────────────────────────────────

class _PlayerControls extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AartiProvider>();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Repeat
          IconButton(
            icon: Icon(Icons.repeat_rounded,
                color: provider.repeat ? AppColors.saffron : Colors.grey),
            onPressed: provider.toggleRepeat,
            tooltip: 'Repeat',
          ),

          // Previous
          IconButton(
            icon: const Icon(Icons.skip_previous_rounded, size: 32),
            onPressed: () {
              final idx = AartiProvider.catalog
                  .indexWhere((t) => t.id == provider.current?.id);
              if (idx > 0) provider.play(AartiProvider.catalog[idx - 1]);
            },
          ),

          // Play / Pause main button
          Container(
            decoration: const BoxDecoration(
                color: AppColors.saffron, shape: BoxShape.circle),
            child: IconButton(
              iconSize: 36,
              icon: Icon(
                provider.isPlaying
                    ? Icons.pause_rounded
                    : Icons.play_arrow_rounded,
                color: Colors.white,
              ),
              onPressed: () =>
                  provider.isPlaying ? provider.pause() : provider.resume(),
            ),
          ),

          // Next
          IconButton(
            icon: const Icon(Icons.skip_next_rounded, size: 32),
            onPressed: () {
              final idx = AartiProvider.catalog
                  .indexWhere((t) => t.id == provider.current?.id);
              if (idx < AartiProvider.catalog.length - 1)
                provider.play(AartiProvider.catalog[idx + 1]);
            },
          ),

          // Stop
          IconButton(
            icon: const Icon(Icons.stop_rounded, color: Colors.grey),
            onPressed: provider.stop,
            tooltip: 'Stop',
          ),
        ],
      ),
    );
  }
}

// ── Ad Banner ──────────────────────────────────────────────────

class _AdBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 52,
      color: Colors.grey.shade200,
      child: const Center(
        child: Text(
          'AD BANNER',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 12,
            color: Colors.grey,
            letterSpacing: 2,
          ),
        ),
      ),
    );
  }
}
