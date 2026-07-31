import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../data/repositories/firestore_deadline_repository.dart';
import '../../domain/entities/deadline_entity.dart';
import '../cubit/deadline_cubit.dart';

class DeadlineTrackerPage extends StatelessWidget {
  const DeadlineTrackerPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = context.read<AuthBloc>().state;
    final userId = authState is AuthAuthenticated ? authState.user.id : '';

    return BlocProvider(
      create: (_) => DeadlineCubit(FirestoreDeadlineRepository(), userId),
      child: const _DeadlineTrackerView(),
    );
  }
}

class _DeadlineTrackerView extends StatelessWidget {
  const _DeadlineTrackerView();

  Future<void> _showDeadlineDialog(
    BuildContext context,
    DeadlineCubit cubit, {
    DeadlineEntity? existing,
  }) async {
    final titleController = TextEditingController(text: existing?.title);
    DateTime? pickedDate = existing?.dueDate;

    await showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (dialogContext, setDialogState) => AlertDialog(
          title: Text(existing == null ? 'Add Deadline' : 'Edit Deadline'),
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
                    initialDate: pickedDate ?? DateTime.now(),
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
                if (existing == null) {
                  cubit.addDeadline(titleController.text.trim(), pickedDate!);
                } else {
                  cubit.editDeadline(
                    existing,
                    titleController.text.trim(),
                    pickedDate!,
                  );
                }
                Navigator.pop(dialogContext);
              },
              child: Text(existing == null ? 'Add' : 'Save'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    DeadlineCubit cubit,
    DeadlineEntity deadline,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Deadline'),
        content: Text('Delete "${deadline.title}"? This can\'t be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await cubit.deleteDeadline(deadline.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<DeadlineCubit>();

    return Scaffold(
      appBar: AppBar(title: const Text('Deadline Tracker')),
      body: BlocBuilder<DeadlineCubit, DeadlineState>(
        builder: (context, state) {
          if (state is DeadlineLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is DeadlineError) {
            return Center(child: Text(state.message));
          }
          final deadlines = (state as DeadlineLoaded).deadlines;
          if (deadlines.isEmpty) {
            return const Center(
              child: Text('No deadlines yet. Tap + to add one.'),
            );
          }
          return RefreshIndicator(
            onRefresh: cubit.loadDeadlines,
            child: ListView.builder(
              itemCount: deadlines.length,
              itemBuilder: (context, index) {
                final deadline = deadlines[index];
                final daysLeft =
                    deadline.dueDate.difference(DateTime.now()).inDays;
                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    title: Text(deadline.title),
                    subtitle: Text(
                      deadline.dueDate.toLocal().toString().split(' ')[0],
                    ),
                    onTap: () => _showDeadlineDialog(
                      context,
                      cubit,
                      existing: deadline,
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          daysLeft >= 0 ? '$daysLeft d left' : 'Passed',
                          style: TextStyle(
                            color: daysLeft <= 3
                                ? Colors.red
                                : Colors.grey.shade700,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline),
                          onPressed: () =>
                              _confirmDelete(context, cubit, deadline),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showDeadlineDialog(context, cubit),
        child: const Icon(Icons.add),
      ),
    );
  }
}
