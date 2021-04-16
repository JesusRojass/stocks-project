import 'package:http/http.dart' as http;
import 'package:stocks/api/Constants.dart';
import 'dart:async';
import 'dart:convert';
import 'package:stocks/model/Stock.dart';

Future<StockResponse> fetchStock(String sym) async {
  //init consume of api
  final http.Response response = await http.get(
    Uri.parse(
        Constants.dataUrl + "&symbol=" + sym + "&apikey=" + Constants.apiKey),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );

  if (response.statusCode == 200) {
    //parse response, why is even a error a code 200?
    return StockResponse.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load the stock');
  }
}
