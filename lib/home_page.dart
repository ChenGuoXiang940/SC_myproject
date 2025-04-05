import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'user_provider.dart';
import 'login_page.dart';
import 'models.dart';

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
                AppLocalizations.of(context)!.welcomeMessage(username),
                style: const TextStyle(fontSize: 20, color: Colors.deepPurpleAccent),
              ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _itemC,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.itemLabel,
                      hintText: AppLocalizations.of(context)!.itemHint,
                    ),
                    validator: (value) => value == null || value.isEmpty
                        ? AppLocalizations.of(context)!.itemValidationError
                        : null,
                  ),
                  TextFormField(
                    controller: _priceC,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.priceLabel,
                      hintText: AppLocalizations.of(context)!.priceHint,
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) => double.tryParse(value ?? '') == null
                        ? AppLocalizations.of(context)!.priceValidationError 
                        : null,
                  ),
                  TextFormField(
                    controller: _numberC,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.quantityLabel, 
                      hintText: AppLocalizations.of(context)!.quantityHint,
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) => int.tryParse(value ?? '') == null
                        ? AppLocalizations.of(context)!.quantityValidationError
                        : null,
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
              child: Text(AppLocalizations.of(context)!.addToCart),
            ),
            const SizedBox(height: 20),
            if (username.isEmpty)
              ElevatedButton(
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage(username)),
                  );
                  if (result != null) {
                    userProvider.setUsername(result);
                  }
                },
                child: Text(AppLocalizations.of(context)!.goToLogin),
              ),
          ],
        ),
      ),
    );
  }

  void _addOrder() {
    final username = Provider.of<UserProvider>(context, listen: false).username;
    if (username.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.loginFirst),
        ),
      );
      return;
    }
    final String item = _itemC.text;
    final double price = double.parse(_priceC.text);
    final int number = int.parse(_numberC.text);
    Data data = Data(item, price, number, username);
    col.add(data);
    setState(() {
      _itemC.clear();
      _priceC.clear();
      _numberC.clear();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context)!.itemAddedToCart(data.item)), // Localized text
        action: SnackBarAction(
          label: AppLocalizations.of(context)!.undo, // Localized text
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