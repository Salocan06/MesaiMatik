import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'models.dart';
import 'calendar_screen.dart';
import 'settings_screen.dart';
import 'theme_screen.dart';
import 'start_date_screen.dart';
import 'leave_screen.dart';
import 'tax_screen.dart';
import 'about_screen.dart';
import 'startup_gate.dart';
import 'encrypt_screen.dart';
import 'pdf_export_screen.dart';
import 'lang.dart';
import 'language_screen.dart';
import 'banner_ad_widget.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  runApp(const MesaimatikApp());
}

class MesaimatikApp extends StatelessWidget {
  const MesaimatikApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, mode, _) {
        return ValueListenableBuilder<String>(
          valueListenable: languageNotifier,
          builder: (context, lang, __) {
            return MaterialApp(
              title: 'Mesaimatik',
              themeMode: mode,
              theme: ThemeData(
                primarySwatch: Colors.indigo,
                useMaterial3: true,
                brightness: Brightness.light,
              ),
              darkTheme: ThemeData(
                primarySwatch: Colors.indigo,
                useMaterial3: true,
                brightness: Brightness.dark,
              ),
              builder: (context, child) {
                return Directionality(
                  textDirection: currentTextDirection(),
                  child: child!,
                );
              },
              home: const StartupGate(),
            );
          },
        );
      },
    );
  }
}

class MainMenuScreen extends StatefulWidget {
  const MainMenuScreen({super.key});

  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen> {
  AppSettings settings = AppSettings();
  Map<String, DayRecord> records = {};
  Map<int, TaxYearSettings> taxYears = {};
  bool loaded = false;
  int selectedMonth = DateTime.now().month;
  int selectedYear = DateTime.now().year;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final settingsStr = prefs.getString('settings');
    final recordsStr = prefs.getString('dailyRecords');
    final taxStr = prefs.getString('taxYears');
    setState(() {
      if (settingsStr != null) {
        settings = AppSettings.fromJson(jsonDecode(settingsStr));
      }
      records = decodeRecords(recordsStr);
      taxYears = decodeTaxYears(taxStr);
      loaded = true;
    });
    themeNotifier.value = themeModeFromString(settings.themeMode);
    languageNotifier.value = settings.language;
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('settings', jsonEncode(settings.toJson()));
  }

  Future<void> _saveRecords() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('dailyRecords', encodeRecords(records));
  }

  Future<void> _saveTaxYears() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('taxYears', encodeTaxYears(taxYears));
  }

  void _updateRecord(String key, DayRecord? record) {
    setState(() {
      if (record == null || record.isEmptyRecord) {
        records.remove(key);
      } else {
        records[key] = record;
      }
    });
    _saveRecords();
  }

  void _updateSettings(AppSettings s) {
    setState(() {
      settings = s;
    });
    _saveSettings();
  }

  void _updateTaxYears(Map<int, TaxYearSettings> t) {
    setState(() {
      taxYears = t;
    });
    _saveTaxYears();
  }

  void _openCalendar() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CalendarScreen(
          settings: settings,
          records: records,
          initialMonth: DateTime(selectedYear, selectedMonth),
          taxYears: taxYears,
          onUpdateRecord: _updateRecord,
        ),
      ),
    ).then((_) => setState(() {}));
  }

  void _openSettings() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SettingsScreen(
          settings: settings,
          month: selectedMonth,
          year: selectedYear,
          taxYears: taxYears,
          onSave: _updateSettings,
        ),
      ),
    );
  }

  void _openTheme() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ThemeScreen(
          settings: settings,
          onSave: _updateSettings,
        ),
      ),
    );
  }

  void _openStartDate() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StartDateScreen(
          settings: settings,
          onSave: _updateSettings,
        ),
      ),
    );
  }

  void _openLeave() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LeaveScreen(
          settings: settings,
          records: records,
          initialYear: selectedYear,
        ),
      ),
    );
  }

  void _openTax() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TaxScreen(
          taxYears: taxYears,
          initialYear: selectedYear,
          onSave: _updateTaxYears,
        ),
      ),
    );
  }

  void _openAbout() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AboutScreen()),
    );
  }

  void _openEncrypt() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EncryptScreen(
          settings: settings,
          onSave: _updateSettings,
        ),
      ),
    );
  }

  void _openPdfExport() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PdfExportScreen(
          settings: settings,
          records: records,
          taxYears: taxYears,
          initialMonth: selectedMonth,
          initialYear: selectedYear,
        ),
      ),
    );
  }

  void _openLanguage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LanguageScreen(
          settings: settings,
          onSave: _updateSettings,
        ),
      ),
    );
  }

  Widget _menuButton(String label, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade700),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.indigo),
            const SizedBox(width: 8),
            Expanded(
              child: Text(label, textAlign: TextAlign.center),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!loaded) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final months = monthNames();
    return Scaffold(
      appBar: AppBar(title: Text(t('appTitle'))),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(t('selectMonthYear'),
                style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<int>(
                    value: selectedMonth,
                    items: List.generate(
                      12,
                      (i) => DropdownMenuItem(
                        value: i + 1,
                        child: Text(months[i]),
                      ),
                    ),
                    onChanged: (v) => setState(() => selectedMonth = v!),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: DropdownButtonFormField<int>(
                    value: selectedYear,
                    items: List.generate(
                      21,
                      (i) => DropdownMenuItem(
                        value: 2020 + i,
                        child: Text('${2020 + i}'),
                      ),
                    ),
                    onChanged: (v) => setState(() => selectedYear = v!),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _menuButton(t('overtimeCalendar'), Icons.calendar_month, _openCalendar),
            const SizedBox(height: 12),
            _menuButton(t('salaryEmployerSettings'), Icons.settings, _openSettings),
            const SizedBox(height: 12),
            _menuButton(t('startDateSettings'), Icons.flag, _openStartDate),
            const SizedBox(height: 12),
            _menuButton(t('visualSettings'), Icons.brightness_6, _openTheme),
            const SizedBox(height: 12),
            _menuButton(t('taxSettings'), Icons.account_balance_wallet, _openTax),
            const SizedBox(height: 12),
            _menuButton(t('leaveTracking'), Icons.beach_access, _openLeave),
            const SizedBox(height: 12),
            _menuButton(t('language'), Icons.language, _openLanguage),
            const SizedBox(height: 12),
            _menuButton(t('pdfExport'), Icons.picture_as_pdf, _openPdfExport),
            const SizedBox(height: 12),
            _menuButton(t('encrypt'), Icons.key, _openEncrypt),
            const SizedBox(height: 12),
            _menuButton(t('about'), Icons.info, _openAbout),
          ],
        ),
      ),
      bottomNavigationBar: const SafeArea(child: BannerAdWidget()),
    );
  }
}