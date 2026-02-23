import 'package:flutter/material.dart';
import 'package:hijri/hijri_calendar.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late HijriCalendar _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = HijriCalendar.now();
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

                return Container(
                  decoration: BoxDecoration(
                    color: isToday ? Colors.green : Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      day.toString(),
                      style: TextStyle(
                        color: isToday ? Colors.white : Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
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
