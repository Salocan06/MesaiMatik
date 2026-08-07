import 'package:flutter/material.dart';
import 'models.dart';

class TaxScreen extends StatefulWidget {
  final Map<int, TaxYearSettings> taxYears;
  final int initialYear;
  final void Function(Map<int, TaxYearSettings>) onSave;

  const TaxScreen({
    super.key,
    required this.taxYears,
    required this.initialYear,
    required this.onSave,
  });

  @override
  State<TaxScreen> createState() => _TaxScreenState();
}

class _TaxScreenState extends State<TaxScreen> {
  late int selectedYear;
  late Map<int, TaxYearSettings> localYears;

  late TextEditingController sgkCtrl;
  late TextEditingController issizlikCtrl;
  late TextEditingController gelirVergisiCtrl;
  late TextEditingController damgaVergisiCtrl;
  late TextEditingController asgariBrutCtrl;
  late TextEditingController asgariNetCtrl;

  @override
  void initState() {
    super.initState();
    selectedYear = widget.initialYear;
    localYears = Map<int, TaxYearSettings>.from(widget.taxYears);
    _loadFieldsForYear(selectedYear);
  }

  void _loadFieldsForYear(int year) {
    final t = taxForYear(localYears, year);
    sgkCtrl = TextEditingController(text: (t.sgkOrani * 100).toString());
    issizlikCtrl = TextEditingController(text: (t.issizlikOrani * 100).toString());
    gelirVergisiCtrl =
        TextEditingController(text: (t.gelirVergisiOrani * 100).toString());
    damgaVergisiCtrl =
        TextEditingController(text: (t.damgaVergisiOrani * 100).toString());
    asgariBrutCtrl = TextEditingController(text: t.asgariUcretBrut.toString());
    asgariNetCtrl = TextEditingController(text: t.asgariUcretNet.toString());
  }

  void _changeYear(int year) {
    setState(() {
      selectedYear = year;
      _loadFieldsForYear(year);
    });
  }

  double _p(String s) => double.tryParse(s.replaceAll(',', '.')) ?? 0;

  void _saveYear() {
    final t = TaxYearSettings(
      sgkOrani: _p(sgkCtrl.text) / 100,
      issizlikOrani: _p(issizlikCtrl.text) / 100,
      gelirVergisiOrani: _p(gelirVergisiCtrl.text) / 100,
      damgaVergisiOrani: _p(damgaVergisiCtrl.text) / 100,
      asgariUcretBrut: _p(asgariBrutCtrl.text),
      asgariUcretNet: _p(asgariNetCtrl.text),
    );
    setState(() {
      localYears[selectedYear] = t;
    });
    widget.onSave(localYears);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$selectedYear yili vergi ayarlari kaydedildi')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasOwnData = localYears.containsKey(selectedYear);

    return Scaffold(
      appBar: AppBar(title: const Text('Vergi ve Asgari Ucret Ayarlari')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Yil secin', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            DropdownButtonFormField<int>(
              value: selectedYear,
              items: List.generate(
                21,
                (i) => DropdownMenuItem(
                  value: 2020 + i,
                  child: Text('${2020 + i}'),
                ),
              ),
              onChanged: (v) => _changeYear(v!),
            ),
            const SizedBox(height: 8),
            if (!hasOwnData)
              const Padding(
                padding: EdgeInsets.only(bottom: 12),
                child: Text(
                  'Bu yil icin henuz ayri deger girilmedi. Onceki yildan tasinan degerler gosteriliyor. Yeni oranlar aciklaninca guncelleyip kaydedin.',
                  style: TextStyle(color: Colors.orange, fontSize: 13),
                ),
              ),
            const Divider(),
            const Text('Kesinti oranlari (%)',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: sgkCtrl,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(labelText: 'SGK Isci Payi (%)'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: issizlikCtrl,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration:
                  const InputDecoration(labelText: 'Issizlik Sigortasi Payi (%)'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: gelirVergisiCtrl,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(labelText: 'Gelir Vergisi (%)'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: damgaVergisiCtrl,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(labelText: 'Damga Vergisi (%)'),
            ),
            const Divider(),
            const Text('Asgari ucret', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: asgariBrutCtrl,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(labelText: 'Asgari ucret brut (TL)'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: asgariNetCtrl,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(labelText: 'Asgari ucret net (TL)'),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _saveYear,
              child: Text('$selectedYear yili icin kaydet'),
            ),
            const SizedBox(height: 24),
            const Text(
              'Not: Her yil icin degerler ayri saklanir. Yeni yil oranlari resmi olarak aciklandiginda bu ekrandan o yili secip degerleri guncelleyin. Guncellenmeyen yillar bir onceki yilin oranlarini kullanmaya devam eder.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}