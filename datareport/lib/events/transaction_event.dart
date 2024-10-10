import 'package:equatable/equatable.dart';

abstract class TransactionEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class UploadFileEvent extends TransactionEvent {
  final String filePath;

  UploadFileEvent(this.filePath);

  @override
  List<Object> get props => [filePath];
}

class CalculateTotalEvent extends TransactionEvent {
  final DateTime startTime;
  final DateTime endTime;

  CalculateTotalEvent(this.startTime, this.endTime);

  @override
  List<Object> get props => [startTime, endTime];
}

class FileLoadingEvent extends TransactionEvent {}