import 'package:flutter_bloc/flutter_bloc.dart';

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
    description: 'Design, build, and maintain software systems and applications.',
    skills: ['Programming', 'Problem Solving', 'Version Control'],
  ),
  CareerPath(
    title: 'Data Science',
    description: 'Analyze data to uncover insights and support decision-making.',
    skills: ['Statistics', 'Python', 'Machine Learning'],
  ),
  CareerPath(
    title: 'UX/UI Design',
    description: 'Design intuitive and accessible user experiences.',
    skills: ['Figma', 'User Research', 'Prototyping'],
  ),
];

class CareerCubit extends Cubit<List<CareerPath>> {
  CareerCubit() : super(_careerPaths);
}