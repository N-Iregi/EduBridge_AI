import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../application/data/repositories/firestore_application_repository.dart';
import '../../../application/presentation/cubit/application_status_cubit.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../data/repositories/firestore_bookmark_repository.dart';
import '../../domain/entities/scholarship_entity.dart';
import '../cubit/bookmark_cubit.dart';

class ScholarshipDetailPage extends StatelessWidget {
  final ScholarshipEntity scholarship;
  const ScholarshipDetailPage({super.key, required this.scholarship});

  @override
  Widget build(BuildContext context) {
    final authState = context.read<AuthBloc>().state;
    final userId = authState is AuthAuthenticated ? authState.user.id : '';

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => BookmarkCubit(
            FirestoreBookmarkRepository(),
            userId,
            scholarship.id,
          ),
        ),
        BlocProvider(
          create: (_) => ApplicationStatusCubit(
            FirestoreApplicationRepository(),
            userId,
            scholarship.id,
            scholarship.title,
          ),
        ),
      ],
      child: _ScholarshipDetailView(scholarship: scholarship),
    );
  }
}

class _ScholarshipDetailView extends StatelessWidget {
  const _ScholarshipDetailView({required this.scholarship});

  final ScholarshipEntity scholarship;

  Future<void> _apply(BuildContext context) async {
    final uri = Uri.tryParse(scholarship.applicationUrl);
    if (uri != null && await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open application link.')),
      );
    }
    if (context.mounted) {
      await context.read<ApplicationStatusCubit>().apply();
    }
  }

  Future<void> _cancelApplication(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Cancel Application'),
        content: const Text('Remove this scholarship from your applications?'),
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
    if (confirmed == true && context.mounted) {
      await context.read<ApplicationStatusCubit>().cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scholarship Details'),
        actions: [
          BlocBuilder<BookmarkCubit, BookmarkState>(
            builder: (context, state) {
              return IconButton(
                icon: Icon(state.isBookmarked ? Icons.bookmark : Icons.bookmark_border),
                onPressed: state.isLoading
                    ? null
                    : () => context.read<BookmarkCubit>().toggle(),
              );
            },
          ),
        ],
      ),
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
            BlocBuilder<ApplicationStatusCubit, ApplicationStatusState>(
              builder: (context, state) {
                if (state.hasApplied) {
                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.check_circle, color: Colors.green),
                          SizedBox(width: 8),
                          Text('Applied'),
                        ],
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: state.isLoading
                              ? null
                              : () => _cancelApplication(context),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            child: Text('Cancel Application'),
                          ),
                        ),
                      ),
                    ],
                  );
                }
                return SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: state.isLoading ? null : () => _apply(context),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Text('Apply Now'),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
