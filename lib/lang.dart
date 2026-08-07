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