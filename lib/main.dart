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
    themeNotifier.value = themeModeFromString(s.themeMode);
    languageNotifier.value = s.language;
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

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) return t('greetingMorning');
    if (hour >= 12 && hour < 18) return t('greetingDay');
    if (hour >= 18 && hour < 23) return t('greetingEvening');
    return t('greetingNight');
  }

  Map<String, int> _monthStats() {
    int overtimeDays = 0;
    int annualLeaveDays = 0;
    int compOffDays = 0;
    int lateDays = 0;
    int absentDays = 0;
    records.forEach((key, r) {
      final d = DateTime.tryParse(key);
      if (d == null) return;
      if (d.year != selectedYear || d.month != selectedMonth) return;
      if (r.type == 'mesai' && r.hours > 0) overtimeDays += 1;
      if (r.type == 'ucretliIzin') annualLeaveDays += 1;
      if (r.type == 'telafi') compOffDays += 1;
      if (r.gecKalmaDakika > 0) lateDays += 1;
      if (r.type == 'gitmedim') absentDays += 1;
    });
    return {
      'overtimeDays': overtimeDays,
      'annualLeaveDays': annualLeaveDays,
      'compOffDays': compOffDays,
      'lateDays': lateDays,
      'absentDays': absentDays,
    };
  }

  Widget _miniStat(String value, String label) {
    return Expanded(
      child: Column(
        children: [
          Text(value,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          const SizedBox(height: 2),
          Text(label,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 10, color: Colors.grey.shade500)),
        ],
      ),
    );
  }

  Widget _vDivider() {
    return Container(
      width: 0.5,
      height: 30,
      color: Colors.grey.withOpacity(0.25),
    );
  }

  Widget _menuRow({
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String label,
    String? trailingText,
    required VoidCallback onTap,
    bool showDivider = true,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        decoration: BoxDecoration(
          border: showDivider
              ? Border(
                  bottom: BorderSide(
                    color: Theme.of(context).dividerColor.withOpacity(0.3),
                    width: 0.5,
                  ),
                )
              : null,
        ),
        child: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 17, color: iconColor),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(label,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
            ),
            if (trailingText != null)
              Padding(
                padding: const EdgeInsets.only(right: 4),
                child: Text(trailingText,
                    style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).textTheme.bodySmall?.color)),
              ),
            Icon(Icons.chevron_right, size: 16, color: Colors.grey.shade600),
          ],
        ),
      ),
    );
  }

  Widget _sectionLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 4),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.3,
          color: Colors.grey.shade500,
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
    final stats = _monthStats();

    return Scaffold(
      appBar: AppBar(title: Text(t('appTitle'))),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_greeting(),
                style: TextStyle(fontSize: 13, color: Colors.grey.shade500)),
            const SizedBox(height: 12),
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
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(
                    color: Colors.grey.withOpacity(0.25), width: 0.5),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${months[selectedMonth - 1]} $selectedYear',
                            style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade500,
                                fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '${stats['overtimeDays']} ${t('daySuffix')}',
                            style: const TextStyle(
                                fontSize: 24, fontWeight: FontWeight.w500),
                          ),
                          Text(t('overtimeDaysLabel'),
                              style: TextStyle(
                                  fontSize: 11, color: Colors.grey.shade500)),
                        ],
                      ),
                      Icon(Icons.calendar_month,
                          size: 26, color: Colors.grey.shade700),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Divider(color: Colors.grey.withOpacity(0.25), height: 1),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _miniStat('${stats['annualLeaveDays']}', t('statAnnualLeave')),
                      _vDivider(),
                      _miniStat('${stats['compOffDays']}', t('statCompOff')),
                      _vDivider(),
                      _miniStat('${stats['lateDays']}', t('statLate')),
                      _vDivider(),
                      _miniStat('${stats['absentDays']}', t('statAbsent')),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            InkWell(
              onTap: _openCalendar,
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.indigo.shade900.withOpacity(0.4),
                      Colors.indigo.shade700.withOpacity(0.25),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: Colors.indigo.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.calendar_month, color: Colors.white, size: 20),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(t('overtimeCalendar'),
                              style: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w500)),
                          const SizedBox(height: 2),
                          Text(t('openCalendarSubtitle'),
                              style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
                        ],
                      ),
                    ),
                    Icon(Icons.chevron_right, size: 18, color: Colors.grey.shade500),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            _sectionLabel(t('groupSettings2')),
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white.withOpacity(0.04)
                    : Colors.black.withOpacity(0.03),
                borderRadius: BorderRadius.circular(14),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Column(
                children: [
                  _menuRow(
                    icon: Icons.payments_outlined,
                    iconColor: Colors.teal,
                    iconBg: Colors.teal.withOpacity(0.15),
                    label: t('salaryEmployerSettings'),
                    onTap: _openSettings,
                  ),
                  _menuRow(
                    icon: Icons.flag_outlined,
                    iconColor: Colors.orange,
                    iconBg: Colors.orange.withOpacity(0.15),
                    label: t('startDateSettings'),
                    onTap: _openStartDate,
                  ),
                  _menuRow(
                    icon: Icons.tune,
                    iconColor: Colors.purple,
                    iconBg: Colors.purple.withOpacity(0.15),
                    label: t('visualSettings'),
                    onTap: _openTheme,
                  ),
                  _menuRow(
                    icon: Icons.account_balance_wallet_outlined,
                    iconColor: Colors.redAccent,
                    iconBg: Colors.redAccent.withOpacity(0.15),
                    label: t('taxSettings'),
                    onTap: _openTax,
                    showDivider: false,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _sectionLabel(t('groupOther')),
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white.withOpacity(0.04)
                    : Colors.black.withOpacity(0.03),
                borderRadius: BorderRadius.circular(14),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Column(
                children: [
                  _menuRow(
                    icon: Icons.beach_access_outlined,
                    iconColor: Colors.indigo,
                    iconBg: Colors.indigo.withOpacity(0.15),
                    label: t('leaveTracking'),
                    onTap: _openLeave,
                  ),
                  _menuRow(
                    icon: Icons.language,
                    iconColor: Colors.blue,
                    iconBg: Colors.blue.withOpacity(0.15),
                    label: t('language'),
                    onTap: _openLanguage,
                  ),
                  _menuRow(
                    icon: Icons.picture_as_pdf_outlined,
                    iconColor: Colors.pinkAccent,
                    iconBg: Colors.pinkAccent.withOpacity(0.15),
                    label: t('pdfExport'),
                    onTap: _openPdfExport,
                  ),
                  _menuRow(
                    icon: Icons.lock_outline,
                    iconColor: Colors.indigo,
                    iconBg: Colors.indigo.withOpacity(0.15),
                    label: t('encrypt'),
                    onTap: _openEncrypt,
                  ),
                  _menuRow(
                    icon: Icons.info_outline,
                    iconColor: Colors.indigo,
                    iconBg: Colors.indigo.withOpacity(0.15),
                    label: t('about'),
                    onTap: _openAbout,
                    showDivider: false,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const SafeArea(child: BannerAdWidget()),
    );
  }
}
