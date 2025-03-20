import 'package:flutter/material.dart';
import 'main.dart';
import 'package:provider/provider.dart';
import 'user_provider.dart';
class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '個人帳號內容',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed:() async {
                final userProvider = context.read<UserProvider>();
                debugPrint('Navigating to SecondPage');
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SecondPage(),
                  ),
                );
                debugPrint('Returned from SecondPage with result: $result');
                if (result != null) {
                  userProvider.setUsername(result);
                }
              },
              child: Text('切換帳戶'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // 更改密碼的邏輯
              },
              child: Text('更改密碼'),
            ),
          ],
        ),
      ),
    );
  }
}