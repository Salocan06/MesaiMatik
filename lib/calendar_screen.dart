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
    double avansTotal = 0, gecKalmaTotal = 0, haftaIciEksikSaat = 0;
    double sickDays = 0, absentDays = 0, unpaidDays = 0;
    double telafiCumartesiSaat = 0, telafiPazarSaat = 0;
    double gitmedimCumartesiSaat = 0, gitmedimPazarSaat = 0;
    widget.records.forEach((key, r) {
      final d = DateTime.parse(key);
      if (d.year != currentMonth.year || d.month != currentMonth.month) return;
      avansTotal += r.avans;
      gecKalmaTotal += r.gecKalmaDakika;
      final isWeekday = d.weekday != DateTime.saturday && d.weekday != DateTime.sunday;
      if (isWeekday && r.gecKalmaDakika > 0) {
        haftaIciEksikSaat += r.gecKalmaDakika / 60;
      }
      if (r.type == 'raporlu') sickDays += 1;
      if (r.type == 'gitmedim') {
        absentDays += 1;
        if (r.gitmedimSaat > 0) {
          if (r.gitmedimGunu == 'pazar') {
            gitmedimPazarSaat += r.gitmedimSaat;
          } else {
            gitmedimCumartesiSaat += r.gitmedimSaat;
          }
        }
      }
      if (r.type == 'ucretsizIzin') unpaidDays += 1;
      if (r.type == 'telafi' && r.telafiSaat > 0) {
        if (r.telafiGunu == 'pazar') {
          telafiPazarSaat += r.telafiSaat;
        } else {
          telafiCumartesiSaat += r.telafiSaat;
        }
      }
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
      'gecKalma': gecKalmaTotal,
      'haftaIciEksikSaat': haftaIciEksikSaat,
      'sickDays': sickDays,
      'absentDays': absentDays,
      'unpaidDays': unpaidDays,
      'telafiCumartesiSaat': telafiCumartesiSaat,
      'telafiPazarSaat': telafiPazarSaat,
      'gitmedimCumartesiSaat': gitmedimCumartesiSaat,
      'gitmedimPazarSaat': gitmedimPazarSaat,
    };
  }

  String? _dayLabel(DayRecord? r) {
    if (r == null) return null;
    switch (r.type) {
      case 'mesai':
        return r.hours > 0 ? r.hours.toStringAsFixed(1) : null;
      case 'gitmedim':
        return 'X';
      case 'raporlu':
        return 'R';
      case 'ucretliIzin':
        return 'Yi';
      case 'ucretsizIzin':
        return '\u00DCi';
      case 'telafi':
        return 'T';
      default:
        return null;
    }
  }

  Widget _legendDot(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 9,
          height: 9,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 5),
        Text(label, style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
      ],
    );
  }

  Widget _summaryGroupCard(List<Widget> rows) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.white.withOpacity(0.04)
            : Colors.black.withOpacity(0.03),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 4),
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(children: rows),
    );
  }

  Widget _summaryRow(IconData icon, Color iconColor, String label, String value,
      {Color? valueColor, bool showDivider = true}) {
    return Container(
      decoration: BoxDecoration(
        border: showDivider
            ? Border(
                bottom: BorderSide(
                  color: Theme.of(context).dividerColor.withOpacity(0.3),
                  width: 0.5,
                ),
              )
            : null,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        children: [
          Icon(icon, size: 16, color: iconColor),
          const SizedBox(width: 10),
          Expanded(
            child: Text(label,
                style: TextStyle(fontSize: 13, color: Colors.grey.shade500)),
          ),
          Text(value,
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: valueColor)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final months = monthNames();
    final tax = taxForYear(widget.taxYears, currentMonth.year);
    final totals = _computeTotals();
    final rate = widget.settings.hourlyRateForCalc(tax);
    final dailyRate = widget.settings.dailyRateForCalc(tax);
    final saatUcreti = totals['haftaIci']! * rate * widget.settings.multiplierHaftaIci +
        totals['cumartesi']! * rate * widget.settings.multiplierCumartesi +
        totals['pazar']! * rate * widget.settings.multiplierPazar +
        totals['resmiTatil']! * rate * widget.settings.multiplierResmiTatil;

    final firstDay = DateTime(currentMonth.year, currentMonth.month, 1);
    final daysInMonth = DateTime(currentMonth.year, currentMonth.month + 1, 0).day;
    final startWeekday = firstDay.weekday;

    final base30 = widget.settings.baseMonthlyEarning(tax);
    final baseForMonth = widget.settings.baseMonthlyEarningForMonth(daysInMonth, tax);
    final gecKalmaKesinti = (totals['gecKalma']! / 60) * rate;
    final unpaidDeduction = totals['unpaidDays']! * dailyRate;
    final telafiKesinti = (totals['telafiCumartesiSaat']! + totals['telafiPazarSaat']!) * rate;
    final gitmedimKesinti = (totals['gitmedimCumartesiSaat']! + totals['gitmedimPazarSaat']!) * rate;
    final total = baseForMonth +
        saatUcreti -
        totals['avans']! -
        gecKalmaKesinti -
        unpaidDeduction -
        telafiKesinti -
        gitmedimKesinti;

    List<Widget> dayCells = [];
    for (int i = 1; i < startWeekday; i++) {
      dayCells.add(Container());
    }
    for (int d = 1; d <= daysInMonth; d++) {
      final day = DateTime(currentMonth.year, currentMonth.month, d);
      final key = _dateKey(day);
      final record = widget.records[key];
      final label = _dayLabel(record);
      final hasLate = record != null && record.gecKalmaDakika > 0;
      final hasOvertime = record != null && record.type == 'mesai' && record.hours > 0;

      Color? solidColor;
      if (record != null) {
        if (record.type == 'gitmedim') {
          solidColor = Colors.red;
        } else if (record.type == 'ucretliIzin') {
          solidColor = Colors.orange;
        } else if (record.type == 'ucretsizIzin') {
          solidColor = Colors.yellow.shade700;
        } else if (record.type == 'telafi') {
          solidColor = Colors.blue;
        } else if (hasOvertime && !hasLate) {
          solidColor = Colors.green;
        } else if (hasLate && !hasOvertime) {
          solidColor = Colors.red;
        }
      }
      final isHalfSplit = hasOvertime && hasLate;

      Widget cellBackground;
      if (isHalfSplit) {
        cellBackground = Row(
          children: [
            Expanded(
              child: Container(color: Colors.red.withOpacity(0.55)),
            ),
            Expanded(
              child: Container(color: Colors.green.withOpacity(0.55)),
            ),
          ],
        );
      } else if (solidColor != null) {
        cellBackground = Container(color: solidColor.withOpacity(0.55));
      } else {
        cellBackground = Container();
      }

      dayCells.add(
        InkWell(
          onTap: () => _openDay(day),
          child: Container(
            margin: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              border: Border.all(
                color: (solidColor ?? (isHalfSplit ? Colors.red : Colors.grey.shade700)),
                width: (solidColor != null || isHalfSplit) ? 2 : 1,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            clipBehavior: Clip.antiAlias,
            child: Stack(
              children: [
                Positioned.fill(child: cellBackground),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '$d',
                      style: (solidColor != null || isHalfSplit)
                          ? const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold)
                          : null,
                    ),
                    if (hasLate)
                      Text(
                        (record!.gecKalmaDakika / 60).toStringAsFixed(1),
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11),
                      ),
                    if (label != null)
                      Text(label,
                          style: TextStyle(
                              color: (solidColor != null || isHalfSplit)
                                  ? Colors.white
                                  : Colors.green,
                              fontWeight: FontWeight.bold)),
                  ],
                ),
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
              child: Row(
                children: [
                  Expanded(child: Center(child: Text(t('mon'), style: const TextStyle(fontWeight: FontWeight.bold)))),
                  Expanded(child: Center(child: Text(t('tue'), style: const TextStyle(fontWeight: FontWeight.bold)))),
                  Expanded(child: Center(child: Text(t('wed'), style: const TextStyle(fontWeight: FontWeight.bold)))),
                  Expanded(child: Center(child: Text(t('thu'), style: const TextStyle(fontWeight: FontWeight.bold)))),
                  Expanded(child: Center(child: Text(t('fri'), style: const TextStyle(fontWeight: FontWeight.bold)))),
                  Expanded(child: Center(child: Text(t('sat'), style: const TextStyle(fontWeight: FontWeight.bold)))),
                  Expanded(child: Center(child: Text(t('sun'), style: const TextStyle(fontWeight: FontWeight.bold)))),
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Wrap(
                spacing: 12,
                runSpacing: 6,
                children: [
                  _legendDot(Colors.green, t('legendOvertime')),
                  _legendDot(Colors.red, t('legendLateAbsent')),
                  _legendDot(Colors.orange, t('legendLeave')),
                  _legendDot(Colors.blue, t('legendCompOff')),
                ],
              ),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _summaryGroupCard([
                    _summaryRow(Icons.calendar_view_day, Colors.grey,
                        t('weekdayHours'), totals['haftaIci']!.toStringAsFixed(2)),
                    _summaryRow(Icons.weekend, Colors.grey, t('saturdayHours'),
                        (totals['cumartesi']! - totals['telafiCumartesiSaat']! - totals['gitmedimCumartesiSaat']!).toStringAsFixed(2)),
                    _summaryRow(Icons.weekend, Colors.grey, t('sundayHours'),
                        (totals['pazar']! - totals['telafiPazarSaat']! - totals['gitmedimPazarSaat']!).toStringAsFixed(2)),
                    _summaryRow(Icons.event, Colors.grey, t('holidayHours'),
                        totals['resmiTatil']!.toStringAsFixed(2), showDivider: false),
                  ]),
                  if (totals['haftaIciEksikSaat']! > 0)
                    _summaryGroupCard([
                      _summaryRow(Icons.warning_amber, Colors.orange,
                          t('weekdayShortHours'),
                          totals['haftaIciEksikSaat']!.toStringAsFixed(2),
                          valueColor: Colors.orange, showDivider: false),
                    ]),
                  _summaryGroupCard([
                    _summaryRow(Icons.request_quote, Colors.grey, t('advanceTotal'),
                        '${totals['avans']!.toStringAsFixed(2)} TL',
                        showDivider: totals['sickDays']! > 0 ||
                            totals['absentDays']! > 0 ||
                            totals['unpaidDays']! > 0),
                    if (totals['sickDays']! > 0)
                      _summaryRow(Icons.sick, Colors.grey, t('sickDaysLabel'),
                          '${totals['sickDays']!.toStringAsFixed(0)} ${t('daySuffix')}',
                          showDivider: totals['absentDays']! > 0 || totals['unpaidDays']! > 0),
                    if (totals['absentDays']! > 0)
                      _summaryRow(Icons.person_off, Colors.grey, t('absentDaysLabel'),
                          '${totals['absentDays']!.toStringAsFixed(0)} ${t('daySuffix')}',
                          showDivider: totals['unpaidDays']! > 0),
                    if (totals['unpaidDays']! > 0)
                      _summaryRow(Icons.free_cancellation, Colors.grey,
                          t('unpaidLeaveDaysLabel'),
                          '${totals['unpaidDays']!.toStringAsFixed(0)} ${t('daySuffix')}',
                          showDivider: false),
                  ]),
                  if (unpaidDeduction > 0 ||
                      gecKalmaKesinti > 0 ||
                      telafiKesinti > 0 ||
                      gitmedimKesinti > 0)
                    _summaryGroupCard([
                      if (unpaidDeduction > 0)
                        _summaryRow(Icons.money_off, Colors.orange,
                            t('unpaidLeaveDeduction'),
                            '-${unpaidDeduction.toStringAsFixed(2)} TL',
                            valueColor: Colors.orange,
                            showDivider: gecKalmaKesinti > 0 || telafiKesinti > 0 || gitmedimKesinti > 0),
                      if (gecKalmaKesinti > 0)
                        _summaryRow(Icons.timer_off, Colors.red, t('lateDeduction'),
                            '-${gecKalmaKesinti.toStringAsFixed(2)} TL',
                            valueColor: Colors.red,
                            showDivider: telafiKesinti > 0 || gitmedimKesinti > 0),
                      if (telafiKesinti > 0)
                        _summaryRow(Icons.change_circle_outlined, Colors.blue,
                            t('compOffDeduction'),
                            '-${telafiKesinti.toStringAsFixed(2)} TL',
                            valueColor: Colors.blue,
                            showDivider: gitmedimKesinti > 0),
                      if (gitmedimKesinti > 0)
                        _summaryRow(Icons.event_busy, Colors.red, t('absentDeduction'),
                            '-${gitmedimKesinti.toStringAsFixed(2)} TL',
                            valueColor: Colors.red, showDivider: false),
                    ]),
                  _summaryGroupCard([
                    _summaryRow(Icons.receipt_long, Colors.grey,
                        t('normallyNetSalaryShort'), '${base30.toStringAsFixed(2)} TL'),
                    _summaryRow(Icons.description, Colors.grey,
                        '$daysInMonth ${t('daysNetSalaryShort')}',
                        '${baseForMonth.toStringAsFixed(2)} TL'),
                    _summaryRow(Icons.trending_up, Colors.green, t('overtimeExtraShort'),
                        '+${saatUcreti.toStringAsFixed(2)} TL',
                        valueColor: Colors.green, showDivider: false),
                  ]),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.indigo.shade900.withOpacity(0.4),
                          Colors.indigo.shade700.withOpacity(0.25),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(t('finalSalary'),
                            style: TextStyle(fontSize: 12, color: Colors.grey.shade400)),
                        const SizedBox(height: 4),
                        Text(
                          '${total.toStringAsFixed(2)} TL',
                          style: const TextStyle(
                              fontSize: 26, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
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
