import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'models.dart';

class PdfExportScreen extends StatefulWidget {
  final AppSettings settings;
  final Map<String, DayRecord> records;
  final Map<int, TaxYearSettings> taxYears;
  final int initialMonth;
  final int initialYear;

  const PdfExportScreen({
    super.key,
    required this.settings,
    required this.records,
    required this.taxYears,
    required this.initialMonth,
    required this.initialYear,
  });

  @override
  State<PdfExportScreen> createState() => _PdfExportScreenState();
}

class _PdfExportScreenState extends State<PdfExportScreen> {
  late int selectedMonth;
  late int selectedYear;
  bool generating = false;
  String? lastError;

  final months = [
    'Ocak', 'Subat', 'Mart', 'Nisan', 'Mayis', 'Haziran',
    'Temmuz', 'Agustos', 'Eylul', 'Ekim', 'Kasim', 'Aralik'
  ];

  @override
  void initState() {
    super.initState();
    selectedMonth = widget.initialMonth;
    selectedYear = widget.initialYear;
  }

  String _typeLabel(String type) {
    if (type == 'mesai') {
      return 'Fazla Mesai';
    }
    if (type == 'gitmedim') {
      return 'Ise Gitmedim';
    }
    if (type == 'raporlu') {
      return 'Raporlu';
    }
    if (type == 'ucretliIzin') {
      return 'Ucretli Izin';
    }
    if (type == 'ucretsizIzin') {
      return 'Ucretsiz Izin';
    }
    return type;
  }

  Future<void> _generateAndShare() async {
    setState(() {
      generating = true;
      lastError = null;
    });
    try {
      final tax = taxForYear(widget.taxYears, selectedYear);
      final daysInMonth = DateTime(selectedYear, selectedMonth + 1, 0).day;

      double haftaIci = 0;
      double cumartesi = 0;
      double pazar = 0;
      double resmiTatil = 0;
      double avansTotal = 0;
      double bahsisTotal = 0;

      final rows = <List<String>>[];

      for (int d = 1; d <= daysInMonth; d++) {
        final day = DateTime(selectedYear, selectedMonth, d);
        final mm = day.month.toString().padLeft(2, '0');
        final dd = day.day.toString().padLeft(2, '0');
        final key = '${day.year}-$mm-$dd';
        final r = widget.records[key];
        if (r == null || r.isEmptyRecord) {
          continue;
        }

        if (r.type == 'mesai' && r.hours > 0) {
          if (r.resmiTatil) {
            resmiTatil = resmiTatil + r.hours;
          } else if (day.weekday == DateTime.saturday) {
            cumartesi = cumartesi + r.hours;
          } else if (day.weekday == DateTime.sunday) {
            pazar = pazar + r.hours;
          } else {
            haftaIci = haftaIci + r.hours;
          }
        }
        avansTotal = avansTotal + r.avans;
        bahsisTotal = bahsisTotal + r.bahsis;

        final hoursText = r.hours > 0 ? r.hours.toStringAsFixed(1) : '-';
        final avansText = r.avans > 0 ? r.avans.toStringAsFixed(2) : '-';
        final bahsisText = r.bahsis > 0 ? r.bahsis.toStringAsFixed(2) : '-';

        rows.add([
          '$dd/$mm/${day.year}',
          _typeLabel(r.type),
          hoursText,
          avansText,
          bahsisText,
          r.not,
        ]);
      }

      if (rows.isEmpty) {
        rows.add(['-', 'Kayit yok', '-', '-', '-', '-']);
      }

      final rate = widget.settings.hourlyRateForCalc(tax);
      final overtimePay = haftaIci * rate * widget.settings.multiplierHaftaIci +
          cumartesi * rate * widget.settings.multiplierCumartesi +
          pazar * rate * widget.settings.multiplierPazar +
          resmiTatil * rate * widget.settings.multiplierResmiTatil;
      final baseEarning =
          widget.settings.baseMonthlyEarningForMonth(daysInMonth, tax);
      final total = baseEarning + overtimePay + bahsisTotal - avansTotal;

      final pdf = pw.Document();

      pdf.addPage(
        pw.MultiPage(
          build: (context) {
            return [
              pw.Header(
                level: 0,
                child: pw.Text(
                  'Mesaimatik - Aylik Rapor',
                  style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
                ),
              ),
              pw.Text(
                '${months[selectedMonth - 1]} $selectedYear',
                style: const pw.TextStyle(fontSize: 14),
              ),
              pw.SizedBox(height: 16),
              pw.Table.fromTextArray(
                headers: ['Tarih', 'Durum', 'Saat', 'Avans', 'Bahsis', 'Not'],
                data: rows,
                cellStyle: const pw.TextStyle(fontSize: 9),
                headerStyle: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold),
                cellAlignment: pw.Alignment.centerLeft,
              ),
              pw.SizedBox(height: 20),
              pw.Divider(),
              pw.SizedBox(height: 8),
              pw.Text(
                'Ozet',
                style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 8),
              pw.Text('Haftaici fazla mesai: ${haftaIci.toStringAsFixed(1)} saat'),
              pw.Text('Cumartesi fazla mesai: ${cumartesi.toStringAsFixed(1)} saat'),
              pw.Text('Pazar fazla mesai: ${pazar.toStringAsFixed(1)} saat'),
              pw.Text('Resmi tatil fazla mesai: ${resmiTatil.toStringAsFixed(1)} saat'),
              pw.SizedBox(height: 8),
              pw.Text('Avans toplami: ${avansTotal.toStringAsFixed(2)} TL'),
              pw.Text('Bahsis toplami: ${bahsisTotal.toStringAsFixed(2)} TL'),
              pw.SizedBox(height: 8),
              pw.Text('Normal kazanc: ${baseEarning.toStringAsFixed(2)} TL'),
              pw.Text('Fazla mesai ucreti: ${overtimePay.toStringAsFixed(2)} TL'),
              pw.SizedBox(height: 8),
              pw.Text(
                'Ele gecen maas: ${total.toStringAsFixed(2)} TL',
                style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
              ),
            ];
          },
        ),
      );

      final bytes = await pdf.save();

      await Printing.sharePdf(
        bytes: bytes,
        filename: 'mesaimatik_${selectedYear}_$selectedMonth.pdf',
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('PDF olusturuldu')),
        );
      }
    } catch (e) {
      setState(() {
        lastError = 'HATA: $e';
      });
    } finally {
      if (mounted) {
        setState(() {
          generating = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('PDF e Aktar')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Hangi ayin raporunu olusturmak istiyorsunuz?',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<int>(
                    value: selectedMonth,
                    items: List.generate(
                      12,
                      (i) => DropdownMenuItem(value: i + 1, child: Text(months[i])),
                    ),
                    onChanged: (v) {
                      setState(() {
                        selectedMonth = v!;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: DropdownButtonFormField<int>(
                    value: selectedYear,
                    items: List.generate(
                      21,
                      (i) => DropdownMenuItem(value: 2020 + i, child: Text('${2020 + i}')),
                    ),
                    onChanged: (v) {
                      setState(() {
                        selectedYear = v!;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: generating ? null : _generateAndShare,
              icon: generating
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.picture_as_pdf),
              label: Text(generating ? 'Olusturuluyor...' : 'PDF Olustur ve Paylas'),
            ),
            if (lastError != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.red),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  lastError!,
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
              ),
            ],
            const SizedBox(height: 16),
            const Text(
              'PDF olusturulduktan sonra telefonunuzun paylasim menusu acilacak.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}