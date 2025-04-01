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

  @override
  Widget build(BuildContext context) {
    final username = Provider.of<UserProvider>(context).username;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Column(
          children: <Widget>[
            if (username.isNotEmpty)
              Text('歡迎登入, $username',
                  style: TextStyle(fontSize: 20, color: Colors.green)),
            TextField(
              controller: _itemC,
              decoration: const InputDecoration(labelText: "商品",hintText:"商品名稱"),
            ),
            TextField(
              controller: _priceC,
              decoration: const InputDecoration(labelText: "價格",hintText:"價格數字"),
            ),
            TextField(
              controller: _numberC,
              decoration: const InputDecoration(labelText: "數量",hintText:"數量數字"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addOrder,
              child: const Text('加入購物車'),
            ),
            const SizedBox(height: 20),
            if(username.isEmpty)
              ElevatedButton(
              onPressed: () async {
                final userProvider = context.read<UserProvider>();
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginPage(),
                  ),
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
    if (username.isEmpty) {
      _showErrorDialog("請先登入");
      return;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('加入購物車'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                item,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text('\$$priceText x $number')
            ],
          ),
          actions: [
            Row(
              children: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      col.add(Data(item, price, number, username));
                      _itemC.clear();
                      _priceC.clear();
                      _numberC.clear();
                    });
                    Navigator.of(context).pop();
                  },
                  child: const Text('確認'),
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
}