import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/career_cubit.dart';

class CareerPathwaysPage extends StatelessWidget {
  const CareerPathwaysPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CareerCubit(),
      child: const _CareerPathwaysView(),
    );
  }
}

class _CareerPathwaysView extends StatelessWidget {
  const _CareerPathwaysView();

  @override
  Widget build(BuildContext context) {
    final paths = context.watch<CareerCubit>().state;
    return Scaffold(
      appBar: AppBar(title: const Text('Career Pathways')),
      body: ListView.builder(
        itemCount: paths.length,
        itemBuilder: (context, index) {
          final path = paths[index];
          return Card(
            margin: const EdgeInsets.all(12),
            child: ListTile(
              title: Text(path.title),
              subtitle: Text(path.description),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CareerDetailPage(path: path),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class CareerDetailPage extends StatelessWidget {
  final CareerPath path;
  const CareerDetailPage({super.key, required this.path});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(path.title)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(path.description, style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 16),
            Text('Key Skills', style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: path.skills.map((s) => Chip(label: Text(s))).toList(),
            ),
          ],
        ),
      ),
    );
  }
}