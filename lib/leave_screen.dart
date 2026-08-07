import 'package:flutter/material.dart';
import 'models.dart';

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
        hizmetSuresi = '$years yil';
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Yillik Izin Takibi')),
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
                        fontSize: 20, fontWeight: FontWeight.bold)),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: () => setState(() => year += 1),
                ),
              ],
            ),
            const Divider(),
            Text('Hizmet suresi: $hizmetSuresi'),
            const SizedBox(height: 8),
            Text('Yillik izin hakki: ${widget.settings.yillikIzinHakki.toStringAsFixed(0)} gun'),
            Text('Kullanilan: ${used.toStringAsFixed(0)} gun'),
            Text(
              'Kalan: ${remaining.toStringAsFixed(0)} gun',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: remaining < 0 ? Colors.red : Colors.green,
              ),
            ),
            const Divider(),
            const Text('Kullanilan izin gunleri',
                style: TextStyle(fontWeight: FontWeight.bold)),
            Expanded(
              child: dates.isEmpty
                  ? const Center(child: Text('Bu yil izin kullanilmadi'))
                  : ListView.builder(
                      itemCount: dates.length,
                      itemBuilder: (context, i) {
                        return ListTile(
                          leading: const Icon(Icons.beach_access),
                          title: Text(dates[i]),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}