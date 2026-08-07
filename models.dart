import 'dart:convert';
import 'package:flutter/material.dart';

final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier<ThemeMode>(ThemeMode.system);

ThemeMode themeModeFromString(String s) {
  if (s == 'light') return ThemeMode.light;
  if (s == 'dark') return ThemeMode.dark;
  return ThemeMode.system;
}

class DayRecord {
  String type;
  double hours;
  bool resmiTatil;
  double gecKalmaDakika;
  double avans;
  double bahsis;
  String not;

  DayRecord({
    this.type = 'mesai',
    this.hours = 0,
    this.resmiTatil = false,
    this.gecKalmaDakika = 0,
    this.avans = 0,
    this.bahsis = 0,
    this.not = '',
  });

  bool get isEmptyRecord =>
      type == 'mesai' &&
      hours == 0 &&
      resmiTatil == false &&
      gecKalmaDakika == 0 &&
      avans == 0 &&
      bahsis == 0 &&
      not.isEmpty;

  Map<String, dynamic> toJson() => {
        'type': type,
        'hours': hours,
        'resmiTatil': resmiTatil,
        'gecKalmaDakika': gecKalmaDakika,
        'avans': avans,
        'bahsis': bahsis,
        'not': not,
      };

  factory DayRecord.fromJson(Map<String, dynamic> j) => DayRecord(
        type: j['type'] ?? 'mesai',
        hours: (j['hours'] ?? 0).toDouble(),
        resmiTatil: j['resmiTatil'] ?? false,
        gecKalmaDakika: (j['gecKalmaDakika'] ?? 0).toDouble(),
        avans: (j['avans'] ?? 0).toDouble(),
        bahsis: (j['bahsis'] ?? 0).toDouble(),
        not: j['not'] ?? '',
      );
}

class TaxYearSettings {
  double sgkOrani;
  double issizlikOrani;
  double gelirVergisiOrani;
  double damgaVergisiOrani;
  double asgariUcretBrut;
  double asgariUcretNet;

  TaxYearSettings({
    this.sgkOrani = 0.14,
    this.issizlikOrani = 0.01,
    this.gelirVergisiOrani = 0.15,
    this.damgaVergisiOrani = 0.00759,
    this.asgariUcretBrut = 33030,
    this.asgariUcretNet = 28075.5,
  });

  Map<String, dynamic> toJson() => {
        'sgkOrani': sgkOrani,
        'issizlikOrani': issizlikOrani,
        'gelirVergisiOrani': gelirVergisiOrani,
        'damgaVergisiOrani': damgaVergisiOrani,
        'asgariUcretBrut': asgariUcretBrut,
        'asgariUcretNet': asgariUcretNet,
      };

  factory TaxYearSettings.fromJson(Map<String, dynamic> j) => TaxYearSettings(
        sgkOrani: (j['sgkOrani'] ?? 0.14).toDouble(),
        issizlikOrani: (j['issizlikOrani'] ?? 0.01).toDouble(),
        gelirVergisiOrani: (j['gelirVergisiOrani'] ?? 0.15).toDouble(),
        damgaVergisiOrani: (j['damgaVergisiOrani'] ?? 0.00759).toDouble(),
        asgariUcretBrut: (j['asgariUcretBrut'] ?? 33030).toDouble(),
        asgariUcretNet: (j['asgariUcretNet'] ?? 28075.5).toDouble(),
      );
}

Map<int, TaxYearSettings> decodeTaxYears(String? jsonStr) {
  final map = <int, TaxYearSettings>{};
  if (jsonStr == null) return map;
  final decoded = jsonDecode(jsonStr) as Map<String, dynamic>;
  decoded.forEach((k, v) {
    map[int.parse(k)] = TaxYearSettings.fromJson(v as Map<String, dynamic>);
  });
  return map;
}

String encodeTaxYears(Map<int, TaxYearSettings> map) {
  final out = <String, dynamic>{};
  map.forEach((k, v) {
    out[k.toString()] = v.toJson();
  });
  return jsonEncode(out);
}

TaxYearSettings taxForYear(Map<int, TaxYearSettings> map, int year) {
  if (map.containsKey(year)) return map[year]!;
  final earlierYears = map.keys.where((y) => y <= year).toList();
  if (earlierYears.isNotEmpty) {
    earlierYears.sort();
    return map[earlierYears.last]!;
  }
  if (map.isNotEmpty) {
    final laterYears = map.keys.toList()..sort();
    return map[laterYears.first]!;
  }
  return TaxYearSettings();
}

class AppSettings {
  String employerType;
  double hourlyRate;
  double monthlySalary;
  double standardMonthlyHours;

  double multiplierHaftaIci;
  double multiplierCumartesi;
  double multiplierPazar;
  double multiplierResmiTatil;

  String maasHesapModu;
  double brutMaasGirisi;
  double netMaasGirisi;
  double manuelNetMaas;
  bool haftaTatiliKesintileri;

  String resmiTatilHesapSekli;
  String netMaasHesapSekli;
  String raporluHesapSekli;

  String themeMode;
  String language;
  String? iseBaslamaTarihi;
  double yillikIzinHakki;
  String? pinCode;

  AppSettings({
    this.employerType = 'aylik',
    this.hourlyRate = 100,
    this.monthlySalary = 30000,
    this.standardMonthlyHours = 225,
    this.multiplierHaftaIci = 1.5,
    this.multiplierCumartesi = 1.5,
    this.multiplierPazar = 2.0,
    this.multiplierResmiTatil = 2.0,
    this.maasHesapModu = 'net',
    this.brutMaasGirisi = 35000,
    this.netMaasGirisi = 30000,
    this.manuelNetMaas = 30000,
    this.haftaTatiliKesintileri = true,
    this.resmiTatilHesapSekli = 'tamamenFazlaMesai',
    this.netMaasHesapSekli = 'gunSayisinaGore',
    this.raporluHesapSekli = 'odemeYok',
    this.themeMode = 'system',
    this.language = 'tr',
    this.iseBaslamaTarihi,
    this.yillikIzinHakki = 14,
    this.pinCode,
  });

  Map<String, dynamic> toJson() => {
        'employerType': employerType,
        'hourlyRate': hourlyRate,
        'monthlySalary': monthlySalary,
        'standardMonthlyHours': standardMonthlyHours,
        'multiplierHaftaIci': multiplierHaftaIci,
        'multiplierCumartesi': multiplierCumartesi,
        'multiplierPazar': multiplierPazar,
        'multiplierResmiTatil': multiplierResmiTatil,
        'maasHesapModu': maasHesapModu,
        'brutMaasGirisi': brutMaasGirisi,
        'netMaasGirisi': netMaasGirisi,
        'manuelNetMaas': manuelNetMaas,
        'haftaTatiliKesintileri': haftaTatiliKesintileri,
        'resmiTatilHesapSekli': resmiTatilHesapSekli,
        'netMaasHesapSekli': netMaasHesapSekli,
        'raporluHesapSekli': raporluHesapSekli,
        'themeMode': themeMode,
        'language': language,
        'iseBaslamaTarihi': iseBaslamaTarihi,
        'yillikIzinHakki': yillikIzinHakki,
        'pinCode': pinCode,
      };

  factory AppSettings.fromJson(Map<String, dynamic> j) => AppSettings(
        employerType: j['employerType'] ?? 'aylik',
        hourlyRate: (j['hourlyRate'] ?? 100).toDouble(),
        monthlySalary: (j['monthlySalary'] ?? 30000).toDouble(),
        standardMonthlyHours: (j['standardMonthlyHours'] ?? 225).toDouble(),
        multiplierHaftaIci: (j['multiplierHaftaIci'] ?? 1.5).toDouble(),
        multiplierCumartesi: (j['multiplierCumartesi'] ?? 1.5).toDouble(),
        multiplierPazar: (j['multiplierPazar'] ?? 2.0).toDouble(),
        multiplierResmiTatil: (j['multiplierResmiTatil'] ?? 2.0).toDouble(),
        maasHesapModu: j['maasHesapModu'] ?? 'net',
        brutMaasGirisi: (j['brutMaasGirisi'] ?? 35000).toDouble(),
        netMaasGirisi: (j['netMaasGirisi'] ?? 30000).toDouble(),
        manuelNetMaas: (j['manuelNetMaas'] ?? 30000).toDouble(),
        haftaTatiliKesintileri: j['haftaTatiliKesintileri'] ?? true,
        resmiTatilHesapSekli: j['resmiTatilHesapSekli'] ?? 'tamamenFazlaMesai',
        netMaasHesapSekli: j['netMaasHesapSekli'] ?? 'gunSayisinaGore',
        raporluHesapSekli: j['raporluHesapSekli'] ?? 'odemeYok',
        themeMode: j['themeMode'] ?? 'system',
        language: j['language'] ?? 'tr',
        iseBaslamaTarihi: j['iseBaslamaTarihi'],
        yillikIzinHakki: (j['yillikIzinHakki'] ?? 14).toDouble(),
        pinCode: j['pinCode'],
      );

  AppSettings copyWith({String? pinCode, bool clearPin = false}) {
    return AppSettings(
      employerType: employerType,
      hourlyRate: hourlyRate,
      monthlySalary: monthlySalary,
      standardMonthlyHours: standardMonthlyHours,
      multiplierHaftaIci: multiplierHaftaIci,
      multiplierCumartesi: multiplierCumartesi,
      multiplierPazar: multiplierPazar,
      multiplierResmiTatil: multiplierResmiTatil,
      maasHesapModu: maasHesapModu,
      brutMaasGirisi: brutMaasGirisi,
      netMaasGirisi: netMaasGirisi,
      manuelNetMaas: manuelNetMaas,
      haftaTatiliKesintileri: haftaTatiliKesintileri,
      resmiTatilHesapSekli: resmiTatilHesapSekli,
      netMaasHesapSekli: netMaasHesapSekli,
      raporluHesapSekli: raporluHesapSekli,
      themeMode: themeMode,
      language: language,
      iseBaslamaTarihi: iseBaslamaTarihi,
      yillikIzinHakki: yillikIzinHakki,
      pinCode: clearPin ? null : (pinCode ?? this.pinCode),
    );
  }

  bool get isSaatlik => employerType == 'saatlik';

  double sgkIsciPayi(TaxYearSettings tax) => brutMaasGirisi * tax.sgkOrani;
  double issizlikPayi(TaxYearSettings tax) => brutMaasGirisi * tax.issizlikOrani;
  double gelirVergisiMatrahi(TaxYearSettings tax) =>
      brutMaasGirisi - sgkIsciPayi(tax) - issizlikPayi(tax);
  double gelirVergisi(TaxYearSettings tax) =>
      gelirVergisiMatrahi(tax) * tax.gelirVergisiOrani;
  double damgaVergisi(TaxYearSettings tax) => brutMaasGirisi * tax.damgaVergisiOrani;
  double kesintilerToplami(TaxYearSettings tax) =>
      sgkIsciPayi(tax) + issizlikPayi(tax) + gelirVergisi(tax) + damgaVergisi(tax);
  double hesaplananNetMaas(TaxYearSettings tax) =>
      brutMaasGirisi - kesintilerToplami(tax);

  double effectiveNetMaas(TaxYearSettings tax) {
    if (isSaatlik) return hourlyRate * standardMonthlyHours;
    if (maasHesapModu == 'brut') return hesaplananNetMaas(tax);
    if (maasHesapModu == 'manuel') return manuelNetMaas;
    return netMaasGirisi;
  }

  double netMaasForMonth(int daysInMonth, TaxYearSettings tax) {
    if (netMaasHesapSekli == 'gunSayisinaGore') {
      return effectiveNetMaas(tax) / 30 * daysInMonth;
    }
    return effectiveNetMaas(tax);
  }

  double hourlyRateForCalc(TaxYearSettings tax) {
    if (isSaatlik) return hourlyRate;
    return effectiveNetMaas(tax) / 30 / 7.5;
  }

  double baseMonthlyEarning(TaxYearSettings tax) => effectiveNetMaas(tax);

  double baseMonthlyEarningForMonth(int daysInMonth, TaxYearSettings tax) =>
      netMaasForMonth(daysInMonth, tax);
}

Map<String, DayRecord> decodeRecords(String? jsonStr) {
  final map = <String, DayRecord>{};
  if (jsonStr == null) return map;
  final decoded = jsonDecode(jsonStr) as Map<String, dynamic>;
  decoded.forEach((k, v) {
    map[k] = DayRecord.fromJson(v as Map<String, dynamic>);
  });
  return map;
}

String encodeRecords(Map<String, DayRecord> records) {
  final map = <String, dynamic>{};
  records.forEach((k, v) {
    map[k] = v.toJson();
  });
  return jsonEncode(map);
}