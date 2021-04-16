import 'package:flutter/material.dart';
import 'package:stocks/view/StockList.dart';

//RUN THE APP
void main() {
  runApp(MyApp());
}

//Declare my app class and theme data, Dark mode is cool
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.cyan,
        brightness: Brightness.dark,
      ),
      home: StockList(),
    );
  }
}
