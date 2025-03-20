import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'home_page.dart';
import 'shopping_cart_page.dart';
import 'account_page.dart';
import 'about_page.dart';
import 'user_provider.dart';

void main() => runApp(
  MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => UserProvider()),
    ],
    child: const MainApp(),
  ),
);

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
  int _selectedIndex = 0;
  static const List<Widget> _pages = <Widget>[
    HomePage(),
    ShoppingCartPage(),
    AccountPage(),
    AboutPage(),
  ];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("購物平台", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '首頁',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: '購物車',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: '個人帳號',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: '關於',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.deepPurpleAccent,
        unselectedItemColor: Colors.deepPurpleAccent,
        onTap: _onItemTapped,
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