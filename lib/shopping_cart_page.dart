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
  String _total="";
  double _calculateTotal(List<Data> items) {
    return items.fold(0, (sum, item) => sum + item.price * item.number);
  }
  @override
  void initState() {
    super.initState();
    _updateTotal();
  }
  void _updateTotal() {
    final username = Provider.of<UserProvider>(context, listen: false).username;
    final userCartItems = col.where((data) => data.name == username).toList();
    setState(() {
      _total = _calculateTotal(userCartItems).toStringAsFixed(2);
    });
  }
  void _remove(Data data) {
    setState(() {
      col.remove(data);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${data.item} 已從購物車刪除'),
        action: SnackBarAction(
          label: '撤銷',
          onPressed: () {
            setState(() {
              col.add(data);
            });
          },
        ),
      ),
    );
  }
  List<Widget> _buildOrderList(List<Data> userOrders) {
  return userOrders.map((x) {
    return ListTile(
      title: Text(x.item),
      subtitle: Text('\$${x.price} x ${x.number}'),
      trailing: Text('花費: \$${x.price * x.number}'),
    );
  }).toList();
}
  void _pushOrder() {
    final username = Provider.of<UserProvider>(context, listen: false).username;
    final userOrders = col.where((data) => data.name == username).toList();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('送出訂單'),
          content: SingleChildScrollView(
            child: ListBody(children:_buildOrderList(userOrders)
            ),
          ),
          actions: [
            Text('總共: \$$_total'),
            Row(
              children: [
                TextButton(
                  onPressed: () {
                    for (var data in userOrders) {
                      setState(() {
                          col.remove(data);
                      });
                    }
                    debugPrint("name:$username total:$_total");
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
  Widget _buildDivider(int index) {
    return Divider(color: index % 2 == 0 ? Colors.blue : Colors.green);
  }
  @override
  Widget build(BuildContext context) {
    final username = Provider.of<UserProvider>(context, listen: false).username;
    final userCartItems = col.where((data) => data.name == username).toList();
    return Center(
      child: Column(
        children: [
          Text(
            '購物車內容',
            style:TextStyle(fontWeight:FontWeight.bold)),
          if(userCartItems.isEmpty)
            Text('你的車是空的，請到首頁購物吧',
                  style:TextStyle(fontSize:18,color:Colors.blue)),
          Expanded(
            child: ListView.separated(
              itemCount: userCartItems.length,
              itemBuilder: (context, index) {
                final cur = userCartItems[index];
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
              separatorBuilder: (BuildContext context, int index) {
                return _buildDivider(index);
              },
            ),
          ),
          ElevatedButton(
            onPressed: userCartItems.isEmpty?null:_pushOrder,
            child: const Text('送出訂單'),
          ),
          SizedBox(height:50)
        ],
      ),
    );
  }
}