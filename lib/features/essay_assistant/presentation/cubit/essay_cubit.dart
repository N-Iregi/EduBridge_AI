import 'package:flutter_bloc/flutter_bloc.dart';

class EssayState {
  final String draft;
  final String? feedback;
  final List<String> savedDrafts;

  const EssayState({
    this.draft = '',
    this.feedback,
    this.savedDrafts = const [],
  });

  EssayState copyWith({
    String? draft,
    String? feedback,
    List<String>? savedDrafts,
  }) {
    return EssayState(
      draft: draft ?? this.draft,
      feedback: feedback ?? this.feedback,
      savedDrafts: savedDrafts ?? this.savedDrafts,
    );
  }
}

class EssayCubit extends Cubit<EssayState> {
  EssayCubit() : super(const EssayState());

  void updateDraft(String value) => emit(state.copyWith(draft: value));

  void requestReview() {
    if (state.draft.trim().isEmpty) return;
    // Placeholder feedback until a real AI review backend is wired in.
    emit(state.copyWith(
      feedback: 'Good start! Consider adding a specific example to strengthen '
          'your main point, and make sure your conclusion ties back to '
          'why you are a strong fit for this opportunity.',
    ));
  }

  void saveDraft() {
    if (state.draft.trim().isEmpty) return;
    emit(state.copyWith(savedDrafts: [...state.savedDrafts, state.draft.trim()]));
  }
}