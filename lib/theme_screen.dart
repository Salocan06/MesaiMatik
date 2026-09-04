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

  Widget _themeCard({
    required String value,
    required IconData icon,
    required String title,
    String? subtitle,
  }) {
    final selected = mode == value;
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () => _apply(value),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: selected
              ? Colors.indigo.withOpacity(0.12)
              : (Theme.of(context).brightness == Brightness.dark
                  ? Colors.white.withOpacity(0.04)
                  : Colors.black.withOpacity(0.03)),
          borderRadius: BorderRadius.circular(14),
          border: selected ? Border.all(color: Colors.indigo.withOpacity(0.5)) : null,
        ),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: selected ? Colors.indigo : Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 19, color: selected ? Colors.white : Colors.grey.shade500),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: TextStyle(
                          fontSize: 14, fontWeight: selected ? FontWeight.w500 : FontWeight.normal)),
                  if (subtitle != null)
                    Text(subtitle,
                        style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
                ],
              ),
            ),
            Radio<String>(value: value, groupValue: mode, onChanged: (v) => _apply(v!)),
          ],
        ),
      ),
    );
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
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(t('themeSelection'),
                  style: TextStyle(fontSize: 15, color: Colors.grey.shade500)),
            ),
            _themeCard(
              value: 'system',
              icon: Icons.smartphone,
              title: t('themeSystem'),
              subtitle: t('themeSystemSubtitle'),
            ),
            _themeCard(
              value: 'light',
              icon: Icons.light_mode_outlined,
              title: t('themeLight'),
            ),
            _themeCard(
              value: 'dark',
              icon: Icons.dark_mode_outlined,
              title: t('themeDark'),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _save,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo),
                child: Text(t('save')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
