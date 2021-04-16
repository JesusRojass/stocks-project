import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:stocks/model/Stock.dart';

Future<Database> database;

//Create local database, this allows me to keep the data even if I close the app
Future<void> createDatabase() async {
  database = openDatabase(
    join(await getDatabasesPath(), 'stock_trading.db'),
    onCreate: (db, version) {
      return db.execute(
        "CREATE TABLE stocks(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, symbol TEXT NOT NULL, open DOUBLE NOT NULL, high DOUBLE NOT NULL, low DOUBLE NOT NULL, price DOUBLE NOT NULL, volume DOUBLE NOT NULL, lowestTradingDay TEXT NOT NULL, previousClose DOUBLE NOT NULL, change DOUBLE NOT NULL, changePercent DOUBLE NOT NULL)",
      );
    },
    version: 1,
  );
}

//insert into local database function
Future<void> insertStock(Stock stock) async {
  final Database db = await database;
  await db.insert(
    'stocks',
    stock.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

//Get local database function
Future<List<Stock>> stocks() async {
  final Database db = await database;
  final List<Map<String, dynamic>> maps = await db.query('stocks');
  return List.generate(maps.length, (i) {
    return Stock(
      symbol: maps[i]['symbol'],
      open: maps[i]['open'],
      high: maps[i]['high'],
      low: maps[i]['low'],
      price: maps[i]['price'],
      volume: maps[i]['volume'],
      lowestTradingDay: maps[i]['lowestTradingDay'],
      previousClose: maps[i]['previousClose'],
      change: maps[i]['change'],
      changePercent: maps[i]['changePercent'],
    );
  });
}

//update database stock object
Future<void> updateStock(Stock stock) async {
  final db = await database;
  await db.update(
    'stocks',
    stock.toMap(),
    where: "symbol = ?",
    whereArgs: [stock.symbol],
  );
}

//delete stock object from database function
Future<void> deleteStock(String symbol) async {
  final db = await database;
  await db.delete(
    'stocks',
    where: "symbol = ?",
    whereArgs: [symbol],
  );
}
