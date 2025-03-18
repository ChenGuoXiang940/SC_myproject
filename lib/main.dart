import 'package:flutter/material.dart';

void main() => runApp(const MainApp());

/// MainApp 是應用的主入口，繼承自 StatelessWidget。
class MainApp extends StatelessWidget {
  /// 建構函式，初始化 MainApp。
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      /// 應用的標題
      title: '商店',
      /// 是否顯示除錯標籤
      debugShowCheckedModeBanner: false,
      /// 應用的主題
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      /// 應用的主頁面
      home: const MyHomePage(title: '購物車'),
    );
  }
}

/// MyHomePage 是一個 StatefulWidget，表示應用的主頁面。
class MyHomePage extends StatefulWidget {
  /// 建構函式，初始化 MyHomePage 並設置頁面標題。
  const MyHomePage({super.key, required this.title});

  /// 頁面標題
  final String title;

  /// 創建 MyHomePage 的狀態
  @override
  MyHomePageState createState() => MyHomePageState();
}

typedef TEC = TextEditingController;

/// 資料類別，用於存儲商品資訊
class Data {
  /// 商品名稱
  String item;

  /// 商品價格
  double price;

  /// 商品數量
  int number;

  /// 購買者
  String? name;

  /// 建構函式，初始化商品名稱、價格和數量
  Data(this.item, this.price, this.number,this.name);
}

class MyHomePageState extends State<MyHomePage> {
  List<Data> col = [];
  final TEC _itemC = TEC();
  final TEC _priceC = TEC();
  final TEC _numberC = TEC();
  String? _username;

  /// 顯示訂單明細的對話框
  void _allow() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        double total = 0;
        final userOrders = col.where((data) => data.name == _username).toList();
        for (var cur in userOrders) {
          total += cur.price * cur.number;
        }
        return AlertDialog(
          title: const Text('訂單明細'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: userOrders.map((x) {
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

  /// 添加訂單至購物車
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
    if(_username==null){
      _showErrorDialog("請先登入");
      return;
    }
    setState(() {
      col.add(Data(item, price, number,_username));
      _itemC.clear();
      _priceC.clear();
      _numberC.clear();
    });
  }

  /// 移除指定的 ListTile
  void _remove(Data data) {
    setState(() {
      col.remove(data);
    });
  }

  /// 顯示錯誤訊息
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
              if(_username!=null)
                Text('歡迎登入, $_username',
                style: TextStyle(fontSize: 20, color: Colors.green)
                )
              ,
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
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  // 導航到第二頁並等待結果
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SecondPage(title: "登入頁面")),
                  );
                  if (result != null) {
                    setState(() {
                      _username = result;
                    });
                  }
                },
                child: const Text('前往登入'),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: col.where((data) => data.name == _username).length,
                  itemBuilder: (context, index) {
                    final cur = col.where((data) => data.name == _username).toList()[index];
                    return ListTile(
                      title: Text(cur.item, style: TextStyle(color: Colors.deepPurpleAccent)),
                      subtitle: Text('\$${cur.price} x ${cur.number}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('總共: ${cur.price * cur.number}'),
                          IconButton(
                            onPressed: () => _remove(cur),
                            icon: const Icon(Icons.remove),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              )
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
class SecondPage extends StatefulWidget {
  const SecondPage({super.key, required this.title});
  final String title;

  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  final TEC _name = TEC();
  final TEC _password = TEC();
  String? _msg = "";

  void _logout() {
    String? name_text = _name.text;
    String? password = _password.text;

    if (name_text.isEmpty || password.isEmpty) {
      setState(() {
        _msg = "登入失敗,請重試輸入";
      });
      return;
    }
    Navigator.pop(context, _name.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('登入', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurpleAccent,
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.white, // Set the background color to white
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "資工購物平台",
                style: TextStyle(color: Colors.deepPurpleAccent, fontSize: 30, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _name,
                decoration: const InputDecoration(
                  labelText: "用戶名",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _password,
                decoration: const InputDecoration(
                  labelText: "密碼",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _logout,
                style: ElevatedButton.styleFrom(
                  iconColor: Colors.deepPurpleAccent,
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  textStyle: const TextStyle(fontSize: 18),
                ),
                child: const Text('登入'),
              ),
              const SizedBox(height: 20),
              if (_msg != null)
                Text(
                  '$_msg',
                  style: TextStyle(color: Colors.deepPurpleAccent, fontSize: 15, fontWeight: FontWeight.bold),
                ),
            ],
          ),
        ),
      ),
    );
  }
}