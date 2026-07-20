import '../entities/scholarship_entity.dart';

/// Abstract definition of database operations regarding Scholarship entities.
abstract class ScholarshipRepository {
  /// Retrieves all scholarship listings.
  Future<List<ScholarshipEntity>> getScholarships();

  /// Fetches a specific scholarship by its ID.
  Future<ScholarshipEntity?> getScholarshipById(String id);

  /// Filters scholarship listings by category.
  Future<List<ScholarshipEntity>> getScholarshipsByCategory(String category);

  /// Saves a scholarship program listing (admin use).
  Future<void> createScholarship(ScholarshipEntity scholarship);

  /// Updates details of an existing scholarship (admin use).
  Future<void> updateScholarship(ScholarshipEntity scholarship);

  /// Deletes a scholarship from the list (admin use).
  Future<void> deleteScholarship(String id);
}
