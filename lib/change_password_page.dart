import 'package:flutter/material.dart';
import 'models.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SecondPage extends StatefulWidget {
  final String username;
  const SecondPage(this.username, {super.key});
  @override
  SecondPageState createState() => SecondPageState();
}

class SecondPageState extends State<SecondPage> {
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _password2 = TextEditingController();
  late AppLocalizations localizations;

  @override
  void initState() {
    super.initState();
    ACCOUNT? account = accounts.firstWhere(
      (account) => account.name == widget.username,
    );
    if (account.phone != null) {
      setState(() {
        _phone.text = account.phone!;
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    localizations = AppLocalizations.of(context)!;
  }

  void _change() {
    String phone = _phone.text.trim();
    String password = _password.text.trim();
    String password2 = _password2.text.trim();

    if (widget.username.isEmpty || phone.isEmpty || password.isEmpty || password2.isEmpty) {
      _showErrorDialog(localizations.incompleteInput);
      return;
    }
    if (phone.length != 10) {
      _showErrorDialog(localizations.invalidPhoneLength);
      return;
    }
    for (int i = 0; i < accounts.length; i++) {
      if (accounts[i].name == widget.username) {
        if (accounts[i].password == password) {
          _showErrorDialog(localizations.useNewPassword);
          setState(() {
            _password.clear();
            _password2.clear();
          });
          return;
        }
        if (password != password2) {
          _showErrorDialog(localizations.passwordMismatch);
          setState(() {
            _password2.clear();
          });
          return;
        }
        debugPrint("${widget.username} $phone Org: ${accounts[i].password} New: $password");
        accounts[i] = ACCOUNT(widget.username, password);
        accounts[i].addPhone(phone);
        Navigator.pop(context, widget.username);
        return;
      }
    }
    _showErrorDialog(localizations.userNotFound);
  }

  void _showErrorDialog(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.changePassword),
        backgroundColor: Colors.deepPurpleAccent,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          children: [
            Text(
              "${localizations.usernameLabel} ${widget.username}",
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _phone,
              decoration: InputDecoration(
                labelText: localizations.phoneLabel,
                hintText: localizations.phoneHint,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _password,
              decoration: InputDecoration(
                labelText: localizations.newPasswordLabel,
                hintText: localizations.newPasswordHint,
              ),
              obscureText: true,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _password2,
              decoration: InputDecoration(
                labelText: localizations.confirmPasswordLabel,
                hintText: localizations.confirmPasswordHint,
              ),
              obscureText: true,
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => _change(),
              child: Text(localizations.changeButton),
            ),
          ],
        ),
      ),
    );
  }
}