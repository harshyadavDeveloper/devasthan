import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/mandir_provider.dart';

class MandirScreen extends StatelessWidget {
  const MandirScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MandirProvider>();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          onTap: () => _renameDialog(context, provider),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(provider.mandirName),
              const SizedBox(width: 6),
              const Icon(Icons.edit, size: 16),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep_outlined),
            tooltip: 'Clear all',
            onPressed: provider.isEmpty
                ? null
                : () => _confirmClear(context, provider),
          ),
        ],
      ),
      body: Column(
        children: [
          // ── Canvas ───────────────────────────────────────────
          Expanded(
            child: _MandirCanvas(),
          ),

          // ── Tabs: Deities / Decor ────────────────────────────
          _BottomPicker(),

          // ── Ad Banner ────────────────────────────────────────
          _AdBanner(),
        ],
      ),
    );
  }

  void _renameDialog(BuildContext context, MandirProvider provider) {
    final ctrl = TextEditingController(text: provider.mandirName);
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Rename Mandir'),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'e.g. Shree Ram Mandir'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              provider.setMandirName(ctrl.text);
              Navigator.of(dialogContext).pop();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _confirmClear(BuildContext context, MandirProvider provider) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Clear Mandir?'),
        content: const Text('This will remove all deities and decor.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              provider.clearAll();
              Navigator.of(dialogContext).pop();
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }
}

// ── Canvas ─────────────────────────────────────────────────────

class _MandirCanvas extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MandirProvider>();

    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFF8E1), Color(0xFFFFECB3)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.gold.withOpacity(0.5), width: 2),
        boxShadow: [
          BoxShadow(
              color: AppColors.gold.withOpacity(0.2),
              blurRadius: 16,
              spreadRadius: 2),
        ],
      ),
      child: provider.isEmpty
          ? _emptyState()
          : LayoutBuilder(
              builder: (context, constraints) {
                return Stack(
                  children: provider.items.map((item) {
                    return _DraggableItem(
                      item: item,
                      width: constraints.maxWidth,
                      height: constraints.maxHeight,
                    );
                  }).toList(),
                );
              },
            ),
    );
  }

  Widget _emptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('🛕', style: TextStyle(fontSize: 64)),
          SizedBox(height: 12),
          Text('Your mandir awaits',
              style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: AppColors.templeBlack)),
          SizedBox(height: 6),
          Text('Tap deities below to place them',
              style: TextStyle(
                  fontFamily: 'Poppins', fontSize: 13, color: Colors.grey)),
        ],
      ),
    );
  }
}

// ── Draggable Item ─────────────────────────────────────────────

class _DraggableItem extends StatelessWidget {
  final PlacedItem item;
  final double width;
  final double height;

  const _DraggableItem({
    required this.item,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    final provider = context.read<MandirProvider>();
    final left = item.position.dx * width - 30;
    final top = item.position.dy * height - 30;

    return Positioned(
      left: left.clamp(0.0, width - 60),
      top: top.clamp(0.0, height - 60),
      child: GestureDetector(
        onLongPress: () {
          provider.removeItem(item.uid);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('${item.label} removed'),
                duration: const Duration(seconds: 1)),
          );
        },
        onPanUpdate: (details) {
          final newX =
              (item.position.dx + details.delta.dx / width).clamp(0.0, 1.0);
          final newY =
              (item.position.dy + details.delta.dy / height).clamp(0.0, 1.0);
          provider.moveItem(item.uid, Offset(newX, newY));
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(item.emoji, style: const TextStyle(fontSize: 36)),
            Text(
              item.label,
              style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                  color: AppColors.templeBlack),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Bottom Picker ──────────────────────────────────────────────

class _BottomPicker extends StatefulWidget {
  @override
  State<_BottomPicker> createState() => _BottomPickerState();
}

class _BottomPickerState extends State<_BottomPicker>
    with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      height: 150,
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 8,
              offset: const Offset(0, -2))
        ],
      ),
      child: Column(
        children: [
          TabBar(
            controller: _tabCtrl,
            labelColor: AppColors.saffron,
            unselectedLabelColor: Colors.grey,
            indicatorColor: AppColors.saffron,
            labelStyle: const TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                fontSize: 13),
            tabs: const [Tab(text: 'Deities'), Tab(text: 'Decor')],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabCtrl,
              children: [
                const _ItemRow(items: MandirProvider.deities),
                const _ItemRow(items: MandirProvider.decor),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ItemRow extends StatelessWidget {
  final List<DeityModel> items;
  const _ItemRow({required this.items});

  @override
  Widget build(BuildContext context) {
    final provider = context.read<MandirProvider>();
    final theme = Theme.of(context); // ← use theme
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(width: 10),
      itemBuilder: (context, i) {
        final item = items[i];
        return GestureDetector(
          onTap: () => provider.addItem(item.emoji, item.name),
          child: Container(
            width: 70,
            decoration: BoxDecoration(
              color: theme.cardTheme.color, // ← was hardcoded Colors.white
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.gold.withOpacity(0.3)),
              boxShadow: [
                BoxShadow(
                    color: AppColors.saffron.withOpacity(0.06), blurRadius: 6)
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(item.emoji, style: const TextStyle(fontSize: 28)),
                const SizedBox(height: 4),
                Text(item.name,
                    style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 10,
                        fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        );
      },
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
