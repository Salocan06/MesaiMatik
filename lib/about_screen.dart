import 'package:flutter/material.dart';
import 'lang.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  Widget _featureRow(BuildContext context, IconData icon, String text, {bool showDivider = true}) {
    return Container(
      decoration: BoxDecoration(
        border: showDivider
            ? Border(
                bottom: BorderSide(
                    color: Theme.of(context).dividerColor.withOpacity(0.3), width: 0.5))
            : null,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
      child: Row(
        children: [
          Icon(icon, size: 15, color: Colors.indigo),
          const SizedBox(width: 10),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 13))),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(t('aboutTitle'))),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: Colors.indigo.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: const Icon(Icons.calendar_month, size: 30, color: Colors.indigo),
                  ),
                  const SizedBox(height: 12),
                  const Text('Mesaimatik',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 2),
                  Text(t('versionLabel'),
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(t('aboutDescription'),
                style: TextStyle(fontSize: 13, color: Colors.grey.shade500, height: 1.6)),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(t('featuresTitle').replaceAll(':', ''),
                  style: TextStyle(fontSize: 15, color: Colors.grey.shade500)),
            ),
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white.withOpacity(0.04)
                    : Colors.black.withOpacity(0.03),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _featureRow(context, Icons.calendar_today,
                      t('feature1').replaceFirst('- ', '')),
                  _featureRow(context, Icons.calendar_view_week,
                      t('feature2').replaceFirst('- ', '')),
                  _featureRow(context, Icons.account_balance_wallet,
                      t('feature3').replaceFirst('- ', '')),
                  _featureRow(context, Icons.beach_access,
                      t('feature4').replaceFirst('- ', '')),
                  _featureRow(context, Icons.receipt_long,
                      t('feature5').replaceFirst('- ', ''),
                      showDivider: false),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.warning_amber_rounded, size: 15, color: Colors.orange),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      t('aboutDisclaimer'),
                      style: const TextStyle(fontSize: 12, color: Colors.orange, height: 1.4),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Text(t('developerLabel'),
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
            ),
          ],
        ),
      ),
    );
  }
}
