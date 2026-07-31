import 'package:flutter/material.dart';

class CareerPath {
  final String title;
  final String description;
  final List<String> skills;
  const CareerPath({
    required this.title,
    required this.description,
    required this.skills,
  });
}

const _careerPaths = [
  CareerPath(
    title: 'Software Engineering',
    description:
        'Design, build, and maintain software systems and applications.',
    skills: ['Programming', 'Problem Solving', 'Version Control'],
  ),
  CareerPath(
    title: 'Data Science',
    description:
        'Analyze data to uncover insights and support decision-making.',
    skills: ['Statistics', 'Python', 'Machine Learning'],
  ),
  CareerPath(
    title: 'UX/UI Design',
    description: 'Design intuitive and accessible user experiences.',
    skills: ['Figma', 'User Research', 'Prototyping'],
  ),
];

class CareerPathwaysPage extends StatelessWidget {
  const CareerPathwaysPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Career Pathways')),
      body: ListView.builder(
        itemCount: _careerPaths.length,
        itemBuilder: (context, index) {
          final path = _careerPaths[index];
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