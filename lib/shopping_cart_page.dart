import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'main.dart';
import 'user_provider.dart';
class ShoppingCartPage extends StatefulWidget {
  const ShoppingCartPage({super.key});

  @override
  ShoppingCartPageState createState() => ShoppingCartPageState();
}

class ShoppingCartPageState extends State<ShoppingCartPage> {
  void _remove(Data data) {
    setState(() {
      col.remove(data);
    });
  }

  void _pushOrder() {
    final username = Provider.of<UserProvider>(context, listen: false).username;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        double total = 0;
        final userOrders = col.where((data) => data.name == username).toList();
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

  @override
  Widget build(BuildContext context) {
    final username = Provider.of<UserProvider>(context, listen: false).username;
    return Center(
      child: Column(
        children: [
          Text('購物車內容'),
          Expanded(
            child: ListView.builder(
              itemCount: col.where((data) => data.name == username).length,
              itemBuilder: (context, index) {
                final cur = col
                    .where((data) => data.name == username)
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
          ),
          ElevatedButton(
            onPressed: _pushOrder,
            child: const Text('送出訂單'),
          ),
        ],
      ),
    );
  }
}