import 'package:flutter/material.dart';
import 'lang.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(t('aboutTitle'))),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Mesaimatik',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(t('versionLabel'), style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 20),
            Text(t('aboutDescription')),
            const SizedBox(height: 16),
            Text(t('featuresTitle'), style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(t('feature1')),
            Text(t('feature2')),
            Text(t('feature3')),
            Text(t('feature4')),
            Text(t('feature5')),
            const SizedBox(height: 20),
            Text(
              t('aboutDisclaimer'),
              style: const TextStyle(fontSize: 13, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            Text(t('developerLabel'),
                style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
