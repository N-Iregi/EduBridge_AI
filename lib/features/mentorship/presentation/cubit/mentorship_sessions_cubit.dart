import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../../../auth/domain/repositories/user_repository.dart';
import '../../domain/entities/mentorship_session_entity.dart';
import '../../domain/repositories/mentorship_repository.dart';

abstract class MentorshipSessionsState {}

class MentorshipSessionsLoading extends MentorshipSessionsState {}

class MentorshipSessionsLoaded extends MentorshipSessionsState {
  final List<MentorshipSessionEntity> sessions;
  final List<UserEntity> mentors;
  MentorshipSessionsLoaded(this.sessions, this.mentors);
}

class MentorshipSessionsError extends MentorshipSessionsState {
  final String message;
  MentorshipSessionsError(this.message);
}

/// Manages a student's booked mentorship sessions, plus the list of
/// mentors (users with role 'mentor') available to book with.
class MentorshipSessionsCubit extends Cubit<MentorshipSessionsState> {
  final MentorshipRepository mentorshipRepository;
  final UserRepository userRepository;
  final String studentId;

  MentorshipSessionsCubit(
    this.mentorshipRepository,
    this.userRepository,
    this.studentId,
  ) : super(MentorshipSessionsLoading()) {
    load();
  }

  Future<void> load() async {
    emit(MentorshipSessionsLoading());
    try {
      final sessions = await mentorshipRepository.getSessionsByStudentId(studentId);
      final mentors = await userRepository.getUsersByRole('mentor');
      emit(MentorshipSessionsLoaded(sessions, mentors));
    } catch (e) {
      emit(MentorshipSessionsError('Failed to load mentorship sessions: $e'));
    }
  }

  Future<void> bookSession({
    required String mentorId,
    required String topic,
    required DateTime scheduledAt,
  }) async {
    final now = DateTime.now();
    await mentorshipRepository.bookSession(MentorshipSessionEntity(
      id: '',
      studentId: studentId,
      mentorId: mentorId,
      status: 'pending',
      scheduledAt: scheduledAt,
      topic: topic,
      notes: '',
      meetingLink: '',
      createdAt: now,
      updatedAt: now,
    ));
    await load();
  }

  Future<void> editSession(
    MentorshipSessionEntity session, {
    required String topic,
    required DateTime scheduledAt,
  }) async {
    await mentorshipRepository.updateSession(MentorshipSessionEntity(
      id: session.id,
      studentId: session.studentId,
      mentorId: session.mentorId,
      status: session.status,
      scheduledAt: scheduledAt,
      topic: topic,
      notes: session.notes,
      meetingLink: session.meetingLink,
      createdAt: session.createdAt,
      updatedAt: DateTime.now(),
    ));
    await load();
  }

  Future<void> cancelSession(String id) async {
    await mentorshipRepository.cancelSession(id);
    await load();
  }
}
