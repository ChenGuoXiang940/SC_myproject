import 'package:flutter/material.dart';

void main() => runApp(const MainApp());

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  MyHomePageState createState() => MyHomePageState();
}

typedef TEC = TextEditingController;

class Data {
  String item;
  double price;
  int number;
  Data(this.item, this.price, this.number);
}

class MyHomePageState extends State<MyHomePage> {
  List<Data> col = [];
  final TEC _itemC = TEC();
  final TEC _priceC = TEC();
  final TEC _numberC = TEC();

void _allow() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        double total = 0;
        for (var cur in col) {
          total += cur.price * cur.number;
        }
        return AlertDialog(
          title: const Text('訂單明細'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: col.map((x) {
              return ListTile(
                title: Text(x.item),
                subtitle: Text('\$${x.price} x ${x.number}'),
                trailing: Text('花費: \$${x.price * x.number}'),
              );
            }).toList(),
          ),
          actions: [
            Text('總共: \$${total.toStringAsFixed(2)}'),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('關閉'),
            ),
          ],
        );
      },
    );
  }

  void _addOrder() {
    final String item = _itemC.text;
    final String priceText = _priceC.text;
    final String numberText = _numberC.text;
    if (item.isEmpty || priceText.isEmpty || numberText.isEmpty) {
      _showErrorDialog("輸入不完整");
      return;
    }
    final double? price = double.tryParse(priceText);
    final int? number = int.tryParse(numberText);
    if (price == null || number == null) {
      _showErrorDialog("輸入格式錯誤");
      return;
    }
    setState(() {
      col.add(Data(item, price, number));
      _itemC.clear();
      _priceC.clear();
      _numberC.clear();
    });
  }

  void _remove(int index) {
    setState(() {
      col.removeAt(index);
    });
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('錯誤'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('關閉'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("購物車", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            children: <Widget>[
              TextField(
                controller: _itemC,
                decoration: const InputDecoration(labelText: "商品"),
              ),
              TextField(
                controller: _priceC,
                decoration: const InputDecoration(labelText: "價格"),
              ),
              TextField(
                controller: _numberC,
                decoration: const InputDecoration(labelText: "數量"),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _addOrder,
                child: const Text('加入購物車'),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: col.length,
                  itemBuilder: (context, index) {
                    final cur = col[index];
                    return ListTile(
                      title: Text(cur.item,style: TextStyle(color: Colors.deepPurpleAccent),),
                      subtitle: Text('\$${cur.price} x ${cur.number}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('總共: ${cur.price * cur.number}'),
                          IconButton(
                            onPressed: () => _remove(index),
                            icon: const Icon(Icons.remove),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _allow,
        tooltip: 'Check',
        child: const Icon(Icons.check),
      ),
    );
  }
}