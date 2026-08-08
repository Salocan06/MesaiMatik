import 'package:flutter/material.dart';
import 'models.dart';
import 'lang.dart';

class ThemeScreen extends StatefulWidget {
  final AppSettings settings;
  final void Function(AppSettings) onSave;

  const ThemeScreen({super.key, required this.settings, required this.onSave});

  @override
  State<ThemeScreen> createState() => _ThemeScreenState();
}

class _ThemeScreenState extends State<ThemeScreen> {
  late String mode;

  @override
  void initState() {
    super.initState();
    mode = widget.settings.themeMode;
  }

  void _apply(String newMode) {
    setState(() => mode = newMode);
    themeNotifier.value = themeModeFromString(newMode);
  }

  void _save() {
    final newSettings = AppSettings(
      employerType: widget.settings.employerType,
      hourlyRate: widget.settings.hourlyRate,
      monthlySalary: widget.settings.monthlySalary,
      standardMonthlyHours: widget.settings.standardMonthlyHours,
      multiplierHaftaIci: widget.settings.multiplierHaftaIci,
      multiplierCumartesi: widget.settings.multiplierCumartesi,
      multiplierPazar: widget.settings.multiplierPazar,
      multiplierResmiTatil: widget.settings.multiplierResmiTatil,
      maasHesapModu: widget.settings.maasHesapModu,
      brutMaasGirisi: widget.settings.brutMaasGirisi,
      netMaasGirisi: widget.settings.netMaasGirisi,
      manuelNetMaas: widget.settings.manuelNetMaas,
      haftaTatiliKesintileri: widget.settings.haftaTatiliKesintileri,
      resmiTatilHesapSekli: widget.settings.resmiTatilHesapSekli,
      netMaasHesapSekli: widget.settings.netMaasHesapSekli,
      raporluHesapSekli: widget.settings.raporluHesapSekli,
      themeMode: mode,
      iseBaslamaTarihi: widget.settings.iseBaslamaTarihi,
      yillikIzinHakki: widget.settings.yillikIzinHakki,
    );
    widget.onSave(newSettings);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(t('visualSettingsTitle'))),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(t('themeSelection'), style: const TextStyle(fontWeight: FontWeight.bold)),
            RadioListTile<String>(
              value: 'system',
              groupValue: mode,
              onChanged: (v) => _apply(v!),
              title: Text(t('themeSystem')),
            ),
            RadioListTile<String>(
              value: 'light',
              groupValue: mode,
              onChanged: (v) => _apply(v!),
              title: Text(t('themeLight')),
            ),
            RadioListTile<String>(
              value: 'dark',
              groupValue: mode,
              onChanged: (v) => _apply(v!),
              title: Text(t('themeDark')),
            ),
            const SizedBox(height: 24),
            ElevatedButton(onPressed: _save, child: Text(t('save'))),
          ],
        ),
      ),
    );
  }
}
