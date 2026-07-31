import 'package:flutter_bloc/flutter_bloc.dart';

enum CvTemplate { classic, modern }

class CvBuilderState {
  final CvTemplate? template;
  final String name;
  final String summary;
  final String skills;

  const CvBuilderState({
    this.template,
    this.name = '',
    this.summary = '',
    this.skills = '',
  });

  CvBuilderState copyWith({
    CvTemplate? template,
    String? name,
    String? summary,
    String? skills,
  }) {
    return CvBuilderState(
      template: template ?? this.template,
      name: name ?? this.name,
      summary: summary ?? this.summary,
      skills: skills ?? this.skills,
    );
  }
}

class CvBuilderCubit extends Cubit<CvBuilderState> {
  CvBuilderCubit() : super(const CvBuilderState());

  void selectTemplate(CvTemplate template) =>
      emit(state.copyWith(template: template));

  void clearTemplate() => emit(CvBuilderState(
        name: state.name,
        summary: state.summary,
        skills: state.skills,
      ));

  void updateName(String value) => emit(state.copyWith(name: value));
  void updateSummary(String value) => emit(state.copyWith(summary: value));
  void updateSkills(String value) => emit(state.copyWith(skills: value));
}