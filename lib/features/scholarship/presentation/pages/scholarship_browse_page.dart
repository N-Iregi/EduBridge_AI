import 'package:flutter/material.dart';
import '../../data/repositories/firestore_scholarship_repository.dart';
import '../../domain/entities/scholarship_entity.dart';
import 'scholarship_detail_page.dart';

const _categories = ['undergraduate', 'postgraduate', 'STEM', 'arts', 'business'];

class ScholarshipBrowsePage extends StatefulWidget {
  const ScholarshipBrowsePage({super.key});

  @override
  State<ScholarshipBrowsePage> createState() => _ScholarshipBrowsePageState();
}

class _ScholarshipBrowsePageState extends State<ScholarshipBrowsePage> {
  final _repository = FirestoreScholarshipRepository();
  late Future<List<ScholarshipEntity>> _future;
  String? _activeCategory;

  @override
  void initState() {
    super.initState();
    _future = _repository.getScholarships();
  }

  void _loadWithFilter(String? category) {
    setState(() {
      _activeCategory = category;
      _future = category == null
          ? _repository.getScholarships()
          : _repository.getScholarshipsByCategory(category);
    });
  }

  void _openFilters() {
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Filter by category'),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                children: [
                  ChoiceChip(
                    label: const Text('All'),
                    selected: _activeCategory == null,
                    onSelected: (_) {
                      _loadWithFilter(null);
                      Navigator.pop(context);
                    },
                  ),
                  for (final c in _categories)
                    ChoiceChip(
                      label: Text(c),
                      selected: _activeCategory == c,
                      onSelected: (_) {
                        _loadWithFilter(c);
                        Navigator.pop(context);
                      },
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scholarships'),
        actions: [
          IconButton(icon: const Icon(Icons.filter_list), onPressed: _openFilters),
        ],
      ),
      body: FutureBuilder<List<ScholarshipEntity>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final scholarships = snapshot.data ?? [];
          if (scholarships.isEmpty) {
            return const Center(child: Text('No scholarships found.'));
          }
          return ListView(
            children: scholarships.map((s) {
              return Card(
                margin: const EdgeInsets.all(12),
                child: ListTile(
                  title: Text(s.title),
                  subtitle: Text('${s.category} • Deadline: ${s.deadline.toLocal().toString().split(' ')[0]}'),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => ScholarshipDetailPage(scholarship: s)),
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}