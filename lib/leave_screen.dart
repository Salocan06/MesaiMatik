import 'package:flutter/material.dart';
import 'models.dart';
import 'lang.dart';

class LeaveScreen extends StatefulWidget {
  final AppSettings settings;
  final Map<String, DayRecord> records;
  final int initialYear;

  const LeaveScreen({
    super.key,
    required this.settings,
    required this.records,
    required this.initialYear,
  });

  @override
  State<LeaveScreen> createState() => _LeaveScreenState();
}

class _LeaveScreenState extends State<LeaveScreen> {
  late int year;

  @override
  void initState() {
    super.initState();
    year = widget.initialYear;
  }

  List<String> _leaveDatesForYear() {
    final list = <String>[];
    widget.records.forEach((key, r) {
      if (r.type == 'ucretliIzin') {
        final d = DateTime.parse(key);
        if (d.year == year) {
          list.add(key);
        }
      }
    });
    list.sort();
    return list;
  }

  Widget _statBox(String value, String label, Color color) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Column(
          children: [
            Text(value,
                style: TextStyle(
                    fontSize: 20, fontWeight: FontWeight.w500, color: color)),
            const SizedBox(height: 4),
            Text(label, style: TextStyle(fontSize: 11, color: color)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dates = _leaveDatesForYear();
    final used = dates.length.toDouble();
    final remaining = widget.settings.yillikIzinHakki - used;

    String hizmetSuresi = '-';
    if (widget.settings.iseBaslamaTarihi != null) {
      final start = DateTime.tryParse(widget.settings.iseBaslamaTarihi!);
      if (start != null) {
        final now = DateTime.now();
        final totalDays = now.difference(start).inDays;
        final years = totalDays ~/ 365;
        hizmetSuresi = '$years ${t('yearsSuffix')}';
      }
    }

    return Scaffold(
      appBar: AppBar(title: Text(t('leaveScreenTitle'))),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: () => setState(() => year -= 1),
                ),
                Text('$year',
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w500)),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: () => setState(() => year += 1),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white.withOpacity(0.04)
                    : Colors.black.withOpacity(0.03),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                children: [
                  Icon(Icons.work_outline, size: 16, color: Colors.grey.shade500),
                  const SizedBox(width: 8),
                  Text('${t('serviceDuration')} $hizmetSuresi',
                      style: TextStyle(fontSize: 13, color: Colors.grey.shade500)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _statBox(widget.settings.yillikIzinHakki.toStringAsFixed(0),
                    t('annualLeaveRightShort'), Colors.grey),
                const SizedBox(width: 10),
                _statBox(used.toStringAsFixed(0), t('usedDaysShort'), Colors.orange),
                const SizedBox(width: 10),
                _statBox(remaining.toStringAsFixed(0), t('remainingDaysShort'),
                    remaining < 0 ? Colors.red : Colors.green),
              ],
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(t('usedLeaveDaysTitle'),
                  style: TextStyle(fontSize: 15, color: Colors.grey.shade500)),
            ),
            Expanded(
              child: dates.isEmpty
                  ? Center(
                      child: Text(t('noLeaveUsedThisYear'),
                          style: TextStyle(color: Colors.grey.shade500)))
                  : Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white.withOpacity(0.04)
                            : Colors.black.withOpacity(0.03),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListView.separated(
                        itemCount: dates.length,
                        separatorBuilder: (context, i) => Divider(
                            height: 0.5, color: Theme.of(context).dividerColor.withOpacity(0.3)),
                        itemBuilder: (context, i) {
                          return ListTile(
                            leading: Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(9),
                              ),
                              child: const Icon(Icons.beach_access,
                                  size: 16, color: Colors.green),
                            ),
                            title: Text(dates[i], style: const TextStyle(fontSize: 13)),
                          );
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
