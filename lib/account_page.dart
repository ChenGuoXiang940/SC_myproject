import 'package:flutter/material.dart';
import 'main.dart';
import 'package:provider/provider.dart';
import 'user_provider.dart';
import 'dart:async';
class AccountPage extends StatelessWidget {
  const AccountPage({super.key});
  @override
  Widget build(BuildContext context) {
    final username = Provider.of<UserProvider>(context).username;
    return Scaffold(
      body: Center(
        child:Column(
          children: [
            Text(
              '個人帳號內容',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed:() async {
                final userProvider = context.read<UserProvider>();
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginPage(),
                  ),
                );
                if (result != null && result is String && context.mounted) {
                  userProvider.setUsername(result);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('登入成功')),
                  );
                }
              },
              child: Text('切換帳戶'),
            ),
            SizedBox(height: 10),
            if(username.isNotEmpty)
              ElevatedButton(
              onPressed: () async{
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SecondPage(username),
                  ),
                );
                if (result != null && result is String && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('密碼更改成功')),
                  );
                }
              },
              child: Text('更改密碼'),
            ),
          ],
        ),
      )
    );
  }
}
class LoginPage extends StatefulWidget {
  const LoginPage({super.key,username});
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
class SecondPage extends StatefulWidget{
  final String username;
  const SecondPage(this.username,{super.key});
  @override
  SecondPageState createState()=>SecondPageState();
}
class SecondPageState extends State<SecondPage>{
  final TextEditingController _phone=TextEditingController();
  final TextEditingController _password=TextEditingController();
  void _change(){
    //  模擬，不用真的發送簡訊來驗證，默認正確
    String phone=_phone.text;
    String password=_password.text;
    if(widget.username.isEmpty||phone.isEmpty||password.isEmpty){
      _showErrorDialog("無輸入");
      return;
    }
    for(int i=0;i<accounts.length;i++){
      if(accounts[i].name==widget.username){
        if(accounts[i].password==password){
          _showErrorDialog("請使用新密碼");
          return;
        }
        debugPrint("${widget.username} $phone Org: ${accounts[i].password} New: $password");
        accounts[i]=ACCOUNT(widget.username,password);
        Navigator.pop(context, widget.username);
        return;
      }
    }
    _showErrorDialog("找不到用戶名");
  }
  void _showErrorDialog(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar:AppBar(
        title: const Text("更換密碼"),
        backgroundColor: Colors.deepPurpleAccent,
        foregroundColor: Colors.white,
      ),
      body:Center(
        child:Column(
          children:[
            Text(
              "用戶名 ${widget.username}",
              style: TextStyle(fontSize: 12,fontWeight:FontWeight.bold)
            ),
            SizedBox(height:10),
            TextField(
              controller:_phone,
              decoration:InputDecoration(labelText:"電話")
            ),
            SizedBox(height:10),
            TextField(
              controller:_password,
              decoration:InputDecoration(labelText:"新密碼")
            ),
            SizedBox(height:10),
            ElevatedButton(
            onPressed:()=>_change(),
            child:const Text("確認")
            )
          ]
        )
      )
    );
  }
}