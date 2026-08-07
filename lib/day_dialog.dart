import 'package:flutter/material.dart';
import 'models.dart';
import 'lang.dart';

class DayEntryDialog extends StatefulWidget {
  final DateTime day;
  final DayRecord initial;

  const DayEntryDialog({super.key, required this.day, required this.initial});

  @override
  State<DayEntryDialog> createState() => _DayEntryDialogState();
}

class _DayEntryDialogState extends State<DayEntryDialog> {
  late String type;
  late bool resmiTatil;
  late TextEditingController hoursCtrl;
  late TextEditingController gecKalmaCtrl;
  late TextEditingController avansCtrl;
  late TextEditingController bahsisCtrl;
  late TextEditingController notCtrl;

  @override
  void initState() {
    super.initState();
    type = widget.initial.type;
    resmiTatil = widget.initial.resmiTatil;
    hoursCtrl = TextEditingController(
        text: widget.initial.hours > 0 ? widget.initial.hours.toString() : '');
    gecKalmaCtrl = TextEditingController(
        text: widget.initial.gecKalmaDakika > 0
            ? widget.initial.gecKalmaDakika.toString()
            : '');
    avansCtrl = TextEditingController(
        text: widget.initial.avans > 0 ? widget.initial.avans.toString() : '');
    bahsisCtrl = TextEditingController(
        text: widget.initial.bahsis > 0 ? widget.initial.bahsis.toString() : '');
    notCtrl = TextEditingController(text: widget.initial.not);
  }

  double _parse(String s) => double.tryParse(s.replaceAll(',', '.')) ?? 0;

  void _save() {
    final record = DayRecord(
      type: type,
      hours: type == 'mesai' ? _parse(hoursCtrl.text) : 0,
      resmiTatil: resmiTatil,
      gecKalmaDakika: _parse(gecKalmaCtrl.text),
      avans: _parse(avansCtrl.text),
      bahsis: _parse(bahsisCtrl.text),
      not: notCtrl.text,
    );
    Navigator.pop(context, record);
  }

  void _delete() {
    Navigator.pop(context, 'DELETE');
  }

  @override
  Widget build(BuildContext context) {
    final months = monthNames();
    final title = '${widget.day.day} ${months[widget.day.month - 1]} ${widget.day.year}';

    return AlertDialog(
      title: Text(title),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            CheckboxListTile(
              value: resmiTatil,
              onChanged: (v) => setState(() => resmiTatil = v ?? false),
              title: Text(t('day_officialHoliday')),
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
            ),
            const Divider(),
            RadioListTile<String>(
              value: 'mesai',
              groupValue: type,
              onChanged: (v) => setState(() => type = v!),
              title: Text(t('day_overtime')),
              contentPadding: EdgeInsets.zero,
            ),
            if (type == 'mesai')
              Padding(
                padding: const EdgeInsets.only(left: 32, bottom: 8),
                child: TextField(
                  controller: hoursCtrl,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(labelText: t('day_overtimeHours')),
                ),
              ),
            RadioListTile<String>(
              value: 'gitmedim',
              groupValue: type,
              onChanged: (v) => setState(() => type = v!),
              title: Text(t('day_absent')),
              contentPadding: EdgeInsets.zero,
            ),
            RadioListTile<String>(
              value: 'raporlu',
              groupValue: type,
              onChanged: (v) => setState(() => type = v!),
              title: Text(t('day_sick')),
              contentPadding: EdgeInsets.zero,
            ),
            RadioListTile<String>(
              value: 'ucretliIzin',
              groupValue: type,
              onChanged: (v) => setState(() => type = v!),
              title: Text(t('day_paidLeave')),
              contentPadding: EdgeInsets.zero,
            ),
            RadioListTile<String>(
              value: 'ucretsizIzin',
              groupValue: type,
              onChanged: (v) => setState(() => type = v!),
              title: Text(t('day_unpaidLeave')),
              contentPadding: EdgeInsets.zero,
            ),
            const Divider(),
            TextField(
              controller: gecKalmaCtrl,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(labelText: t('day_lateMinutes')),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: avansCtrl,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(labelText: t('day_advance')),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: bahsisCtrl,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(labelText: t('day_tip')),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: notCtrl,
              decoration: InputDecoration(labelText: t('day_note')),
              maxLines: 2,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: _delete, child: Text(t('delete'))),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(t('cancel')),
        ),
        ElevatedButton(onPressed: _save, child: Text(t('ok'))),
      ],
    );
  }
}