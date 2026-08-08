import 'package:flutter/material.dart';
import 'models.dart';
import 'lang.dart';

class StartDateScreen extends StatefulWidget {
  final AppSettings settings;
  final void Function(AppSettings) onSave;

  const StartDateScreen({super.key, required this.settings, required this.onSave});

  @override
  State<StartDateScreen> createState() => _StartDateScreenState();
}

class _StartDateScreenState extends State<StartDateScreen> {
  DateTime? selectedDate;
  late TextEditingController izinHakkiCtrl;

  @override
  void initState() {
    super.initState();
    if (widget.settings.iseBaslamaTarihi != null) {
      selectedDate = DateTime.tryParse(widget.settings.iseBaslamaTarihi!);
    }
    izinHakkiCtrl =
        TextEditingController(text: widget.settings.yillikIzinHakki.toString());
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(1980),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => selectedDate = picked);
    }
  }

  void _save() {
    final s = widget.settings;
    final newSettings = AppSettings(
      employerType: s.employerType,
      hourlyRate: s.hourlyRate,
      monthlySalary: s.monthlySalary,
      standardMonthlyHours: s.standardMonthlyHours,
      multiplierHaftaIci: s.multiplierHaftaIci,
      multiplierCumartesi: s.multiplierCumartesi,
      multiplierPazar: s.multiplierPazar,
      multiplierResmiTatil: s.multiplierResmiTatil,
      maasHesapModu: s.maasHesapModu,
      brutMaasGirisi: s.brutMaasGirisi,
      netMaasGirisi: s.netMaasGirisi,
      manuelNetMaas: s.manuelNetMaas,
      haftaTatiliKesintileri: s.haftaTatiliKesintileri,
      resmiTatilHesapSekli: s.resmiTatilHesapSekli,
      netMaasHesapSekli: s.netMaasHesapSekli,
      raporluHesapSekli: s.raporluHesapSekli,
      themeMode: s.themeMode,
      iseBaslamaTarihi: selectedDate?.toIso8601String(),
      yillikIzinHakki:
          double.tryParse(izinHakkiCtrl.text.replaceAll(',', '.')) ?? 14,
    );
    widget.onSave(newSettings);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(t('startDateTitle'))),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(t('startDateLabel'),
                style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: _pickDate,
              child: Text(selectedDate == null
                  ? t('pickDate')
                  : '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'),
            ),
            const SizedBox(height: 24),
            Text(t('annualLeaveLabel'),
                style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: izinHakkiCtrl,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(labelText: t('exampleFourteen')),
            ),
            const SizedBox(height: 24),
            ElevatedButton(onPressed: _save, child: Text(t('save'))),
          ],
        ),
      ),
    );
  }
}
