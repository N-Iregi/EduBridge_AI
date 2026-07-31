import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/deadline_cubit.dart';

class DeadlineTrackerPage extends StatelessWidget {
  const DeadlineTrackerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DeadlineCubit(),
      child: const _DeadlineTrackerView(),
    );
  }
}

class _DeadlineTrackerView extends StatelessWidget {
  const _DeadlineTrackerView();

  Future<void> _addDeadline(BuildContext context) async {
    final titleController = TextEditingController();
    DateTime? pickedDate;
    final cubit = context.read<DeadlineCubit>();

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
                cubit.addDeadline(titleController.text.trim(), pickedDate!);
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
    final deadlines = context.watch<DeadlineCubit>().state;

    return Scaffold(
      appBar: AppBar(title: const Text('Deadline Tracker')),
      body: deadlines.isEmpty
          ? const Center(child: Text('No deadlines yet. Tap + to add one.'))
          : ListView.builder(
              itemCount: deadlines.length,
              itemBuilder: (context, index) {
                final deadline = deadlines[index];
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
        onPressed: () => _addDeadline(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}