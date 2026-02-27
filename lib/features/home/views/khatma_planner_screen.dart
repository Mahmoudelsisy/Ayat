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
    final now = DateTime.now();
    final daysPassed = now.difference(plan.startDate).inDays + 1;
    final progress = plan.progressAyahs / 6236;
    final remainingAyahs = 6236 - plan.progressAyahs;
    final remainingDays = plan.targetDays - daysPassed;
    final dailyGoal = remainingDays > 0 ? remainingAyahs / remainingDays : remainingAyahs.toDouble();

    // Mushaf pages is ~604
    final remainingPages = (remainingAyahs / 6236) * 604;
    final pagesPerDay = remainingDays > 0 ? remainingPages / remainingDays : remainingPages;

    final predictedEnd = now.add(Duration(days: remainingDays > 0 ? remainingDays : 1));

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: ListView(
        children: [
          Text(plan.title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          Center(
            child: SizedBox(
              width: 180, height: 180,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CircularProgressIndicator(value: progress, strokeWidth: 12, backgroundColor: Colors.grey[200]),
                  Center(child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('${(progress * 100).toInt()}%', style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                      const Text('مكتمل', style: TextStyle(color: Colors.grey)),
                    ],
                  )),
                ],
              ),
            ),
          ),
          const SizedBox(height: 30),
          _buildInfoCard([
            _buildInfoRow('تاريخ البدء', plan.startDate.toString().split(' ')[0]),
            _buildInfoRow('تاريخ الانتهاء المتوقع', predictedEnd.toString().split(' ')[0]),
            _buildInfoRow('الأيام المتبقية', '${remainingDays > 0 ? remainingDays : 0} يوم'),
          ]),
          const SizedBox(height: 16),
          _buildInfoCard([
            _buildInfoRow('الآيات المتبقية', '$remainingAyahs آية'),
            _buildInfoRow('الهدف اليومي (آيات)', '${dailyGoal.ceil()} آية'),
            _buildInfoRow('الهدف اليومي (صفحات)', '${pagesPerDay.toStringAsFixed(1)} صفحة'),
          ]),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: _finishPlan,
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white, padding: const EdgeInsets.all(16)),
            child: const Text('إنهاء الختمة الحالية'),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(List<Widget> children) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: children),
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
