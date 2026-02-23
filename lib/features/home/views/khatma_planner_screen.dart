import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;
import '../../../main.dart';
import '../../../core/database/database.dart';

final activeKhatmaProvider = FutureProvider<KhatmaPlan?>((ref) async {
  final db = ref.read(databaseProvider);
  return await (db.select(db.khatmaPlans)..where((t) => t.isActive.equals(true))..limit(1)).getSingleOrNull();
});

class KhatmaPlannerScreen extends ConsumerStatefulWidget {
  const KhatmaPlannerScreen({super.key});

  @override
  ConsumerState<KhatmaPlannerScreen> createState() => _KhatmaPlannerScreenState();
}

class _KhatmaPlannerScreenState extends ConsumerState<KhatmaPlannerScreen> {
  final _titleController = TextEditingController();
  int _targetDays = 30;

  @override
  Widget build(BuildContext context) {
    final activeKhatmaAsync = ref.watch(activeKhatmaProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('مخطط الختمة')),
      body: activeKhatmaAsync.when(
        data: (plan) => plan == null ? _buildCreatePlanView() : _buildActivePlanView(plan),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('خطأ: $err')),
      ),
    );
  }

  Widget _buildCreatePlanView() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('ابدأ ختمة جديدة', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(labelText: 'اسم الختمة (مثلاً: ختمة رمضان)'),
          ),
          const SizedBox(height: 20),
          Text('المدة المستهدفة (أيام): $_targetDays'),
          Slider(
            value: _targetDays.toDouble(),
            min: 7,
            max: 365,
            onChanged: (val) => setState(() => _targetDays = val.toInt()),
          ),
          const Spacer(),
          ElevatedButton(
            onPressed: _createPlan,
            style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(15)),
            child: const Text('بدء الختمة'),
          ),
        ],
      ),
    );
  }

  Widget _buildActivePlanView(KhatmaPlan plan) {
    final daysPassed = DateTime.now().difference(plan.startDate).inDays;
    final progress = plan.progressAyahs / 6236;
    final dailyGoal = 6236 / plan.targetDays;

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Text(plan.title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          SizedBox(
            width: 150, height: 150,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CircularProgressIndicator(value: progress, strokeWidth: 12),
                Center(child: Text('${(progress * 100).toInt()}%', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold))),
              ],
            ),
          ),
          const SizedBox(height: 30),
          _buildInfoRow('تاريخ البدء', plan.startDate.toString().split(' ')[0]),
          _buildInfoRow('المدة الكلية', '${plan.targetDays} يوم'),
          _buildInfoRow('الأيام المنقضية', '$daysPassed يوم'),
          _buildInfoRow('الهدف اليومي', '${dailyGoal.toInt()} آية'),
          const Spacer(),
          ElevatedButton(
            onPressed: _finishPlan,
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            child: const Text('إنهاء الختمة الحالية'),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 16)),
          Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Future<void> _createPlan() async {
    final db = ref.read(databaseProvider);
    await db.into(db.khatmaPlans).insert(KhatmaPlansCompanion.insert(
          title: _titleController.text.isEmpty ? 'ختمة جديدة' : _titleController.text,
          startDate: DateTime.now(),
          targetDays: _targetDays,
        ));
    ref.invalidate(activeKhatmaProvider);
  }

  Future<void> _finishPlan() async {
    final db = ref.read(databaseProvider);
    final active = await ref.read(activeKhatmaProvider.future);
    if (active != null) {
      await (db.update(db.khatmaPlans)..where((t) => t.id.equals(active.id))).write(const KhatmaPlansCompanion(isActive: drift.Value(false)));
      ref.invalidate(activeKhatmaProvider);
    }
  }
}
