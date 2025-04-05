import 'package:flutter/material.dart';
import 'models.dart';
class SecondPage extends StatefulWidget{
  final String username;
  const SecondPage(this.username,{super.key});
  @override
  SecondPageState createState()=>SecondPageState();
}
class SecondPageState extends State<SecondPage>{
  final TextEditingController _phone=TextEditingController();
  final TextEditingController _password=TextEditingController();
  final TextEditingController _password2=TextEditingController();
  @override
  void initState() {
    super.initState();
    ACCOUNT? account = accounts.firstWhere(
    (account) => account.name == widget.username);
    if (account.phone != null) {
      setState((){
        _phone.text = account.phone!;
      });
    }
  }
  void _change(){
    //  模擬，不用真的發送簡訊來驗證，默認正確
    String phone=_phone.text;
    String password=_password.text;
    String password2=_password2.text;
    if(widget.username.isEmpty||phone.isEmpty||password.isEmpty||password2.isEmpty){
      _showErrorDialog("輸入不完整");
      return;
    }
    if(phone.length!=10){
      _showErrorDialog("電話長度為 10 位，例如 09xxxxxxxx");
      return;
    }
    for(int i=0;i<accounts.length;i++){
      if(accounts[i].name==widget.username){
        if(accounts[i].password==password){
          _showErrorDialog("請使用新密碼");
          setState((){
            _password.clear();
            _password2.clear();
          });
          return;
        }
        if(password!=password2){
          _showErrorDialog("確認密碼不正確");
          setState((){
            _password2.clear();
          });
          return;    
        }
        debugPrint("${widget.username} $phone Org: ${accounts[i].password} New: $password");
        accounts[i]=ACCOUNT(widget.username,password);
        accounts[i].addPhone(phone);
        Navigator.pop(context, widget.username);
        return;
      }
    }
    _showErrorDialog("無此用戶名");
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
              decoration:InputDecoration(
                labelText:"電話",
                hintText:"輸入你的電話號碼")
            ),
            SizedBox(height:10),
            TextField(  
              controller:_password,
              decoration:InputDecoration(
                labelText:"新密碼",
                hintText:"輸入與舊密碼不同"),
              obscureText:true
            ),
            SizedBox(height:10),
            TextField(  
              controller:_password2,
              decoration:InputDecoration(
                labelText:"確認密碼",
                hintText:"再次輸入新密碼"),
              obscureText:true
            ),
            SizedBox(height:10),
            ElevatedButton(
            onPressed:()=>_change(),
            child:const Text("確認變更")
            )
          ]
        )
      )
    );
  }
}