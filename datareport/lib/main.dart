import 'package:datareport/blocs/data_bloc_observer.dart';
import 'package:datareport/blocs/transaction_bloc.dart';
import 'package:datareport/screens/data_report_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> requestPermissions() async {
  var status = await Permission.storage.status;
  if (!status.isGranted) {
    await Permission.storage.request();
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = DataReportBlocObserver();
  await requestPermissions();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Transaction Report',
      debugShowCheckedModeBanner: false,
      home: BlocProvider(
        create: (_) => TransactionBloc(),
        child: TransactionScreen(),
      ),
    );
  }
}
