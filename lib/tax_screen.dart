import 'package:flutter/material.dart';
import 'models.dart';
import 'lang.dart';

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
      SnackBar(content: Text('$selectedYear ${t2('taxSavedSnackbar')}')),
    );
  }

  Widget _cardBg({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.white.withOpacity(0.04)
            : Colors.black.withOpacity(0.03),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(4),
      child: child,
    );
  }

  Widget _sectionLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 4),
      child: Text(text, style: TextStyle(fontSize: 15, color: Colors.grey.shade500)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasOwnData = localYears.containsKey(selectedYear);

    return Scaffold(
      appBar: AppBar(title: Text(t2('taxScreenTitle'))),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionLabel(t2('selectYear')),
            _cardBg(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    Icon(Icons.calendar_today, size: 16, color: Colors.grey.shade500),
                    const SizedBox(width: 8),
                    Expanded(
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<int>(
                          isExpanded: true,
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
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (!hasOwnData)
              Container(
                margin: const EdgeInsets.only(top: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.warning_amber_rounded, size: 16, color: Colors.orange),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        t2('noOwnDataWarning'),
                        style: const TextStyle(color: Colors.orange, fontSize: 12, height: 1.4),
                      ),
                    ),
                  ],
                ),
              ),
            _sectionLabel(t2('deductionRatesTitle')),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: sgkCtrl,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(labelText: t2('sgkShareLabel')),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: issizlikCtrl,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(labelText: t2('unemploymentShareLabel')),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: gelirVergisiCtrl,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(labelText: t2('incomeTaxLabel')),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: damgaVergisiCtrl,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(labelText: t2('stampTaxLabel')),
                  ),
                ),
              ],
            ),
            _sectionLabel(t2('minWageTitle')),
            TextField(
              controller: asgariBrutCtrl,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(labelText: t2('minWageGrossLabel')),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: asgariNetCtrl,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(labelText: t2('minWageNetLabel')),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveYear,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo),
                child: Text('$selectedYear ${t2('saveForYear')}'),
              ),
            ),
            const SizedBox(height: 20),
            _cardBg(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.info_outline, size: 15, color: Colors.grey.shade500),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        t2('taxYearNote'),
                        style: TextStyle(fontSize: 12, color: Colors.grey.shade500, height: 1.4),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
