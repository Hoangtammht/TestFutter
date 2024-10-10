import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formdata/blocs/TransactionBloc.dart';
import 'package:formdata/event/TransactionEvent.dart';
import 'package:formdata/models/TransactionModel.dart';
import 'package:formdata/screens/TransactionFormScreen.dart';

class TransactionListScreen extends StatefulWidget {
  @override
  _TransactionListScreenState createState() => _TransactionListScreenState();
}

class _TransactionListScreenState extends State<TransactionListScreen> {
  List<TransactionModel> transactions = [
    TransactionModel(
      dateTime: DateTime.now(),
      quantity: 100,
      pump: '1',
      revenue: 5000,
      unitPrice: 3550,
    ),
    TransactionModel(
      dateTime: DateTime.now(),
      quantity: 50,
      pump: '2',
      revenue: 2000,
      unitPrice: 2550,
    ),
    TransactionModel(
      dateTime: DateTime.now(),
      quantity: 70,
      pump: '3',
      revenue: 3000,
      unitPrice: 1500,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TransactionBloc(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Danh sách giao dịch'),
        ),
        body: ListView.builder(
          itemCount: transactions.length,
          itemBuilder: (context, index) {
            final transaction = transactions[index];
            return ListTile(
              title: Text('Trụ: ${transaction.pump} - Số lượng: ${transaction.quantity} lít'),
              subtitle: Text(
                'Doanh thu: ${transaction.revenue} - Đơn giá: ${transaction.unitPrice}',
              ),
              trailing: IconButton(
                icon: Icon(Icons.edit),
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TransactionFormScreen(
                        transaction: transaction,
                      ),
                    ),
                  );
                  if (result == true) {
                    BlocProvider.of<TransactionBloc>(context).add(UpdateTransaction(transaction));
                    setState(() {}); // Cập nhật lại UI
                  }
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
