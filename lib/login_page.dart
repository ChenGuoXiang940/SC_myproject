import 'package:flutter/material.dart';
import 'dart:async';
import 'models.dart';
class LoginPage extends StatefulWidget {
  final String username;
  const LoginPage(this.username,{super.key});
  @override
  LoginPageState createState() => LoginPageState();
}
class LoginPageState extends State<LoginPage> {
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
    try {
      accounts.firstWhere(
        (account) => account.name == nameText && account.password == password,
      );
      setState(() {
        _msg = "";
      });
      Navigator.pop(context, nameText);
    } catch (e) {
      displayError("帳號不存在或密碼錯誤");
    }
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
    debugPrint("name:$nameText password:$password");
    setState(() {
      _msg = "註冊成功,請再次登入";
      _name.clear();
      _password.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("登入", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurpleAccent,
      ),
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
