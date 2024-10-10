import 'package:datareport/models/TransactionModel.dart';
import 'package:equatable/equatable.dart';

abstract class TransactionState extends Equatable {
  @override
  List<Object> get props => [];
}

class TransactionInitialState extends TransactionState {}

class FileUploadedState extends TransactionState {
  final List<TransactionModel> transactions;

  FileUploadedState(this.transactions);

  @override
  List<Object> get props => [transactions];
}

class TotalCalculatedState extends TransactionState {
  final double total;

  TotalCalculatedState(this.total);

  @override
  List<Object> get props => [total];
}

class TransactionErrorState extends TransactionState {
  final String message;

  TransactionErrorState(this.message);

  @override
  List<Object> get props => [message];
}

class FileUploadingState extends TransactionState {}
