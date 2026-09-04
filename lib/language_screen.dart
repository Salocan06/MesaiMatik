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

  Widget _langCard(String value, String flag, String label) {
    final selectedNow = selected == value;
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () => _apply(value),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: selectedNow
              ? Colors.indigo.withOpacity(0.12)
              : (Theme.of(context).brightness == Brightness.dark
                  ? Colors.white.withOpacity(0.04)
                  : Colors.black.withOpacity(0.03)),
          borderRadius: BorderRadius.circular(14),
          border: selectedNow ? Border.all(color: Colors.indigo.withOpacity(0.5)) : null,
        ),
        child: Row(
          children: [
            Text(flag, style: const TextStyle(fontSize: 22)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(label,
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: selectedNow ? FontWeight.w500 : FontWeight.normal)),
            ),
            Radio<String>(value: value, groupValue: selected, onChanged: (v) => _apply(v!)),
          ],
        ),
      ),
    );
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
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(t('selectLanguage'),
                  style: TextStyle(fontSize: 15, color: Colors.grey.shade500)),
            ),
            _langCard('tr', 'ğŸ‡¹ğŸ‡·', 'TÃ¼rkÃ§e'),
            _langCard('en', 'ğŸ‡¬ğŸ‡§', 'English'),
            _langCard('ur', 'ğŸ‡µğŸ‡°', 'Ø§Ø±Ø¯Ùˆ (Urduca)'),
            _langCard('ne', 'ğŸ‡³ğŸ‡µ', 'à¤¨à¥‡à¤ªà¤¾à¤²à¥€ (Nepalce)'),
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
