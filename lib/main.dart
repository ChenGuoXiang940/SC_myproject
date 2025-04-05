import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'home_page.dart';
import 'shopping_cart_page.dart';
import 'account_page.dart';
import 'about_page.dart';
import 'user_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() => runApp(
  MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => UserProvider()),
    ],
    child: MainApp(),
  ),
);
class MainApp extends StatefulWidget {
  const MainApp({super.key});
  @override
  MainAppState createState()=>MainAppState();
}
class MainAppState extends State<MainApp>{
  Locale _locale = const Locale('zh', 'CN'); // 默認語言（中文）
  ThemeMode _themeMode = ThemeMode.dark; // 默認主題（黑色）
  void toggleLanguage() {
    setState(() {
      _locale = _locale.languageCode == 'zh'
          ? const Locale('en', 'US')
          : const Locale('zh', 'CN'); 
    });
  }
  void _toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: _locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: ThemeData.light(), // Light Mode 主題
      darkTheme: ThemeData.dark(), // Dark Mode 主題
      themeMode: _themeMode,
      home: MyHomePage(toggleLanguage: toggleLanguage,toggleTheme: _toggleTheme),
    );
  }
}
class MyHomePage extends StatefulWidget {
  final VoidCallback toggleLanguage;
  final VoidCallback toggleTheme;
  const MyHomePage({super.key, required this.toggleLanguage, required this.toggleTheme});
  @override
  MyHomePageState createState() => MyHomePageState();
}
class MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  static const List<Widget> _pages = <Widget>[
    HomePage(),
    ShoppingCartPage(),
    AccountPage(),
    AboutPage(),
  ];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      title: const Text("購物平台", style: TextStyle(color: Colors.white)),
      backgroundColor: Colors.deepPurpleAccent,
      actions: [
        IconButton(
          icon: const Icon(Icons.language),
          onPressed: widget.toggleLanguage,
        ),
        IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: widget.toggleTheme,
        ),
      ],
    ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: const Icon(Icons.home),
          label: AppLocalizations.of(context)!.home,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.shopping_cart),
          label: AppLocalizations.of(context)!.cart,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.account_circle),
          label: AppLocalizations.of(context)!.account,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.info),
          label: AppLocalizations.of(context)!.about,
        ),
      ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.deepPurpleAccent,
        unselectedItemColor: Colors.deepPurpleAccent,
        onTap: _onItemTapped,
      ),
    );
  }
}