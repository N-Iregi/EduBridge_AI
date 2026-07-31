import 'package:flutter/material.dart';

enum CvTemplate { classic, modern }

class CvBuilderPage extends StatefulWidget {
  const CvBuilderPage({super.key});

  @override
  State<CvBuilderPage> createState() => _CvBuilderPageState();
}

class _CvBuilderPageState extends State<CvBuilderPage> {
  CvTemplate? _selectedTemplate;
  final _nameController = TextEditingController();
  final _summaryController = TextEditingController();
  final _skillsController = TextEditingController();

  void _export() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('CV Exported'),
        content: SingleChildScrollView(
          child: Text(
            'Template: ${_selectedTemplate == CvTemplate.classic ? "Classic" : "Modern"}\n\n'
            'Name: ${_nameController.text}\n\n'
            'Summary: ${_summaryController.text}\n\n'
            'Skills: ${_skillsController.text}',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('CV Builder')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: _selectedTemplate == null
            ? _buildTemplateSelect()
            : _buildEditor(),
      ),
    );
  }

  Widget _buildTemplateSelect() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Choose a template', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => setState(() => _selectedTemplate = CvTemplate.classic),
                child: const Padding(
                  padding: EdgeInsets.all(24),
                  child: Text('Classic'),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton(
                onPressed: () => setState(() => _selectedTemplate = CvTemplate.modern),
                child: const Padding(
                  padding: EdgeInsets.all(24),
                  child: Text('Modern'),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEditor() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextButton.icon(
            onPressed: () => setState(() => _selectedTemplate = null),
            icon: const Icon(Icons.arrow_back, size: 18),
            label: const Text('Change template'),
          ),
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Full Name'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _summaryController,
            maxLines: 3,
            decoration: const InputDecoration(labelText: 'Summary'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _skillsController,
            decoration: const InputDecoration(labelText: 'Skills (comma separated)'),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _export,
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Text('Export CV'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}