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
  bool manualEntry = false;

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

  Map<String, int> _serviceDuration() {
    if (selectedDate == null) return {'years': 0, 'months': 0, 'days': 0};
    final now = DateTime.now();
    int years = now.year - selectedDate!.year;
    int months = now.month - selectedDate!.month;
    int days = now.day - selectedDate!.day;
    if (days < 0) {
      final prevMonth = DateTime(now.year, now.month, 0);
      days += prevMonth.day;
      months -= 1;
    }
    if (months < 0) {
      months += 12;
      years -= 1;
    }
    if (years < 0) years = 0;
    return {'years': years, 'months': months, 'days': days};
  }

  double _autoLeaveEntitlement(int years) {
    if (years >= 15) return 26;
    if (years >= 5) return 20;
    return 14;
  }

  void _save() {
    final s = widget.settings;
    final duration = _serviceDuration();
    final leaveValue = manualEntry
        ? (double.tryParse(izinHakkiCtrl.text.replaceAll(',', '.')) ?? 14)
        : _autoLeaveEntitlement(duration['years']!);
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
      language: s.language,
      iseBaslamaTarihi: selectedDate?.toIso8601String(),
      yillikIzinHakki: leaveValue,
      pinCode: s.pinCode,
    );
    widget.onSave(newSettings);
    Navigator.pop(context);
  }

  Widget _sectionLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 4),
      child: Text(text, style: TextStyle(fontSize: 15, color: Colors.grey.shade500)),
    );
  }

  Widget _miniStat(String value, String label) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.white.withOpacity(0.06)
              : Colors.black.withOpacity(0.04),
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          children: [
            Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
            const SizedBox(height: 2),
            Text(label, style: TextStyle(fontSize: 10, color: Colors.grey.shade500)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final duration = _serviceDuration();
    final months = monthNames();
    final autoLeave = _autoLeaveEntitlement(duration['years']!);
    final dateText = selectedDate == null
        ? t('pickDate')
        : '${selectedDate!.day} ${months[selectedDate!.month - 1]} ${selectedDate!.year}';

    return Scaffold(
      appBar: AppBar(title: Text(t('startDateTitle'))),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionLabel(t('startDateLabel')),
            InkWell(
              onTap: _pickDate,
              borderRadius: BorderRadius.circular(14),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.withOpacity(0.25), width: 0.5),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Colors.indigo.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.event, size: 18, color: Colors.indigo),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(t('startDateLabel'),
                              style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
                          const SizedBox(height: 2),
                          Text(dateText,
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                        ],
                      ),
                    ),
                    Icon(Icons.chevron_right, size: 18, color: Colors.grey.shade500),
                  ],
                ),
              ),
            ),
            if (selectedDate != null) ...[
              _sectionLabel(t('serviceDurationLabel')),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.work_outline, size: 16, color: Colors.green),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            '$dateText ${t('sinceWorkingLabel')}',
                            style: const TextStyle(fontSize: 13, color: Colors.green),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        _miniStat('${duration['years']}', t('yearsSuffix')),
                        const SizedBox(width: 8),
                        _miniStat('${duration['months']}', t('monthsSuffix')),
                        const SizedBox(width: 8),
                        _miniStat('${duration['days']}', t('daySuffix')),
                      ],
                    ),
                  ],
                ),
              ),
            ],
            _sectionLabel(t('annualLeaveSectionLabel')),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.indigo.withOpacity(0.10),
                border: Border.all(color: Colors.indigo.withOpacity(0.3), width: 0.5),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.indigo,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.auto_fix_high, size: 18, color: Colors.white),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(t('autoCalculatedLeave'),
                            style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
                        const SizedBox(height: 2),
                        Text(
                          manualEntry
                              ? '${izinHakkiCtrl.text} ${t('daySuffix')}'
                              : '${autoLeave.toStringAsFixed(0)} ${t('daySuffix')}',
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white.withOpacity(0.04)
                    : Colors.black.withOpacity(0.03),
                borderRadius: BorderRadius.circular(12),
              ),
              child: SwitchListTile(
                value: manualEntry,
                onChanged: (v) => setState(() => manualEntry = v),
                title: Text(t('manualLeaveToggle'), style: const TextStyle(fontSize: 13)),
                activeColor: Colors.indigo,
                dense: true,
              ),
            ),
            if (manualEntry) ...[
              const SizedBox(height: 10),
              TextField(
                controller: izinHakkiCtrl,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(labelText: t('annualLeaveLabel')),
                onChanged: (_) => setState(() {}),
              ),
            ],
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _save,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo),
                child: Text(t('save')),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white.withOpacity(0.04)
                    : Colors.black.withOpacity(0.03),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.balance, size: 15, color: Colors.grey.shade500),
                      const SizedBox(width: 8),
                      Text(t('legalLeaveTitle'),
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  _legalRow(t('legalLeaveTier1'), '14 ${t('daySuffix')}'),
                  _legalRow(t('legalLeaveTier2'), '20 ${t('daySuffix')}'),
                  _legalRow(t('legalLeaveTier3'), '26 ${t('daySuffix')}', showDivider: false),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _legalRow(String label, String value, {bool showDivider = true}) {
    return Container(
      decoration: BoxDecoration(
        border: showDivider
            ? Border(
                bottom: BorderSide(
                    color: Theme.of(context).dividerColor.withOpacity(0.3), width: 0.5))
            : null,
      ),
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(label, style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
          ),
          Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
