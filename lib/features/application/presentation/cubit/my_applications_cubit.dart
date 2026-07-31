import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/application_entity.dart';
import '../../domain/repositories/application_repository.dart';

abstract class MyApplicationsState {}

class MyApplicationsLoading extends MyApplicationsState {}

class MyApplicationsLoaded extends MyApplicationsState {
  final List<ApplicationEntity> applications;
  MyApplicationsLoaded(this.applications);
}

class MyApplicationsError extends MyApplicationsState {
  final String message;
  MyApplicationsError(this.message);
}

class MyApplicationsCubit extends Cubit<MyApplicationsState> {
  final ApplicationRepository repository;
  final String userId;

  MyApplicationsCubit(this.repository, this.userId) : super(MyApplicationsLoading()) {
    load();
  }

  Future<void> load() async {
    emit(MyApplicationsLoading());
    try {
      final applications = await repository.getApplicationsByUserId(userId);
      emit(MyApplicationsLoaded(applications));
    } catch (e) {
      emit(MyApplicationsError('Failed to load applications: $e'));
    }
  }

  Future<void> updateNotes(ApplicationEntity application, String notes) async {
    await repository.updateApplication(ApplicationEntity(
      id: application.id,
      userId: application.userId,
      scholarshipId: application.scholarshipId,
      scholarshipTitle: application.scholarshipTitle,
      status: application.status,
      appliedAt: application.appliedAt,
      documents: application.documents,
      notes: notes,
      createdAt: application.createdAt,
      updatedAt: DateTime.now(),
    ));
    await load();
  }

  Future<void> cancel(String id) async {
    await repository.cancelApplication(id);
    await load();
  }
}
