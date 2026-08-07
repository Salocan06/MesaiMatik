import 'package:flutter/material.dart';
import 'models.dart';
import 'lang.dart';

class LanguageScreen extends StatefulWidget {
  final AppSettings settings;
  final void Function(AppSettings) onSave;

  const LanguageScreen({super.key, required this.settings, required this.onSave});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  late String selected;

  @override
  void initState() {
    super.initState();
    selected = widget.settings.language;
  }

  void _apply(String lang) {
    setState(() => selected = lang);
    languageNotifier.value = lang;
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
      language: selected,
      iseBaslamaTarihi: s.iseBaslamaTarihi,
      yillikIzinHakki: s.yillikIzinHakki,
      pinCode: s.pinCode,
    );
    widget.onSave(newSettings);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(t('languageScreenTitle'))),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(t('selectLanguage'),
                style: const TextStyle(fontWeight: FontWeight.bold)),
            RadioListTile<String>(
              value: 'tr',
              groupValue: selected,
              onChanged: (v) => _apply(v!),
              title: const Text('Turkce'),
            ),
            RadioListTile<String>(
              value: 'ur',
              groupValue: selected,
              onChanged: (v) => _apply(v!),
              title: const Text('اردو (Urduca)'),
            ),
            RadioListTile<String>(
              value: 'ne',
              groupValue: selected,
              onChanged: (v) => _apply(v!),
              title: const Text('नेपाली (Nepalce)'),
            ),
            const SizedBox(height: 24),
            ElevatedButton(onPressed: _save, child: Text(t('save'))),
          ],
        ),
      ),
    );
  }
}