import 'package:flutter/material.dart';

class Deadline {
  final String title;
  final DateTime date;
  Deadline({required this.title, required this.date});
}

class DeadlineTrackerPage extends StatefulWidget {
  const DeadlineTrackerPage({super.key});

  @override
  State<DeadlineTrackerPage> createState() => _DeadlineTrackerPageState();
}

class _DeadlineTrackerPageState extends State<DeadlineTrackerPage> {
  final List<Deadline> _deadlines = [];

  Future<void> _addDeadline() async {
    final titleController = TextEditingController();
    DateTime? pickedDate;

    await showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (dialogContext, setDialogState) => AlertDialog(
          title: const Text('Add Deadline'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              const SizedBox(height: 12),
              TextButton.icon(
                icon: const Icon(Icons.calendar_today),
                label: Text(
                  pickedDate == null
                      ? 'Pick a date'
                      : pickedDate!.toLocal().toString().split(' ')[0],
                ),
                onPressed: () async {
                  final date = await showDatePicker(
                    context: dialogContext,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );
                  if (date != null) {
                    setDialogState(() => pickedDate = date);
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (titleController.text.trim().isEmpty || pickedDate == null) {
                  return;
                }
                setState(() {
                  _deadlines.add(
                    Deadline(title: titleController.text.trim(), date: pickedDate!),
                  );
                });
                Navigator.pop(dialogContext);
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final sorted = [..._deadlines]..sort((a, b) => a.date.compareTo(b.date));

    return Scaffold(
      appBar: AppBar(title: const Text('Deadline Tracker')),
      body: sorted.isEmpty
          ? const Center(child: Text('No deadlines yet. Tap + to add one.'))
          : ListView.builder(
              itemCount: sorted.length,
              itemBuilder: (context, index) {
                final deadline = sorted[index];
                final daysLeft = deadline.date.difference(DateTime.now()).inDays;
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    title: Text(deadline.title),
                    subtitle: Text(deadline.date.toLocal().toString().split(' ')[0]),
                    trailing: Text(
                      daysLeft >= 0 ? '$daysLeft d left' : 'Passed',
                      style: TextStyle(
                        color: daysLeft <= 3 ? Colors.red : Colors.grey.shade700,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addDeadline,
        child: const Icon(Icons.add),
      ),
    );
  }
}