import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stocks/controller/ConsumeStock.dart';
import 'package:stocks/controller/LocalStocks.dart';
import 'package:stocks/model/Stock.dart';

//create view class as a stateful widget
class StockList extends StatefulWidget {
  @override
  _StockListState createState() => _StockListState();
}

//initiate my view
class _StockListState extends State<StockList> {
  @override
  void initState() {
    super.initState();
    createDatabase().then((result) {
      setState(() {
        stocks();
      });
    });
  }

  //This will appear when a error is catched. eg. stock not found or not valid
  _errorPop(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Error! That is not a valid Stock Symbol',
            textAlign: TextAlign.center,
          ),
          content: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              child: Text(
                "Ok",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.red[300]),
              ),
            ),
          ),
        );
      },
    );
  }

  //This pop up shpuld appear when pressed + on the appbar
  _stockAdd(context) {
    final symController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          scrollable: true,
          title: Text(
            'New Stock Symbol',
            textAlign: TextAlign.center,
          ),
          content: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              child: Column(
                children: <Widget>[
                  TextFormField(
                    style: TextStyle(color: Colors.grey[900]),
                    decoration: InputDecoration(
                      hintText: "Symbol",
                      hintStyle: TextStyle(color: Colors.grey[900]),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(
                          color: Colors.grey[900],
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(
                          color: Colors.grey[900],
                        ),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    controller: symController,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: ElevatedButton(
                          child: Text(
                            "Cancel",
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Colors.red[300]),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: ElevatedButton(
                          child: Text(
                            "Add",
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            fetchStock(symController.text)
                                .then((StockResponse response) {
                              //Not the cutest way to handle an error, I was having some trouble catching the error sinces every single api request returned a error 200
                              if (response.stockRes.symbol != null) {
                                setState(() {
                                  insertStock(response.stockRes);
                                  stocks();
                                });
                                Navigator.pop(context);
                              } else {
                                symController.text = '';
                                _errorPop(context);
                              }
                            });
                          },
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  //build the view
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: Text("My Stocks"),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              _stockAdd(context);
            },
            icon: Icon(Icons.add_circle_outline),
          ),
        ],
      ),
      body: Container(
        child: Center(
          //Future builder because i use a local database to fecth my objects
          child: FutureBuilder<List<Stock>>(
            future: stocks(),
            builder:
                (BuildContext context, AsyncSnapshot<List<Stock>> snapshot) {
              Center child;
              if (snapshot.hasData) {
                //if no stock is found yet
                if (snapshot.data.isEmpty) {
                  child = Center(
                    child: Text(
                      'You have no Stocks.\nAdd one clicking +',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18),
                    ),
                  );
                } else {
                  return Column(
                    children: [
                      Expanded(
                        //Bild the list
                        child: ListView.separated(
                            separatorBuilder: (context, index) => Divider(
                                  color: Color.fromRGBO(0, 0, 0, 0),
                                ),
                            itemCount: snapshot.data.length,
                            itemBuilder: (BuildContext context, int index) {
                              //cells that you can swipe away
                              return Dismissible(
                                key: Key(UniqueKey().toString()),
                                onDismissed: (direction) {
                                  setState(() {
                                    deleteStock(snapshot.data[index].symbol);
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          snapshot.data[index].symbol +
                                              " dismissed"),
                                    ),
                                  );
                                },
                                background: Container(
                                  color: Colors.red,
                                  child: Container(
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          top: 20, bottom: 20, right: 20),
                                      child: Text(
                                        "Delete " + snapshot.data[index].symbol,
                                        textAlign: TextAlign.right,
                                        style: TextStyle(fontSize: 18),
                                      ),
                                    ),
                                  ),
                                ),
                                child: Container(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.all(20),
                                        child: Text(
                                          snapshot.data[index].symbol,
                                          textAlign: TextAlign.right,
                                          style: TextStyle(fontSize: 14),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: 20, bottom: 20, left: 20),
                                        child: Text(
                                          snapshot.data[index].price
                                              .toStringAsFixed(2),
                                          textAlign: TextAlign.right,
                                          style: TextStyle(fontSize: 14),
                                        ),
                                      ),
                                      Spacer(),
                                      Container(
                                          width: 20,
                                          height: 20,
                                          child: Image.asset(
                                              'assets/Up_arrow_icon_3x.png')),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: 20,
                                            bottom: 20,
                                            left: 10,
                                            right: 20),
                                        child: Text(
                                          snapshot.data[index].high
                                              .toStringAsFixed(2),
                                          textAlign: TextAlign.right,
                                          style: TextStyle(fontSize: 14),
                                        ),
                                      ),
                                      Container(
                                          width: 20,
                                          height: 20,
                                          child: Image.asset(
                                              'assets/Down_arrow_icon_3x.png')),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: 20,
                                            bottom: 20,
                                            left: 10,
                                            right: 20),
                                        child: Text(
                                          snapshot.data[index].low
                                              .toStringAsFixed(2),
                                          textAlign: TextAlign.right,
                                          style: TextStyle(fontSize: 14),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                      ),
                    ],
                  );
                }
              } else {
                //if no stock is found yet, this is a bit redundant but needed.
                child = Center(
                  child: Text(
                    'You have no Stocks.\nAdd one clicking +',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18),
                  ),
                );
              }
              return child;
            },
          ),
        ),
      ),
    );
  }
}
