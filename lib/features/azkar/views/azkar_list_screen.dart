import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../main.dart';
import '../../../core/database/database.dart';

final azkarContentProvider = FutureProvider.family<List<AzkarData>, String>((ref, category) async {
  final db = ref.read(databaseProvider);
  return await (db.select(db.azkar)..where((t) => t.category.equals(category))).get();
});

class AzkarListScreen extends ConsumerWidget {
  final String category;
  const AzkarListScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final azkarAsync = ref.watch(azkarContentProvider(category));

    return Scaffold(
      appBar: AppBar(
        title: Text(category),
      ),
      body: azkarAsync.when(
        data: (items) => ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            return AzkarCard(item: item);
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('خطأ: $err')),
      ),
    );
  }
}

class AzkarCard extends StatefulWidget {
  final AzkarData item;
  const AzkarCard({super.key, required this.item});

  @override
  State<AzkarCard> createState() => _AzkarCardState();
}

class _AzkarCardState extends State<AzkarCard> {
  late int _remaining;

  @override
  void initState() {
    super.initState();
    _remaining = widget.item.count;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      color: _remaining == 0 ? Colors.grey[200] : null,
      child: InkWell(
        onTap: () {
          if (_remaining > 0) {
            setState(() => _remaining--);
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                widget.item.zikrText,
                textAlign: TextAlign.right,
                style: const TextStyle(fontSize: 18, height: 1.5),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    backgroundColor: _remaining == 0 ? Colors.green : Theme.of(context).primaryColor,
                    child: Text('$_remaining', style: const TextStyle(color: Colors.white)),
                  ),
                  if (widget.item.reference != null)
                    Expanded(
                      child: Text(
                        widget.item.reference!,
                        textAlign: TextAlign.left,
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
