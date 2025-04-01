import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'user_provider.dart';
import 'main.dart';
import 'account_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final TextEditingController _itemC = TextEditingController();
  final TextEditingController _priceC = TextEditingController();
  final TextEditingController _numberC = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
Widget build(BuildContext context) {
  final userProvider = context.watch<UserProvider>();
  final username = userProvider.username;

  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Center(
      child: Column(
        children: <Widget>[
          if (username.isNotEmpty)
            Text(
              '歡迎登入, $username',
              style: const TextStyle(fontSize: 20, color: Colors.green),
            ),
          Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _itemC,
                  decoration: const InputDecoration(labelText: "商品", hintText: "商品名稱"),
                  validator: (value) => value == null || value.isEmpty ? "請輸入商品名稱" : null,
                ),
                TextFormField(
                  controller: _priceC,
                  decoration: const InputDecoration(labelText: "價格", hintText: "價格數字"),
                  keyboardType: TextInputType.number,
                  validator: (value) => double.tryParse(value ?? '') == null ? "請輸入有效的價格" : null,
                ),
                TextFormField(
                  controller: _numberC,
                  decoration: const InputDecoration(labelText: "數量", hintText: "數量數字"),
                  keyboardType: TextInputType.number,
                  validator: (value) => int.tryParse(value ?? '') == null ? "請輸入有效的數量" : null,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState?.validate() ?? false) {
                _addOrder();
              }
            },
            child: const Text('加入購物車'),
          ),
          const SizedBox(height: 20),
          if (username.isEmpty)
            ElevatedButton(
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
                if (result != null) {
                  userProvider.setUsername(result);
                }
              },
              child: const Text('前往登入'),
            ),
        ],
      ),
    ),
  );
}

  void _addOrder() {
    final username = Provider.of<UserProvider>(context, listen: false).username;
    final String item = _itemC.text;
    final double price = double.parse(_priceC.text);
    final int number =int.parse(_numberC.text);
    Data data=Data(item, price, number, username);
    col.add(data);
    setState((){
      _itemC.clear();
      _priceC.clear();
      _numberC.clear();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${data.item} 已加入至購物車'),
        action: SnackBarAction(
          label: '撤銷',
          onPressed: () {
            setState(() {
              col.remove(data);
            });
          },
        ),
      ),
    );
  }
}