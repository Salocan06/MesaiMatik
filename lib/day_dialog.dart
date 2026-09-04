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

  Widget _typeOption({
    required String value,
    required IconData icon,
    required Color color,
    required String label,
    required VoidCallback onSelected,
    Widget? extra,
  }) {
    final selected = type == value;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: selected
            ? color.withOpacity(0.12)
            : (Theme.of(context).brightness == Brightness.dark
                ? Colors.white.withOpacity(0.04)
                : Colors.black.withOpacity(0.03)),
        borderRadius: BorderRadius.circular(12),
        border: selected ? Border.all(color: color.withOpacity(0.5), width: 1) : null,
      ),
      child: Column(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: onSelected,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: color.withOpacity(selected ? 0.9 : 0.15),
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: Icon(icon,
                        size: 16, color: selected ? Colors.white : color),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(label,
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: selected ? FontWeight.w500 : FontWeight.normal)),
                  ),
                  Radio<String>(
                    value: value,
                    groupValue: type,
                    onChanged: (_) => onSelected(),
                  ),
                ],
              ),
            ),
          ),
          if (selected && extra != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: extra,
            ),
        ],
      ),
    );
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
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white.withOpacity(0.04)
                    : Colors.black.withOpacity(0.03),
                borderRadius: BorderRadius.circular(12),
              ),
              child: CheckboxListTile(
                value: resmiTatil,
                onChanged: (v) => setState(() => resmiTatil = v ?? false),
                title: Text(t('day_officialHoliday'), style: const TextStyle(fontSize: 13)),
                controlAffinity: ListTileControlAffinity.leading,
                dense: true,
              ),
            ),
            const SizedBox(height: 12),
            Text(t('dayStatusLabel'),
                style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
            const SizedBox(height: 8),

            _typeOption(
              value: 'mesai',
              icon: Icons.add_alarm,
              color: Colors.indigo,
              label: t('day_overtime'),
              onSelected: () => setState(() => type = 'mesai'),
              extra: TextField(
                controller: hoursCtrl,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(labelText: t('day_overtimeHours')),
              ),
            ),
            _typeOption(
              value: 'gitmedim',
              icon: Icons.person_off,
              color: Colors.red,
              label: t('day_absent'),
              onSelected: () async {
                setState(() => type = 'gitmedim');
                await _askDeductionDay(forAbsence: true);
              },
              extra: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: gitmedimSaatCtrl,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(labelText: t('day_absentHours')),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${t('day_compOffDay')}: ${gitmedimGunu == 'pazar' ? t('compOffSunday') : t('compOffSaturday')}',
                          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
                        ),
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
            _typeOption(
              value: 'raporlu',
              icon: Icons.local_hospital_outlined,
              color: Colors.orange,
              label: t('day_sick'),
              onSelected: () => setState(() => type = 'raporlu'),
            ),
            _typeOption(
              value: 'ucretliIzin',
              icon: Icons.beach_access,
              color: Colors.green,
              label: t('day_paidLeave'),
              onSelected: () => setState(() => type = 'ucretliIzin'),
            ),
            _typeOption(
              value: 'ucretsizIzin',
              icon: Icons.event_busy,
              color: Colors.amber,
              label: t('day_unpaidLeave'),
              onSelected: () => setState(() => type = 'ucretsizIzin'),
            ),
            _typeOption(
              value: 'telafi',
              icon: Icons.swap_horiz,
              color: Colors.purple,
              label: t('day_compOff'),
              onSelected: () async {
                setState(() => type = 'telafi');
                await _askDeductionDay(forAbsence: false);
              },
              extra: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: telafiSaatCtrl,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(labelText: t('day_compOffHours')),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${t('day_compOffDay')}: ${telafiGunu == 'pazar' ? t('compOffSunday') : t('compOffSaturday')}',
                          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
                        ),
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

            const SizedBox(height: 8),
            Text(t('extraInfoLabel'),
                style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
            const SizedBox(height: 8),
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
