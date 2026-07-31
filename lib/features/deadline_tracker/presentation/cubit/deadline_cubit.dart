import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/deadline_entity.dart';
import '../../domain/repositories/deadline_repository.dart';

abstract class DeadlineState {}

class DeadlineLoading extends DeadlineState {}

class DeadlineLoaded extends DeadlineState {
  final List<DeadlineEntity> deadlines;
  DeadlineLoaded(this.deadlines);
}

class DeadlineError extends DeadlineState {
  final String message;
  DeadlineError(this.message);
}

class DeadlineCubit extends Cubit<DeadlineState> {
  final DeadlineRepository repository;
  final String userId;

  DeadlineCubit(this.repository, this.userId) : super(DeadlineLoading()) {
    loadDeadlines();
  }

  Future<void> loadDeadlines() async {
    emit(DeadlineLoading());
    try {
      final deadlines = await repository.getDeadlines(userId);
      emit(DeadlineLoaded(deadlines));
    } catch (e) {
      emit(DeadlineError('Failed to load deadlines: $e'));
    }
  }

  Future<void> addDeadline(String title, DateTime dueDate) async {
    if (title.trim().isEmpty) return;
    await repository.createDeadline(DeadlineEntity(
      id: '',
      userId: userId,
      title: title.trim(),
      dueDate: dueDate,
      createdAt: DateTime.now(),
    ));
    await loadDeadlines();
  }

  Future<void> editDeadline(
    DeadlineEntity deadline,
    String title,
    DateTime dueDate,
  ) async {
    if (title.trim().isEmpty) return;
    await repository.updateDeadline(DeadlineEntity(
      id: deadline.id,
      userId: deadline.userId,
      title: title.trim(),
      dueDate: dueDate,
      createdAt: deadline.createdAt,
    ));
    await loadDeadlines();
  }

  Future<void> deleteDeadline(String id) async {
    await repository.deleteDeadline(id);
    await loadDeadlines();
  }
}
