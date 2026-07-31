import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/bookmark_entity.dart';
import '../../domain/entities/scholarship_entity.dart';
import '../../domain/repositories/bookmark_repository.dart';
import '../../domain/repositories/scholarship_repository.dart';

abstract class SavedScholarshipsState {}

class SavedScholarshipsLoading extends SavedScholarshipsState {}

class SavedScholarshipsLoaded extends SavedScholarshipsState {
  final List<ScholarshipEntity> scholarships;
  SavedScholarshipsLoaded(this.scholarships);
}

class SavedScholarshipsError extends SavedScholarshipsState {
  final String message;
  SavedScholarshipsError(this.message);
}

/// Hydrates a user's [BookmarkEntity] records into the full
/// [ScholarshipEntity] each one points to, so the saved list can show
/// title/deadline/etc. without the caller juggling both collections.
class SavedScholarshipsCubit extends Cubit<SavedScholarshipsState> {
  final BookmarkRepository bookmarkRepository;
  final ScholarshipRepository scholarshipRepository;
  final String userId;

  SavedScholarshipsCubit(
    this.bookmarkRepository,
    this.scholarshipRepository,
    this.userId,
  ) : super(SavedScholarshipsLoading()) {
    load();
  }

  Future<void> load() async {
    emit(SavedScholarshipsLoading());
    try {
      final bookmarks = await bookmarkRepository.getBookmarksByUserId(userId);
      final scholarships = await Future.wait(
        bookmarks.map((b) => scholarshipRepository.getScholarshipById(b.scholarshipId)),
      );
      emit(SavedScholarshipsLoaded(scholarships.whereType<ScholarshipEntity>().toList()));
    } catch (e) {
      emit(SavedScholarshipsError('Failed to load saved scholarships: $e'));
    }
  }

  Future<void> removeBookmark(String scholarshipId) async {
    await bookmarkRepository.removeBookmark('${userId}_$scholarshipId');
    await load();
  }
}
