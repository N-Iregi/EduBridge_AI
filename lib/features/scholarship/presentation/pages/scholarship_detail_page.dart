import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../domain/entities/scholarship_entity.dart';

class ScholarshipDetailPage extends StatelessWidget {
  final ScholarshipEntity scholarship;
  const ScholarshipDetailPage({super.key, required this.scholarship});

  Future<void> _apply(BuildContext context) async {
    final uri = Uri.tryParse(scholarship.applicationUrl);
    if (uri != null && await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open application link.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scholarship Details')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(scholarship.title, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            Chip(label: Text(scholarship.category)),
            const SizedBox(height: 16),
            Text('Provider', style: Theme.of(context).textTheme.labelLarge),
            Text(scholarship.provider),
            const SizedBox(height: 16),
            Text('Amount', style: Theme.of(context).textTheme.labelLarge),
            Text(scholarship.amount),
            const SizedBox(height: 16),
            Text('Deadline', style: Theme.of(context).textTheme.labelLarge),
            Text(scholarship.deadline.toLocal().toString().split(' ')[0]),
            const SizedBox(height: 16),
            Text('Eligibility', style: Theme.of(context).textTheme.labelLarge),
            Text(scholarship.eligibilityCriteria),
            const SizedBox(height: 16),
            Text('Description', style: Theme.of(context).textTheme.labelLarge),
            Text(scholarship.description),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _apply(context),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Text('Apply Now'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}