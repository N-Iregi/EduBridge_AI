import 'package:flutter/material.dart';

class EssayAssistantPage extends StatefulWidget {
  const EssayAssistantPage({super.key});

  @override
  State<EssayAssistantPage> createState() => _EssayAssistantPageState();
}

class _EssayAssistantPageState extends State<EssayAssistantPage> {
  final _draftController = TextEditingController();
  String? _feedback;
  final List<String> _savedDrafts = [];

  void _reviewDraft() {
    final text = _draftController.text.trim();
    if (text.isEmpty) return;
    setState(() {
      // Placeholder feedback until a real AI review backend is wired in.
      _feedback =
          'Good start! Consider adding a specific example to strengthen '
          'your main point, and make sure your conclusion ties back to '
          'why you are a strong fit for this opportunity.';
    });
  }

  void _saveDraft() {
    final text = _draftController.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _savedDrafts.add(text);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Draft saved.')),
    );
  }

  void _showSavedDrafts() {
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: _savedDrafts.isEmpty
            ? const Padding(
                padding: EdgeInsets.all(24),
                child: Text('No saved drafts yet.'),
              )
            : ListView(
                shrinkWrap: true,
                children: _savedDrafts
                    .map((d) => ListTile(
                          title: Text(
                            d,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ))
                    .toList(),
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Essay Assistant'),
        actions: [
          IconButton(
            icon: const Icon(Icons.folder_open),
            onPressed: _showSavedDrafts,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Your Draft', style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 8),
            TextField(
              controller: _draftController,
              maxLines: 8,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Write your essay draft here...',
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _reviewDraft,
                    child: const Text('AI Review'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: _saveDraft,
                    child: const Text('Save'),
                  ),
                ),
              ],
            ),
            if (_feedback != null) ...[
              const SizedBox(height: 16),
              Text('Feedback', style: Theme.of(context).textTheme.labelLarge),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(_feedback!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}