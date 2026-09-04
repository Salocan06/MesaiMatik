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

  Widget _cardBg({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.white.withOpacity(0.04)
            : Colors.black.withOpacity(0.03),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: child,
    );
  }

  Widget _sectionLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 12),
      child: Text(text,
          style: TextStyle(fontSize: 15, color: Colors.grey.shade500)),
    );
  }

  Widget _selectableCard({
    required bool selected,
    required IconData icon,
    required Color color,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: selected
              ? color.withOpacity(0.12)
              : (Theme.of(context).brightness == Brightness.dark
                  ? Colors.white.withOpacity(0.04)
                  : Colors.black.withOpacity(0.03)),
          borderRadius: BorderRadius.circular(12),
          border: selected ? Border.all(color: color.withOpacity(0.5)) : null,
        ),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: color.withOpacity(selected ? 0.9 : 0.15),
                borderRadius: BorderRadius.circular(9),
              ),
              child: Icon(icon, size: 16, color: selected ? Colors.white : color),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: selected ? FontWeight.w500 : FontWeight.normal)),
                  if (subtitle != null)
                    Text(subtitle,
                        style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
                ],
              ),
            ),
            Radio<bool>(value: true, groupValue: selected ? true : null, onChanged: (_) => onTap()),
          ],
        ),
      ),
    );
  }

  Widget _infoCard(List<Widget> rows) {
    return _cardBg(
      child: Column(children: rows),
    );
  }

  Widget _infoRow(String label, String value, {bool showDivider = true}) {
    return Container(
      decoration: BoxDecoration(
        border: showDivider
            ? Border(
                bottom: BorderSide(
                    color: Theme.of(context).dividerColor.withOpacity(0.3), width: 0.5))
            : null,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: Text(label, style: TextStyle(fontSize: 13, color: Colors.grey.shade500)),
          ),
          Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final preview = _buildSettings();
    final months = monthNames();

    return Scaffold(
      appBar: AppBar(title: Text(t('salaryEmployerSettingsTitle'))),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '${widget.year} ${months[widget.month - 1]}',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white.withOpacity(0.04)
                    : Colors.black.withOpacity(0.03),
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.all(4),
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: () => setState(() => selectedTab = 0),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: selectedTab == 0 ? Colors.indigo : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(t('salaryTab'),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 12,
                                color: selectedTab == 0 ? Colors.white : Colors.grey.shade500)),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: () => setState(() => selectedTab = 1),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: selectedTab == 1 ? Colors.indigo : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(t('employerTab'),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 12,
                                color: selectedTab == 1 ? Colors.white : Colors.grey.shade500)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
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
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo),
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

  Widget _buildMaasAyarlari(AppSettings preview) {
    final daysInMonth = daysInSelectedMonth;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionLabel(t('workType')),
        _selectableCard(
          selected: employerType == 'saatlik',
          icon: Icons.access_time,
          color: Colors.indigo,
          title: t('hourlyPaid'),
          onTap: () => setState(() => employerType = 'saatlik'),
        ),
        _selectableCard(
          selected: employerType == 'aylik',
          icon: Icons.calendar_month,
          color: Colors.indigo,
          title: t('monthlyPaid'),
          onTap: () => setState(() => employerType = 'aylik'),
        ),
        const SizedBox(height: 8),
        if (employerType == 'saatlik') ...[
          _cardBg(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.info_outline, size: 15, color: Colors.grey.shade500),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      t('hourlyInfoText'),
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade500, height: 1.4),
                    ),
                  ),
                ],
              ),
            ),
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
          _sectionLabel(t('salaryCalcMethod')),
          _selectableCard(
            selected: maasHesapModu == 'brut',
            icon: Icons.trending_up,
            color: Colors.teal,
            title: t('calcFromGross'),
            onTap: () => setState(() => maasHesapModu = 'brut'),
          ),
          _selectableCard(
            selected: maasHesapModu == 'net',
            icon: Icons.check_circle_outline,
            color: Colors.teal,
            title: t('calcFromNet'),
            onTap: () => setState(() => maasHesapModu = 'net'),
          ),
          _selectableCard(
            selected: maasHesapModu == 'manuel',
            icon: Icons.edit_outlined,
            color: Colors.teal,
            title: t('calcManual'),
            onTap: () => setState(() => maasHesapModu = 'manuel'),
          ),
          const SizedBox(height: 8),
          if (maasHesapModu == 'brut') ...[
            TextField(
              controller: brutMaasCtrl,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(labelText: t('grossSalaryLabel')),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 12),
            _infoCard([
              _infoRow(t('sgkShare'), preview.sgkIsciPayi(tax).toStringAsFixed(2)),
              _infoRow(t('unemploymentShare'), preview.issizlikPayi(tax).toStringAsFixed(2)),
              _infoRow(t('incomeTaxBase'), preview.gelirVergisiMatrahi(tax).toStringAsFixed(2)),
              _infoRow(t('incomeTax'), preview.gelirVergisi(tax).toStringAsFixed(2)),
              _infoRow(t('stampTax'), preview.damgaVergisi(tax).toStringAsFixed(2)),
              _infoRow(t('totalDeductions'), preview.kesintilerToplami(tax).toStringAsFixed(2)),
              _infoRow(t('netSalaryLabel30'), preview.hesaplananNetMaas(tax).toStringAsFixed(2),
                  showDivider: false),
            ]),
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
        const SizedBox(height: 8),
        _cardBg(
          child: SwitchListTile(
            value: haftaTatiliKesintileri,
            onChanged: (v) => setState(() => haftaTatiliKesintileri = v),
            title: Text(t('weekendDeductions'), style: const TextStyle(fontSize: 13)),
            activeColor: Colors.indigo,
            dense: true,
          ),
        ),
        _sectionLabel(t('overtimeMultipliersTitle')),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: mHaftaIciCtrl,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(labelText: t('weekdayMultiplierLabel')),
                onChanged: (_) => setState(() {}),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                controller: mCumartesiCtrl,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(labelText: t('saturdayMultiplierLabel')),
                onChanged: (_) => setState(() {}),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: mPazarCtrl,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(labelText: t('sundayMultiplierLabel')),
                onChanged: (_) => setState(() {}),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                controller: mResmiTatilCtrl,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(labelText: t('holidayMultiplierLabel')),
                onChanged: (_) => setState(() {}),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _infoCard([
          _infoRow(t('hourlyRateResult'), preview.hourlyRateForCalc(tax).toStringAsFixed(2)),
          _infoRow(t('weekdayHourlyRate'),
              (preview.hourlyRateForCalc(tax) * preview.multiplierHaftaIci).toStringAsFixed(2)),
          _infoRow(t('saturdayHourlyRate'),
              (preview.hourlyRateForCalc(tax) * preview.multiplierCumartesi).toStringAsFixed(2)),
          _infoRow(t('sundayHourlyRate'),
              (preview.hourlyRateForCalc(tax) * preview.multiplierPazar).toStringAsFixed(2)),
          _infoRow(t('holidayHourlyRate'),
              (preview.hourlyRateForCalc(tax) * preview.multiplierResmiTatil).toStringAsFixed(2),
              showDivider: false),
        ]),
        const SizedBox(height: 10),
        Text(
          t('monthlyNetSalaryText').replaceAll('%d', '$daysInMonth') +
              '${preview.baseMonthlyEarningForMonth(daysInMonth, tax).toStringAsFixed(2)} TL',
          style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
        ),
      ],
    );
  }

  Widget _employerQuestion({
    required IconData icon,
    required Color color,
    required String question,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 26,
            height: 26,
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 14, color: color),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(question,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _radioCard({
    required bool selected,
    required String label,
    required VoidCallback onTap,
    bool showDivider = true,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: showDivider
              ? Border(
                  bottom: BorderSide(
                      color: Theme.of(context).dividerColor.withOpacity(0.3), width: 0.5))
              : null,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Radio<bool>(value: true, groupValue: selected ? true : null, onChanged: (_) => onTap()),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(label, style: const TextStyle(fontSize: 13, height: 1.4)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIsverenAyarlari() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _employerQuestion(
          icon: Icons.event_available,
          color: Colors.orange,
          question: t('employerHolidayQuestion'),
        ),
        _infoCard([
          _radioCard(
            selected: resmiTatilHesapSekli == 'gunlukEkUcret',
            label: t('holidayOptionExtraDay'),
            onTap: () => setState(() => resmiTatilHesapSekli = 'gunlukEkUcret'),
          ),
          _radioCard(
            selected: resmiTatilHesapSekli == 'tamamenFazlaMesai',
            label: t('holidayOptionOvertime'),
            onTap: () => setState(() => resmiTatilHesapSekli = 'tamamenFazlaMesai'),
            showDivider: false,
          ),
        ]),
        _employerQuestion(
          icon: Icons.account_balance_wallet_outlined,
          color: Colors.teal,
          question: t('employerNetSalaryQuestion'),
        ),
        _infoCard([
          _radioCard(
            selected: netMaasHesapSekli == 'sabit30Gun',
            label: t('fixedSalaryOption'),
            onTap: () => setState(() => netMaasHesapSekli = 'sabit30Gun'),
          ),
          _radioCard(
            selected: netMaasHesapSekli == 'gunSayisinaGore',
            label: t('dayBasedSalaryOption'),
            onTap: () => setState(() => netMaasHesapSekli = 'gunSayisinaGore'),
            showDivider: false,
          ),
        ]),
        _employerQuestion(
          icon: Icons.local_hospital_outlined,
          color: Colors.redAccent,
          question: t('employerSickPayQuestion'),
        ),
        _infoCard([
          _radioCard(
            selected: raporluHesapSekli == 'odemeYok',
            label: t('sickPayNone'),
            onTap: () => setState(() => raporluHesapSekli = 'odemeYok'),
          ),
          _radioCard(
            selected: raporluHesapSekli == 'ilk2GunYok',
            label: t('sickPayFirst2Days'),
            onTap: () => setState(() => raporluHesapSekli = 'ilk2GunYok'),
          ),
          _radioCard(
            selected: raporluHesapSekli == 'tumGunlerOdenir',
            label: t('sickPayAllDays'),
            onTap: () => setState(() => raporluHesapSekli = 'tumGunlerOdenir'),
            showDivider: false,
          ),
        ]),
      ],
    );
  }
}
