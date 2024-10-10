import 'package:formdata/models/TransactionModel.dart';

abstract class TransactionEvent {}

class UpdateTransaction extends TransactionEvent {
  final TransactionModel transaction;
  UpdateTransaction(this.transaction);
}
