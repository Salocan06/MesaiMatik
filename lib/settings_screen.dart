import 'package:flutter/material.dart';
import 'models.dart';
import 'lang.dart';

class SettingsScreen extends StatefulWidget {
  final AppSettings settings;
  final int month;
  final int year;
  final Map<int, TaxYearSettings> taxYears;
  final void Function(AppSettings) onSave;

  const SettingsScreen({
    super.key,
    required this.settings,
    required this.month,
    required this.year,
    required this.taxYears,
    required this.onSave,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  int selectedTab = 0;

  late String employerType;
  late String maasHesapModu;
  late String resmiTatilHesapSekli;
  late String netMaasHesapSekli;
  late String raporluHesapSekli;
  late bool haftaTatiliKesintileri;

  late TextEditingController hourlyRateCtrl;
  late TextEditingController standardHoursCtrl;
  late TextEditingController mHaftaIciCtrl;
  late TextEditingController mCumartesiCtrl;
  late TextEditingController mPazarCtrl;
  late TextEditingController mResmiTatilCtrl;
  late TextEditingController brutMaasCtrl;
  late TextEditingController netMaasCtrl;
  late TextEditingController manuelNetMaasCtrl;

  TaxYearSettings get tax => taxForYear(widget.taxYears, widget.year);

  @override
  void initState() {
    super.initState();
    final s = widget.settings;
    employerType = s.employerType;
    maasHesapModu = s.maasHesapModu;
    resmiTatilHesapSekli = s.resmiTatilHesapSekli;
    netMaasHesapSekli = s.netMaasHesapSekli;
    raporluHesapSekli = s.raporluHesapSekli;
    haftaTatiliKesintileri = s.haftaTatiliKesintileri;

    hourlyRateCtrl = TextEditingController(text: s.hourlyRate.toString());
    standardHoursCtrl = TextEditingController(text: s.standardMonthlyHours.toString());
    mHaftaIciCtrl = TextEditingController(text: s.multiplierHaftaIci.toString());
    mCumartesiCtrl = TextEditingController(text: s.multiplierCumartesi.toString());
    mPazarCtrl = TextEditingController(text: s.multiplierPazar.toString());
    mResmiTatilCtrl = TextEditingController(text: s.multiplierResmiTatil.toString());
    brutMaasCtrl = TextEditingController(text: s.brutMaasGirisi.toString());
    netMaasCtrl = TextEditingController(text: s.netMaasGirisi.toString());
    manuelNetMaasCtrl = TextEditingController(text: s.manuelNetMaas.toString());
  }

  double _p(String v) => double.tryParse(v.replaceAll(',', '.')) ?? 0;

  AppSettings _buildSettings() {
    return AppSettings(
      employerType: employerType,
      hourlyRate: _p(hourlyRateCtrl.text),
      monthlySalary: widget.settings.monthlySalary,
      standardMonthlyHours: _p(standardHoursCtrl.text),
      multiplierHaftaIci: _p(mHaftaIciCtrl.text),
      multiplierCumartesi: _p(mCumartesiCtrl.text),
      multiplierPazar: _p(mPazarCtrl.text),
      multiplierResmiTatil: _p(mResmiTatilCtrl.text),
      maasHesapModu: maasHesapModu,
      brutMaasGirisi: _p(brutMaasCtrl.text),
      netMaasGirisi: _p(netMaasCtrl.text),
      manuelNetMaas: _p(manuelNetMaasCtrl.text),
      haftaTatiliKesintileri: haftaTatiliKesintileri,
      resmiTatilHesapSekli: resmiTatilHesapSekli,
      netMaasHesapSekli: netMaasHesapSekli,
      raporluHesapSekli: raporluHesapSekli,
      themeMode: widget.settings.themeMode,
      language: widget.settings.language,
      iseBaslamaTarihi: widget.settings.iseBaslamaTarihi,
      yillikIzinHakki: widget.settings.yillikIzinHakki,
      pinCode: widget.settings.pinCode,
    );
  }

  void _save() {
    widget.onSave(_buildSettings());
    Navigator.pop(context);
  }

  int get daysInSelectedMonth =>
      DateTime(widget.year, widget.month + 1, 0).day;

  @override
  Widget build(BuildContext context) {
    final preview = _buildSettings();
    final months = monthNames();

    return Scaffold(
      appBar: AppBar(title: Text(t('salaryEmployerSettingsTitle'))),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              '${widget.year} ${months[widget.month - 1]}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () => setState(() => selectedTab = 0),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    color: selectedTab == 0
                        ? Colors.indigo
                        : Colors.grey.shade800,
                    child: Text(t('salaryTab'), textAlign: TextAlign.center),
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: () => setState(() => selectedTab = 1),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    color: selectedTab == 1
                        ? Colors.indigo
                        : Colors.grey.shade800,
                    child: Text(t('employerTab'), textAlign: TextAlign.center),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: selectedTab == 0
                  ? _buildMaasAyarlari(preview)
                  : _buildIsverenAyarlari(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(t('iptalBtn')),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _save,
                    child: Text(t('save')),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(child: Text(label)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildMaasAyarlari(AppSettings preview) {
    final daysInMonth = daysInSelectedMonth;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(t('workType'), style: const TextStyle(fontWeight: FontWeight.bold)),
        RadioListTile<String>(
          value: 'saatlik',
          groupValue: employerType,
          onChanged: (v) => setState(() => employerType = v!),
          title: Text(t('hourlyPaid')),
          contentPadding: EdgeInsets.zero,
        ),
        RadioListTile<String>(
          value: 'aylik',
          groupValue: employerType,
          onChanged: (v) => setState(() => employerType = v!),
          title: Text(t('monthlyPaid')),
          contentPadding: EdgeInsets.zero,
        ),
        const Divider(),
        if (employerType == 'saatlik') ...[
          Text(
            t('hourlyInfoText'),
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: hourlyRateCtrl,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(labelText: t('hourlyRateLabel')),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: standardHoursCtrl,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(labelText: t('standardHoursLabel')),
            onChanged: (_) => setState(() {}),
          ),
        ] else ...[
          Text(t('salaryCalcMethod'),
              style: const TextStyle(fontWeight: FontWeight.bold)),
          RadioListTile<String>(
            value: 'brut',
            groupValue: maasHesapModu,
            onChanged: (v) => setState(() => maasHesapModu = v!),
            title: Text(t('calcFromGross')),
            contentPadding: EdgeInsets.zero,
          ),
          RadioListTile<String>(
            value: 'net',
            groupValue: maasHesapModu,
            onChanged: (v) => setState(() => maasHesapModu = v!),
            title: Text(t('calcFromNet')),
            contentPadding: EdgeInsets.zero,
          ),
          RadioListTile<String>(
            value: 'manuel',
            groupValue: maasHesapModu,
            onChanged: (v) => setState(() => maasHesapModu = v!),
            title: Text(t('calcManual')),
            contentPadding: EdgeInsets.zero,
          ),
          const SizedBox(height: 12),
          if (maasHesapModu == 'brut') ...[
            TextField(
              controller: brutMaasCtrl,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(labelText: t('grossSalaryLabel')),
              onChanged: (_) => setState(() {}),
            ),
            const Divider(),
            _infoRow(t('sgkShare'), preview.sgkIsciPayi(tax).toStringAsFixed(2)),
            _infoRow(t('unemploymentShare'), preview.issizlikPayi(tax).toStringAsFixed(2)),
            _infoRow(t('incomeTaxBase'), preview.gelirVergisiMatrahi(tax).toStringAsFixed(2)),
            _infoRow(t('incomeTax'), preview.gelirVergisi(tax).toStringAsFixed(2)),
            _infoRow(t('stampTax'), preview.damgaVergisi(tax).toStringAsFixed(2)),
            _infoRow(t('totalDeductions'), preview.kesintilerToplami(tax).toStringAsFixed(2)),
            _infoRow(t('netSalaryLabel30'), preview.hesaplananNetMaas(tax).toStringAsFixed(2)),
          ] else if (maasHesapModu == 'net') ...[
            TextField(
              controller: netMaasCtrl,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(labelText: t('netSalaryLabel30')),
              onChanged: (_) => setState(() {}),
            ),
          ] else ...[
            TextField(
              controller: manuelNetMaasCtrl,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(labelText: t('netSalaryManualLabel')),
              onChanged: (_) => setState(() {}),
            ),
          ],
        ],
        const Divider(),
        SwitchListTile(
          value: haftaTatiliKesintileri,
          onChanged: (v) => setState(() => haftaTatiliKesintileri = v),
          title: Text(t('weekendDeductions')),
          contentPadding: EdgeInsets.zero,
        ),
        const Divider(),
        Text(t('overtimeMultipliersTitle'),
            style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextField(
          controller: mHaftaIciCtrl,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(labelText: t('weekdayMultiplierLabel')),
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: mCumartesiCtrl,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(labelText: t('saturdayMultiplierLabel')),
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: mPazarCtrl,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(labelText: t('sundayMultiplierLabel')),
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: mResmiTatilCtrl,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(labelText: t('holidayMultiplierLabel')),
          onChanged: (_) => setState(() {}),
        ),
        const Divider(),
        _infoRow(t('hourlyRateResult'), preview.hourlyRateForCalc(tax).toStringAsFixed(2)),
        _infoRow(t('weekdayHourlyRate'),
            (preview.hourlyRateForCalc(tax) * preview.multiplierHaftaIci).toStringAsFixed(2)),
        _infoRow(t('saturdayHourlyRate'),
            (preview.hourlyRateForCalc(tax) * preview.multiplierCumartesi).toStringAsFixed(2)),
        _infoRow(t('sundayHourlyRate'),
            (preview.hourlyRateForCalc(tax) * preview.multiplierPazar).toStringAsFixed(2)),
        _infoRow(t('holidayHourlyRate'),
            (preview.hourlyRateForCalc(tax) * preview.multiplierResmiTatil).toStringAsFixed(2)),
        const SizedBox(height: 8),
        Text(t('monthlyNetSalaryText').replaceAll('%d', '$daysInMonth') +
            '${preview.baseMonthlyEarningForMonth(daysInMonth, tax).toStringAsFixed(2)} TL'),
      ],
    );
  }

  Widget _buildIsverenAyarlari() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          t('employerHolidayQuestion'),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        RadioListTile<String>(
          value: 'gunlukEkUcret',
          groupValue: resmiTatilHesapSekli,
          onChanged: (v) => setState(() => resmiTatilHesapSekli = v!),
          title: Text(t('holidayOptionExtraDay')),
          contentPadding: EdgeInsets.zero,
        ),
        RadioListTile<String>(
          value: 'tamamenFazlaMesai',
          groupValue: resmiTatilHesapSekli,
          onChanged: (v) => setState(() => resmiTatilHesapSekli = v!),
          title: Text(t('holidayOptionOvertime')),
          contentPadding: EdgeInsets.zero,
        ),
        const Divider(),
        Text(
          t('employerNetSalaryQuestion'),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        RadioListTile<String>(
          value: 'sabit30Gun',
          groupValue: netMaasHesapSekli,
          onChanged: (v) => setState(() => netMaasHesapSekli = v!),
          title: Text(t('fixedSalaryOption')),
          contentPadding: EdgeInsets.zero,
        ),
        RadioListTile<String>(
          value: 'gunSayisinaGore',
          groupValue: netMaasHesapSekli,
          onChanged: (v) => setState(() => netMaasHesapSekli = v!),
          title: Text(t('dayBasedSalaryOption')),
          contentPadding: EdgeInsets.zero,
        ),
        const Divider(),
        Text(
          t('employerSickPayQuestion'),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        RadioListTile<String>(
          value: 'odemeYok',
          groupValue: raporluHesapSekli,
          onChanged: (v) => setState(() => raporluHesapSekli = v!),
          title: Text(t('sickPayNone')),
          contentPadding: EdgeInsets.zero,
        ),
        RadioListTile<String>(
          value: 'ilk2GunYok',
          groupValue: raporluHesapSekli,
          onChanged: (v) => setState(() => raporluHesapSekli = v!),
          title: Text(t('sickPayFirst2Days')),
          contentPadding: EdgeInsets.zero,
        ),
        RadioListTile<String>(
          value: 'tumGunlerOdenir',
          groupValue: raporluHesapSekli,
          onChanged: (v) => setState(() => raporluHesapSekli = v!),
          title: Text(t('sickPayAllDays')),
          contentPadding: EdgeInsets.zero,
        ),
      ],
    );
  }
}
