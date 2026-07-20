import '../entities/application_entity.dart';

/// Abstract definition of database operations regarding Scholarship Application entities.
abstract class ApplicationRepository {
  /// Retrieves all applications submitted by a specific user.
  Future<List<ApplicationEntity>> getApplicationsByUserId(String userId);

  /// Fetches details of a specific application by its ID.
  Future<ApplicationEntity?> getApplicationById(String id);

  /// Saves a newly submitted application to the database.
  Future<void> submitApplication(ApplicationEntity application);

  /// Updates details of an application (e.g. status changes, notes additions).
  Future<void> updateApplication(ApplicationEntity application);

  /// Deletes or cancels a scholarship application.
  Future<void> cancelApplication(String id);
}
