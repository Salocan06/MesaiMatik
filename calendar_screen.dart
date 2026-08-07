import 'package:flutter/material.dart';
import 'models.dart';
import 'day_dialog.dart';
import 'lang.dart';

class CalendarScreen extends StatefulWidget {
  final AppSettings settings;
  final Map<String, DayRecord> records;
  final DateTime initialMonth;
  final Map<int, TaxYearSettings> taxYears;
  final void Function(String dateKey, DayRecord? record) onUpdateRecord;

  const CalendarScreen({
    super.key,
    required this.settings,
    required this.records,
    required this.initialMonth,
    required this.taxYears,
    required this.onUpdateRecord,
  });

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late DateTime currentMonth;

  @override
  void initState() {
    super.initState();
    currentMonth = DateTime(widget.initialMonth.year, widget.initialMonth.month);
  }

  String _dateKey(DateTime d) {
    final mm = d.month.toString().padLeft(2, '0');
    final dd = d.day.toString().padLeft(2, '0');
    return '${d.year}-$mm-$dd';
  }

  void _changeMonth(int delta) {
    setState(() {
      currentMonth = DateTime(currentMonth.year, currentMonth.month + delta);
    });
  }

  Future<void> _openDay(DateTime day) async {
    final key = _dateKey(day);
    final existing = widget.records[key] ?? DayRecord();
    final result = await showDialog(
      context: context,
      builder: (context) => DayEntryDialog(day: day, initial: existing),
    );
    if (result == 'DELETE') {
      widget.onUpdateRecord(key, null);
      setState(() {});
    } else if (result is DayRecord) {
      widget.onUpdateRecord(key, result);
      setState(() {});
    }
  }

  Map<String, double> _computeTotals() {
    double haftaIci = 0, cumartesi = 0, pazar = 0, resmiTatil = 0;
    double avansTotal = 0, bahsisTotal = 0;
    widget.records.forEach((key, r) {
      final d = DateTime.parse(key);
      if (d.year != currentMonth.year || d.month != currentMonth.month) return;
      avansTotal += r.avans;
      bahsisTotal += r.bahsis;
      if (r.type == 'mesai' && r.hours > 0) {
        if (r.resmiTatil) {
          resmiTatil += r.hours;
        } else if (d.weekday == DateTime.saturday) {
          cumartesi += r.hours;
        } else if (d.weekday == DateTime.sunday) {
          pazar += r.hours;
        } else {
          haftaIci += r.hours;
        }
      }
    });
    return {
      'haftaIci': haftaIci,
      'cumartesi': cumartesi,
      'pazar': pazar,
      'resmiTatil': resmiTatil,
      'avans': avansTotal,
      'bahsis': bahsisTotal,
    };
  }

  String? _dayLabel(DayRecord? r) {
    if (r == null) return null;
    switch (r.type) {
      case 'mesai':
        return r.hours > 0 ? r.hours.toString() : null;
      case 'gitmedim':
        return 'X';
      case 'raporlu':
        return 'R';
      case 'ucretliIzin':
        return 'I';
      case 'ucretsizIzin':
        return 'Iu';
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final months = monthNames();
    final tax = taxForYear(widget.taxYears, currentMonth.year);
    final totals = _computeTotals();
    final rate = widget.settings.hourlyRateForCalc(tax);
    final saatUcreti = totals['haftaIci']! * rate * widget.settings.multiplierHaftaIci +
        totals['cumartesi']! * rate * widget.settings.multiplierCumartesi +
        totals['pazar']! * rate * widget.settings.multiplierPazar +
        totals['resmiTatil']! * rate * widget.settings.multiplierResmiTatil;

    final firstDay = DateTime(currentMonth.year, currentMonth.month, 1);
    final daysInMonth = DateTime(currentMonth.year, currentMonth.month + 1, 0).day;
    final startWeekday = firstDay.weekday;

    final base30 = widget.settings.baseMonthlyEarning(tax);
    final baseForMonth = widget.settings.baseMonthlyEarningForMonth(daysInMonth, tax);
    final total = baseForMonth + saatUcreti + totals['bahsis']! - totals['avans']!;

    List<Widget> dayCells = [];
    for (int i = 1; i < startWeekday; i++) {
      dayCells.add(Container());
    }
    for (int d = 1; d <= daysInMonth; d++) {
      final day = DateTime(currentMonth.year, currentMonth.month, d);
      final key = _dateKey(day);
      final record = widget.records[key];
      final label = _dayLabel(record);
      dayCells.add(
        InkWell(
          onTap: () => _openDay(day),
          child: Container(
            margin: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade700),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('$d'),
                if (label != null)
                  Text(label,
                      style: const TextStyle(
                          color: Colors.green, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(t('calendarTitle'))),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left),
                    onPressed: () => _changeMonth(-1),
                  ),
                  Text(
                    '${currentMonth.year} ${months[currentMonth.month - 1]}',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.chevron_right),
                    onPressed: () => _changeMonth(1),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: GridView.count(
                crossAxisCount: 7,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                childAspectRatio: 1.1,
                children: dayCells,
              ),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${t('weekdayHours')} ${totals['haftaIci']}'),
                  Text('${t('saturdayHours')} ${totals['cumartesi']}'),
                  Text('${t('sundayHours')} ${totals['pazar']}'),
                  Text('${t('holidayHours')} ${totals['resmiTatil']}'),
                  const SizedBox(height: 8),
                  Text('${t('advanceTotal')} ${totals['avans']!.toStringAsFixed(2)} TL'),
                  Text('${t('tipTotal')} ${totals['bahsis']!.toStringAsFixed(2)} TL'),
                  const SizedBox(height: 8),
                  Text(
                    '${t('normallyNetSalary')} ${base30.toStringAsFixed(2)} TL)',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  Text(
                    '$daysInMonth ${t('daysNetSalary')}${baseForMonth.toStringAsFixed(2)} TL',
                  ),
                  Text('${t('overtimeExtra')}${saatUcreti.toStringAsFixed(2)} TL'),
                  const Divider(),
                  Text(
                    '${t('finalSalary')} ${total.toStringAsFixed(2)} TL',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}