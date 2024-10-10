import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formdata/blocs/TransactionBloc.dart';
import 'package:formdata/blocs/data_bloc_observer.dart';
import 'package:formdata/screens/TransactionListScreen.dart';

void main() async {
  Bloc.observer = DataReportBlocObserver();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Data Form',
      debugShowCheckedModeBanner: false,
      home: BlocProvider(
        create: (_) => TransactionBloc(),
        child: TransactionListScreen(),
      ),
    );
  }
}
