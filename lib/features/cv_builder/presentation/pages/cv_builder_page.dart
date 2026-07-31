import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/cv_builder_cubit.dart';

class CvBuilderPage extends StatelessWidget {
  const CvBuilderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CvBuilderCubit(),
      child: const _CvBuilderView(),
    );
  }
}

class _CvBuilderView extends StatelessWidget {
  const _CvBuilderView();

  void _export(BuildContext context, CvBuilderState state) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('CV Exported'),
        content: SingleChildScrollView(
          child: Text(
            'Template: ${state.template == CvTemplate.classic ? "Classic" : "Modern"}\n\n'
            'Name: ${state.name}\n\n'
            'Summary: ${state.summary}\n\n'
            'Skills: ${state.skills}',
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
    final state = context.watch<CvBuilderCubit>().state;
    final cubit = context.read<CvBuilderCubit>();

    return Scaffold(
      appBar: AppBar(title: const Text('CV Builder')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: state.template == null
            ? _buildTemplateSelect(cubit)
            : _buildEditor(context, cubit, state),
      ),
    );
  }

  Widget _buildTemplateSelect(CvBuilderCubit cubit) {
    return Builder(
      builder: (context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Choose a template', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => cubit.selectTemplate(CvTemplate.classic),
                  child: const Padding(
                    padding: EdgeInsets.all(24),
                    child: Text('Classic'),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton(
                  onPressed: () => cubit.selectTemplate(CvTemplate.modern),
                  child: const Padding(
                    padding: EdgeInsets.all(24),
                    child: Text('Modern'),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEditor(BuildContext context, CvBuilderCubit cubit, CvBuilderState state) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextButton.icon(
            onPressed: cubit.clearTemplate,
            icon: const Icon(Icons.arrow_back, size: 18),
            label: const Text('Change template'),
          ),
          TextField(
            decoration: const InputDecoration(labelText: 'Full Name'),
            onChanged: cubit.updateName,
          ),
          const SizedBox(height: 12),
          TextField(
            maxLines: 3,
            decoration: const InputDecoration(labelText: 'Summary'),
            onChanged: cubit.updateSummary,
          ),
          const SizedBox(height: 12),
          TextField(
            decoration: const InputDecoration(labelText: 'Skills (comma separated)'),
            onChanged: cubit.updateSkills,
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _export(context, state),
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