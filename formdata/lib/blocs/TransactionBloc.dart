import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formdata/event/TransactionEvent.dart';
import 'package:formdata/states/TransactionState.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  TransactionBloc() : super(TransactionInitial()) {
    on<UpdateTransaction>((event, emit) {
      final transaction = event.transaction;

      if (transaction.dateTime == null ||
          transaction.quantity == null ||
          transaction.pump == null ||
          transaction.revenue == null ||
          transaction.unitPrice == null) {
        emit(TransactionError('Please fill all fields correctly.'));
      } else {
        emit(TransactionSuccess());
      }
    });
  }
}
