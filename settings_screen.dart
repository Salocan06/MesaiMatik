import 'package:flutter/material.dart';
import 'models.dart';

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

  final months = [
    'OCAK','SUBAT','MART','NISAN','MAYIS','HAZIRAN',
    'TEMMUZ','AGUSTOS','EYLUL','EKIM','KASIM','ARALIK'
  ];

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

    return Scaffold(
      appBar: AppBar(title: const Text('Maas ve Isveren Ayarlari')),
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
                    child: const Text('MAAS AYARLARI',
                        textAlign: TextAlign.center),
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
                    child: const Text('ISVEREN AYARLARI',
                        textAlign: TextAlign.center),
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
                    child: const Text('Iptal'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _save,
                    child: const Text('Kaydet'),
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
        const Text('Calisma tipi', style: TextStyle(fontWeight: FontWeight.bold)),
        RadioListTile<String>(
          value: 'saatlik',
          groupValue: employerType,
          onChanged: (v) => setState(() => employerType = v!),
          title: const Text('Saatlik ucretli'),
          contentPadding: EdgeInsets.zero,
        ),
        RadioListTile<String>(
          value: 'aylik',
          groupValue: employerType,
          onChanged: (v) => setState(() => employerType = v!),
          title: const Text('Aylik maasli'),
          contentPadding: EdgeInsets.zero,
        ),
        const Divider(),
        if (employerType == 'saatlik') ...[
          const Text(
            'Saatlik ucretiniz ve standart aylik saatinizden bir net maas hesaplanir, bu maas ayin gun sayisina gore olceklenir. Takvime girdiginiz ekstra saatler ayrica eklenir.',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: hourlyRateCtrl,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(labelText: 'Saatlik ucretiniz (TL)'),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: standardHoursCtrl,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(labelText: 'Standart aylik saat (orn. 225, 30 gun icin)'),
            onChanged: (_) => setState(() {}),
          ),
        ] else ...[
          const Text('Maas nasil hesaplansin',
              style: TextStyle(fontWeight: FontWeight.bold)),
          RadioListTile<String>(
            value: 'brut',
            groupValue: maasHesapModu,
            onChanged: (v) => setState(() => maasHesapModu = v!),
            title: const Text('Brut maas uzerinden otomatik hesapla'),
            contentPadding: EdgeInsets.zero,
          ),
          RadioListTile<String>(
            value: 'net',
            groupValue: maasHesapModu,
            onChanged: (v) => setState(() => maasHesapModu = v!),
            title: const Text('Net maas uzerinden otomatik hesapla'),
            contentPadding: EdgeInsets.zero,
          ),
          RadioListTile<String>(
            value: 'manuel',
            groupValue: maasHesapModu,
            onChanged: (v) => setState(() => maasHesapModu = v!),
            title: const Text('Manuel: net maasi ben gireceğim'),
            contentPadding: EdgeInsets.zero,
          ),
          const SizedBox(height: 12),
          if (maasHesapModu == 'brut') ...[
            TextField(
              controller: brutMaasCtrl,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(labelText: 'Brut maasiniz (30 gun icin)'),
              onChanged: (_) => setState(() {}),
            ),
            const Divider(),
            _infoRow('SGK Isci Payi', preview.sgkIsciPayi(tax).toStringAsFixed(2)),
            _infoRow('Issiz. Sigortasi Payi', preview.issizlikPayi(tax).toStringAsFixed(2)),
            _infoRow('Bu Ayki Gelir Vergisi Matrahi', preview.gelirVergisiMatrahi(tax).toStringAsFixed(2)),
            _infoRow('Gelir Vergisi', preview.gelirVergisi(tax).toStringAsFixed(2)),
            _infoRow('Damga Vergisi', preview.damgaVergisi(tax).toStringAsFixed(2)),
            _infoRow('Kesintiler Toplami', preview.kesintilerToplami(tax).toStringAsFixed(2)),
            _infoRow('Net maasiniz (30 gun icin)', preview.hesaplananNetMaas(tax).toStringAsFixed(2)),
          ] else if (maasHesapModu == 'net') ...[
            TextField(
              controller: netMaasCtrl,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(labelText: 'Net maasiniz (30 gun icin)'),
              onChanged: (_) => setState(() {}),
            ),
          ] else ...[
            TextField(
              controller: manuelNetMaasCtrl,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(labelText: 'Net maasiniz (30 gun icin, elle girin)'),
              onChanged: (_) => setState(() {}),
            ),
          ],
        ],
        const Divider(),
        SwitchListTile(
          value: haftaTatiliKesintileri,
          onChanged: (v) => setState(() => haftaTatiliKesintileri = v),
          title: const Text('Hafta tatili kesintileri'),
          contentPadding: EdgeInsets.zero,
        ),
        const Divider(),
        const Text('Fazla mesai carpanlari',
            style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextField(
          controller: mHaftaIciCtrl,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(labelText: 'Haftaici carpani (orn. 1.5)'),
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: mCumartesiCtrl,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(labelText: 'Cumartesi carpani (orn. 1.5)'),
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: mPazarCtrl,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(labelText: 'Pazar carpani (orn. 2.0)'),
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: mResmiTatilCtrl,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(labelText: 'Resmi tatil carpani (orn. 2.0)'),
          onChanged: (_) => setState(() {}),
        ),
        const Divider(),
        _infoRow('1 saatlik ucretiniz', preview.hourlyRateForCalc(tax).toStringAsFixed(2)),
        _infoRow('Haftaici 1 saat ucret',
            (preview.hourlyRateForCalc(tax) * preview.multiplierHaftaIci).toStringAsFixed(2)),
        _infoRow('Cumartesi 1 saat ucret',
            (preview.hourlyRateForCalc(tax) * preview.multiplierCumartesi).toStringAsFixed(2)),
        _infoRow('Pazar 1 saat ucret',
            (preview.hourlyRateForCalc(tax) * preview.multiplierPazar).toStringAsFixed(2)),
        _infoRow('Resmi tatil 1 saat ucret',
            (preview.hourlyRateForCalc(tax) * preview.multiplierResmiTatil).toStringAsFixed(2)),
        const SizedBox(height: 8),
        Text('Bu ay ($daysInMonth gun) icin net maas: '
            '${preview.baseMonthlyEarningForMonth(daysInMonth, tax).toStringAsFixed(2)} TL'),
      ],
    );
  }

  Widget _buildIsverenAyarlari() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'ISVERENINIZ RESMI TATIL CALISMALARININ UCRETLERINI NASIL HESAPLAR?',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        RadioListTile<String>(
          value: 'gunlukEkUcret',
          groupValue: resmiTatilHesapSekli,
          onChanged: (v) => setState(() => resmiTatilHesapSekli = v!),
          title: const Text(
              'Resmi tatilde calistiginizda fazladan bir gunluk ucret veriyorsa bu secenegi isaretleyin.'),
          contentPadding: EdgeInsets.zero,
        ),
        RadioListTile<String>(
          value: 'tamamenFazlaMesai',
          groupValue: resmiTatilHesapSekli,
          onChanged: (v) => setState(() => resmiTatilHesapSekli = v!),
          title: const Text(
              'Isvereniniz resmi tatildeki tum calismanizi fazla mesai olarak oduyorsa bu secenegi isaretleyin.'),
          contentPadding: EdgeInsets.zero,
        ),
        const Divider(),
        const Text(
          'ISVERENINIZ NET MAASI NASIL HESAPLAR?',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        RadioListTile<String>(
          value: 'sabit30Gun',
          groupValue: netMaasHesapSekli,
          onChanged: (v) => setState(() => netMaasHesapSekli = v!),
          title: const Text(
              'Isvereniniz sabit net maas oduyorsa bu secenegi isaretleyin (ay 28-29-31 gun de olsa maas ayni).'),
          contentPadding: EdgeInsets.zero,
        ),
        RadioListTile<String>(
          value: 'gunSayisinaGore',
          groupValue: netMaasHesapSekli,
          onChanged: (v) => setState(() => netMaasHesapSekli = v!),
          title: const Text(
              'Isvereniniz net maasi aydaki gun sayisina gore hesapliyorsa bu secenegi isaretleyin.'),
          contentPadding: EdgeInsets.zero,
        ),
        const Divider(),
        const Text(
          'ISVERENINIZ RAPORLU GUN UCRETLERINI NASIL HESAPLAR?',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        RadioListTile<String>(
          value: 'odemeYok',
          groupValue: raporluHesapSekli,
          onChanged: (v) => setState(() => raporluHesapSekli = v!),
          title: const Text(
              'Isvereniniz raporlu oldugunuz gunler icin odeme yapmiyorsa bu secenegi isaretleyin.'),
          contentPadding: EdgeInsets.zero,
        ),
        RadioListTile<String>(
          value: 'ilk2GunYok',
          groupValue: raporluHesapSekli,
          onChanged: (v) => setState(() => raporluHesapSekli = v!),
          title: const Text(
              'Isvereniniz raporlu oldugunuz ilk 2 gune odeme yapmiyor, diger gunlere odeme yapiyorsa bu secenegi isaretleyin.'),
          contentPadding: EdgeInsets.zero,
        ),
        RadioListTile<String>(
          value: 'tumGunlerOdenir',
          groupValue: raporluHesapSekli,
          onChanged: (v) => setState(() => raporluHesapSekli = v!),
          title: const Text(
              'Isvereniniz raporlu oldugunuz butun gunler icin odeme yapiyorsa bu secenegi isaretleyin.'),
          contentPadding: EdgeInsets.zero,
        ),
      ],
    );
  }
}