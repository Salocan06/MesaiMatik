import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hakkinda')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('Mesaimatik',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            SizedBox(height: 4),
            Text('Surum: 1.0.0', style: TextStyle(color: Colors.grey)),
            SizedBox(height: 20),
            Text(
              'Bu uygulama, calisanlarin fazla mesai saatlerini takip etmesi ve maas hesaplamalarini yapabilmesi icin gelistirilmistir.',
            ),
            SizedBox(height: 16),
            Text('Ozellikler:', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('- Gunluk fazla mesai takibi'),
            Text('- Haftaici / Cumartesi / Pazar / Resmi tatil ayrimi'),
            Text('- Net / Brut maas hesaplama'),
            Text('- Yillik izin takibi'),
            Text('- Yillara gore vergi ve asgari ucret ayarlari'),
            SizedBox(height: 20),
            Text(
              'Not: Bu uygulamadaki hesaplamalar tahmini olup yasal bir belge niteligi tasimaz. Kesin maas bilgileriniz icin isvereninize veya bordronuza basvurunuz.',
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
            SizedBox(height: 20),
            Text('Gelistirici: Salih Oznal',
                style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}