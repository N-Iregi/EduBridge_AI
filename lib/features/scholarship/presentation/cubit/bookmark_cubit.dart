import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/bookmark_entity.dart';
import '../../domain/repositories/bookmark_repository.dart';

class BookmarkState {
  final bool isBookmarked;
  final bool isLoading;

  const BookmarkState({required this.isBookmarked, required this.isLoading});

  BookmarkState copyWith({bool? isBookmarked, bool? isLoading}) {
    return BookmarkState(
      isBookmarked: isBookmarked ?? this.isBookmarked,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

/// Tracks and toggles whether [scholarshipId] is bookmarked by [userId].
class BookmarkCubit extends Cubit<BookmarkState> {
  final BookmarkRepository repository;
  final String userId;
  final String scholarshipId;

  BookmarkCubit(this.repository, this.userId, this.scholarshipId)
      : super(const BookmarkState(isBookmarked: false, isLoading: true)) {
    _load();
  }

  Future<void> _load() async {
    final isBookmarked = await repository.isBookmarked(userId, scholarshipId);
    emit(BookmarkState(isBookmarked: isBookmarked, isLoading: false));
  }

  Future<void> toggle() async {
    emit(state.copyWith(isLoading: true));
    if (state.isBookmarked) {
      await repository.removeBookmark('${userId}_$scholarshipId');
    } else {
      await repository.addBookmark(BookmarkEntity(
        id: '${userId}_$scholarshipId',
        userId: userId,
        scholarshipId: scholarshipId,
        bookmarkedAt: DateTime.now(),
      ));
    }
    emit(BookmarkState(isBookmarked: !state.isBookmarked, isLoading: false));
  }
}
