import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/firestore_bookmark_repository.dart';
import '../../data/repositories/firestore_scholarship_repository.dart';
import '../cubit/saved_scholarships_cubit.dart';
import 'scholarship_detail_page.dart';

class SavedScholarshipsPage extends StatelessWidget {
  const SavedScholarshipsPage({super.key, required this.userId});

  final String userId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SavedScholarshipsCubit(
        FirestoreBookmarkRepository(),
        FirestoreScholarshipRepository(),
        userId,
      ),
      child: const _SavedScholarshipsView(),
    );
  }
}

class _SavedScholarshipsView extends StatelessWidget {
  const _SavedScholarshipsView();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SavedScholarshipsCubit>();

    return Scaffold(
      appBar: AppBar(title: const Text('Saved Scholarships')),
      body: BlocBuilder<SavedScholarshipsCubit, SavedScholarshipsState>(
        builder: (context, state) {
          if (state is SavedScholarshipsLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is SavedScholarshipsError) {
            return Center(child: Text(state.message));
          }
          final scholarships = (state as SavedScholarshipsLoaded).scholarships;
          if (scholarships.isEmpty) {
            return const Center(
              child: Text('No saved scholarships yet. Tap the bookmark icon '
                  'on a scholarship to save it here.'),
            );
          }
          return RefreshIndicator(
            onRefresh: cubit.load,
            child: ListView.builder(
              itemCount: scholarships.length,
              itemBuilder: (context, index) {
                final scholarship = scholarships[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    title: Text(scholarship.title),
                    subtitle: Text(
                      '${scholarship.category} • Deadline: '
                      '${scholarship.deadline.toLocal().toString().split(' ')[0]}',
                    ),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ScholarshipDetailPage(scholarship: scholarship),
                      ),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.bookmark_remove),
                      onPressed: () => cubit.removeBookmark(scholarship.id),
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
