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
  'startDateTitle': {'tr': 'Ise Baslama Ayarlari', 'ur': 'ملازمت شروع کرنے کی ترتیبات', 'ne': 'काम सुरु मिति सेटिङ'},
  'startDateLabel': {'tr': 'Ise baslama tarihiniz', 'ur': 'آپ کی ملازمت شروع ہونے کی تاریخ', 'ne': 'तपाईंको काम सुरु मिति'},
  'pickDate': {'tr': 'Tarih secin', 'ur': 'تاریخ منتخب کریں', 'ne': 'मिति छान्नुहोस्'},
  'annualLeaveLabel': {'tr': 'Yillik izin hakkiniz (gun)', 'ur': 'آپ کی سالانہ چھٹی کا حق (دن)', 'ne': 'तपाईंको वार्षिक बिदा अधिकार (दिन)'},
  'exampleFourteen': {'tr': 'Orn. 14', 'ur': 'مثلاً 14', 'ne': 'जस्तै 14'},
  'visualSettingsTitle': {'tr': 'Gorsel Ayarlar', 'ur': 'بصری ترتیبات', 'ne': 'देखावट सेटिङ'},
  'themeSelection': {'tr': 'Tema secimi', 'ur': 'تھیم کا انتخاب', 'ne': 'थिम छनोट'},
  'themeSystem': {'tr': 'Telefon ayarina gore (otomatik)', 'ur': 'فون کی ترتیبات کے مطابق (خودکار)', 'ne': 'फोन सेटिङ अनुसार (स्वचालित)'},
  'themeLight': {'tr': 'Acik tema', 'ur': 'روشن تھیم', 'ne': 'उज्यालो थिम'},
  'themeDark': {'tr': 'Koyu tema', 'ur': 'گہرا تھیم', 'ne': 'गाढा थिम'},
  'taxScreenTitle': {'tr': 'Vergi ve Asgari Ucret Ayarlari', 'ur': 'ٹیکس اور کم از کم اجرت کی ترتیبات', 'ne': 'कर र न्यूनतम ज्याला सेटिङ'},
  'selectYear': {'tr': 'Yil secin', 'ur': 'سال منتخب کریں', 'ne': 'वर्ष छान्नुहोस्'},
  'noOwnDataWarning': {
    'tr': 'Bu yil icin henuz ayri deger girilmedi. Onceki yildan tasinan degerler gosteriliyor. Yeni oranlar aciklaninca guncelleyip kaydedin.',
    'ur': 'اس سال کے لیے ابھی تک الگ ویلیو درج نہیں کی گئی۔ پچھلے سال کی ویلیوز دکھائی جا رہی ہیں۔ نئی شرحیں اعلان ہونے پر اپ ڈیٹ کر کے محفوظ کریں۔',
    'ne': 'यस वर्षको लागि अझै छुट्टै मान प्रविष्ट गरिएको छैन। अघिल्लो वर्षका मानहरू देखाइँदैछ। नयाँ दरहरू घोषणा भएपछि अद्यावधिक गरी सुरक्षित गर्नुहोस्।',
  },
  'deductionRatesTitle': {'tr': 'Kesinti oranlari (%)', 'ur': 'کٹوتی کی شرحیں (%)', 'ne': 'कटौती दरहरू (%)'},
  'sgkShareLabel': {'tr': 'SGK Isci Payi (%)', 'ur': 'SGK ملازم حصہ (%)', 'ne': 'SGK कर्मचारी हिस्सा (%)'},
  'unemploymentShareLabel': {'tr': 'Issizlik Sigortasi Payi (%)', 'ur': 'بے روزگاری انشورنس حصہ (%)', 'ne': 'बेरोजगारी बीमा हिस्सा (%)'},
  'incomeTaxLabel': {'tr': 'Gelir Vergisi (%)', 'ur': 'انکم ٹیکس (%)', 'ne': 'आयकर (%)'},
  'stampTaxLabel': {'tr': 'Damga Vergisi (%)', 'ur': 'اسٹامپ ڈیوٹی (%)', 'ne': 'स्ट्याम्प कर (%)'},
  'minWageTitle': {'tr': 'Asgari ucret', 'ur': 'کم از کم اجرت', 'ne': 'न्यूनतम ज्याला'},
  'minWageGrossLabel': {'tr': 'Asgari ucret brut (TL)', 'ur': 'کم از کم اجرت مجموعی (TL)', 'ne': 'न्यूनतम ज्याला कुल (TL)'},
  'minWageNetLabel': {'tr': 'Asgari ucret net (TL)', 'ur': 'کم از کم اجرت خالص (TL)', 'ne': 'न्यूनतम ज्याला खुद (TL)'},
  'saveForYear': {'tr': 'yili icin kaydet', 'ur': 'سال کے لیے محفوظ کریں', 'ne': 'वर्षको लागि सुरक्षित गर्नुहोस्'},
  'taxSavedSnackbar': {'tr': 'yili vergi ayarlari kaydedildi', 'ur': 'سال کی ٹیکس ترتیبات محفوظ ہو گئیں', 'ne': 'वर्षको कर सेटिङ सुरक्षित भयो'},
  'taxYearNote': {
    'tr': 'Not: Her yil icin degerler ayri saklanir. Yeni yil oranlari resmi olarak aciklandiginda bu ekrandan o yili secip degerleri guncelleyin. Guncellenmeyen yillar bir onceki yilin oranlarini kullanmaya devam eder.',
    'ur': 'نوٹ: ہر سال کی ویلیوز الگ محفوظ کی جاتی ہیں۔ نئے سال کی شرحیں سرکاری طور پر اعلان ہونے پر اس اسکرین سے وہ سال منتخب کر کے ویلیوز اپ ڈیٹ کریں۔ اپ ڈیٹ نہ ہونے والے سال پچھلے سال کی شرحیں استعمال کرتے رہیں گے۔',
    'ne': 'नोट: प्रत्येक वर्षको मान छुट्टै सुरक्षित गरिन्छ। नयाँ वर्षका दरहरू आधिकारिक रूपमा घोषणा भएपछि यस स्क्रिनबाट त्यो वर्ष छानी मानहरू अद्यावधिक गर्नुहोस्। अद्यावधिक नगरिएका वर्षहरूले अघिल्लो वर्षका दरहरू प्रयोग गर्न जारी राख्नेछन्।',
  },
  'leaveScreenTitle': {'tr': 'Yillik Izin Takibi', 'ur': 'سالانہ چھٹی کا ٹریکنگ', 'ne': 'वार्षिक बिदा ट्र्याकिङ'},
  'serviceDuration': {'tr': 'Hizmet suresi:', 'ur': 'ملازمت کی مدت:', 'ne': 'सेवा अवधि:'},
  'yearsSuffix': {'tr': 'yil', 'ur': 'سال', 'ne': 'वर्ष'},
  'annualLeaveRight': {'tr': 'Yillik izin hakki:', 'ur': 'سالانہ چھٹی کا حق:', 'ne': 'वार्षिक बिदा अधिकार:'},
  'usedDays': {'tr': 'Kullanilan:', 'ur': 'استعمال شدہ:', 'ne': 'प्रयोग गरिएको:'},
  'remainingDays': {'tr': 'Kalan:', 'ur': 'باقی:', 'ne': 'बाँकी:'},
  'daySuffix': {'tr': 'gun', 'ur': 'دن', 'ne': 'दिन'},
  'usedLeaveDaysTitle': {'tr': 'Kullanilan izin gunleri', 'ur': 'استعمال شدہ چھٹی کے دن', 'ne': 'प्रयोग गरिएका बिदा दिनहरू'},
  'noLeaveUsedThisYear': {'tr': 'Bu yil izin kullanilmadi', 'ur': 'اس سال چھٹی استعمال نہیں کی گئی', 'ne': 'यस वर्ष बिदा प्रयोग गरिएन'},
  'pdfExportTitle': {'tr': 'PDF e Aktar', 'ur': 'PDF میں برآمد کریں', 'ne': 'PDF मा निर्यात गर्नुहोस्'},
  'typeOvertime': {'tr': 'Fazla Mesai', 'ur': 'اضافی کام', 'ne': 'ओभरटाइम'},
  'typeAbsent': {'tr': 'Ise Gitmedim', 'ur': 'کام پر نہیں گیا', 'ne': 'काममा गइनँ'},
  'typeSick': {'tr': 'Raporlu', 'ur': 'بیماری کی چھٹی', 'ne': 'बिरामी बिदा'},
  'typePaidLeave': {'tr': 'Ucretli Izin', 'ur': 'تنخواہ دار چھٹی', 'ne': 'तलबी बिदा'},
  'typeUnpaidLeave': {'tr': 'Ucretsiz Izin', 'ur': 'بلا تنخواہ چھٹی', 'ne': 'बिना तलब बिदा'},
  'noRecordText': {'tr': 'Kayit yok', 'ur': 'کوئی ریکارڈ نہیں', 'ne': 'रेकर्ड छैन'},
  'pdfReportTitle': {'tr': 'Mesaimatik - Aylik Rapor', 'ur': 'Mesaimatik - ماہانہ رپورٹ', 'ne': 'Mesaimatik - मासिक रिपोर्ट'},
  'pdfHeaderDate': {'tr': 'Tarih', 'ur': 'تاریخ', 'ne': 'मिति'},
  'pdfHeaderStatus': {'tr': 'Durum', 'ur': 'حالت', 'ne': 'स्थिति'},
  'pdfHeaderHours': {'tr': 'Saat', 'ur': 'گھنٹے', 'ne': 'घण्टा'},
  'pdfHeaderAdvance': {'tr': 'Avans', 'ur': 'ایڈوانس', 'ne': 'पेश्की'},
  'pdfHeaderTip': {'tr': 'Bahsis', 'ur': 'انعام', 'ne': 'टिप'},
  'pdfHeaderNote': {'tr': 'Not', 'ur': 'نوٹ', 'ne': 'नोट'},
  'pdfSummaryTitle': {'tr': 'Ozet', 'ur': 'خلاصہ', 'ne': 'सारांश'},
  'pdfWeekdayOvertime': {'tr': 'Haftaici fazla mesai:', 'ur': 'ہفتہ کے دن اضافی کام:', 'ne': 'हप्ताको दिन ओभरटाइम:'},
  'pdfSaturdayOvertime': {'tr': 'Cumartesi fazla mesai:', 'ur': 'ہفتے کا اضافی کام:', 'ne': 'शनिबार ओभरटाइम:'},
  'pdfSundayOvertime': {'tr': 'Pazar fazla mesai:', 'ur': 'اتوار کا اضافی کام:', 'ne': 'आइतबार ओभरटाइम:'},
  'pdfHolidayOvertime': {'tr': 'Resmi tatil fazla mesai:', 'ur': 'سرکاری تعطیل اضافی کام:', 'ne': 'सार्वजनिक बिदा ओभरटाइम:'},
  'hoursSuffix': {'tr': 'saat', 'ur': 'گھنٹے', 'ne': 'घण्टा'},
  'pdfAdvanceTotal': {'tr': 'Avans toplami:', 'ur': 'کل ایڈوانس:', 'ne': 'कुल पेश्की:'},
  'pdfTipTotal': {'tr': 'Bahsis toplami:', 'ur': 'کل انعام:', 'ne': 'कुल टिप:'},
  'pdfNormalEarning': {'tr': 'Normal kazanc:', 'ur': 'عام آمدنی:', 'ne': 'सामान्य आम्दानी:'},
  'pdfOvertimePay': {'tr': 'Fazla mesai ucreti:', 'ur': 'اضافی کام کی اجرت:', 'ne': 'ओभरटाइम ज्याला:'},
  'pdfFinalSalary': {'tr': 'Ele gecen maas:', 'ur': 'ہاتھ میں آنے والی تنخواہ:', 'ne': 'हातमा पर्ने तलब:'},
  'pdfCreatedSnackbar': {'tr': 'PDF olusturuldu', 'ur': 'PDF بن گئی', 'ne': 'PDF बनाइयो'},
  'whichMonthQuestion': {'tr': 'Hangi ayin raporunu olusturmak istiyorsunuz?', 'ur': 'آپ کس مہینے کی رپورٹ بنانا چاہتے ہیں؟', 'ne': 'तपाईं कुन महिनाको रिपोर्ट बनाउन चाहनुहुन्छ?'},
  'generatingText': {'tr': 'Olusturuluyor...', 'ur': 'بنایا جا رہا ہے...', 'ne': 'बनाइँदैछ...'},
  'generatePdfButton': {'tr': 'PDF Olustur ve Paylas', 'ur': 'PDF بنائیں اور شیئر کریں', 'ne': 'PDF बनाउनुहोस् र साझा गर्नुहोस्'},
  'shareInfoText': {'tr': 'PDF olusturulduktan sonra telefonunuzun paylasim menusu acilacak.', 'ur': 'PDF بننے کے بعد آپ کے فون کا شیئر مینو کھلے گا۔', 'ne': 'PDF बनेपछि तपाईंको फोनको सेयर मेनु खुल्नेछ।'},
  'encryptScreenTitle': {'tr': 'Programi Sifrele', 'ur': 'پروگرام کو محفوظ بنائیں', 'ne': 'प्रोग्राम लक गर्नुहोस्'},
  'pinMinLengthError': {'tr': 'PIN en az 4 haneli olmali', 'ur': 'PIN کم از کم 4 ہندسوں کا ہونا چاہیے', 'ne': 'PIN कम्तिमा ४ अंकको हुनुपर्छ'},
  'pinMismatchError': {'tr': 'PIN ler eslesmiyor', 'ur': 'PIN میل نہیں کھاتے', 'ne': 'PIN मिलेन'},
  'pinSavedMessage': {'tr': 'PIN kaydedildi. Uygulama bir sonraki acilista PIN isteyecek.', 'ur': 'PIN محفوظ ہو گیا۔ اگلی بار ایپ کھلنے پر PIN مانگا جائے گا۔', 'ne': 'PIN सुरक्षित भयो। अर्को पटक एप खोल्दा PIN सोधिनेछ।'},
  'wrongCurrentPinError': {'tr': 'Mevcut PIN yanlis', 'ur': 'موجودہ PIN غلط ہے', 'ne': 'हालको PIN गलत छ'},
  'pinRemovedMessage': {'tr': 'PIN kaldirildi.', 'ur': 'PIN ہٹا دیا گیا۔', 'ne': 'PIN हटाइयो।'},
  'pinActiveMessage': {'tr': 'Uygulama su an PIN ile korunuyor.', 'ur': 'ایپ فی الحال PIN سے محفوظ ہے۔', 'ne': 'एप हाल PIN द्वारा सुरक्षित छ।'},
  'enterCurrentPinToRemove': {'tr': 'PIN i kaldirmak icin mevcut PIN i girin:', 'ur': 'PIN ہٹانے کے لیے موجودہ PIN درج کریں:', 'ne': 'PIN हटाउन हालको PIN प्रविष्ट गर्नुहोस्:'},
  'currentPinLabel': {'tr': 'Mevcut PIN', 'ur': 'موجودہ PIN', 'ne': 'हालको PIN'},
  'removePinButton': {'tr': 'PIN i Kaldir', 'ur': 'PIN ہٹائیں', 'ne': 'PIN हटाउनुहोस्'},
  'pinNotActiveMessage': {'tr': 'Uygulama su an PIN ile korunmuyor.', 'ur': 'ایپ فی الحال PIN سے محفوظ نہیں ہے۔', 'ne': 'एप हाल PIN द्वारा सुरक्षित छैन।'},
  'changePinTitle': {'tr': 'PIN i degistir:', 'ur': 'PIN تبدیل کریں:', 'ne': 'PIN परिवर्तन गर्नुहोस्:'},
  'newPinTitle': {'tr': 'Yeni bir PIN belirleyin (4 haneli):', 'ur': 'ایک نیا PIN مقرر کریں (4 ہندسوں کا):', 'ne': 'नयाँ PIN सेट गर्नुहोस् (४ अंकको):'},
  'newPinLabel': {'tr': 'Yeni PIN', 'ur': 'نیا PIN', 'ne': 'नयाँ PIN'},
  'confirmPinLabel': {'tr': 'Yeni PIN (tekrar)', 'ur': 'نیا PIN (دوبارہ)', 'ne': 'नयाँ PIN (फेरि)'},
  'updatePinButton': {'tr': 'PIN i Guncelle', 'ur': 'PIN اپ ڈیٹ کریں', 'ne': 'PIN अद्यावधिक गर्नुहोस्'},
  'setPinButton': {'tr': 'PIN Belirle', 'ur': 'PIN مقرر کریں', 'ne': 'PIN सेट गर्नुहोस्'},
  'aboutTitle': {'tr': 'Hakkinda', 'ur': 'کے بارے میں', 'ne': 'बारेमा'},
  'versionLabel': {'tr': 'Surum: 1.0.0', 'ur': 'ورژن: 1.0.0', 'ne': 'संस्करण: 1.0.0'},
  'aboutDescription': {
    'tr': 'Bu uygulama, calisanlarin fazla mesai saatlerini takip etmesi ve maas hesaplamalarini yapabilmesi icin gelistirilmistir.',
    'ur': 'یہ ایپ ملازمین کو اضافی کام کے اوقات ٹریک کرنے اور تنخواہ کا حساب لگانے کے لیے بنائی گئی ہے۔',
    'ne': 'यो एप कर्मचारीहरूले ओभरटाइम घण्टा ट्र्याक गर्न र तलब गणना गर्न सक्ने बनाइएको हो।',
  },
  'featuresTitle': {'tr': 'Ozellikler:', 'ur': 'خصوصیات:', 'ne': 'सुविधाहरू:'},
  'feature1': {'tr': '- Gunluk fazla mesai takibi', 'ur': '- روزانہ اضافی کام کا ٹریکنگ', 'ne': '- दैनिक ओभरटाइम ट्र्याकिङ'},
  'feature2': {'tr': '- Haftaici / Cumartesi / Pazar / Resmi tatil ayrimi', 'ur': '- ہفتہ کے دن / ہفتہ / اتوار / سرکاری تعطیل کی تفریق', 'ne': '- हप्ताको दिन / शनिबार / आइतबार / सार्वजनिक बिदा छुट्याइ'},
  'feature3': {'tr': '- Net / Brut maas hesaplama', 'ur': '- خالص / مجموعی تنخواہ کا حساب', 'ne': '- खुद / कुल तलब गणना'},
  'feature4': {'tr': '- Yillik izin takibi', 'ur': '- سالانہ چھٹی کا ٹریکنگ', 'ne': '- वार्षिक बिदा ट्र्याकिङ'},
  'feature5': {'tr': '- Yillara gore vergi ve asgari ucret ayarlari', 'ur': '- سالوں کے مطابق ٹیکس اور کم از کم اجرت کی ترتیبات', 'ne': '- वर्ष अनुसार कर र न्यूनतम ज्याला सेटिङ'},
  'aboutDisclaimer': {
    'tr': 'Not: Bu uygulamadaki hesaplamalar tahmini olup yasal bir belge niteligi tasimaz. Kesin maas bilgileriniz icin isvereninize veya bordronuza basvurunuz.',
    'ur': 'نوٹ: اس ایپ کے حسابات تخمینی ہیں اور قانونی دستاویز کی حیثیت نہیں رکھتے۔ درست تنخواہ کی معلومات کے لیے اپنے آجر یا پے سلپ سے رجوع کریں۔',
    'ne': 'नोट: यस एपका गणनाहरू अनुमानित हुन् र कानुनी कागजातको हैसियत राख्दैनन्। सटीक तलब जानकारीको लागि आफ्नो रोजगारदाता वा पेस्लिपमा सम्पर्क गर्नुहोस्।',
  },
  'developerLabel': {'tr': 'Gelistirici: Salih Oznal', 'ur': 'ڈیولپر: صالح اوزنال', 'ne': 'विकासकर्ता: सालिह ओज्नाल'},
};

String t(String key) {
  final lang = languageNotifier.value;
  final entry = _translations[key];
  if (entry == null) return key;
  return entry[lang] ?? entry['tr'] ?? key;
}

String t2(String key) => t(key);

List<String> monthNames() {
  return t('months').split(',');
}

TextDirection currentTextDirection() {
  return languageNotifier.value == 'ur' ? TextDirection.rtl : TextDirection.ltr;
}
