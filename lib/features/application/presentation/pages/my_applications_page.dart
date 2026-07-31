import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/firestore_application_repository.dart';
import '../../domain/entities/application_entity.dart';
import '../cubit/my_applications_cubit.dart';

class MyApplicationsPage extends StatelessWidget {
  const MyApplicationsPage({super.key, required this.userId});

  final String userId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MyApplicationsCubit(FirestoreApplicationRepository(), userId),
      child: const _MyApplicationsView(),
    );
  }
}

class _MyApplicationsView extends StatelessWidget {
  const _MyApplicationsView();

  Future<void> _editNotes(
    BuildContext context,
    MyApplicationsCubit cubit,
    ApplicationEntity application,
  ) async {
    final controller = TextEditingController(text: application.notes);
    await showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Application Notes'),
        content: TextField(
          controller: controller,
          maxLines: 4,
          decoration: const InputDecoration(hintText: 'e.g. documents submitted, follow-up dates'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              cubit.updateNotes(application, controller.text.trim());
              Navigator.pop(dialogContext);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmCancel(
    BuildContext context,
    MyApplicationsCubit cubit,
    ApplicationEntity application,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Cancel Application'),
        content: Text('Cancel your application to "${application.scholarshipTitle}"?'),
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
      await cubit.cancel(application.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<MyApplicationsCubit>();

    return Scaffold(
      appBar: AppBar(title: const Text('My Applications')),
      body: BlocBuilder<MyApplicationsCubit, MyApplicationsState>(
        builder: (context, state) {
          if (state is MyApplicationsLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is MyApplicationsError) {
            return Center(child: Text(state.message));
          }
          final applications = (state as MyApplicationsLoaded).applications;
          if (applications.isEmpty) {
            return const Center(
              child: Text('No applications yet. Apply to a scholarship to see it here.'),
            );
          }
          return RefreshIndicator(
            onRefresh: cubit.load,
            child: ListView.builder(
              itemCount: applications.length,
              itemBuilder: (context, index) {
                final application = applications[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    title: Text(application.scholarshipTitle),
                    subtitle: Text(
                      'Status: ${application.status} • Applied '
                      '${application.appliedAt.toLocal().toString().split(' ')[0]}'
                      '${application.notes.isNotEmpty ? '\nNotes: ${application.notes}' : ''}',
                    ),
                    isThreeLine: application.notes.isNotEmpty,
                    onTap: () => _editNotes(context, cubit, application),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () => _confirmCancel(context, cubit, application),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
