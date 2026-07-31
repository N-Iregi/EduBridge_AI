import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/essay_cubit.dart';

class EssayAssistantPage extends StatelessWidget {
  const EssayAssistantPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => EssayCubit(),
      child: const _EssayAssistantView(),
    );
  }
}

class _EssayAssistantView extends StatelessWidget {
  const _EssayAssistantView();

  void _showSavedDrafts(BuildContext context, List<String> drafts) {
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: drafts.isEmpty
            ? const Padding(
                padding: EdgeInsets.all(24),
                child: Text('No saved drafts yet.'),
              )
            : ListView(
                shrinkWrap: true,
                children: drafts
                    .map((d) => ListTile(
                          title: Text(d, maxLines: 2, overflow: TextOverflow.ellipsis),
                        ))
                    .toList(),
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<EssayCubit>().state;
    final cubit = context.read<EssayCubit>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Essay Assistant'),
        actions: [
          IconButton(
            icon: const Icon(Icons.folder_open),
            onPressed: () => _showSavedDrafts(context, state.savedDrafts),
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
              maxLines: 8,
              onChanged: cubit.updateDraft,
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
                    onPressed: cubit.requestReview,
                    child: const Text('AI Review'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: cubit.saveDraft,
                    child: const Text('Save'),
                  ),
                ),
              ],
            ),
            if (state.feedback != null) ...[
              const SizedBox(height: 16),
              Text('Feedback', style: Theme.of(context).textTheme.labelLarge),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(state.feedback!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}