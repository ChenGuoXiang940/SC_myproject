import 'package:flutter/material.dart';
import 'dart:async';
import 'models.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginPage extends StatefulWidget {
  final String username;
  const LoginPage(this.username, {super.key});
  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _password = TextEditingController();
  Timer? _timer;
  bool _isLocked = false;
  String? _msg;
  int errorCount = 0;

  late AppLocalizations localizations;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    localizations = AppLocalizations.of(context)!;
  }

  void displayError(String msg) {
    setState(() {
      if (++errorCount == 4) {
        _isLocked = true;
        _msg = '$msg, ${localizations.waitRetry}';
        _timer = Timer(const Duration(seconds: 5), () {
          setState(() {
            _isLocked = false;
            errorCount = 0;
            _msg = "";
          });
        });
      } else {
        _msg = '$msg, ${localizations.remainingAttempts(4 - errorCount)}';
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
    String nameText = _name.text.trim();
    String password = _password.text.trim();
    if (nameText.isEmpty || password.isEmpty) {
      displayError(localizations.loginFailed);
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
      displayError(localizations.accountNotFound);
    }
  }

  void _enroll() {
    String nameText = _name.text.trim();
    String password = _password.text.trim();
    if (nameText.isEmpty || password.isEmpty) {
      displayError(localizations.registerFailed);
      return;
    }
    for (var it in accounts) {
      if (it.name == nameText) {
        displayError(localizations.accountExists);
        return;
      }
    }
    accounts.add(ACCOUNT(nameText, password));
    debugPrint("name:$nameText password:$password");
    setState(() {
      _msg = localizations.registerSuccess;
      _name.clear();
      _password.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.loginTitle, style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                localizations.appTitle,
                style: const TextStyle(
                    color: Colors.deepPurpleAccent,
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _name,
                decoration: InputDecoration(
                  labelText: localizations.usernameLabel,
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _password,
                decoration: InputDecoration(
                  labelText: localizations.passwordLabel,
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.lock),
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
                  child: Text(localizations.loginButton),
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
                  child: Text(localizations.registerButton),
                ),
              const SizedBox(height: 10),
              if (_msg != null)
                Text(
                  _msg!,
                  style: const TextStyle(
                    color: Colors.deepPurpleAccent,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}