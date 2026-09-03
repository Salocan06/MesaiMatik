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
  late TextEditingController notCtrl;
  late TextEditingController telafiSaatCtrl;
  String telafiGunu = 'cumartesi';
  late TextEditingController gitmedimSaatCtrl;
  String gitmedimGunu = 'cumartesi';

  @override
  void initState() {
    super.initState();
    type = widget.initial.type;
    resmiTatil = widget.initial.resmiTatil;
    hoursCtrl = TextEditingController(
        text: widget.initial.hours > 0 ? widget.initial.hours.toString() : '');
    gecKalmaCtrl = TextEditingController(
        text: widget.initial.gecKalmaDakika > 0
            ? (widget.initial.gecKalmaDakika / 60).toString()
            : '');
    avansCtrl = TextEditingController(
        text: widget.initial.avans > 0 ? widget.initial.avans.toString() : '');
    notCtrl = TextEditingController(text: widget.initial.not);
    telafiSaatCtrl = TextEditingController(
        text: widget.initial.telafiSaat > 0
            ? widget.initial.telafiSaat.toString()
            : '');
    telafiGunu = widget.initial.telafiGunu ?? 'cumartesi';
    gitmedimSaatCtrl = TextEditingController(
        text: widget.initial.gitmedimSaat > 0
            ? widget.initial.gitmedimSaat.toString()
            : '');
    gitmedimGunu = widget.initial.gitmedimGunu ?? 'cumartesi';
  }

  double _parse(String s) => double.tryParse(s.replaceAll(',', '.')) ?? 0;

  Future<void> _askDeductionDay({required bool forAbsence}) async {
    final result = await showDialog<String>(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text(t('day_compOffDayQuestion')),
        children: [
          SimpleDialogOption(
            onPressed: () => Navigator.pop(context, 'cumartesi'),
            child: Text(t('compOffSaturday')),
          ),
          SimpleDialogOption(
            onPressed: () => Navigator.pop(context, 'pazar'),
            child: Text(t('compOffSunday')),
          ),
        ],
      ),
    );
    if (result != null) {
      setState(() {
        if (forAbsence) {
          gitmedimGunu = result;
        } else {
          telafiGunu = result;
        }
      });
    }
  }

  void _save() {
    final record = DayRecord(
      type: type,
      hours: type == 'mesai' ? _parse(hoursCtrl.text) : 0,
      resmiTatil: resmiTatil,
      gecKalmaDakika: _parse(gecKalmaCtrl.text) * 60,
      avans: _parse(avansCtrl.text),
      not: notCtrl.text,
      telafiSaat: type == 'telafi' ? _parse(telafiSaatCtrl.text) : 0,
      telafiGunu: type == 'telafi' ? telafiGunu : null,
      gitmedimSaat: type == 'gitmedim' ? _parse(gitmedimSaatCtrl.text) : 0,
      gitmedimGunu: type == 'gitmedim' ? gitmedimGunu : null,
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
              onChanged: (v) async {
                setState(() => type = v!);
                await _askDeductionDay(forAbsence: true);
              },
              title: Text(t('day_absent')),
              contentPadding: EdgeInsets.zero,
            ),
            if (type == 'gitmedim')
              Padding(
                padding: const EdgeInsets.only(left: 32, bottom: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: gitmedimSaatCtrl,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(labelText: t('day_absentHours')),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          '${t('day_compOffDay')}: ${gitmedimGunu == 'pazar' ? t('compOffSunday') : t('compOffSaturday')}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextButton(
                          onPressed: () => _askDeductionDay(forAbsence: true),
                          child: Text(t('compOffChange')),
                        ),
                      ],
                    ),
                  ],
                ),
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
            RadioListTile<String>(
              value: 'telafi',
              groupValue: type,
              onChanged: (v) async {
                setState(() => type = v!);
                await _askDeductionDay(forAbsence: false);
              },
              title: Text(t('day_compOff')),
              contentPadding: EdgeInsets.zero,
            ),
            if (type == 'telafi')
              Padding(
                padding: const EdgeInsets.only(left: 32, bottom: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: telafiSaatCtrl,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(labelText: t('day_compOffHours')),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          '${t('day_compOffDay')}: ${telafiGunu == 'pazar' ? t('compOffSunday') : t('compOffSaturday')}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextButton(
                          onPressed: () => _askDeductionDay(forAbsence: false),
                          child: Text(t('compOffChange')),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            const Divider(),
            TextField(
              controller: gecKalmaCtrl,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(labelText: t('day_lateHours')),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: avansCtrl,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(labelText: t('day_advance')),
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
