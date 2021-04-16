//stock model
class Stock {
  final String symbol;
  final double open;
  final double high;
  final double low;
  final double price;
  final double volume;
  final String lowestTradingDay;
  final double previousClose;
  final double change;
  final String changePercent;

  Stock({
    this.symbol,
    this.open,
    this.high,
    this.low,
    this.price,
    this.volume,
    this.lowestTradingDay,
    this.previousClose,
    this.change,
    this.changePercent,
  });

  factory Stock.fromJson(Map<String, dynamic> json) {
    return Stock(
      symbol: json["01. symbol"] == null ? null : json["01. symbol"],
      open: json["02. open"] == null ? null : double.parse(json["02. open"]),
      high: json["03. high"] == null ? null : double.parse(json["03. high"]),
      low: json["04. low"] == null ? null : double.parse(json["04. low"]),
      price: json["05. price"] == null ? null : double.parse(json["05. price"]),
      volume:
          json["06. volume"] == null ? null : double.parse(json["06. volume"]),
      lowestTradingDay: json["07. latest trading day"] == null
          ? null
          : json["07. latest trading day"],
      previousClose: json["08. previous close"] == null
          ? null
          : double.parse(json["08. previous close"]),
      change:
          json["09. change"] == null ? null : double.parse(json["09. change"]),
      changePercent: json["10. change percent"] == null
          ? null
          : json["10. change percent"],
    );
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["symbol"] = symbol;
    map["open"] = open;
    map["high"] = high;
    map["low"] = low;
    map["price"] = price;
    map["volume"] = volume;
    map["lowestTradingDay"] = lowestTradingDay;
    map["previousClose"] = previousClose;
    map["change"] = change;
    map["changePercent"] = changePercent;
    return map;
  }
}

//stock response model
class StockResponse {
  final Stock stockRes;

  StockResponse({this.stockRes});

  factory StockResponse.fromJson(Map<String, dynamic> json) {
    return StockResponse(
      stockRes: json["Global Quote"] == null
          ? null
          : Stock.fromJson(json["Global Quote"]),
    );
  }
}
