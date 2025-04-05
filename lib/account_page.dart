import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'login_page.dart';
import 'change_password_page.dart';
import 'user_provider.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    final username = Provider.of<UserProvider>(context).username;

    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Text(
              AppLocalizations.of(context)!.accountContent, // Localized text
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final userProvider = context.read<UserProvider>();
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginPage(username),
                  ),
                );
                if (result != null && result is String && context.mounted) {
                  userProvider.setUsername(result);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(AppLocalizations.of(context)!.loginSuccess)), // Localized text
                  );
                }
              },
              child: Text(AppLocalizations.of(context)!.switchAccount), // Localized text
            ),
            SizedBox(height: 10),
            if (username.isNotEmpty)
              ElevatedButton(
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SecondPage(username),
                    ),
                  );
                  if (result != null && result is String && context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(AppLocalizations.of(context)!.passwordChangeSuccess)), // Localized text
                    );
                  }
                },
                child: Text(AppLocalizations.of(context)!.changePassword), // Localized text
              ),
          ],
        ),
      ),
    );
  }
}