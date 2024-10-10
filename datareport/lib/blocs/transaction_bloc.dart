import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:datareport/events/transaction_event.dart';
import 'package:datareport/models/TransactionModel.dart';
import 'package:datareport/states/transaction_state.dart';
import 'package:excel/excel.dart';
import 'package:flutter/foundation.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  TransactionBloc() : super(TransactionInitialState()) {
    on<UploadFileEvent>(_onFileUploaded);
    on<CalculateTotalEvent>(_onTotalCalculated);
  }

  List<TransactionModel> transactions = [];

  Future<void> _onFileUploaded(
      UploadFileEvent event, Emitter<TransactionState> emit) async {
    emit(FileUploadingState());

    try {
      transactions = await compute(_parseXlsxFile, event.filePath);

      if (transactions.isEmpty) {
        emit(TransactionErrorState('No transactions found in the file.'));
      } else {
        emit(FileUploadedState(transactions));
      }
    } catch (e) {
      print('Error reading file: $e');
      emit(TransactionErrorState('Failed to read the file.'));
    }
  }


  void _onTotalCalculated(
      CalculateTotalEvent event, Emitter<TransactionState> emit) {
    final total = transactions
        .where((transaction) =>
    transaction.time.isAfter(event.startTime) &&
        transaction.time.isBefore(event.endTime))
        .fold(0.0, (sum, transaction) => sum + transaction.amount);

    emit(TotalCalculatedState(total));
  }
}

Future<List<TransactionModel>> _parseXlsxFile(String filePath) async {
  List<TransactionModel> transactions = [];

  if (!File(filePath).existsSync()) {
    return transactions;
  } else {
    try {
      var bytes = File(filePath).readAsBytesSync();
      var excel = Excel.decodeBytes(bytes);

      for (var table in excel.tables.keys) {
        for (var rowIndex = 0; rowIndex < excel.tables[table]!.rows.length; rowIndex++) {
          var row = excel.tables[table]!.rows[rowIndex];
          if (rowIndex == 0) continue;
          if (row.length >= 9) {
            String timeString = row[1]?.value?.toString() ?? '';
            var amountValue = row[8]?.value;
            double amount;
            if (amountValue is String) {
              amount = double.tryParse(amountValue.replaceAll(',', '')) ?? 0.0;
            } else if (amountValue is double) {
              amount = amountValue;
            } else if (amountValue is int) {
              amount = amountValue.toDouble();
            } else {
              print('Unexpected value in amount column: $amountValue');
              continue;
            }

            DateTime parsedTime;
            try {
              parsedTime = _parseDateString(timeString);
              print("Số tiền: $amount");
            } catch (e) {
              print('Error parsing time: $e');
              continue;
            }

            transactions.add(TransactionModel(
              time: parsedTime,
              amount: amount,
            ));
          }
        }
      }

    } catch (e) {
      print('Error reading Excel file: $e');
    }
  }

  return transactions;
}

DateTime _parseDateString(String dateString) {
  dateString = dateString.trim();

  final parts = dateString.split('/');
  if (parts.length == 3) {
    try {
      int day = int.parse(parts[0]);
      int month = int.parse(parts[1]);
      int year = int.parse(parts[2]);
      return DateTime(year, month, day);
    } catch (e) {
      throw FormatException('Invalid date format');
    }
  }

  if (dateString.contains('-')) {
    try {
      return DateTime.parse(dateString);
    } catch (e) {
      throw FormatException('Invalid date format');
    }
  }

  throw FormatException('Invalid date format');
}
