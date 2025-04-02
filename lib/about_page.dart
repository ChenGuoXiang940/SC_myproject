import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
class AboutPage extends StatelessWidget {
  const AboutPage({super.key});
  static const TextStyle _boldTextStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 16,
  );
  static const TextStyle _featureTextStyle = TextStyle(
    fontSize: 14,
  );
  Widget _buildFeatureItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Text(text, style: _featureTextStyle),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          Center(child: Image.asset('assets/images/flutter_logo.png')),
          const SizedBox(height: 20),
          Text('資工購物平台', style: _boldTextStyle),
          const SizedBox(height: 20),
          Text('功能需求:', style: _boldTextStyle),
          const SizedBox(height: 10),
          _buildFeatureItem('1. 註冊與登入頁面'),
          _buildFeatureItem('2. 主畫面（商品列表）'),
          _buildFeatureItem('3. 購物車頁面'),
          _buildFeatureItem('4. 關於頁面'),
          _buildFeatureItem('5. 更多'),
          const SizedBox(height: 30),
          InkWell(
            onTap: () async {
              const url = 'https://github.com/ChenGuoXiang940/MyApp';
              final Uri uri = Uri.parse(url);
              if (await canLaunchUrl(uri)&&context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('開啟網址 https://github.com/ChenGuoXiang940/MyApp')),
                );
                await launchUrl(uri, mode: LaunchMode.externalApplication);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('無法開啟網址 https://github.com/ChenGuoXiang940/MyApp')),
                );
              }
            },
            child: Text(
              'GitHub Repository',
              style: const TextStyle(
                color: Colors.blue,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }
}