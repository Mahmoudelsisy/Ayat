import 'package:flutter/material.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' hide Column;
import '../../../main.dart';
import '../../../core/database/database.dart';

class CalendarScreen extends ConsumerStatefulWidget {
  const CalendarScreen({super.key});

  @override
  ConsumerState<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen> {
  late HijriCalendar _selectedDate;
  List<FastingTrackingData> _fastingDays = [];
  List<CalendarNote> _notes = [];

  @override
  void initState() {
    super.initState();
    _selectedDate = HijriCalendar.now();
    _loadData();
  }

  Future<void> _loadData() async {
    final db = ref.read(databaseProvider);
    final fasting = await (db.select(db.fastingTracking)
          ..where((t) => t.hYear.equals(_selectedDate.hYear) & t.hMonth.equals(_selectedDate.hMonth)))
        .get();
    final notes = await (db.select(db.calendarNotes)
          ..where((t) => t.hYear.equals(_selectedDate.hYear) & t.hMonth.equals(_selectedDate.hMonth)))
        .get();

    if (mounted) {
      setState(() {
        _fastingDays = fasting;
        _notes = notes;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('التقويم الهجري')),
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
              ),
              itemCount: _selectedDate.getDaysInMonth(_selectedDate.hYear, _selectedDate.hMonth) + _getStartWeekday(),
              itemBuilder: (context, index) {
                if (index < _getStartWeekday()) return const SizedBox();
                final day = index - _getStartWeekday() + 1;
                final isToday = _isToday(day);
                final isFasting = _fastingDays.any((d) => d.hDay == day);
                final hasNote = _notes.any((n) => n.hDay == day);

                return InkWell(
                  onTap: () => _showDayDetails(day),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isToday
                          ? Colors.green
                          : isFasting
                              ? Colors.orange.withValues(alpha: 0.3)
                              : Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                      border: hasNote ? Border.all(color: Colors.blue, width: 2) : null,
                    ),
                    child: Stack(
                      children: [
                        Center(
                          child: Text(
                            day.toString(),
                            style: TextStyle(
                              color: isToday ? Colors.white : Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        if (isFasting)
                          const Positioned(
                            top: 2,
                            right: 2,
                            child: Icon(Icons.wb_sunny, size: 12, color: Colors.orange),
                          ),
                        if (hasNote)
                          const Positioned(
                            bottom: 2,
                            left: 2,
                            child: Icon(Icons.note, size: 12, color: Colors.blue),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          _buildEventsList(),
        ],
      ),
    );
  }

  void _showDayDetails(int day) {
    final fastingDay = _fastingDays.where((d) => d.hDay == day).firstOrNull;
    final note = _notes.where((n) => n.hDay == day).firstOrNull;
    final noteController = TextEditingController(text: note?.note ?? '');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 16, right: 16, top: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('يوم $day ${_selectedDate.longMonthName}',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
            const SizedBox(height: 20),
            SwitchListTile(
              title: const Text('صيام'),
              value: fastingDay != null,
              onChanged: (val) async {
                final db = ref.read(databaseProvider);
                if (val) {
                  await db.into(db.fastingTracking).insert(FastingTrackingCompanion.insert(
                        hYear: _selectedDate.hYear,
                        hMonth: _selectedDate.hMonth,
                        hDay: day,
                        type: 'Sunnah',
                      ));
                } else if (fastingDay != null) {
                  await (db.delete(db.fastingTracking)..where((t) => t.id.equals(fastingDay.id))).go();
                }
                if (context.mounted) Navigator.pop(context);
                _loadData();
              },
            ),
            const Divider(),
            const Text('ملاحظات:', style: TextStyle(fontWeight: FontWeight.bold)),
            TextField(
              controller: noteController,
              decoration: const InputDecoration(hintText: 'أضف ملاحظة لهذا اليوم...'),
              maxLines: 3,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final db = ref.read(databaseProvider);
                if (noteController.text.isEmpty) {
                  if (note != null) {
                    await (db.delete(db.calendarNotes)..where((t) => t.id.equals(note.id))).go();
                  }
                } else {
                  if (note != null) {
                    await (db.update(db.calendarNotes)..where((t) => t.id.equals(note.id)))
                        .write(CalendarNotesCompanion(note: Value(noteController.text)));
                  } else {
                    await db.into(db.calendarNotes).insert(CalendarNotesCompanion.insert(
                          hYear: _selectedDate.hYear,
                          hMonth: _selectedDate.hMonth,
                          hDay: day,
                          note: noteController.text,
                        ));
                  }
                }
                if (context.mounted) Navigator.pop(context);
                _loadData();
              },
              child: const Text('حفظ'),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(icon: const Icon(Icons.chevron_left), onPressed: _nextMonth),
          Text(
            '${_selectedDate.longMonthName} ${_selectedDate.hYear}',
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          IconButton(icon: const Icon(Icons.chevron_right), onPressed: _prevMonth),
        ],
      ),
    );
  }

  int _getStartWeekday() {
    // Basic implementation for start of month
    final firstDay = HijriCalendar();
    firstDay.hYear = _selectedDate.hYear;
    firstDay.hMonth = _selectedDate.hMonth;
    firstDay.hDay = 1;
    // In hijri package, it seems we need to convert to DateTime to get weekday
    return DateTime.parse(firstDay.toString()).weekday % 7;
  }

  bool _isToday(int day) {
    final now = HijriCalendar.now();
    return now.hYear == _selectedDate.hYear && now.hMonth == _selectedDate.hMonth && now.hDay == day;
  }

  void _nextMonth() {
    setState(() {
      if (_selectedDate.hMonth == 12) {
        _selectedDate.hMonth = 1;
        _selectedDate.hYear++;
      } else {
        _selectedDate.hMonth++;
      }
      _loadData();
    });
  }

  void _prevMonth() {
    setState(() {
      if (_selectedDate.hMonth == 1) {
        _selectedDate.hMonth = 12;
        _selectedDate.hYear--;
      } else {
        _selectedDate.hMonth--;
      }
      _loadData();
    });
  }

  Widget _buildEventsList() {
    return Container(
      padding: const EdgeInsets.all(16),
      width: double.infinity,
      color: Colors.green.withValues(alpha: 0.1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('المناسبات الإسلامية القادمة', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          _buildEventTile('بداية رمضان', '1 رمضان'),
          _buildEventTile('عيد الفطر', '1 شوال'),
          _buildEventTile('يوم عرفة', '9 ذو الحجة'),
        ],
      ),
    );
  }

  Widget _buildEventTile(String title, String date) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title),
          Text(date, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
        ],
      ),
    );
  }
}
