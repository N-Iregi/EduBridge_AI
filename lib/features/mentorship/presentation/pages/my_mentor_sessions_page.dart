import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../auth/data/repositories/firestore_user_repository.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../../data/repositories/firestore_mentorship_repository.dart';
import '../../domain/entities/mentorship_session_entity.dart';
import '../cubit/mentorship_sessions_cubit.dart';

class MyMentorSessionsPage extends StatelessWidget {
  const MyMentorSessionsPage({super.key, required this.studentId});

  final String studentId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MentorshipSessionsCubit(
        FirestoreMentorshipRepository(),
        FirestoreUserRepository(),
        studentId,
      ),
      child: const _MyMentorSessionsView(),
    );
  }
}

class _MyMentorSessionsView extends StatelessWidget {
  const _MyMentorSessionsView();

  String _mentorName(List<UserEntity> mentors, String mentorId) {
    final match = mentors.where((m) => m.id == mentorId);
    return match.isEmpty ? 'Unknown mentor' : match.first.fullName;
  }

  Future<void> _showSessionDialog(
    BuildContext context,
    MentorshipSessionsCubit cubit,
    List<UserEntity> mentors, {
    MentorshipSessionEntity? existing,
  }) async {
    final topicController = TextEditingController(text: existing?.topic);
    String? mentorId = existing?.mentorId;
    DateTime? scheduledAt = existing?.scheduledAt;

    if (existing == null && mentors.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No mentors are registered yet.')),
      );
      return;
    }

    await showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (dialogContext, setDialogState) => AlertDialog(
          title: Text(existing == null ? 'Book Session' : 'Edit Session'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (existing == null)
                DropdownButtonFormField<String>(
                  initialValue: mentorId,
                  decoration: const InputDecoration(labelText: 'Mentor'),
                  items: mentors
                      .map((m) => DropdownMenuItem(value: m.id, child: Text(m.fullName)))
                      .toList(),
                  onChanged: (value) => setDialogState(() => mentorId = value),
                )
              else
                Text('Mentor: ${_mentorName(mentors, existing.mentorId)}'),
              const SizedBox(height: 12),
              TextField(
                controller: topicController,
                decoration: const InputDecoration(labelText: 'Topic'),
              ),
              const SizedBox(height: 12),
              TextButton.icon(
                icon: const Icon(Icons.calendar_today),
                label: Text(
                  scheduledAt == null
                      ? 'Pick date & time'
                      : scheduledAt!.toLocal().toString().split('.')[0],
                ),
                onPressed: () async {
                  final date = await showDatePicker(
                    context: dialogContext,
                    initialDate: scheduledAt ?? DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );
                  if (date == null || !dialogContext.mounted) return;
                  final time = await showTimePicker(
                    context: dialogContext,
                    initialTime: TimeOfDay.fromDateTime(scheduledAt ?? DateTime.now()),
                  );
                  if (time == null) return;
                  setDialogState(() => scheduledAt = DateTime(
                        date.year, date.month, date.day, time.hour, time.minute,
                      ));
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
                if (topicController.text.trim().isEmpty ||
                    scheduledAt == null ||
                    (existing == null && mentorId == null)) {
                  return;
                }
                if (existing == null) {
                  cubit.bookSession(
                    mentorId: mentorId!,
                    topic: topicController.text.trim(),
                    scheduledAt: scheduledAt!,
                  );
                } else {
                  cubit.editSession(
                    existing,
                    topic: topicController.text.trim(),
                    scheduledAt: scheduledAt!,
                  );
                }
                Navigator.pop(dialogContext);
              },
              child: Text(existing == null ? 'Book' : 'Save'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmCancel(
    BuildContext context,
    MentorshipSessionsCubit cubit,
    MentorshipSessionEntity session,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Cancel Session'),
        content: const Text('Cancel this mentorship session?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Yes, cancel'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await cubit.cancelSession(session.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<MentorshipSessionsCubit>();

    return Scaffold(
      appBar: AppBar(title: const Text('My Mentor Sessions')),
      body: BlocBuilder<MentorshipSessionsCubit, MentorshipSessionsState>(
        builder: (context, state) {
          if (state is MentorshipSessionsLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is MentorshipSessionsError) {
            return Center(child: Text(state.message));
          }
          final loaded = state as MentorshipSessionsLoaded;
          if (loaded.sessions.isEmpty) {
            return Center(
              child: Text(
                loaded.mentors.isEmpty
                    ? 'No mentors are registered yet, so sessions can\'t be '
                        'booked. Check back once a mentor has signed up.'
                    : 'No sessions booked yet. Tap + to request one.',
                textAlign: TextAlign.center,
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: cubit.load,
            child: ListView.builder(
              itemCount: loaded.sessions.length,
              itemBuilder: (context, index) {
                final session = loaded.sessions[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    title: Text(session.topic),
                    subtitle: Text(
                      'With ${_mentorName(loaded.mentors, session.mentorId)} • '
                      '${session.status} • '
                      '${session.scheduledAt.toLocal().toString().split('.')[0]}',
                    ),
                    onTap: () => _showSessionDialog(
                      context,
                      cubit,
                      loaded.mentors,
                      existing: session,
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () => _confirmCancel(context, cubit, session),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: BlocBuilder<MentorshipSessionsCubit, MentorshipSessionsState>(
        builder: (context, state) {
          final mentors = state is MentorshipSessionsLoaded ? state.mentors : <UserEntity>[];
          return FloatingActionButton(
            onPressed: () => _showSessionDialog(context, cubit, mentors),
            child: const Icon(Icons.add),
          );
        },
      ),
    );
  }
}
