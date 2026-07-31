import '../entities/deadline_entity.dart';

/// Storage-agnostic contract for reading and writing a user's deadlines.
abstract class DeadlineRepository {
  /// Retrieves all deadlines belonging to [userId], soonest due date first.
  Future<List<DeadlineEntity>> getDeadlines(String userId);

  /// Saves a newly created deadline to the database.
  Future<void> createDeadline(DeadlineEntity deadline);

  /// Updates an existing deadline (e.g. edited title or due date).
  Future<void> updateDeadline(DeadlineEntity deadline);

  /// Deletes a deadline by its id.
  Future<void> deleteDeadline(String id);
}
