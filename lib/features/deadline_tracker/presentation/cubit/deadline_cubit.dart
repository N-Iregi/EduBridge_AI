import 'package:flutter_bloc/flutter_bloc.dart';

class Deadline {
  final String title;
  final DateTime date;
  Deadline({required this.title, required this.date});
}

class DeadlineCubit extends Cubit<List<Deadline>> {
  DeadlineCubit() : super([]);

  void addDeadline(String title, DateTime date) {
    final updated = [...state, Deadline(title: title, date: date)]
      ..sort((a, b) => a.date.compareTo(b.date));
    emit(updated);
  }
}