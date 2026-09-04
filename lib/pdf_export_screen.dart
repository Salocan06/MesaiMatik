import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'models.dart';
import 'lang.dart';

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

  @override
  void initState() {
    super.initState();
    selectedMonth = widget.initialMonth;
    selectedYear = widget.initialYear;
  }

  String _typeLabel(String type) {
    if (type == 'mesai') {
      return t('typeOvertime');
    }
    if (type == 'gitmedim') {
      return t('typeAbsent');
    }
    if (type == 'raporlu') {
      return t('typeSick');
    }
    if (type == 'ucretliIzin') {
      return t('typePaidLeave');
    }
    if (type == 'ucretsizIzin') {
      return t('typeUnpaidLeave');
    }
    if (type == 'telafi') {
      return t('typeCompOff');
    }
    return type;
  }

  Future<void> _generateAndShare() async {
    setState(() {
      generating = true;
      lastError = null;
    });
    try {
      final months = monthNames();
      final tax = taxForYear(widget.taxYears, selectedYear);
      final daysInMonth = DateTime(selectedYear, selectedMonth + 1, 0).day;

      double haftaIci = 0;
      double cumartesi = 0;
      double pazar = 0;
      double resmiTatil = 0;
      double avansTotal = 0;
      double gecKalmaTotal = 0;
      double sickDays = 0;
      double absentDays = 0;
      double unpaidDays = 0;
      double telafiCumartesiSaat = 0;
      double telafiPazarSaat = 0;

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
        gecKalmaTotal = gecKalmaTotal + r.gecKalmaDakika;
        if (r.type == 'raporlu') sickDays += 1;
        if (r.type == 'gitmedim') absentDays += 1;
        if (r.type == 'ucretsizIzin') unpaidDays += 1;
        if (r.type == 'telafi' && r.telafiSaat > 0) {
          if (r.telafiGunu == 'pazar') {
            telafiPazarSaat += r.telafiSaat;
          } else {
            telafiCumartesiSaat += r.telafiSaat;
          }
        }

        final hoursText = r.hours > 0 ? r.hours.toStringAsFixed(1) : '-';
        final avansText = r.avans > 0 ? r.avans.toStringAsFixed(2) : '-';
        final lateText =
            r.gecKalmaDakika > 0 ? (r.gecKalmaDakika / 60).toStringAsFixed(1) : '-';

        rows.add([
          '$dd/$mm/${day.year}',
          _typeLabel(r.type),
          hoursText,
          avansText,
          lateText,
          r.not,
        ]);
      }

      if (rows.isEmpty) {
        rows.add(['-', t('noRecordText'), '-', '-', '-', '-']);
      }

      final rate = widget.settings.hourlyRateForCalc(tax);
      final dailyRate = widget.settings.dailyRateForCalc(tax);
      final overtimePay = haftaIci * rate * widget.settings.multiplierHaftaIci +
          cumartesi * rate * widget.settings.multiplierCumartesi +
          pazar * rate * widget.settings.multiplierPazar +
          resmiTatil * rate * widget.settings.multiplierResmiTatil;
      final baseEarning =
          widget.settings.baseMonthlyEarningForMonth(daysInMonth, tax);
      final lateDeduction = (gecKalmaTotal / 60) * rate;
      final absentDeduction = absentDays * dailyRate;
      final unpaidDeduction = unpaidDays * dailyRate;
      final telafiDeduction = telafiCumartesiSaat * rate * widget.settings.multiplierCumartesi +
          telafiPazarSaat * rate * widget.settings.multiplierPazar;
      final total = baseEarning +
          overtimePay -
          avansTotal -
          lateDeduction -
          absentDeduction -
          unpaidDeduction -
          telafiDeduction;

      final pdf = pw.Document();

      pdf.addPage(
        pw.MultiPage(
          build: (context) {
            return [
              pw.Header(
                level: 0,
                child: pw.Text(
                  t('pdfReportTitle'),
                  style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
                ),
              ),
              pw.Text(
                '${months[selectedMonth - 1]} $selectedYear',
                style: const pw.TextStyle(fontSize: 14),
              ),
              pw.SizedBox(height: 16),
              pw.Table.fromTextArray(
                headers: [
                  t('pdfHeaderDate'),
                  t('pdfHeaderStatus'),
                  t('pdfHeaderHours'),
                  t('pdfHeaderAdvance'),
                  t('day_lateHours'),
                  t('pdfHeaderNote'),
                ],
                data: rows,
                cellStyle: const pw.TextStyle(fontSize: 9),
                headerStyle: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold),
                cellAlignment: pw.Alignment.centerLeft,
              ),
              pw.SizedBox(height: 20),
              pw.Divider(),
              pw.SizedBox(height: 8),
              pw.Text(
                t('pdfSummaryTitle'),
                style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 8),
              pw.Text('${t('pdfWeekdayOvertime')} ${haftaIci.toStringAsFixed(1)} ${t('hoursSuffix')}'),
              pw.Text('${t('pdfSaturdayOvertime')} ${cumartesi.toStringAsFixed(1)} ${t('hoursSuffix')}'),
              pw.Text('${t('pdfSundayOvertime')} ${pazar.toStringAsFixed(1)} ${t('hoursSuffix')}'),
              pw.Text('${t('pdfHolidayOvertime')} ${resmiTatil.toStringAsFixed(1)} ${t('hoursSuffix')}'),
              pw.SizedBox(height: 8),
              pw.Text('${t('pdfAdvanceTotal')} ${avansTotal.toStringAsFixed(2)} TL'),
              if (sickDays > 0)
                pw.Text('${t('sickDaysLabel')} ${sickDays.toStringAsFixed(0)} ${t('daySuffix')}'),
              if (absentDays > 0) ...[
                pw.Text('${t('absentDaysLabel')} ${absentDays.toStringAsFixed(0)} ${t('daySuffix')}'),
                pw.Text('${t('absentDeduction')} -${absentDeduction.toStringAsFixed(2)} TL'),
              ],
              if (unpaidDays > 0) ...[
                pw.Text('${t('unpaidLeaveDaysLabel')} ${unpaidDays.toStringAsFixed(0)} ${t('daySuffix')}'),
                pw.Text('${t('unpaidLeaveDeduction')} -${unpaidDeduction.toStringAsFixed(2)} TL'),
              ],
              if (lateDeduction > 0)
                pw.Text('${t('lateDeduction')} -${lateDeduction.toStringAsFixed(2)} TL'),
              if (telafiDeduction > 0)
                pw.Text('${t('compOffDeduction')} -${telafiDeduction.toStringAsFixed(2)} TL'),
              pw.SizedBox(height: 8),
              pw.Text('${t('pdfNormalEarning')} ${baseEarning.toStringAsFixed(2)} TL'),
              pw.Text('${t('pdfOvertimePay')} ${overtimePay.toStringAsFixed(2)} TL'),
              pw.SizedBox(height: 8),
              pw.Text(
                '${t('pdfFinalSalary')} ${total.toStringAsFixed(2)} TL',
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
          SnackBar(content: Text(t('pdfCreatedSnackbar'))),
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
    final months = monthNames();
    return Scaffold(
      appBar: AppBar(title: Text(t('pdfExportTitle'))),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Center(
              child: Column(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: Colors.redAccent.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(Icons.picture_as_pdf,
                        size: 30, color: Colors.redAccent),
                  ),
                  const SizedBox(height: 12),
                  Text(t('pdfIntroTitle'),
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 4),
                  Text(
                    t('whichMonthQuestion'),
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
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
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: generating ? null : _generateAndShare,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo),
                icon: generating
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : const Icon(Icons.download),
                label: Text(generating ? t('generatingText') : t('generatePdfButton')),
              ),
            ),
            if (lastError != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.red.withOpacity(0.4)),
                ),
                child: Text(
                  lastError!,
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
              ),
            ],
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white.withOpacity(0.04)
                    : Colors.black.withOpacity(0.03),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.info_outline, size: 15, color: Colors.grey.shade500),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      t('shareInfoText'),
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade500, height: 1.4),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
