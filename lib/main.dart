import 'package:flutter/material.dart';
import 'dart:async';

void main() => runApp(const MainApp());

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  MyHomePageState createState() => MyHomePageState();
}
class ACCOUNT {
  String name;
  String password;
  ACCOUNT(this.name, this.password);
}
List<ACCOUNT> accounts = [];
class Data {
  String item;
  double price;
  int number;
  String? name;
  Data(this.item, this.price, this.number, this.name);
}
List<Data> col = [];
class MyHomePageState extends State<MyHomePage> {
  final TextEditingController _itemC = TextEditingController();
  final TextEditingController _priceC = TextEditingController();
  final TextEditingController _numberC = TextEditingController();
  String? _username;

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
          title: const Text('送出訂單'),
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
            Row(
              children: [
                TextButton(
                onPressed: () {
                  for (var data in userOrders) {
                    _remove(data);
                  }
                  Navigator.of(context).pop();
                },
                child: const Text('結帳'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('關閉'),
                ),
              ],
            )
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
    if (_username == null) {
      _showErrorDialog("請先登入");
      return;
    }
    setState(() {
      col.add(Data(item, price, number, _username));
      _itemC.clear();
      _priceC.clear();
      _numberC.clear();
    });
  }

  void _remove(Data data) {
    setState(() {
      col.remove(data);
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
              if (_username != null)
                Text('歡迎登入, $_username',
                    style: TextStyle(fontSize: 20, color: Colors.green)),
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
                  debugPrint('Navigating to SecondPage');
                  // 導航到第二頁並等待結果
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SecondPage(),
                    ),
                  );
                  debugPrint('Returned from SecondPage with result: $result');
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
                    final cur = col
                        .where((data) => data.name == _username)
                        .toList()[index];
                    return ListTile(
                      title: Text(cur.item,
                          style: TextStyle(color: Colors.deepPurpleAccent)),
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
  const SecondPage({super.key});
  @override
  SecondPageState createState() => SecondPageState();
}
class SecondPageState extends State<SecondPage> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _password = TextEditingController();
  Timer? _timer;
  bool _isLocked=false;
  String? _msg;
  int errorCount = 0;
  void displayError(String msg) {
    setState(() {
      if (++errorCount == 4) {
        _isLocked=true;
        _msg = '$msg,等待重試';
        _timer = Timer(const Duration(seconds: 5), () {
          setState(() {
            _isLocked = false;
            errorCount = 0;
            _msg = "";
          });
        });
      } else {
          _msg = '$msg, 還有 ${4 - errorCount} 次機會';
      }
    });
  }
  @override
  void dispose() {
    _timer?.cancel();
    _name.dispose();
    _password.dispose();
    super.dispose();
  }
  void _logout() {
    String? nameText = _name.text;
    String? password = _password.text;
    if (nameText.isEmpty || password.isEmpty) {
      displayError("登入失敗");
      return;
    }
    for (var it in accounts) {
      if (it.name == nameText && it.password == password) {
        setState(() {
          _msg = "";
        });
        Navigator.pop(context, nameText);
        return;
      }
    }
    displayError("帳號不存在或密碼錯誤");
  }

  void _enroll() {
    String? nameText = _name.text;
    String? password = _password.text;
    if (nameText.isEmpty || password.isEmpty) {
      displayError("註冊失敗");
      return;
    }
    for (var it in accounts) {
      if (it.name == nameText) {
        displayError("帳號已存在");
        return;
      }
    }
    accounts.add(ACCOUNT(nameText, password));
    setState(() {
      _msg = "註冊成功,請重試輸入";
      _name.clear();
      _password.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('登入', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurpleAccent,
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "資工購物平台",
                style: TextStyle(
                    color: Colors.deepPurpleAccent,
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
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
              if (!_isLocked)
                ElevatedButton(
                  onPressed: _logout,
                  style: ElevatedButton.styleFrom(
                    iconColor: Colors.deepPurpleAccent,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 15),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                  child: const Text('登入'),
                ),
              const SizedBox(height: 10),
              if (!_isLocked)
                TextButton(
                  onPressed: _enroll,
                  style: ElevatedButton.styleFrom(
                    iconColor: Colors.deepPurpleAccent,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 15),
                    textStyle: const TextStyle(fontSize: 15),
                  ),
                  child: const Text('註冊新帳號'),
                ),
              const SizedBox(height: 10),
              if(_msg!=null)
                Text(
                    _msg!,
                    style: TextStyle(
                    color: Colors.deepPurpleAccent,
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}