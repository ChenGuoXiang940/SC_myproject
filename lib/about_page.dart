import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  Widget _buildFeatureItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Text(text, style: TextStyle(fontSize: 14)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(child: Image.asset('assets/images/flutter_logo.png')),
          const SizedBox(height: 20),
          Text(
            '版本資訊: 1.0.0',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 20),
          Text(
            '作者: ChenGuoXiang',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Text(
            '功能需求:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          _buildFeatureItem('1. 註冊與登入頁面'),
          _buildFeatureItem('2. 主畫面（商品列表）'),
          _buildFeatureItem('3. 購物車頁面'),
          _buildFeatureItem('4. 關於頁面'),
          _buildFeatureItem('5. 更多'),
          const SizedBox(height: 30),
          GestureDetector(
              onTap: () async {
                const url = 'https://github.com/ChenGuoXiang940/MyApp';
                final Uri uri = Uri.parse(url);
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                } else {
                  debugPrint('無法開啟網址: $url');
                }
              },
              child: Text(
                'GitHub Repository',
                style: TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
          )
        ],
      ),
    );
  }
}