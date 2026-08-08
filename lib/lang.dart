import 'package:flutter/material.dart';

final ValueNotifier<String> languageNotifier = ValueNotifier<String>('tr');

final Map<String, Map<String, String>> _translations = {
  'appTitle': {'tr': 'Mesaimatik', 'ur': 'Mesaimatik', 'ne': 'Mesaimatik'},
  'selectMonthYear': {
    'tr': 'AY VE YIL SEC', 'ur': 'مہینہ اور سال منتخب کریں', 'ne': 'महिना र वर्ष छान्नुहोस्',
  },
  'overtimeCalendar': {
    'tr': 'FAZLA MESAI GIRISI (TAKVIM)', 'ur': 'اضافی کام کا اندراج (کیلنڈر)', 'ne': 'ओभरटाइम प्रविष्टि (क्यालेन्डर)',
  },
  'salaryEmployerSettings': {
    'tr': 'MAAS VE ISVEREN AYARLARI', 'ur': 'تنخواہ اور آجر کی ترتیبات', 'ne': 'तलब र रोजगारदाता सेटिङ',
  },
  'startDateSettings': {
    'tr': 'ISE BASLAMA AYARLARI', 'ur': 'ملازمت شروع کرنے کی ترتیبات', 'ne': 'काम सुरु मिति सेटिङ',
  },
  'visualSettings': {
    'tr': 'GORSEL AYARLAR', 'ur': 'بصری ترتیبات', 'ne': 'देखावट सेटिङ',
  },
  'taxSettings': {
    'tr': 'VERGI/ASGARI UCRET AYARLARI', 'ur': 'ٹیکس/کم از کم اجرت کی ترتیبات', 'ne': 'कर/न्यूनतम ज्याला सेटिङ',
  },
  'leaveTracking': {
    'tr': 'YILLIK IZIN TAKIBI', 'ur': 'سالانہ چھٹی کا ٹریکنگ', 'ne': 'वार्षिक बिदा ट्र्याकिङ',
  },
  'language': {'tr': 'DIL', 'ur': 'زبان', 'ne': 'भाषा'},
  'pdfExport': {
    'tr': 'PDF E AKTAR', 'ur': 'PDF میں برآمد کریں', 'ne': 'PDF मा निर्यात गर्नुहोस्',
  },
  'encrypt': {
    'tr': 'PROGRAMI SIFRELE', 'ur': 'پروگرام کو محفوظ بنائیں', 'ne': 'प्रोग्राम लक गर्नुहोस्',
  },
  'about': {'tr': 'HAKKINDA', 'ur': 'کے بارے میں', 'ne': 'बारेमा'},
  'languageScreenTitle': {
    'tr': 'Dil Ayarlari', 'ur': 'زبان کی ترتیبات', 'ne': 'भाषा सेटिङ',
  },
  'selectLanguage': {
    'tr': 'Uygulama dilini secin', 'ur': 'ایپ کی زبان منتخب کریں', 'ne': 'एपको भाषा छान्नुहोस्',
  },
  'save': {'tr': 'Kaydet', 'ur': 'محفوظ کریں', 'ne': 'सुरक्षित गर्नुहोस्'},
  'months': {
    'tr': 'Ocak,Subat,Mart,Nisan,Mayis,Haziran,Temmuz,Agustos,Eylul,Ekim,Kasim,Aralik',
    'ur': 'جنوری,فروری,مارچ,اپریل,مئی,جون,جولائی,اگست,ستمبر,اکتوبر,نومبر,دسمبر',
    'ne': 'जनवरी,फेब्रुअरी,मार्च,अप्रिल,मे,जुन,जुलाई,अगस्ट,सेप्टेम्बर,अक्टोबर,नोभेम्बर,डिसेम्बर',
  },
  'calendarTitle': {'tr': 'Takvim', 'ur': 'کیلنڈر', 'ne': 'क्यालेन्डर'},
  'weekdayHours': {'tr': 'Haftaici saat:', 'ur': 'ہفتے کے دن گھنٹے:', 'ne': 'हप्ताको दिन घण्टा:'},
  'saturdayHours': {'tr': 'Cumartesi saat:', 'ur': 'ہفتہ کے گھنٹے:', 'ne': 'शनिबार घण्टा:'},
  'sundayHours': {'tr': 'Pazar saat:', 'ur': 'اتوار کے گھنٹے:', 'ne': 'आइतबार घण्टा:'},
  'holidayHours': {'tr': 'Resmi tatil saat:', 'ur': 'سرکاری تعطیل گھنٹے:', 'ne': 'सार्वजनिक बिदा घण्टा:'},
  'advanceTotal': {'tr': 'Avans toplami:', 'ur': 'کل ایڈوانس:', 'ne': 'कुल पेश्की:'},
  'tipTotal': {'tr': 'Bahsis toplami:', 'ur': 'کل انعام:', 'ne': 'कुल टिप:'},
  'normallyNetSalary': {
    'tr': '(Normalde net maas:', 'ur': '(عام طور پر خالص تنخواہ:', 'ne': '(सामान्यतया खुद तलब:',
  },
  'daysNetSalary': {'tr': 'gunluk net maas: +', 'ur': 'دن کی خالص تنخواہ: +', 'ne': 'दिनको खुद तलब: +'},
  'overtimeExtra': {
    'tr': 'Fazla mesai / ekstra saat ucreti: +',
    'ur': 'اضافی وقت / اضافی گھنٹے کی اجرت: +',
    'ne': 'ओभरटाइम / अतिरिक्त घण्टा ज्याला: +',
  },
  'finalSalary': {'tr': 'Ele gecen maas:', 'ur': 'ہاتھ میں آنے والی تنخواہ:', 'ne': 'हातमा पर्ने तलब:'},
  'day_officialHoliday': {
    'tr': 'Bu gun resmi tatil ve ben calistim',
    'ur': 'یہ سرکاری تعطیل ہے اور میں نے کام کیا',
    'ne': 'यो सार्वजनिक बिदा हो र मैले काम गरें',
  },
  'day_overtime': {'tr': 'Fazla mesai yaptim', 'ur': 'میں نے اضافی کام کیا', 'ne': 'मैले ओभरटाइम गरें'},
  'day_overtimeHours': {
    'tr': 'Fazla mesai saati', 'ur': 'اضافی کام کے گھنٹے', 'ne': 'ओभरटाइम घण्टा',
  },
  'day_absent': {'tr': 'Ise gitmedim', 'ur': 'میں کام پر نہیں گیا', 'ne': 'म काममा गइनँ'},
  'day_sick': {'tr': 'Raporluyum', 'ur': 'میں بیمار ہوں', 'ne': 'म बिरामी छु'},
  'day_paidLeave': {
    'tr': 'Ucretli/Yillik izindeyim', 'ur': 'میں تنخواہ دار/سالانہ چھٹی پر ہوں', 'ne': 'म तलबी/वार्षिक बिदामा छु',
  },
  'day_unpaidLeave': {
    'tr': 'Ucretsiz izindeyim', 'ur': 'میں بلا تنخواہ چھٹی پر ہوں', 'ne': 'म बिना तलब बिदामा छु',
  },
  'day_lateMinutes': {
    'tr': 'Ise gec kaldiysaniz dakika belirtin',
    'ur': 'اگر آپ دیر سے آئے تو منٹ بتائیں',
    'ne': 'ढिलो भएमा मिनेट लेख्नुहोस्',
  },
  'day_advance': {
    'tr': 'Avans cektiyseniz belirtin', 'ur': 'اگر آپ نے ایڈوانس لیا تو بتائیں', 'ne': 'पेश्की लिनुभएको भए लेख्नुहोस्',
  },
  'day_tip': {
    'tr': 'Bahsis/Ekstra aldiysaniz belirtin', 'ur': 'اگر آپ کو انعام/اضافی ملا تو بتائیں', 'ne': 'टिप/थप पाउनुभएको भए लेख्नुहोस्',
  },
  'day_note': {'tr': 'Notunuz', 'ur': 'آپ کا نوٹ', 'ne': 'तपाईंको नोट'},
  'delete': {'tr': 'Sil', 'ur': 'حذف کریں', 'ne': 'मेटाउनुहोस्'},
  'cancel': {'tr': 'VAZGEC', 'ur': 'منسوخ کریں', 'ne': 'रद्द गर्नुहोस्'},
  'ok': {'tr': 'TAMAM', 'ur': 'ٹھیک ہے', 'ne': 'ठीक छ'},
  'salaryEmployerSettingsTitle': {
    'tr': 'Maas ve Isveren Ayarlari', 'ur': 'تنخواہ اور آجر ترتیبات', 'ne': 'तलब र रोजगारदाता सेटिङ',
  },
  'salaryTab': {'tr': 'MAAS AYARLARI', 'ur': 'تنخواہ ترتیبات', 'ne': 'तलब सेटिङ'},
  'employerTab': {'tr': 'ISVEREN AYARLARI', 'ur': 'آجر ترتیبات', 'ne': 'रोजगारदाता सेटिङ'},
  'iptalBtn': {'tr': 'Iptal', 'ur': 'منسوخ کریں', 'ne': 'रद्द गर्नुहोस्'},
  'workType': {'tr': 'Calisma tipi', 'ur': 'کام کی قسم', 'ne': 'काम को प्रकार'},
  'hourlyPaid': {'tr': 'Saatlik ucretli', 'ur': 'فی گھنٹہ اجرت', 'ne': 'प्रति घण्टा ज्याला'},
  'monthlyPaid': {'tr': 'Aylik maasli', 'ur': 'ماہانہ تنخواہ', 'ne': 'मासिक तलब'},
  'hourlyInfoText': {
    'tr': 'Saatlik ucretiniz ve standart aylik saatinizden bir net maas hesaplanir, bu maas ayin gun sayisina gore olceklenir. Takvime girdiginiz ekstra saatler ayrica eklenir.',
    'ur': 'آپ کی فی گھنٹہ اجرت اور معیاری ماہانہ گھنٹوں سے ایک خالص تنخواہ کا حساب لگایا جاتا ہے، یہ تنخواہ مہینے کے دنوں کی تعداد کے مطابق ایڈجسٹ ہوتی ہے۔ کیلنڈر میں درج اضافی گھنٹے الگ سے شامل کیے جاتے ہیں۔',
    'ne': 'तपाईंको प्रति घण्टा ज्याला र मानक मासिक घण्टाबाट खुद तलब गणना गरिन्छ, यो तलब महिनाको दिन संख्या अनुसार समायोजन गरिन्छ। क्यालेन्डरमा प्रविष्ट गरिएका थप घण्टाहरू छुट्टै थपिन्छ।',
  },
  'hourlyRateLabel': {'tr': 'Saatlik ucretiniz (TL)', 'ur': 'آپ کی فی گھنٹہ اجرت (TL)', 'ne': 'तपाईंको प्रति घण्टा ज्याला (TL)'},
  'standardHoursLabel': {
    'tr': 'Standart aylik saat (orn. 225, 30 gun icin)',
    'ur': 'معیاری ماہانہ گھنٹے (مثلاً 225، 30 دن کے لیے)',
    'ne': 'मानक मासिक घण्टा (जस्तै 225, 30 दिनको लागि)',
  },
  'salaryCalcMethod': {'tr': 'Maas nasil hesaplansin', 'ur': 'تنخواہ کیسے شمار کی جائے', 'ne': 'तलब कसरी गणना गर्ने'},
  'calcFromGross': {
    'tr': 'Brut maas uzerinden otomatik hesapla', 'ur': 'مجموعی تنخواہ سے خودکار حساب لگائیں', 'ne': 'कुल तलबबाट स्वचालित गणना गर्नुहोस्',
  },
  'calcFromNet': {
    'tr': 'Net maas uzerinden otomatik hesapla', 'ur': 'خالص تنخواہ سے خودکار حساب لگائیں', 'ne': 'खुद तलबबाट स्वचालित गणना गर्नुहोस्',
  },
  'calcManual': {
    'tr': 'Manuel: net maasi ben gireceğim', 'ur': 'دستی: میں خالص تنخواہ خود درج کروں گا', 'ne': 'म्यानुअल: म खुद तलब आफैं प्रविष्ट गर्नेछु',
  },
  'grossSalaryLabel': {'tr': 'Brut maasiniz (30 gun icin)', 'ur': 'آپ کی مجموعی تنخواہ (30 دن کے لیے)', 'ne': 'तपाईंको कुल तलब (30 दिनको लागि)'},
  'sgkShare': {'tr': 'SGK Isci Payi', 'ur': 'SGK ملازم حصہ', 'ne': 'SGK कर्मचारी हिस्सा'},
  'unemploymentShare': {'tr': 'Issiz. Sigortasi Payi', 'ur': 'بے روزگاری انشورنس حصہ', 'ne': 'बेरोजगारी बीमा हिस्सा'},
  'incomeTaxBase': {'tr': 'Bu Ayki Gelir Vergisi Matrahi', 'ur': 'اس ماہ کی انکم ٹیکس بنیاد', 'ne': 'यस महिनाको आयकर आधार'},
  'incomeTax': {'tr': 'Gelir Vergisi', 'ur': 'انکم ٹیکس', 'ne': 'आयकर'},
  'stampTax': {'tr': 'Damga Vergisi', 'ur': 'اسٹامپ ڈیوٹی', 'ne': 'स्ट्याम्प कर'},
  'totalDeductions': {'tr': 'Kesintiler Toplami', 'ur': 'کل کٹوتیاں', 'ne': 'कुल कटौती'},
  'netSalaryLabel30': {'tr': 'Net maasiniz (30 gun icin)', 'ur': 'آپ کی خالص تنخواہ (30 دن کے لیے)', 'ne': 'तपाईंको खुद तलब (30 दिनको लागि)'},
  'netSalaryManualLabel': {
    'tr': 'Net maasiniz (30 gun icin, elle girin)', 'ur': 'آپ کی خالص تنخواہ (30 دن، دستی طور پر درج کریں)', 'ne': 'तपाईंको खुद तलब (30 दिन, आफैं प्रविष्ट गर्नुहोस्)',
  },
  'weekendDeductions': {'tr': 'Hafta tatili kesintileri', 'ur': 'ہفتہ وار چھٹی کٹوتیاں', 'ne': 'साप्ताहिक बिदा कटौती'},
  'overtimeMultipliersTitle': {'tr': 'Fazla mesai carpanlari', 'ur': 'اضافی وقت کے ضرب', 'ne': 'ओभरटाइम गुणक'},
  'weekdayMultiplierLabel': {'tr': 'Haftaici carpani (orn. 1.5)', 'ur': 'ہفتہ کے دن کا ضرب (مثلاً 1.5)', 'ne': 'हप्ताको दिन गुणक (जस्तै 1.5)'},
  'saturdayMultiplierLabel': {'tr': 'Cumartesi carpani (orn. 1.5)', 'ur': 'ہفتے کا ضرب (مثلاً 1.5)', 'ne': 'शनिबार गुणक (जस्तै 1.5)'},
  'sundayMultiplierLabel': {'tr': 'Pazar carpani (orn. 2.0)', 'ur': 'اتوار کا ضرب (مثلاً 2.0)', 'ne': 'आइतबार गुणक (जस्तै 2.0)'},
  'holidayMultiplierLabel': {'tr': 'Resmi tatil carpani (orn. 2.0)', 'ur': 'سرکاری تعطیل کا ضرب (مثلاً 2.0)', 'ne': 'सार्वजनिक बिदा गुणक (जस्तै 2.0)'},
  'hourlyRateResult': {'tr': '1 saatlik ucretiniz', 'ur': 'آپ کی 1 گھنٹے کی اجرت', 'ne': 'तपाईंको १ घण्टा ज्याला'},
  'weekdayHourlyRate': {'tr': 'Haftaici 1 saat ucret', 'ur': 'ہفتہ کے دن 1 گھنٹے کی اجرت', 'ne': 'हप्ताको दिन १ घण्टा ज्याला'},
  'saturdayHourlyRate': {'tr': 'Cumartesi 1 saat ucret', 'ur': 'ہفتے 1 گھنٹے کی اجرت', 'ne': 'शनिबार १ घण्टा ज्याला'},
  'sundayHourlyRate': {'tr': 'Pazar 1 saat ucret', 'ur': 'اتوار 1 گھنٹے کی اجرت', 'ne': 'आइतबार १ घण्टा ज्याला'},
  'holidayHourlyRate': {'tr': 'Resmi tatil 1 saat ucret', 'ur': 'سرکاری تعطیل 1 گھنٹے کی اجرت', 'ne': 'सार्वजनिक बिदा १ घण्टा ज्याला'},
  'monthlyNetSalaryText': {
    'tr': 'Bu ay (%d gun) icin net maas: ', 'ur': 'اس مہینے (%d دن) کی خالص تنخواہ: ', 'ne': 'यस महिना (%d दिन) को खुद तलब: ',
  },
  'employerHolidayQuestion': {
    'tr': 'ISVERENINIZ RESMI TATIL CALISMALARININ UCRETLERINI NASIL HESAPLAR?',
    'ur': 'آپ کا آجر سرکاری تعطیل کے کام کی اجرت کیسے شمار کرتا ہے؟',
    'ne': 'तपाईंको रोजगारदाताले सार्वजनिक बिदाको काम कसरी गणना गर्छ?',
  },
  'holidayOptionExtraDay': {
    'tr': 'Resmi tatilde calistiginizda fazladan bir gunluk ucret veriyorsa bu secenegi isaretleyin.',
    'ur': 'اگر سرکاری تعطیل پر کام کرنے پر ایک اضافی دن کی اجرت ملتی ہے تو یہ آپشن منتخب کریں۔',
    'ne': 'सार्वजनिक बिदामा काम गर्दा थप एक दिनको ज्याला दिने भए यो विकल्प छान्नुहोस्।',
  },
  'holidayOptionOvertime': {
    'tr': 'Isvereniniz resmi tatildeki tum calismanizi fazla mesai olarak oduyorsa bu secenegi isaretleyin.',
    'ur': 'اگر آجر سرکاری تعطیل کے تمام کام کو اضافی وقت کے طور پر ادا کرتا ہے تو یہ آپشن منتخب کریں۔',
    'ne': 'रोजगारदाताले सार्वजनिक बिदाको सबै काम ओभरटाइमको रूपमा तिर्ने भए यो विकल्प छान्नुहोस्।',
  },
  'employerNetSalaryQuestion': {
    'tr': 'ISVERENINIZ NET MAASI NASIL HESAPLAR?', 'ur': 'آپ کا آجر خالص تنخواہ کیسے شمار کرتا ہے؟', 'ne': 'तपाईंको रोजगारदाताले खुद तलब कसरी गणना गर्छ?',
  },
  'fixedSalaryOption': {
    'tr': 'Isvereniniz sabit net maas oduyorsa bu secenegi isaretleyin (ay 28-29-31 gun de olsa maas ayni).',
    'ur': 'اگر آجر مقررہ خالص تنخواہ دیتا ہے تو یہ آپشن منتخب کریں (مہینہ 28-29-31 دن کا ہو تب بھی تنخواہ ایک جیسی)۔',
    'ne': 'रोजगारदाताले स्थिर खुद तलब तिर्ने भए यो विकल्प छान्नुहोस् (महिना २८-२९-३१ दिनको भए पनि तलब उही)।',
  },
  'dayBasedSalaryOption': {
    'tr': 'Isvereniniz net maasi aydaki gun sayisina gore hesapliyorsa bu secenegi isaretleyin.',
    'ur': 'اگر آجر خالص تنخواہ مہینے کے دنوں کی تعداد کے مطابق شمار کرتا ہے تو یہ آپشن منتخب کریں۔',
    'ne': 'रोजगारदाताले खुद तलब महिनाको दिन संख्या अनुसार गणना गर्ने भए यो विकल्प छान्नुहोस्।',
  },
  'employerSickPayQuestion': {
    'tr': 'ISVERENINIZ RAPORLU GUN UCRETLERINI NASIL HESAPLAR?', 'ur': 'آپ کا آجر بیماری کی چھٹی کی اجرت کیسے شمار کرتا ہے؟', 'ne': 'तपाईंको रोजगारदाताले बिरामी बिदाको ज्याला कसरी गणना गर्छ?',
  },
  'sickPayNone': {
    'tr': 'Isvereniniz raporlu oldugunuz gunler icin odeme yapmiyorsa bu secenegi isaretleyin.',
    'ur': 'اگر آجر بیماری کی چھٹی کے دنوں کی ادائیگی نہیں کرتا تو یہ آپشن منتخب کریں۔',
    'ne': 'रोजगारदाताले बिरामी बिदाको दिनको भुक्तानी नगर्ने भए यो विकल्प छान्नुहोस्।',
  },
  'sickPayFirst2Days': {
    'tr': 'Isvereniniz raporlu oldugunuz ilk 2 gune odeme yapmiyor, diger gunlere odeme yapiyorsa bu secenegi isaretleyin.',
    'ur': 'اگر آجر پہلے 2 دنوں کی ادائیگی نہیں کرتا مگر باقی دنوں کی کرتا ہے تو یہ آپشن منتخب کریں۔',
    'ne': 'रोजगारदाताले पहिलो २ दिनको भुक्तानी नगरी बाँकी दिनको गर्ने भए यो विकल्प छान्नुहोस्।',
  },
  'sickPayAllDays': {
    'tr': 'Isvereniniz raporlu oldugunuz butun gunler icin odeme yapiyorsa bu secenegi isaretleyin.',
    'ur': 'اگر آجر بیماری کی چھٹی کے تمام دنوں کی ادائیگی کرتا ہے تو یہ آپشن منتخب کریں۔',
    'ne': 'रोजगारदाताले बिरामी बिदाको सबै दिनको भुक्तानी गर्ने भए यो विकल्प छान्नुहोस्।',
  },
  'mon': {'tr': 'Pzt', 'ur': 'پیر', 'ne': 'सोम'},
  'tue': {'tr': 'Sal', 'ur': 'منگل', 'ne': 'मंगल'},
  'wed': {'tr': 'Çar', 'ur': 'بدھ', 'ne': 'बुध'},
  'thu': {'tr': 'Per', 'ur': 'جمعرات', 'ne': 'बिहि'},
  'fri': {'tr': 'Cum', 'ur': 'جمعہ', 'ne': 'शुक्र'},
  'sat': {'tr': 'Cmt', 'ur': 'ہفتہ', 'ne': 'शनि'},
  'sun': {'tr': 'Paz', 'ur': 'اتوار', 'ne': 'आइत'},
};

String t(String key) {
  final lang = languageNotifier.value;
  final entry = _translations[key];
  if (entry == null) return key;
  return entry[lang] ?? entry['tr'] ?? key;
}

List<String> monthNames() {
  return t('months').split(',');
}

TextDirection currentTextDirection() {
  return languageNotifier.value == 'ur' ? TextDirection.rtl : TextDirection.ltr;
}
