import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/application_entity.dart';
import '../../domain/repositories/application_repository.dart';

class ApplicationStatusState {
  final ApplicationEntity? application;
  final bool isLoading;

  const ApplicationStatusState({required this.application, required this.isLoading});

  bool get hasApplied => application != null;

  ApplicationStatusState copyWith({
    ApplicationEntity? application,
    bool clearApplication = false,
    bool? isLoading,
  }) {
    return ApplicationStatusState(
      application: clearApplication ? null : (application ?? this.application),
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

/// Tracks whether the current user has already applied to [scholarshipId],
/// and records/cancels that application.
class ApplicationStatusCubit extends Cubit<ApplicationStatusState> {
  final ApplicationRepository repository;
  final String userId;
  final String scholarshipId;
  final String scholarshipTitle;

  ApplicationStatusCubit(
    this.repository,
    this.userId,
    this.scholarshipId,
    this.scholarshipTitle,
  ) : super(const ApplicationStatusState(application: null, isLoading: true)) {
    _load();
  }

  Future<void> _load() async {
    final applications = await repository.getApplicationsByUserId(userId);
    final existing = applications.where((a) => a.scholarshipId == scholarshipId);
    emit(ApplicationStatusState(
      application: existing.isEmpty ? null : existing.first,
      isLoading: false,
    ));
  }

  Future<void> apply() async {
    emit(state.copyWith(isLoading: true));
    final now = DateTime.now();
    final application = ApplicationEntity(
      id: const Uuid().v4(),
      userId: userId,
      scholarshipId: scholarshipId,
      scholarshipTitle: scholarshipTitle,
      status: 'applied',
      appliedAt: now,
      documents: const [],
      notes: '',
      createdAt: now,
      updatedAt: now,
    );
    await repository.submitApplication(application);
    emit(ApplicationStatusState(application: application, isLoading: false));
  }

  Future<void> cancel() async {
    final application = state.application;
    if (application == null) return;
    emit(state.copyWith(isLoading: true));
    await repository.cancelApplication(application.id);
    emit(const ApplicationStatusState(application: null, isLoading: false));
  }
}
