import 'package:datareport/blocs/transaction_bloc.dart';
import 'package:datareport/events/transaction_event.dart';
import 'package:datareport/models/TransactionModel.dart';
import 'package:datareport/states/transaction_state.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class TransactionScreen extends StatefulWidget {
  @override
  _TransactionScreenState createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  DateTime? _startTime;
  DateTime? _endTime;
  String? _filePath;
  List<TransactionModel>? _transactions;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Data Report'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        FilePickerResult? result = await FilePicker.platform.pickFiles(
                          type: FileType.custom,
                          allowedExtensions: ['xlsx'],
                          allowMultiple: false,
                        );
                        if (result != null && result.files.single.path != null) {
                          _filePath = result.files.single.path!;
                          context.read<TransactionBloc>().add(UploadFileEvent(_filePath!));
                        }
                      },
                      child: Text('Upload File'),
                    ),
                    SizedBox(height: 16),
                    _buildDatePickerRow('Start Time:', _startTime, (selectedDate) {
                      setState(() {
                        _startTime = selectedDate;
                      });
                    }),
                    SizedBox(height: 10),
                    _buildDatePickerRow('End Time:', _endTime, (selectedDate) {
                      setState(() {
                        _endTime = selectedDate;
                      });
                    }),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        if (_startTime != null && _endTime != null && _filePath != null) {
                          context.read<TransactionBloc>().add(CalculateTotalEvent(_startTime!, _endTime!));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Please select a time range and upload a file.')),
                          );
                        }
                      },
                      child: Text('Calculate Total'),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            BlocBuilder<TransactionBloc, TransactionState>(
              builder: (context, state) {
                if (state is FileUploadingState) {
                  return Center(child: CircularProgressIndicator());
                } else if (state is TotalCalculatedState) {
                  String formattedTotal = NumberFormat.currency(locale: 'vi_VN', symbol: ' VNĐ').format(state.total);
                  return Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Total: $formattedTotal',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                  );
                } else if (state is TransactionErrorState) {
                  return Text('Error: ${state.message}', style: TextStyle(color: Colors.red));
                } else if (state is FileUploadedState) {
                  _transactions = state.transactions;
                  return _buildTransactionList(_transactions!);
                }
                return Container();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDatePickerRow(String label, DateTime? date, Function(DateTime?) onChanged) {
    return Row(
      children: [
        Text(label),
        IconButton(
          icon: Icon(Icons.date_range),
          onPressed: () async {
            DateTime? selectedDate = await showDatePicker(
              context: context,
              initialDate: date ?? DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2101),
            );
            onChanged(selectedDate);
          },
        ),
        Text(date != null ? DateFormat('yyyy-MM-dd').format(date) : 'Not selected'),
      ],
    );
  }

  Widget _buildTransactionList(List<TransactionModel> transactions) {
    return Expanded(
      child: ListView.builder(
        itemCount: transactions.length,
        itemBuilder: (context, index) {
          final transaction = transactions[index];
          String formattedPrice = NumberFormat.currency(locale: 'vi_VN', symbol: ' VNĐ').format(transaction.amount);
          return Card(
            elevation: 2,
            margin: EdgeInsets.symmetric(vertical: 5),
            child: ListTile(
              title: Text('Transaction ${index + 1}'),
              subtitle: Text(
                'Time: ${DateFormat('dd-MM-yyyy').format(transaction.time)}\nAmount: ${formattedPrice}',
              ),
            ),
          );
        },
      ),
    );
  }
}
